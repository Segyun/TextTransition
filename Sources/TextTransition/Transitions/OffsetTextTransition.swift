//
//  OffsetTextTransition.swift
//  TextTransition
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

/// A transition that animates newly inserted text from an offset position.
public struct OffsetTextTransition: TextTransition {
    private let offset: CGSize

    /// Creates an offset transition with the provided displacement.
    public init(offset: CGSize) {
        self.offset = offset
    }

    public func body(context: inout GraphicsContext, progress: Double) {
        context.translateBy(
            x: (1 - progress) * offset.width,
            y: (1 - progress) * offset.height
        )
    }
}

extension TextTransition where Self == OffsetTextTransition {
    /// An offset transition created from horizontal and vertical components.
    public static func offset(x: CGFloat, y: CGFloat) -> Self {
        .init(offset: .init(width: x, height: y))
    }

    /// An offset transition created from a `CGSize` value.
    public static func offset(_ offset: CGSize) -> Self {
        .init(offset: offset)
    }
}
