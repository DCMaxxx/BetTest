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

protocol UserPlaylistType {

    var title: Variable<String> { get }
    var picture: Variable<URL?> { get }
    var author: Variable<String> { get }
    var duration: Variable<TimeInterval> { get }

}

protocol UserPlaylistListType {

    var playlists: Variable<[UserPlaylistType]> { get }
    var hasMore: Variable<Bool> { get }

    func loadMore() -> Observable<Void>

}

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
