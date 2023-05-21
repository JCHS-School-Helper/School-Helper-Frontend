import Foundation

struct Meal: Decodable, Identifiable, Hashable {
    var id: UUID {
        return UUID()
    }
    let type: MealType
    let menu: [String]
}

enum MealType: String, CaseIterable, Decodable {
    case breakfast = "조식"
    case lunch = "중식"
    case dinner = "석식"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let typeString = try container.decode(String.self).lowercased()
        
        switch typeString {
        case "breakfast":
            self = .breakfast
        case "lunch":
            self = .lunch
        case "dinner":
            self = .dinner
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid meal type: \(typeString)"
            )
        }
    }
}

class MealModel: ObservableObject {
    @Published var meals: [Meal]?
    @Published var error: Error?
    
    func fetchMeals() {
        guard let url = URL(string: Settings.host + "/meal") else { return }
        
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
                        self.meals = try JSONDecoder().decode([Meal].self, from: data)
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
