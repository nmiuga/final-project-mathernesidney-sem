import Foundation

struct GoogleBooksService {
    private let session: URLSession
    private let apiKey = "AIzaSyCLl7Hvr9m37gIuqSxtGmwMumOu_E_IsNg"

    init(session: URLSession = .shared) {
        self.session = session
    }

    func searchBooks(query: String) async throws -> [GoogleBookItem] {
        var components = URLComponents(string: "https://www.googleapis.com/books/v1/volumes")
        components?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "maxResults", value: "20"),
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
            let decodedResponse = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)
            return decodedResponse.items ?? []
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
            return "Could not create a valid search URL."
        case .invalidResponse:
            return "The server sent an invalid response."
        case .serverError(let statusCode):
            return "Server error (code \(statusCode)). Please try again."
        case .decodingFailed:
            return "Could not read book data from Google Books."
        }
    }
}
