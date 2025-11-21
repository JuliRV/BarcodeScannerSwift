import Foundation
import SwiftData

// Equivalente a BarcodeRepositoryImpl en Kotlin
class BarcodeRepositoryImpl: BarcodeRepository {
    
    // ModelContext es como tu DAO/Database instance. Maneja la conexión a la DB.
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchHistory() throws -> [BarcodeItem] {
        // FetchDescriptor es como tu Query @Query("SELECT * FROM ...")
        let descriptor = FetchDescriptor<BarcodeItem>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try modelContext.fetch(descriptor)
    }
    
    func save(barcode: BarcodeItem) throws {
        modelContext.insert(barcode)
        // En SwiftData el autoguardado suele estar activo, pero a veces llamamos save() explícito.
        // try modelContext.save() 
    }
    
    func delete(barcode: BarcodeItem) throws {
        modelContext.delete(barcode)
    }
}
