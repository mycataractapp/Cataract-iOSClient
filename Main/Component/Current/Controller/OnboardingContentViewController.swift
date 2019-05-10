//
//  OnboardingContentViewController.swift
//  Cataract
//
//  Created by Roseanne Choi on 5/8/19.
//  Copyright © 2019 Rose Choi. All rights reserved.
//

import UIKit

class OnboardingContentViewController : DynamicController
{
    private var _imageView : UIImageView!
    @objc dynamic var viewModel : OnboardingContentViewModel!
    
    var imageView : UIImageView
    {
        get
        {
            if (self._imageView == nil)
            {
                self._imageView = UIImageView()
            }
            
            let imageView = self._imageView!
            
            return imageView
        }
    }
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 0.8)
        
        self.view.addSubview(self.imageView)
    }
    
    override func render()
    {
        super.render()
        
        self.view.frame.size = self.viewModel.size
        
        self.imageView.frame.size.width = self.view.frame.size.width
        self.imageView.frame.size.height = self.view.frame.size.height - 50
        self.imageView.frame.origin.y = 25
    }
    
    override func bind()
    {
        super.bind()
        
        self.addObserver(self,
                         forKeyPath: "viewModel.image",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.removeObserver(self, forKeyPath: "viewModel.image")
    }
    
    override func observeKeyValue(for kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == "viewModel.image")
        {
            let newValue = kvoEvent.newValue as? String
            self.set(image: newValue)
        }
    }
    
    func set(image: String?)
    {
        let image = UIImage(contentsOfFile: Bundle.main.path(forResource: image, ofType: "png")!)
        
        self.imageView.image = image
    }
    
    class Cell : UICollectionViewCell
    {
        private var _onboardingContentViewController : OnboardingContentViewController!
        
        var onboardingContentViewController : OnboardingContentViewController
        {
            get
            {
                if (self._onboardingContentViewController == nil)
                {
                    self._onboardingContentViewController = OnboardingContentViewController()
                    self._onboardingContentViewController.bind()
                    self.addSubview(self._onboardingContentViewController.view)
                    self.autoresizesSubviews = false
                }
                
                let onboardingContentViewController = self._onboardingContentViewController!
                
                return onboardingContentViewController
            }
        }
    }
    
    class CollectionViewController : DynamicController, DynamicViewModelDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    {
        private var _collectionViewController : UICollectionViewController!
        private var _collectionViewFlowLayout : UICollectionViewFlowLayout!
        private var _button : UIButton!
        @objc dynamic var viewModel : OnboardingContentViewModel.CollectionViewModel!
        
        var collectionViewController : UICollectionViewController
        {
            get
            {
                if (self._collectionViewController == nil)
                {
                    self._collectionViewController = UICollectionViewController(collectionViewLayout: self.collectionViewFlowLayout)
                    self._collectionViewController.collectionView!.isPagingEnabled = true
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
                    self._collectionViewFlowLayout.scrollDirection = .horizontal
                    self._collectionViewFlowLayout.minimumLineSpacing = 0
                    self._collectionViewFlowLayout.minimumInteritemSpacing = 0
                }
                
                let collectionViewFlowLayout = self._collectionViewFlowLayout!
                
                return collectionViewFlowLayout
            }
        }
        
        var button : UIButton
        {
            get
            {
                if (self._button == nil)
                {
                    self._button = UIButton()
                    self._button.backgroundColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
                    self.button.alpha = 0
                    self._button.setTitle("Enter", for: .normal)
                }
                
                let button = self._button!
                
                return button
            }
        }
        
        override func viewDidLoad()
        {
            self.collectionViewController.modalPresentationStyle = UIModalPresentationStyle.currentContext
            self.collectionViewController.collectionView!.backgroundColor = UIColor.white
            
            self.view.addSubview(self.collectionViewController.collectionView!)
            self.view.addSubview(self.button)
        }
        
        override func render()
        {
            super.render()
            
            self.view.frame.size = self.viewModel.itemSize
            
            for viewModel in self.viewModel.onboardingContentViewModels
            {
                viewModel.size = self.view.frame.size
            }
            
            self.button.frame.size.width = self.view.frame.size.width
            self.button.frame.size.height = 90
            self.button.frame.origin.y = self.view.frame.size.height - self.button.frame.size.height
        }
        
        override func bind()
        {
            super.bind()
            
            self.collectionViewController.collectionView!.register(OnboardingContentViewController.Cell.self,
                                                                   forCellWithReuseIdentifier: OnboardingContentViewModel.description())
            
            self.button.addTarget(self,
                                  action: #selector(self._start),
                                  for: .touchDown)
        }
        
        override func unbind()
        {
            super.unbind()
            
            self.button.removeTarget(self,
                                     action: #selector(self._start),
                                     for: .touchDown)
        }

        @objc private func _start()
        {
            if (self.viewModel != nil)
            {
                self.viewModel.start()
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            return self.viewModel.onboardingContentViewModels.count
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            var size = CGSize.zero
            
            let viewModel = self.viewModel.onboardingContentViewModels[indexPath.item]
            size = viewModel.size
            
            return size
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            var cell : UICollectionViewCell! = nil
 
            let viewModel = self.viewModel.onboardingContentViewModels[indexPath.item]
            let onboardingContentViewControllerCell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: OnboardingContentViewModel.description(),
                                                                                                                        for: indexPath) as! OnboardingContentViewController.Cell
            onboardingContentViewControllerCell.onboardingContentViewController.viewModel = viewModel
            
            cell = onboardingContentViewControllerCell
            
            return cell
        }

       func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
       {
            if (indexPath.item == 5)
            {
                UIView.animate(withDuration: 3.0)
                {
                    self.button.alpha = 1
                }
            }
            else
            {
                UIView.animate(withDuration: 0.5)
                {
                    self.button.alpha = 0
                }
            }
        }
        
        override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
        {
            if (kvoEvent.keyPath == DynamicKVO.keyPath(\UserController.ButtonController.viewModel))
            {
                if (controllerEvent.operation == DynamicController.Event.Operation.bind)
                {
                    self.viewModel.delegate = self
                }
                else
                {
                    self.viewModel.delegate = nil
                }
            }
        }
        
        func viewModel(_ viewModel: DynamicViewModel, transitWith event: DynamicViewModel.Event)
        {
            if (event.transition == OnboardingContentViewModel.CollectionViewModel.Transition.start)
            {
                print("startedddd")
            }
        }
    }
}

