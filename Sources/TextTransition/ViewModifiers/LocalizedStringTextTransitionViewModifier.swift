//
//  LocalizedStringTextTransitionViewModifier.swift
//  TextTransition
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

internal struct LocalizedStringTextTransitionViewModifier<Transition>: ViewModifier
where Transition: TextTransition {
    @Environment(\.locale) private var locale: Locale

    private let transition: Transition
    private let resource: LocalizedStringResource

    private var value: String {
        var copy = resource
        copy.locale = locale
        return String.init(localized: copy)
    }

    init(
        transition: Transition,
        resource: LocalizedStringResource
    ) {
        self.transition = transition
        self.resource = resource.localizedStringResource
    }

    func body(content: Content) -> some View {
        content
            .modifier(
                TextTransitionViewModifier(transition: transition, value: value)
            )
    }
}
