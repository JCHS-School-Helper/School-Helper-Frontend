import SwiftUI

struct MealView: View {
    @StateObject var mealModel = MealModel()
    @State private var selectedTab = 1
    
    var body: some View {
        if let meals = mealModel.meals {
            if meals.count == 0 {
                Text("급식이 없습니다.")
            } else {
                TabView(selection: $selectedTab) {
                    ForEach(Array(meals.enumerated()), id: \.1) { index, meal in
                        VStack() {
                            HStack {
                                Image(systemName: meal.type == .breakfast ? "sunrise" : meal.type == .lunch ? "sun.max" : "sunset")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                
                                Text(meal.type.rawValue)
                                    .font(.system(size: 20))
                            }
                            .padding(.top, 7.5)
                            
                            Divider()
                                .padding(.vertical, 5)
                            
                            ScrollView {
                                ForEach(meal.menu, id: \.self) { menu in
                                    Text(menu)
                                        .font(.system(size: 16))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 15)
                                }
                            }
                        }
                        .tag(index+1)
                    }
                }
                .onAppear {
                    let now = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"

                    if let lunchIndex = meals.firstIndex(where: { $0.type == .lunch }), formatter.string(from: now) >= "08:30" && formatter.string(from: now) < "13:20" {
                        selectedTab = lunchIndex + 1
                    } else if let dinnerIndex = meals.firstIndex(where: { $0.type == .dinner }), formatter.string(from: now) >= "13:20" {
                        selectedTab = dinnerIndex + 1
                    } else {
                        selectedTab = 1
                    }
                }
                .navigationTitle("급식")
                .tabViewStyle(PageTabViewStyle())
            }
        } else if let error = mealModel.error {
            ErrorView(error: error)
        } else {
            ProgressView()
                .navigationTitle("급식")
                .onAppear {
                    mealModel.fetchMeals()
                }
        }
    }
}
