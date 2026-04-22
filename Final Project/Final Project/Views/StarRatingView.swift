import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int

    var maxRating: Int = 5
    var allowZero: Bool = true
    var starSize: CGFloat = 24

    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...maxRating, id: \.self) { index in
                Button {
                    if allowZero && rating == index {
                        rating = 0
                    } else {
                        rating = index
                    }
                } label: {
                    Image(systemName: rating >= index ? "star.fill" : "star")
                        .font(.system(size: starSize))
                        .foregroundStyle(rating >= index ? AppTheme.accentGold : AppTheme.mutedBrown.opacity(0.45))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Rate \(index) star\(index == 1 ? "" : "s")")
            }
        }
    }
}

#Preview {
    StarRatingPreviewWrapper()
}

private struct StarRatingPreviewWrapper: View {
    @State private var rating = 3

    var body: some View {
        StarRatingView(rating: $rating, allowZero: true)
            .padding()
            .background(AppTheme.cream)
    }
}
