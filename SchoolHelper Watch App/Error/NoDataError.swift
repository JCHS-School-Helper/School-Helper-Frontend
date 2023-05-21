import Foundation

class NoDataError: Error, LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString("데이터가 없습니다.", comment: "")
    }
}
