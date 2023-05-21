import SwiftUI

struct ErrorView: View {
    let error: Error
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .padding(.bottom, 5)
            
            Text("오류가 발생했습니다.")
                .font(.system(size: 16, weight: .bold))
            
            Divider()
                .padding(.vertical, 10)
            
            Text(error.localizedDescription)
                .font(.system(size: 14, weight: .light))
        }
        .padding()
        .navigationTitle("오류")
    }
}
