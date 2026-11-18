import SwiftUI

/// iOS 15-compatible text field accepting the `prompt` + `axis` arguments
/// used by the app. On iOS 15 the field falls back to a `TextEditor` for
/// vertical (multiline) text, otherwise to a plain `TextField`.
struct AdaptiveTextField<Label: StringProtocol>: View {
    private let title: Label
    @Binding private var text: String
    private let prompt: Text?
    private let axis: Axis

    init(
        _ title: Label,
        text: Binding<String>,
        prompt: Text? = nil,
        axis: Axis = .horizontal
    ) {
        self.title = title
        self._text = text
        self.prompt = prompt
        self.axis = axis
    }

    var body: some View {
        Group {
            if #available(iOS 16.0, macOS 13.0, *) {
                TextField(title, text: $text, prompt: prompt, axis: axis)
            } else {
                legacyField
            }
        }
    }

    @ViewBuilder
    private var legacyField: some View {
        if axis == .vertical {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                if text.isEmpty, let prompt {
                    prompt
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                        .padding(.leading, 4)
                        .allowsHitTesting(false)
                }
            }
        } else {
            TextField(title, text: $text)
        }
    }
}
