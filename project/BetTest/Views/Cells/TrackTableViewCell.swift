//
//  TrackTableViewCell.swift
//  BetTest
//
//  Created by Maxime de Chalendar on 30/09/2017.
//  Copyright © 2017 Maxime de Chalendar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

/// A cell responsible for displaying a PlaylistTrackViewModelType
final class TrackTableViewCell: UITableViewCell {

    private var disposeBag: DisposeBag?

    var viewModel: PlaylistTrackViewModelType? {
        didSet {
            disposeBag = nil
            configureInterface()
        }
    }

    override func prepareForReuse() {
        viewModel = nil
    }

    private func configureInterface() {
        guard
            let viewModel = viewModel,
            let titleLabel = textLabel,
            let subtitleLabel = detailTextLabel
            else {
                textLabel?.text = nil
                detailTextLabel?.text = nil
                return
        }

        let disposeBag = DisposeBag()
        self.disposeBag = disposeBag

        viewModel.title.asObservable()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.subtitle.asObservable()
            .bind(to: subtitleLabel.rx.text)
            .disposed(by: disposeBag)
    }

}

extension TrackTableViewCell: Reusable {

}
