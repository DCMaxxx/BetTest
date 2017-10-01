//
//  PlaylistTableViewHeaderView.swift
//  BetTest
//
//  Created by Maxime de Chalendar on 01/10/2017.
//  Copyright © 2017 Maxime de Chalendar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class PlaylistTableViewHeaderView: UIView {

    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!

    private var disposeBag: DisposeBag?

    var viewModel: UserPlaylistViewModelType? {
        didSet {
            disposeBag = nil
            configureInterface()
        }
    }

    private func configureInterface() {
        guard let viewModel = viewModel else {
            coverImageView.image = #imageLiteral(resourceName: "cover-placeholder")
            authorLabel.text = nil
            durationLabel.text = nil
            return
        }

        let disposeBag = DisposeBag()
        self.disposeBag = disposeBag

        viewModel.author.asObservable()
            .bind(to: authorLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.formattedDuration.asObservable()
            .bind(to: durationLabel.rx.text)
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
