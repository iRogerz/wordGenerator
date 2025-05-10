import SwiftUI
import SwiftData

struct GeneratorModeView: View {
    @Binding var navigationPath: NavigationPath
    @StateObject private var viewModel = GeneratorModeViewModel()
  
    var body: some View {
        VStack(spacing: 32) {
            CustomSegmentedControl(selectedIndex: $viewModel.selectedType, titles: viewModel.types)
          
          Spacer()
          
            // 單字卡片
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                .fill(Color.Primary.primary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.Primary.deepBlue, lineWidth: 8)
                            .blur(radius: 0.5)
                    )
              
                if let word = viewModel.currentWord {
                    Text(word.name)
                        .font(.system(size: 56, weight: .bold))
                        .foregroundColor(Color.Primary.deepBlue)
                        .padding(32)
                        .minimumScaleFactor(0.6)
                        .lineLimit(0)
                }
            }
            .frame(height: 180)
            .padding(.horizontal, 4)
            
            // 提示卡片
          if viewModel.showHint {
            ZStack {
              RoundedRectangle(cornerRadius: 14)
                .stroke(Color.Primary.orange.opacity(0.5), lineWidth: 4)
                .background(
                  RoundedRectangle(cornerRadius: 14)
                    .fill(Color.Primary.primary)
                )
              if let word = viewModel.currentWord {
                Text(word.note)
                  .font(.title2)
                  .foregroundColor(Color.Primary.orange)
                  .padding(16)
                  .minimumScaleFactor(0.5)
              }
            }
            .padding(.horizontal, 4)
          }
            
            Spacer()
            
            HStack(spacing: 24) {
                Button(action: {
                    viewModel.toggleHint()
                }) {
                    HStack(spacing: 12) {
                      Image(.General.light)
                        .frame(width: 50, height: 50)
                            
                        Text("提示")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.Primary.deepBlue)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.Background.yellow)
                    .cornerRadius(12)
                    .shadow(color: Color.Primary.deepBlue.opacity(0.3), radius: 4, x: 4, y: 4)
                }
                .buttonStyle(NoAnimationButtonStyle())
                
                Button(action: {
                    viewModel.generateNewWord()
                }) {
                    HStack(spacing: 14) {
                      Image(.General.dice)
                        .frame(width: 50, height: 50)
                        Text("產生")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.Primary.orange)
                    .cornerRadius(12)
                    .shadow(color: Color.Primary.deepBlue.opacity(0.3), radius: 4, x: 4, y: 4)
                }
                .buttonStyle(NoAnimationButtonStyle())
              
            }
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 16)
        .background(Color.Background.lightYellow)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.generateNewWord()
        }
    }
}

#Preview {
    GeneratorModeView(navigationPath: .constant(NavigationPath()))
} 
