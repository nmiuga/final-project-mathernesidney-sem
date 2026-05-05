import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject private var bookSearchViewModel: BookSearchViewModel

    var body: some View {
        ZStack {
            AppTheme.cream.ignoresSafeArea()

            content
        }
        .navigationTitle("Discover")
        .searchable(text: $bookSearchViewModel.searchText, prompt: "Search by title or author")
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
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if bookSearchViewModel.isSearching {
            searchContent
        } else {
            discoverHomeContent
        }
    }

    @ViewBuilder
    private var searchContent: some View {
        if bookSearchViewModel.isLoadingSearch {
            ProgressView("Searching books...")
                .tint(AppTheme.accentOlive)
        } else if let error = bookSearchViewModel.errorMessage, bookSearchViewModel.searchResults.isEmpty {
            stateMessage(title: "Search Error", message: error)
        } else if bookSearchViewModel.searchResults.isEmpty {
            stateMessage(title: "No books found.", message: "Try a different title or author.")
        } else {
            List(bookSearchViewModel.searchResults) { book in
                NavigationLink {
                    DiscoverDetailView(book: book)
                } label: {
                    DiscoverBookRow(book: book)
                }
                .listRowBackground(AppTheme.cardBeige.opacity(0.8))
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }

    @ViewBuilder
    private var discoverHomeContent: some View {
        if bookSearchViewModel.isLoadingSections && allSectionBooksAreEmpty {
            ProgressView("Loading Discover...")
                .tint(AppTheme.accentOlive)
        } else if let error = bookSearchViewModel.errorMessage, allSectionBooksAreEmpty {
            VStack(spacing: 12) {
                stateMessage(title: "Couldn’t load books", message: error)
                Button("Try Again") {
                    Task {
                        await bookSearchViewModel.reloadSections()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.accentOlive)
            }
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header

                    DiscoverSectionView(title: "Popular Now", books: bookSearchViewModel.popularBooks)
                    DiscoverSectionView(title: "Fantasy", books: bookSearchViewModel.fantasyBooks)
                    DiscoverSectionView(title: "Romance", books: bookSearchViewModel.romanceBooks)
                    DiscoverSectionView(title: "Mystery", books: bookSearchViewModel.mysteryBooks)
                    DiscoverSectionView(title: "Science Fiction", books: bookSearchViewModel.sciFiBooks)
                    DiscoverSectionView(title: "Young Adult", books: bookSearchViewModel.youngAdultBooks)
                }
                .padding(.vertical)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Browse Your Next Read")
                .font(AppTheme.headingFont(32))
                .foregroundStyle(AppTheme.mutedBrown)

            Text("Explore popular shelves, genres, and favorites.")
                .font(AppTheme.bodyFont(16))
                .foregroundStyle(AppTheme.mutedBrown.opacity(0.75))
        }
        .padding(.horizontal)
    }

    private var allSectionBooksAreEmpty: Bool {
        bookSearchViewModel.popularBooks.isEmpty &&
        bookSearchViewModel.fantasyBooks.isEmpty &&
        bookSearchViewModel.romanceBooks.isEmpty &&
        bookSearchViewModel.mysteryBooks.isEmpty &&
        bookSearchViewModel.sciFiBooks.isEmpty &&
        bookSearchViewModel.youngAdultBooks.isEmpty
    }

    private func stateMessage(title: String, message: String) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .font(AppTheme.headingFont(24))
                .foregroundStyle(AppTheme.mutedBrown)

            Text(message)
                .font(AppTheme.bodyFont(16))
                .foregroundStyle(AppTheme.mutedBrown.opacity(0.75))
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
