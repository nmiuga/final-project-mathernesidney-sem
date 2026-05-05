import Foundation
import Combine

@MainActor
final class MyLibraryViewModel: ObservableObject {
    @Published private(set) var lists: [BookList] = []

    private let storageKey = "book_library_lists_v2"
    private let defaultNames = ["To Be Read", "Reading", "Finished"]

    init() {
        loadLists()
        ensureDefaultLists()
        sortLists()
        persistLists()
    }

    var defaultLists: [BookList] {
        lists.filter(\.isDefault).sorted { lhs, rhs in
            (defaultNames.firstIndex(of: lhs.name) ?? 999) < (defaultNames.firstIndex(of: rhs.name) ?? 999)
        }
    }

    var customLists: [BookList] {
        lists.filter { !$0.isDefault }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    var allLists: [BookList] {
        defaultLists + customLists
    }

    // MARK: - Lists

    @discardableResult
    func createList(name: String) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else { return false }
        guard !lists.contains(where: { $0.name.caseInsensitiveCompare(trimmed) == .orderedSame }) else {
            return false
        }

        lists.append(BookList(name: trimmed, isDefault: false))
        sortLists()
        persistLists()
        return true
    }

    func deleteCustomLists(at offsets: IndexSet) {
        let custom = customLists

        for index in offsets.sorted(by: >) {
            guard custom.indices.contains(index) else { continue }
            let listID = custom[index].id
            lists.removeAll { $0.id == listID }
        }

        persistLists()
    }

    func list(withID id: String) -> BookList? {
        lists.first(where: { $0.id == id })
    }

    // MARK: - Books In Lists

    @discardableResult
    func addBook(
        _ book: Book,
        toListID listID: String,
        personalRating: Int? = nil,
        personalNote: String? = nil
    ) -> Bool {
        guard let index = lists.firstIndex(where: { $0.id == listID }) else { return false }

        guard !lists[index].books.contains(where: { $0.book.id == book.id }) else {
            return false
        }

        let note = personalNote?.trimmingCharacters(in: .whitespacesAndNewlines)
        let savedBook = SavedBook(
            book: book,
            personalRating: personalRating,
            personalNote: (note?.isEmpty == true) ? nil : note
        )

        lists[index].books.append(savedBook)
        sortBooks(in: index)
        persistLists()
        return true
    }

    func removeBooks(at offsets: IndexSet, fromListID listID: String) {
        guard let index = lists.firstIndex(where: { $0.id == listID }) else { return }

        for offset in offsets.sorted(by: >) {
            guard lists[index].books.indices.contains(offset) else { continue }
            lists[index].books.remove(at: offset)
        }

        persistLists()
    }

    func contains(bookID: String, inListID listID: String) -> Bool {
        guard let list = list(withID: listID) else { return false }
        return list.books.contains(where: { $0.book.id == bookID })
    }

    func listsContaining(bookID: String) -> [BookList] {
        allLists.filter { list in
            list.books.contains(where: { $0.book.id == bookID })
        }
    }

    func savedBook(listID: String, savedBookID: String) -> SavedBook? {
        guard let list = list(withID: listID) else { return nil }
        return list.books.first(where: { $0.id == savedBookID })
    }

    func updateSavedBook(listID: String, savedBookID: String, personalRating: Int?, personalNote: String) {
        guard let listIndex = lists.firstIndex(where: { $0.id == listID }) else { return }
        guard let bookIndex = lists[listIndex].books.firstIndex(where: { $0.id == savedBookID }) else { return }

        let trimmedNote = personalNote.trimmingCharacters(in: .whitespacesAndNewlines)
        lists[listIndex].books[bookIndex].personalRating = personalRating
        lists[listIndex].books[bookIndex].personalNote = trimmedNote.isEmpty ? nil : trimmedNote

        persistLists()
    }

    // MARK: - Private

    private func ensureDefaultLists() {
        for name in defaultNames where !lists.contains(where: { $0.name == name }) {
            lists.append(BookList(name: name, isDefault: true))
        }
    }

    private func sortLists() {
        lists.sort { lhs, rhs in
            if lhs.isDefault != rhs.isDefault {
                return lhs.isDefault && !rhs.isDefault
            }

            if lhs.isDefault {
                return (defaultNames.firstIndex(of: lhs.name) ?? 999) < (defaultNames.firstIndex(of: rhs.name) ?? 999)
            }

            return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
        }
    }

    private func sortBooks(in listIndex: Int) {
        lists[listIndex].books.sort {
            $0.book.title.localizedCaseInsensitiveCompare($1.book.title) == .orderedAscending
        }
    }

    private func persistLists() {
        do {
            let encoded = try JSONEncoder().encode(lists)
            UserDefaults.standard.set(encoded, forKey: storageKey)
        } catch {
            print("Failed to save lists: \(error.localizedDescription)")
        }
    }

    private func loadLists() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }

        do {
            lists = try JSONDecoder().decode([BookList].self, from: data)
        } catch {
            print("Failed to load lists: \(error.localizedDescription)")
            lists = []
        }
    }
}
