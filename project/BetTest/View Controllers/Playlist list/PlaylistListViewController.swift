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

final class PlaylistListViewController: UIViewController {

    static func instantiate(viewModel: UserPlaylistListViewModelType) -> PlaylistListViewController {
        let controller = StoryboardScene.Main.playlistListViewController.instantiate()
        controller.viewModel = viewModel
        return controller
    }

    private var viewModel: UserPlaylistListViewModelType!
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        bindCollectionView()
        bindLoadMore()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        performInitialLoadIfNeeded()
    }

    private func bindCollectionView() {
        viewModel.playlists.asObservable().bind(to: collectionView.rx.items) { collectionView, item, viewModel in
            let indexPath = IndexPath(item: item, section: 0)
            let cell = collectionView.dequeueReusableCell(for: indexPath) as PlaylistCollectionViewCell
            cell.viewModel = viewModel
            return cell
        }.disposed(by: disposeBag)
    }

    private func bindLoadMore() {
        var shouldLoadMore = true

        let disposable = collectionView.rx.willDisplayCell.asObservable().subscribe(onNext: { [unowned self] _, indexPath in
            guard shouldLoadMore else {
                return
            }

            let lastItem = self.collectionView.numberOfItems(inSection: indexPath.section) - 1
            let isLastItem = indexPath.item == lastItem
            if isLastItem {
                shouldLoadMore = false
                self.setNetworkIndicatorVisibility(visible: true)
                self.viewModel.loadMore().subscribe(onCompleted: {
                    shouldLoadMore = true
                    self.setNetworkIndicatorVisibility(visible: false)
                }).disposed(by: self.disposeBag)
            }
        })
        disposable.disposed(by: disposeBag)

        viewModel.hasMore.asObservable()
            .filter { !$0 }
            .subscribe(onNext: { _ in
                disposable.dispose()
            })
            .disposed(by: disposeBag)
    }

    private func performInitialLoadIfNeeded() {
        guard viewModel.playlists.value.isEmpty else {
            return
        }

        self.setNetworkIndicatorVisibility(visible: true)
        viewModel.loadMore().subscribe { [unowned self] _ in
            self.setNetworkIndicatorVisibility(visible: false)
        }.disposed(by: disposeBag)
    }

    private func setNetworkIndicatorVisibility(visible: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = visible
    }

}
