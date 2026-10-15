import Foundation

struct LaunchpadSettings: Codable, Equatable {
   static let columnsRange = 4...12
   static let rowsRange = 3...12

   // MARK: - Grid Layout
   var columns: Int
   var rows: Int
   var iconSize: Double
   var margin: Double
   var appsTopMargin: Double
   var appsBottomMargin: Double
   var folderColumns: Int
   var folderRows: Int
   var categoryColumns: Int
   var categoryRows: Int

   // MARK: - Interaction & Animation
   var dropDelay: Double
   var scrollDebounceInterval: TimeInterval
   var scrollActivationThreshold: Double
   var enableIconAnimation: Bool

   // MARK: - Display & Appearance
   var showDock: Bool
   var transparency: Double
   var showIconsInSearch: Bool
   var backgroundType: BackgroundType
   var customBackgroundPath: String
   var backgroundBlur: Double
   var backgroundOpacity: Double
   var labelFontColor: String?
   var labelFontSize: Double

   // MARK: - Behavior
   var startAtLogin: Bool
   var resetOnRelaunch: Bool
   var showCategories: Bool

   // MARK: - Advanced
   var customAppLocations: [String]

   // MARK: - Defaults
   static let defaultColumns = 6
   static let defaultRows = 5
   static let defaultIconSize: Double = 120.0
   static let defaultMargin: Double = 90.0
   static let defaultAppsTopMargin: Double = 80.0
   static let defaultAppsBottomMargin: Double = 80.0
   static let defaultLabelFontSize: Double = 12.0
   static let defaultFolderColumns = 5
   static let defaultFolderRows = 3
   static let defaultCategoryColumns = 3
   static let defaultCategoryRows = 2
   static let defaultDropDelay: Double = 0.5
   static let defaultScrollDebounceInterval: TimeInterval = 0.8
   static let defaultScrollActivationThreshold: Double = 80.0
   static let defaultTransparency: Double = 1.0
   static let defaultEnableIconAnimation = true
   static let defaultStartAtLogin = false
   static let defaultResetOnRelaunch = true
   static let defaultShowDock = true
   static let defaultShowIconsInSearch = true
   static let defaultShowCategories = true
   static let defaultBackgroundType: BackgroundType = .default
   static let defaultBackgroundBlur: Double = 10.0
   static let defaultBackgroundOpacity: Double = 1.0



   // MARK: - Initializer
   init(
      columns: Int = defaultColumns,
      rows: Int = defaultRows,
      iconSize: Double = defaultIconSize,
      margin: Double = defaultMargin,
      appsTopMargin: Double = defaultAppsTopMargin,
      appsBottomMargin: Double = defaultAppsBottomMargin,
      folderColumns: Int = defaultFolderColumns,
      folderRows: Int = defaultFolderRows,
      categoryColumns: Int = defaultCategoryColumns,
      categoryRows: Int = defaultCategoryRows,
      dropDelay: Double = defaultDropDelay,
      scrollDebounceInterval: TimeInterval = defaultScrollDebounceInterval,
      scrollActivationThreshold: Double = defaultScrollActivationThreshold,
      enableIconAnimation: Bool = defaultEnableIconAnimation,
      showDock: Bool = defaultShowDock,
      transparency: Double = defaultTransparency,
      showIconsInSearch: Bool = defaultShowIconsInSearch,
      backgroundType: BackgroundType = defaultBackgroundType,
      customBackgroundPath: String = "",
      backgroundBlur: Double = defaultBackgroundBlur,
      backgroundOpacity: Double = defaultBackgroundOpacity,
      labelFontColor: String? = nil,
      labelFontSize: Double = defaultLabelFontSize,
      startAtLogin: Bool = defaultStartAtLogin,
      resetOnRelaunch: Bool = defaultResetOnRelaunch,
      showCategories: Bool = defaultShowCategories,
      customAppLocations: [String] = []
   ) {
      // Layout
      self.columns = Self.columnsRange.clamped(columns)
      self.rows = Self.rowsRange.clamped(rows)
      self.iconSize = max(20, min(200, iconSize))
      self.margin = max(0, min(300, margin))
      self.appsTopMargin = max(0, min(200, appsTopMargin))
      self.appsBottomMargin = max(0, min(200, appsBottomMargin))
      self.folderColumns = max(3, min(10, folderColumns))
      self.folderRows = max(3, min(8, folderRows))
      self.categoryColumns = max(2, min(4, categoryColumns))
      self.categoryRows = max(2, min(4, categoryRows))

      // Interaction
      self.dropDelay = max(0.0, min(3.0, dropDelay))
      self.scrollDebounceInterval = scrollDebounceInterval
      self.scrollActivationThreshold = scrollActivationThreshold
      self.enableIconAnimation = enableIconAnimation

      // Appearance
      self.transparency = max(0.0, min(2.0, transparency))
      self.backgroundType = backgroundType
      self.customBackgroundPath = customBackgroundPath
      self.backgroundBlur = max(0.0, min(30.0, backgroundBlur))
      self.backgroundOpacity = max(0.0, min(1.0, backgroundOpacity))
      self.labelFontColor = labelFontColor
      self.labelFontSize = max(8, min(24, labelFontSize))

      // Behavior
      self.showDock = showDock
      self.showIconsInSearch = showIconsInSearch
      self.startAtLogin = startAtLogin
      self.resetOnRelaunch = resetOnRelaunch
      self.showCategories = showCategories

      // Advanced
      self.customAppLocations = customAppLocations
   }

