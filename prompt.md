# Prompt

Build a brand-new SwiftUI iOS app named **BookLibrary** for a class project.

## Core requirements
- `TabView` with exactly two tabs:
  - Discover
  - My Library
- `NavigationStack` inside each tab
- Use Google Books API with:
  - `URLSession`
  - `async/await`
  - `Codable`

## Discover tab
- Acts as both homepage and search page.
- Homepage loads immediately with browsing sections:
  - Popular Now
  - Fantasy
  - Romance
  - Mystery
  - Science Fiction
  - Young Adult
- Search by title or author.
- Clearing search returns to homepage sections.

## Book details
- Show full details and metadata.
- Use **Add to List** behavior instead of one global save button.
- Prevent duplicates inside the same list.

## My Library tab
- Focus on named lists, not one flat list.
- Include default lists:
  - Want to Read
  - Reading
  - Finished
- Allow custom list creation.
- Show list counts and list detail views.

## Add flow
- `+` opens search-based add flow (API-backed), not manual form first.
- Include a secondary option to manually add custom books.

## Personal data
- Reusable `StarRatingView` (5 clickable stars).
- Saved book detail allows editing personal note + personal rating.

## Style
- Warm light-academia visuals (cream/beige/taupe, muted brown text, olive/gold accents).
- Baskerville/Nunito preferred with graceful fallback.

## Constraints
- Beginner-friendly and easy to explain in class.
- No Core Data, SwiftData, Firebase, or over-engineered architecture.
- Keep project realistic, clean, and compile-ready.
