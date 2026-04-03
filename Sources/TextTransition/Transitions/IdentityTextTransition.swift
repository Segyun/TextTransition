//
//  IdentityTextTransition.swift
//  TextTransition
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

/// A transition that leaves the text unchanged.
public struct IdentityTextTransition: TextTransition {
    public init() {}

    public func body(context: inout GraphicsContext, progress: Double) {}
}

extension TextTransition where Self == IdentityTextTransition {
    /// A transition that performs no visual effect.
    public static var identity: Self { .init() }
}
