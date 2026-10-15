import Foundation

struct CategorySuggestion: Equatable {
   let name: String
   let appPaths: Set<String>
}

enum CategoryClassifier {
   private static let rules: [(String, Set<String>)] = [
      ("Communication", ["mail", "messages", "facetime", "phone", "contacts", "messenger", "viber", "microsoft outlook"]),
      ("Productivity", ["calendar", "reminders", "notes", "freeform", "journal", "notion", "microsoft word", "microsoft excel", "microsoft powerpoint", "libreoffice", "zotero", "wondershare pdfelement", "textedit", "dictionary", "books"]),
      ("Creativity", ["final cut pro", "blender", "descript", "photos", "image playground", "photo booth", "quicktime player", "voice memos", "audio midi setup", "colorsync utility", "digital colour meter"]),
      ("Developer", ["xcode", "visual studio code", "docker", "terminal", "script editor", "automator", "shortcuts", "coteditor", "texstudio-4.9.5-osx-m1"]),
      ("Internet & Security", ["safari", "google chrome", "adguard for safari", "cyberghost vpn", "surfshark", "metamask", "passwords", "find my"]),
      ("Entertainment", ["music", "spotify", "tv", "podcasts", "books", "news", "vlc"]),
      ("Utilities", ["activity monitor", "airport utility", "app store", "calculator", "clock", "console", "disk utility", "font book", "image capture", "magnifier", "migration assistant", "mission control", "preview", "print centre", "screen sharing", "screenshot", "siri", "system information", "system settings", "time machine", "voiceover utility", "bluetooth file exchange", "grapher", "betterdisplay", "commander one", "grandperspective", "logi options"]),
      ("3D & Printing", ["anycubicslicernext", "ultimaker cura", "blender"]),
      ("Games", ["chess", "league of legends", "riot client", "games"]),
      ("Home & Lifestyle", ["home", "maps", "weather", "headspace", "stocks", "tips", "journal"])
   ]

   static func suggestions(for apps: [AppInfo]) -> [CategorySuggestion] {
      let uniqueApps = apps.unique(by: \.path).filter { !normalized($0.name).contains("uninstaller") }
      var result: [CategorySuggestion] = []

      let recent = uniqueApps.filter { $0.lastOpenedDate != nil }
         .sorted { $0.lastOpenedDate! > $1.lastOpenedDate! }
         .prefix(12)
      if !recent.isEmpty {
         result.append(CategorySuggestion(name: "Favorites", appPaths: Set(recent.map(\.path))))
      }

      for (categoryName, appNames) in rules {
         let paths = Set(uniqueApps.filter { appNames.contains(normalized($0.name)) }.map(\.path))
         if !paths.isEmpty {
            result.append(CategorySuggestion(name: categoryName, appPaths: paths))
         }
      }
      return result
   }

   static func merge(_ suggestions: [CategorySuggestion], into existing: [Category]) -> [Category] {
      var result = existing
      for suggestion in suggestions {
         if let index = result.firstIndex(where: { normalized($0.name) == normalized(suggestion.name) }) {
            result[index].appPaths.formUnion(suggestion.appPaths)
         } else {
            result.append(Category(name: suggestion.name, appPaths: suggestion.appPaths))
         }
      }
      return result
   }

   static func replacing(with suggestions: [CategorySuggestion]) -> [Category] {
      suggestions.map { Category(name: $0.name, appPaths: $0.appPaths) }
   }

   private static func normalized(_ value: String) -> String {
      value.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
         .trimmingCharacters(in: .whitespacesAndNewlines)
   }
}
