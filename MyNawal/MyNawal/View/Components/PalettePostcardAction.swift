import SwiftUI

struct PalettePostcardAction: View {
    let title: String
    let icon: String
    let background: Color

    var body: some View {
        HStack(spacing: 9) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .black))
                .frame(width: 28, height: 28)
                .background(Color.white.opacity(0.12))
                .clipShape(Circle())

            Text(title)
                .font(.system(size: 15, weight: .bold, design: .rounded))
        }
            .foregroundStyle(Color.mamCrema)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: background.opacity(0.2), radius: 8, y: 4)
    }
}
