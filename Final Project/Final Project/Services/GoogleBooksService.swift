import Foundation

struct GoogleBooksService {
    private let session: URLSession
    private let apiKey = "AIzaSyCLl7Hvr9m37gIuqSxtGmwMumOu_E_IsNg"

    init(session: URLSession = .shared) {
        self.session = session
    }

    func searchBooks(query: String, maxResults: Int = 20) async throws -> [Book] {
        var components = URLComponents(string: "https://www.googleapis.com/books/v1/volumes")
        components?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "maxResults", value: "\(max(1, min(maxResults, 40)))"),
            URLQueryItem(name: "printType", value: "books"),
            URLQueryItem(name: "key", value: apiKey)
        ]

        guard let url = components?.url else {
            throw GoogleBooksServiceError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw GoogleBooksServiceError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw GoogleBooksServiceError.serverError(statusCode: httpResponse.statusCode)
        }

        do {
            let decoded = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)
            return (decoded.items ?? []).map(Book.init(googleBook:))
        } catch {
            throw GoogleBooksServiceError.decodingFailed
        }
    }
}

enum GoogleBooksServiceError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Could not create the request URL."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .serverError(let statusCode):
            return "Google Books request failed (code \(statusCode))."
        case .decodingFailed:
            return "Could not decode book data from Google Books."
        }
    }
}
