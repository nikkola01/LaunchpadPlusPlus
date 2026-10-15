import SwiftUI

struct CategoryPageView: View {
   let allApps: [AppInfo]
   let settings: LaunchpadSettings
   let onItemTap: (AppGridItem) -> Void
   
   @ObservedObject private var categoryManager = CategoryManager.shared

   private var categoryIconSize: Double {
      min(settings.iconSize, 110)
   }

   private var cardHeight: CGFloat {
      let rowHeight = categoryIconSize + settings.labelFontSize * 1.25 + 8
      let rowsHeight = CGFloat(settings.categoryRows) * CGFloat(rowHeight)
      let gapsHeight = CGFloat(max(settings.categoryRows - 1, 0)) * CGFloat(8)
      return max(CGFloat(280), CGFloat(64) + rowsHeight + gapsHeight)
   }

   private var categoryLayout: LayoutMetrics {
      LayoutMetrics(
         size: CGSize(width: LaunchpadConstants.categoryBoxMinWidth - 32, height: cardHeight - 32),
         columns: settings.categoryColumns,
         rows: settings.categoryRows,
         iconSize: categoryIconSize,
         labelFontSize: settings.labelFontSize
      )
   }

   private var categoryGridColumns: [GridItem] {
      [GridItem(.adaptive(
         minimum: LaunchpadConstants.categoryBoxMinWidth,
         maximum: LaunchpadConstants.categoryBoxMaxWidth
      ), spacing: 36)]
   }
   
   var body: some View {
      if categoryManager.categories.isEmpty {
         EmptyCategoriesView()
      } else {
         GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
               VStack(spacing: 0) {
                  Spacer(minLength: 24)

                  LazyVGrid(columns: categoryGridColumns, spacing: 36) {
                     ForEach(categoryManager.categories) { category in
                        CategoryBoxView(
                           category: category,
                           allApps: allApps,
                           settings: settings,
                           layout: categoryLayout,
                           cardHeight: cardHeight,
                           onItemTap: onItemTap
                        )
                     }
                  }

                  Spacer(minLength: 24)
               }
               .frame(minHeight: geo.size.height)
               .padding(.horizontal, 72)
            }
            .scrollBounceBehavior(.basedOnSize)
         }
      }
   }
}
