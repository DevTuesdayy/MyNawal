//
//  CameraManager.swift
//  MyNawal
//
//  Created by Alan Cervantes on 18/09/26.
//

import AVFoundation
import Combine
import UIKit

enum CameraState: Equatable {
    case idle
    case requestingPermission
    case configuring
    case ready
    case capturing
    case denied
    case restricted
    case unavailable
    case failed(String)

    var canCapture: Bool {
        self == .ready
    }
}

final class CameraManager: NSObject, ObservableObject, nonisolated AVCapturePhotoCaptureDelegate, @unchecked Sendable {
    let session = AVCaptureSession()

    @Published private(set) var capturedImage: UIImage?
    @Published private(set) var state: CameraState = .idle

    private let photoOutput = AVCapturePhotoOutput()
    private let sessionQueue = DispatchQueue(label: "com.tuesday.mynawal.camera.session")
    private var isConfigured = false

    func prepare() {
        guard state == .idle || state == .denied || state == .restricted || isRecoverableFailure else {
            return
        }

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureSession()
        case .notDetermined:
            updateState(.requestingPermission)
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self else { return }

                if granted {
                    self.configureSession()
                } else {
                    self.updateState(.denied)
                }
            }
        case .denied:
            updateState(.denied)
        case .restricted:
            updateState(.restricted)
        @unknown default:
            updateState(.unavailable)
        }
    }

    func startSession() {
        sessionQueue.async { [weak self] in
            guard let self, self.isConfigured, !self.session.isRunning else {
                return
            }

            self.session.startRunning()
        }
    }

    func stopSession() {
        sessionQueue.async { [weak self] in
            guard let self, self.session.isRunning else {
                return
            }

            self.session.stopRunning()
        }
    }

    func capturePhoto() {
        guard state.canCapture else {
            return
        }

        let rotationAngle = Self.currentInterfaceOrientation.captureVideoRotationAngle
        updateState(.capturing)

        sessionQueue.async { [weak self] in
            guard let self else { return }
            guard self.isConfigured,
                  self.session.isRunning,
                  let connection = self.photoOutput.connection(with: .video) else {
                self.updateState(.failed("La cámara todavía no está lista para tomar la foto."))
                return
            }

            if connection.isVideoMirroringSupported {
                connection.automaticallyAdjustsVideoMirroring = false
                connection.isVideoMirrored = true
            }
            if connection.isVideoRotationAngleSupported(rotationAngle) {
                connection.videoRotationAngle = rotationAngle
            }

            let settings = AVCapturePhotoSettings()
            settings.photoQualityPrioritization = .quality
            self.photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }

    func clearCapturedImage() {
        capturedImage = nil
        updateState(.ready)
    }

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        if let error {
            updateState(.failed("No se pudo capturar la foto: \(error.localizedDescription)"))
            return
        }

        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            updateState(.failed("No se pudieron procesar los datos de la fotografía."))
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.capturedImage = image
            self?.state = .ready
        }
    }

    private func configureSession() {
        updateState(.configuring)

        sessionQueue.async { [weak self] in
            guard let self else { return }

            if self.isConfigured {
                self.startSessionOnQueue()
                self.updateState(.ready)
                return
            }

            guard let camera = Self.frontCamera() else {
                self.updateState(.unavailable)
                return
            }

            self.session.beginConfiguration()
            self.session.sessionPreset = .photo

            do {
                let input = try AVCaptureDeviceInput(device: camera)
                guard self.session.canAddInput(input),
                      self.session.canAddOutput(self.photoOutput) else {
                    self.session.commitConfiguration()
                    self.updateState(.failed("No fue posible conectar la cámara frontal."))
                    return
                }

                self.session.addInput(input)
                self.session.addOutput(self.photoOutput)
                self.photoOutput.maxPhotoQualityPrioritization = .quality
                self.session.commitConfiguration()

                self.isConfigured = true
                self.startSessionOnQueue()
                self.updateState(.ready)
            } catch {
                self.session.commitConfiguration()
                self.updateState(.failed("No se pudo configurar la cámara: \(error.localizedDescription)"))
            }
        }
    }

    private func startSessionOnQueue() {
        guard !session.isRunning else {
            return
        }

        session.startRunning()
    }

    private static func frontCamera() -> AVCaptureDevice? {
        AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front)
            ?? AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    }

    private var isRecoverableFailure: Bool {
        if case .failed = state {
            return true
        }
        return false
    }

    private static var currentInterfaceOrientation: UIInterfaceOrientation {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.activationState == .foregroundActive })?
            .effectiveGeometry.interfaceOrientation ?? .portrait
    }

    private func updateState(_ newState: CameraState) {
        DispatchQueue.main.async { [weak self] in
            self?.state = newState
        }
    }
}

extension UIInterfaceOrientation {
    var captureVideoRotationAngle: CGFloat {
        switch self {
        case .portrait:
            90
        case .portraitUpsideDown:
            270
        case .landscapeLeft:
            0
        case .landscapeRight:
            180
        default:
            90
        }
    }
}
