# Prompt

Create a brand-new SwiftUI iOS app named **BookLibrary** for a student class project.

Requirements summary:
- Two tabs inside a `TabView`: **Discover** and **My Library**
- `NavigationStack` inside each tab
- Google Books API search using `URLSession`, `Codable`, and `async/await`
- Discover flow with:
  - searchable query field
  - loading/error/empty/result states
  - row with cover, title, author, and average rating
  - detail page with metadata and Add to My Library button
- My Library flow with:
  - saved books list
  - plus button to manually add a book
  - detail page with personal rating and note
  - reusable 5-star clickable `StarRatingView`
- Beginner-friendly structure with separate files and `// MARK:` comments
- Warm “light academia” styling (cream, beige, muted brown, olive/gold accents)
- Optional simple persistence with `UserDefaults`

Deliver all requested files with full compile-ready SwiftUI code.
