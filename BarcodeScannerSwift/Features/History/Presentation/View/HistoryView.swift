import SwiftUI

struct HistoryView: View {
    // Inyectamos el ViewModel.
    // @State hace que la vista sea dueña de este objeto (similar a viewModel() en Compose).
    @State var viewModel: HistoryViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.code)
                                .font(.headline)
                            Text(item.type)
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
                Button(action: viewModel.addMockItem) {
                    Image(systemName: "plus")
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
        }
    }
}
