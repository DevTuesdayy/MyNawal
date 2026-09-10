import SwiftUI

struct TarjetaCatalogoNawal: View {
    let nawal: PaletteNawalItem
    let alSeleccionar: () -> Void

    var body: some View {
        Button(action: alSeleccionar) {
            VStack(spacing: 10) {
                ImagenNawalLocal(nombre: nawal.nombreImagen)
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.mamArena.opacity(0.28), lineWidth: 1)
                    }

                Text(nawal.nombre)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.mamFondo)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .background(Color.mamTarjeta)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.mamFondo.opacity(0.07), lineWidth: 1)
            }
            .shadow(color: Color.mamFondo.opacity(0.08), radius: 7, y: 4)
        }
        .buttonStyle(NawalCardButtonStyle())
        .accessibilityLabel("Nawal \(nawal.nombre)")
    }
}

private struct NawalCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.88 : 1)
            .animation(.easeOut(duration: 0.16), value: configuration.isPressed)
    }
}

#Preview {
    TarjetaCatalogoNawal(
        nawal: PaletteNawalItem(nombre: "Imox", esDestacado: true, nombreImagen: "Imox"),
        alSeleccionar: {}
    )
    .padding()
    .background(Color.mamBlanco)
}
