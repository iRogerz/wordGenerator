import SwiftUI
import CoreMotion
import AudioToolbox

struct GamePlayView: View {
    let timeLimit: Int
    let wordLengths: Set<Int>
    @Binding var navigationPath: NavigationPath
    
    @State private var currentWord: Word?
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
            startCountdown()
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
            GameOverView(score: score, correctCount: correctCount, wrongCount: wrongCount, navigationPath: $navigationPath)
        }
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
            let uprightThreshold = 0.3 // 回正門檻（小於此值代表回正）
            
            // 1. 使用者翻轉：進入顛倒狀態
            if !isUpsideDown && abs(z) > flipThreshold {
                isUpsideDown = true
                lastAcceleration = z
            }
            
            // 2. 使用者已經翻過去，且回正，才進行處理
            if isUpsideDown && abs(z) < uprightThreshold && canFlip {
                // 禁止在冷卻期間觸發
                canFlip = false
                isUpsideDown = false
                
                // 判斷方向：答對還是答錯
                if lastAcceleration > 0 {
                    // 向下翻回正：答對
                    isCorrect = true
                    score += 1
                    correctCount += 1
                    resultColor = .green
                } else {
                    // 向上翻回正：答錯
                    isCorrect = false
                    wrongCount += 1
                    resultColor = .red
                }
                
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
                // 冷卻一秒後：重置狀態 + 出下一題
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    canFlip = true
                    resultColor = .clear
                    generateNewWord()
                }
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
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack(spacing: 20) {
            Text("遊戲結束")
                .font(.title)
                .fontWeight(.bold)
            
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
            
            Button(action: {
                navigationPath.removeLast(navigationPath.count)
            }) {
                Text("返回主畫面")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    GamePlayView(timeLimit: 60, wordLengths: [2, 3, 4], navigationPath: .constant(NavigationPath()))
} 
