//
//  ViewController.swift
//  BetTest
//
//  Created by Maxime de Chalendar on 29/09/2017.
//  Copyright © 2017 Maxime de Chalendar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

/// A view controller responsible for displaying a UserPlaylistListViewModelType, and load more playlists on scroll
final class PlaylistListViewController: UIViewController {

    static func instantiate(viewModel: UserPlaylistListViewModelType) -> PlaylistListViewController {
        let controller = StoryboardScene.Main.playlistListViewController.instantiate()
        controller.viewModel = viewModel
        return controller
    }

    fileprivate var viewModel: UserPlaylistListViewModelType!
    fileprivate let disposeBag = DisposeBag()

    @IBOutlet fileprivate weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTitle()
        bindCollectionViewItems()
        bindLoadMore()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        performInitialLoadIfNeeded()
    }

}

// MARK: - Static interface
extension PlaylistListViewController {

    fileprivate func configureTitle() {
        title = L10n.Playlistlistviewcontroller.title
    }

}

// MARK: - Data source
extension PlaylistListViewController {

    fileprivate func bindCollectionViewItems() {
        viewModel.playlists.asObservable()
            .bind(to: collectionView.rx.items) { collectionView, item, viewModel in
                let indexPath = IndexPath(item: item, section: 0)
                let cell = collectionView.dequeueReusableCell(for: indexPath) as PlaylistCollectionViewCell
                cell.viewModel = viewModel
                return cell
            }
            .disposed(by: disposeBag)
    }

}

// MARK: - Load data
extension PlaylistListViewController {

    fileprivate func performInitialLoadIfNeeded() {
        guard viewModel.playlists.value.isEmpty else {
            return
        }

        self.setNetworkIndicatorVisibility(visible: true)
        viewModel.loadMore()
            .subscribe { [unowned self] _ in
                self.setNetworkIndicatorVisibility(visible: false)
            }
            .disposed(by: disposeBag)
    }

    fileprivate func bindLoadMore() {
        var isLoadingMore = false

        let loadMoreDisposable = collectionView.rx.willDisplayCell.asObservable()
            .subscribe(onNext: { [unowned self] _, indexPath in
                guard !isLoadingMore else {
                    return
                }

                let lastItem = self.collectionView.numberOfItems(inSection: indexPath.section) - 1
                let isLastItem = indexPath.item == lastItem
                if isLastItem {
                    isLoadingMore = true
                    self.setNetworkIndicatorVisibility(visible: true)
                    self.viewModel.loadMore().subscribe(onCompleted: {
                        isLoadingMore = false
                        self.setNetworkIndicatorVisibility(visible: false)
                    }).disposed(by: self.disposeBag)
                }
            })
        loadMoreDisposable.disposed(by: disposeBag)

        viewModel.hasMore.asObservable()
            .filter { !$0 }
            .take(1)
            .subscribe(onNext: { _ in
                loadMoreDisposable.dispose()
            })
            .disposed(by: disposeBag)
    }

    fileprivate func setNetworkIndicatorVisibility(visible: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = visible
    }

}
