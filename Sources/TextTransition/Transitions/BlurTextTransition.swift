//
//  BlurTextTransition.swift
//  TextTransition
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

public struct BlurTextTransition: TextTransition {
    private let radius: CGFloat

    public init(radius: CGFloat) {
        self.radius = radius
    }

    public func body(context: inout GraphicsContext, progress: Double) {
        context.addFilter(.blur(radius: radius * (1 - progress)))
    }
}

extension TextTransition where Self == BlurTextTransition {
    public static var blur: Self { .init(radius: 4) }

    public static func blur(radius: CGFloat) -> Self { .init(radius: radius) }
}
