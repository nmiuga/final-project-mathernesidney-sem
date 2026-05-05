import SwiftUI

struct BookListDetailView: View {
    let listID: String

    @EnvironmentObject private var myLibraryViewModel: MyLibraryViewModel

    private var list: BookList? {
        myLibraryViewModel.list(withID: listID)
    }

    var body: some View {
        ZStack {
            AppTheme.cream.ignoresSafeArea()

            if let list {
                if list.books.isEmpty {
                    VStack(spacing: 10) {
                        Text("No books in this list yet.")
                            .font(AppTheme.headingFont(24))
                            .foregroundStyle(AppTheme.mutedBrown)

                        Text("Use + in My Library to add books.")
                            .font(AppTheme.bodyFont(15))
                            .foregroundStyle(AppTheme.mutedBrown.opacity(0.75))
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                } else {
                    List {
                        ForEach(list.books) { savedBook in
                            NavigationLink {
                                LibraryDetailView(listID: listID, savedBookID: savedBook.id)
                            } label: {
                                LibraryBookRow(savedBook: savedBook)
                            }
                            .listRowBackground(AppTheme.cardBeige.opacity(0.82))
                        }
                        .onDelete { offsets in
                            myLibraryViewModel.removeBooks(at: offsets, fromListID: listID)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            } else {
                Text("This list no longer exists.")
                    .font(AppTheme.bodyFont(16))
                    .foregroundStyle(AppTheme.mutedBrown)
            }
        }
        .navigationTitle(list?.name ?? "List")
        .navigationBarTitleDisplayMode(.inline)
    }
}
