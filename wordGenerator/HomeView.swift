//
//  HomeView.swift
//  wordGenerator
//
//  Created by Roger Tseng on 2025/4/18.
//

import SwiftData
import SwiftUI

struct HomeView: View {
  @StateObject private var router = AppRouter()
  @Environment(\.modelContext) private var modelContext

  var body: some View {
    NavigationStack(path: $router.path) {
      ZStack {
        Color.Background.yellow
          .ignoresSafeArea()
        VStack {
          
          // 卡片直向滑動區塊
          ScrollView(.vertical, showsIndicators: false) {
            Image(.Home.icon)
              .resizable()
              .frame(width: 160, height: 160)
            
            VStack(spacing: 30) {
              Button(action: {
                router.push(.gameMode)
              }) {
                ModeButton(title: "遊戲模式", image: .Home.gameMode, mainColor: .Primary.orange, buttonType: .right)
                  .padding(.horizontal, 40)
              }
              Button(action: {
                router.push(.generatorMode)
              }) {
                ModeButton(title: "一般模式", image: .Home.generalMode, mainColor: .Primary.deepBlue, buttonType: .left)
                  .padding(.horizontal, 40)
              }
              Button(action: {
                router.push(.idiomFillIn)
              }) {
                ModeButton(title: "成語填空", image: .Home.idiomFill, mainColor: .Primary.orange, buttonType: .right)
                  .padding(.horizontal, 40)
              }
            }
          }
          
          Spacer().frame(height: 16)
          
          Text("資料來源：教育部《國語辭典簡編本》, 《成語典》")
            .font(.footnote)
            .foregroundColor(.Background.lightYellow)
        }
        .padding(.horizontal)
        
      }
      .navigationDestination(for: AppRoute.self) { route in
        switch route {
        case .gameMode:
          GameSettingModeView()
            .enablePopGesture()
        case .generatorMode:
          GeneratorModeView()
            .enablePopGesture()
        case .idiomFillIn:
          IdiomFillInView()
            .enablePopGesture()
        case .gamePlay(let config):
          GamePlayView(timeLimit: config.timeLimit, wordLengths: config.wordLengths)
        case .gameOver(let overRoute):
          GameOverView(
            score: overRoute.score,
            correctCount: overRoute.correctCount,
            wrongCount: overRoute.wrongCount,
            playedWords: overRoute.playedWords,
            onRestart: {
              router.pop()
            }
          )
        }
      }
    }
    .tint(.Primary.deepBlue)
    .environmentObject(router)
    .onAppear {
      DataImporter.importIfNeeded(context: modelContext)
      WordManager.shared.loadAllWords(context: modelContext)
    }
  }
}

#Preview {
  HomeView()
}
