import SwiftUI
import CoreMotion
import AudioToolbox
import SwiftData

struct GamePlayView: View {
    let timeLimit: Int
    let wordLengths: Set<Int>
    @EnvironmentObject var router: AppRouter
    @StateObject private var viewModel: GamePlayViewModel
    
    init(timeLimit: Int, wordLengths: Set<Int>) {
        self.timeLimit = timeLimit
        self.wordLengths = wordLengths
        _viewModel = StateObject(wrappedValue: GamePlayViewModel(timeLimit: timeLimit, wordLengths: wordLengths))
    }
    
    var body: some View {
        ZStack {
            Color.Background.lightYellow.ignoresSafeArea()
            
            if !viewModel.isGameStarted {
                VStack {
                    Text("\(viewModel.countdown)")
                        .font(.system(size: 120))
                        .fontWeight(.bold)
                        .foregroundColor(.Primary.deepBlue)
                }
            } else {
              ZStack {
                
                VStack {
                  HStack {
                    Button(action: {
                      router.pop()
                    }) {
                      Text("Back")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.Primary.deepBlue)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 28)
                        .background(Color.Primary.orange.opacity(0.6))
                        .cornerRadius(20)
                    }
                    .padding(.leading, 24)
                    .padding(.top, 24)
                    
                    Spacer()
                  }
                  Spacer()
                }
                
                VStack {
                  HStack {
                    Spacer()
                    Text("剩餘時間：\(viewModel.remainingTime)秒")
                      .font(.title)
                      .fontWeight(.bold)
                      .foregroundColor(.Primary.deepBlue)
                      .padding(.vertical, 10)
                      .padding(.horizontal, 32)
                      .background(Color.Primary.orange.opacity(0.6))
                      .cornerRadius(20)
                    
                    Spacer()
                  }
                  .padding(.top, 32)
                  
                  
                  Spacer()
                  
                  if let word = viewModel.currentWord {
                    Text(word.name)
                      .font(.system(size: 90, weight: .bold))
                      .minimumScaleFactor(0.5)
                      .foregroundColor(.Primary.deepBlue)
                      .multilineTextAlignment(.center)
                      .padding(.vertical, 24)
                  }
                  Spacer()
                  HStack(spacing: 20) {
                    ZStack {
                      Circle()
                        .fill(Color.green)
                        .frame(width: 50, height: 50)
                      Image(systemName: "checkmark")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                    }
                    Text("\(viewModel.correctCount)")
                      .font(.title)
                      .fontWeight(.bold)
                      .foregroundColor(.Primary.deepBlue)
                    ZStack {
                      Circle()
                        .fill(Color.red)
                        .frame(width: 50, height: 50)
                      Image(systemName: "xmark")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                    }
                    Text("\(viewModel.wrongCount)")
                      .font(.title)
                      .fontWeight(.bold)
                      .foregroundColor(.Primary.deepBlue)
                  }
//                  .padding(.bottom, 10)
                  Spacer()
                }
              }
            }
        }
        .navigationBarBackButtonHidden()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(viewModel.resultColor, lineWidth: 5)
                .padding()
        )
        .onAppear {
             DispatchQueue.main.async {
               AppDelegate.orientationLock = .landscapeRight
               UIViewController.attemptRotationToDeviceOrientation()
               viewModel.startNewGame()
            }
        }.onDisappear {
            DispatchQueue.main.async {
              viewModel.stopGame()
              AppDelegate.orientationLock = .portrait
              UIViewController.attemptRotationToDeviceOrientation()
            }
        }.onChange(of: viewModel.isGameOver) { isGameOver in
            if isGameOver {
                router.push(.gameOver(GameOverRoute(
                    score: viewModel.score,
                    correctCount: viewModel.correctCount,
                    wrongCount: viewModel.wrongCount,
                    playedWords: viewModel.playedWords
                )))
                viewModel.isGameOver = false
            }
        }
    }
}

#Preview {
    GamePlayView(timeLimit: 60, wordLengths: [2, 3, 4]).environmentObject(AppRouter())
}
