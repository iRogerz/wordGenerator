import SwiftUI

struct GameSettingModeView: View {
    @StateObject private var viewModel = GameModeViewModel()
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            Text("遊戲設定")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.Primary.deepBlue)
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                  Image(systemName: "hourglass")
                    .font(.title2)
                    .foregroundColor(.Primary.deepBlue)
                  Text("時間限制：\(viewModel.selectedTimeLimit)秒")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.Primary.deepBlue)
                }
                
                Slider(value: Binding(
                    get: { Double(viewModel.selectedTimeLimit) },
                    set: { viewModel.selectedTimeLimit = Int($0) }
                ), in: 30...300, step: 30)
                .tint(.Primary.deepBlue)
              
              HStack {
                Image(.General.translate)
                  .font(.title2)
                  .foregroundColor(.Primary.deepBlue)
                Text("字詞類型")
                  .font(.title2)
                  .fontWeight(.bold)
                  .foregroundColor(.Primary.deepBlue)
              }
                
                CustomSegmentedControl(selectedIndex: $viewModel.selectedWordTypeIndex, titles: [WordType.simple.rawValue, WordType.idiom.rawValue])
                
              VStack(alignment: .leading, spacing: 8) {
                HStack {
                  Image(.General.wordLength)
                    .font(.title2)
                  Text("詞語長度")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.Primary.deepBlue)
                }
                
                VStack(spacing: 8) {
                  ForEach(WordLengthOption.allCases, id: \.self) { option in
                    Toggle(isOn: Binding(
                      get: { viewModel.selectedWordLengths.contains(option) },
                      set: { isOn in
                        if isOn {
                          viewModel.selectedWordLengths.insert(option)
                        } else {
                          viewModel.selectedWordLengths.remove(option)
                        }
                      }
                    )) {
                      Text(option.displayText)
                        .font(.title3)
                        .bold()
                        .foregroundColor(.Primary.deepBlue)
                    }
                    .toggleStyle(.switch)
                    .tint(.Primary.deepBlue)
                    
                  }
                }
                .padding(.vertical, 8)
              }
              .padding(.top, 8)
              .opacity(viewModel.selectedWordTypeIndex == 0 ? 1 : 0)

            }
            .padding()
            
            Button(action: {
                navigationPath.append(viewModel.getGameConfig())
            }) {
                Text("開始遊戲")
                    .font(.title2)
                    .foregroundColor(.white)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.Primary.orange)
                    .cornerRadius(10)
                    .shadow(radius: 2)
            }
            .padding(.horizontal)
          
          Spacer()
        }
        .padding()
        .background(Color.Background.lightYellow)
    }
}

struct GameConfig: Hashable {
    let timeLimit: Int
    let wordLengths: Set<Int>
}

#Preview {
  GameSettingModeView(navigationPath: .constant(NavigationPath()))
} 
