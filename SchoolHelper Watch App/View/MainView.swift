import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                NavigationLink(destination: TimeTableView()) {
                    HStack {
                        Image(systemName: "clock.badge.checkmark")
                        
                        Text("시간표")
                            .font(.system(size: 16))
                    }
                }
                
                NavigationLink(destination: MealView()) {
                    HStack {
                        Image(systemName: "fork.knife")
                        
                        Text("급식")
                            .font(.system(size: 16))
                    }
                }
            }
        }
    }
}
