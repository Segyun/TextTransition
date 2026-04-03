//
//  View+TextTransition.swift
//  TextTransition
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

extension View {
    /// Animates text changes for a plain string value.
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

    /// Animates text changes for a localized string resource.
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

    /// Animates text changes for a formatted value.
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
