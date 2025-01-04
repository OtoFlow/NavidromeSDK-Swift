import Foundation
import OpenAPIRuntime
import OpenAPIURLSession
import SubsonicAPI

public struct SubsonicSession: Equatable {
    public let username: String
    public let salt: String
    public let token: String

    public init(username: String, salt: String, token: String) {
        self.username = username
        self.salt = salt
        self.token = token
    }
}

public final class NavidromeClient {
    public struct Configuration {
        public let serverURL: URL
        public let client: String
        public let version: String
        public let deviceName: String
        public let deviceID: String

        public init(
            serverURL: URL,
            client: String,
            version: String,
            deviceName: String,
            deviceID: String
        ) {
            self.serverURL = serverURL
            self.client = client
            self.version = version
            self.deviceName = deviceName
            self.deviceID = deviceID
        }
    }

    public let configuration: Configuration

    public private(set) var userID: String?
    public private(set) var accessToken: String?

    let underlyingClient: any APIProtocol

    private var subsonicClient: SubsonicClient?

    public var subsonic: SubsonicClient {
        get throws {
            guard let subsonicClient else {
                throw APIError("Subsonic client not initialized")
            }
            return subsonicClient
        }
    }

    private(set) var authenticationMiddleware: AuthenticationMiddleware?

    init(configuration: Configuration, underlyingClient: any APIProtocol) {
        self.configuration = configuration
        self.underlyingClient = underlyingClient
    }

    public convenience init(
        configuration: Configuration,
        userID: String? = nil,
        accessToken: String? = nil,
        subsonicSession: SubsonicSession? = nil
    ) {
        let authenticationMiddleware = AuthenticationMiddleware(
            client: configuration.client,
            device: configuration.deviceName,
            deviceID: configuration.deviceID,
            version: configuration.version,
            userID: nil,
            accessToken: nil
        )

        self.init(
            configuration: configuration,
            underlyingClient: Client(
                serverURL: configuration.serverURL,
                configuration: .init(
                    dateTranscoder: ISO8601DateTranscoder(
                        options: [.withTimeZone]
                    )
                ),
                transport: URLSessionTransport(),
                middlewares: [
                    authenticationMiddleware
                ]
            )
        )

        self.userID = userID
        self.accessToken = accessToken
        self.authenticationMiddleware = authenticationMiddleware

        if let subsonicSession {
            subsonicClient = SubsonicClient(
                configuration: .init(
                    serverURL: configuration.serverURL,
                    client: configuration.client,
                    version: configuration.version,
                    deviceName: configuration.deviceName,
                    deviceID: configuration.deviceID
                ),
                username: subsonicSession.username,
                salt: subsonicSession.salt,
                token: subsonicSession.token
            )
        }
    }
}

extension NavidromeClient {
    public func login(
        username: String,
        password: String
    ) async throws -> Components.Schemas.AuthenticationResult {
        let result = try await underlyingClient.post_sol_auth_sol_login(
            body: .json(.init(username: username, password: password))
        ).ok.body.json

        self.userID = result.id
        self.accessToken = result.token
        authenticationMiddleware?.userID = result.id
        authenticationMiddleware?.accessToken = result.token

        subsonicClient = SubsonicClient(
            configuration: .init(
                serverURL: configuration.serverURL,
                client: configuration.client,
                version: configuration.version,
                deviceName: configuration.deviceName,
                deviceID: configuration.deviceID
            ),
            username: result.username,
            salt: result.subsonicSalt,
            token: result.subsonicToken
        )

        return result
    }
}
