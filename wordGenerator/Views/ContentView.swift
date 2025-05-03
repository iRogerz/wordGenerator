//
//  ContentView.swift
//  wordGenerator
//
//  Created by Roger Tseng on 2025/4/18.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var navigationPath = NavigationPath()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 30) {
                Text("猜詞王")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 50)
                
                Button(action: {
                    navigationPath.append("gameMode")
                }) {
                    ModeButton(title: "遊玩模式", description: "限時挑戰，考驗反應力")
                }
                
                Button(action: {
                    navigationPath.append("generatorMode")
                }) {
                    ModeButton(title: "一般模式", description: "自由產生字詞")
                }
            }
            .padding()
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "gameMode":
                    GameModeView(navigationPath: $navigationPath)
                case "generatorMode":
                    GeneratorModeView(navigationPath: $navigationPath)
                default:
                    EmptyView()
                }
            }
            .navigationDestination(for: GameConfig.self) { config in
                GamePlayView(timeLimit: config.timeLimit, wordLengths: config.wordLengths, navigationPath: $navigationPath)
            }
        }
        .onAppear {
            DataImporter.importIfNeeded(context: modelContext)
            WordManager.shared.loadAllWords(context: modelContext)
        }
    }
}

struct ModeButton: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    ContentView()
}
