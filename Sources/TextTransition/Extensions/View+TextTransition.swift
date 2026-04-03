//
//  View+TextTransition.swift
//  TextTransition
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

extension View {
    public func textTransition(
        _ transition: some TextTransition,
        value: some StringProtocol
    ) -> some View {
        self
            .modifier(
                TextTransitionViewModifier(
                    transition: transition,
                    value: value
                )
            )
    }

    public func textTransition(
        _ transition: some TextTransition,
        resource: LocalizedStringResource
    ) -> some View {
        self
            .modifier(
                LocalizedStringTextTransitionViewModifier(
                    transition: transition,
                    resource: resource
                )
            )
    }

    public func textTransition<Format>(
        _ transition: some TextTransition,
        input: Format.FormatInput,
        format: Format
    ) -> some View
    where
        Format: FormatStyle,
        Format.FormatInput: Equatable,
        Format.FormatOutput == String
    {
        self
            .modifier(
                FormattedStringTextTransitionViewModifier(
                    transition: transition,
                    input: input,
                    format: format
                )
            )
    }
}
