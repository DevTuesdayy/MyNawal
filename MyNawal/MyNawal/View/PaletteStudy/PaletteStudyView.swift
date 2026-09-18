import SwiftUI

struct PaletteStudyView: View {
    @ObservedObject var viewModel: PaletteStudyViewModel

    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            NavigationStack {
                PaletteCatalogView(content: viewModel.content)
                    .toolbar(.hidden, for: .navigationBar)
            }
                .tag(PaletteStudyTab.catalog)
                .tabItem {
                    Label(PaletteStudyTab.catalog.title, systemImage: PaletteStudyTab.catalog.systemImage)
                }

            NavigationStack {
                CalculadorView(
                    result: viewModel.calculationResult,
                    errorMessage: viewModel.calculationErrorMessage,
                    onCalculate: viewModel.calculateNawal,
                    onCreatePostcard: viewModel.createPostcard
                )
            }
                .tag(PaletteStudyTab.calculator)
                .tabItem {
                    Label(PaletteStudyTab.calculator.title, systemImage: PaletteStudyTab.calculator.systemImage)
                }

            PalettePostcardView(draft: viewModel.postcardDraft) {
                viewModel.selectTab(.calculator)
            }
                .tag(PaletteStudyTab.postcard)
                .tabItem {
                    Label(PaletteStudyTab.postcard.title, systemImage: PaletteStudyTab.postcard.systemImage)
                }
        }
        .tint(Color.mamJade)
        .toolbarBackground(Color.mamBlanco, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarColorScheme(.light, for: .tabBar)
    }
}

#Preview {
    PaletteStudyView(
        viewModel: PaletteStudyViewModel(
            useCase: DefaultPaletteStudyUseCase(
                repository: MockPaletteStudyRepository()
            )
        )
    )
}
