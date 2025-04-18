import SwiftUI

struct GameModeView: View {
    @Binding var navigationPath: NavigationPath
    @State private var selectedTimeLimit = 30
    @State private var selectedWordTypes: Set<WordType> = [.phrase]
    
    var body: some View {
        VStack(spacing: 30) {
            Text("遊戲設定")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("時間限制：\(selectedTimeLimit)秒")
                    .font(.title2)
                
                Slider(value: Binding(
                    get: { Double(selectedTimeLimit) },
                    set: { selectedTimeLimit = Int($0) }
                ), in: 30...300, step: 30)
                
                Text("字詞類型")
                    .font(.title2)
                
                Picker("選擇類型", selection: $selectedWordTypes) {
                    ForEach(WordType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(Set([type]))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedWordTypes) { newValue in
                    if newValue.isEmpty {
                        selectedWordTypes = Set([.phrase])
                    }
                }
            }
            .padding()
            
            Button(action: {
                let wordLengths = Set(selectedWordTypes.flatMap { type -> [Int] in
                    switch type {
                    case .idiom:
                        return [4]
                    case .phrase:
                        return [2, 3]
                    case .random:
                        return [2, 3, 4]
                    }
                })
                navigationPath.append(GameConfig(timeLimit: selectedTimeLimit, wordLengths: wordLengths))
            }) {
                Text("開始遊戲")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct GameConfig: Hashable {
    let timeLimit: Int
    let wordLengths: Set<Int>
}

#Preview {
    GameModeView(navigationPath: .constant(NavigationPath()))
} 
