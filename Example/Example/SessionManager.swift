//
//  SessionManager.swift
//  Example
//
//  Created by Huigyun Jeong on 4/3/26.
//

import Foundation
import FoundationModels

@Observable
final class SessionManager {
    private let model: SystemLanguageModel
    private var session: LanguageModelSession

    private(set) var messages: [Message]
    private var requestTask: Task<Void, Never>?

    var isAvailable: Bool { model.isAvailable }
    var isGenerating: Bool { requestTask != nil }

    init() {
        self.model = .default
        self.session = .init(model: model)

        self.messages = []
        self.requestTask = nil
    }

    func request(prompt: String) {
        guard isAvailable else {
            print("Error: language model is not available")
            return
        }

        self.requestTask = .init {
            defer {
                self.requestTask = nil
            }

            self.messages.append(
                .init(role: .user, content: prompt)
            )

            let message: Message = .init(role: .assistant, content: "")
            self.messages.append(message)

            do {
                let stream = self.session.streamResponse(to: prompt)

                for try await partialResult in stream {
                    message.content = partialResult.content
                    try? await Task.sleep(for: .seconds(0.3))
                }
            } catch {
                message.role = .system
                message.content = error.localizedDescription
                print("Failed to response: \(error)")
            }
        }
    }

    func stop() {
        self.requestTask?.cancel()
    }

    func reset() {
        requestTask?.cancel()
        session = .init(model: model)
        messages = []
    }
}
