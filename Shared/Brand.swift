import SwiftUI

/// White-label brand configuration. Change these values (and swap the app
/// icon) to ship this app for any family or under any brand — nothing else in
/// the code hard-codes a name or color.
///
/// Shared by both targets. To rebrand:
///   1. Edit the values below.
///   2. Replace the app icon in `NoorWatch/Assets.xcassets/AppIcon`.
///   3. Set each target's Display Name in Xcode (General tab).
///   4. The default child's name lives in settings and is editable in the
///      parent app; `defaultChildName` is only the starting value.
enum Brand {
    /// Full product name, shown on the watch home and the parent app.
    static let appName = "Idrees Big Boy App"

    /// Short name for tight spaces (titles, tabs).
    static let shortName = "Idrees"

    /// Greeting line on the watch, before the child's name.
    static let greeting = "Salaam"

    /// Starting child name; the parent can change it any time.
    static let defaultChildName = "Idrees"

    /// Brand accent. Defined as components so both SwiftUI and any UIKit use
    /// read the same source.
    static let accentRGB = (red: 0.137, green: 0.353, blue: 0.224)   // forest green

    static var accent: Color {
        Color(red: accentRGB.red, green: accentRGB.green, blue: accentRGB.blue)
    }

    /// Whether the app leans on Islamic features (prayer, duas, Qibla, adhan).
    /// A non-faith white-label build can set this false to hide them.
    static let islamicFeatures = true
}
