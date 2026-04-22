# Edits Made

## Project Structure
- Replaced starter app entry with `BookLibraryApp.swift`.
- Updated `ContentView.swift` to use a 2-tab layout with `NavigationStack` per tab.
- Added folders and files:
  - `Models/`
  - `Services/`
  - `ViewModels/`
  - `Views/`

## Data Models
- Added `Book` model for app-level storage and library features.
- Added `GoogleBooksResponse` models for API decoding.
- Included mapping from API model to local `Book` model.

## Networking
- Added `GoogleBooksService` using:
  - `URLSession`
  - `async/await`
  - `Codable`
- Implemented error handling for invalid URL/response/server/decode issues.

## ViewModels
- Added `BookSearchViewModel` with discover states:
  - empty prompt
  - loading
  - error
  - no results
  - results
- Added `MyLibraryViewModel` with:
  - add from API
  - add manual book
  - no-duplicate protection
  - update personal rating/note
  - alphabetical sorting
  - delete support
  - `UserDefaults` persistence

## Views
- Added Discover screens:
  - `DiscoverView`
  - `DiscoverBookRow`
  - `DiscoverDetailView`
- Added My Library screens:
  - `MyLibraryView`
  - `LibraryBookRow`
  - `LibraryDetailView`
  - `AddBookView`
- Added reusable `StarRatingView` with 5 clickable stars and optional unrated state.

## Design
- Applied light-academia visual palette with reusable theme values.
- Added font helper functions for Baskerville/Nunito with graceful fallback behavior.
