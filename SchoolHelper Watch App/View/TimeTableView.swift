import SwiftUI

struct TimeTableView: View {
    @StateObject var timeTableModel = TimeTableModel()
    @State var showSettingsView = false
    
    var body: some View {
        if let timeTable = timeTableModel.timeTable {
            ScrollView {
                NavigationLink(destination:  SettingsView(onSave: { grade, clazz, number in
                    self.showSettingsView = false
                    timeTableModel.fetchTimeTable(grade: grade, clazz: clazz, id: number)
                })) {
                    HStack {
                        Image(systemName: "gear")
                        
                        Text("설정")
                            .font(.system(size: 16))
                    }
                }
                
                Divider()
                
                ForEach(Array(timeTable.enumerated()), id: \.element.id) { (index, table) in
                    HStack {
                        Text("\(table.period)교시")
                            .font(.system(size: 16))

                        Text(table.lecture)
                            .font(.system(size: 16))
                    }
                    
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Text(table.location)
                            .font(.system(size: 14))

                        Text("-")
                            .font(.system(size: 14))
                            .padding(.horizontal, 2)
                            
                        Text(table.teacher)
                            .font(.system(size: 14))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 38)
                    
                    if index != timeTable.count - 1 {
                        Divider()
                            .padding(.vertical, 3)
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 5)
            .navigationTitle("시간표")
            .tabViewStyle(PageTabViewStyle())
        } else if let error = timeTableModel.error {
            ErrorView(error: error)
        } else if showSettingsView {
            SettingsView(onSave: { grade, clazz, number in
                self.showSettingsView = false
                timeTableModel.fetchTimeTable(grade: grade, clazz: clazz, id: number)
            })
        } else {
            ProgressView()
                .navigationTitle("시간표")
                .onAppear {
                    let grade = UserDefaults.standard.integer(forKey: "grade")
                    let clazz = UserDefaults.standard.integer(forKey: "clazz")
                    let id = UserDefaults.standard.integer(forKey: "id")
                    
                    if (grade == 0 || clazz == 0 || id == 0) {
                        self.showSettingsView = true
                    } else {
                        self.showSettingsView = false
                        timeTableModel.fetchTimeTable(grade: grade, clazz: clazz, id: id)
                    }
                }
        }
    }
}
