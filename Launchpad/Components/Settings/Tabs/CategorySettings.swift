import SwiftUI

struct CategorySettings: View {
   @Binding var categories: [Category]
   let allApps: [AppInfo]

   @State private var newCategoryName = ""
   @State private var showDeleteAlert = false
   @State private var showAutoFillAlert = false
   @State private var selectedCategoryID: UUID?
   @State private var editedName = ""
   @State private var pendingSuggestions: [CategorySuggestion] = []

   var body: some View {
      VStack(alignment: .leading, spacing: 16) {
         Text(L10n.categoriesDescription)
            .font(.subheadline)
            .foregroundColor(.secondary)

         HStack {
            TextField(L10n.categoryName, text: $newCategoryName)
               .textFieldStyle(.roundedBorder)
            Button(action: addCategory) { Image(systemName: "plus.circle.fill") }
               .buttonStyle(.borderedProminent)
               .disabled(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
         }

         Button {
            pendingSuggestions = CategoryClassifier.suggestions(for: allApps)
            showAutoFillAlert = true
         } label: {
            Label(L10n.autoFillCategories, systemImage: "square.grid.2x2")
         }
         .buttonStyle(.bordered)

         if categories.isEmpty {
            Text(L10n.noCategories).foregroundColor(.secondary).italic()
         } else {
            ScrollView {
               VStack(spacing: 8) {
                  ForEach(categories) { category in categoryRow(category) }
                  .onMove { source, destination in
                     categories.move(fromOffsets: source, toOffset: destination)
                  }
               }
            }
         }
      }
      .padding(.horizontal, 8)
      .alert(L10n.deleteCategoryTitle, isPresented: $showDeleteAlert) {
         Button(L10n.cancel, role: .cancel) { selectedCategoryID = nil }
         Button(L10n.deleteCategory, role: .destructive, action: deleteSelectedCategory)
      } message: {
         Text(L10n.deleteCategoryMessage)
      }
      .alert(L10n.autoFillCategories, isPresented: $showAutoFillAlert) {
         Button(L10n.cancel, role: .cancel) { }
         Button(L10n.mergeCategories) {
            categories = CategoryClassifier.merge(pendingSuggestions, into: categories)
         }
         Button(L10n.replaceAllCategories, role: .destructive) {
            categories = CategoryClassifier.replacing(with: pendingSuggestions)
         }
      } message: {
         Text(autoFillSummary)
      }
   }

   @ViewBuilder
   private func categoryRow(_ category: Category) -> some View {
      HStack {
         if selectedCategoryID == category.id {
            TextField(L10n.categoryName, text: $editedName)
               .textFieldStyle(.roundedBorder)
               .onSubmit { saveEdit() }
            Button(L10n.save, action: saveEdit).buttonStyle(.bordered)
            Button(L10n.cancel) { selectedCategoryID = nil }.buttonStyle(.bordered)
         } else {
            Image(systemName: "tag.fill").foregroundColor(.blue)
            Text(category.name)
            Text("(\(category.appPaths.count))").font(.caption).foregroundColor(.secondary)
            Spacer()
            Button {
               selectedCategoryID = category.id
               editedName = category.name
            } label: { Image(systemName: "pencil") }
            .buttonStyle(.plain)
            Button {
               selectedCategoryID = category.id
               showDeleteAlert = true
            } label: { Image(systemName: "trash").foregroundColor(.red) }
            .buttonStyle(.plain)
         }
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .background(RoundedRectangle(cornerRadius: 6).fill(Color.primary.opacity(0.05)))
   }

   private var autoFillSummary: String {
      let matchedPaths = Set(pendingSuggestions.flatMap(\.appPaths))
      let memberships = pendingSuggestions.reduce(0) { $0 + $1.appPaths.count }
      let overlaps = max(memberships - matchedPaths.count, 0)
      return L10n.autoFillCategoriesSummary(
         pendingSuggestions.count,
         matchedPaths.count,
         max(allApps.count - matchedPaths.count, 0),
         overlaps
      )
   }

   private func addCategory() {
      let name = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
      guard !name.isEmpty else { return }
      categories.append(Category(name: name))
      newCategoryName = ""
   }

   private func saveEdit() {
      guard let id = selectedCategoryID,
            let index = categories.firstIndex(where: { $0.id == id }) else { return }
      let name = editedName.trimmingCharacters(in: .whitespacesAndNewlines)
      if !name.isEmpty { categories[index].name = name }
      selectedCategoryID = nil
   }

   private func deleteSelectedCategory() {
      guard let id = selectedCategoryID else { return }
      categories.removeAll { $0.id == id }
      selectedCategoryID = nil
   }
}
