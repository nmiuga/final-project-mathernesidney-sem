import Foundation
import Combine

@MainActor
final class BookSearchViewModel: ObservableObject {
    @Published var searchText: String = ""

    @Published private(set) var popularBooks: [Book] = []
    @Published private(set) var fantasyBooks: [Book] = []
    @Published private(set) var romanceBooks: [Book] = []
    @Published private(set) var mysteryBooks: [Book] = []
    @Published private(set) var sciFiBooks: [Book] = []

    @Published private(set) var searchResults: [Book] = []
    @Published private(set) var isLoadingSections = false
    @Published private(set) var isLoadingSearch = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var hasLoadedSections = false

    private let service: GoogleBooksService
    private var searchTask: Task<Void, Never>?

    init(service: GoogleBooksService = GoogleBooksService()) {
        self.service = service
    }

    var isSearching: Bool {
        !searchText.trimmed.isEmpty
    }

    func loadSectionsIfNeeded() async {
        guard !hasLoadedSections else { return }
        await loadSections()
    }

    func reloadSections() async {
        await loadSections()
    }

    func onSearchTextChanged() {
        searchTask?.cancel()

        guard isSearching else {
            searchResults = []
            isLoadingSearch = false
            errorMessage = nil
            return
        }

        searchTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 350_000_000)
            guard !Task.isCancelled else { return }
            await self?.searchBooks()
        }
    }

    func searchBooks() async {
        let query = searchText.trimmed

        guard !query.isEmpty else {
            searchResults = []
            errorMessage = nil
            isLoadingSearch = false
            return
        }

        isLoadingSearch = true
        errorMessage = nil

        do {
            searchResults = try await service.searchBooks(query: query, maxResults: 30)
        } catch {
            searchResults = []
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Something went wrong."
        }

        isLoadingSearch = false
    }

    deinit {
        searchTask?.cancel()
    }

    // MARK: - Private

    private func loadSections() async {
        isLoadingSections = true
        errorMessage = nil

        do {
            async let popular = service.searchBooks(query: "popular fiction", maxResults: 12)
            async let fantasy = service.searchBooks(query: "subject:fantasy", maxResults: 12)
            async let romance = service.searchBooks(query: "subject:romance", maxResults: 12)
            async let mystery = service.searchBooks(query: "subject:mystery", maxResults: 12)
            async let sciFi = service.searchBooks(query: "subject:science fiction", maxResults: 12)

            popularBooks = try await popular
            fantasyBooks = try await fantasy
            romanceBooks = try await romance
            mysteryBooks = try await mystery
            sciFiBooks = try await sciFi

            hasLoadedSections = true
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Failed to load books."
        }

        isLoadingSections = false
    }
}

private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
