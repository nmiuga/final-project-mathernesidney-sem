# Prompt

Create a brand-new SwiftUI iOS app called **BookLibrary** for a student class project.

This app should be built from scratch in a new project and should use the Google Books API with `URLSession` and `async/await` to search for books and fetch book details including title, author, description, average rating, and cover image URL.

The app should feel like a simplified Goodreads-style app where users can discover books, organize books into their own lists, save notes and ratings, and browse by genre.

# Main App Structure

The app must use a `TabView` with exactly two tabs:

1. Discover
2. My Library

Use `NavigationStack` inside each tab.

Suggested SF Symbols:
- Discover: `magnifyingglass`
- My Library: `books.vertical`

The app should use SwiftUI only and should remain beginner/intermediate level and easy to explain in class.

---

# Discover Tab

The Discover tab should work as both:
- a browsing homepage
- a search page

When the Discover tab first opens, it should already be filled with books so the user can browse without searching.

At the top of the Discover page:
- include a search bar
- searching should work by title or author

Behavior:
- if the user enters a search query, show search results
- if the search field is cleared, return to the default browsing homepage

The Discover homepage should contain multiple sections of books, such as:
- Popular Now
- Fantasy
- Romance
- Mystery
- Science Fiction
- Young Adult

Each section should display books fetched from the Google Books API using preset queries.

Suggested queries:
- Popular Now → `"popular fiction"` or `"bestseller books"`
- Fantasy → `"subject:fantasy"`
- Romance → `"subject:romance"`
- Mystery → `"subject:mystery"`
- Science Fiction → `"subject:science fiction"`
- Young Adult → `"subject:young adult"`

Each section should appear separately and have its own heading.

The Discover page should feel full and interesting even before searching.

Each section may use:
- a horizontal scrolling row of books
- or grouped vertical sections

Horizontal rows are preferred if easy.

Each book shown in Discover should display:
- cover image
- title
- author
- average rating if available

Use `AsyncImage` for remote cover images.

If no image is available:
- show a clean placeholder image

---

# Discover Book Detail View

When a user taps a book in Discover or in search results, open a detail screen showing:
- larger cover image
- title
- author(s)
- description
- average/public rating
- published date if available
- page count if available
- categories if available

Instead of a simple “Add to My Library” button, use an **Add to List** button.

Tapping Add to List should:
- present a sheet or menu of the user’s book lists
- let the user choose which list to save the book into

If the book is already in one or more lists:
- indicate that clearly
- example:
  - “Saved in Want to Read”
  - “Already in 2 Lists”

Prevent duplicates inside the same list.

---

# My Library Tab

The My Library tab should no longer be one flat list of books.

Instead, it should focus on user-created named lists.

The main My Library screen should show:
- all book lists the user has created
- default lists already included

Include these default lists automatically:
- Want to Read
- Reading
- Finished

Users should also be able to create custom lists.

Each list row should show:
- list name
- number of books in the list

Example:
- Want to Read (12)
- Favorites (5)
- Fantasy Recs (8)

If there are no custom lists yet, still show the default lists.

The My Library screen should include:
- a plus button in the top right for adding books
- another button or toolbar item for creating a new list

---

# Add Book Flow

The plus button in My Library should NOT immediately open a blank manual-entry form.

Instead, it should open an **Add Book / Search Books** screen connected to the same Google Books API search system used in Discover.

This screen should:
- have a search bar at the top
- search the Google Books API
- display matching books as the user types or when search is submitted

Each result should show:
- cover image
- title
- author

When the user taps a result:
- let the user choose which list to add the book into
- then save the book to that list

This means the Add button should essentially point back to the searchable book library.

---

# Optional Manual Book Entry

Keep a secondary option for manually adding a custom book.

On the Add Book / Search Books screen, include a button such as:
- “Add Custom Book Manually”

This should open a simple form with:
- title
- author
- description
- personal note
- personal rating

Custom books can use a placeholder cover image.

---

# Book List Detail View

When the user taps one of their lists, open a Book List Detail screen.

This screen should show all books inside that list.

Each row should display:
- cover image
- title
- author
- personal rating if available

The user should be able to:
- tap a book for more details
- remove books from the list using swipe-to-delete if simple to implement

---

# Saved Book Detail View

