import AppKit
import SwiftUI

struct LayoutMetrics {
   let hPadding: CGFloat
   let vPadding: CGFloat
   let hSpacing: CGFloat
   let vSpacing: CGFloat
   let cellWidth: CGFloat
   let iconSize: CGFloat
   let fontSize: CGFloat
   let labelGap: CGFloat
   
   init(size: CGSize, columns: Int, rows: Int, iconSize: Double, margin: Double = 0.0, appsTopMargin: Double = 0.0, appsBottomMargin: Double = 0.0, labelFontSize: Double = 12.0) {
      hPadding = margin
      vPadding = size.height * 0.04
      labelGap = 8
      let preferredHSpacing = size.height < 800 ? size.height * 0.04 : size.height * 0.03
      let widthAfterPadding = max(size.width - (hPadding * 2), 0)
      hSpacing = min(preferredHSpacing, widthAfterPadding / CGFloat(max(columns * 3, 1)))
      let totalHSpacing = CGFloat(columns - 1) * hSpacing
      cellWidth = max((widthAfterPadding - totalHSpacing) / CGFloat(max(columns, 1)), 1)
      fontSize = max(8, min(CGFloat(labelFontSize), 24))

      let labelHeight = fontSize * 1.25
      let availableHeight = max(size.height - (vPadding * 2) - CGFloat(max(appsTopMargin, 0)) - CGFloat(max(appsBottomMargin, 0)), 0)
      let nonIconHeight = CGFloat(rows) * (labelGap + labelHeight)
      let heightLimitedIconSize = max((availableHeight - nonIconHeight) / CGFloat(max(rows, 1)), 1)
      self.iconSize = min(CGFloat(iconSize), cellWidth, heightLimitedIconSize)

      let usedHeight = CGFloat(rows) * (self.iconSize + labelGap + labelHeight)
      let remainingHeight = max(availableHeight - usedHeight, 0)
      let gaps = CGFloat(max(rows - 1, 1))
      vSpacing = rows > 1 ? remainingHeight / gaps : 0
   }
}
