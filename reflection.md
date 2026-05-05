# Reflection

This version shifts the project from a basic save-list app into a more realistic mini Goodreads-style experience while staying class-friendly.

## What Worked Well
- The list-based data model (`Book`, `SavedBook`, `BookList`) made features easier to reason about.
- Separating discover logic (`BookSearchViewModel`) from library logic (`MyLibraryViewModel`) kept the code readable.
- Reusing one `AddToListSheet` in multiple places reduced duplicate UI code and made behavior consistent.

## Main Challenges
- Keeping Discover both browsable and searchable required clear UI-state branching:
  - section homepage when search is empty
  - search results when query exists
- Preventing duplicates in a list while still allowing the same book in different lists required careful list-level checks.
- Personal notes/ratings belong to saved entries, not the shared `Book` object, which required modeling with `SavedBook`.

## Why This Is Good for Class Presentation
- The app demonstrates real API usage with modern Swift concurrency.
- The architecture is simple enough to explain quickly (models -> service -> view models -> views).
- The UI feels polished and portfolio-ready without using advanced frameworks.

## Next Improvements (Optional)
- Add small loading placeholders (skeleton cards) for homepage sections.
- Add reorder support for custom lists.
- Add optional filter/sort controls inside each list.
- Move API key to a config file or environment-based setup for safer sharing.
