import Foundation

public struct APIError: LocalizedError {
    public let message: String

    init(_ message: String) {
        self.message = message
    }

    public var errorDescription: String? { message }
}