When a user taps a saved book from one of their lists, open a detail view showing:
- cover image
- title
- author
- description
- average/public rating
- personal star rating
- personal note

If there is no note, show:
- “No personal note yet.”

The user should be able to edit:
- their personal note
- their personal star rating

---

# Star Rating Requirements

Create a reusable SwiftUI `StarRatingView`.

Requirements:
- 5 clickable stars
- use SF Symbols:
  - `star`
  - `star.fill`
- allow rating from 1 to 5
- optionally allow 0 as unrated

Use this in:
- manual add book flow
- saved book detail view
- anywhere else helpful

---

# Data Models

Create beginner-friendly models to support:

### Book
Represents a book from the Google Books API.

Fields should include:
- id
- title
- authors
- description
- coverURL
- averageRating
- publishedDate
- pageCount
- categories

### SavedBook
Represents a book saved in a user list.

Fields should include:
- id
- book
- personalRating
- personalNote
- dateAdded

### BookList
Represents a named user list.

Fields should include:
- id
- name
- books: [SavedBook]

---

# State Management

Keep state management simple and readable.

Use:
- `@State`
- `@Binding`
- `@StateObject`
- `ObservableObject`

Suggested ViewModels:
- `BookSearchViewModel`
  - handles searching
  - handles discover homepage sections
  - stores:
    - popularBooks
    - fantasyBooks
    - romanceBooks
    - mysteryBooks
    - sciFiBooks
    - youngAdultBooks
    - searchResults

- `MyLibraryViewModel`
  - handles user lists
  - creating lists
  - adding books to lists
  - editing notes and ratings

Do NOT use:
- Core Data
- SwiftData
- Firebase
- advanced architecture patterns
- UIKit unless absolutely necessary

Simple runtime storage is acceptable, but lightweight `UserDefaults` persistence is okay if it stays simple.

---

# Networking Requirements

Use:
- `URLSession`
- `async/await`
- `Codable`

The app should support:
- loading state
- error state
- empty state

Expected behavior:
- if no search has been entered and Discover is showing default sections, no empty state is needed
- if a search query returns nothing, show:
  - “No books found.”
- while loading, show `ProgressView`
- if an API request fails, show a readable error message

---

# Visual Style

Use a warm, cozy, light-academia style:
- cream background
- beige / taupe cards
- muted brown text
- soft gold or olive accents

The app should feel:
- bookish
- elegant
- cozy
- readable

Use:
- Baskerville for headings if available
- Nunito for body text if available

If custom fonts are not set up, include comments showing where they can be added later.

---

# Suggested File Structure

Please generate the full contents of these files:

1. `BookLibraryApp.swift`
2. `ContentView.swift`

### Models
3. `Models/Book.swift`
4. `Models/SavedBook.swift`
5. `Models/BookList.swift`
6. `Models/GoogleBooksResponse.swift`

### Services
7. `Services/GoogleBooksService.swift`

### ViewModels
8. `ViewModels/BookSearchViewModel.swift`
9. `ViewModels/MyLibraryViewModel.swift`

### Views
10. `Views/DiscoverView.swift`
11. `Views/DiscoverSectionView.swift`
12. `Views/DiscoverBookRow.swift`
13. `Views/DiscoverDetailView.swift`
14. `Views/MyLibraryView.swift`
15. `Views/LibraryListRow.swift`
16. `Views/BookListDetailView.swift`
17. `Views/LibraryBookRow.swift`
18. `Views/LibraryDetailView.swift`
19. `Views/AddBookSearchView.swift`
20. `Views/AddCustomBookView.swift`
21. `Views/CreateListView.swift`
22. `Views/AddToListSheet.swift`
23. `Views/StarRatingView.swift`

### Other Files
24. `prompt.md`
25. `edits.md`
26. `reflection.md`

---

# Optional Features
Only include these if they remain simple:
- save lists to `UserDefaults`
- sort books alphabetically inside lists
- sort lists alphabetically
- swipe-to-delete books
- swipe-to-delete custom lists

---

# Important Constraints
- Keep the code beginner-friendly
- Keep it realistic for a class project
- Make everything compile
- Avoid over-engineering
- Keep architecture simple and easy to explain
- Do not use Kindle APIs
- Do not use private APIs
- Do not use external databases
