//
//  FormattedStringTextTransitionViewModifier.swift
//  TextTransition
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

internal struct FormattedStringTextTransitionViewModifier<Transition, Format>:
    ViewModifier
where
    Transition: TextTransition,
    Format: FormatStyle,
    Format.FormatInput: Equatable,
    Format.FormatOutput == String
{
    @Environment(\.locale) private var locale: Locale

    private let transition: Transition
    private let input: Format.FormatInput
    private let format: Format

    private var value: String {
        return format.locale(locale).format(input)
    }

    init(
        transition: Transition,
        input: Format.FormatInput,
        format: Format
    ) {
        self.transition = transition
        self.input = input
        self.format = format
    }

    func body(content: Content) -> some View {
        content
            .modifier(
                TextTransitionViewModifier(transition: transition, value: value)
            )
    }
}
