import SwiftUI

struct DiscoverDetailView: View {
    let googleBook: GoogleBookItem

    @EnvironmentObject private var myLibraryViewModel: MyLibraryViewModel

    private var mappedBook: Book {
        Book(googleBook: googleBook)
    }

    private var alreadySaved: Bool {
        myLibraryViewModel.contains(bookID: googleBook.id)
    }

    private var coverURL: URL? {
        guard let cover = mappedBook.coverURL else { return nil }
        return URL(string: cover)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                coverImage

                Text(mappedBook.title)
                    .font(AppTheme.headingFont(30))
                    .foregroundStyle(AppTheme.mutedBrown)

                Text(mappedBook.authorText)
                    .font(AppTheme.bodyFont(18))
                    .foregroundStyle(AppTheme.mutedBrown.opacity(0.8))

                metadataSection

                Text("Description")
                    .font(AppTheme.headingFont(24))
                    .foregroundStyle(AppTheme.mutedBrown)

                Text(mappedBook.description.isEmpty ? "No description available." : mappedBook.description)
                    .font(AppTheme.bodyFont(16))
                    .foregroundStyle(AppTheme.mutedBrown.opacity(0.9))

                addButton
            }
            .padding()
        }
        .background(AppTheme.cream.ignoresSafeArea())
        .navigationTitle("Book Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let rating = mappedBook.averageRating {
                Label(String(format: "Public Rating: %.1f", rating), systemImage: "star.fill")
                    .foregroundStyle(AppTheme.accentGold)
                    .font(AppTheme.bodyFont(15))
            } else {
                Text("Public Rating: Not available")
                    .font(AppTheme.bodyFont(15))
                    .foregroundStyle(AppTheme.mutedBrown.opacity(0.75))
            }

            if let publishedDate = mappedBook.publishedDate {
                Text("Published: \(publishedDate)")
                    .font(AppTheme.bodyFont(15))
                    .foregroundStyle(AppTheme.mutedBrown.opacity(0.8))
            }

            if let pageCount = mappedBook.pageCount {
                Text("Pages: \(pageCount)")
                    .font(AppTheme.bodyFont(15))
                    .foregroundStyle(AppTheme.mutedBrown.opacity(0.8))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.cardBeige.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var addButton: some View {
        Button {
            myLibraryViewModel.addGoogleBook(googleBook)
        } label: {
            Text(alreadySaved ? "Already in My Library" : "Add to My Library")
                .font(AppTheme.bodyFont(16))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
        .buttonStyle(.borderedProminent)
        .tint(alreadySaved ? AppTheme.mutedBrown.opacity(0.5) : AppTheme.accentOlive)
        .disabled(alreadySaved)
        .padding(.top, 4)
    }

    private var coverImage: some View {
        AsyncImage(url: coverURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure:
                placeholderCover
            case .empty:
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(AppTheme.cardBeige)
                    ProgressView()
                        .tint(AppTheme.accentOlive)
                }
            @unknown default:
                placeholderCover
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 260)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var placeholderCover: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(AppTheme.cardBeige)

            Image(systemName: "books.vertical")
                .font(.system(size: 44))
                .foregroundStyle(AppTheme.accentOlive)
        }
    }
}

#Preview {
    let sample = GoogleBookItem(
        id: "2",
        volumeInfo: GoogleVolumeInfo(
            title: "The Great Book",
            authors: ["A. Writer"],
            description: "A sample description for preview purposes.",
            averageRating: 4.5,
            publishedDate: "2023-09-01",
            pageCount: 314,
            imageLinks: nil
        )
    )

    NavigationStack {
        DiscoverDetailView(googleBook: sample)
            .environmentObject(MyLibraryViewModel())
    }
}
