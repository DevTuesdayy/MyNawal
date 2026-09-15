import SwiftUI

struct DetalleNawalView: View {
    let nawal: PaletteNawalItem

    @Environment(\.dismiss) private var cerrarVista

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                encabezado

                VStack(spacing: 12) {
                    Text("Conoce el nawal")
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .foregroundStyle(Color.mamFondo)
                        .accessibilityAddTraits(.isHeader)

                    Text(nawal.nombre)
                        .font(.system(size: 54, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.mamJade)

                    Text(nawal.informacion.significado)
                        .font(.system(size: 22, weight: .medium, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.mamFondo)

                    SeparadorHilos()
                        .padding(.top, 4)
                }
                .multilineTextAlignment(.center)

                ImagenNawalLocal(nombre: nawal.nombreImagen)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: 320)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .padding(8)
                    .superficieEstuco()
                    .accessibilityLabel("Imagen de \(nawal.nombre)")

                Text(nawal.informacion.descripcion)
                    .font(.system(size: 19, weight: .regular, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.mamFondo)
                    .lineSpacing(5)
                    .frame(maxWidth: 360)
                    .padding(20)
                    .superficieEstuco()
                    .nawalEntrance()

                VStack(alignment: .leading, spacing: 14) {
                    Text("Animal o representación")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.mamFondo)

                    Text(nawal.informacion.animal)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.mamFondo)

                    Divider()

                    Text("Elemento")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.mamFondo)

                    Text(nawal.informacion.elemento)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.mamFondo)

                    Divider()

                    Text("Asociaciones simbólicas")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.mamFondo)

                    Text(nawal.informacion.energia)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundStyle(Color.mamFondo)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
                .superficieEstuco()

            }
            .frame(maxWidth: 520)
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
        }
        .background(FondoEstuco().ignoresSafeArea())
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
            .buttonStyle(NawalPressStyle())

            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        DetalleNawalView(
            nawal: NawalCatalogo.items[0]
        )
    }
}
