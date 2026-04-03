//
//  TextTransitionViewModifier.swift
//  TextTransition
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

internal struct TextTransitionViewModifier<Transition, Value>: ViewModifier
where Transition: TextTransition, Value: StringProtocol & Equatable {
    private let transition: Transition
    private let value: Value

    @State private var stablePrefixCharacterCount: Int = 0
    @State private var animationProgress: Double = 1.0

    init(
        transition: Transition,
        value: Value
    ) {
        self.transition = transition
        self.value = value
    }

    func body(content: Content) -> some View {
        content
            .textRenderer(
                TextTransitionRenderer(
                    transition,
                    stablePrefixCharacterCount: stablePrefixCharacterCount,
                    totalCharacterCount: value.count,
                    progress: animationProgress
                )
            )
            .onAppear {
                stablePrefixCharacterCount = value.count
                animationProgress = 1.0
            }
            .onChange(of: value, initial: false) { oldValue, newValue in
                stablePrefixCharacterCount = commonPrefixCount(
                    from: oldValue,
                    to: newValue
                )
                animationProgress = 0.0

                withAnimation(.linear) {
                    animationProgress = 1.0
                }
            }
    }

    private func commonPrefixCount(
        from oldValue: Value,
        to newValue: Value
    ) -> Int {
        zip(oldValue, newValue).prefix { $0 == $1 }.count
    }
}
