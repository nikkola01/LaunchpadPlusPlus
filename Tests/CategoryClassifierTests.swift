import XCTest
import AppKit
@testable import LaunchpadPlus

final class CategoryClassifierTests: XCTestCase {
   private func app(_ name: String, path: String? = nil, lastOpened: Date? = nil) -> AppInfo {
      AppInfo(
         name: name,
         icon: NSImage(size: NSSize(width: 1, height: 1)),
         path: path ?? "/Applications/\(name).app",
         bundleId: "test.\(name)",
         lastOpenedDate: lastOpened,
         installDate: nil
      )
   }

   func testKnownAppsAreClassifiedAndUsefulOverlapIsPreserved() {
      let suggestions = CategoryClassifier.suggestions(for: [app("Blender"), app("Messages")])
      let creativity = suggestions.first { $0.name == "Creativity" }
      let printing = suggestions.first { $0.name == "3D & Printing" }
      let communication = suggestions.first { $0.name == "Communication" }

      XCTAssertTrue(creativity?.appPaths.contains("/Applications/Blender.app") == true)
      XCTAssertTrue(printing?.appPaths.contains("/Applications/Blender.app") == true)
      XCTAssertTrue(communication?.appPaths.contains("/Applications/Messages.app") == true)
   }

   func testUnknownAndUninstallerAppsAreNotForcedIntoCategories() {
      let suggestions = CategoryClassifier.suggestions(for: [
         app("Mystery Tool"),
         app("Logi Options Uninstaller")
      ])
      XCTAssertTrue(suggestions.flatMap(\.appPaths).isEmpty)
   }

   func testMergePreservesManualCategoryIdentityAndIsIdempotent() {
      let id = UUID()
      let existing = [Category(id: id, name: "Communication", appPaths: ["/Manual.app"])]
      let suggestion = CategorySuggestion(name: "communication", appPaths: ["/Messages.app"])

      let once = CategoryClassifier.merge([suggestion], into: existing)
      let twice = CategoryClassifier.merge([suggestion], into: once)

      XCTAssertEqual(once[0].id, id)
      XCTAssertEqual(once[0].appPaths, ["/Manual.app", "/Messages.app"])
      XCTAssertEqual(twice, once)
   }

   func testFavoritesUsesMostRecentlyOpenedApps() {
      let older = app("Older", lastOpened: Date(timeIntervalSince1970: 1))
      let newer = app("Newer", lastOpened: Date(timeIntervalSince1970: 2))
      let favorites = CategoryClassifier.suggestions(for: [older, newer]).first { $0.name == "Favorites" }
      XCTAssertEqual(favorites?.appPaths, Set([older.path, newer.path]))
   }

   func testOrderedAppsIncludesFolderContentsAndDeduplicatesPaths() {
      let duplicate = app("Duplicate")
      let nested = app("Nested")
      let folder = Folder(name: "Folder", page: 0, apps: [duplicate, nested])
      let result = AppGridItem.orderedApps(from: [[.app(duplicate), .folder(folder)]])
      XCTAssertEqual(result.map(\.path), [duplicate.path, nested.path])
   }
}
