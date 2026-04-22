import SwiftUI

struct DiscoverView: View {
    @StateObject private var searchViewModel = BookSearchViewModel()
    @EnvironmentObject private var myLibraryViewModel: MyLibraryViewModel

    var body: some View {
        ZStack {
            AppTheme.cream
                .ignoresSafeArea()

            content
        }
        .navigationTitle("Discover")
        .searchable(text: $searchViewModel.query, prompt: "Search by title or author")
        .onSubmit(of: .search) {
            Task {
                await searchViewModel.searchBooks()
            }
        }
        .onChange(of: searchViewModel.query) { _, _ in
            searchViewModel.clearSearchIfNeeded()
        }
    }

    // MARK: - Content States

    @ViewBuilder
    private var content: some View {
        let trimmedQuery = searchViewModel.query.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedQuery.isEmpty {
            emptyQueryState
        } else if searchViewModel.isLoading {
            ProgressView("Searching books...")
                .tint(AppTheme.accentOlive)
                .font(AppTheme.bodyFont(17))
        } else if let errorMessage = searchViewModel.errorMessage {
            errorState(message: errorMessage)
        } else if searchViewModel.hasSearched && searchViewModel.books.isEmpty {
            noResultsState
        } else {
            resultsList
        }
    }

    private var emptyQueryState: some View {
        VStack(spacing: 12) {
            Image(systemName: "book.closed")
                .font(.system(size: 38))
                .foregroundStyle(AppTheme.accentGold)

            Text("Search for a title or author.")
                .font(AppTheme.headingFont(22))
                .foregroundStyle(AppTheme.mutedBrown)

            Text("Find your next read with Google Books.")
                .font(AppTheme.bodyFont(16))
                .foregroundStyle(AppTheme.mutedBrown.opacity(0.75))
        }
        .multilineTextAlignment(.center)
        .padding()
    }

    private func errorState(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 32))
                .foregroundStyle(.orange)

            Text(message)
                .font(AppTheme.bodyFont(16))
                .foregroundStyle(AppTheme.mutedBrown)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                Task {
                    await searchViewModel.searchBooks()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.accentOlive)
        }
        .padding()
    }

    private var noResultsState: some View {
        VStack(spacing: 10) {
            Text("No results found.")
                .font(AppTheme.headingFont(24))
                .foregroundStyle(AppTheme.mutedBrown)

            Text("Try another title or author.")
                .font(AppTheme.bodyFont(16))
                .foregroundStyle(AppTheme.mutedBrown.opacity(0.75))
        }
        .padding()
    }

    private var resultsList: some View {
        List(searchViewModel.books) { book in
            NavigationLink {
                DiscoverDetailView(googleBook: book)
            } label: {
                DiscoverBookRow(googleBook: book)
            }
            .listRowBackground(AppTheme.cardBeige.opacity(0.85))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    NavigationStack {
        DiscoverView()
            .environmentObject(MyLibraryViewModel())
    }
}
