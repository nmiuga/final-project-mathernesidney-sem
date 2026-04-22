import Foundation
import Combine

@MainActor
final class MyLibraryViewModel: ObservableObject {
    @Published private(set) var books: [Book] = []

    private let storageKey = "book_library_saved_books"

    init() {
        loadBooks()
    }

    // MARK: - Public Actions

    func contains(bookID: String) -> Bool {
        books.contains(where: { $0.id == bookID })
    }

    func addGoogleBook(_ googleBook: GoogleBookItem) {
        let mappedBook = Book(googleBook: googleBook)
        addBook(mappedBook)
    }

    func addManualBook(
        title: String,
        author: String,
        description: String,
        personalNote: String,
        personalRating: Int?
    ) {
        let manualBook = Book.manual(
            title: title,
            author: author,
            description: description,
            personalNote: personalNote,
            personalRating: personalRating
        )
        addBook(manualBook)
    }

    func deleteBooks(at offsets: IndexSet) {
        for index in offsets.sorted(by: >) {
            books.remove(at: index)
        }
        persistBooks()
    }

    func book(withID id: String) -> Book? {
        books.first(where: { $0.id == id })
    }

    func updatePersonalInfo(for id: String, rating: Int?, note: String) {
        guard let index = books.firstIndex(where: { $0.id == id }) else { return }

        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        books[index].personalRating = rating
        books[index].personalNote = trimmedNote.isEmpty ? nil : trimmedNote

        persistBooks()
    }

    // MARK: - Private Helpers

    private func addBook(_ book: Book) {
        guard !contains(bookID: book.id) else { return }

        books.append(book)
        sortBooks()
        persistBooks()
    }

    private func sortBooks() {
        books.sort {
            $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
        }
    }

    private func persistBooks() {
        do {
            let data = try JSONEncoder().encode(books)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Failed to save books: \(error.localizedDescription)")
        }
    }

    private func loadBooks() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }

        do {
            books = try JSONDecoder().decode([Book].self, from: data)
            sortBooks()
        } catch {
            print("Failed to load saved books: \(error.localizedDescription)")
            books = []
        }
    }
}
