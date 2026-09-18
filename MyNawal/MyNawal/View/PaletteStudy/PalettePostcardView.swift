import SwiftUI

struct PalettePostcardView: View {
    let draft: NawalPostcardDraft?
    let onCalculate: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isShowingSelfie = false
    @State private var selfieImage: UIImage?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("Tu postal Nawal")
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .accessibilityAddTraits(.isHeader)
                    Text(draft == nil
                         ? "Comienza descubriendo tu nawal"
                         : selfieImage == nil
                            ? "Tu nawal, listo para crear tu postal"
                            : "Tu selfie y tu nawal, unidos en una postal")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(Color.mamFondo.opacity(0.75))
                    SeparadorHilos()
                }

                if let draft {
                    if let selfieImage {
                        completedPostcard(draft, selfieImage: selfieImage)
                            .id(draft)
                            .nawalEntrance()
                    } else {
                        postcardDetails(draft)
                            .id(draft)
                            .nawalEntrance()

                        selfieSection()
                    }
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "camera.on.rectangle")
                            .font(.system(size: 44, weight: .light))
                            .foregroundStyle(Color.mamJade)
                            .accessibilityHidden(true)
                        Text("Primero calcula tu Nawal")
                            .font(.headline)
                        Text("Ingresa tu fecha de nacimiento y toca Crear mi postal en tu resultado.")
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .superficieEstuco()
                }

                Button(action: onCalculate) {
                    Label(draft == nil ? "Calcular mi Nawal" : "Volver a calcular", systemImage: "calendar")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(Color.mamBlanco)
                        .padding(18)
                        .frame(maxWidth: .infinity, minHeight: 54)
                        .background(Color.mamJade, in: RoundedRectangle(cornerRadius: 18))
                }
                .buttonStyle(NawalPressStyle())
            }
            .foregroundStyle(Color.mamFondo)
            .multilineTextAlignment(.center)
            .frame(maxWidth: 520)
            .padding(24)
            .frame(maxWidth: .infinity)
        }
        .background(FondoEstuco().ignoresSafeArea())
        .fullScreenCover(isPresented: $isShowingSelfie) {
            if let draft {
                NawalSelfieView(draft: draft) { image in
                    withAnimation(reduceMotion ? nil : .easeOut(duration: 0.24)) {
                        selfieImage = image
                    }
                }
            }
        }
        .onChange(of: draft) { oldDraft, newDraft in
            guard oldDraft != newDraft else { return }
            selfieImage = nil
        }
    }

    private func postcardDetails(_ draft: NawalPostcardDraft) -> some View {
        let nawal = draft.result.nawal
        return VStack(spacing: 16) {
            Text("Mi Nawal es")
                .font(.headline)
            Text("\(draft.result.energia) \(nawal.nombre)")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(Color.mamJade)
                .accessibilityLabel("Energía \(draft.result.energia), nawal \(nawal.nombre)")

            ImagenNawalLocal(nombre: nawal.nombreImagen)
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(8)
                .superficieEstuco()
                .accessibilityHidden(true)

            Text(nawal.informacion.significado)
                .font(.system(.title3, design: .rounded, weight: .medium))
            Text("Animal o representación: \(nawal.informacion.animal)")
                .font(.body)
            Text("Elemento: \(nawal.informacion.elemento)")
                .font(.body)
            SeparadorHilos()
            Text(draft.birthDateText)
                .font(.headline)
                .accessibilityLabel("Fecha de nacimiento: \(draft.birthDateText)")
            Text(nawal.informacion.energia)
                .font(.subheadline)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .superficieEstuco()
    }

    private func selfieSection() -> some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 34, weight: .medium))
                    .foregroundStyle(Color.mamJade)
                    .accessibilityHidden(true)
                Text("Añade tu selfie")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                Text("La usaremos para crear tu postal en el siguiente paso.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(Color.mamFondo.opacity(0.72))
            }
            .padding(.vertical, 8)

            Button {
                isShowingSelfie = true
            } label: {
                Label("Tomar mi selfie", systemImage: "camera.fill")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Color.mamBlanco)
                .padding(16)
                .frame(maxWidth: .infinity, minHeight: 54)
                .background(Color.mamJade, in: RoundedRectangle(cornerRadius: 18))
            }
            .buttonStyle(NawalPressStyle())
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .superficieEstuco()
    }

    private func completedPostcard(
        _ draft: NawalPostcardDraft,
        selfieImage: UIImage
    ) -> some View {
        VStack(spacing: 18) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(Color.mamJade)
                Text("Tu postal está lista")
                    .font(.system(.title3, design: .rounded, weight: .bold))
            }

            NawalPostcardCanvas(draft: draft, selfieImage: selfieImage)
                .shadow(color: Color.mamFondo.opacity(0.16), radius: 8, y: 5)
                .transition(
                    reduceMotion
                        ? .opacity
                        : .scale(scale: 0.96).combined(with: .opacity)
                )

            Button {
                isShowingSelfie = true
            } label: {
                Label("Cambiar selfie", systemImage: "arrow.triangle.2.circlepath.camera")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Color.mamJade)
                    .frame(maxWidth: .infinity, minHeight: 52)
            }
            .buttonStyle(.bordered)
            .tint(Color.mamJade)
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .superficieEstuco()
    }
}

#Preview("Sin resultado") {
    PalettePostcardView(draft: nil, onCalculate: {})
}

#Preview("Con resultado") {
    PalettePostcardView(
        draft: NawalPostcardDraft(
            result: NawalCalculationResult(nawal: NawalCatalogo.items[0], energia: 11),
            birthDateText: "10 de diciembre de 1954"
        ),
        onCalculate: {}
    )
}
