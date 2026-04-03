//
//  OpacityTextTransition.swift
//  TextTransition
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

public struct OpacityTextTransition: TextTransition {
    public init() {}

    public func body(context: inout GraphicsContext, progress: Double) {
        context.opacity = progress
    }
}

extension TextTransition where Self == OpacityTextTransition {
    public static var opacity: Self { .init() }
}
