import SwiftUI
import Combine


/// Define todas las rutas posibles en la aplicación.
/// Esto actúa como el "Graph" de navegación.
enum Route: Hashable {
    case history
    case scanner
    // Añade aquí más destinos, por ejemplo:
    // case detail(Item)
}

/// Clase encargada de gestionar la navegación de forma centralizada.
/// Funciona como un Coordinator o Router.
final class NavigationManager: ObservableObject {
    /// El path de navegación que controla el stack.
    @Published var path = NavigationPath()
    
    /// Navega a una nueva ruta.
    func push(_ route: Route) {
        path.append(route)
    }
    
    /// Vuelve a la pantalla anterior.
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    /// Vuelve a la raíz del stack.
    func popToRoot() {
        path = NavigationPath()
    }
}
