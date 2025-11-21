import Foundation

// Equivalente a tu interface BarcodeRepository en Kotlin
protocol BarcodeRepository {
    func fetchHistory() throws -> [BarcodeItem]
    func save(barcode: BarcodeItem) throws
    func delete(barcode: BarcodeItem) throws
}
