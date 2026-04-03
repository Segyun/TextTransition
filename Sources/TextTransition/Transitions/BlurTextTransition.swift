//
//  BlurTextTransition.swift
//  TextTransition
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

/// A transition that animates newly inserted text from blurred to sharp.
public struct BlurTextTransition: TextTransition {
    private let radius: CGFloat

    /// Creates a blur transition with the provided maximum blur radius.
    public init(radius: CGFloat) {
        self.radius = radius
    }

    public func body(context: inout GraphicsContext, progress: Double) {
        context.addFilter(.blur(radius: radius * (1 - progress)))
    }
}

extension TextTransition where Self == BlurTextTransition {
    /// A blur transition with the default blur radius.
    public static var blur: Self { .init(radius: 4) }

    /// A blur transition with a custom blur radius.
    public static func blur(radius: CGFloat) -> Self { .init(radius: radius) }
}
