//
//  UserPlaylistsViewModel.swift
//  BetTest
//
//  Created by Maxime de Chalendar on 30/09/2017.
//  Copyright © 2017 Maxime de Chalendar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Protocols
/// A protocol representing a view model for a playlist
protocol UserPlaylistViewModelType {

    var title: Variable<String> { get }
    var picture: Variable<URL?> { get }
    var author: Variable<String> { get }
    var formattedDuration: Variable<String> { get }

    var trackListViewModel: PlaylistTrackListViewModelType? { get }

}

/// A protocol representing a view model for a list of playlists, that can grow over time
protocol UserPlaylistListViewModelType {

    var playlists: Variable<[UserPlaylistViewModelType]> { get }
    var hasMore: Variable<Bool> { get }

    func loadMore() -> Observable<Void>

}

// MARK: - Implementation
/// A concrete implementation of UserPlaylistListViewModelType,
/// that stores a list of UserPlaylistViewModelType which can be observed
final class UserPlaylistListViewModel: UserPlaylistListViewModelType {

    private let disposeBag = DisposeBag()
    private let userPlaylistList: UserPlaylistListType

    let playlists = Variable<[UserPlaylistViewModelType]>([])
    let hasMore = Variable(true)

    init(userPlaylistList: UserPlaylistListType) {
        self.userPlaylistList = userPlaylistList

        userPlaylistList.playlists.asObservable()
            .map { $0.map(PlaylistViewModel.init) }
            .bind(to: self.playlists)
            .disposed(by: self.disposeBag)

        userPlaylistList.hasMore.asObservable()
            .bind(to: self.hasMore)
            .disposed(by: self.disposeBag)
    }

    func loadMore() -> Observable<Void> {
        return userPlaylistList.loadMore()
    }

}

extension UserPlaylistListViewModel {

    /// A concrete implementation of UserPlaylistViewModelType,
    /// that formats a playlist's data to display in on screen
    final class PlaylistViewModel: UserPlaylistViewModelType {

        private let playlist: UserPlaylistType
        private let disposeBag = DisposeBag()

        let title = Variable<String>("")
        let picture = Variable<URL?>(nil)
        let author = Variable<String>("")
        let formattedDuration = Variable<String>("")

        var trackListViewModel: PlaylistTrackListViewModelType? {
            return playlist.trackList.flatMap(PlaylistTrackListViewModel.init)
        }

        init(playlist: UserPlaylistType) {
            self.playlist = playlist

            playlist.title.asObservable()
                .bind(to: self.title)
                .disposed(by: self.disposeBag)

            playlist.picture.asObservable()
                .bind(to: self.picture)
                .disposed(by: self.disposeBag)

            playlist.author.asObservable()
                .bind(to: self.author)
                .disposed(by: self.disposeBag)

            playlist.duration.asObservable()
                .map { return "\($0)" }
                .bind(to: self.formattedDuration)
                .disposed(by: self.disposeBag)
        }

    }

}
