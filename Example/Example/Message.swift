//
//  Message.swift
//  Example
//
//  Created by Huigyun Jeong on 4/3/26.
//

import Foundation

@Observable
final class Message: Identifiable {
    let id: UUID

    var role: ChatRole
    var content: String

    init(
        id: UUID = .init(),
        role: ChatRole,
        content: String
    ) {
        self.id = id
        self.role = role
        self.content = content
    }
}

extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id && lhs.role == rhs.role && lhs.content == rhs.content
    }
}
