import SwiftUI

struct AddToListSheet: View {
    let book: Book

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var myLibraryViewModel: MyLibraryViewModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(book.title)
                            .font(AppTheme.headingFont(22))
                            .foregroundStyle(AppTheme.mutedBrown)

                        Text(book.authorText)
                            .font(AppTheme.bodyFont(14))
                            .foregroundStyle(AppTheme.mutedBrown.opacity(0.75))
                    }
                    .padding(.vertical, 4)
                }
                .listRowBackground(AppTheme.cardBeige.opacity(0.8))

                Section("Choose a List") {
                    ForEach(myLibraryViewModel.allLists) { list in
                        let alreadyInList = myLibraryViewModel.contains(bookID: book.id, inListID: list.id)

                        Button {
                            let added = myLibraryViewModel.addBook(book, toListID: list.id)
                            if added || alreadyInList {
                                dismiss()
                            }
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(list.name)
                                        .font(AppTheme.bodyFont(16))
                                        .foregroundStyle(AppTheme.mutedBrown)

                                    if alreadyInList {
                                        Text("Already in this list")
                                            .font(AppTheme.bodyFont(12))
                                            .foregroundStyle(AppTheme.mutedBrown.opacity(0.7))
                                    }
                                }

                                Spacer()

                                Image(systemName: alreadyInList ? "checkmark.circle.fill" : "plus.circle")
                                    .foregroundStyle(alreadyInList ? AppTheme.accentOlive : AppTheme.accentGold)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .listRowBackground(AppTheme.cardBeige.opacity(0.8))
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(AppTheme.cream)
            .navigationTitle("Add to List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}
