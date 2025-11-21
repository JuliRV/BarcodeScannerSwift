import Foundation

// Interfaz del UseCase
protocol GetHistoryUseCase {
    func execute() throws -> [BarcodeItem]
}

// Implementación
class GetHistoryUseCaseImpl: GetHistoryUseCase {
    private let repository: BarcodeRepository
    
    init(repository: BarcodeRepository) {
        self.repository = repository
    }
    
    func execute() throws -> [BarcodeItem] {
        // Aquí podrías aplicar lógica de negocio extra (filtrado, ordenamiento, etc.)
        return try repository.fetchHistory()
    }
}
