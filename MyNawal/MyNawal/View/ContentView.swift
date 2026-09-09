import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: PaletteStudyViewModel
                    
    init() {
        let repository = MockPaletteStudyRepository()
        let useCase = DefaultPaletteStudyUseCase(repository: repository)
        _viewModel = StateObject(wrappedValue: PaletteStudyViewModel(useCase: useCase))
    }

    var body: some View {
        PaletteStudyView(viewModel: viewModel)
    }
}

#Preview {
    ContentView()
}
