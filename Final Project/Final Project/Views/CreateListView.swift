import SwiftUI

struct CreateListView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var myLibraryViewModel: MyLibraryViewModel

    @State private var listName = ""
    @State private var errorMessage: String?

    var body: some View {
        Form {
            Section("New List") {
                TextField("List name", text: $listName)
                    .font(AppTheme.bodyFont(16))

                if let errorMessage {
                    Text(errorMessage)
                        .font(AppTheme.bodyFont(14))
                        .foregroundStyle(.red)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.cream)
        .navigationTitle("Create List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Create") {
                    createList()
                }
            }
        }
    }

    private func createList() {
        let success = myLibraryViewModel.createList(name: listName)

        if success {
            dismiss()
        } else {
            errorMessage = "Use a unique list name and try again."
        }
    }
}
