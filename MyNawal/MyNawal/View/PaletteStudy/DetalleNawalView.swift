import SwiftUI

struct DetalleNawalView: View {
    let nawal: PaletteNawalItem
    let contenido: PaletteStudyContent

    @Environment(\.dismiss) private var cerrarVista

    private var esImox: Bool {
        nawal.nombre == "Imox"
    }

    private var subtitulo: String {
        esImox ? "(Cocodrilo / Agua)" : "Símbolo sagrado"
    }

    private var descripcion: String {
        if esImox {
            return contenido.selectedNawal.description
        }

        return "El nawal \(nawal.nombre) acompaña tu camino y representa una energía única dentro de la cosmovisión maya."
    }

    private var energia: String {
        esImox ? contenido.selectedNawal.energyText : "Conexión • Equilibrio • Propósito"
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                encabezado

                VStack(spacing: 6) {
                    Text("Tu Nawal es")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.mamFondo)

                    Text(nawal.nombre)
                        .font(.system(size: 54, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.mamJade)

                    Text(subtitulo)
                        .font(.system(size: 22, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.mamFondo)
                }

                ImagenNawalLocal(nombre: nawal.nombreImagen)
                    .frame(width: 250, height: 250)

                HStack(spacing: 14) {
                    ForEach(0..<5, id: \.self) { _ in
                        Circle()
                            .fill(Color.mamJade)
                            .frame(width: 30, height: 30)
                    }
                }

                Text(descripcion)
                    .font(.system(size: 19, weight: .regular, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.mamFondo)
                    .lineSpacing(5)
                    .frame(maxWidth: 360)

                VStack(alignment: .leading, spacing: 14) {
                    Text("Fecha correspondiente")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.mamFondo)

                    Text(contenido.birthDateText)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.mamFondo)

                    Text("Energía")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.mamFondo)
                        .padding(.top, 8)

                    Text(energia)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.mamFondo)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
                .background(Color.mamArena.opacity(0.22))
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .background(Color.mamBlanco.ignoresSafeArea())
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
    }

    private var encabezado: some View {
        HStack {
            Button(action: { cerrarVista() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 26, weight: .medium))
                    .foregroundStyle(Color.mamFondo)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Regresar al catálogo")

            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        DetalleNawalView(
            nawal: PaletteNawalItem(
                nombre: "Imox",
                esDestacado: true,
                nombreImagen: "nawal_01"
            ),
            contenido: MockPaletteStudyRepository().fetchContent()
        )
    }
}
