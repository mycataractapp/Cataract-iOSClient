//
//  AppDelegate.swift
//  Cataract
//
//  Created by Rose Choi on 6/4/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    var rootController : DropTimeController!
    
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
        self.rootController = DropTimeController()

        self.window!.rootViewController = self.rootController
        self.window!.backgroundColor = UIColor.black
        self.window!.makeKeyAndVisible()
        
        let rootViewModel = DropTimeViewModel(colorPath: Bundle.main.path(forResource: "Blue", ofType: "png")!,
                                              drop: "Blue Top",
                                              time: "12:00pm")

//        for index in 0...1
//        {
//            let imagePathByState = ["On": Bundle.main.path(forResource: "DropOn", ofType: "png")!,
//                                    "Off": Bundle.main.path(forResource: "DropOff", ofType: "png")!]
//            let navigationViewModel = NavigationViewModel(imagePathByState: imagePathByState, isSelected: false)
//
//            rootViewModel.navigationViewModels.append(navigationViewModel)
//        }
        
        self.rootController.bind(viewModel: rootViewModel)
        self.rootController.render(size: self.rootControllerSize)
        self.rootController.view.frame.origin = self.rootControllerOrigin
        
//        self.rootController.dropStore.load(count: 5, info: nil, isNetworkEnabled: false)
//        self.rootController.appointmentStore.load(count: 5, info: nil, isNetworkEnabled: false)
        
        return true
    }
}


