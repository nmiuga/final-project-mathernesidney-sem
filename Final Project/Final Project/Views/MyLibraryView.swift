import SwiftUI

struct MyLibraryView: View {
    @EnvironmentObject private var myLibraryViewModel: MyLibraryViewModel
    @State private var isShowingAddBookView = false

    var body: some View {
        ZStack {
            AppTheme.cream
                .ignoresSafeArea()

            if myLibraryViewModel.books.isEmpty {
                emptyState
            } else {
                libraryList
            }
        }
        .navigationTitle("My Library")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingAddBookView = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add Book")
            }
        }
        .sheet(isPresented: $isShowingAddBookView) {
            NavigationStack {
                AddBookView()
            }
            .environmentObject(myLibraryViewModel)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "books.vertical")
                .font(.system(size: 38))
                .foregroundStyle(AppTheme.accentGold)

            Text("No books added yet.")
                .font(AppTheme.headingFont(24))
                .foregroundStyle(AppTheme.mutedBrown)

            Text("Search in Discover or tap + to add your own.")
                .font(AppTheme.bodyFont(16))
                .foregroundStyle(AppTheme.mutedBrown.opacity(0.75))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }

    private var libraryList: some View {
        List {
            ForEach(myLibraryViewModel.books) { book in
                NavigationLink {
                    LibraryDetailView(bookID: book.id)
                } label: {
                    LibraryBookRow(book: book)
                }
                .listRowBackground(AppTheme.cardBeige.opacity(0.85))
            }
            .onDelete(perform: myLibraryViewModel.deleteBooks)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    NavigationStack {
        MyLibraryView()
            .environmentObject(MyLibraryViewModel())
    }
}
