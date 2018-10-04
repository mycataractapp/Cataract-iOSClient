//
//  CustomCardController.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 9/15/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class CustomCardController : DynamicController
{
    private var _label : UILabel!
    @objc dynamic var viewModel : CustomCardViewModel!
    
    var label : UILabel
    {
        get
        {
            if (self._label == nil)
            {
                self._label = UILabel()
                self._label.textAlignment = NSTextAlignment.center
                self._label.backgroundColor = UIColor.blue
            }
            
            let label = self._label!
            
            return label
        }
    }
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.purple
        
        self.view.addSubview(self.label)
    }
    
    override func render()
    {
        super.render()
        
        let canvas = self.viewModel.size
        
        self.view.frame.size = canvas
        
        self.label.frame.size.width = 5
        self.label.frame.size.height = 2
        self.label.frame.origin.x = (canvas.width - self.label.frame.size.width) / 2
        self.label.frame.origin.y = (canvas.height - self.label.frame.size.height) / 2
    }
    
    override func bind()
    {
        super.bind()
        
        self.addObserver(self,
                         forKeyPath: DynamicKVO.keyPath(\CustomCardController.viewModel.name),
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\CustomCardController.viewModel.name))
    }
    
    override func observeKeyValue(for kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.kind == DynamicKVO.Event.Kind.setting)
        {
            if (kvoEvent.keyPath == DynamicKVO.keyPath(\CustomCardController.viewModel.name))
            {
                let newValue = kvoEvent.newValue as? String
                self.set(name: newValue)
            }
        }
    }
    
    func set(name: String?)
    {
        self.label.text = name
    }
    
    class CustomCollectionCell : UICollectionViewCell
    {
        private var _customCardController : CustomCardController!
            
        var customCardController : CustomCardController
        {
            get
            {
                if (self._customCardController == nil)
                {
                    self._customCardController = CustomCardController()
                    self._customCardController.bind()
                    self.addSubview(self._customCardController.view)
                    self.autoresizesSubviews = false
                }
                
                let customCardController = self._customCardController!
                
                return customCardController
            }
        }
    }
    
    class CustomCollectionController : DynamicController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    {
        private var _collectionViewController : UICollectionViewController!
        private var _collectionViewFlowLayoutController : UICollectionViewFlowLayout!
        private var _customCardControllers = Set<CustomCardController>()
        @objc dynamic var viewModel : CustomCardViewModel.CollectionViewModel!
        
        var collectionViewController : UICollectionViewController
        {
            get
            {
                if (self._collectionViewController == nil)
                {
                    self._collectionViewController = UICollectionViewController(collectionViewLayout: self.collectionViewFlowLayoutController)
                    self._collectionViewController.collectionView?.delegate = self
                    self._collectionViewController.collectionView?.dataSource = self
                }
                
                let collectionViewController = self._collectionViewController!
                
                return collectionViewController
            }
        }
        
        var collectionViewFlowLayoutController : UICollectionViewFlowLayout
        {
            get
            {
                if (self._collectionViewFlowLayoutController == nil)
                {
                    self._collectionViewFlowLayoutController = UICollectionViewFlowLayout()
                    self._collectionViewFlowLayoutController.minimumInteritemSpacing = 0
                    self._collectionViewFlowLayoutController.minimumLineSpacing = 0 
                }
                
                let collectionViewFlowLayoutController = self._collectionViewFlowLayoutController!
                
                return collectionViewFlowLayoutController
            }
        }
        
        override func viewDidLoad()
        {
            self.view.backgroundColor = UIColor.white
            self.collectionViewController.collectionView?.backgroundColor = UIColor.white
            
            self.view.addSubview(self.collectionViewController.collectionView!)
            
            self.collectionViewController.collectionView?.register(CustomCardController.CustomCollectionCell.self, forCellWithReuseIdentifier: CustomCardViewModel.description())
        }
        
        override func unbind()
        {
            super.unbind()
            
            for customCardController in self._customCardControllers
            {
                customCardController.unbind()
            }
        }
        
        override func observeKeyValue(for kvoEvent: DynamicKVO.Event)
        {
            if (kvoEvent.keyPath == DynamicKVO.keyPath(\CustomCollectionController.viewModel))
            {
                self.collectionViewController.collectionView?.reloadData()
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            if (self.viewModel != nil)
            {
                return self.viewModel.customCardViewModels.count
            }
            else
            {
                return 0
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            var size = CGSize.zero
            
            let customCardController = CustomCardController()
            customCardController.bind()
            customCardController.viewModel = self.viewModel.customCardViewModels[indexPath.row]
            size = customCardController.view.frame.size
            customCardController.unbind()
            
            return size
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            let customCardViewModel = self.viewModel.customCardViewModels[indexPath.row]
            let cell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: CustomCardViewModel.description(), for: indexPath) as! CustomCardController.CustomCollectionCell
            cell.customCardController.viewModel = customCardViewModel
            self._customCardControllers.insert(cell.customCardController)
            
            return cell
        }
    }
}
