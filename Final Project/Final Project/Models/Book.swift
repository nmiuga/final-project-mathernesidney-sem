import Foundation

enum BookSource: String, Codable {
    case api
    case manual
}

struct Book: Identifiable, Codable, Equatable {
    var id: String
    var title: String
    var authors: [String]
    var description: String
    var coverURL: String?
    var averageRating: Double?
    var publishedDate: String?
    var pageCount: Int?
    var personalRating: Int?
    var personalNote: String?
    var source: BookSource

    var authorText: String {
        authors.isEmpty ? "Unknown Author" : authors.joined(separator: ", ")
    }

    var noteText: String {
        let trimmedNote = (personalNote ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedNote.isEmpty ? "No personal note yet." : trimmedNote
    }

    static func manual(
        title: String,
        author: String,
        description: String,
        personalNote: String,
        personalRating: Int?
    ) -> Book {
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNote = personalNote.trimmingCharacters(in: .whitespacesAndNewlines)

        return Book(
            id: UUID().uuidString,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            authors: [author.trimmingCharacters(in: .whitespacesAndNewlines)],
            description: trimmedDescription,
            coverURL: nil,
            averageRating: nil,
            publishedDate: nil,
            pageCount: nil,
            personalRating: personalRating,
            personalNote: trimmedNote.isEmpty ? nil : trimmedNote,
            source: .manual
        )
    }
}

// MARK: - Mapping From API Model

extension Book {
    init(googleBook: GoogleBookItem) {
        let info = googleBook.volumeInfo

        self.id = googleBook.id
        self.title = info.title
        self.authors = info.authors ?? ["Unknown Author"]
        self.description = (info.description ?? "No description available.")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        self.coverURL = Book.secureURL(from: info.coverURLString)
        self.averageRating = info.averageRating
        self.publishedDate = info.publishedDate
        self.pageCount = info.pageCount
        self.personalRating = nil
        self.personalNote = nil
        self.source = .api
    }

    private static func secureURL(from rawURL: String?) -> String? {
        guard let rawURL else { return nil }
        return rawURL.replacingOccurrences(of: "http://", with: "https://")
    }
}
