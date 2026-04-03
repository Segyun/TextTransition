//
//  MessageView.swift
//  Example
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI
import TextTransition

struct MessageView: View {
    let message: Message

    private var content: AttributedString {
        guard
            let string = try? AttributedString(
                markdown: message.content,
                options: .init(
                    interpretedSyntax: .inlineOnlyPreservingWhitespace,
                    failurePolicy: .returnPartiallyParsedIfPossible
                )
            )
        else { return .init(message.content) }

        return string
    }

    private var foregroundStyle: AnyShapeStyle {
        switch message.role {
        case .system:
            return .init(.red)
        case .user:
            return .init(.white)
        case .assistant:
            return .init(.foreground)
        }
    }

    private var backgroundStyle: AnyShapeStyle {
        switch message.role {
        case .system:
            return .init(.clear)
        case .user:
            return .init(Color.accentColor)
        case .assistant:
            return .init(.background.secondary)
        }
    }

    var body: some View {
        ZStack {
            if message.content.isEmpty {
                ProgressView()
            } else {
                Text(content)
                    .foregroundStyle(foregroundStyle)
                    .textTransition(
                        .offset(x: 0, y: 8)
                            .combined(with: .blur)
                            .combined(with: .opacity),
                        value: message.content
                    )
            }
        }
        .padding()
        .background(backgroundStyle, in: .rect(cornerRadius: 16))
        .geometryGroup()
    }
}
