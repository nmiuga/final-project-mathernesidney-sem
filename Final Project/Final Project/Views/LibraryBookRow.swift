import SwiftUI

struct LibraryBookRow: View {
    let savedBook: SavedBook

    private var coverURL: URL? {
        guard let cover = savedBook.book.coverURL else { return nil }
        return URL(string: cover)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            coverImage

            VStack(alignment: .leading, spacing: 6) {
                Text(savedBook.book.title)
                    .font(AppTheme.headingFont(18))
                    .foregroundStyle(AppTheme.mutedBrown)
                    .lineLimit(2)

                Text(savedBook.book.authorText)
                    .font(AppTheme.bodyFont(14))
                    .foregroundStyle(AppTheme.mutedBrown.opacity(0.8))
                    .lineLimit(2)

                if let personalRating = savedBook.personalRating {
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(AppTheme.accentGold)
                        Text("Your rating: \(personalRating)/5")
                            .font(AppTheme.bodyFont(13))
                            .foregroundStyle(AppTheme.mutedBrown)
                    }
                } else {
                    Text("No personal rating")
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

            Image(systemName: "book")
                .font(.system(size: 20))
                .foregroundStyle(AppTheme.accentOlive)
        }
    }
}
