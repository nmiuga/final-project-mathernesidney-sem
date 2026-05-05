import SwiftUI

struct DiscoverSectionView: View {
    let title: String
    let books: [Book]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(AppTheme.headingFont(26))
                .foregroundStyle(AppTheme.mutedBrown)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(books) { book in
                        NavigationLink {
                            DiscoverDetailView(book: book)
                        } label: {
                            DiscoverSectionBookCard(book: book)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

private struct DiscoverSectionBookCard: View {
    let book: Book

    private var coverURL: URL? {
        guard let cover = book.coverURL else { return nil }
        return URL(string: cover)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppTheme.cardBeige)
                        ProgressView()
                            .tint(AppTheme.accentOlive)
                    }
                @unknown default:
                    placeholder
                }
            }
            .frame(width: 120, height: 170)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(book.title)
                .font(AppTheme.headingFont(16))
                .foregroundStyle(AppTheme.mutedBrown)
                .lineLimit(2)

            Text(book.authorText)
                .font(AppTheme.bodyFont(13))
                .foregroundStyle(AppTheme.mutedBrown.opacity(0.75))
                .lineLimit(1)

            if let rating = book.averageRating {
                Label(String(format: "%.1f", rating), systemImage: "star.fill")
                    .font(AppTheme.bodyFont(12))
                    .foregroundStyle(AppTheme.accentGold)
            }
        }
        .frame(width: 130, alignment: .leading)
        .padding(10)
        .background(AppTheme.cardBeige.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(AppTheme.cardBeige)

            Image(systemName: "book.closed")
                .font(.system(size: 30))
                .foregroundStyle(AppTheme.accentOlive)
        }
    }
}
