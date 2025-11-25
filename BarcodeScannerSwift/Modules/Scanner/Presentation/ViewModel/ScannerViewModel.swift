//
//  ScannerViewModel.swift
//  BarcodeScannerSwift
//
//  Created by Julian Regueira on 20/11/25.
//

import Foundation
import Observation
import AudioToolbox

@Observable
class ScannerViewModel {
    
    // DEPENDENCIAS
    private let saveBarcodeUseCase: SaveBarcodeUseCase
    
    // ESTADO
    var scannedCode: String?
    var errorMessage: String?
    
    // PRIVADO
    private var lastScanTime: [String: Date] = [:]
    private let throttleInterval: TimeInterval = 30.0
    
    init(saveBarcodeUseCase: SaveBarcodeUseCase) {
        self.saveBarcodeUseCase = saveBarcodeUseCase
    }
    
    func onCodeDetected(code: String, type: String) {
        self.scannedCode = code
        
        let now = Date()
        if let lastTime = lastScanTime[code], now.timeIntervalSince(lastTime) < throttleInterval {
            return // Ignorar si se escaneó hace poco
        }
        
        lastScanTime[code] = now
        saveCode(code: code, type: type)
    }
    
    private func saveCode(code: String, type: String) {
        do {
            try saveBarcodeUseCase.execute(code: code, type: type)
            // Vibrar SOLO cuando se guarda exitosamente
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            print("Código guardado: \(code)")
        } catch {
            errorMessage = "Error al guardar: \(error.localizedDescription)"
        }
    }
}
