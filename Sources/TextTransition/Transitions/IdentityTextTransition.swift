//
//  IdentityTextTransition.swift
//  TextTransition
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

public struct IdentityTextTransition: TextTransition {
    public init() {}

    public func body(context: inout GraphicsContext, progress: Double) {}
}

extension TextTransition where Self == IdentityTextTransition {
    public static var identity: Self { .init() }
}
