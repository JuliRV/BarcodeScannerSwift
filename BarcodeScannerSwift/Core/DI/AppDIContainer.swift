import Foundation
import SwiftData

@MainActor
class AppDIContainer {
    
    // MARK: - Persistent Storage
    let sharedModelContainer: ModelContainer
    
    init() {
        let schema = Schema([
            BarcodeItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            self.sharedModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    // MARK: - Repositories
    // Lazy initialization to ensure ModelContainer is ready and to create a single instance if desired (Singleton-like for the repo)
    private lazy var barcodeRepository: BarcodeRepository = {
        BarcodeRepositoryImpl(modelContext: sharedModelContainer.mainContext)
    }()
    
    // MARK: - Use Cases
    // Factory methods or properties for UseCases
    private var getHistoryUseCase: GetHistoryUseCase {
        GetHistoryUseCaseImpl(repository: barcodeRepository)
    }
    
    private var deleteBarcodeUseCase: DeleteBarcodeUseCase {
        DeleteBarcodeUseCaseImpl(repository: barcodeRepository)
    }
    
    private var saveBarcodeUseCase: SaveBarcodeUseCase {
        SaveBarcodeUseCaseImpl(repository: barcodeRepository)
    }
    
    private var clearHistoryUseCase: ClearHistoryUseCase {
        ClearHistoryUseCase(repository: barcodeRepository)
    }
    
    // MARK: - ViewModels Factory Methods
    
    func makeHistoryViewModel() -> HistoryViewModel {
        HistoryViewModel(
            getHistoryUseCase: getHistoryUseCase,
            deleteBarcodeUseCase: deleteBarcodeUseCase,
            clearHistoryUseCase: clearHistoryUseCase
        )
    }
    
    func makeScannerViewModel() -> ScannerViewModel {
        ScannerViewModel(
            saveBarcodeUseCase: saveBarcodeUseCase
        )
    }
}
