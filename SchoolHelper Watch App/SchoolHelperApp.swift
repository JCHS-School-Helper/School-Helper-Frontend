import SwiftUI

@main
struct TestApp: App {
    let settings: Settings = Settings()
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

struct Settings {
    static let host = "https://schoolhelper.p-e.kr"
}
