import Foundation
import AVFoundation

struct BarcodeTypeFormatter {
    static func format(_ type: String) -> String {
        // Common prefixes to remove
        let prefixes = [
            "org.iso.",
            "org.gs1.",
            "com.apple.avfoundation.avmetadataobject.type."
        ]
        
        var formatted = type
        
        for prefix in prefixes {
            if formatted.hasPrefix(prefix) {
                formatted = String(formatted.dropFirst(prefix.count))
            }
        }
        
        // Specific replacements if needed (e.g., specific casing)
        switch formatted {
        case "QRCode": return "QR Code"
        case "EAN13": return "EAN-13"
        case "EAN8": return "EAN-8"
        case "PDF417": return "PDF417"
        case "Aztec": return "Aztec"
        case "Code128": return "Code 128"
        case "Code39": return "Code 39"
        case "UPCE": return "UPC-E"
        default: return formatted
        }
    }
}
