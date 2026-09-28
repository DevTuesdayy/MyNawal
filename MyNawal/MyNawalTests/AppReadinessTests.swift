import UIKit
import SwiftUI
import XCTest
@testable import MyNawal

@MainActor
final class AppReadinessTests: XCTestCase {
    func testCatalogContainsTwentyUniqueNawalesWithImages() {
        let nawales = NawalCatalogo.items

        XCTAssertEqual(nawales.count, 20)
        XCTAssertEqual(Set(nawales.map(\.nombre)).count, 20)

        for nawal in nawales {
            XCTAssertNotNil(
                UIImage(named: nawal.nombreImagen),
                "Falta la imagen local de \(nawal.nombre): \(nawal.nombreImagen)"
            )
        }
    }

    func testExplanationLayoutSnapshots() async throws {
        for size: DynamicTypeSize in [.large, .accessibility5] {
            let view = CalculoNawalExplicacionView()
                .environment(\.dynamicTypeSize, size)
            let controller = UIHostingController(rootView: view)
            let scene = try XCTUnwrap(UIApplication.shared.connectedScenes.first as? UIWindowScene)
            let window = UIWindow(windowScene: scene)
            window.frame = CGRect(x: 0, y: 0, width: 375, height: 812)
            window.rootViewController = controller
            window.makeKeyAndVisible()
            defer { window.isHidden = true }

            try await Task.sleep(for: .milliseconds(900))
            controller.view.layoutIfNeeded()
            let snapshot = UIGraphicsImageRenderer(bounds: controller.view.bounds).image { _ in
                controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
            }
            let attachment = XCTAttachment(image: snapshot)
            attachment.name = size == .large ? "calculo-explicacion" : "calculo-explicacion-texto-grande"
            attachment.lifetime = .keepAlways
            add(attachment)

            XCTAssertEqual(controller.view.bounds.width, 375)
        }
    }

    func testCalculatorHelpButtonLayoutSnapshots() async throws {
        for size: DynamicTypeSize in [.large, .accessibility5] {
            let view = NavigationStack {
                CalculadorView(
                    result: nil,
                    errorMessage: nil,
                    onCalculate: { _ in },
                    onCreatePostcard: {}
                )
            }
            .environment(\.dynamicTypeSize, size)
            let controller = UIHostingController(rootView: view)
            let scene = try XCTUnwrap(UIApplication.shared.connectedScenes.first as? UIWindowScene)
            let window = UIWindow(windowScene: scene)
            window.frame = CGRect(x: 0, y: 0, width: 375, height: 812)
            window.rootViewController = controller
            window.makeKeyAndVisible()
            defer { window.isHidden = true }

            try await Task.sleep(for: .milliseconds(500))
            controller.view.layoutIfNeeded()
            let snapshot = UIGraphicsImageRenderer(bounds: controller.view.bounds).image { _ in
                controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
            }
            let attachment = XCTAttachment(image: snapshot)
            attachment.name = size == .large ? "calculadora-ayuda" : "calculadora-ayuda-texto-grande"
            attachment.lifetime = .keepAlways
            add(attachment)

            XCTAssertEqual(controller.view.bounds.width, 375)
        }
    }
}
