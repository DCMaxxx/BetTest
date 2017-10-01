//
//  UserPlaylistList.swift
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
protocol UserPlaylistType {

    var title: Variable<String> { get }
    var picture: Variable<URL?> { get }
    var author: Variable<String> { get }
    var duration: Variable<TimeInterval> { get }

}

/// A protocol representing an observable list of playlist, that can grow over time
protocol UserPlaylistListType {

    var playlists: Variable<[UserPlaylistType]> { get }
    var hasMore: Variable<Bool> { get }

    func loadMore() -> Observable<Void>

}

// MARK: - Implementation
/// A concrete implementation of UserPlaylistListType,
/// that stores a list of UserPlaylistType which can be observed
final class UserPlaylistList: UserPlaylistListType {

    private let disposeBag = DisposeBag()
    private let fetcher: UserPlaylistsFetcherType

    let playlists = Variable<[UserPlaylistType]>([])
    let hasMore = Variable(true)

    init(fetcher: UserPlaylistsFetcherType) {
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
            let playlists: [UserPlaylistType] = fetchedPlaylists.map(Playlist.init)
            newPlaylists.append(contentsOf: playlists)
            self.playlists.value = newPlaylists

            observer.onCompleted()

        }, onError: { error in
            observer.onError(error)

        }, onCompleted: {
            observer.onCompleted()

        }).disposed(by: disposeBag)

        return subject
    }

}

extension UserPlaylistList {

    /// A concrete implementation of UserPlaylistType, that turns
    /// a fetched playlist into a observable model
    final class Playlist: UserPlaylistType {

        let title: Variable<String>
        let picture: Variable<URL?>
        let author: Variable<String>
        let duration: Variable<TimeInterval>

        init(fetchedPlaylist: UserPlaylistFetchedType) {
            self.title = Variable(fetchedPlaylist.title)
            self.picture = Variable(fetchedPlaylist.picture)
            self.author = Variable(fetchedPlaylist.author)
            self.duration = Variable(fetchedPlaylist.duration)
        }

    }

}
