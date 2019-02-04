//
//  ColorCardController.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class ColorCardController : DynamicController, DynamicViewModelDelegate
{
    private var _buttonView : UIImageView!
    @objc dynamic var viewModel : ColorCardViewModel!
    
    var buttonView : UIImageView
    {
        get
        {
            if (self._buttonView == nil)
            {
                self._buttonView = UIImageView()
            }
            
            let buttonView = self._buttonView!
            
            return buttonView
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.buttonView)
    }
    
    override func render()
    {
        super.render()
        
        self.view.frame.size = self.viewModel.size
        
        self.buttonView.frame.size.width = self.view.frame.size.width - 5
        self.buttonView.frame.size.height = self.buttonView.frame.size.width
        self.buttonView.frame.origin.x = (self.view.frame.size.width - self.buttonView.frame.size.width) / 2
        self.buttonView.frame.origin.y = (self.view.frame.size.height - self.buttonView.frame.size.height) / 2
        self.buttonView.layer.cornerRadius = self.buttonView.frame.width / 2
    }
    
    override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\ColorCardController.viewModel))
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
        if (event.newState == ColorCardViewModel.State.on)
        {
            self.buttonView.backgroundColor = self.viewModel.uicolor
            self.buttonView.layer.borderWidth = 0
        }
        else
        {
            self.buttonView.backgroundColor = UIColor.white
            self.buttonView.layer.borderColor = self.viewModel.uicolor.cgColor
            self.buttonView.layer.borderWidth = 2
        }
    }
    
    class CollectionCell : UICollectionViewCell
    {
        private var _colorCardController : ColorCardController!
        
        var colorCardController : ColorCardController
        {
            get
            {
                if (self._colorCardController == nil)
                {
                    self._colorCardController = ColorCardController()
                    self._colorCardController.bind()
                    self.addSubview(self._colorCardController.view)
                    self.autoresizesSubviews = false
                }
                
                let colorCardController = self._colorCardController!
                
                return colorCardController
            }
        }
    }
    
    class CollectionController : DynamicController, UICollectionViewDelegate, UICollectionViewDataSource
    {
        private var _collectionViewController : UICollectionViewController!
        private var _collectionCardControllers = Set<ColorCardController>()
        @objc dynamic var viewModel : ColorCardViewModel.CollectionViewModel!
        
        var collectionViewController : UICollectionViewController
        {
            get
            {
                if (self._collectionViewController == nil)
                {
                    let collectionViewController = self._collectionViewController!
                }
                
                return collectionViewController
            }
        }
        
        var collectionView : UICollectionView
        {
            get
            {
                let collectionView = self.collectionViewController.collectionView!
                
                return collectionView
            }
        }
        
        override func viewDidLoad()
        {
            self.collectionView.backgroundColor = UIColor.white
            self.collectionView.register(ColorCardController.CollectionCell.self,
                                         forCellWithReuseIdentifier: ColorCardViewModel.description())
            
            self.view.addSubview(self.collectionView)
        }
        
        override func unbind()
        {
            super.unbind()
            
            for colorCardController in self._collectionCardControllers
            {
                colorCardController.unbind()
            }
        }
        
        override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
        {
            if (kvoEvent.keyPath == DynamicKVO.keyPath(\ColorCardController.viewModel))
            {
                self.collectionView.reloadData()
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            var numberOfItemsInSection = 0
            
            if (self.viewModel != nil)
            {
                numberOfItemsInSection = self.viewModel.colorCardsViewModels.count
            }
            
            return numberOfItemsInSection
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            let collectionViewModel = self.viewModel.colorCardsViewModels[indexPath.row]
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: ColorCardViewModel.description(),
                                                               for: indexPath) as! ColorCardController.CollectionCell
            cell.colorCardController.viewModel.size = self.viewModel.itemSize
            cell.colorCardController.viewModel = collectionViewModel
            
            self._collectionCardControllers.insert(cell.colorCardController)
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
        {
            
        }
    }
}
