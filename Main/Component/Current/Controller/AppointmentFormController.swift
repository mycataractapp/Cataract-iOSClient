//
//  AppointmentFormController.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class AppointmentFormController : DynamicController
{
    private var _pageViewController : UIPageViewController!
    private var _firstPageController : AppointmentFormController.FirstPageController!
    @objc dynamic var viewModel : AppointmentFormViewModel!
    
    var pageViewController : UIPageViewController
    {
        get
        {
            if (self._pageViewController == nil)
            {
                self._pageViewController = UIPageViewController()
            }
            
            let pageViewController = self._pageViewController!
            
            return pageViewController
        }
    }
    
    var firstPageController : AppointmentFormController.FirstPageController
    {
        get
        {
            if (self._firstPageController == nil)
            {
                self._firstPageController = AppointmentFormController.FirstPageController()
            }
            
            let firstPageController = self._firstPageController!
            
            return firstPageController
        }
    }
    
    override func render()
    {
        super.render()
        
        self.view.frame.size = self.viewModel.size
        
        self.viewModel.firstPageViewModel.labelViewModel.size.width = self.view.frame.size.width
        self.viewModel.firstPageViewModel.labelViewModel.size.height = 50
    }
    
    class FirstPageController : DynamicController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    {
        private var _collectionViewController : UICollectionViewController!
        private var _collectionViewFlowLayout : UICollectionViewFlowLayout!
        @objc dynamic var viewModel : AppointmentFormViewModel.FirstPageViewModel!
        
        var collectionViewController : UICollectionViewController
        {
            get
            {
                if (self._collectionViewController == nil)
                {
                    self._collectionViewController = UICollectionViewController(collectionViewLayout: self.collectionViewFlowLayout)
                    self._collectionViewController.collectionView!.dataSource = self
                    self._collectionViewController.collectionView!.delegate = self
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
        
        override func viewDidLoad()
        {
            self.collectionViewController.collectionView!.backgroundColor = UIColor.white
        }
        
        override func render()
        {
            super.render()
            
            self.collectionViewController.collectionView?.reloadData()
        }
        
        override func bind()
        {
            super.bind()
            
            self.collectionViewController.collectionView?.register(LabelController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: LabelViewModel.description())
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            return 7
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            var size = CGSize.zero
            
            if (indexPath.item == 0)
            {
                let labelController = LabelController()
                labelController.bind()
                labelController.viewModel = self.viewModel.labelViewModel
                size = labelController.view.frame.size
                labelController.unbind()
            }
            else if (indexPath.item >= 1 && indexPath.item < 6)
            {
                let labelController = LabelController()
                labelController.bind()
                labelController.viewModel = self.viewModel.labelViewModel
                size = labelController.view.frame.size
                labelController.unbind()
            }
            else if (indexPath.item == 7)
            {
                let labelController = LabelController()
                labelController.bind()
                labelController.viewModel = self.viewModel.instructionLabelViewModel
                size = labelController.view.frame.size
                labelController.unbind()
            }
        
            return size
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            var cell = UICollectionViewCell()
            
            return cell
        }
    }
}
