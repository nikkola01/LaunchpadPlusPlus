import SwiftUI

extension AppGridItem {
   static func orderedApps(from pages: [[AppGridItem]]) -> [AppInfo] {
      var seen = Set<String>()
      return pages.flatMap { $0 }.flatMap { item -> [AppInfo] in
         switch item {
         case .app(let app): return [app]
         case .folder(let folder): return folder.apps
         case .category: return []
         }
      }.filter { seen.insert($0.path).inserted }
   }

   var path: String {
      switch self {
      case .app(let app): return app.path
      case .folder: return ""
      case .category: return ""
      }
   }

   var lastOpenedDate: Date? {
      switch self {
      case .app(let app): return app.lastOpenedDate
      case .folder(let folder): return folder.apps.compactMap(\.lastOpenedDate).max()
      case .category: return nil
      }
   }

   var installDate: Date? {
      switch self {
      case .app(let app): return app.installDate
      case .folder(let folder): return folder.apps.compactMap(\.installDate).max()
      case .category: return nil
      }
   }

   var appPaths: Set<String> {
      switch self {
      case .app(let app): return [app.path]
      case .folder(let folder): return Set(folder.apps.map(\.path))
      case .category: return []
      }
   }

   func serialize() -> [String: Any] {
      switch self {
      case .app(let app): return serialize(app)
      case .folder(let folder): return serialize(folder)
      case .category: return [:]
      }
   }

   func serialize(_ folder: Folder) -> [String : Any] {
      return [
         "type": "folder",
         "id": folder.id.uuidString,
         "name": folder.name,
         "page": folder.page,
         "apps": folder.apps.map(serialize)
      ]
   }

   func serialize(_ app: AppInfo) -> [String: Any] {
      [
         "type": "app",
         "id": app.id.uuidString,
         "name": app.name,
         "page": app.page,
         "path": app.path
      ]
   }

   func withUpdatedPage(_ newPage: Int) -> AppGridItem {
      switch self {
      case .app(var app):
         app.page = newPage
         return .app(app)
      case .folder(var folder):
         folder.page = newPage
         return .folder(folder)
      case .category(let category):
         return .category(category)
      }
   }
}
