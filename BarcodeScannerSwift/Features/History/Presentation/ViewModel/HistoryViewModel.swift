import Foundation
import Observation

@Observable
class HistoryViewModel {
    // ESTADO
    var items: [BarcodeItem] = []
    var errorMessage: String? = nil
    
    // DEPENDENCIAS (UseCases)
    private let getHistoryUseCase: GetHistoryUseCase
    private let deleteBarcodeUseCase: DeleteBarcodeUseCase
    private let saveBarcodeUseCase: SaveBarcodeUseCase
    
    // Init con inyección de dependencias
    init(
        getHistoryUseCase: GetHistoryUseCase,
        deleteBarcodeUseCase: DeleteBarcodeUseCase,
        saveBarcodeUseCase: SaveBarcodeUseCase
    ) {
        self.getHistoryUseCase = getHistoryUseCase
        self.deleteBarcodeUseCase = deleteBarcodeUseCase
        self.saveBarcodeUseCase = saveBarcodeUseCase
    }
    
    // INTENCIONES
    func loadHistory() {
        do {
            self.items = try getHistoryUseCase.execute()
        } catch {
            self.errorMessage = "Error cargando historial: \(error.localizedDescription)"
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            do {
                try deleteBarcodeUseCase.execute(item: item)
                // Actualización optimista de la UI
                items.remove(at: index)
            } catch {
                self.errorMessage = "Error eliminando: \(error.localizedDescription)"
            }
        }
    }
    
    func addMockItem() {
        do {
            try saveBarcodeUseCase.execute(code: "123456", type: "EAN-13")
            loadHistory() // Recargamos la lista completa
        } catch {
            self.errorMessage = "Error guardando: \(error.localizedDescription)"
        }
    }
}
