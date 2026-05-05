import SwiftUI

struct MyLibraryView: View {
    @EnvironmentObject private var myLibraryViewModel: MyLibraryViewModel

    @State private var isShowingAddBookSearch = false
    @State private var isShowingCreateList = false

    var body: some View {
        ZStack {
            AppTheme.cream.ignoresSafeArea()

            List {
                Section("Default Lists") {
                    ForEach(myLibraryViewModel.defaultLists) { list in
                        NavigationLink {
                            BookListDetailView(listID: list.id)
                        } label: {
                            LibraryListRow(list: list)
                        }
                        .listRowBackground(AppTheme.cardBeige.opacity(0.82))
                    }
                }

                Section("Custom Lists") {
                    if myLibraryViewModel.customLists.isEmpty {
                        Text("Create your first custom list to organize favorites.")
                            .font(AppTheme.bodyFont(14))
                            .foregroundStyle(AppTheme.mutedBrown.opacity(0.75))
                            .listRowBackground(AppTheme.cardBeige.opacity(0.7))
                    } else {
                        ForEach(myLibraryViewModel.customLists) { list in
                            NavigationLink {
                                BookListDetailView(listID: list.id)
                            } label: {
                                LibraryListRow(list: list)
                            }
                            .listRowBackground(AppTheme.cardBeige.opacity(0.82))
                        }
                        .onDelete(perform: myLibraryViewModel.deleteCustomLists)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("My Library")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    isShowingCreateList = true
                } label: {
                    Label("New List", systemImage: "folder.badge.plus")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingAddBookSearch = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add Book")
            }
        }
        .sheet(isPresented: $isShowingAddBookSearch) {
            NavigationStack {
                AddBookSearchView()
                    .environmentObject(myLibraryViewModel)
            }
        }
        .sheet(isPresented: $isShowingCreateList) {
            NavigationStack {
                CreateListView()
                    .environmentObject(myLibraryViewModel)
            }
        }
    }
}
