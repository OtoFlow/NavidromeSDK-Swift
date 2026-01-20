import Foundation

public typealias Artist = Components.Schemas.Artist
public typealias Album = Components.Schemas.Album
public typealias Song = Components.Schemas.MediaFile
public typealias Playlist = Components.Schemas.Playlist
public typealias PlaylistTrack = Components.Schemas.PlaylistTrack

extension NavidromeClient {

    public func getArtists(
        start: Int? = 0,
        end: Int? = 20,
        sort: Sort? = nil,
        order: Order? = nil,
        starred: Bool? = nil,
        missing: Bool? = false
    ) async throws -> [Artist]
    {
        let response = try await underlyingClient.get_sol_api_sol_artist(
            query: .init(
                _start: start.map(Int32.init),
                _end: end.map(Int32.init),
                _sort: sort?.query,
                _order: order,
                starred: starred,
                missing: missing
            )
        )

        switch response {
        case let .ok(response):
            return (try? response.body.json) ?? []
        case let .unauthorized(unauthorized):
            throw APIError.unauthorized((try? unauthorized.body.json.error) ?? "")
        case let .undocumented(statusCode, undocumented):
            throw APIError.undocumented(statusCode: statusCode)
        }
    }

    public func getAlbums(
        start: Int? = 0,
        end: Int? = 20,
        sort: Sort? = nil,
        order: Order? = nil,
        artistId: String? = nil,
        compilation: Bool? = nil,
        starred: Bool? = nil,
        missing: Bool? = false
    ) async throws -> [Album]
    {
        let response = try await underlyingClient.get_sol_api_sol_album(
            query: .init(
                _start: start.map(Int32.init),
                _end: end.map(Int32.init),
                _sort: sort?.query,
                _order: order,
                artist_id: artistId,
                compilation: compilation,
                starred: starred,
                missing: missing
            )
        )
        switch response {
        case let .ok(response):
            return (try? response.body.json) ?? []
        case let .unauthorized(unauthorized):
            throw APIError.unauthorized((try? unauthorized.body.json.error) ?? "")
        case let .undocumented(statusCode, undocumented):
            throw APIError.undocumented(statusCode: statusCode)
        }
    }

    public func getSongs(
        start: Int = 0,
        end: Int = 20,
        sort: Sort? = nil,
        order: Order? = nil,
        albumId: String? = nil,
        artistId: String? = nil,
        starred: Bool? = nil,
        title: String? = nil
    ) async throws -> [Song]
    {
        let response = try await underlyingClient.get_sol_api_sol_song(
            query: .init(
                _start: Int32(start),
                _end: Int32(end),
                _sort: sort?.query,
                _order: order,
                album_id: albumId,
                artist_id: artistId,
                starred: starred,
                title: title
            )
        )
        switch response {
        case let .ok(response):
            return (try? response.body.json) ?? []
        case let .unauthorized(unauthorized):
            throw APIError.unauthorized((try? unauthorized.body.json.error) ?? "")
        case let .undocumented(statusCode, undocumented):
            throw APIError.undocumented(statusCode: statusCode)
        }
    }

    public func getPlaylists(
        start: Int = 0,
        end: Int = 0,
        sort: Playlist.Sort? = nil,
        order: Order? = nil,
        query: String? = nil
    ) async throws -> [Playlist]
    {
        let response = try await underlyingClient.get_sol_api_sol_playlist(
            query: .init(
                _start: Int32(start),
                _end: Int32(end),
                _sort: sort?.rawValue,
                _order: order,
                q: query
            )
        )
        switch response {
        case let .ok(response):
            return (try? response.body.json) ?? []
        case let .unauthorized(unauthorized):
            throw APIError.unauthorized((try? unauthorized.body.json.error) ?? "")
        case let .undocumented(statusCode, undocumented):
            throw APIError.undocumented(statusCode: statusCode)
        }
    }

    public func getTracks(
        playlistId: String,
        start: Int = 0,
        end: Int = 20,
        sort: PlaylistTrack.Sort? = nil,
        order: Order? = nil
    ) async throws -> [PlaylistTrack]
    {
        let response = try await underlyingClient.get_sol_api_sol_playlist_sol__lcub_playlistId_rcub__sol_tracks(
            path: .init(playlistId: playlistId),
            query: .init(
                _start: Int32(start),
                _end: Int32(end),
                _sort: sort?.rawValue,
                _order: order
            )
        )
        switch response {
        case let .ok(response):
            return (try? response.body.json) ?? []
        case let .unauthorized(unauthorized):
            throw APIError.unauthorized((try? unauthorized.body.json.error) ?? "")
        case let .undocumented(statusCode, undocumented):
            throw APIError.undocumented(statusCode: statusCode)
        }
    }
}
