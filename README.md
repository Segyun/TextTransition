# TextTransition

[![Swift](https://img.shields.io/badge/Swift-6.0+-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-18.0+-blue.svg)](https://developer.apple.com/ios/)
[![macOS](https://img.shields.io/badge/macOS-15.0+-blue.svg)](https://developer.apple.com/macos/)
[![visionOS](https://img.shields.io/badge/visionOS-2.0+-blue.svg)](https://developer.apple.com/visionos/)
[![SPM](https://img.shields.io/badge/Swift_Package_Manager-compatible-green.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)

**TextTransition** lets you animate text updates in SwiftUI with composable text-specific transitions such as blur, offset, and opacity.

<p align="center">
  <img width=256 src="https://github.com/user-attachments/assets/4e86cf63-3d13-4940-a2e4-127184bb74e8"/>
</p>

## Demo

The [Example project](Example) shows a streaming chat-style interface where message text animates as content changes over time.

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/Segyun/TextTransition.git", from: "1.0.0")
]
```

Or add the package in Xcode with:

```text
https://github.com/Segyun/TextTransition.git
```

## Usage

Apply `textTransition(_:value:)` to a `Text` view and drive the content change with a SwiftUI animation transaction.

```swift
import SwiftUI
import TextTransition

struct ContentView: View {
    @State private var text: String = "Hello"

    var body: some View {
        VStack {
            Text(text)
                .textTransition(
                    .blur
                        .combined(with: .offset(x: 0, y: 8))
                        .combined(with: .opacity),
                    value: text
                )
                .animation(.default, value: text)

            Button("Change") {
                text = "Hello, TextTransition"
            }
        }
    }
}
```

You can also trigger the change explicitly with `withAnimation`:

```swift
withAnimation(.default) {
    text = "Updated"
}
```

## Available Transitions

- `identity`
- `blur`
- `blur(radius:)`
- `offset(x:y:)`
- `offset(_:)`
- `opacity`

Transitions can be combined:

```swift
let transition = TextTransition.blur
    .combined(with: .offset(x: 0, y: 8))
    .combined(with: .opacity)
```

You can also remap timing with a `UnitCurve`:

```swift
let transition = TextTransition.blur
    .combined(with: .opacity)
    .animation(.easeInOut)
```

## Custom Transitions

You can create your own transition by conforming to `TextTransition`.

`body(context:progress:)` gives you access to the `GraphicsContext` used for drawing each animated text slice, along with a normalized progress value in the `0...1` range.

```swift
import SwiftUI
import TextTransition

struct ScaleTextTransition: TextTransition {
    func body(context: inout GraphicsContext, progress: Double) {
        let scale = 0.8 + (0.2 * progress)
        context.scaleBy(x: scale, y: scale)
        context.opacity = progress
    }
}
```

You can use a custom transition the same way as the built-in ones:

```swift
Text(text)
    .textTransition(ScaleTextTransition(), value: text)
    .animation(.default, value: text)
```

## Notes

- `TextTransition` only runs when the text change happens inside an animation transaction, such as `.animation(_:value:)` or `withAnimation`.
- The package currently supports `String`, localized string resources, and formatted string output through dedicated overloads.
- Platform requirements are `iOS 18`, `macOS 15`, `tvOS 18`, `watchOS 11`, and `visionOS 2`.

## Example Code

The [Example project](Example) demonstrates how to use `TextTransition` in a real SwiftUI app. It includes a streaming message UI that updates text incrementally and applies text-specific transitions as the content changes.

## License

This library is released under the MIT License. See [LICENSE](LICENSE) for details.
