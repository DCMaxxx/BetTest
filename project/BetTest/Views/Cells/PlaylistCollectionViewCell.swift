//
//  PlaylistCollectionViewCell.swift
//  BetTest
//
//  Created by Maxime de Chalendar on 30/09/2017.
//  Copyright © 2017 Maxime de Chalendar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

/// A cell responsible for displaying a PlaylistViewModelType
final class PlaylistCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    private var disposeBag: DisposeBag?

    var viewModel: PlaylistViewModelType? {
        didSet {
            disposeBag = nil
            configureInterface()
        }
    }

    override func prepareForReuse() {
        viewModel = nil
    }

    private func configureInterface() {
        guard let viewModel = viewModel else {
            coverImageView.image = nil
            titleLabel.text = nil
            return
        }

        let disposeBag = DisposeBag()
        self.disposeBag = disposeBag

        viewModel.title.asObservable()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.picture.asObservable()
            .flatMap { url -> Observable<UIImage?> in
                guard let url = url else {
                    return Observable.just(nil)
                }
                return url.image()
            }
            .bind(to: coverImageView.rx.image)
            .disposed(by: disposeBag)
    }

}

extension PlaylistCollectionViewCell: Reusable {

}
