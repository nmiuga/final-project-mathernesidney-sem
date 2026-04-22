import Foundation
import Combine

@MainActor
final class BookSearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var books: [GoogleBookItem] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var hasSearched: Bool = false

    private let service: GoogleBooksService

    init(service: GoogleBooksService) {
        self.service = service
    }

    init() {
        self.service = GoogleBooksService()
    }

    func searchBooks() async {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedQuery.isEmpty else {
            books = []
            errorMessage = nil
            hasSearched = false
            return
        }

        isLoading = true
        errorMessage = nil
        hasSearched = true

        do {
            books = try await service.searchBooks(query: trimmedQuery)
        } catch {
            books = []
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Something went wrong."
        }

        isLoading = false
    }

    func clearSearchIfNeeded() {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            books = []
            errorMessage = nil
            hasSearched = false
        }
    }
}
