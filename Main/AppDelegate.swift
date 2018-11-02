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

    var rootController = CustomController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        self.window!.rootViewController = rootController
//        self.rootController.collectionViewController.collectionView!.frame.size.height = 300

        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()

        self.rootController.bind()
        
        let viewModel = CustomViewModel(id: "")
        
//        self.rootController.loadAllStores()
        
//        let footerPanelViewModel = FooterPanelViewModel(id: "")
//        let firstPageViewModel = DropFormViewModel.FirstPageViewModel()
//        let secondPageViewModel = DropFormViewModel.SecondPageViewModel()
//        let thirdPageViewModel = DropFormViewModel.ThirdPageViewModel()
//        let overlayCardViewModel = UserViewModel.OverLayCardViewModel(id: "")
//        let firstPageViewModel = AppointmentFormViewModel.FirstPageViewModel()
//        let secondPageViewModel = AppointmentFormViewModel.SecondPageViewModel()
//        let appointmentInputViewModel = UserViewModel.AppointmentInputViewModel(id: "")
//
//        let viewModel = AppointmentFormViewModel(footerPanelViewModel: footerPanelViewModel,
//                                                 firstPageViewModel: firstPageViewModel,
//                                                 secondPageViewModel: secondPageViewModel,
//                                                 appointmentInputViewModel: appointmentInputViewModel)
//        let viewModel = DropFormViewModel(firstPageViewModel: firstPageViewModel,
//                                          secondPageViewModel: secondPageViewModel,
//                                          thirdPageViewModel: thirdPageViewModel,
//                                          footerPanelViewModel: footerPanelViewModel,
//                                          overLayCardViewModel: overlayCardViewModel)
        viewModel.size = UIScreen.main.bounds.size
        viewModel.size.height = 300
        viewModel.buttonCardViewModel.size.width = viewModel.size.width
        viewModel.buttonCardViewModel.size.height = 100
        
        self.rootController.viewModel = viewModel
        self.rootController.present(self.rootController.collectionViewController, animated: false, completion: nil)
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.rootController.present(self.rootController.collectionViewController, animated: false, completion: nil)
    }
}

class CustomController : DynamicController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    private var _collectionViewController : UICollectionViewController!
    private var _collectionViewFlowLayout : UICollectionViewFlowLayout!
    private var _buttonCollectionCell : UserController.ButtonController.CollectionCell!
    @objc dynamic var viewModel : CustomViewModel!
    
    var collectionViewController : UICollectionViewController
    {
        get
        {
            if (self._collectionViewController == nil)
            {
                self._collectionViewController = UICollectionViewController(collectionViewLayout: self.collectionViewFlowLayout)
                self._collectionViewController.collectionView!.delegate = self
                self._collectionViewController.collectionView!.dataSource = self
            }
            
            let collectionViewController = self._collectionViewController!
            
            return collectionViewController
        }
    }
    
    var collectionViewFlowLayout : UICollectionViewFlowLayout
    {
        get
        {
            if (self._collectionViewFlowLayout == nil)
            {
                self._collectionViewFlowLayout = UICollectionViewFlowLayout()
                self._collectionViewFlowLayout.minimumLineSpacing = 0
                self._collectionViewFlowLayout.minimumInteritemSpacing = 0
            }
            
            let collectionViewFlowLayout = self._collectionViewFlowLayout!
            
            return collectionViewFlowLayout
        }
    }
    
    var buttonCollectionCell : UserController.ButtonController.CollectionCell
    {
        get
        {
            print("Nil", self._buttonCollectionCell == nil)
            
            if (self._buttonCollectionCell == nil)
            {
                self._buttonCollectionCell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: UserViewModel.ButtonCardViewModel.description(), for: IndexPath(item: 0, section: 0)) as? UserController.ButtonController.CollectionCell
                
                print("MAKE", self._buttonCollectionCell.buttonController)
            }

            let buttonCollectionCell = self._buttonCollectionCell!
            print("DONE")

            return buttonCollectionCell
        }
    }

    override func viewDidLoad()
    {
        self.collectionViewController.collectionView!.backgroundColor = UIColor.blue
//        self.view.addSubview(self.collectionViewController.collectionView!)
    }
    
    override func render()
    {
        super.render()
        
        self.view.frame.size = self.viewModel.size
        
        print("333")
        self.buttonCollectionCell.buttonController.viewModel = self.viewModel.buttonCardViewModel
        print("RETURN")
        self.collectionViewController.collectionView!.reloadData()
    }
    
    override func bind()
    {
        super.bind()
        
        self.collectionViewController.collectionView!.register(UserController.ButtonController.CollectionCell.self,
                                                               forCellWithReuseIdentifier: UserViewModel.ButtonCardViewModel.description())
    }
    
    override func unbind()
    {
        super.unbind()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if (self.viewModel != nil)
        {
            return 1
        }
        else
        {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var size = CGSize.zero
        
        if (indexPath.item == 0)
        {
            print("111")
            size = self.buttonCollectionCell.buttonController.view.frame.size
//            let buttonController = UserController.ButtonController()
//            buttonController.bind()
//            buttonController.viewModel = self.viewModel.buttonCardViewModel
//            size = buttonController.view.frame.size
//            buttonController.unbind()
        }
        
        print("FINAL", size)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell : UICollectionViewCell! = nil

        if (indexPath.item == 0)
        {
            cell = self.buttonCollectionCell
            print("AA")
        }
        
//        let buttonControllerCell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: UserViewModel.ButtonCardViewModel.description(), for: indexPath) as! UserController.ButtonController.CollectionCell
//        buttonControllerCell.buttonController.viewModel = self.viewModel.buttonCardViewModel

//        cell = buttonControllerCell
        
        return cell
    }
    
//    override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
//    {
//        if (kvoEvent.keyPath == DynamicKVO.keyPath(\CustomController.viewModel))
//        {
//            if (controllerEvent.operation == DynamicController.Event.Operation.bind)
//            {
//                self.viewModel.delegate = self
//            }
//            else
//            {
//                self.viewModel.delegate = nil
//            }
//        }
//    }
//
//    func viewModel(_ viewModel: DynamicViewModel, transitWith event: DynamicViewModel.Event)
//    {
//        if (event.newState == CustomViewModel.State.changed)
//        {
//            self.collectionViewController.collectionView!.reloadData()
//        }
//    }
}

class CustomViewModel : CardViewModel
{
    private var _buttonCardViewModel : UserViewModel.ButtonCardViewModel!
    
    @objc var buttonCardViewModel : UserViewModel.ButtonCardViewModel
    {
        get
        {
            if (self._buttonCardViewModel == nil)
            {
                self._buttonCardViewModel = UserViewModel.ButtonCardViewModel(id: "")
            }

            let buttonCardViewModel = self._buttonCardViewModel!

            return buttonCardViewModel
        }
    }
    
    @objc func change()
    {
        self.transit(transition: CustomViewModel.Transition.change,
                     to: CustomViewModel.State.changed)
    }
    
    struct Transition
    {
        static let change = DynamicViewModel.Transition(rawValue: "Change")
    }
    
    struct State
    {
        static let changed = DynamicViewModel.State(rawValue: "Changed")
    }
}
