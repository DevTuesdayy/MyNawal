import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: PaletteStudyViewModel
    @State private var isPresentingWelcome: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
                    
    init(showWelcome: Bool = true) {
        let repository = MockPaletteStudyRepository()
        let useCase = DefaultPaletteStudyUseCase(repository: repository)
        _viewModel = StateObject(wrappedValue: PaletteStudyViewModel(useCase: useCase))
        _isPresentingWelcome = State(initialValue: showWelcome)
    }

    var body: some View {
        ZStack {
            PaletteStudyView(viewModel: viewModel)
                .opacity(isPresentingWelcome ? 0.94 : 1)
                .allowsHitTesting(!isPresentingWelcome)
                .accessibilityHidden(isPresentingWelcome)

            if isPresentingWelcome {
                WelcomeView {
                    guard isPresentingWelcome else { return }
                    withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.36)) {
                        isPresentingWelcome = false
                    }
                }
                .transition(
                    reduceMotion
                        ? .opacity
                        : .opacity.combined(with: .scale(scale: 1.012))
                )
                .zIndex(1)
            }
        }
    }
}

#Preview {
    ContentView()
}

#Preview("Contenido principal") {
    ContentView(showWelcome: false)
}
