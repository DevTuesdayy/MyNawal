import SwiftUI

struct SmallOrnament: View {
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color.mamJade)
                .frame(width: 6, height: 6)
            Rectangle()
                .fill(Color.mamJade)
                .frame(width: 16, height: 2)
            Circle()
                .fill(Color.mamAmarillo)
                .frame(width: 6, height: 6)
            Rectangle()
                .fill(Color.mamJade)
                .frame(width: 16, height: 2)
            Circle()
                .fill(Color.mamJade)
                .frame(width: 6, height: 6)
        }
    }
}
