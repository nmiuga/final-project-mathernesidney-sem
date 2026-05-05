import SwiftUI

struct LibraryDetailView: View {
    let listID: String
    let savedBookID: String

    @EnvironmentObject private var myLibraryViewModel: MyLibraryViewModel

    @State private var personalRating = 0
    @State private var personalNote = ""

    private var savedBook: SavedBook? {
        myLibraryViewModel.savedBook(listID: listID, savedBookID: savedBookID)
    }

    private var coverURL: URL? {
        guard let cover = savedBook?.book.coverURL else { return nil }
        return URL(string: cover)
    }

    var body: some View {
        ScrollView {
            if let savedBook {
                VStack(alignment: .leading, spacing: 16) {
                    coverImage

                    Text(savedBook.book.title)
                        .font(AppTheme.headingFont(30))
                        .foregroundStyle(AppTheme.mutedBrown)

                    Text(savedBook.book.authorText)
                        .font(AppTheme.bodyFont(18))
                        .foregroundStyle(AppTheme.mutedBrown.opacity(0.8))

                    if let averageRating = savedBook.book.averageRating {
                        Label(String(format: "Public Rating: %.1f", averageRating), systemImage: "star.fill")
                            .font(AppTheme.bodyFont(15))
                            .foregroundStyle(AppTheme.accentGold)
                    } else {
                        Text("Public Rating: Not available")
                            .font(AppTheme.bodyFont(15))
                            .foregroundStyle(AppTheme.mutedBrown.opacity(0.75))
                    }

                    if !savedBook.book.description.isEmpty {
                        Text("Description")
                            .font(AppTheme.headingFont(24))
                            .foregroundStyle(AppTheme.mutedBrown)

                        Text(savedBook.book.description)
                            .font(AppTheme.bodyFont(16))
                            .foregroundStyle(AppTheme.mutedBrown.opacity(0.9))
                    }

                    if !savedBook.book.categories.isEmpty {
                        Text("Categories: \(savedBook.book.categoriesText)")
                            .font(AppTheme.bodyFont(15))
                            .foregroundStyle(AppTheme.mutedBrown.opacity(0.8))
                    }

                    personalSection

                    saveButton
                }
                .padding()
            } else {
                Text("This saved book was not found.")
                    .font(AppTheme.bodyFont(16))
                    .foregroundStyle(AppTheme.mutedBrown)
                    .padding()
            }
        }
        .background(AppTheme.cream.ignoresSafeArea())
        .navigationTitle("Saved Book")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: savedBookID) {
            loadCurrentValues()
        }
    }

    private var personalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Rating")
                .font(AppTheme.headingFont(22))
                .foregroundStyle(AppTheme.mutedBrown)

            StarRatingView(rating: $personalRating, allowZero: true)

            Text("Your Note")
                .font(AppTheme.headingFont(22))
                .foregroundStyle(AppTheme.mutedBrown)

            TextEditor(text: $personalNote)
                .font(AppTheme.bodyFont(16))
                .frame(height: 120)
                .padding(8)
                .background(AppTheme.cardBeige.opacity(0.72))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            if personalNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text("No personal note yet.")
                    .font(AppTheme.bodyFont(14))
                    .foregroundStyle(AppTheme.mutedBrown.opacity(0.7))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.cardBeige.opacity(0.52))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var saveButton: some View {
        Button {
            myLibraryViewModel.updateSavedBook(
                listID: listID,
                savedBookID: savedBookID,
                personalRating: personalRating == 0 ? nil : personalRating,
                personalNote: personalNote
            )
        } label: {
            Text("Save Personal Updates")
                .font(AppTheme.bodyFont(16))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
        .buttonStyle(.borderedProminent)
        .tint(AppTheme.accentOlive)
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

            Image(systemName: "book.closed")
                .font(.system(size: 44))
                .foregroundStyle(AppTheme.accentOlive)
        }
    }

    private func loadCurrentValues() {
        guard let current = myLibraryViewModel.savedBook(listID: listID, savedBookID: savedBookID) else { return }
        personalRating = current.personalRating ?? 0
        personalNote = current.personalNote ?? ""
    }
}
