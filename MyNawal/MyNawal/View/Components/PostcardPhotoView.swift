import SwiftUI

struct PostcardPhotoMask: Shape {
    let shape: PostcardPhotoShape
    var radius: CGFloat = 18
    func path(in rect: CGRect) -> Path {
        switch shape {
        case .rounded: RoundedRectangle(cornerRadius: radius).path(in: rect)
        case .circle, .oval: Ellipse().path(in: rect)
        }
    }
}

/// Same crop and finish for interactive preview and high-resolution export.
struct PostcardPhotoView: View {
    let image: UIImage
    let settings: PostcardPhotoSettings
    var border: Color = .mamArena
    var unit: CGFloat = 1

    var body: some View {
        GeometryReader { proxy in
            let viewport = CGSize(
                width: settings.shape == .circle ? min(proxy.size.width, proxy.size.height) : proxy.size.width,
                height: proxy.size.height
            )
            let layout = settings.geometry(image: image.size, viewport: viewport)
            let mask = PostcardPhotoMask(shape: settings.shape, radius: 18 * unit)
            ZStack {
                Image(uiImage: settings.finish == .monochrome ? PostcardPhotoFilter.monochrome(image) : image)
                    .resizable()
                    .frame(width: layout.size.width, height: layout.size.height)
                    .offset(layout.offset)
            }
            .frame(width: viewport.width, height: viewport.height)
            .clipped()
            .overlay {
                if settings.finish == .warm {
                    Color.orange.opacity(0.16).blendMode(.softLight)
                }
            }
            .clipShape(mask)
            .overlay { mask.stroke(border, lineWidth: 2 * unit) }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .accessibilityHidden(true)
    }
}

/// The crop and the nawal badge are identical in the editor and exported postcard.
struct PostcardPhotoWithBadge: View {
    let image: UIImage
    let settings: PostcardPhotoSettings
    let border: Color
    let ornament: Color
    let nawalImageName: String
    let unit: CGFloat

    var body: some View {
        PostcardPhotoView(image: image, settings: settings, border: border, unit: unit)
            .overlay(alignment: .topTrailing) {
                ImagenNawalLocal(nombre: nawalImageName)
                    .frame(width: 68 * unit, height: 68 * unit)
                    .padding(5 * unit)
                    .background(Color.mamBlanco.opacity(0.94), in: RoundedRectangle(cornerRadius: 14 * unit))
                    .overlay {
                        RoundedRectangle(cornerRadius: 14 * unit)
                            .strokeBorder(ornament, lineWidth: 1.5 * unit)
                    }
                    .shadow(color: Color.mamFondo.opacity(0.22), radius: 4 * unit, y: 2 * unit)
                    .padding(10 * unit)
                    .allowsHitTesting(false)
            }
    }
}

struct PostcardPhotoControls: View {
    let image: UIImage
    @Binding var settings: PostcardPhotoSettings
    let aspectRatio: CGFloat
    let border: Color
    let ornament: Color
    let nawalImageName: String
    @GestureState private var drag: CGSize = .zero
    @GestureState private var magnification: CGFloat = 1

    private func transientSettings(in viewport: CGSize) -> PostcardPhotoSettings {
        var value = settings
        value.zoom = min(max(settings.zoom * magnification, 1), 3)
        let layout = value.geometry(image: image.size, viewport: viewport)
        let overflowX = (layout.size.width - viewport.width) / 2
        let overflowY = (layout.size.height - viewport.height) / 2
        value.x = min(max(settings.x + (overflowX > 0 ? drag.width / overflowX : 0), -1), 1)
        value.y = min(max(settings.y + (overflowY > 0 ? drag.height / overflowY : 0), -1), 1)
        return value
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Encuadra tu foto").font(.headline)
            Text("Arrastra la foto y amplía con dos dedos, o usa los controles.")
                .font(.subheadline)
            GeometryReader { proxy in
                let viewport = CGSize(width: settings.shape == .circle ? min(proxy.size.width, proxy.size.height) : proxy.size.width,
                                      height: proxy.size.height)
                PostcardPhotoWithBadge(
                    image: image,
                    settings: transientSettings(in: viewport),
                    border: border,
                    ornament: ornament,
                    nawalImageName: nawalImageName,
                    unit: proxy.size.width / 324
                )
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .updating($drag) { value, state, _ in state = value.translation }
                            .onEnded { value in
                                let layout = settings.geometry(image: image.size, viewport: viewport)
                                let dx = (layout.size.width - viewport.width) / 2
                                let dy = (layout.size.height - viewport.height) / 2
                                settings.x = min(max(settings.x + (dx > 0 ? value.translation.width / dx : 0), -1), 1)
                                settings.y = min(max(settings.y + (dy > 0 ? value.translation.height / dy : 0), -1), 1)
                            }
                    )
                    .simultaneousGesture(
                        MagnifyGesture()
                            .updating($magnification) { value, state, _ in state = value.magnification }
                            .onEnded { value in settings.zoom = min(max(settings.zoom * value.magnification, 1), 3) }
                    )
            }
            .aspectRatio(aspectRatio, contentMode: .fit)

            Text("Ampliación").font(.subheadline)
            Slider(value: $settings.zoom, in: 1...3) { Text("Ampliación") }
            Text("Posición horizontal").font(.subheadline)
            Slider(value: $settings.x, in: -1...1) { Text("Posición horizontal") }
            Text("Posición vertical").font(.subheadline)
            Slider(value: $settings.y, in: -1...1) { Text("Posición vertical") }
            Picker("Recorte", selection: $settings.shape) {
                ForEach(PostcardPhotoShape.allCases) { Text($0.title).tag($0) }
            }
            Picker("Acabado", selection: $settings.finish) {
                ForEach(PostcardPhotoFinish.allCases) { Text($0.title).tag($0) }
            }
            Button("Restablecer foto", systemImage: "arrow.counterclockwise") {
                settings = PostcardPhotoSettings()
            }
            .frame(minHeight: 44)
        }
        .pickerStyle(.menu)
        .tint(Color.mamJade)
    }
}
