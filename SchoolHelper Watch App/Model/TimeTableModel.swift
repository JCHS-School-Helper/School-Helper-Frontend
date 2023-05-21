import Foundation

struct TimeTable: Decodable, Identifiable, Hashable {
    var id: UUID {
        return UUID()
    }
    var period: Int
    var lecture: String
    var teacher: String
    var location: String
}

class TimeTableModel: ObservableObject {
    @Published var timeTable: [TimeTable]?
    @Published var error: Error?
    
    func fetchTimeTable(grade: Int, clazz: Int, id: Int) {
        let urlStr = Settings.host + "/timetable?grade=\(grade)&class=\(clazz)&id=\(id)"
        guard let url = URL(string: urlStr) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.error = error
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.error = NSError(domain: "Invalid response", code: 0)
                }
                return
            }
            
            if httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    do {
                        self.timeTable = try JSONDecoder().decode([TimeTable].self, from: data)
                    } catch {
                        self.error = error
                    }
                }
            } else if httpResponse.statusCode == 204 {
                DispatchQueue.main.async {
                    self.error = NoDataError()
                }
            } else {
                DispatchQueue.main.async {
                    self.error = NSError(domain: "Invalid response", code: httpResponse.statusCode)
                }
            }
        }
        
        task.resume()
    }

}
