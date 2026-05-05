# Edits Made

## Architecture Refactor
- Rebuilt the app around three beginner-friendly core models:
  - `Book`
  - `SavedBook`
  - `BookList`
- Updated state management to focus on list-based organization instead of one flat library.

## Models Added/Updated
- `Models/Book.swift`
  - API-ready fields: title, authors, description, cover URL, ratings, published date, page count, categories.
  - Includes API mapping helper and custom manual-book helper.
- `Models/SavedBook.swift`
  - Tracks personal rating, personal note, and date added.
- `Models/BookList.swift`
  - Named list model with `books: [SavedBook]` and default/custom support.
- `Models/GoogleBooksResponse.swift`
  - Expanded decoding to include categories and image links.

## Networking
- `Services/GoogleBooksService.swift`
  - Uses `URLSession` + `async/await` + `Codable`.
  - Returns mapped `[Book]`.
  - Handles readable URL/response/server/decoding errors.

## ViewModels
- `BookSearchViewModel`
  - Added homepage section loading for:
    - Popular Now
    - Fantasy
    - Romance
    - Mystery
    - Science Fiction
    - Young Adult
  - Added search handling with lightweight debounced typing behavior.
  - Supports separate loading/error states for homepage and search.
- `MyLibraryViewModel`
  - Added default lists automatically:
    - Want to Read
    - Reading
    - Finished
  - Added custom list creation.
  - Added add-to-list logic with duplicate prevention per list.
  - Added list/detail helpers and personal note/rating update behavior.
  - Added lightweight `UserDefaults` persistence for all lists/books.

## Views Rebuilt
- Discover side:
  - `DiscoverView`
  - `DiscoverSectionView`
  - `DiscoverBookRow`
  - `DiscoverDetailView`
- Library side:
  - `MyLibraryView`
  - `LibraryListRow`
  - `BookListDetailView`
  - `LibraryBookRow`
  - `LibraryDetailView`
- Add flows:
  - `AddBookSearchView`
  - `AddCustomBookView`
  - `CreateListView`
  - `AddToListSheet`
- Shared:
  - `StarRatingView`

## Behavior Changes
- Discover now works as both homepage browsing + search.
- Add-to-library flow now targets specific user lists.
- My Library now centers on list management and list counts.
- Saved book details now support editable personal rating and note.

## Build
- Recompiled after refactor and resolved compile issues.
