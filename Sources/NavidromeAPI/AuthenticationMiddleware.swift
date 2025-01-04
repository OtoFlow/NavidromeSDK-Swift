import OpenAPIRuntime
import Foundation
import HTTPTypes

final class AuthenticationMiddleware {
    private let client: String
    private let device: String
    private let deviceID: String
    private let version: String

    package var userID: String?
    package var accessToken: String?

    init(
        client: String,
        device: String,
        deviceID: String,
        version: String,
        userID: String?,
        accessToken: String?
    ) {
        self.client = client
        self.device = device
        self.deviceID = deviceID
        self.version = version
        self.userID = userID
        self.accessToken = accessToken
    }
}

extension AuthenticationMiddleware: ClientMiddleware {
    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        request.headerFields[.authorization] = authHeaders()
        request.headerFields[.init("x-nd-authorization")!] = accessToken.map { "Bearer \($0)" }
        request.headerFields[.init("x-nd-client-unique-id")!] = userID
        return try await next(request, body, baseURL)
    }

    private func authHeaders() -> String {
        let fields = [
            "Client": client,
            "Version": version,
            "Device": device,
            "DeviceId": deviceID,
            "UserId": userID,
        ]
            .compactMap { key, value in
                value.map { "\(key)=\($0)" }
            }
            .joined(separator: ", ")
        return "\(fields)"
    }
}
