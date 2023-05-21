import SwiftUI

struct SettingsView: View {
    @State private var grade: Int = UserDefaults.standard.integer(forKey: "grade")
    @State private var clazz: Int = UserDefaults.standard.integer(forKey: "clazz")
    @State private var id: Int = UserDefaults.standard.integer(forKey: "id")
    
    @Environment(\.presentationMode) var presentationMode
    
    var onSave: (Int, Int, Int) -> Void
    
    var body: some View {
        Form {
            Section(header: Text("학년")) {
                Picker("학년", selection: $grade) {
                    ForEach(1..<4) { i in
                        Text("\(i) 학년").tag(i)
                    }
                }
            }
            
            Section(header: Text("반")) {
                Picker("반", selection: $clazz) {
                    ForEach(1..<8) { i in
                        Text("\(i) 반").tag(i)
                    }
                }
            }
            
            Section(header: Text("번호")) {
                Picker("번호", selection: $id) {
                    ForEach(1..<31) { i in
                        Text("\(i) 번").tag(i)
                    }
                }
            }
            
            Section {
                Button("저장") {
                    UserDefaults.standard.set(grade, forKey: "grade")
                    UserDefaults.standard.set(clazz, forKey: "clazz")
                    UserDefaults.standard.set(id, forKey: "id")
                    
                    onSave(grade, clazz, id)
                    
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationTitle("설정")
        .onAppear {
            if grade == 0 { UserDefaults.standard.set(1, forKey: "grade") }
            if clazz == 0 { UserDefaults.standard.set(1, forKey: "clazz") }
            if id == 0 { UserDefaults.standard.set(1, forKey: "id") }
        }
    }
}
