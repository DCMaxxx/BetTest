// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {

  enum Durationformatter {
    /// %d seconds
    static func secondsFallback(_ p1: Int) -> String {
      return L10n.tr("Localizable", "DurationFormatter.secondsFallback", p1)
    }
  }

  enum Playlist {
    /// By %@
    static func author(_ p1: String) -> String {
      return L10n.tr("Localizable", "Playlist.author", p1)
    }
  }

  enum Playlistlistviewcontroller {
    /// Playlists
    static let title = L10n.tr("Localizable", "PlaylistListViewController.title")
  }

  enum Track {
    /// %@ - %@
    static func subtitle(_ p1: String, _ p2: String) -> String {
      return L10n.tr("Localizable", "Track.subtitle", p1, p2)
    }
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  fileprivate static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}

