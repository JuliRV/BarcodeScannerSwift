import SwiftUI

struct ScannerView: View {
    @State private var viewModel: ScannerViewModel
    @State private var isActive = false
    @State private var scanMode: ScanMode = .camera
    @State private var manualCode: String = ""
    
    enum ScanMode {
        case camera
        case keyboard
    }
    
    init(viewModel: ScannerViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            // Fondo negro para cuando no hay cámara
            Color.black.edgesIgnoringSafeArea(.all)
            
            if scanMode == .camera {
                ScannerCameraView(
                    onScanned: { code, type in
                        viewModel.onCodeDetected(code: code, type: type)
                    },
                    errorMessage: $viewModel.errorMessage,
                    isActive: $isActive
                )
                .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                // Selector de Modo
                HStack(spacing: 0) {
                    Button(action: { scanMode = .camera; isActive = true }) {
                        Text("CÁMARA")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(scanMode == .camera ? Color.white : Color.gray.opacity(0.3))
                            .foregroundColor(scanMode == .camera ? .black : .white)
                    }
                    
                    Button(action: { scanMode = .keyboard; isActive = false }) {
                        Text("TECLADO")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(scanMode == .keyboard ? Color.white : Color.gray.opacity(0.3))
                            .foregroundColor(scanMode == .keyboard ? .black : .white)
                    }
                }
                .cornerRadius(10)
                .padding()
                .padding(.top, 40) // Espacio para safe area superior
                
                if scanMode == .camera {
                    Text("ESCANEA EL CODIGO DE BARRAS O QR")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(20)
                        .padding(.top, 10)
                } else {
                    // Vista de Teclado
                    VStack(spacing: 20) {
                        Text("Introduce el código manualmente")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.top, 40)
                        
                        TextField("Código", text: $manualCode)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .foregroundColor(.black)
                        
                        Button(action: {
                            if !manualCode.isEmpty {
                                viewModel.submitManualCode(manualCode)
                                manualCode = ""
                                // Opcional: Ocultar teclado
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        }) {
                            Text("Escanear")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(10)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 1)
                                }
                                .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding()
                }
                
                Spacer()
                
                if let code = viewModel.scannedCode {
                    Text("Código: \(code)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green.opacity(0.9))
                        .cornerRadius(10)
                        .padding(.bottom, 50)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: viewModel.scannedCode)
        }
        .onAppear {
            if scanMode == .camera {
                isActive = true
            }
        }
        .onDisappear {
            isActive = false
        }
    }
}
