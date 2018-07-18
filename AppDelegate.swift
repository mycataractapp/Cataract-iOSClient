//
//  AppDelegate.swift
//  Cataract
//
//  Created by Rose Choi on 6/4/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftMoment
import CareKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, OCKCarePlanStoreDelegate
{
    var window: UIWindow?
    var rootController : DropFormDetailController!
    
    var rootControllerSize : CGSize
    {
        get
        {
            var rootControllerSize = UIScreen.main.bounds.size
            
            rootControllerSize.width -= (self.window!.safeAreaInsets.left + self.window!.safeAreaInsets.right)
            rootControllerSize.height -= (self.window!.safeAreaInsets.top + self.window!.safeAreaInsets.bottom)
            
            if (rootControllerSize.height == UIScreen.main.bounds.size.height)
            {
                rootControllerSize.height -= UIApplication.shared.statusBarFrame.height
            }
                        
            return rootControllerSize
        }
    }
    var rootControllerOrigin : CGPoint
    {
        get
        {
            var rootControllerOrigin = CGPoint.zero
            rootControllerOrigin.x = self.window!.safeAreaInsets.left
            rootControllerOrigin.y = self.window!.safeAreaInsets.top
            
            if (rootControllerOrigin.y == 0)
            {
                rootControllerOrigin.y = UIApplication.shared.statusBarFrame.height
            }
            
            return rootControllerOrigin
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        self.rootController = DropFormDetailController()

        self.window!.rootViewController = self.rootController
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()

        let rootViewModel = DropFormDetailViewModel()

        self.rootController.bind(viewModel: rootViewModel)
        self.rootController.render(size: self.rootControllerSize)
        self.rootController.view.frame.origin = self.rootControllerOrigin

//        self.rootController.informationStore.load(count: 11, info: nil, isNetworkEnabled: false)
//        self.rootController.dropColorStore.load(count: 7, info: nil, isNetworkEnabled: false)
//        self.rootController.dropFormInputController.colorStore.load(count: 7, info: nil, isNetworkEnabled: false)
//        self.rootController.dropStore.load(count: 5, info: nil, isNetworkEnabled: false)
//        self.rootController.appointmentStore.load(count: 5, info: nil, isNetworkEnabled: false)
        
        return true
    }
}



