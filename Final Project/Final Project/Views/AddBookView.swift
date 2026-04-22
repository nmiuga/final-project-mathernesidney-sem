import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var myLibraryViewModel: MyLibraryViewModel

    @State private var title = ""
    @State private var author = ""
    @State private var description = ""
    @State private var personalNote = ""
    @State private var personalRating = 0

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
        .navigationTitle("Add Book")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Add") {
                    saveBook()
                }
                .disabled(!canSave)
            }
        }
    }

    private func saveBook() {
        myLibraryViewModel.addManualBook(
            title: title,
            author: author,
            description: description,
            personalNote: personalNote,
            personalRating: personalRating == 0 ? nil : personalRating
        )
        dismiss()
    }
}

#Preview {
    NavigationStack {
        AddBookView()
            .environmentObject(MyLibraryViewModel())
    }
}
