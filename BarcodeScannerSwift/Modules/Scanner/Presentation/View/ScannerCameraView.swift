import SwiftUI
import AVFoundation

struct ScannerCameraView: UIViewRepresentable {
    @Binding var scannedCode: String?
    @Binding var errorMessage: String?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> CameraPreviewView {
        let view = CameraPreviewView()
        context.coordinator.setupCamera(in: view)
        return view
    }
    
    func updateUIView(_ uiView: CameraPreviewView, context: Context) {
        // Updates if needed
    }
    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: ScannerCameraView
        var captureSession: AVCaptureSession?
        var previewLayer: AVCaptureVideoPreviewLayer?
        var boundingBoxLayer: CAShapeLayer?
        
        init(parent: ScannerCameraView) {
            self.parent = parent
        }
        
        func setupCamera(in view: CameraPreviewView) {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                self.configureSession(in: view)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                    if granted {
                        DispatchQueue.main.async {
                            self?.configureSession(in: view)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.parent.errorMessage = "Permiso de cámara denegado"
                        }
                    }
                }
            case .denied, .restricted:
                parent.errorMessage = "Permiso de cámara denegado. Habilítalo en Configuración."
                return
            @unknown default:
                parent.errorMessage = "Estado de cámara desconocido"
                return
            }
        }
        
        func configureSession(in view: CameraPreviewView) {
            let session = AVCaptureSession()
            self.captureSession = session
            
            // 1. Configurar Input (Cámara Trasera)
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                parent.errorMessage = "No se encontró la cámara trasera. (¿Estás en Simulador?)"
                return
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
            } catch {
                parent.errorMessage = "Error al crear input: \(error.localizedDescription)"
                return
            }
            
            // 2. Configurar Output (Metadata)
            let metadataOutput = AVCaptureMetadataOutput()
            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                // Tipos de códigos a detectar
                metadataOutput.metadataObjectTypes = [.qr, .ean13, .ean8, .code128]
            }
            
            // 3. Configurar Preview Layer
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
            self.previewLayer = previewLayer
            
            // 4. Configurar Bounding Box Layer
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.green.cgColor
            shapeLayer.lineWidth = 3
            shapeLayer.fillColor = UIColor.clear.cgColor
            view.layer.addSublayer(shapeLayer)
            self.boundingBoxLayer = shapeLayer
            
            // Asignar el layer al view para que maneje el layout
            view.previewLayer = previewLayer
            view.boundingBoxLayer = shapeLayer
            
            // Iniciar sesión en background
            DispatchQueue.global(qos: .userInitiated).async {
                session.startRunning()
            }
        }
        
        // Delegate method: Detectar códigos
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            
            // Limpiar bounding box si no hay objetos
            if metadataObjects.isEmpty {
                boundingBoxLayer?.path = nil
                return
            }
            
            // Procesar el primer objeto encontrado
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                // 1. Transformar coordenadas visuales
                guard let transformedObject = previewLayer?.transformedMetadataObject(for: metadataObject) as? AVMetadataMachineReadableCodeObject else {
                    return
                }
                
                // 2. Dibujar Bounding Box
                let path = UIBezierPath(rect: transformedObject.bounds)
                boundingBoxLayer?.path = path.cgPath
                
                // 3. Enviar código detectado (evitar duplicados rápidos si es necesario)
                if let stringValue = metadataObject.stringValue {
                    // Opcional: Feedback háptico
                    if parent.scannedCode == nil { // Solo notificar si es nuevo o resetear lógica
                         AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                         parent.scannedCode = stringValue
                    }
                }
            }
        }
    }
}

// UIView personalizado para manejar el layout de los layers
class CameraPreviewView: UIView {
    var previewLayer: AVCaptureVideoPreviewLayer?
    var boundingBoxLayer: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
        boundingBoxLayer?.frame = bounds
    }
}
