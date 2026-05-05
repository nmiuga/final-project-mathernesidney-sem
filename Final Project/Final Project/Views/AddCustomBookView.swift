import SwiftUI

struct AddCustomBookView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var myLibraryViewModel: MyLibraryViewModel

    @State private var title = ""
    @State private var author = ""
    @State private var description = ""
    @State private var personalNote = ""
    @State private var personalRating = 0
    @State private var selectedListID: String = ""

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !selectedListID.isEmpty
    }

    var body: some View {
        Form {
            Section("Book Info") {
                TextField("Title", text: $title)
                TextField("Author", text: $author)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Description")
                        .font(AppTheme.bodyFont(14))
                        .foregroundStyle(AppTheme.mutedBrown.opacity(0.8))

                    TextEditor(text: $description)
                        .font(AppTheme.bodyFont(15))
                        .frame(minHeight: 110)
                }
            }

            Section("Save To List") {
                Picker("List", selection: $selectedListID) {
                    ForEach(myLibraryViewModel.allLists) { list in
                        Text(list.name).tag(list.id)
                    }
                }
            }

            Section("Personal Details") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Rating")
                        .font(AppTheme.bodyFont(14))
                        .foregroundStyle(AppTheme.mutedBrown)

                    StarRatingView(rating: $personalRating, allowZero: true)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Your Note")
                        .font(AppTheme.bodyFont(14))
                        .foregroundStyle(AppTheme.mutedBrown)

                    TextEditor(text: $personalNote)
                        .font(AppTheme.bodyFont(15))
                        .frame(minHeight: 110)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.cream)
        .navigationTitle("Custom Book")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveBook()
                }
                .disabled(!canSave)
            }
        }
        .task {
            if selectedListID.isEmpty {
                selectedListID = myLibraryViewModel.allLists.first?.id ?? ""
            }
        }
    }

    private func saveBook() {
        let customBook = Book.custom(title: title, author: author, description: description)

        _ = myLibraryViewModel.addBook(
            customBook,
            toListID: selectedListID,
            personalRating: personalRating == 0 ? nil : personalRating,
            personalNote: personalNote
        )

        dismiss()
    }
}
