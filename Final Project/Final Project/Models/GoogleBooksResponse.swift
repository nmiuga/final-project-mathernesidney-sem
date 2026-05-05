import Foundation

struct GoogleBooksResponse: Codable {
    let items: [GoogleBookItem]?
}

struct GoogleBookItem: Codable {
    let id: String
    let volumeInfo: GoogleVolumeInfo
}

struct GoogleVolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let description: String?
    let averageRating: Double?
    let publishedDate: String?
    let pageCount: Int?
    let categories: [String]?
    let imageLinks: GoogleImageLinks?
}

struct GoogleImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}
