import CoreTransferable
import Photos
import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct RenderedPostcard {
    let image: UIImage
    let pngData: Data
}

struct ShareablePostcard: Transferable {
    let pngData: Data

    nonisolated static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { postcard in
            postcard.pngData
        }
    }
}

enum PostcardExportError: LocalizedError, Equatable {
    case renderingFailed
    case photoAccessDenied
    case savingFailed(String)

    var errorDescription: String? {
        switch self {
        case .renderingFailed:
            "No se pudo preparar la imagen de la postal. Inténtalo nuevamente."
        case .photoAccessDenied:
            "Activa el acceso a Fotos en Configuración para guardar tu postal."
        case .savingFailed(let message):
            "No se pudo guardar la postal: \(message)"
        }
    }
}

enum PostcardExportService {
    static let exportSize = CGSize(width: 1080, height: 1350)

    @MainActor
    static func render(
        draft: NawalPostcardDraft,
        selfieImage: UIImage,
        appearance: PostcardAppearance = PostcardAppearance()
    ) throws -> RenderedPostcard {
        let postcard = NawalPostcardCanvas(draft: draft, selfieImage: selfieImage, appearance: appearance)
            .frame(width: exportSize.width, height: exportSize.height)

        let renderer = ImageRenderer(content: postcard)
        renderer.proposedSize = ProposedViewSize(exportSize)
        renderer.scale = 1
        renderer.isOpaque = true

        guard let image = renderer.uiImage,
              let pngData = image.pngData() else {
            throw PostcardExportError.renderingFailed
        }

        return RenderedPostcard(image: image, pngData: pngData)
    }

    static func saveToPhotoLibrary(_ pngData: Data) async throws {
        let currentStatus = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        let status: PHAuthorizationStatus

        if currentStatus == .notDetermined {
            status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        } else {
            status = currentStatus
        }

        guard status == .authorized || status == .limited else {
            throw PostcardExportError.photoAccessDenied
        }

        do {
            try await PHPhotoLibrary.shared().performChanges {
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: .photo, data: pngData, options: nil)
            }
        } catch {
            throw PostcardExportError.savingFailed(error.localizedDescription)
        }
    }
}
