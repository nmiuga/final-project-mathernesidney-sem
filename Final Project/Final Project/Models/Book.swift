import Foundation

struct Book: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let authors: [String]
    let description: String
    let coverURL: String?
    let averageRating: Double?
    let publishedDate: String?
    let pageCount: Int?
    let categories: [String]

    var authorText: String {
        authors.isEmpty ? "Unknown Author" : authors.joined(separator: ", ")
    }

    var categoriesText: String {
        categories.isEmpty ? "No categories" : categories.joined(separator: ", ")
    }

    static func custom(
        title: String,
        author: String,
        description: String
    ) -> Book {
        Book(
            id: UUID().uuidString,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            authors: [author.trimmingCharacters(in: .whitespacesAndNewlines)],
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            coverURL: nil,
            averageRating: nil,
            publishedDate: nil,
            pageCount: nil,
            categories: []
        )
    }
}

// MARK: - API Mapping

extension Book {
    init(googleBook: GoogleBookItem) {
        let info = googleBook.volumeInfo

        self.id = googleBook.id
        self.title = info.title
        self.authors = info.authors ?? []
        self.description = (info.description ?? "No description available.")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        self.coverURL = Book.makeSecureURL(info.imageLinks?.thumbnail ?? info.imageLinks?.smallThumbnail)
        self.averageRating = info.averageRating
        self.publishedDate = info.publishedDate
        self.pageCount = info.pageCount
        self.categories = info.categories ?? []
    }

    private static func makeSecureURL(_ url: String?) -> String? {
        guard let url else { return nil }
        return url.replacingOccurrences(of: "http://", with: "https://")
    }
}
