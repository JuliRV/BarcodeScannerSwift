import SwiftUI
import SwiftData

@main
struct BarcodeScannerSwiftApp: App {
    // Contenedor de SwiftData (Base de datos)
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            BarcodeItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            TabView {
                // --- FEATURE: HISTORY ---
                // Composition Root (DI Manual)
                // 1. Data Layer
                let context = sharedModelContainer.mainContext
                let historyRepository = BarcodeRepositoryImpl(modelContext: context)
                
                // 2. Domain Layer (UseCases)
                let getHistoryUseCase = GetHistoryUseCaseImpl(repository: historyRepository)
                let deleteBarcodeUseCase = DeleteBarcodeUseCaseImpl(repository: historyRepository)
                let saveBarcodeUseCase = SaveBarcodeUseCaseImpl(repository: historyRepository)
                
                // 3. Presentation Layer (ViewModel)
                let historyViewModel = HistoryViewModel(
                    getHistoryUseCase: getHistoryUseCase,
                    deleteBarcodeUseCase: deleteBarcodeUseCase,
                    saveBarcodeUseCase: saveBarcodeUseCase
                )
                
                HistoryView(viewModel: historyViewModel)
                    .tabItem {
                        Label("Historial", systemImage: "list.bullet")
                    }
                
                // --- MODULE: SCANNER ---
                let scannerViewModel = ScannerViewModel()
                
                ScannerView(viewModel: scannerViewModel)
                    .tabItem {
                        Label("Escanear", systemImage: "qrcode.viewfinder")
                    }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
