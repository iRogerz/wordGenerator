//
//  ContentView.swift
//  wordGenerator
//
//  Created by Roger Tseng on 2025/4/18.
//

import SwiftData
import SwiftUI


struct ContentView: View {
  @State private var navigationPath = NavigationPath()
  @Environment(\.modelContext) private var modelContext

  var body: some View {
    NavigationStack(path: $navigationPath) {
      VStack {
        Image(.Home.icon)
          .resizable()
          .frame(width: 180, height: 180)

        VStack(spacing: 40) {
          Button(action: {
            navigationPath.append("gameMode")
          }) {
            ModeButton(title: "遊戲模式", image: .Home.gameMode, mainColor: .Primary.orange, buttonType: .right)
              .padding(.horizontal, 40)
          }
          
          Button(action: {
            navigationPath.append("generatorMode")
          }) {
            ModeButton(title: "一般模式", image: .Home.generalMode, mainColor: .Primary.deepBlue, buttonType: .left)
              .padding(.horizontal, 40)
          }
        }
        .buttonStyle(NoAnimationButtonStyle())
        
        
        Spacer().frame(height: 70)

        Text("資料來源：教育部《國語辭典簡編本》, 《成語典》")
          .font(.footnote)
          .foregroundColor(.gray.opacity(0.8))
      }
      .padding()
      .background(Color.Background.yellow)
      .navigationDestination(for: String.self) { destination in
        switch destination {
        case "gameMode":
          GameSettingModeView(navigationPath: $navigationPath)
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

#Preview {
  ContentView()
}
