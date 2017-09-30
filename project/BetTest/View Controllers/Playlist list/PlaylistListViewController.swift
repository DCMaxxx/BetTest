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

        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        performInitialLoadIfNeeded()
    }

    private func bind() {
        viewModel.playlists.asObservable().bind(to: collectionView.rx.items) { collectionView, item, viewModel in
            let indexPath = IndexPath(item: item, section: 0)
            let cell = collectionView.dequeueReusableCell(for: indexPath) as PlaylistCollectionViewCell
            cell.viewModel = viewModel
            return cell
            }.disposed(by: disposeBag)
    }

    private func performInitialLoadIfNeeded() {
        guard viewModel.playlists.value.isEmpty else {
            return
        }

        viewModel.loadMore().subscribe(onNext: {
            print("Loaded more")
        }, onError: { error in
            print("Loaded more error: \(error)")
        }, onCompleted: {
            print("Loaded more completed")
        }, onDisposed: {
            print("Loaded more disposed")
        }).disposed(by: disposeBag)

    }

}
