//
//  PlaylistViewController.swift
//  BetTest
//
//  Created by Maxime de Chalendar on 30/09/2017.
//  Copyright © 2017 Maxime de Chalendar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// A view controller responsible for displaying a single UserPlaylistViewModelType and its PlaylistTrackListViewModelType
final class PlaylistViewController: UIViewController {

    static func instantiate(viewModel: UserPlaylistViewModelType) -> PlaylistViewController {
        let controller = StoryboardScene.Main.playlistViewController.instantiate()
        controller.viewModel = viewModel
        controller.trackListViewModel = viewModel.trackListViewModel
        return controller
    }

    fileprivate var viewModel: UserPlaylistViewModelType!
    fileprivate var trackListViewModel: PlaylistTrackListViewModelType?
    fileprivate let disposeBag = DisposeBag()

    @IBOutlet fileprivate weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        bindTitle()
        bindTableViewItems()
        bindLoadMore()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        performInitialLoadIfNeeded()
    }

}

extension PlaylistViewController {

    fileprivate func bindTitle() {
        viewModel.title.asObservable()
            .bind(to: rx.title)
            .disposed(by: disposeBag)
    }

}

// MARK: - Data source
extension PlaylistViewController {

    fileprivate func bindTableViewItems() {
        guard let trackListViewModel = trackListViewModel else {
            return
        }
        trackListViewModel.tracks.asObservable()
            .bind(to: tableView.rx.items) { tableView, row, viewModel in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tableView.dequeueReusableCell(for: indexPath) as TrackTableViewCell
                cell.viewModel = viewModel
                return cell
            }
            .disposed(by: disposeBag)
    }

}

// MARK: - Load data
extension PlaylistViewController {

    fileprivate func performInitialLoadIfNeeded() {
        guard let trackListViewModel = trackListViewModel, trackListViewModel.tracks.value.isEmpty else {
            return
        }

        self.setNetworkIndicatorVisibility(visible: true)
        trackListViewModel.loadMore()
            .subscribe { [unowned self] _ in
                self.setNetworkIndicatorVisibility(visible: false)
            }
            .disposed(by: disposeBag)
    }

    fileprivate func bindLoadMore() {
        guard let trackListViewModel = trackListViewModel else {
            return
        }

        var isLoadingMore = false

        let disposable = tableView.rx.willDisplayCell.asObservable().subscribe(onNext: { [unowned self] _, indexPath in
            guard !isLoadingMore else {
                return
            }

            let lastItem = self.tableView.numberOfRows(inSection: indexPath.section) - 1
            let isLastItem = indexPath.item == lastItem
            if isLastItem {
                isLoadingMore = true
                self.setNetworkIndicatorVisibility(visible: true)
                trackListViewModel.loadMore()
                    .subscribe(onCompleted: { [unowned self] in
                        isLoadingMore = false
                        self.setNetworkIndicatorVisibility(visible: false)
                    })
                    .disposed(by: self.disposeBag)
            }
        })
        disposable.disposed(by: disposeBag)

        trackListViewModel.hasMore.asObservable()
            .filter { !$0 }
            .take(1)
            .subscribe(onNext: { _ in
                disposable.dispose()
            })
            .disposed(by: disposeBag)
    }

    private func setNetworkIndicatorVisibility(visible: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = visible
    }

}
