# Reflection

This build focused on making a class-project app that feels polished but still easy to explain in a walkthrough.

## What Went Well
- The Google Books API integration stayed simple by using one search endpoint and mapping results into a local `Book` model.
- Using separate view models made state handling clear for beginners:
  - `BookSearchViewModel` for API search logic
  - `MyLibraryViewModel` for saved books and personal data
- The reusable `StarRatingView` reduced duplicate code and kept rating behavior consistent across screens.

## Challenges
- API data is inconsistent (missing images, ratings, or descriptions), so defensive UI fallbacks were necessary in almost every view.
- Keeping the app visually cohesive required a central theme setup rather than ad-hoc colors and fonts per screen.

## Improvements for a Future Iteration
- Add debounce search so API requests are not triggered too frequently.
- Add optional filtering/sorting controls in My Library (rating, source type, date added).
- Add lightweight unit tests for model mapping and view model behavior.
- Persist additional metadata like date-added and last-edited.

Overall, the app now meets the project goals: discover books from a real API and save/read/annotate them in a personal library.
