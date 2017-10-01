//
//  PlaylistTrackListViewModel.swift
//  BetTest
//
//  Created by Maxime de Chalendar on 30/09/2017.
//  Copyright © 2017 Maxime de Chalendar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Protocols
/// A protocol representing a view model for a track
protocol PlaylistTrackViewModelType {

    var title: Variable<String> { get }
    var subtitle: Variable<String> { get }

}

/// A protocol representing a view model for a list of tracks, that can grow over time
protocol PlaylistTrackListViewModelType {

    var tracks: Variable<[PlaylistTrackViewModelType]> { get }
    var hasMore: Variable<Bool> { get }

    func loadMore() -> Observable<Void>

}

// MARK: - Implementation
/// A concrete implementation of PlaylistTrackListViewModelType,
/// that stores a list of PlaylistTrackViewModelType which can be observed
final class PlaylistTrackListViewModel: PlaylistTrackListViewModelType {

    private let disposeBag = DisposeBag()
    private let playlistTrackList: PlaylistTrackListType

    let tracks = Variable<[PlaylistTrackViewModelType]>([])
    let hasMore = Variable(true)

    init(playlistTrackList: PlaylistTrackListType) {
        self.playlistTrackList = playlistTrackList

        playlistTrackList.tracks.asObservable().map { list in
            return list.map(Track.init)
        }.bind(to: self.tracks).disposed(by: self.disposeBag)

        playlistTrackList.hasMore.asObservable().bind(to: self.hasMore).disposed(by: self.disposeBag)
    }

    func loadMore() -> Observable<Void> {
        return playlistTrackList.loadMore()
    }

}

extension PlaylistTrackListViewModel {

    /// A concrete implementation of PlaylistTrackViewModelType,
    /// that formats a track's data to display in on screen
    final class Track: PlaylistTrackViewModelType {

        private let disposeBag = DisposeBag()

        let title = Variable<String>("")
        let subtitle = Variable<String>("")

        init(playlist: PlaylistTrackType) {
            playlist.title.asObservable()
                .bind(to: self.title)
                .disposed(by: self.disposeBag)

            let artist = playlist.artist.asObservable()
            let duration = playlist.duration.asObservable()
            Observable.combineLatest(artist, duration)
                .map { artist, duration in
                    let durationString = DurationFormatter.shared.string(from: duration)
                    return L10n.Track.subtitle(artist, durationString)
                }
                .bind(to: self.subtitle)
                .disposed(by: self.disposeBag)
        }

    }

}
