//
//  ContactFormController.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class ContactFormController : DynamicController, DynamicViewModelDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    private var _pageViewController : UIPageViewController!
    private var _collectionViewController : UICollectionViewController!
    private var _collectionViewFlowLayout : UICollectionViewFlowLayout!
    private var _footerPanelController : FooterPanelController!
    private var _textFieldInputControllers = [TextFieldInputViewModel:TextFieldInputController]()
    @objc dynamic var viewModel : ContactFormViewModel!
    
    var pageViewController : UIPageViewController
    {
        get
        {
            if (self._pageViewController == nil)
            {
               self._pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                               navigationOrientation: .horizontal,
                                                               options: nil)
               self._pageViewController.setViewControllers([self.collectionViewController],
                                                           direction: UIPageViewControllerNavigationDirection.forward,
                                                           animated: true,
                                                           completion: nil)
            }
            
            let pageViewController = self._pageViewController!
            
            return pageViewController
        }
    }
    
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
    
    var footerPanelController : FooterPanelController
    {
        get
        {
            if (self._footerPanelController == nil)
            {
                self._footerPanelController = FooterPanelController()
            }
            
            let footerPanelController = self._footerPanelController!
            
            return footerPanelController
        }
    }

    override func viewDidLoad()
    {
        self.collectionViewController.collectionView!.backgroundColor = UIColor.white
        
        self.view.addSubview(self.pageViewController.view)
        self.view.addSubview(self.footerPanelController.view)
    }
    
    override func render()
    {
        super.render()
        
        self.view.frame.size = self.viewModel.size
        
        self.viewModel.footerPanelViewModel.size.width = self.view.frame.size.width
        self.viewModel.footerPanelViewModel.size.height = 90
        
        self.pageViewController.view.frame.size.width = self.view.frame.size.width 
        self.pageViewController.view.frame.size.height = self.view.frame.size.height - self.viewModel.footerPanelViewModel.size.height
        
        self.viewModel.headerLabelViewModel.size.width = self.view.frame.size.width
        self.viewModel.headerLabelViewModel.size.height = self.collectionViewController.collectionView!.frame.size.height / 7
        
        self.viewModel.nameLabelViewModel.size.width = self.view.frame.size.width
        self.viewModel.nameLabelViewModel.size.height = self.collectionViewController.collectionView!.frame.size.height / 7
        
        self.viewModel.numberLabelViewModel.size.width = self.view.frame.size.width
        self.viewModel.numberLabelViewModel.size.height = self.collectionViewController.collectionView!.frame.size.height / 7

        self.viewModel.emailLabelViewModel.size.width = self.view.frame.size.width
        self.viewModel.emailLabelViewModel.size.height = self.collectionViewController.collectionView!.frame.size.height / 7
        
        self.viewModel.nameInputViewModel.size.width = self.view.frame.size.width
        self.viewModel.nameInputViewModel.size.height = self.collectionViewController.collectionView!.frame.size.height / 7

        self.viewModel.numberInputViewModel.size.width = self.view.frame.size.width
        self.viewModel.numberInputViewModel.size.height = self.collectionViewController.collectionView!.frame.size.height / 7

        self.viewModel.emailInputViewModel.size.width = self.view.frame.size.width
        self.viewModel.emailInputViewModel.size.height = self.collectionViewController.collectionView!.frame.size.height / 7
        
        self.footerPanelController.view.frame.origin.y = self.view.frame.size.height - self.viewModel.footerPanelViewModel.size.height
        
        self.footerPanelController.viewModel = self.viewModel.footerPanelViewModel
        
        self.collectionViewController.collectionView!.reloadData()
    }
    
    override func bind()
    {
        super.bind()
        
        self.footerPanelController.bind()
        
        self.collectionViewController.collectionView!.register(LabelController.CollectionCell.self,
                                                               forCellWithReuseIdentifier: LabelViewModel.description())
        self.collectionViewController.collectionView!.register(TextFieldInputController.CollectionCell.self,
                                                               forCellWithReuseIdentifier:  TextFieldInputViewModel.description())
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var size = CGSize.zero
        
        if (indexPath.item == 0 || indexPath.item == 1 || indexPath.item == 3 || indexPath.item == 5)
        {
            let labelController = LabelController()
            labelController.bind()
            labelController.viewModel = self.viewModel.headerLabelViewModel
            size = labelController.view.frame.size
            labelController.unbind()
        }
        else
        {
            let textFieldInputController = TextFieldInputController()
            textFieldInputController.bind()
            textFieldInputController.viewModel = self.viewModel.nameInputViewModel
            size = textFieldInputController.view.frame.size
            textFieldInputController.unbind()
        }
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell : UICollectionViewCell! = nil
        
        if (indexPath.item == 0 || indexPath.item == 1 || indexPath.item == 3 || indexPath.item == 5)
        {
            let labelControllerCell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: LabelViewModel.description(), for: indexPath) as! LabelController.CollectionCell
            
            if (indexPath.item == 0)
            {
                labelControllerCell.labelController.viewModel = self.viewModel.headerLabelViewModel
                labelControllerCell.labelController.view.backgroundColor = UIColor.red
                
                cell = labelControllerCell
            }
            else if (indexPath.item == 1)
            {
                labelControllerCell.labelController.viewModel = self.viewModel.nameLabelViewModel
                
                cell = labelControllerCell
            }
            else if (indexPath.item == 3)
            {
                labelControllerCell.labelController.viewModel = self.viewModel.numberLabelViewModel
                
                cell = labelControllerCell
            }
            else
            {
                labelControllerCell.labelController.viewModel = self.viewModel.emailLabelViewModel
                
                cell = labelControllerCell
            }
        }
        else if (indexPath.item == 2 || indexPath.item == 4 || indexPath.item == 6)
        {
            let textFieldInputControllerCell = self.collectionViewController.collectionView!.dequeueReusableCell(withReuseIdentifier: TextFieldInputViewModel.description(), for: indexPath) as! TextFieldInputController.CollectionCell
            
            if (indexPath.item == 2)
            {
                textFieldInputControllerCell.textFieldInputController.viewModel = self.viewModel.nameInputViewModel
                self._textFieldInputControllers[self.viewModel.nameInputViewModel] = textFieldInputControllerCell.textFieldInputController
                
                cell = textFieldInputControllerCell
            }
            else if (indexPath.item == 4)
            {
                textFieldInputControllerCell.textFieldInputController.viewModel = self.viewModel.numberInputViewModel
                textFieldInputControllerCell.textFieldInputController.textField.keyboardType = .numberPad
                self._textFieldInputControllers[self.viewModel.numberInputViewModel] = textFieldInputControllerCell.textFieldInputController
                
                cell = textFieldInputControllerCell
            }
            else
            {
                textFieldInputControllerCell.textFieldInputController.viewModel = self.viewModel.emailInputViewModel
                textFieldInputControllerCell.textFieldInputController.textField.keyboardType = .emailAddress
                self._textFieldInputControllers[self.viewModel.emailInputViewModel] = textFieldInputControllerCell.textFieldInputController
                
                cell = textFieldInputControllerCell
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let selectedCell = indexPath.item

        if (selectedCell == indexPath.item)
        {
            for textFieldInputController in self._textFieldInputControllers.values
            {
                textFieldInputController.textField.resignFirstResponder()
            }
        }
    }
    
    override var viewModelEventKeyPaths: Set<String>
    {
        get
        {
            var viewModelEventKeyPaths = super.viewModelEventKeyPaths
            viewModelEventKeyPaths = viewModelEventKeyPaths.union(Set<String>([DynamicKVO.keyPath(\ContactFormController.viewModel.footerPanelViewModel.event)]))
            
            return viewModelEventKeyPaths
        }
    }
    
    override func observeViewModel(for viewModelEvent: DynamicViewModel.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\ContactFormController.viewModel.footerPanelViewModel.event))
        {
            if (self.viewModel.footerPanelViewModel.state == FooterPanelViewModel.State.right)
            {
                self.viewModel.create()
            }
        }
    }
    
    override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\ContactFormController.viewModel))
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
        if (event.newState == ContactFormViewModel.State.completion)
        {
            var contactInfoModels = [ContactInfoModel]()
            
            let contactInfoNumberModel = ContactInfoModel(type: "PhoneNumber",
                                                        label: "",
                                                        display: self.viewModel.numberInputViewModel.value)
            contactInfoModels.append(contactInfoNumberModel)
            
            let contactInfoEmailModel = ContactInfoModel(type: "Email",
                                                         label: "",
                                                         display: self.viewModel.emailInputViewModel.value)
            contactInfoModels.append(contactInfoEmailModel)
            
            let contactModel = ContactModel(name: self.viewModel.nameInputViewModel.value,
                                            contactInfoModels: contactInfoModels)
        }
    }
}
