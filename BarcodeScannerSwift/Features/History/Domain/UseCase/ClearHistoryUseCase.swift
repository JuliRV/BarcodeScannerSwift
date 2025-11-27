import Foundation

class ClearHistoryUseCase {
    private let repository: BarcodeRepository
    
    init(repository: BarcodeRepository) {
        self.repository = repository
    }
    
    func execute() throws {
        try repository.clearHistory()
    }
}
