import XCTest
import UIKit
import SwiftUI
@testable import MyNawal

@MainActor
final class PostcardLibraryTests: XCTestCase {
    func testPortraitAndMirroredSelfiesKeepTheirAppearanceAfterEncoding() throws {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let original = UIGraphicsImageRenderer(size: CGSize(width: 60, height: 90), format: format).image { context in
            UIColor.blue.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 60, height: 90))
            UIColor.red.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 25, height: 40))
        }
        let cgImage = try XCTUnwrap(original.cgImage)
        let (draft, appearance, _) = try fixture()
        for orientation: UIImage.Orientation in [.up, .down, .left, .right, .upMirrored, .downMirrored, .leftMirrored, .rightMirrored] {
            let input = UIImage(cgImage: cgImage, scale: 1, orientation: orientation)
            let encoded = try XCTUnwrap(PostcardPhotoEncoding.pngData(input))
            let restored = try XCTUnwrap(UIImage(data: encoded))
            XCTAssertEqual(restored.imageOrientation, .up)
            XCTAssertEqual(restored.size, input.size)
            let before = try PostcardExportService.render(draft: draft, selfieImage: input, appearance: appearance)
            let after = try PostcardExportService.render(draft: draft, selfieImage: restored, appearance: appearance)
            XCTAssertEqual(before.pngData, after.pngData, "Changed orientation: \(orientation.rawValue)")
        }
    }

    func testOlderMetadataAndInterruptedSaveRemainReadable() async throws {
        let directory = try temporaryDirectory()
        let store = try PostcardLibraryStore(directory: directory)
        let (draft, appearance, image) = try fixture()
        let saved = try await store.save(draft: draft, appearance: appearance, selfieData: image, renderedPNG: image)
        let metadata = directory.appendingPathComponent(saved.id.uuidString).appendingPathComponent("metadata.json")
        var legacy = try XCTUnwrap(JSONSerialization.jsonObject(with: Data(contentsOf: metadata)) as? [String: Any])
        legacy.removeValue(forKey: "updatedAt")
        try JSONSerialization.data(withJSONObject: legacy).write(to: metadata)
        let partial = directory.appendingPathComponent(".staging-interrupted")
        try FileManager.default.createDirectory(at: partial, withIntermediateDirectories: true)
        try Data("partial".utf8).write(to: partial.appendingPathComponent("metadata.json"))
        let reopened = try PostcardLibraryStore(directory: directory)
        let listed = try await reopened.list()
        XCTAssertEqual(listed, [saved])
    }

    func testGalleryListsMetadataWithoutLoadingOriginalPhotos() async throws {
        let directory = try temporaryDirectory()
        let store = try PostcardLibraryStore(directory: directory)
        let (draft, appearance, _) = try fixture()
        let image = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 50)).pngData { context in
            UIColor.green.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 40, height: 50))
        }
        var saved: [SavedPostcard] = []
        for _ in 0..<12 {
            saved.append(try await store.save(draft: draft, appearance: appearance, selfieData: image, renderedPNG: image))
        }
        // Originals are deliberately absent in this isolated fixture. Listing must
        // still work because a grid only needs metadata and small thumbnails.
        for record in saved {
            try FileManager.default.removeItem(at: directory.appendingPathComponent(record.id.uuidString).appendingPathComponent(PostcardAsset.selfie.rawValue))
        }
        let reopened = try PostcardLibraryStore(directory: directory)
        let listed = try await reopened.list()
        XCTAssertEqual(listed.map(\.id), saved.reversed().map(\.id))
    }

    func testGalleryLayoutSnapshots() async throws {
        let store = try PostcardLibraryStore(directory: temporaryDirectory())
        let (draft, appearance, image) = try fixture()
        for index in 0..<2 {
            var style = appearance
            style.design = index == 0 ? .classic : .woven
            let selfie = try XCTUnwrap(UIImage(data: image))
            let rendered = try PostcardExportService.render(draft: draft, selfieImage: selfie, appearance: style)
            _ = try await store.save(draft: draft, appearance: style, selfieData: image, renderedPNG: rendered.pngData)
        }
        for size: DynamicTypeSize in [.large, .accessibility5] {
            let controller = UIHostingController(rootView: PostcardLibraryView(store: store)
                .environment(\.dynamicTypeSize, size))
            let scene = try XCTUnwrap(UIApplication.shared.connectedScenes.first as? UIWindowScene)
            let window = UIWindow(windowScene: scene)
            window.frame = CGRect(x: 0, y: 0, width: 375, height: 812)
            window.rootViewController = controller
            window.makeKeyAndVisible()
            defer { window.isHidden = true }
            // Allow the view's async disk reads and layout to finish before capturing.
            try await Task.sleep(for: .milliseconds(600))
            controller.view.layoutIfNeeded()
            let snapshot = UIGraphicsImageRenderer(bounds: controller.view.bounds).image { _ in
                controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
            }
            let attachment = XCTAttachment(image: snapshot)
            attachment.name = size == .large ? "gallery-compact" : "gallery-accessibility"
            attachment.lifetime = .keepAlways
            add(attachment)
            XCTAssertEqual(controller.view.bounds.width, 375)
        }
    }

    func testUpdatePreservesIdentityAndResultAndCopyLeavesOriginalUntouched() async throws {
        let directory = try temporaryDirectory()
        let store = try PostcardLibraryStore(directory: directory)
        let (draft, appearance, image) = try fixture()
        let original = try await store.save(draft: draft, appearance: appearance, selfieData: image, renderedPNG: image)
        var edited = appearance
        edited.text.message = "Una nueva versión"
        edited.design = .minimal
        let secondImage = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 60)).pngData { context in
            UIColor.red.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 50, height: 60))
        }
        let updated = try await store.update(
            id: original.id, appearance: edited, selfieData: secondImage, renderedPNG: secondImage
        )
        XCTAssertEqual(updated.id, original.id)
        XCTAssertEqual(updated.createdAt, original.createdAt)
        XCTAssertEqual(updated.draft, original.draft)
        XCTAssertEqual(updated.appearance, edited)
        XCTAssertNotNil(updated.updatedAt)
        let reopened = try PostcardLibraryStore(directory: directory)
        let loaded = try await reopened.load(id: updated.id)
        XCTAssertEqual(loaded, updated)
        let updatedImage = try await reopened.imageData(id: updated.id, asset: .rendered)
        XCTAssertEqual(updatedImage, secondImage)
        let copy = try await store.save(
            draft: updated.draft, appearance: appearance, selfieData: image, renderedPNG: image
        )
        XCTAssertNotEqual(copy.id, original.id)
        let unchanged = try await store.load(id: original.id)
        XCTAssertEqual(unchanged, updated)
        let listed = try await store.list()
        XCTAssertEqual(listed.count, 2)
    }

    func testFailedUpdateRetainsPreviousRecordAndImages() async throws {
        let store = try PostcardLibraryStore(directory: temporaryDirectory())
        let (draft, appearance, image) = try fixture()
        let original = try await store.save(draft: draft, appearance: appearance, selfieData: image, renderedPNG: image)
        do {
            _ = try await store.update(
                id: original.id, appearance: PostcardAppearance(),
                selfieData: image, renderedPNG: Data("invalid".utf8)
            )
            XCTFail("Invalid update must fail")
        } catch {
            XCTAssertEqual(error as? PostcardLibraryError, .invalidImage)
        }
        let retained = try await store.load(id: original.id)
        XCTAssertEqual(retained, original)
        let retainedImage = try await store.imageData(id: original.id, asset: .rendered)
        XCTAssertEqual(retainedImage, image)
    }

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
