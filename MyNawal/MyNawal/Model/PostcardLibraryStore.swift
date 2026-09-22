import Foundation
import ImageIO

/// Use one shared instance. Disk work and thumbnail decoding run outside the main actor.
/// Each committed directory contains metadata plus separate images. Hidden staging
/// directories are never listed, so an interrupted save cannot publish a partial record.
actor PostcardLibraryStore {
    private let rootURL: URL
    private let fileManager = FileManager.default

    init(directory: URL? = nil) throws {
        if let directory {
            rootURL = directory
        } else {
            rootURL = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("MyPostcards", isDirectory: true)
        }
    }

    /// A caller can keep the same ID while retrying a save to prevent duplicates.
    /// Existing records are deliberately never overwritten by this operation.
    func save(
        id: UUID = UUID(),
        draft: NawalPostcardDraft,
        appearance: PostcardAppearance,
        selfieData: Data,
        renderedPNG: Data
    ) throws -> SavedPostcard {
        guard (1...13).contains(draft.result.energia) else {
            throw PostcardLibraryError.invalidRecord
        }
        guard let selfie = CGImageSourceCreateWithData(selfieData as CFData, nil),
              CGImageSourceGetCount(selfie) > 0,
              CGImageSourceCreateThumbnailAtIndex(selfie, 0, [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceThumbnailMaxPixelSize: 1
              ] as CFDictionary) != nil,
              let rendered = CGImageSourceCreateWithData(renderedPNG as CFData, nil),
              CGImageSourceGetType(rendered) as String? == "public.png" else {
            throw PostcardLibraryError.invalidImage
        }
        let thumbnail = try makeThumbnail(from: rendered)
        try fileManager.createDirectory(at: rootURL, withIntermediateDirectories: true)
        let destination = folder(for: id)
        guard !fileManager.fileExists(atPath: destination.path) else {
            throw PostcardLibraryError.alreadyExists
        }
        let record = SavedPostcard(
            schemaVersion: 1, id: id, createdAt: Date(),
            draft: draft, appearance: appearance
        )
        let metadata = try JSONEncoder().encode(record)
        let staging = rootURL.appendingPathComponent(".staging-" + UUID().uuidString, isDirectory: true)
        try fileManager.createDirectory(at: staging, withIntermediateDirectories: false)
        defer { try? fileManager.removeItem(at: staging) }
        try metadata.write(to: staging.appendingPathComponent("metadata.json"), options: .atomic)
        try selfieData.write(to: staging.appendingPathComponent(PostcardAsset.selfie.rawValue), options: .atomic)
        try renderedPNG.write(to: staging.appendingPathComponent(PostcardAsset.rendered.rawValue), options: .atomic)
        try thumbnail.write(to: staging.appendingPathComponent(PostcardAsset.thumbnail.rawValue), options: .atomic)
        try fileManager.moveItem(at: staging, to: destination)
        return record
    }

    /// Only reads metadata, never the full-resolution photos.
    func list() throws -> [SavedPostcard] {
        guard fileManager.fileExists(atPath: rootURL.path) else { return [] }
        let directories = try fileManager.contentsOfDirectory(
            at: rootURL, includingPropertiesForKeys: [.isDirectoryKey],
            options: .skipsHiddenFiles
        )
        var records: [SavedPostcard] = []
        for directory in directories {
            guard let id = UUID(uuidString: directory.lastPathComponent),
                  try directory.resourceValues(forKeys: [.isDirectoryKey]).isDirectory == true else { continue }
            records.append(try load(id: id))
        }
        return records.sorted {
            $0.createdAt == $1.createdAt
                ? $0.id.uuidString < $1.id.uuidString
                : $0.createdAt > $1.createdAt
        }
    }

    func load(id: UUID) throws -> SavedPostcard {
        let data = try Data(contentsOf: folder(for: id).appendingPathComponent("metadata.json"))
        let decoder = JSONDecoder()
        // Decode the version first so a future schema is reported without rewriting it.
        let header = try decoder.decode(VersionHeader.self, from: data)
        guard header.schemaVersion == 1 else {
            throw PostcardLibraryError.unsupportedVersion(header.schemaVersion)
        }
        let record = try decoder.decode(SavedPostcard.self, from: data)
        guard record.id == id, (1...13).contains(record.draft.result.energia) else {
            throw PostcardLibraryError.invalidRecord
        }
        return record
    }

    func imageData(id: UUID, asset: PostcardAsset) throws -> Data {
        try Data(contentsOf: folder(for: id).appendingPathComponent(asset.rawValue))
    }

    /// Removes only this record and its images; exports in Photos are independent.
    func delete(id: UUID) throws {
        let directory = folder(for: id)
        guard fileManager.fileExists(atPath: directory.path) else { return }
        try fileManager.removeItem(at: directory)
    }

    private func folder(for id: UUID) -> URL {
        rootURL.appendingPathComponent(id.uuidString, isDirectory: true)
    }

    private func makeThumbnail(from source: CGImageSource) throws -> Data {
        guard let image = CGImageSourceCreateThumbnailAtIndex(source, 0, [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: 360
        ] as CFDictionary) else { throw PostcardLibraryError.invalidImage }
        let output = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(output, "public.png" as CFString, 1, nil) else {
            throw PostcardLibraryError.invalidImage
        }
        CGImageDestinationAddImage(destination, image, nil)
        guard CGImageDestinationFinalize(destination) else { throw PostcardLibraryError.invalidImage }
        return output as Data
    }

    private struct VersionHeader: Decodable {
        let schemaVersion: Int
    }
}
