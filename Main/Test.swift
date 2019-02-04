//
//  Test.swift
//  Cataract
//
//  Created by Roseanne Choi on 1/17/19.
//  Copyright © 2019 Rose Choi. All rights reserved.
//

//import UIKit
//
//class CustomViewModel : DynamicViewModel
//{
//    var size = CGSize.zero
//    @objc var fullName : String
//
//    init(fullName: String)
//    {
//        self.fullName = fullName
//
//        super.init()
//    }
//}
//
//class CustomViewController : DynamicController
//{
//    private var _label : UILabel!
//    @objc dynamic var viewModel : CustomViewModel!
//
//    var label : UILabel
//    {
//        get
//        {
//            if (self._label == nil)
//            {
//                self._label = UILabel()
//                self._label.textAlignment = NSTextAlignment.center
//            }
//
//            let label = self._label!
//
//            return label
//        }
//    }
//
//    override func viewDidLoad()
//    {
//        self.view.backgroundColor = UIColor.white
//
//        self.view.addSubview(self.label)
//    }
//
//    override func render()
//    {
//        super.render()
//
//        self.view.frame.size = self.viewModel.size
//
//        self.label.frame.size = self.view.frame.size
//    }
//
//    override func bind()
//    {
//        super.bind()
//
//        self.addObserver(self,
//                         forKeyPath: DynamicKVO.keyPath(\CustomViewController.viewModel.fullName),
//                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
//                                                              NSKeyValueObservingOptions.initial]),
//                         context: nil)
//    }
//
//    override func unbind()
//    {
//        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\CustomViewController.viewModel.fullName))
//    }
//
//    override func observeKeyValue(for kvoEvent: DynamicKVO.Event)
//    {
//        if (kvoEvent.keyPath == DynamicKVO.keyPath(\CustomViewController.viewModel.fullName))
//        {
//            let newValue = kvoEvent.newValue as? String
//            self.set(fullName: newValue)
//        }
//    }
//
//    func set(fullName: String?)
//    {
//        self.label.text = fullName
//    }
//}
//
////class CustomCell : UICollectionViewCell
////{
////    private var _customViewController : CustomViewController!
////
////    var customViewController : CustomViewController
////    {
////        get
////        {
////            if (self._customViewController == nil)
////            {
////                self._customViewController = CustomViewController()
////                self._customViewController.bind()
////                self.addSubview(self._customViewController.view)
////                self.autoresizesSubviews = false
////            }
////
////            let customViewController = self._customViewController!
////
////            return customViewController
////        }
////    }
////}
//
//class FirstTestViewModel : DynamicViewModel
//{
//    var size = CGSize.zero
//    private var _customViewModels : [CustomViewModel]
//
//    init(customViewModels: [CustomViewModel])
//    {
//        self._customViewModels = customViewModels
//
//        super.init()
//    }
//
//    var customViewModels : [CustomViewModel]
//    {
//        get
//        {
//            let customViewModels = self._customViewModels
//
//            return customViewModels
//        }
//    }
//}
//
//class FirstTestController : DynamicController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
//{
//    private var _collectionViewController : UICollectionViewController!
//    private var _collectionViewFlowLayout : UICollectionViewFlowLayout!
//    private var _controllerByCell = [UICollectionViewCell:CustomViewController]()
//    @objc dynamic var viewModel : FirstTestViewModel!
//
//    var collectionViewController : UICollectionViewController
//    {
//        get
//        {
//            if (self._collectionViewController == nil)
//            {
//                self._collectionViewController = UICollectionViewController(collectionViewLayout: self.collectionViewFlowLayout)
//                self._collectionViewController.collectionView!.delegate = self
//                self._collectionViewController.collectionView!.dataSource = self
//            }
//
//            let collectionViewController = self._collectionViewController!
//
//            return collectionViewController
//        }
//    }
//
//    var collectionViewFlowLayout : UICollectionViewFlowLayout
//    {
//        get
//        {
//            if (self._collectionViewFlowLayout == nil)
//            {
//                self._collectionViewFlowLayout = UICollectionViewFlowLayout()
//            }
//
//            let collectionViewFlowLayout = self._collectionViewFlowLayout!
//
//            return collectionViewFlowLayout
//        }
//    }
//
//    // every cell will always have only one controller attached
//    func controller(by cell: UICollectionViewCell) -> CustomViewController
//    {
//        var controller : CustomViewController! = nil
//
//        if (self._controllerByCell.keys.contains(cell))
//        {
//            controller = self._controllerByCell[cell]
//        }
//        else
//        {
//            controller = CustomViewController()
//            controller.bind()
//
//            cell.addSubview(controller.view)
//            cell.autoresizesSubviews = false
//            self._controllerByCell[cell] = controller
//        }
//
//        return controller
//    }
//
//    override func viewDidLoad()
//    {
//        self.collectionViewController.collectionView!.backgroundColor = UIColor.white
//
//        self.view.addSubview(self.collectionViewController.collectionView!)
//    }
//
//    override func render()
//    {
//        super.render()
//
//        self.viewModel.size.width = self.view.frame.size.width
//        self.viewModel.size.height = 150
//    }
//
//    override func bind()
//    {
//        super.bind()
//
//        self.collectionViewController.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.description())
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
//    {
//        var numberOfItemsInSection = 0
//
//        if (self.viewModel != nil)
//        {
//            numberOfItemsInSection = self.viewModel.customViewModels.count
//        }
//        else
//        {
//            numberOfItemsInSection = 0
//        }
//
//        return numberOfItemsInSection
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        var sizeForItemAt = self.viewModel.size
//
//        return sizeForItemAt
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
//    {
//        let cell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.description(), for: indexPath)
//        let customViewModel = self.viewModel.customViewModels[indexPath.item]
//        customViewModel.size = self.viewModel.size
//
//        let controller = self.controller(by: cell)
//        controller.viewModel = customViewModel
//
//        return cell
//    }
//}
//
//class SecondTestViewModel : DynamicViewModel
//{
//    var size = CGSize.zero
//    private var _firstCustomViewModel : CustomViewModel!
//    private var _secondCustomViewModel : CustomViewModel!
//    private var _thirdCustomViewModel : CustomViewModel!
//
//    var firstCustomViewModel : CustomViewModel
//    {
//        get
//        {
//            if (self._firstCustomViewModel == nil)
//            {
//                self._firstCustomViewModel = CustomViewModel(fullName: "ROSE CHOI")
//            }
//
//            let firstCustomViewModel = self._firstCustomViewModel!
//
//            return firstCustomViewModel
//        }
//    }
//
//    var secondCustomViewModel : CustomViewModel
//    {
//        get
//        {
//            if (self._secondCustomViewModel == nil)
//            {
//                self._secondCustomViewModel = CustomViewModel(fullName: "CHOI CHOI")
//            }
//
//            let secondCustomViewModel = self._secondCustomViewModel!
//
//            return secondCustomViewModel
//        }
//    }
//
//    var thirdCustomViewModel : CustomViewModel
//    {
//        get
//        {
//            if (self._thirdCustomViewModel == nil)
//            {
//                self._thirdCustomViewModel = CustomViewModel(fullName: "ROSE ROSE")
//            }
//
//            let thirdCustomViewModel = self._thirdCustomViewModel!
//
//            return thirdCustomViewModel
//        }
//    }
//}
//
//class SecondTestController : DynamicController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
//{
//    private var _collectionViewController : UICollectionViewController!
//    private var _collectionViewFlowLayout : UICollectionViewFlowLayout!
//    private var _controllerByCell = [UICollectionViewCell:CustomViewController]()
//    @objc dynamic var viewModel : SecondTestViewModel!
//
//    var collectionViewController : UICollectionViewController
//    {
//        get
//        {
//            if (self._collectionViewController == nil)
//            {
//                self._collectionViewController = UICollectionViewController(collectionViewLayout: self.collectionViewFlowLayout)
//                self._collectionViewController.collectionView!.delegate = self
//                self._collectionViewController.collectionView!.dataSource = self
//            }
//
//            let collectionViewController = self._collectionViewController!
//
//            return collectionViewController
//        }
//    }
//
//    var collectionViewFlowLayout : UICollectionViewFlowLayout
//    {
//        get
//        {
//            if (self._collectionViewFlowLayout == nil)
//            {
//                self._collectionViewFlowLayout = UICollectionViewFlowLayout()
//            }
//
//            let collectionViewFlowLayout = self._collectionViewFlowLayout!
//
//            return collectionViewFlowLayout
//        }
//    }
//
//    func controller(by cell: UICollectionViewCell) -> CustomViewController
//    {
//        var controller : CustomViewController! = nil
//
//        if (self._controllerByCell.keys.contains(cell))
//        {
//            controller = self._controllerByCell[cell]
//        }
//        else
//        {
//            controller = CustomViewController()
//            controller.bind()
//
//            cell.addSubview(controller.view)
//            cell.autoresizesSubviews = false
//            self._controllerByCell[cell] = controller
//        }
//
//        return controller
//    }
//
//    override func viewDidLoad()
//    {
//        self.collectionViewController.collectionView!.backgroundColor = UIColor.white
//
//        self.view.addSubview(self.collectionViewController.collectionView!)
//    }
//
//    override func render()
//    {
//        super.render()
//
//        self.viewModel.firstCustomViewModel.size.width = self.viewModel.size.width
//        self.viewModel.firstCustomViewModel.size.height = 100
//
//        self.viewModel.secondCustomViewModel.size.width = self.viewModel.size.width
//        self.viewModel.secondCustomViewModel.size.height = 250
//
//        self.viewModel.thirdCustomViewModel.size.width = self.viewModel.size.width
//        self.viewModel.thirdCustomViewModel.size.height = 100
//    }
//
//    override func bind()
//    {
//        super.bind()
//
//        self.collectionViewController.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.description())
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int
//    {
//        var sections = 0
//
//        if (self.viewModel != nil)
//        {
//            sections = 3
//        }
//        else
//        {
//            sections = 0
//        }
//
//        return sections
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
//    {
//        var numberOfItemsInSection = 0
//
//        if (section == 0 || section == 1 || section == 2)
//        {
//            numberOfItemsInSection = 1
//        }
//
//        return numberOfItemsInSection
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        var size = CGSize.zero
//
//        if (self._controllerByCell.count == 0)
//        {
//            return CGSize(width: 100, height: 100)
//        }
//        else
//        {
//            let cell : UICollectionViewCell! = self.collectionViewController.collectionView!.cellForItem(at: indexPath)
//            let controller = self.controller(by: cell)
//            size = controller.view.frame.size
//        }
//
//        return size
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
//    {
//        let cell : UICollectionViewCell!
//
//        if (indexPath.section == 0)
//        {
//            cell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.description(), for: indexPath)
//            let viewModel = self.viewModel.firstCustomViewModel
//            viewModel.size = self.viewModel.firstCustomViewModel.size
//
//            let controller = self.controller(by: cell)
//            controller.viewModel = viewModel
//        }
//        else if (indexPath.section == 1)
//        {
//            cell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.description(), for: indexPath)
//            let viewModel = self.viewModel.secondCustomViewModel
//            viewModel.size = self.viewModel.secondCustomViewModel.size
//
//            let controller = self.controller(by: cell)
//            controller.viewModel = viewModel
//        }
//        else
//        {
//            cell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.description(), for: indexPath)
//            let viewModel = self.viewModel.thirdCustomViewModel
//            viewModel.size = self.viewModel.thirdCustomViewModel.size
//
//            let controller = self.controller(by: cell)
//            controller.viewModel = viewModel
//        }
//
//        self.collectionViewController.collectionView!.collectionViewLayout.invalidateLayout()
//
//        return cell
//    }
//}
