//
//  TextTransitionRenderer.swift
//  TextTransition
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

internal struct TextTransitionRenderer<Transition>: TextRenderer
where Transition: TextTransition {
    private let transition: Transition
    private let stablePrefixCharacterCount: Int
    private let totalCharacterCount: Int
    private var progress: Double

    init(
        _ transition: Transition,
        stablePrefixCharacterCount: Int,
        totalCharacterCount: Int,
        progress: Double
    ) {
        self.transition = transition
        self.stablePrefixCharacterCount = stablePrefixCharacterCount
        self.totalCharacterCount = totalCharacterCount
        self.progress = progress
    }

    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        let runSlices = Array(layout.flattenedRunSlices)
        let stableSliceCount = estimatedStableSliceCount(for: runSlices.count)
        let animatedSliceCount = max(0, runSlices.count - stableSliceCount)

        for (index, slice) in runSlices.enumerated() {
            var copy = context
            if index >= stableSliceCount {
                let localIndex = index - stableSliceCount
                let staggeredProgress = Self.staggeredProgress(
                    baseProgress: progress,
                    index: localIndex,
                    total: animatedSliceCount
                )
                transition.body(context: &copy, progress: staggeredProgress)
            }
            copy.draw(slice)
        }
    }

    private func estimatedStableSliceCount(for sliceCount: Int) -> Int {
        guard sliceCount > 0 else { return 0 }
        guard totalCharacterCount > 0 else { return 0 }

        let ratio: Double =
            Double(stablePrefixCharacterCount) / Double(totalCharacterCount)
        let estimatedCount: Int = Int((Double(sliceCount) * ratio).rounded(.down))

        return min(sliceCount, max(0, estimatedCount))
    }

    private static func staggeredProgress(
        baseProgress: Double,
        index: Int,
        total: Int
    ) -> Double {
        guard total > 0 else { return 1.0 }

        let maxDelay: Double = min(0.36, Double(max(total - 1, 0)) * 0.04)
        let delay: Double = min(Double(index) * 0.04, maxDelay)
        let normalized: Double = max(
            0.0,
            min(1.0, (baseProgress - delay) / max(0.001, 1.0 - maxDelay))
        )

        return normalized * normalized * (3.0 - 2.0 * normalized)
    }
}

extension TextTransitionRenderer: Animatable {
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
}
