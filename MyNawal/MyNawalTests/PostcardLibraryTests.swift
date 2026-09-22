import XCTest
import UIKit
@testable import MyNawal

@MainActor
final class PostcardLibraryTests: XCTestCase {
    private func temporaryDirectory() throws -> URL {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        addTeardownBlock { try FileManager.default.removeItem(at: url) }
        return url
    }

    private func fixture() throws -> (NawalPostcardDraft, PostcardAppearance, Data) {
        let draft = NawalPostcardDraft(
            result: NawalCalculationResult(nawal: NawalCatalogo.items[3], energia: 11),
            birthDateText: "10 de diciembre de 1954"
        )
        var appearance = PostcardAppearance(design: .woven, thickness: .bold)
        appearance.apply(.clay)
        appearance.photo = PostcardPhotoSettings(zoom: 2.2, x: 0.3, y: -0.4, shape: .oval, finish: .warm)
        appearance.text = PostcardTextSettings(
            personName: "Alan", message: "Mi postal", typography: .classic,
            showsDate: false, showsAnimal: true, showsElement: false, showsEnergyAssociations: true
        )
        let image = try XCTUnwrap(UIImage(named: "SelfieDemo"))
        return (draft, appearance, try XCTUnwrap(image.pngData()))
    }

    func testReopeningPreservesDraftSettingsImagesAndThumbnail() async throws {
        let directory = try temporaryDirectory()
        let store = try PostcardLibraryStore(directory: directory)
        let (draft, appearance, image) = try fixture()
        let saved = try await store.save(draft: draft, appearance: appearance, selfieData: image, renderedPNG: image)
        let reopened = try PostcardLibraryStore(directory: directory)
        let loaded = try await reopened.load(id: saved.id)
        XCTAssertEqual(loaded, saved)
        XCTAssertEqual(loaded.draft, draft)
        XCTAssertEqual(loaded.appearance, appearance)
        let selfie = try await reopened.imageData(id: saved.id, asset: .selfie)
        let rendered = try await reopened.imageData(id: saved.id, asset: .rendered)
        XCTAssertEqual(selfie, image)
        XCTAssertEqual(rendered, image)
        let thumbnailData = try await reopened.imageData(id: saved.id, asset: .thumbnail)
        let thumbnail = try XCTUnwrap(UIImage(data: thumbnailData))
        XCTAssertLessThanOrEqual(max(thumbnail.size.width, thumbnail.size.height), 360)
        let listed = try await reopened.list()
        XCTAssertEqual(listed, [saved])
    }

    func testDuplicateDoesNotOverwriteAndDeletionIsScoped() async throws {
        let directory = try temporaryDirectory()
        let store = try PostcardLibraryStore(directory: directory)
        let (draft, appearance, image) = try fixture()
        let first = try await store.save(draft: draft, appearance: appearance, selfieData: image, renderedPNG: image)
        let second = try await store.save(draft: draft, appearance: appearance, selfieData: image, renderedPNG: image)
        do {
            _ = try await store.save(id: first.id, draft: draft, appearance: PostcardAppearance(), selfieData: image, renderedPNG: image)
            XCTFail("A retry must not replace an existing postcard")
        } catch {
            XCTAssertEqual(error as? PostcardLibraryError, .alreadyExists)
        }
        let original = try await store.load(id: first.id)
        XCTAssertEqual(original, first)
        let listed = try await store.list()
        XCTAssertEqual(listed.map(\.id), [second.id, first.id])
        try await store.delete(id: first.id)
        try await store.delete(id: first.id)
        XCTAssertFalse(FileManager.default.fileExists(atPath: directory.appendingPathComponent(first.id.uuidString).path))
        let remaining = try await store.list()
        XCTAssertEqual(remaining, [second])
        let retainedImage = try await store.imageData(id: second.id, asset: .selfie)
        XCTAssertEqual(retainedImage, image)
    }

    func testInvalidImageDoesNotPublishPartialRecord() async throws {
        let store = try PostcardLibraryStore(directory: temporaryDirectory())
        let (draft, appearance, image) = try fixture()
        do {
            _ = try await store.save(draft: draft, appearance: appearance, selfieData: Data(), renderedPNG: image)
            XCTFail("Invalid image must fail")
        } catch {
            XCTAssertEqual(error as? PostcardLibraryError, .invalidImage)
        }
        let listed = try await store.list()
        XCTAssertTrue(listed.isEmpty)
    }

    func testUnsupportedVersionIsReportedAndPreserved() async throws {
        let directory = try temporaryDirectory()
        let store = try PostcardLibraryStore(directory: directory)
        let (draft, appearance, image) = try fixture()
        let saved = try await store.save(draft: draft, appearance: appearance, selfieData: image, renderedPNG: image)
        let metadataURL = directory.appendingPathComponent(saved.id.uuidString).appendingPathComponent("metadata.json")
        let future = Data("{\"schemaVersion\":999}".utf8)
        try future.write(to: metadataURL)
        do {
            _ = try await store.load(id: saved.id)
            XCTFail("Future schemas must not be silently interpreted")
        } catch {
            XCTAssertEqual(error as? PostcardLibraryError, .unsupportedVersion(999))
        }
        XCTAssertEqual(try Data(contentsOf: metadataURL), future)
    }
}
