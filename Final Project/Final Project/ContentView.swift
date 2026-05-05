import SwiftUI

struct ContentView: View {
    @StateObject private var bookSearchViewModel = BookSearchViewModel()
    @StateObject private var myLibraryViewModel = MyLibraryViewModel()

    var body: some View {
        TabView {
            NavigationStack {
                DiscoverView()
            }
            .tabItem {
                Label("Discover", systemImage: "magnifyingglass")
            }

            NavigationStack {
                MyLibraryView()
            }
            .tabItem {
                Label("My Library", systemImage: "books.vertical")
            }
        }
        .environmentObject(bookSearchViewModel)
        .environmentObject(myLibraryViewModel)
        .tint(AppTheme.accentOlive)
    }
}

// MARK: - App Theme

enum AppTheme {
    static let cream = Color(red: 0.97, green: 0.95, blue: 0.90)
    static let cardBeige = Color(red: 0.91, green: 0.87, blue: 0.80)
    static let mutedBrown = Color(red: 0.31, green: 0.25, blue: 0.19)
    static let accentGold = Color(red: 0.74, green: 0.62, blue: 0.33)
    static let accentOlive = Color(red: 0.45, green: 0.49, blue: 0.33)

    static func headingFont(_ size: CGFloat) -> Font {
        // Add Baskerville to your project for guaranteed custom headings.
        // This falls back gracefully if the font is not installed.
        .custom("Baskerville", size: size)
    }

    static func bodyFont(_ size: CGFloat) -> Font {
        // Add Nunito to your project for guaranteed body typography.
        // This falls back gracefully if the font is not installed.
        .custom("Nunito-Regular", size: size)
    }
}

#Preview {
    ContentView()
}
