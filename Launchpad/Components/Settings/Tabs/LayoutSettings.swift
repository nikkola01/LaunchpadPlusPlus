import SwiftUI

struct LayoutSettings: View {
   @Binding var settings: LaunchpadSettings
   let onReflowPages: () -> Void
   @State private var showingReflowConfirmation = false

   var body: some View {
      ScrollView {
         VStack(alignment: .leading, spacing: 12) {
            Text(L10n.layout)
               .font(.headline)
               .foregroundColor(.primary)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 190), spacing: 16)], spacing: 12) {
               SettingsNumberField(title: L10n.columns, value: $settings.columns, range: LaunchpadSettings.columnsRange)
               SettingsNumberField(title: L10n.rows, value: $settings.rows, range: LaunchpadSettings.rowsRange)
               SettingsNumberField(title: L10n.folderColumns, value: $settings.folderColumns, range: 2...8)
               SettingsNumberField(title: L10n.folderRows, value: $settings.folderRows, range: 1...6)
               SettingsNumberField(title: L10n.categoryColumns, value: $settings.categoryColumns, range: 2...4)
               SettingsNumberField(title: L10n.categoryRows, value: $settings.categoryRows, range: 2...4)
            }
            SettingsSlider(
               title: L10n.iconSize,
               value: $settings.iconSize,
               range: 50...200,
               step: 10,
               minLabel: L10n.number10,
               maxLabel: L10n.number200
            )

            SettingsSlider(
               title: L10n.margin,
               value: $settings.margin,
               range: 0...300,
               step: 10,
               minLabel: "0",
               maxLabel: "300"
            )

            SettingsSlider(
               title: L10n.appsTopMargin,
               value: $settings.appsTopMargin,
               range: 0...200,
               step: 1,
               minLabel: "0",
               maxLabel: "200"
            )

            SettingsSlider(
               title: L10n.appsBottomMargin,
               value: $settings.appsBottomMargin,
               range: 0...200,
               step: 1,
               minLabel: "0",
               maxLabel: "200"
            )

            SettingsSlider(
               title: L10n.labelFontSize,
               value: $settings.labelFontSize,
               range: 8...24,
               step: 1,
               minLabel: "8 pt",
               maxLabel: "24 pt"
            )

            SettingsSlider(
               title: L10n.transparency,
               value: $settings.transparency,
               range: 0.0...2.0,
               step: 0.01,
               minLabel: "0%",
               maxLabel: "200%"
            )

            SettingsColorPicker(
               title: L10n.labelFontColor,
               hexColor: $settings.labelFontColor
            )

            Divider()

            Button(L10n.reflowPages) {
               showingReflowConfirmation = true
            }
            .buttonStyle(.bordered)
         }
      }
      .padding(.horizontal, 8)
      .alert(L10n.reflowPages, isPresented: $showingReflowConfirmation) {
         Button(L10n.cancel, role: .cancel) { }
         Button(L10n.reflow, action: onReflowPages)
      } message: {
         Text(L10n.reflowPagesConfirmation)
      }
   }
}
