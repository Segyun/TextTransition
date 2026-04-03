//
//  CombiningTextTransition.swift
//  TextTransition
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

public struct CombiningTextTransition<each Transition: TextTransition>:
    TextTransition
{
    private let transitions: (repeat each Transition)

    public init(_ transitions: repeat each Transition) {
        self.transitions = (repeat each transitions)
    }

    public func body(context: inout GraphicsContext, progress: Double) {
        for transition in repeat each transitions {
            transition
                .body(context: &context, progress: progress)
        }
    }
}
