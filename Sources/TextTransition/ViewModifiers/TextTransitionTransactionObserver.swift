import SwiftUI

#if canImport(UIKit)
    import UIKit

    internal struct TextTransitionTransactionObserver: UIViewRepresentable {
        let value: String
        let onValueChange: @MainActor (String, Bool) -> Void

        func makeCoordinator() -> Coordinator {
            Coordinator()
        }

        func makeUIView(context: Context) -> UIView {
            UIView(frame: .zero)
        }

        func updateUIView(_ uiView: UIView, context: Context) {
            guard context.coordinator.lastValue != value else { return }

            context.coordinator.lastValue = value

            let isAnimated: Bool =
                context.transaction.animation != nil
                && context.transaction.disablesAnimations == false

            Task { @MainActor in
                onValueChange(value, isAnimated)
            }
        }

        final class Coordinator {
            var lastValue: String?
        }
    }
#elseif canImport(AppKit)
    import AppKit

    internal struct TextTransitionTransactionObserver: NSViewRepresentable {
        let value: String
        let onValueChange: @MainActor (String, Bool) -> Void

        func makeCoordinator() -> Coordinator {
            Coordinator()
        }

        func makeNSView(context: Context) -> NSView {
            NSView(frame: .zero)
        }

        func updateNSView(_ nsView: NSView, context: Context) {
            guard context.coordinator.lastValue != value else { return }

            context.coordinator.lastValue = value

            let isAnimated: Bool =
                context.transaction.animation != nil
                && context.transaction.disablesAnimations == false

            Task { @MainActor in
                onValueChange(value, isAnimated)
            }
        }

        final class Coordinator {
            var lastValue: String?
        }
    }
#else
    internal struct TextTransitionTransactionObserver: View {
        let value: String
        let onValueChange: @MainActor (String, Bool) -> Void

        var body: some View {
            Color.clear
                .onChange(of: value, initial: false) { _, newValue in
                    Task { @MainActor in
                        onValueChange(newValue, false)
                    }
                }
        }
    }
#endif
