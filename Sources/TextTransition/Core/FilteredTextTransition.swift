//
//  FilteredTextTransition.swift
//  TextTransition
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

public struct FilteredTextTransition<Transition>: TextTransition
where Transition: TextTransition {
    let animation: UnitCurve?
    private let transition: Transition

    init(
        animation: UnitCurve?,
        transition: Transition
    ) {
        self.animation = animation
        self.transition = transition
    }

    func body(context: inout GraphicsContext, progress: Double) {
        // Apply an optional timing curve before forwarding progress to the wrapped transition.
        let animatedProgress: Double = animation?.value(at: progress) ?? 1.0
        transition.body(context: &context, progress: animatedProgress)
    }
}
