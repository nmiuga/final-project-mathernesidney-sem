import Foundation

struct BookList: Identifiable, Codable, Equatable {
    let id: String
    var name: String
    var books: [SavedBook]
    var isDefault: Bool

    init(
        id: String = UUID().uuidString,
        name: String,
        books: [SavedBook] = [],
        isDefault: Bool = false
    ) {
        self.id = id
        self.name = name
        self.books = books
        self.isDefault = isDefault
    }

    var bookCount: Int {
        books.count
    }
}
