import Foundation

// Este repositorio abstraerá la complejidad de MLKit.
// La implementación (Data Layer) usará MLKit.
protocol ScannerRepository {
    // Stream o callback que emite códigos detectados
    // En Swift moderno podríamos usar AsyncStream<[DetectedBarcode]>
    func startScanning(onResult: @escaping ([DetectedBarcode]) -> Void)
    func stopScanning()
}
