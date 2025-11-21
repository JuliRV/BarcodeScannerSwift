import Foundation
import SwiftData

// @Model es la macro de SwiftData equivalente a @Entity de Room.
// Hace que esta clase sea persistente automáticamente.
@Model
final class BarcodeItem {
    // En SwiftData no necesitamos @PrimaryKey explícito si usamos UUID, pero @Attribute(.unique) asegura unicidad.
    @Attribute(.unique) var id: UUID
    var code: String
    var type: String // E.g. "QR_CODE", "EAN_13"
    var date: Date
    
    // Init similar al constructor de Kotlin
    init(code: String, type: String, date: Date = Date()) {
        self.id = UUID()
        self.code = code
        self.type = type
        self.date = date
    }
}
