import SwiftUI
import CoreMotion
import AudioToolbox
import SwiftData

struct GamePlayView: View {
    let timeLimit: Int
    let wordLengths: Set<Int>
    @Binding var navigationPath: NavigationPath
    @StateObject private var viewModel: GamePlayViewModel
    
    init(timeLimit: Int, wordLengths: Set<Int>, navigationPath: Binding<NavigationPath>) {
        self.timeLimit = timeLimit
        self.wordLengths = wordLengths
        self._navigationPath = navigationPath
        _viewModel = StateObject(wrappedValue: GamePlayViewModel(timeLimit: timeLimit, wordLengths: wordLengths))
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if !viewModel.isGameStarted {
                VStack {
                    Text("\(viewModel.countdown)")
                        .font(.system(size: 120))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            } else {
                VStack {
                    Text("剩餘時間：\(viewModel.remainingTime)秒")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                    
                    Spacer()
                    
                    if let word = viewModel.currentWord {
                        Text(word.name)
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 30) {
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.green)
                            Text("\(viewModel.correctCount)")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        
                        VStack {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.red)
                            Text("\(viewModel.wrongCount)")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(viewModel.resultColor, lineWidth: 5)
                .padding()
        )
        .onAppear {
            // 鎖定橫向
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
            }
            viewModel.startNewGame()
        }
        .onDisappear {
            viewModel.stopGame()
            // 解除鎖定
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
            }
        }
        .sheet(isPresented: $viewModel.isGameOver) {
            GameOverView(
                score: viewModel.score,
                correctCount: viewModel.correctCount,
                wrongCount: viewModel.wrongCount,
                playedWords: viewModel.playedWords,
                navigationPath: $navigationPath,
                onRestart: {
                    viewModel.isGameOver = false
                    viewModel.startNewGame()
                }
            )
        }
    }
}

struct GameOverView: View {
    let score: Int
    let correctCount: Int
    let wrongCount: Int
    let playedWords: [(word: GameWord, isCorrect: Bool)]
    @Binding var navigationPath: NavigationPath
    let onRestart: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("最終分數：\(score)")
                        .font(.title2)
                    
                    HStack(spacing: 30) {
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.green)
                            Text("\(correctCount)")
                                .font(.title2)
                        }
                        
                        VStack {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.red)
                            Text("\(wrongCount)")
                                .font(.title2)
                        }
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("答題記錄")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        
                        ForEach(playedWords.indices, id: \.self) { index in
                            HStack {
                                Text("\(index + 1). \(playedWords[index].word.name)")
                                    .font(.body)
                                
                                Spacer()
                                
                                Image(systemName: playedWords[index].isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(playedWords[index].isCorrect ? .green : .red)
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                }
                .padding()
            }
            .navigationTitle("遊戲結束")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        navigationPath.removeLast(navigationPath.count)
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("返回主畫面")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                        onRestart()
                    }) {
                        HStack {
                            Text("再玩一次")
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    GamePlayView(timeLimit: 60, wordLengths: [2, 3, 4], navigationPath: .constant(NavigationPath()))
} 
