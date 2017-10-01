//
//  PlaylistListViewModel.swift
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
protocol PlaylistViewModelType {

    var title: Variable<String> { get }
    var picture: Variable<URL?> { get }
    var author: Variable<String> { get }
    var formattedDuration: Variable<String> { get }

    var trackListViewModel: PlaylistTrackListViewModelType? { get }

}

/// A protocol representing a view model for a list of playlists, that can grow over time
protocol PlaylistListViewModelType {

    var playlists: Variable<[PlaylistViewModelType]> { get }
    var hasMore: Variable<Bool> { get }

    func loadMore() -> Observable<Void>

}

// MARK: - Implementation
/// A concrete implementation of PlaylistListViewModelType,
/// that stores a list of PlaylistViewModelType which can be observed
final class PlaylistListViewModel: PlaylistListViewModelType {

    private let disposeBag = DisposeBag()
    private let playlistList: PlaylistListType

    let playlists = Variable<[PlaylistViewModelType]>([])
    let hasMore = Variable(true)

    init(playlistList: PlaylistListType) {
        self.playlistList = playlistList

        playlistList.playlists.asObservable()
            .map { $0.map(PlaylistViewModel.init) }
            .bind(to: self.playlists)
            .disposed(by: self.disposeBag)

        playlistList.hasMore.asObservable()
            .bind(to: self.hasMore)
            .disposed(by: self.disposeBag)
    }

    func loadMore() -> Observable<Void> {
        return playlistList.loadMore()
    }

}

extension PlaylistListViewModel {

    /// A concrete implementation of PlaylistViewModelType,
    /// that formats a playlist's data to display in on screen
    final class PlaylistViewModel: PlaylistViewModelType {

        private let playlist: PlaylistType
        private let disposeBag = DisposeBag()

        let title = Variable<String>("")
        let picture = Variable<URL?>(nil)
        let author = Variable<String>("")
        let formattedDuration = Variable<String>("")

        var trackListViewModel: PlaylistTrackListViewModelType? {
            return playlist.trackList.flatMap(PlaylistTrackListViewModel.init)
        }

        init(playlist: PlaylistType) {
            self.playlist = playlist

            playlist.title.asObservable()
                .bind(to: self.title)
                .disposed(by: self.disposeBag)

            playlist.picture.asObservable()
                .bind(to: self.picture)
                .disposed(by: self.disposeBag)

            playlist.author.asObservable()
                .map { L10n.Playlist.author($0) }
                .bind(to: self.author)
                .disposed(by: self.disposeBag)

            playlist.duration.asObservable()
                .map { return DurationFormatter.shared.string(from: $0) }
                .bind(to: self.formattedDuration)
                .disposed(by: self.disposeBag)
        }

    }

}
