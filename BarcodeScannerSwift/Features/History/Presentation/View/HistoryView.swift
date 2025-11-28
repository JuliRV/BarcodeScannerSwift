import SwiftUI

struct HistoryView: View {
    // Inyectamos el ViewModel.
    // @State hace que la vista sea dueña de este objeto (similar a viewModel() en Compose).
    @State var viewModel: HistoryViewModel
    
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            List {
                ForEach(viewModel.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.code)
                                .font(.headline)
                            Text(BarcodeTypeFormatter.format(item.type))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(item.date, style: .date)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
                .onDelete(perform: viewModel.deleteItem) // Gesto de swipe-to-delete nativo
            }
            .navigationTitle("Historial")
            .toolbar {
                Button(action: {
                    viewModel.clearHistory()
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            .onAppear {
                // Equivalente a LaunchedEffect(Unit)
                viewModel.loadHistory()
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            // Definimos los destinos de navegación aquí o en el Manager si fuera posible, pero navigationDestination debe estar dentro del Stack
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .history:
                    HistoryView(viewModel: viewModel) // O crear una nueva instancia si es necesario
                case .scanner:
                    // Placeholder o vista real
                    Text("Scanner")
                }
            }
        }
    }
}
