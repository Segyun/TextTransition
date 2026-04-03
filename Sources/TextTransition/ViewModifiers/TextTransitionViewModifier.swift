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

    @State private var displayedValue: String = ""
    @State private var stablePrefixCharacterCount: Int = 0
    @State private var animationProgress: Double = 1.0
    @State private var pendingAnimationTask: Task<Void, Never>?

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
                    totalCharacterCount: displayedValue.count,
                    progress: animationProgress
                )
            )
            .background {
                TextTransitionTransactionObserver(value: String(value)) { newValue, isAnimated in
                    handleValueChange(to: newValue, isAnimated: isAnimated)
                }
                .frame(width: 0, height: 0)
            }
            .onAppear {
                pendingAnimationTask?.cancel()
                displayedValue = String(value)
                stablePrefixCharacterCount = displayedValue.count
                animationProgress = 1.0
            }
            .onDisappear {
                pendingAnimationTask?.cancel()
                pendingAnimationTask = nil
            }
    }

    @MainActor
    private func handleValueChange(to newValue: String, isAnimated: Bool) {
        guard displayedValue != newValue else { return }

        guard isAnimated else {
            pendingAnimationTask?.cancel()
            pendingAnimationTask = nil
            displayedValue = newValue
            stablePrefixCharacterCount = displayedValue.count
            animationProgress = 1.0
            return
        }

        pendingAnimationTask?.cancel()
        pendingAnimationTask = nil

        stablePrefixCharacterCount = commonPrefixCount(from: displayedValue, to: newValue)
        displayedValue = newValue
        animationProgress = 0.0

        pendingAnimationTask = Task { @MainActor in
            // Start the explicit linear animation on the next run loop so SwiftUI
            // can commit the reset progress before interpolating to the final value.
            await Task.yield()
            guard Task.isCancelled == false else { return }

            withAnimation(.linear(duration: animationDuration)) {
                animationProgress = 1.0
            }

            pendingAnimationTask = nil
        }
    }

    private func commonPrefixCount(from oldValue: String, to newValue: String) -> Int {
        zip(oldValue, newValue).prefix { $0 == $1 }.count
    }

    private var animationDuration: Double { 0.5 }
}
