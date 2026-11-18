import SwiftUI

#if os(iOS)
    let ToolbarLeading = ToolbarItemPlacement.topBarLeading
    let ToolbarTrailing = ToolbarItemPlacement.topBarTrailing
#else
    let ToolbarLeading = ToolbarItemPlacement.navigation
    let ToolbarTrailing = ToolbarItemPlacement.primaryAction
#endif

extension View {
    /// `.formStyle` is iOS 16+. On iOS 15 `Form` is already grouped by default,
    /// so no-op is the correct fallback.
    @ViewBuilder
    func adaptiveGroupedFormStyle() -> some View {
        if #available(iOS 16.0, macOS 13.0, *) {
            self.formStyle(.grouped)
        } else {
            self
        }
    }

    /// `.scrollDismissesKeyboard` is iOS 16+. Fall back to no-op on iOS 15.
    @ViewBuilder
    func adaptiveScrollDismissesKeyboard() -> some View {
        if #available(iOS 16.0, macOS 13.0, *) {
            self.scrollDismissesKeyboard(.immediately)
        } else {
            self
        }
    }

    func decimalKeyboardType() -> some View {
#if os(iOS)
        return self.keyboardType(.decimalPad)
#else
        return self
#endif
    }
    
    func numberKeyboardType() -> some View {
#if os(iOS)
        return self.keyboardType(.numberPad)
#else
        return self
#endif
    }
    
    func adaptiveNavigationBarTitleInline() -> some View {
#if os(iOS)
        return self.navigationBarTitleDisplayMode(.inline)
#else
        return self
#endif
    }
    
    func adaptiveNoTextInputAutocapitalization() -> some View {
#if os(iOS)
        return self.textInputAutocapitalization(.never)
#else
        return self
#endif
    }

    @ViewBuilder
    func adaptiveToolbarLabelStyle(padding: CGFloat) -> some View {
        if #available(iOS 27.1, macOS 27.1, *) {
            modifier(VerticalBarAwareLabelStyle(padding: padding))
        } else {
            self.labelStyle(.titleAndIcon).padding(padding)
        }
    }
}

@available(iOS 27.1, macOS 27.1, *)
private struct VerticalBarAwareLabelStyle: ViewModifier {
    @Environment(\.toolbarVerticalEdge) private var toolbarVerticalEdge
    let padding: CGFloat

    func body(content: Content) -> some View {
        if toolbarVerticalEdge != nil {
            content.labelStyle(.iconOnly)
        } else {
            content.labelStyle(.titleAndIcon).padding(padding)
        }
    }
}

extension ToolbarContent {
    /// Prefers placing the item in the vertical bar (e.g. on iPhone Duo) when one is present.
    @available(iOS 27.1, *)
    @ToolbarContentBuilder
    func adaptiveVerticalPreferred() -> some ToolbarContent {
#if os(iOS)
        if #available(iOS 27.1, *) {
            self.axisBehavior(.verticalPreferred)
        } else {
            self
        }
#else
        self
#endif
    }
}

