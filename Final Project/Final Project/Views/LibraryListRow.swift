import SwiftUI

struct LibraryListRow: View {
    let list: BookList

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(list.name)
                    .font(AppTheme.headingFont(20))
                    .foregroundStyle(AppTheme.mutedBrown)

                Text("\(list.bookCount) book\(list.bookCount == 1 ? "" : "s")")
                    .font(AppTheme.bodyFont(14))
                    .foregroundStyle(AppTheme.mutedBrown.opacity(0.75))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(AppTheme.mutedBrown.opacity(0.6))
        }
        .padding(.vertical, 8)
    }
}
