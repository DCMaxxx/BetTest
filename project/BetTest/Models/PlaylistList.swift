//
//  PlaylistList.swift
//  BetTest
//
//  Created by Maxime de Chalendar on 30/09/2017.
//  Copyright © 2017 Maxime de Chalendar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Protocols
/// A protocol representing an observable playlist
protocol PlaylistType {

    var title: Variable<String> { get }
    var picture: Variable<URL?> { get }
    var author: Variable<String> { get }
    var duration: Variable<TimeInterval> { get }
    var trackList: PlaylistTrackListType? { get }

}

/// A protocol representing an observable list of playlist, that can grow over time
protocol PlaylistListType {

    var playlists: Variable<[PlaylistType]> { get }
    var hasMore: Variable<Bool> { get }

    func loadMore() -> Observable<Void>

}

// MARK: - Implementation
/// A concrete implementation of PlaylistListType,
/// that stores a list of PlaylistType which can be observed
final class PlaylistList: PlaylistListType {

    private let disposeBag = DisposeBag()
    private let fetcher: PlaylistsFetcherType

    let playlists = Variable<[PlaylistType]>([])
    let hasMore = Variable(true)

    init(fetcher: PlaylistsFetcherType) {
        self.fetcher = fetcher
        fetcher.hasMore.asObservable()
            .bind(to: self.hasMore)
            .disposed(by: self.disposeBag)
    }

    func loadMore() -> Observable<Void> {
        let subject = PublishSubject<Void>()
        let observer = subject.asObserver()

        self.fetcher.fetch().subscribe(onNext: { [unowned self] fetchedPlaylists in
            var newPlaylists = self.playlists.value
            let playlists: [PlaylistType] = fetchedPlaylists.map(Playlist.init)
            newPlaylists.append(contentsOf: playlists)
            self.playlists.value = newPlaylists

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

extension PlaylistList {

    /// A concrete implementation of PlaylistType, that turns
    /// a fetched playlist into a observable model
    final class Playlist: PlaylistType {

        private let fetchedPlaylist: PlaylistFetchedType
        let title: Variable<String>
        let picture: Variable<URL?>
        let author: Variable<String>
        let duration: Variable<TimeInterval>

        var trackList: PlaylistTrackListType? {
            return fetchedPlaylist.trackListFetcher.flatMap(PlaylistTrackList.init)
        }

        init(fetchedPlaylist: PlaylistFetchedType) {
            self.fetchedPlaylist = fetchedPlaylist
            self.title = Variable(fetchedPlaylist.title)
            self.picture = Variable(fetchedPlaylist.picture)
            self.author = Variable(fetchedPlaylist.author)
            self.duration = Variable(fetchedPlaylist.duration)
        }

    }

}
