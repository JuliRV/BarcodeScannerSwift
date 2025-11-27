import SwiftUI

struct ScannerView: View {
    @State private var viewModel: ScannerViewModel
    @State private var isActive = false
    
    init(viewModel: ScannerViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            ScannerCameraView(
                onScanned: { code, type in
                    viewModel.onCodeDetected(code: code, type: type)
                },
                errorMessage: $viewModel.errorMessage,
                isActive: $isActive
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("ESCANEA EL CODIGO DE BARRAS O QR")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(20)
                    .padding(.top, 50)
                
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
            isActive = true
        }
        .onDisappear {
            isActive = false
        }
    }
}