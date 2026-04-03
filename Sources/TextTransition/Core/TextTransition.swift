//
//  TextTransition.swift
//  TextTransition
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

/// A transition that mutates the graphics context for the changing portion of a text layout.
public protocol TextTransition {
    /// Applies the transition to the provided graphics context.
    ///
    /// - Parameters:
    ///   - context: The graphics context used to draw the current text slice.
    ///   - progress: A normalized transition progress value in the `0...1` range.
    func body(context: inout GraphicsContext, progress: Double)
}

extension TextTransition {
    /// Returns a transition that applies this transition followed by another transition.
    public func combined(
        with other: some TextTransition
    ) -> some TextTransition {
        return CombiningTextTransition(self, other)
    }

    /// Re-maps the transition progress with the provided timing curve.
    public func animation(
        _ animation: UnitCurve?
    ) -> some TextTransition {
        return FilteredTextTransition(animation: animation, transition: self)
    }
}
