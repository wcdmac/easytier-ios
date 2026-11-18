import Foundation

/// Backport of `String(localized:)` (iOS 16+) for iOS 15.
///
/// `NSLocalizedString` resolves from the main bundle using the same
/// `Localizable.xcstrings` catalog, so behavior is equivalent for the
/// single-key form used throughout the app.
func localizedString(_ key: String) -> String {
    NSLocalizedString(key, comment: "")
}
