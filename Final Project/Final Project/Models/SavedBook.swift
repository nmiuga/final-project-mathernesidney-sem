import Foundation

struct SavedBook: Identifiable, Codable, Equatable {
    let id: String
    var book: Book
    var personalRating: Int?
    var personalNote: String?
    let dateAdded: Date

    init(
        id: String = UUID().uuidString,
        book: Book,
        personalRating: Int? = nil,
        personalNote: String? = nil,
        dateAdded: Date = Date()
    ) {
        self.id = id
        self.book = book
        self.personalRating = personalRating
        self.personalNote = personalNote
        self.dateAdded = dateAdded
    }

    var noteText: String {
        let trimmed = (personalNote ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "No personal note yet." : trimmed
    }
}
