//
//  AppDelegate.swift
//  RxSwiftTraining
//
//  Created by yochidros on 2020/02/18.
//  Copyright © 2020 yochidros. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		window = UIWindow(frame: UIScreen.main.bounds)
		let navigation = UINavigationController(rootViewController: TopViewController())
		window?.rootViewController = navigation
		window?.makeKeyAndVisible()
		return true
	}

}

