import SwiftUI

struct PalettePostcardView: View {
  let content: PaletteStudyContent

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 24) {
        VStack(spacing: 12) {
          Text(content.postcardTitle)
            .font(.system(.title, design: .rounded, weight: .bold))
            .foregroundStyle(Color.mamFondo)
            .accessibilityAddTraits(.isHeader)

          Text(content.postcardSubtitle)
            .font(.system(.body, design: .rounded))
            .foregroundStyle(Color.mamFondo.opacity(0.75))

          SeparadorHilos()
            .padding(.top, 4)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)

        VStack(spacing: 16) {
          Text("Postal de ejemplo · No es un resultado calculado")
            .font(.headline.weight(.semibold))
            .foregroundStyle(Color.mamFondo)

          Text(content.selectedNawal.subtitle)
            .font(.system(size: 34, weight: .black, design: .rounded))
            .foregroundStyle(Color.mamFondo)

          if let nawal = content.catalogItems.first(where: {
            $0.nombre == content.selectedNawal.subtitle
          }) {
            Text("Simbolismo: \(nawal.informacion.significado)")
              .font(.subheadline)
              .foregroundStyle(Color.mamFondo)
            Text("Animal o representación: \(nawal.informacion.animal)")
              .font(.footnote)
            Text("Elemento: \(nawal.informacion.elemento)")
              .font(.footnote)
            ImagenNawalLocal(nombre: nawal.nombreImagen)
              .aspectRatio(1, contentMode: .fit)
              .frame(maxWidth: 200)
              .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
              .padding(8)
              .superficieEstuco()
              .accessibilityLabel("Imagen de \(nawal.nombre)")
            Text(nawal.informacion.energia)
              .font(.subheadline)
              .foregroundStyle(Color.mamFondo)
          }

          VStack(spacing: 6) {
            Text("Fecha de ejemplo: \(content.birthDateText)")
              .font(.headline)
              .foregroundStyle(Color.mamFondo)
          }

          SeparadorHilos()
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
        .superficieEstuco()

        HStack(spacing: 12) {
          PalettePostcardAction(title: "Guardar", icon: "arrow.down", background: .mamJade)
          PalettePostcardAction(
            title: "Compartir", icon: "square.and.arrow.up", background: .mamFondo)
        }

      }
      .frame(maxWidth: 520)
      .padding(24)
      .frame(maxWidth: .infinity)
      .nawalEntrance()
    }
    .background(FondoEstuco().ignoresSafeArea())
  }
}
