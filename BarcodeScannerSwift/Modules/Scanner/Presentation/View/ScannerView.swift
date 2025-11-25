import SwiftUI

struct ScannerView: View {
    @State private var viewModel: ScannerViewModel
    
    init(viewModel: ScannerViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            ScannerCameraView(
                onScanned: { code, type in
                    viewModel.onCodeDetected(code: code, type: type)
                },
                errorMessage: $viewModel.errorMessage
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
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
                }
            }
        }
    }
}