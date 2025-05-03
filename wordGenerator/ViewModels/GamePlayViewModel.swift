import SwiftUI
import CoreMotion
import AudioToolbox
import SwiftData

class GamePlayViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentWord: GameWord?
    @Published var remainingTime: Int = 0
    @Published var isGameOver = false
    @Published var score = 0
    @Published var isCorrect = false
    @Published var correctCount = 0
    @Published var wrongCount = 0
    @Published var isUpsideDown = false
    @Published var resultColor: Color = .clear
    @Published var countdown = 3
    @Published var isGameStarted = false
    
    // MARK: - Private Properties
    private let timeLimit: Int
    private let wordLengths: Set<Int>
    private var motionManager = CMMotionManager()
    private var timer: Timer?
    private var hasJudged = false
    
    // MARK: - Constants
    private let flipThreshold = 0.7    // 翻轉門檻
    private let uprightThreshold = 0.3 // 回正門檻
    
    // MARK: - Initialization
    init(timeLimit: Int, wordLengths: Set<Int>) {
        self.timeLimit = timeLimit
        self.wordLengths = wordLengths
    }
    
    // MARK: - Public Methods
    func startGame() {
        startCountdown()
    }
    
    func stopGame() {
        stopMotionUpdates()
        timer?.invalidate()
    }
    
    // MARK: - Private Methods
    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if self.countdown > 1 {
                self.countdown -= 1
            } else {
                timer.invalidate()
                self.isGameStarted = true
                self.startGameLogic()
            }
        }
    }
    
    private func startGameLogic() {
        remainingTime = timeLimit
        startTimer()
        startMotionUpdates()
        // generateNewWord() 需由外部呼叫
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                timer.invalidate()
                self.stopMotionUpdates()
                self.isGameOver = true
            }
        }
    }
    
    private func startMotionUpdates() {
        guard motionManager.isAccelerometerAvailable else { return }
        
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let self = self,
                  let acceleration = data?.acceleration else { return }
            
            let z = acceleration.z
            
            // 如果手機已經歸位，重置狀態並出下一題
            if abs(z) < self.uprightThreshold {
                if self.hasJudged {
                    self.hasJudged = false
                    self.isUpsideDown = false
                    self.resultColor = .clear
                    // 這裡需要外部呼叫 generateNewWord()
                }
                return
            }
            
            // 如果已經判定過，不再重複判定
            if self.hasJudged {
                return
            }
            
            // 當手機傾斜超過門檻時，立即判定
            if abs(z) > self.flipThreshold {
                self.hasJudged = true
                self.isUpsideDown = true
                
                if z > 0 {
                    // 向下傾斜：答對
                    self.isCorrect = true
                    self.score += 1
                    self.correctCount += 1
                    self.resultColor = .green
                } else {
                    // 向上傾斜：答錯
                    self.isCorrect = false
                    self.wrongCount += 1
                    self.resultColor = .red
                }
                
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
        }
    }
    
    private func stopMotionUpdates() {
        motionManager.stopAccelerometerUpdates()
    }
    
    // 只從快取 array 取資料
    func generateNewWord() {
        currentWord = WordManager.shared.getRandomWord(lengths: wordLengths)
    }
} 
