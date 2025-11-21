import Foundation

protocol DeleteBarcodeUseCase {
    func execute(item: BarcodeItem) throws
}

class DeleteBarcodeUseCaseImpl: DeleteBarcodeUseCase {
    private let repository: BarcodeRepository
    
    init(repository: BarcodeRepository) {
        self.repository = repository
    }
    
    func execute(item: BarcodeItem) throws {
        try repository.delete(barcode: item)
    }
}
