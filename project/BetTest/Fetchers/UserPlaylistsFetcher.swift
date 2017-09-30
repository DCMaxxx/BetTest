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

protocol UserPlaylistFetchedType {

    var title: String { get }
    var picture: URL? { get }
    var author: String { get }
    var duration: TimeInterval { get }
    var tracks: URL? { get }

}

protocol UserPlaylistsFetcherType {

    func fetch() -> Observable<[UserPlaylistFetchedType]>

}

final class UserPlaylistsFetcher: UserPlaylistsFetcherType {

    private static func baseFetcherURL(userID: String) -> URL? {
        return URL(string: "https://api.deezer.com/user/\(userID)/playlists")
    }

    private let userID: String
    private var nextPlaylistsURL: URL?

    init(userID: String) {
        self.userID = userID
        self.nextPlaylistsURL = UserPlaylistsFetcher.baseFetcherURL(userID: userID)
    }

    func fetch() -> Observable<[UserPlaylistFetchedType]> {
        return Observable.create { observer -> Disposable in

            guard let url = self.nextPlaylistsURL else {
                observer.onCompleted()
                return Disposables.create()
            }

            Alamofire.request(url).responseJSON { response in
                if let error = response.error {
                    observer.onError(error)
                    return
                }

                guard
                    let value = response.value,
                    let array = JSON(value)["data"].array
                    else {
                        return
                }

                let playlists = array.flatMap(Playlist.init)
                observer.onNext(playlists)
                observer.onCompleted()
            }

            return Disposables.create()
        }
    }

}

extension UserPlaylistsFetcher {

    final class Playlist: UserPlaylistFetchedType {

        let title: String
        let picture: URL?
        let author: String
        let duration: TimeInterval
        let tracks: URL?

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
