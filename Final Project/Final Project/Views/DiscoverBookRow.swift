import SwiftUI

struct DiscoverBookRow: View {
    let googleBook: GoogleBookItem

    private var title: String { googleBook.volumeInfo.title }
    private var authorText: String {
        (googleBook.volumeInfo.authors ?? ["Unknown Author"]).joined(separator: ", ")
    }
    private var coverURL: URL? {
        guard let urlString = googleBook.volumeInfo.coverURLString else { return nil }
        return URL(string: urlString.replacingOccurrences(of: "http://", with: "https://"))
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            coverImage

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(AppTheme.headingFont(18))
                    .foregroundStyle(AppTheme.mutedBrown)
                    .lineLimit(2)

                Text(authorText)
                    .font(AppTheme.bodyFont(14))
                    .foregroundStyle(AppTheme.mutedBrown.opacity(0.8))
                    .lineLimit(2)

                if let averageRating = googleBook.volumeInfo.averageRating {
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(AppTheme.accentGold)

                        Text(String(format: "%.1f", averageRating))
                            .font(AppTheme.bodyFont(14))
                            .foregroundStyle(AppTheme.mutedBrown)
                    }
                } else {
                    Text("No public rating")
                        .font(AppTheme.bodyFont(13))
                        .foregroundStyle(AppTheme.mutedBrown.opacity(0.65))
                }
            }
        }
        .padding(.vertical, 6)
    }

    private var coverImage: some View {
        AsyncImage(url: coverURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                placeholder
            case .empty:
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppTheme.cardBeige)
                    ProgressView()
                        .tint(AppTheme.accentOlive)
                }
            @unknown default:
                placeholder
            }
        }
        .frame(width: 60, height: 90)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(AppTheme.cardBeige)

            Image(systemName: "book.closed")
                .font(.system(size: 20))
                .foregroundStyle(AppTheme.accentOlive)
        }
    }
}

#Preview {
    let sample = GoogleBookItem(
        id: "1",
        volumeInfo: GoogleVolumeInfo(
            title: "Sample Book",
            authors: ["Sample Author"],
            description: "Sample",
            averageRating: 4.2,
            publishedDate: "2024",
            pageCount: 280,
            imageLinks: nil
        )
    )

    DiscoverBookRow(googleBook: sample)
        .padding()
        .background(AppTheme.cream)
}
