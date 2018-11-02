//
//  AppointmentFormController.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class AppointmentFormController : DynamicController, DynamicViewModelDelegate
{
    private var _pageViewController : UIPageViewController!
    private var _footerPanelController : FooterPanelController!
    private var _firstPageController : AppointmentFormController.FirstPageController!
    private var _secondPageController : AppointmentFormController.SecondPageController!
    private var _appointmentInputController : UserController.AppointmentInputController!
    @objc dynamic var viewModel : AppointmentFormViewModel!
    
    var pageViewController : UIPageViewController
    {
        get
        {
            if (self._pageViewController == nil)
            {
                self._pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                                navigationOrientation: .horizontal,
                                                                options: nil)
                self._pageViewController.setViewControllers([self.firstPageController.collectionViewController],
                                                            direction: UIPageViewControllerNavigationDirection.forward,
                                                            animated: true,
                                                            completion: nil)
            }
            
            let pageViewController = self._pageViewController!
            
            return pageViewController
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
    
    var firstPageController : AppointmentFormController.FirstPageController
    {
        get
        {
            if (self._firstPageController == nil)
            {
                self._firstPageController = FirstPageController()
            }
            
            let firstPageController = self._firstPageController!
            
            return firstPageController
        }
    }
    
    var secondPageController : AppointmentFormController.SecondPageController
    {
        get
        {
            if (self._secondPageController == nil)
            {
                self._secondPageController = SecondPageController()
            }
            
            let secondPageController = self._secondPageController!
            
            return secondPageController
        }
    }
    
    var appointmentInputController : UserController.AppointmentInputController
    {
        get
        {
            if (self._appointmentInputController == nil)
            {
                self._appointmentInputController = UserController.AppointmentInputController()
            }
            
            let appointmentInputController = self._appointmentInputController!
            
            return appointmentInputController
        }
    }

    override func viewDidLoad()
    {
        self.view.addSubview(self.footerPanelController.view)
        self.view.addSubview(self.pageViewController.view)
    }
    
    override func bind()
    {
        super.bind()
        
        self.footerPanelController.bind()
        self.firstPageController.bind()
        self.secondPageController.bind()
        self.appointmentInputController.bind()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self._keyBoardDidShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardDidShow,
                                               object: nil)
    }
    
    @objc private func _keyBoardDidShow(notification: Notification)
    {
        if (self.viewModel != nil)
        {
            self.appointmentInputController.collectionViewController.collectionView?.scrollToItem(at: IndexPath(item: 2, section: 0),
                                                                                                  at: .bottom,
                                                                                                  animated: true)
        }
    }

    override func render()
    {
        super.render()
        
        self.view.frame.size = self.viewModel.size
        
        self.viewModel.footerPanelViewModel.size.width = self.view.frame.size.width
        self.viewModel.footerPanelViewModel.size.height = 90
        
        self.pageViewController.view.frame.size.width = self.view.frame.size.width
        self.pageViewController.view.frame.size.height = self.view.frame.size.height - self.viewModel.footerPanelViewModel.size.height - 20
        
        self.viewModel.firstPageViewModel.selectLabelViewModel.size.width = self.view.frame.size.width
        self.viewModel.firstPageViewModel.selectLabelViewModel.size.height = 50
        
        for appointmentFormLabelViewModel in self.viewModel.firstPageViewModel.appointmentFormLabelViewModels
        {
            appointmentFormLabelViewModel.size.width = self.pageViewController.view.frame.size.width - 10
            appointmentFormLabelViewModel.size.height = 75
        }

        self.viewModel.firstPageViewModel.addLabelViewModel.size.width = self.pageViewController.view.frame.size.width - 100
        self.viewModel.firstPageViewModel.addLabelViewModel.size.height = 100
        
        self.viewModel.firstPageViewModel.addButtonViewModel.size.width = 75
        self.viewModel.firstPageViewModel.addButtonViewModel.size.height = 75
        
        self.viewModel.secondPageViewModel.labelViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.secondPageViewModel.labelViewModel.size.height = 100
        
        self.viewModel.secondPageViewModel.datePickerInputViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.secondPageViewModel.datePickerInputViewModel.size.height = self.pageViewController.view.frame.size.height - self.viewModel.secondPageViewModel.labelViewModel.size.height
        
        self.viewModel.appointmentInputViewModel.buttonViewModel.size.width = self.view.frame.size.width
        self.viewModel.appointmentInputViewModel.buttonViewModel.size.height = 100
        
        self.viewModel.appointmentInputViewModel.size = self.view.frame.size
        
        self.appointmentInputController.buttonCell.buttonController.viewModel = self.viewModel.appointmentInputViewModel.buttonViewModel
        
        self.footerPanelController.view.frame.origin.y = self.view.frame.size.height - self.viewModel.footerPanelViewModel.size.height
        
        self.footerPanelController.viewModel = self.viewModel.footerPanelViewModel
        self.firstPageController.viewModel = self.viewModel.firstPageViewModel
        self.secondPageController.viewModel = self.viewModel.secondPageViewModel
        self.appointmentInputController.viewModel = self.viewModel.appointmentInputViewModel
    }
    
    override var viewModelEventKeyPaths: Set<String>
    {
        get
        {
            var viewModelEventKeyPaths = super.viewModelEventKeyPaths
            viewModelEventKeyPaths = viewModelEventKeyPaths.union(Set<String>([DynamicKVO.keyPath(\AppointmentFormController.viewModel.footerPanelViewModel.event),
                                                      DynamicKVO.keyPath(\AppointmentFormController.viewModel.firstPageViewModel.addButtonViewModel.event)]))
            
            return viewModelEventKeyPaths
        }
    }
    
    override func observeViewModel(for viewModelEvent: DynamicViewModel.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\AppointmentFormController.viewModel.footerPanelViewModel.event))
        {
            if (self.viewModel.footerPanelViewModel.state == FooterPanelViewModel.State.right)
            {
                if (self.viewModel.state == AppointmentFormViewModel.State.appointment)
                {
                    self.viewModel.inputDate()
                }
                else if (self.viewModel.state == AppointmentFormViewModel.State.date)
                {
                    self.viewModel.create()
                }
            }
            else if (self.viewModel.footerPanelViewModel.state == FooterPanelViewModel.State.left)
            {
                if (self.viewModel.state == AppointmentFormViewModel.State.date)
                {
                    self.viewModel.inputAppointment()
                }
            }
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\AppointmentFormController.viewModel.firstPageViewModel.addButtonViewModel.event))
        {
            if (self.viewModel.firstPageViewModel.addButtonViewModel.state == UserViewModel.AddButtonViewModel.State.computation)
            {
                self.viewModel.appointmentInputViewModel.edit()
                                
                self.appointmentInputController.collectionViewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                self.present(self.appointmentInputController.collectionViewController,
                             animated: true,
                             completion: nil)
            }
        }
    }
    
    override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\AppointmentFormController.viewModel))
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
        if (event.newState == AppointmentFormViewModel.State.date)
        {
            self.pageViewController.setViewControllers([self.secondPageController.collectionViewController],
                                                       direction: .forward,
                                                       animated: true,
                                                       completion: nil)
        }
        else if (event.newState == AppointmentFormViewModel.State.appointment)
        {
            self.pageViewController.setViewControllers([self.firstPageController.collectionViewController],
                                                       direction: .reverse,
                                                       animated: true,
                                                       completion: nil)
        }
    }
    
    class FirstPageController : DynamicController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    {
        private var _collectionViewController : UICollectionViewController!
        private var _collectionViewFlowLayout : UICollectionViewFlowLayout!
        private var _appointmentFormLabelController : UserController.AppointmentFormLabelController!
        @objc dynamic var viewModel : AppointmentFormViewModel.FirstPageViewModel!
        
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
                }
                
                let collectionViewFlowLayout = self._collectionViewFlowLayout!
                
                return collectionViewFlowLayout
            }
        }
        
        var appointmentFormLabelController : UserController.AppointmentFormLabelController
        {
            get
            {
                if (self._appointmentFormLabelController == nil)
                {
                    self._appointmentFormLabelController = UserController.AppointmentFormLabelController()
                }
                
                let appointmentFormLabelController = self._appointmentFormLabelController!
                
                return appointmentFormLabelController
            }
        }
        
        override func viewDidLoad()
        {
            self.collectionViewController.collectionView?.backgroundColor = UIColor.white
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
            self.collectionViewController.collectionView?.register(UserController.AppointmentFormLabelController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: UserViewModel.AppointmentFormLabelViewModel.description())
            self.collectionViewController.collectionView?.register(UserController.AddButtonController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: UserViewModel.AddButtonViewModel.description())
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int
        {
            return 3
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            var numberOfItemsInSection = 0
            
            if (self.viewModel != nil)
            {
                if (section == 0)
                {
                    numberOfItemsInSection = 1
                }
                else if (section == 1)
                {
                    numberOfItemsInSection = self.viewModel.appointmentFormLabelViewModels.count
                }
                else
                {
                    numberOfItemsInSection = 2
                }
                
                return numberOfItemsInSection
            }
            else
            {
                return 0
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            var size = CGSize.zero
            
            if (indexPath.section == 0)
            {
                let labelController = LabelController()
                labelController.bind()
                labelController.viewModel = self.viewModel.selectLabelViewModel
                size = labelController.view.frame.size
                labelController.unbind()
            }
            else if (indexPath.section == 1)
            {
                let index = indexPath.item
                let appointmentLabelFormViewModel = self.viewModel.appointmentFormLabelViewModels[index]
                
                let appointmentLabelFormController = UserController.AppointmentFormLabelController()
                appointmentLabelFormController.bind()
                appointmentLabelFormController.viewModel = appointmentLabelFormViewModel
                size.width = appointmentLabelFormController.view.frame.size.width + 10
                size.height = appointmentLabelFormController.view.frame.size.height
                appointmentLabelFormController.unbind()
            }
            else
            {
                if (indexPath.item == 0)
                {
                    let labelController = LabelController()
                    labelController.bind()
                    labelController.viewModel = self.viewModel.addLabelViewModel
                    size = labelController.view.frame.size
                    labelController.unbind()
                }
                else
                {
                    let addButtonController = UserController.AddButtonController()
                    addButtonController.bind()
                    addButtonController.viewModel = self.viewModel.addButtonViewModel
                    size = addButtonController.view.frame.size
                    addButtonController.unbind()
                }
            }

            return size
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            var cell = UICollectionViewCell()
            
            if (indexPath.section == 0)
            {
                let labelControllerCell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: LabelViewModel.description(),
                                                                                                            for: indexPath) as! LabelController.CollectionCell
                
                labelControllerCell.labelController.viewModel = self.viewModel.selectLabelViewModel
                
                cell = labelControllerCell
            }
            else if (indexPath.section == 1)
            {
                let index = indexPath.item
                let appointmentLabelViewModel = self.viewModel.appointmentFormLabelViewModels[index]
                let appointmentCell = self._collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: UserViewModel.AppointmentFormLabelViewModel.description(),
                                                                                   for: indexPath) as! UserController.AppointmentFormLabelController.CollectionCell
                appointmentCell.appointmentLabelController.viewModel = appointmentLabelViewModel
                appointmentCell.appointmentLabelController.labelController.view.frame.origin.x = 5
                
                cell = appointmentCell
            }
            else if (indexPath.section == 2)
            {
                if (indexPath.item == 0)
                {
                    let labelControllerCell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: LabelViewModel.description(),
                                                                                                                for: indexPath) as! LabelController.CollectionCell
                    labelControllerCell.labelController.viewModel = self.viewModel.addLabelViewModel
                    
                    cell = labelControllerCell
                }
                else
                {
                    let addButtonControllerCell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: UserViewModel.AddButtonViewModel.description(),
                                                                                                                    for: indexPath) as! UserController.AddButtonController.CollectionCell
                    addButtonControllerCell.addButtonController.viewModel = self.viewModel.addButtonViewModel
                    cell = addButtonControllerCell
                }

            }

            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
        {
            let selectedItem = indexPath.item
                        
            self.viewModel.toggle(at: selectedItem)
        }
    }
    
    class SecondPageController : DynamicController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    {
        private var _collectionViewController : UICollectionViewController!
        private var _collectionViewFlowLayout : UICollectionViewFlowLayout!
        @objc dynamic var viewModel : AppointmentFormViewModel.SecondPageViewModel!
        
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
                }
                
                let collectionViewFlowLayout = self._collectionViewFlowLayout!
                
                return collectionViewFlowLayout
            }
        }
        
        override func viewDidLoad()
        {
            self.collectionViewController.collectionView?.backgroundColor = UIColor.white
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
            self.collectionViewController.collectionView?.register(DatePickerInputController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: DatePickerInputViewModel.description())
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int
        {
            return 2
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            var numberOfItemsInSection = 0
            
            if (self.viewModel != nil)
            {
                numberOfItemsInSection = 1
            }
            else
            {
                numberOfItemsInSection = 0
            }
            
            return numberOfItemsInSection
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            var size = CGSize.zero
            
            if (indexPath.section == 0)
            {
                let labelController = LabelController()
                labelController.bind()
                labelController.viewModel = self.viewModel.labelViewModel
                size = labelController.view.frame.size
                labelController.unbind()
            }
            else
            {
                let datePickerInputController = DatePickerInputController()
                datePickerInputController.bind()
                datePickerInputController.viewModel = self.viewModel.datePickerInputViewModel
                size = datePickerInputController.view.frame.size
                datePickerInputController.unbind()
            }
            
            return size
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            var cell = UICollectionViewCell()
            
            if (indexPath.section == 0)
            {
                let labelControllerCell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: LabelViewModel.description(),
                                                                                                            for: indexPath) as! LabelController.CollectionCell
                labelControllerCell.labelController.viewModel = self.viewModel.labelViewModel
                
                cell = labelControllerCell
            }
            else
            {
                let datePickerInputControllerCell = self.collectionViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: DatePickerInputViewModel.description(),
                                                                                                                      for: indexPath) as! DatePickerInputController.CollectionCell
                datePickerInputControllerCell.datePickerInputController.viewModel = self.viewModel.datePickerInputViewModel
                
                cell = datePickerInputControllerCell
            }
            
            return cell
        }
    }
}
