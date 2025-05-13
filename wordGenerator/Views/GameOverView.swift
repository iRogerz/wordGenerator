//
//  GameOverView.swift
//  wordGenerator
//
//  Created by Roger Tseng on 2025/5/11.
//

import Foundation
import SwiftUI

struct PlayedWord: Hashable, Equatable {
    let word: GameWord
    let isCorrect: Bool
}

struct GameOverRoute: Hashable, Equatable {
    let score: Int
    let correctCount: Int
    let wrongCount: Int
    let playedWords: [PlayedWord]
}

struct GameOverView: View {
    let score: Int
    let correctCount: Int
    let wrongCount: Int
    let playedWords: [PlayedWord]
    @Binding var navigationPath: NavigationPath
    let onRestart: () -> Void
    
    var body: some View {
        ZStack {
            Color.Background.yellow.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Button(action: {
                            navigationPath.removeLast(navigationPath.count)
                        }) {
                            Text("返回主畫面")
                        }
                        .buttonStyle(OutlinedButtonStyle())
                        Spacer()
                        Button(action: {
                            onRestart()
                        }) {
                            Text("再玩一次")
                        }
                        .buttonStyle(OutlinedButtonStyle())
                    }
                    .padding(.horizontal)
                    
                    Text("答題紀錄")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.Primary.deepBlue)
                        .padding(.top, 10)
                    
                    // 分數區塊
                    HStack(spacing: 60) {
                        VStack {
                            Image(systemName: "checkmark")
                                .font(.system(size: 50))
                                .bold()
                                .foregroundColor(.green)
                            Text("\(correctCount)")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.Primary.deepBlue)
                        }
                        VStack {
                            Image(systemName: "xmark")
                                .font(.system(size: 50))
                                .bold()
                                .foregroundColor(.red)
                            Text("\(wrongCount)")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.Primary.deepBlue)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.white).opacity(0.7))
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.Primary.deepBlue, lineWidth: 8)
                    )
                    .padding(.horizontal)
                    
                    // 答題紀錄列表
                    VStack(alignment: .leading, spacing: 10) {
                        Text("答題紀錄")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.Primary.deepBlue)
                            .padding(.bottom, 5)
                        ForEach(playedWords.indices, id: \.self) { index in
                            HStack {
                                Text("\(index + 1). \(playedWords[index].word.name)")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.Primary.deepBlue)
                                Spacer()
                                Image(systemName: playedWords[index].isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(playedWords[index].isCorrect ? .green : .red)
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                            .background(Color(.white).opacity(0.7))
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color(.white).opacity(0.3))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    Spacer(minLength: 20)
                }
                .padding(.vertical, 20)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
  @Previewable @State var path = NavigationPath()
  GameOverView(
      score: 88,
      correctCount: 6,
      wrongCount: 9,
      playedWords: [
        PlayedWord(word: GameWord(name: "脫位", note: "", type: .simple, idiom: nil), isCorrect: false),
        PlayedWord(word: GameWord(name: "脫位", note: "", type: .simple, idiom: nil), isCorrect: false),
        PlayedWord(word: GameWord(name: "脫位", note: "", type: .simple, idiom: nil), isCorrect: false),
        PlayedWord(word: GameWord(name: "脫位", note: "", type: .simple, idiom: nil), isCorrect: false)
      ],
//      playedWords: [
//          (word: GameWord(name: "脫位", note: "", type: .simple, idiom: nil), isCorrect: false),
//          (word: GameWord(name: "杞人憂天", note: "", type: .simple, idiom: nil), isCorrect: true),
//          (word: GameWord(name: "吐血", note: "", type: .simple, idiom: nil), isCorrect: true),
//          (word: GameWord(name: "賤高", note: "", type: .simple, idiom: nil), isCorrect: true),
//          (word: GameWord(name: "百繭", note: "", type: .simple, idiom: nil), isCorrect: true),
//          (word: GameWord(name: "初生之犢不畏虎", note: "", type: .simple, idiom: nil), isCorrect: true),
//          (word: GameWord(name: "豔莊", note: "", type: .simple, idiom: nil), isCorrect: false),
//          (word: GameWord(name: "鞭辟入裡", note: "", type: .simple, idiom: nil), isCorrect: false),
//          (word: GameWord(name: "一箭雙鵰", note: "", type: .simple, idiom: nil), isCorrect: false),
//          (word: GameWord(name: "畫蛇添足", note: "", type: .simple, idiom: nil), isCorrect: false),
//          (word: GameWord(name: "一舉兩得", note: "", type: .simple, idiom: nil), isCorrect: false),
//      ],
      navigationPath: $path,
      onRestart: {}
  )
  .previewInterfaceOrientation(.landscapeLeft)
}


