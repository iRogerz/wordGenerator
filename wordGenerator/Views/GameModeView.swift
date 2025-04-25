import SwiftUI

struct GameModeView: View {
    @StateObject private var viewModel = GameModeViewModel()
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack(spacing: 30) {
            Text("遊戲設定")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("時間限制：\(viewModel.selectedTimeLimit)秒")
                    .font(.title2)
                
                Slider(value: Binding(
                    get: { Double(viewModel.selectedTimeLimit) },
                    set: { viewModel.selectedTimeLimit = Int($0) }
                ), in: 30...300, step: 30)
                
                Text("字詞類型")
                    .font(.title2)
                
                Picker("選擇類型", selection: $viewModel.selectedWordTypes) {
                    ForEach(WordType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(Set([type]))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: viewModel.selectedWordTypes) { newValue in
                    viewModel.updateWordTypes(newValue)
                }
            }
            .padding()
            
            Button(action: {
                navigationPath.append(viewModel.getGameConfig())
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
