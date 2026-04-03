//
//  ContentView.swift
//  Example
//
//  Created by Huigyun Jeong on 4/3/26.
//

import SwiftUI

struct ContentView: View {
    @State private var sessionManager: SessionManager = .init()
    @State private var content: String = ""
    @State private var prompt: String = ""
    @State private var scrollPosition: ScrollPosition = .init(idType: UUID.self, edge: .bottom)

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(sessionManager.messages) { message in
                        let alignment: Alignment =
                            switch message.role {
                            case .system: .center
                            case .user: .trailing
                            case .assistant: .leading
                            }

                        MessageView(message: message)
                            .frame(
                                maxWidth: .infinity,
                                alignment: alignment
                            )
                            .animation(.default, value: message.content)
                    }
                }
            }
            .contentMargins(16, for: .scrollContent)
            .scrollPosition($scrollPosition)
            .scrollEdgeEffectStyle(.soft, for: .vertical)
            .safeAreaBar(edge: .bottom) {
                HStack {
                    TextField(
                        "Prompt",
                        text: $prompt,
                        prompt: Text("Ask anything...").italic()
                    )
                    .onSubmit {
                        requestAction()
                    }

                    let isGenerating: Bool = sessionManager.isGenerating

                    Button(
                        isGenerating ? "Stop" : "Send",
                        systemImage: isGenerating ? "stop.circle.fill" : "arrow.up.circle.fill"
                    ) {
                        if isGenerating {
                            sessionManager.stop()
                        } else {
                            requestAction()
                        }
                    }
                    .labelStyle(.iconOnly)
                    .font(.title)
                    .disabled(!isGenerating && prompt.isEmpty)
                }
                .padding()
                .glassEffect()
                .safeAreaPadding()
            }
            .toolbar {
                ToolbarItem {
                    Button("Reset", systemImage: "trash", role: .destructive) {
                        sessionManager.reset()
                    }
                    .tint(.red)
                }
            }
            .onChange(of: sessionManager.messages.last?.content) {
                guard let lastMessage = sessionManager.messages.last else { return }

                withAnimation {
                    scrollPosition.scrollTo(id: lastMessage.id)
                }
            }
        }
    }

    private func requestAction() {
        guard sessionManager.isGenerating == false else { return }

        sessionManager.request(prompt: prompt)
        prompt = ""
    }
}

#Preview {
    ContentView()
}
