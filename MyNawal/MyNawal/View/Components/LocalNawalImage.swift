import SwiftUI
import UIKit

struct LocalNawalImage: View {
    let name: String

    var body: some View {
        Group {
            if let uiImage = loadImage(named: name) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.mamArena.opacity(0.35))
                    .overlay {
                        Text(name)
                            .font(.caption.bold())
                            .foregroundStyle(Color.mamFondo)
                    }
            }
        }
    }

    private func loadImage(named name: String) -> UIImage? {
        if let image = UIImage(named: name) {
            return image
        }

        if let image = UIImage(named: name.lowercased()) {
            return image
        }

        return nil
    }
}
