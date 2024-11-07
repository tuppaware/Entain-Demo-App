// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum EntainStrings {
  internal enum InfoState {
    internal enum NoRaces {
      /// Whoops, looks like we dont have any races to show you at the moment.
      internal static let description = EntainStrings.tr("Copy", "InfoState.NoRaces.Description", fallback: "Whoops, looks like we dont have any races to show you at the moment.")
      /// No races scheduled
      internal static let title = EntainStrings.tr("Copy", "InfoState.NoRaces.Title", fallback: "No races scheduled")
      internal enum PrimaryCTA {
        /// Check again
        internal static let title = EntainStrings.tr("Copy", "InfoState.NoRaces.PrimaryCTA.Title", fallback: "Check again")
      }
    }
  }
  internal enum NextToGo {
    /// Copy.strings
    ///   EntainDemoApp
    /// 
    ///   Created by Adam Ware on 5/11/2024.
    internal static let title = EntainStrings.tr("Copy", "NextToGo.Title", fallback: "Entain Demo App")
    internal enum Section {
      /// Next to go races
      internal static let title = EntainStrings.tr("Copy", "NextToGo.Section.Title", fallback: "Next to go races")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension EntainStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
