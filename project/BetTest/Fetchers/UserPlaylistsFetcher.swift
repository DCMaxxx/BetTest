//
//  UserPlaylistsFetcher.swift
//  BetTest
//
//  Created by Maxime de Chalendar on 30/09/2017.
//  Copyright © 2017 Maxime de Chalendar. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON

// MARK: - Protocols
/// A protocol representing a raw playlist, given by a UserPlaylistsFetcherType
protocol UserPlaylistFetchedType {

    var title: String { get }
    var picture: URL? { get }
    var author: String { get }
    var duration: TimeInterval { get }
    var trackListFetcher: PlaylistTrackListFetcherType? { get }

}

/// A protocol representing an object that can fetch playlists
protocol UserPlaylistsFetcherType {

    var hasMore: Variable<Bool> { get }

    func fetch() -> Observable<[UserPlaylistFetchedType]>

}

// MARK: - Implementation
/// A concrete implementation of UserPlaylistsFetcherType, that fetches playlists from Deezer's HTTP API
final class UserPlaylistsFetcher: UserPlaylistsFetcherType {

    enum FetchError: Error {
        case invalidJSON
    }

    private static func baseFetcherURL(userID: String) -> URL? {
        return URL(string: "https://api.deezer.com/user/\(userID)/playlists")
    }

    private let userID: String
    private var nextPlaylistsURL: URL?

    let hasMore = Variable(true)

    init(userID: String) {
        self.userID = userID
        self.nextPlaylistsURL = UserPlaylistsFetcher.baseFetcherURL(userID: userID)
    }

    func fetch() -> Observable<[UserPlaylistFetchedType]> {
        let subject = PublishSubject<[UserPlaylistFetchedType]>()
        let observer = subject.asObserver()

        guard let url = nextPlaylistsURL else {
            subject.onCompleted()
            return subject
        }

        Alamofire.request(url).responseJSON { response in
            if let error = response.error {
                observer.onError(error)
                return
            }

            guard
                let json = response.value.flatMap(JSON.init),
                let array = json["data"].array
                else {
                    observer.onError(FetchError.invalidJSON)
                    return
            }

            if let url = json["next"].url {
                self.nextPlaylistsURL = url
            } else {
                self.hasMore.value = false
            }

            let playlists = array.flatMap(Playlist.init)
            observer.onNext(playlists)
            observer.onCompleted()
        }

        return subject
    }

}

extension UserPlaylistsFetcher {

    /// A concrete implementation or UserPlaylistFetchedType, that parses a Deezer playlist, represented as a JSON
    final class Playlist: UserPlaylistFetchedType {

        private let tracks: URL?

        let title: String
        let picture: URL?
        let author: String
        let duration: TimeInterval

        var trackListFetcher: PlaylistTrackListFetcherType? {
            return tracks.flatMap(PlaylistTrackListFetcher.init)
        }

        fileprivate init?(json: JSON) {
            guard
                let title = json["title"].string,
                let author = json["creator"]["name"].string
                else {
                    return nil
            }

            self.title = title
            self.picture = json["picture_medium"].url
            self.author = author
            self.duration = TimeInterval(json["duration"].doubleValue)
            self.tracks = json["tracklist"].url
        }

    }

}
