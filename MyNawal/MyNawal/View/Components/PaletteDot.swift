import SwiftUI

struct PaletteDot: View {
    let color: Color

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 16, height: 16)
    }
}
