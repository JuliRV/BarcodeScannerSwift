import SwiftUI
import SwiftData

@main
struct BarcodeScannerSwiftApp: App {
    // Inicializamos el contenedor de dependencias (que a su vez inicia SwiftData)
    @State private var appDIContainer = AppDIContainer()

    var body: some Scene {
        WindowGroup {
            TabView {
                // --- FEATURE: HISTORY ---
                // Usamos el Factory del Container
                HistoryView(viewModel: appDIContainer.makeHistoryViewModel())
                    .tabItem {
                        Label("Historial", systemImage: "list.bullet")
                    }
                
                // --- MODULE: SCANNER ---
                ScannerView(viewModel: appDIContainer.makeScannerViewModel())
                    .tabItem {
                        Label("Escanear", systemImage: "qrcode.viewfinder")
                    }
            }
        }
        // Inyectamos el ModelContainer de SwiftData al entorno por si alguna View lo usa con @Query
        .modelContainer(appDIContainer.sharedModelContainer)
    }
}
