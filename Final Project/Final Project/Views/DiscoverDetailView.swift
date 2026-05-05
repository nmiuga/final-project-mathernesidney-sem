import SwiftUI

struct DiscoverDetailView: View {
    let book: Book

    @EnvironmentObject private var myLibraryViewModel: MyLibraryViewModel
    @State private var isShowingAddToListSheet = false

    private var coverURL: URL? {
        guard let cover = book.coverURL else { return nil }
        return URL(string: cover)
    }

    private var savedStatusText: String? {
        let containingLists = myLibraryViewModel.listsContaining(bookID: book.id)

        if containingLists.isEmpty {
            return nil
        }

        if containingLists.count == 1 {
            return "Saved in \(containingLists[0].name)"
        }

        return "Already in \(containingLists.count) Lists"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                coverImage

                Text(book.title)
                    .font(AppTheme.headingFont(30))
                    .foregroundStyle(AppTheme.mutedBrown)

                Text(book.authorText)
                    .font(AppTheme.bodyFont(18))
                    .foregroundStyle(AppTheme.mutedBrown.opacity(0.8))

                metadataSection

                Text("Description")
                    .font(AppTheme.headingFont(24))
                    .foregroundStyle(AppTheme.mutedBrown)

                Text(book.description.isEmpty ? "No description available." : book.description)
                    .font(AppTheme.bodyFont(16))
                    .foregroundStyle(AppTheme.mutedBrown.opacity(0.9))

                Button {
                    isShowingAddToListSheet = true
                } label: {
                    Text("Add to List")
                        .font(AppTheme.bodyFont(16))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.accentOlive)

                if let savedStatusText {
                    Text(savedStatusText)
                        .font(AppTheme.bodyFont(14))
                        .foregroundStyle(AppTheme.mutedBrown.opacity(0.75))
                }
            }
            .padding()
        }
        .background(AppTheme.cream.ignoresSafeArea())
        .navigationTitle("Book Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingAddToListSheet) {
            AddToListSheet(book: book)
                .presentationDetents([.medium, .large])
                .environmentObject(myLibraryViewModel)
        }
    }

    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let rating = book.averageRating {
                Label(String(format: "Public Rating: %.1f", rating), systemImage: "star.fill")
                    .foregroundStyle(AppTheme.accentGold)
                    .font(AppTheme.bodyFont(15))
            } else {
                Text("Public Rating: Not available")
                    .font(AppTheme.bodyFont(15))
                    .foregroundStyle(AppTheme.mutedBrown.opacity(0.75))
            }

            if let publishedDate = book.publishedDate {
                Text("Published: \(publishedDate)")
                    .font(AppTheme.bodyFont(15))
                    .foregroundStyle(AppTheme.mutedBrown.opacity(0.8))
            }

            if let pageCount = book.pageCount {
                Text("Pages: \(pageCount)")
                    .font(AppTheme.bodyFont(15))
                    .foregroundStyle(AppTheme.mutedBrown.opacity(0.8))
            }

            if !book.categories.isEmpty {
                Text("Categories: \(book.categoriesText)")
                    .font(AppTheme.bodyFont(15))
                    .foregroundStyle(AppTheme.mutedBrown.opacity(0.8))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.cardBeige.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 14))
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
