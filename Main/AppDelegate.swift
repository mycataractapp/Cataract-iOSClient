//
//  AppDelegate.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/4/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit
import SwiftMoment
import CareKit
import UserNotifications
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
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

    var rootController = DropFormController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        self.window!.rootViewController = rootController

        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()

        self.rootController.bind()

//        self.rootController.loadAllStores()

        let firstPageViewModel = DropFormViewModel.FirstPageViewModel()
        let footerPanelViewModel = FooterPanelViewModel(id: "")
        let secondPageViewModel = DropFormViewModel.SecondPageViewModel()
        let thirdPageViewModel = DropFormViewModel.ThirdPageViewModel()
        let overLayCardViewModel = UserViewModel.OverLayCardViewModel(id: "")

        let viewModel = DropFormViewModel(firstPageViewModel: firstPageViewModel,
                                          secondPageViewModel: secondPageViewModel,
                                          thirdPageViewModel: thirdPageViewModel,
                                          footerPanelViewModel: footerPanelViewModel,
                                          overLayCardViewModel: overLayCardViewModel)

        viewModel.size = UIScreen.main.bounds.size

        self.rootController.viewModel = viewModel
        
        return true
    }
}

