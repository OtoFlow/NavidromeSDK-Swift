import Foundation

public enum APIError: Error {

    case invalidClient

    case unauthorized(String)

    case undocumented(statusCode: Int)
}
