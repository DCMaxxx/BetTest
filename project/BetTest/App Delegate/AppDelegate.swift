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

    private func setRootViewController() {
        let userID = "5" // Daniel Marhely's
        let fetcher = UserPlaylistsFetcher(userID: userID)
        let playlistList = UserPlaylistList(fetcher: fetcher)
        let viewModel =  UserPlaylistListViewModel(userPlaylistList: playlistList)
        let playlistListViewController = PlaylistListViewController.instantiate(viewModel: viewModel)

        let navigationController = UINavigationController(rootViewController: playlistListViewController)

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

}
