import XCTest
@testable import LaunchpadPlus

final class LayoutMetricsTests: XCTestCase {
   func testDenseRowsShrinkIconsToFitAvailableHeight() {
      let metrics = LayoutMetrics(
         size: CGSize(width: 1200, height: 700),
         columns: 7,
         rows: 12,
         iconSize: 100,
         margin: 20,
         appsTopMargin: 30,
         appsBottomMargin: 25,
         labelFontSize: 18
      )

      XCTAssertLessThan(metrics.iconSize, 100)
      let labelHeight = metrics.fontSize * 1.25
      let contentHeight = CGFloat(12) * (metrics.iconSize + metrics.labelGap + labelHeight)
         + CGFloat(11) * metrics.vSpacing
      let availableHeight = 700 - (metrics.vPadding * 2) - 30 - 25
      XCTAssertLessThanOrEqual(contentHeight, availableHeight + 0.01)
   }

   func testPreferredIconSizeIsKeptWhenItFits() {
      let metrics = LayoutMetrics(
         size: CGSize(width: 1600, height: 1000),
         columns: 7,
         rows: 5,
         iconSize: 100,
         margin: 20,
         appsTopMargin: 0,
         appsBottomMargin: 0,
         labelFontSize: 12
      )

      XCTAssertEqual(metrics.iconSize, 100, accuracy: 0.01)
      XCTAssertEqual(metrics.fontSize, 12, accuracy: 0.01)
   }

   func testHorizontalConstraintsPreventIconsExceedingCells() {
      let metrics = LayoutMetrics(
         size: CGSize(width: 800, height: 700),
         columns: 12,
         rows: 5,
         iconSize: 200,
         margin: 100
      )

      XCTAssertLessThanOrEqual(metrics.iconSize, metrics.cellWidth)
      XCTAssertGreaterThan(metrics.cellWidth, 0)
   }
}
