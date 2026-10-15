import Foundation

extension ClosedRange where Bound: Comparable {
   func clamped(_ value: Bound) -> Bound {
      Swift.min(Swift.max(value, lowerBound), upperBound)
   }
}

extension LaunchpadSettings {
   var appsPerPage: Int {
      return columns * rows
   }
}
