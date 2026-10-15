import SwiftUI

struct SettingsNumberField: View {
   let title: String
   @Binding var value: Int
   let range: ClosedRange<Int>
   
   var body: some View {
      VStack(alignment: .leading, spacing: 8) {
         Text(title)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .help(title)
         
         HStack {
            TextField(title, value: $value, format: .number)
               .textFieldStyle(.roundedBorder)
               .frame(minWidth: 72)
               .onChange(of: value) { _, newValue in
                  value = min(max(newValue, range.lowerBound), range.upperBound)
               }
            
            Stepper("", value: $value, in: range)
               .labelsHidden()
         }
      }
      .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
   }
}
