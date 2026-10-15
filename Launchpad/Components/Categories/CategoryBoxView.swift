import SwiftUI

struct CategoryBoxView: View {
   let category: Category
   let allApps: [AppInfo]
   let settings: LaunchpadSettings
   let layout: LayoutMetrics
   let cardHeight: CGFloat
   let onItemTap: (AppGridItem) -> Void

   @Environment(\.colorScheme) private var colorScheme

   private var categoryApps: [AppInfo] {
      CategoryManager.shared.getAppsForCategory(category: category, from: allApps)
   }

   private var capacity: Int {
      settings.categoryColumns * settings.categoryRows
   }

   private var hasOverflow: Bool {
      categoryApps.count > capacity
   }

   private var previewApps: [AppInfo] {
      Array(categoryApps.prefix(hasOverflow ? capacity - 1 : capacity))
   }

   private var moreApps: [AppInfo] {
      guard hasOverflow else { return [] }
      return Array(categoryApps.dropFirst(capacity - 1).prefix(4))
   }

   private var additionalCount: Int {
      max(categoryApps.count - (capacity - 1), 0)
   }

   var body: some View {
      VStack(alignment: .leading, spacing: 12) {
         Text(category.name)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.primary)
            .padding(.leading, 16)
            .padding(.top, 16)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
            .help(category.name)
            .contentShape(Rectangle())
            .onTapGesture { openCategory() }

         LazyVGrid(
            columns: GridLayoutUtility.createFlexibleGridColumns(count: settings.categoryColumns, spacing: 12),
            spacing: 8
         ) {
            ForEach(previewApps) { app in
               AppIconView(app: app, layout: layout, scale: 1.0)
                  .onTapGesture { onItemTap(.app(app)) }
            }

            if hasOverflow {
               moreAppsCluster()
            }

            // Fill remaining spots with placeholders
            ForEach(0..<max(0, capacity - previewApps.count - (hasOverflow ? 1 : 0)), id: \.self) { _ in
               placeholderBox()
            }
         }
         .padding(.horizontal, 16)
         .padding(.bottom, 16)
      }
      .frame(maxWidth: .infinity, minHeight: cardHeight, maxHeight: cardHeight, alignment: .top)
      .background(
         RoundedRectangle(cornerRadius: 20)
            .fill(.regularMaterial.opacity(0.6 * settings.transparency))
            .overlay(
               RoundedRectangle(cornerRadius: 20)
                  .fill(
                     LinearGradient(
                        colors: [
                           Color.white.opacity((colorScheme == .dark ? 0.15 : 0.35) * settings.transparency),
                           Color.white.opacity(0.05 * settings.transparency),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                     )
                  )
            )
      )
   }

   private func moreAppsCluster() -> some View {
      ZStack(alignment: .bottomTrailing) {
         LazyVGrid(
            columns: GridLayoutUtility.createFlexibleGridColumns(count: 2, spacing: 4),
            spacing: 4
         ) {
            ForEach(moreApps) { app in
               Image(nsImage: app.icon)
                  .resizable()
                  .aspectRatio(contentMode: .fit)
            }
         }
         .frame(width: layout.iconSize, height: layout.iconSize)

         if additionalCount > 4 {
            Text("+\(additionalCount)")
               .font(.system(size: max(10, layout.fontSize - 1), weight: .semibold))
               .padding(.horizontal, 6)
               .padding(.vertical, 3)
               .background(.ultraThinMaterial, in: Capsule())
         }
      }
      .frame(width: layout.cellWidth, height: layout.iconSize + layout.labelGap + layout.fontSize * 1.25, alignment: .top)
      .contentShape(Rectangle())
      .onTapGesture { openCategory() }
      .accessibilityLabel("\(additionalCount) more apps in \(category.name)")
      .accessibilityAddTraits(.isButton)
   }

   private func openCategory() {
      guard !categoryApps.isEmpty else { return }
      onItemTap(.category(category))
   }

   private func placeholderBox() -> some View {
      RoundedRectangle(cornerRadius: 12)
         .fill(Color.clear)
         .frame(maxWidth: .infinity)
         .aspectRatio(1, contentMode: .fit)
   }
}
