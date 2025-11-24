import SwiftUI

struct ScannerView: View {
    @State private var viewModel: ScannerViewModel
    
    init(viewModel: ScannerViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            ScannerCameraView(scannedCode: $viewModel.scannedCode, errorMessage: $viewModel.errorMessage)
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
                    Text("Código detectado: \(code)")
                        .font(.headline)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.bottom, 50)
                }
            }
        }
    }
}