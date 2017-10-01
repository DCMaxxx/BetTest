//
//  PlaylistTracks.swift
//  BetTest
//
//  Created by Maxime de Chalendar on 30/09/2017.
//  Copyright © 2017 Maxime de Chalendar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Protocols
/// A protocol representing an observable track
protocol PlaylistTrackType {

    var title: Variable<String> { get }
    var artist: Variable<String> { get }
    var duration: Variable<TimeInterval> { get }

}

/// A protocol representing an observable list of tracks, that can grow over time
protocol PlaylistTrackListType {

    var tracks: Variable<[PlaylistTrackType]> { get }
    var hasMore: Variable<Bool> { get }

    func loadMore() -> Observable<Void>

}

// MARK: - Implementation
/// A concrete implementation of PlaylistTrackListType,
/// that stores a list of PlaylistTrackType which can be observed
final class PlaylistTrackList: PlaylistTrackListType {

    private let disposeBag = DisposeBag()
    private let fetcher: PlaylistTracksFetcherType

    let tracks = Variable<[PlaylistTrackType]>([])
    let hasMore = Variable(true)

    init(fetcher: PlaylistTracksFetcherType) {
        self.fetcher = fetcher
        fetcher.hasMore.asObservable().bind(to: self.hasMore).disposed(by: disposeBag)
    }

    func loadMore() -> Observable<Void> {
        let subject = PublishSubject<Void>()
        let observer = subject.asObserver()

        self.fetcher.fetch().subscribe(onNext: { [unowned self] fetchedTracks in
            var newTracks = self.tracks.value
            let tracks: [PlaylistTrackType] = fetchedTracks.map(Track.init)
            newTracks.append(contentsOf: tracks)
            self.tracks.value = newTracks

            observer.onCompleted()

        }, onError: { error in
                observer.onError(error)

        }, onCompleted: {
                observer.onCompleted()
        })
            .disposed(by: disposeBag)

        return subject
    }

}

extension PlaylistTrackList {

    /// A concrete implementation of PlaylistTrackType, that turns
    /// a fetched track into a observable model
    final class Track: PlaylistTrackType {

        let title: Variable<String>
        let artist: Variable<String>
        let duration: Variable<TimeInterval>

        init(fetchedTrack: PlaylistTrackFetchedType) {
            self.title = Variable(fetchedTrack.title)
            self.artist = Variable(fetchedTrack.artist)
            self.duration = Variable(fetchedTrack.duration)
        }

    }

}
