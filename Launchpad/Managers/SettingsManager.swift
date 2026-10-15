import Foundation

@MainActor
final class SettingsManager: ObservableObject {
   static let shared = SettingsManager()

   @Published var settings: LaunchpadSettings = LaunchpadSettings()

   private let userDefaults = UserDefaults.standard
   private let settingsKey = "LaunchpadSettings"

   private init() {
      loadSettings()
   }

   func saveSettings(newSettings: LaunchpadSettings) {
      settings = newSettings

      guard let data = try? JSONEncoder().encode(settings) else { return }
      print("Save settings.")
      userDefaults.set(data, forKey: settingsKey)
   }

   /// Updates the running app without writing to UserDefaults.
   /// Settings uses this for live previews so Cancel can restore the saved values.
   func previewSettings(_ previewSettings: LaunchpadSettings) {
      settings = previewSettings
   }

   private func loadSettings() {
      print("Load settings.")
      guard let data = UserDefaults.standard.data(forKey: settingsKey) else {
         print("No saved settings found.")
         return
      }

      do {
         settings = try JSONDecoder().decode(LaunchpadSettings.self, from: data)
         print("Loaded settings.")
      } catch {
         print("Failed to load settings: \(error)")
      }
   }

   func resetToDefaults() -> LaunchpadSettings {
      // Preserve custom scan locations when resetting appearance and behavior.
      settings = LaunchpadSettings(customAppLocations: settings.customAppLocations)
      return settings
   }
}
