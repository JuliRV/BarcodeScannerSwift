import Foundation

protocol SaveBarcodeUseCase {
    func execute(code: String, type: String) throws
}

class SaveBarcodeUseCaseImpl: SaveBarcodeUseCase {
    private let repository: BarcodeRepository
    
    init(repository: BarcodeRepository) {
        self.repository = repository
    }
    
    func execute(code: String, type: String) throws {
        // Aquí es donde la Clean Architecture brilla.
        // Podemos validar datos antes de tocar la capa de datos.
        guard !code.isEmpty else {
            // Podrías lanzar un error de dominio específico aquí
            return
        }
        
        let newItem = BarcodeItem(code: code, type: type)
        try repository.save(barcode: newItem)
    }
}
