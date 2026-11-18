import SwiftUI

/// Backport wrapper: `NavigationStack` is iOS 16+. On iOS 15 use `NavigationView`.
struct AdaptiveNavigationStack<Content: View>: View {
    @ViewBuilder private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        if #available(iOS 16.0, macOS 13.0, *) {
            NavigationStack {
                content
            }
        } else {
            NavigationView {
                content
            }
            .navigationViewStyle(.stack)
        }
    }
}
