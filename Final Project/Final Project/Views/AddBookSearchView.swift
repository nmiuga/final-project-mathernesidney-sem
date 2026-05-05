import SwiftUI

struct AddBookSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var myLibraryViewModel: MyLibraryViewModel

    @StateObject private var bookSearchViewModel = BookSearchViewModel()
    @State private var selectedBook: Book?
    @State private var isShowingCustomBookForm = false

    var body: some View {
        ZStack {
            AppTheme.cream.ignoresSafeArea()

            content
        }
        .navigationTitle("Add Book")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .searchable(text: $bookSearchViewModel.searchText, prompt: "Search books to add")
        .onSubmit(of: .search) {
            Task {
                await bookSearchViewModel.searchBooks()
            }
        }
        .onChange(of: bookSearchViewModel.searchText) { _ in
            bookSearchViewModel.onSearchTextChanged()
        }
        .task {
            await bookSearchViewModel.loadSectionsIfNeeded()
        }
        .sheet(item: $selectedBook) { book in
            AddToListSheet(book: book)
                .presentationDetents([.medium, .large])
                .environmentObject(myLibraryViewModel)
        }
        .sheet(isPresented: $isShowingCustomBookForm) {
            NavigationStack {
                AddCustomBookView()
                    .environmentObject(myLibraryViewModel)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        List {
            Section {
                Button {
                    isShowingCustomBookForm = true
                } label: {
                    Label("Add Custom Book Manually", systemImage: "square.and.pencil")
                        .font(AppTheme.bodyFont(15))
                        .foregroundStyle(AppTheme.accentOlive)
                }
            }
            .listRowBackground(AppTheme.cardBeige.opacity(0.8))

            if bookSearchViewModel.isSearching {
                searchResultsSection
            } else {
                popularSuggestionsSection
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }

    @ViewBuilder
    private var searchResultsSection: some View {
        Section("Search Results") {
            if bookSearchViewModel.isLoadingSearch {
                HStack {
                    ProgressView()
                        .tint(AppTheme.accentOlive)
                    Text("Searching...")
                        .font(AppTheme.bodyFont(14))
                        .foregroundStyle(AppTheme.mutedBrown)
                }
            } else if let error = bookSearchViewModel.errorMessage, bookSearchViewModel.searchResults.isEmpty {
                Text(error)
                    .font(AppTheme.bodyFont(14))
                    .foregroundStyle(AppTheme.mutedBrown)
            } else if bookSearchViewModel.searchResults.isEmpty {
                Text("No books found.")
                    .font(AppTheme.bodyFont(14))
                    .foregroundStyle(AppTheme.mutedBrown)
            } else {
                ForEach(bookSearchViewModel.searchResults) { book in
                    Button {
                        selectedBook = book
                    } label: {
                        DiscoverBookRow(book: book)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .listRowBackground(AppTheme.cardBeige.opacity(0.82))
    }

    @ViewBuilder
    private var popularSuggestionsSection: some View {
        Section("Popular Suggestions") {
            if bookSearchViewModel.isLoadingSections && bookSearchViewModel.popularBooks.isEmpty {
                HStack {
                    ProgressView()
                        .tint(AppTheme.accentOlive)
                    Text("Loading suggestions...")
                        .font(AppTheme.bodyFont(14))
                        .foregroundStyle(AppTheme.mutedBrown)
                }
            } else {
                ForEach(bookSearchViewModel.popularBooks) { book in
                    Button {
                        selectedBook = book
                    } label: {
                        DiscoverBookRow(book: book)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .listRowBackground(AppTheme.cardBeige.opacity(0.82))
    }
}
