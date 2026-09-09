import SwiftUI

struct PaletteStudyView: View {
    @ObservedObject var viewModel: PaletteStudyViewModel

    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            PaletteCatalogView(content: viewModel.content)
                .tag(PaletteStudyTab.catalog)
                .tabItem {
                    Label(PaletteStudyTab.catalog.title, systemImage: PaletteStudyTab.catalog.systemImage)
                }

            PaletteDetailView(content: viewModel.content)
                .tag(PaletteStudyTab.detail)
                .tabItem {
                    Label(PaletteStudyTab.detail.title, systemImage: PaletteStudyTab.detail.systemImage)
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
