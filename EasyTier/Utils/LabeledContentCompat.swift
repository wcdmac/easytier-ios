import SwiftUI

/// Backport of SwiftUI's `LabeledContent` (iOS 16+) for iOS 15.
///
/// Supports the three initializer forms used by the app:
///   - `LabeledContent("key", value: someValue)`
///   - `LabeledContent("key") { ...content... }`
///   - `LabeledContent { ...content... } label: { ...label... }`
///
/// Layout mirrors a Form row: label leading, value trailing, right-aligned.
struct LabeledContentCompat<Content: View, Label: View>: View {
    private let content: Content
    private let label: Label

    init(@ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) {
        self.content = content()
        self.label = label()
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            label
            Spacer(minLength: 8)
            content
                .multilineTextAlignment(.trailing)
        }
    }
}

// MARK: - value: form (label + textual value)

extension LabeledContentCompat where Content == Text, Label == Text {
    /// LocalizedStringKey label (matches SwiftUI's most common initializer).
    init(_ titleKey: LocalizedStringKey, value: Any) {
        self.content = Text(String(describing: value))
        self.label = Text(titleKey)
    }

    /// String / StringProtocol label variable.
    init<S: StringProtocol>(_ title: S, value: Any) {
        self.content = Text(String(describing: value))
        self.label = Text(verbatim: String(title))
    }
}

// MARK: - trailing content closure with LocalizedStringKey / String label

extension LabeledContentCompat where Label == Text {
    init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.label = Text(titleKey)
    }

    init<S: StringProtocol>(_ title: S, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.label = Text(verbatim: String(title))
    }
}
