import SwiftUI
import CoreMotion
import AudioToolbox
import SwiftData

struct GamePlayView: View {
    let timeLimit: Int
    let wordLengths: Set<Int>
    @Binding var navigationPath: NavigationPath
    @Environment(\.modelContext) private var modelContext
    
    @State private var currentWord: GameWord?
    @State private var remainingTime: Int = 0
    @State private var isGameOver = false
    @State private var score = 0
    @State private var motionManager = CMMotionManager()
    @State private var lastAcceleration: Double = 0
    @State private var isCorrect = false
    @State private var isPass = false
    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var canFlip = true
    @State private var isUpsideDown = false
    @State private var showResult = false
    @State private var resultColor: Color = .clear
    @State private var timer: Timer?
    @State private var countdown = 3
    @State private var isGameStarted = false
    @State private var hasJudged = false
    @State private var playedWords: [(word: GameWord, isCorrect: Bool)] = []
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if !isGameStarted {
                VStack {
                    Text("\(countdown)")
                        .font(.system(size: 120))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            } else {
                VStack {
                    Text("剩餘時間：\(remainingTime)秒")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                    
                    Spacer()
                    
                    if let word = currentWord {
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
                            Text("\(correctCount)")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        
                        VStack {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.red)
                            Text("\(wrongCount)")
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
                .stroke(resultColor, lineWidth: 5)
                .padding()
        )
        .onAppear {
            // 鎖定橫向
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
            }
            startNewGame()
        }
        .onDisappear {
            stopMotionUpdates()
            timer?.invalidate()
            // 解除鎖定
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
            }
        }
        .sheet(isPresented: $isGameOver) {
            GameOverView(
                score: score,
                correctCount: correctCount,
                wrongCount: wrongCount,
                playedWords: playedWords,
                navigationPath: $navigationPath,
                onRestart: {
                    isGameOver = false
                    startNewGame()
                }
            )
        }
    }
    
    private func startNewGame() {
        // 停止現有的計時器和動作監測
        timer?.invalidate()
        stopMotionUpdates()
        
        // 重置所有遊戲狀態
        score = 0
        correctCount = 0
        wrongCount = 0
        playedWords = []
        remainingTime = timeLimit
        countdown = 3
        isGameStarted = false
        hasJudged = false
        resultColor = .clear
        currentWord = nil
        
        // 鎖定橫向
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
        }
        startCountdown()
    }
    
    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if countdown > 1 {
                countdown -= 1
            } else {
                timer.invalidate()
                isGameStarted = true
                startGame()
            }
        }
    }
    
    private func startGame() {
        remainingTime = timeLimit
        startTimer()
        startMotionUpdates()
        generateNewWord()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                timer.invalidate()
                stopMotionUpdates()
                isGameOver = true
            }
        }
    }
    
    private func startMotionUpdates() {
        guard motionManager.isAccelerometerAvailable else { return }
        
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { data, _ in
            guard let acceleration = data?.acceleration else { return }
            
            let z = acceleration.z
            let flipThreshold = 0.7    // 翻轉門檻
            let uprightThreshold = 0.3 // 回正門檻
            
            // 如果手機已經歸位，重置狀態並出下一題
            if abs(z) < uprightThreshold {
                if hasJudged {
                    hasJudged = false
                    isUpsideDown = false
                    resultColor = .clear
                    generateNewWord()
                }
                return
            }
            
            // 如果已經判定過，不再重複判定
            if hasJudged {
                return
            }
            
            // 當手機傾斜超過門檻時，立即判定
            if abs(z) > flipThreshold {
                hasJudged = true
                isUpsideDown = true
                
                if z > 0 {
                    // 向下傾斜：答對
                    isCorrect = true
                    score += 1
                    correctCount += 1
                    resultColor = .green
                    if let word = currentWord {
                        playedWords.append((word: word, isCorrect: true))
                    }
                } else {
                    // 向上傾斜：答錯
                    isCorrect = false
                    wrongCount += 1
                    resultColor = .red
                    if let word = currentWord {
                        playedWords.append((word: word, isCorrect: false))
                    }
                }
                
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
        }
    }
    
    private func stopMotionUpdates() {
        motionManager.stopAccelerometerUpdates()
    }
    
    private func generateNewWord() {
        currentWord = WordManager.shared.getRandomWord(lengths: wordLengths)
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
