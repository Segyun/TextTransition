//
//  OffsetTextTransition.swift
//  TextTransition
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

public struct OffsetTextTransition: TextTransition {
    private let offset: CGSize

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
    public static func offset(x: CGFloat, y: CGFloat) -> Self {
        .init(offset: .init(width: x, height: y))
    }

    public static func offset(_ offset: CGSize) -> Self {
        .init(offset: offset)
    }
}
