import SwiftUI
import UIKit

struct ImagenNawalLocal: View {
    let nombre: String

    var body: some View {
        Group {
            if let imagen = cargarImagen(nombre: nombre) {
                Image(uiImage: imagen)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 30, weight: .light))
                    .foregroundStyle(Color.mamFondo.opacity(0.28))
            }
        }
    }

    private func cargarImagen(nombre: String) -> UIImage? {
        UIImage(named: nombre)
    }
}
