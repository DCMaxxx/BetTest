//
//  URLImageFetcher.swift
//  BetTest
//
//  Created by Maxime de Chalendar on 01/10/2017.
//  Copyright © 2017 Maxime de Chalendar. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Alamofire

extension URL {

    enum ImageFetchError: Error {
        case notAnImage
    }

    func image() -> Observable<UIImage?> {
        return Observable.create { observer in
            let request = Alamofire.request(self)

            request.responseData { response in
                if let error = response.error {
                    observer.onError(error)
                    return
                }

                guard let image = response.value.flatMap(UIImage.init) else {
                    observer.onError(ImageFetchError.notAnImage)
                    return
                }

                observer.onNext(image)
                observer.onCompleted()
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }

}
