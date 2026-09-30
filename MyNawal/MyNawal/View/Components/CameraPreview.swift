import AVFoundation
import SwiftUI

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    let device: AVCaptureDevice?

    func makeUIView(context: Context) -> CameraPreviewView {
        let view = CameraPreviewView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        view.configureRotation(for: device)
        return view
    }

    func updateUIView(_ uiView: CameraPreviewView, context: Context) {
        if uiView.previewLayer.session !== session {
            uiView.previewLayer.session = session
        }
        uiView.configureRotation(for: device)
    }
}

final class CameraPreviewView: UIView {
    private var rotationCoordinator: AVCaptureDevice.RotationCoordinator?
    private var rotationObservation: NSKeyValueObservation?

    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var previewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            preconditionFailure("CameraPreviewView debe utilizar AVCaptureVideoPreviewLayer")
        }
        return layer
    }

    func configureRotation(for device: AVCaptureDevice?) {
        guard let device else { return }
        guard rotationCoordinator?.device !== device else {
            updatePreviewRotation()
            return
        }

        rotationObservation = nil
        let coordinator = AVCaptureDevice.RotationCoordinator(device: device, previewLayer: previewLayer)
        rotationCoordinator = coordinator
        rotationObservation = coordinator.observe(
            \.videoRotationAngleForHorizonLevelPreview,
            options: [.initial, .new]
        ) { [weak self] _, _ in
            self?.updatePreviewRotation()
        }
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        updatePreviewRotation()
    }

    private func updatePreviewRotation() {
        guard let coordinator = rotationCoordinator,
              let connection = previewLayer.connection else { return }
        let rotationAngle = coordinator.videoRotationAngleForHorizonLevelPreview
        if connection.isVideoRotationAngleSupported(rotationAngle) {
            connection.videoRotationAngle = rotationAngle
        }
    }
}
