import SwiftUI

struct OrnamentLine: View {
    var body: some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(Color.mamJade)
                .frame(height: 2)
            SmallOrnament()
            Rectangle()
                .fill(Color.mamJade)
                .frame(height: 2)
        }
        .frame(maxWidth: 220)
    }
}
