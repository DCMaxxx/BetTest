//
//  PlaylistTracksFetcher.swift
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
/// A protocol representing a raw track, given by a PlaylistTracksFetcherType
protocol PlaylistTrackFetchedType {

    var title: String { get }
    var artist: String { get }
    var duration: TimeInterval { get }

}

/// A protocol representing an object that can fetch tracks
protocol PlaylistTracksFetcherType {

    var hasMore: Variable<Bool> { get }

    func fetch() -> Observable<[PlaylistTrackFetchedType]>

}

// MARK: - Implementation
/// A concrete implementation of PlaylistTracksFetcherType, that fetches tracks from Deezer's HTTP API
final class PlaylistTracksFetcher: PlaylistTracksFetcherType {

    enum FetchError: Error {
        case invalidJSON
    }

    private var nextTracksURL: URL?

    let hasMore = Variable(true)

    init(tracksURL: URL) {
        self.nextTracksURL = tracksURL
    }

    func fetch() -> Observable<[PlaylistTrackFetchedType]> {
        let subject = PublishSubject<[PlaylistTrackFetchedType]>()
        let observer = subject.asObserver()

        guard let url = nextTracksURL else {
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
                let array = json["data"].array else {
                    observer.onError(FetchError.invalidJSON)
                    return
            }

            if let url = json["next"].url {
                self.nextTracksURL = url
            } else {
                self.hasMore.value = false
            }

            let tracks = array.flatMap(Track.init)
            observer.onNext(tracks)
            observer.onCompleted()
        }

        return subject
    }

}

extension PlaylistTracksFetcher {

    final class Track: PlaylistTrackFetchedType {

        let title: String
        let artist: String
        let duration: TimeInterval

        init?(json: JSON) {
            guard
                let title = json["title"].string,
                let artist = json["artist"]["name"].string
                else {
                    return nil
            }

            self.title = title
            self.artist = artist
            self.duration = TimeInterval(json["duration"].doubleValue)
        }

    }

}
