import SwiftUI

struct SettingsView: View {
   private let settingsManager = SettingsManager.shared
   private let appManager = AppManager.shared
   let onDismiss: () -> Void
   private let originalSettings: LaunchpadSettings
   private let originalPages: [[AppGridItem]]
   private let originalCategories: [Category]

   @State private var selectedTab: Int
   @State private var settings: LaunchpadSettings = SettingsManager.shared.settings
   @State private var categories: [Category]
   @State private var didReflowPages = false

   init(onDismiss: @escaping () -> Void, initialTab: Int = 0) {
      self.onDismiss = onDismiss;
      let currentSettings = SettingsManager.shared.settings
      self.originalSettings = currentSettings
      self.originalPages = AppManager.shared.pages
      let currentCategories = CategoryManager.shared.categories
      self.originalCategories = currentCategories
      _settings = State(initialValue: currentSettings)
      _categories = State(initialValue: currentCategories)
      _selectedTab = State(initialValue: initialTab)
   }

   var body: some View {
      ZStack {
         Color.black.opacity(0.4)
            .ignoresSafeArea()
            .onTapGesture(perform: cancel)

         VStack(spacing: 0) {
            HStack {
               Text(L10n.launchpadSettings)
                  .font(.title2)
                  .fontWeight(.semibold)
               Spacer()
               Button("✕", action: cancel)
                  .buttonStyle(.plain)
                  .foregroundColor(.secondary)
                  .font(.title3)
            }
            .padding(.bottom, 16)

            HStack(spacing: 0) {
               // Sidebar with vertical tabs
               VStack(alignment: .leading, spacing: 4) {
                  SidebarTabButton(
                     icon: "grid",
                     label: L10n.layout,
                     isSelected: selectedTab == 0,
                     action: { selectedTab = 0 }
                  )
                  SidebarTabButton(
                     icon: "sparkles",
                     label: L10n.features,
                     isSelected: selectedTab == 1,
                     action: { selectedTab = 1 },
                  )
                  SidebarTabButton(
                     icon: "photo",
                     label: L10n.background,
                     isSelected: selectedTab == 2,
                     action: { selectedTab = 2 }
                  )
                  SidebarTabButton(
                     icon: "bolt",
                     label: L10n.actions,
                     isSelected: selectedTab == 3,
                     action: { selectedTab = 3 }
                  )
                  SidebarTabButton(
                     icon: "eye.slash",
                     label: L10n.hiddenApps,
                     isSelected: selectedTab == 4,
                     action: { selectedTab = 4 }
                  )
                  if settings.showCategories {
                     SidebarTabButton(
                        icon: "tag.fill",
                        label: L10n.categories,
                        isSelected: selectedTab == 5,
                        action: { selectedTab = 5 }
                     )
                  }
                  SidebarTabButton(
                     icon: "folder",
                     label: L10n.locations,
                     isSelected: selectedTab == 6,
                     action: { selectedTab = 6 }
                  )
                  Spacer()
                  Link(destination: URL(string: "https://buymeacoffee.com/nnikolov01")!) {
                     Label(L10n.buyMeACoffee, systemImage: "cup.and.saucer.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                  }
                  .buttonStyle(.plain)
                  .foregroundColor(.primary)
                  .padding(.horizontal, 12)
                  .padding(.vertical, 8)
               }
               .frame(width: 200)
               .padding(.trailing, 16)

               Divider()
                  .padding(.trailing, 16)

               // Content area
               VStack {
                  Group {
                     if selectedTab == 0 {
                        LayoutSettings(settings: $settings, onReflowPages: reflowPages)
                     } else if selectedTab == 1 {
                        FeaturesSettings(settings: $settings)
                     } else if selectedTab == 2 {
                        BackgroundSettings(settings: $settings)
                     } else if selectedTab == 3 {
                        ActionsSettings()
                     } else if selectedTab == 4 {
                        HiddenAppsSettings()
                     } else if selectedTab == 5 {
                        CategorySettings(
                           categories: $categories,
                           allApps: AppGridItem.orderedApps(from: appManager.pages)
                        )
                     } else if selectedTab == 6 {
                        LocationsSettings(settings: $settings)
                     }
                  }

                  Spacer()

                  HStack(spacing: 16) {
                     Button(L10n.resetToDefaults, action: reset).buttonStyle(.bordered)
                     Spacer()
                     Button(L10n.cancel, action: cancel).buttonStyle(.bordered)
                     Button(L10n.save, action: save).buttonStyle(.borderedProminent)
                  }
               }
            }
         }
         .padding(24)
         .frame(width: 740, height: 480)
         .background(
            RoundedRectangle(cornerRadius: 16)
               .fill(.regularMaterial)
               .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
         )
         .overlay(
            RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.2), lineWidth: 1)
         )
      }
      .onChange(of: settings) { _, newSettings in
         if !newSettings.showCategories && selectedTab == 5 {
            selectedTab = 1
         }
         preview(newSettings)
      }
      .onChange(of: categories) { _, newCategories in
         CategoryManager.shared.previewCategories(newCategories)
      }
   }

   private func save() {
      settingsManager.saveSettings(newSettings: settings)
      CategoryManager.shared.commitCategories(categories)
      if didReflowPages {
         appManager.saveAppGridItems()
      }
      onDismiss()
   }

   private func reset() {
      settings = LaunchpadSettings(customAppLocations: settings.customAppLocations)
   }

   private func cancel() {
      preview(originalSettings)
      appManager.pages = originalPages
      categories = originalCategories
      CategoryManager.shared.previewCategories(originalCategories)
      onDismiss()
   }

   private func reflowPages() {
      appManager.reflowPages(appsPerPage: settings.appsPerPage)
      didReflowPages = true
   }

   private func preview(_ newSettings: LaunchpadSettings) {
      let previousSettings = settingsManager.settings
      settingsManager.previewSettings(newSettings)

      if didReflowPages && previousSettings.appsPerPage != newSettings.appsPerPage {
         appManager.reflowPages(appsPerPage: newSettings.appsPerPage)
      }

      NSMenu.setMenuBarVisible(newSettings.showDock)

      if previousSettings.startAtLogin != newSettings.startAtLogin {
         if newSettings.startAtLogin {
            LoginItemManager.shared.enableLoginItem()
         } else {
            LoginItemManager.shared.disableLoginItem()
         }
      }

      // Reload apps if custom locations changed
      if previousSettings.customAppLocations != newSettings.customAppLocations {
         appManager.loadAppGridItems(appsPerPage: newSettings.appsPerPage)
      }
   }
}
