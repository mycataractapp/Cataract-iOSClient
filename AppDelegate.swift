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
    var rootController : AppDetailController!
    
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
        self.rootController = AppDetailController()
        
        self.window!.rootViewController = self.rootController
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()
        
        let rootViewModel = AppDetailViewModel()
        
        var navigationViewModel : NavigationViewModel!

        for index in 0...1
        {
            if (index == 0)
            {
                navigationViewModel = NavigationViewModel(imagePath: Bundle.main.path(forResource: "DropsOn", ofType: "png")!)
            }
            else if (index == 1)
            {
                navigationViewModel = NavigationViewModel(imagePath: Bundle.main.path(forResource: "AppointmentsOn", ofType: "png")!)
            }
            rootViewModel.navigationOverviewViewModel.navigationViewModels.append(navigationViewModel)
        }
        
//        do
//        {
//            let url : URL = URL(fileURLWithPath: Bundle.main.path(forResource: "DropData", ofType: "json")!)
//            let source : Data = try Data(contentsOf: url)
//            let jsons : [JSON] = JSON(source).array!
//            let dropStore: DynamicStore<DropModel> = DynamicStore()
//
//            for json in jsons
//            {
//                let dropModel = DropModel()
//                dropModel.data = json
//                dropStore.push(dropModel, isNetworkEnabled: false)
//            }
//
//
//
        let dropStore = DropStore()

        dropStore.load(count: 5, info: nil, isNetworkEnabled: false)

            for dropModel in dropStore
            {
                let dropTimeViewModel = DropTimeViewModel(colorPath: Bundle.main.path(forResource: dropModel.button, ofType: "png")!,
                                                          drop: dropModel.drop,
                                                          time: dropModel.time)
                rootViewModel.dropTimeOverviewViewModel.dropTimeViewModels.append(dropTimeViewModel)
            }

        let appointmentStore = AppointmentStore()

        appointmentStore.load(count: 5, info: nil, isNetworkEnabled: false)

        for appointmentModel in appointmentStore
        {
            let appointmentTimeViewModel = AppointmentTimeViewModel(title: appointmentModel.title,
                                                                    date: appointmentModel.date,
                                                                    time: appointmentModel.time)
            rootViewModel.appointmentTimeOverviewViewModel.appointmentTimeViewModels.append(appointmentTimeViewModel)
        }
//    }
//        catch{}
//        
        
//        for index in 0...4
//        {
//            let dropTimeViewModel = DropTimeViewModel(colorPath: Bundle.main.path(forResource: "Blue", ofType: "png")!,
//                                                      drop: "Blue Top",
//                                                      time: "12:00pm")
//            let appointmentTimeViewModel = AppointmentTimeViewModel(title: "Pre-Op",
//                                                                    date: "June 20th, 2018",
//                                                                    time: "1:00pm")
//                rootViewModel.dropTimeViewModels.append(dropTimeViewModel)
//            rootViewModel.dropTimeOverviewViewModel.dropTimeViewModels.append(dropTimeViewModel)
//            rootViewModel.appointmentTimeOverviewViewModel.appointmentTimeViewModels.append(appointmentTimeViewModel)
//        }
        
        self.rootController.bind(viewModel: rootViewModel)
        self.rootController.render(size: self.rootControllerSize)
        self.rootController.view.frame.origin = self.rootControllerOrigin
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        rootController.viewModel.transit(transition: "Deselect", to: "Off")
    }
}


