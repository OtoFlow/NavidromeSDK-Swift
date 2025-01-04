import Foundation

public typealias Album = Components.Schemas.Album
public typealias Order = Components.Parameters.Order

extension NavidromeClient {
    public func getAlbums(
        start: Int = 0,
        end: Int = 19,
        order: Order = .ASC,
        sort: String? = nil,
        artistId: String? = nil,
        starred: Bool? = nil
    ) async throws -> [Album] {
        try await underlyingClient.get_sol_api_sol_album(
            query: .init(
                _start: Int32(start),
                _end: Int32(end),
                _order: order,
                _sort: sort,
                artist_id: artistId,
                starred: starred
            )
        )
        .ok.body.json
    }
}
