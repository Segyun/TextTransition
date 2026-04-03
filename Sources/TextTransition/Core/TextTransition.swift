//
//  TextTransition.swift
//  TextTransition
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

public protocol TextTransition {
    func body(context: inout GraphicsContext, progress: Double)
}

extension TextTransition {
    public func combined(
        with other: some TextTransition
    ) -> some TextTransition {
        return CombiningTextTransition(self, other)
    }

    public func animation(
        _ animation: UnitCurve?
    ) -> some TextTransition {
        return FilteredTextTransition(animation: animation, transition: self)
    }
}
