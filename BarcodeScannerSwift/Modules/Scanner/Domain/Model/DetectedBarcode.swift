import Foundation
import CoreGraphics // Necesario para CGRect

struct DetectedBarcode {
    let rawValue: String
    let format: String
    // El boundingBox normalizado (0.0 a 1.0) para dibujar el cuadrado verde
    let boundingBox: CGRect 
}