   private enum CodingKeys: String, CodingKey {
      case columns, rows, iconSize, margin, appsTopMargin, appsBottomMargin
      case folderColumns, folderRows, categoryColumns, categoryRows
      case dropDelay, scrollDebounceInterval, scrollActivationThreshold, enableIconAnimation
      case showDock, transparency, showIconsInSearch, backgroundType
      case customBackgroundPath, backgroundBlur, backgroundOpacity, labelFontColor, labelFontSize
      case startAtLogin, resetOnRelaunch, showCategories, customAppLocations
   }

   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.init(
         columns: try container.decodeIfPresent(Int.self, forKey: .columns) ?? Self.defaultColumns,
         rows: try container.decodeIfPresent(Int.self, forKey: .rows) ?? Self.defaultRows,
         iconSize: try container.decodeIfPresent(Double.self, forKey: .iconSize) ?? Self.defaultIconSize,
         margin: try container.decodeIfPresent(Double.self, forKey: .margin) ?? Self.defaultMargin,
         appsTopMargin: try container.decodeIfPresent(Double.self, forKey: .appsTopMargin) ?? Self.defaultAppsTopMargin,
         appsBottomMargin: try container.decodeIfPresent(Double.self, forKey: .appsBottomMargin) ?? Self.defaultAppsBottomMargin,
         folderColumns: try container.decodeIfPresent(Int.self, forKey: .folderColumns) ?? Self.defaultFolderColumns,
         folderRows: try container.decodeIfPresent(Int.self, forKey: .folderRows) ?? Self.defaultFolderRows,
         categoryColumns: try container.decodeIfPresent(Int.self, forKey: .categoryColumns) ?? Self.defaultCategoryColumns,
         categoryRows: try container.decodeIfPresent(Int.self, forKey: .categoryRows) ?? Self.defaultCategoryRows,
         dropDelay: try container.decodeIfPresent(Double.self, forKey: .dropDelay) ?? Self.defaultDropDelay,
         scrollDebounceInterval: try container.decodeIfPresent(TimeInterval.self, forKey: .scrollDebounceInterval) ?? Self.defaultScrollDebounceInterval,
         scrollActivationThreshold: try container.decodeIfPresent(Double.self, forKey: .scrollActivationThreshold) ?? Self.defaultScrollActivationThreshold,
         enableIconAnimation: try container.decodeIfPresent(Bool.self, forKey: .enableIconAnimation) ?? Self.defaultEnableIconAnimation,
         showDock: try container.decodeIfPresent(Bool.self, forKey: .showDock) ?? Self.defaultShowDock,
         transparency: try container.decodeIfPresent(Double.self, forKey: .transparency) ?? Self.defaultTransparency,
         showIconsInSearch: try container.decodeIfPresent(Bool.self, forKey: .showIconsInSearch) ?? Self.defaultShowIconsInSearch,
         backgroundType: try container.decodeIfPresent(BackgroundType.self, forKey: .backgroundType) ?? Self.defaultBackgroundType,
         customBackgroundPath: try container.decodeIfPresent(String.self, forKey: .customBackgroundPath) ?? "",
         backgroundBlur: try container.decodeIfPresent(Double.self, forKey: .backgroundBlur) ?? Self.defaultBackgroundBlur,
         backgroundOpacity: try container.decodeIfPresent(Double.self, forKey: .backgroundOpacity) ?? Self.defaultBackgroundOpacity,
         labelFontColor: try container.decodeIfPresent(String.self, forKey: .labelFontColor),
         labelFontSize: try container.decodeIfPresent(Double.self, forKey: .labelFontSize) ?? Self.defaultLabelFontSize,
         startAtLogin: try container.decodeIfPresent(Bool.self, forKey: .startAtLogin) ?? Self.defaultStartAtLogin,
         resetOnRelaunch: try container.decodeIfPresent(Bool.self, forKey: .resetOnRelaunch) ?? Self.defaultResetOnRelaunch,
         showCategories: try container.decodeIfPresent(Bool.self, forKey: .showCategories) ?? Self.defaultShowCategories,
         customAppLocations: try container.decodeIfPresent([String].self, forKey: .customAppLocations) ?? []
      )
   }
}
