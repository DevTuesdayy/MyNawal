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
                CalculadorView()
            }
                .tag(PaletteStudyTab.calculator)
                .tabItem {
                    Label(PaletteStudyTab.calculator.title, systemImage: PaletteStudyTab.calculator.systemImage)
                }

            PalettePostcardView(content: viewModel.content)
                .tag(PaletteStudyTab.postcard)
                .tabItem {
                    Label(PaletteStudyTab.postcard.title, systemImage: PaletteStudyTab.postcard.systemImage)
                }
        }
        .tint(Color.mamAmarillo)
        .toolbarBackground(Color.mamFondo, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarColorScheme(.dark, for: .tabBar)
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
