//
//  AppDelegate.swift
//  BetTest
//
//  Created by Maxime de Chalendar on 29/09/2017.
//  Copyright © 2017 Maxime de Chalendar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        setRootViewController()
        return true
    }

}

// MARK: - Root View Controller handling
extension AppDelegate {

    fileprivate func setRootViewController() {
        let userID = Constants.Users.deezerFounderID
        let rootViewController = buildRootViewController(forUserID: userID)
        setKeyWindow(withRootController: rootViewController)
    }

    private func buildRootViewController(forUserID userID: String) -> UIViewController {
        let fetcher = UserPlaylistsFetcher(userID: userID)
        let playlistList = UserPlaylistList(fetcher: fetcher)
        let viewModel =  UserPlaylistListViewModel(userPlaylistList: playlistList)
        let playlistListViewController = PlaylistListViewController.instantiate(viewModel: viewModel)

        return UINavigationController(rootViewController: playlistListViewController)
    }

    private func setKeyWindow(withRootController rootViewController: UIViewController) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }

}
