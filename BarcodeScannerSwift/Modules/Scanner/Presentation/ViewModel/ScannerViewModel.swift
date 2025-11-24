//
//  ScannerViewModel.swift
//  BarcodeScannerSwift
//
//  Created by Julian Regueira on 20/11/25.
//

import Foundation
import Observation

@Observable
class ScannerViewModel {
    
    // DEPENDENCIAS
    private let saveBarcodeUseCase: SaveBarcodeUseCase
    
    // ESTADO
    var scannedCode: String?
    var errorMessage: String?
    
    init(saveBarcodeUseCase: SaveBarcodeUseCase) {
        self.saveBarcodeUseCase = saveBarcodeUseCase
    }
}
