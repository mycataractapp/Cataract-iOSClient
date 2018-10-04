//
//  DropFormController.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class DropFormController : DynamicController, DynamicViewModelDelegate
{
    private var _pageViewController : UIPageViewController!
    private var _firstPageController : DropFormController.FirstPageController!
    private var _secondPageController : DropFormController.SecondPageController!
    private var _thirdPageController : DropFormController.ThirdPageController!
    private var _footerPanelController : FooterPanelController!
    @objc dynamic var viewModel : DropFormViewModel!
    
    var pageViewController : UIPageViewController
    {
        get
        {
            if (self._pageViewController == nil)
            {
                self._pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll,
                                                                navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal,
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
    
    var firstPageController : DropFormController.FirstPageController
    {
        get
        {
            if (self._firstPageController == nil)
            {
                self._firstPageController = DropFormController.FirstPageController()
            }
            
            let firstPageController = self._firstPageController!
            
            return firstPageController
        }
    }
    
    var secondPageController : DropFormController.SecondPageController
    {
        get
        {
            if (self._secondPageController == nil)
            {
                self._secondPageController = DropFormController.SecondPageController()
            }
            
            let secondPageController = self._secondPageController!
            
            return secondPageController
        }
    }
    
    var thirdPageController : DropFormController.ThirdPageController
    {
        get
        {
            if (self._thirdPageController == nil)
            {
                self._thirdPageController = DropFormController.ThirdPageController()
            }

            let thirdPageController = self._thirdPageController!

            return thirdPageController
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
        self.view.addSubview(self.pageViewController.view)
        self.view.addSubview(self.footerPanelController.view)
    }
    
    override func bind()
    {
        super.bind()
        
        self.firstPageController.bind()
        self.secondPageController.bind()
        self.thirdPageController.bind()
        self.footerPanelController.bind()
    }
    
    override func render()
    {
        super.render()
        
        self.view.frame.size = self.viewModel.size
        
        self.viewModel.footerPanelViewModel.size.width = self.view.frame.size.width
        self.viewModel.footerPanelViewModel.size.height = 90
        
        self.pageViewController.view.frame.size.height = self.view.frame.size.height - self.viewModel.footerPanelViewModel.size.height - 20
        
        self.viewModel.firstPageViewModel.nameLabelViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.firstPageViewModel.nameLabelViewModel.size.height = self.pageViewController.view.frame.size.height / 5

        self.viewModel.firstPageViewModel.colorLabelViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.firstPageViewModel.colorLabelViewModel.size.height = self.pageViewController.view.frame.size.height / 5
        
        self.viewModel.firstPageViewModel.textFieldInputViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.firstPageViewModel.textFieldInputViewModel.size.height = self.pageViewController.view.frame.size.height / 5
        
        for colorCardviewModel in self.viewModel.firstPageViewModel.colorCardViewModels
        {
            colorCardviewModel.size.width = self.pageViewController.view.frame.size.width / 4
            colorCardviewModel.size.height = self.pageViewController.view.frame.size.height / 5
        }
        
        self.viewModel.secondPageViewModel.startDateLabelViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.secondPageViewModel.startDateLabelViewModel.size.height = self.pageViewController.view.frame.size.height / 4
        
        self.viewModel.secondPageViewModel.endDateLabelViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.secondPageViewModel.endDateLabelViewModel.size.height = self.pageViewController.view.frame.size.height / 4
        
        self.viewModel.secondPageViewModel.startDatePickerInputViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.secondPageViewModel.startDatePickerInputViewModel.size.height = self.pageViewController.view.frame.size.height / 4
        
        self.viewModel.secondPageViewModel.endDatePickerInputViewModel.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.secondPageViewModel.endDatePickerInputViewModel.size.height = self.pageViewController.view.frame.size.height / 4
        
        self.viewModel.thirdPageViewModel.controlCardStartTime.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.thirdPageViewModel.controlCardStartTime.size.height = self.pageViewController.view.frame.size.height / 3

        self.viewModel.thirdPageViewModel.controlCardInterval.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.thirdPageViewModel.controlCardInterval.size.height = self.pageViewController.view.frame.size.height / 3

        self.viewModel.thirdPageViewModel.controlCardTimesPerDay.size.width = self.pageViewController.view.frame.size.width
        self.viewModel.thirdPageViewModel.controlCardTimesPerDay.size.height  = self.pageViewController.view.frame.size.height / 3
        
        self.footerPanelController.view.frame.origin.y = self.view.frame.size.height - self.viewModel.footerPanelViewModel.size.height
        
        self.footerPanelController.viewModel = self.viewModel.footerPanelViewModel
        self.firstPageController.viewModel = self.viewModel.firstPageViewModel
        self.secondPageController.viewModel = self.viewModel.secondPageViewModel
        self.thirdPageController.viewModel = self.viewModel.thirdPageViewModel
    }
    
    override var viewModelEventKeyPaths: Set<String>
    {
        get
        {
            var viewModelEventKeyPaths = super.viewModelEventKeyPaths
            viewModelEventKeyPaths = viewModelEventKeyPaths.union(Set<String>([DynamicKVO.keyPath(\DropFormController.viewModel.footerPanelViewModel.event)]))
            
            return viewModelEventKeyPaths
        }
    }
    
    override func observeViewModel(for viewModelEvent: DynamicViewModel.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel.footerPanelViewModel.event))
        {
            if (self.viewModel.footerPanelViewModel.state == FooterPanelViewModel.State.left)
            {
                if (self.viewModel.state == DropFormViewModel.State.date)
                {
                    self.viewModel.inputDrop()
                }
                else if (self.viewModel.state == DropFormViewModel.State.schedule)
                {
                    self.viewModel.inputDate()
                }
            }
            else if (self.viewModel.footerPanelViewModel.state == FooterPanelViewModel.State.right)
            {
                if (self.viewModel.state == DropFormViewModel.State.drop)
                {
                    self.viewModel.inputDate()
                }
                else if (self.viewModel.state == DropFormViewModel.State.date)
                {
                    self.viewModel.setSchedule()
                }
            }
        }
    }
    
    override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropFormController.viewModel))
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
        if (event.newState == DropFormViewModel.State.drop)
        {
            self.pageViewController.setViewControllers([self.firstPageController.collectionViewController],
                                                       direction: UIPageViewControllerNavigationDirection.reverse,
                                                       animated: true,
                                                       completion: nil)
        }
        else if (event.newState == DropFormViewModel.State.date)
        {
            if (event.oldState == DropFormViewModel.State.drop)
            {
                self.pageViewController.setViewControllers([self.secondPageController.collectionViewController],
                                                           direction: UIPageViewControllerNavigationDirection.forward,
                                                           animated: true,
                                                           completion: nil)
            }
            else if (event.oldState == DropFormViewModel.State.schedule)
            {
                self.pageViewController.setViewControllers([self.secondPageController.collectionViewController],
                                                           direction: UIPageViewControllerNavigationDirection.reverse,
                                                           animated: true,
                                                           completion: nil)
            }
        }
        else
        {
            if (event.oldState == DropFormViewModel.State.date)
            {
                self.pageViewController.setViewControllers([self.thirdPageController.collectionViewController],
                                                           direction: UIPageViewControllerNavigationDirection.forward,
                                                           animated: true,
                                                           completion: nil)
            }
        }
    }
    
    class FirstPageController : DynamicController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    {
        private var _collectionViewController : UICollectionViewController!
        private var _collectionViewFlowLayout : UICollectionViewFlowLayout!
        private var _labelControllerByViewModel = [LabelViewModel:LabelController]()
        private var _textFieldInputControllers = [TextFieldInputViewModel:TextFieldInputController]()
        private var _colorCardControllers = [ColorCardViewModel:ColorCardController]()
        @objc dynamic var viewModel : DropFormViewModel.FirstPageViewModel!
        
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
        
        override func bind()
        {
            super.bind()
            
            self.collectionViewController.collectionView!.register(LabelController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: LabelViewModel.description())
            self.collectionViewController.collectionView!.register(TextFieldInputController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: TextFieldInputViewModel.description())
            self.collectionViewController.collectionView!.register(ColorCardController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: ColorCardViewModel.description())
        }
        
        override func unbind()
        {
            super.unbind()

            for labelController in self._labelControllerByViewModel.values
            {
                labelController.unbind()
            }
        }
        
        override func render()
        {
            super.render()
            
            self.collectionViewController.collectionView!.reloadData()
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            if (self.viewModel != nil)
            {
                return self.viewModel.colorCardViewModels.count + 3
            }
            else
            {
                return 0
            }
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            var size = CGSize.zero

            if (indexPath.item == 0 || indexPath.item == 2)
            {
                let labelController = LabelController()
                labelController.bind()
                labelController.viewModel = self.viewModel.nameLabelViewModel
                size = labelController.view.frame.size
                labelController.unbind()
            }
            else if (indexPath.item == 1)
            {
                let textFieldInputController = TextFieldInputController()
                textFieldInputController.bind()
                textFieldInputController.viewModel = self.viewModel.textFieldInputViewModel
                size = textFieldInputController.view.frame.size
                textFieldInputController.unbind()
            }
            else if (indexPath.item >= 3)
            {
                let colorCardController = ColorCardController()
                colorCardController.bind()
                let index = indexPath.item - 3
                colorCardController.viewModel = self.viewModel.colorCardViewModels[index]
                size = colorCardController.view.frame.size
                colorCardController.unbind()
            }

            return size
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            var cell : UICollectionViewCell! = nil

            if (indexPath.item == 0 || indexPath.item == 2)
            {
                let labelControllerCell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelViewModel.description(),
                                                                             for: indexPath) as! LabelController.CollectionCell

                if (indexPath.item == 0)
                {
                    labelControllerCell.labelController.viewModel = self.viewModel.nameLabelViewModel

                    self._labelControllerByViewModel[self.viewModel.nameLabelViewModel] = labelControllerCell.labelController
                }
                else
                {
                    labelControllerCell.labelController.viewModel = self.viewModel.colorLabelViewModel

                    self._labelControllerByViewModel[self.viewModel.colorLabelViewModel] = labelControllerCell.labelController
                }

                 cell = labelControllerCell
            }
            else if (indexPath.item == 1)
            {
                let textFieldInputControllerCell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldInputViewModel.description(),
                                                                                      for: indexPath) as! TextFieldInputController.CollectionCell
                textFieldInputControllerCell.textFieldInputController.viewModel = self.viewModel.textFieldInputViewModel
                
                self._textFieldInputControllers[self.viewModel.textFieldInputViewModel] = textFieldInputControllerCell.textFieldInputController
                
                cell = textFieldInputControllerCell
            }
            else
            {
                let index = indexPath.item - 3
                let colorCardViewModel = self.viewModel.colorCardViewModels[index]
                let colorCardControllerCell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCardViewModel.description(),
                                                                                 for: indexPath) as! ColorCardController.CollectionCell
                colorCardControllerCell.colorCardController.viewModel = colorCardViewModel

                self._colorCardControllers[colorCardViewModel] = colorCardControllerCell.colorCardController

                cell = colorCardControllerCell
            }

            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
        {
            let textFieldInputController = self._textFieldInputControllers[self.viewModel.textFieldInputViewModel]
            textFieldInputController?.textField.resignFirstResponder()

            if (indexPath.row >= 3)
            {
                let selectedIndexPath = indexPath.row - 3
                self.viewModel.toggle(at: selectedIndexPath)
            }
//            let labelController = self._labelControllerByViewModel[self.viewModel.nameLabelViewModel]
//            Able to access the controller anywhere in the code.
        }
    }
    
    class SecondPageController : DynamicController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    {
        private var _collectionViewController : UICollectionViewController!
        private var _collectionViewFlowLayout : UICollectionViewFlowLayout!
        private var _secondPageLabelControllerByViewModel = [LabelViewModel:LabelController]()
        private var _datePickerControllerByViewModel = [DatePickerInputViewModel:DatePickerInputController]()
        @objc dynamic var viewModel : DropFormViewModel.SecondPageViewModel!
        
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
        
        override func viewDidLoad()
        {
            self.collectionViewController.collectionView?.backgroundColor = UIColor.white
        }
        
        override func bind()
        {
            super.bind()
            
            self.collectionViewController.collectionView!.register(LabelController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: LabelViewModel.description())
            self.collectionViewController.collectionView!.register(DatePickerInputController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: DatePickerInputViewModel.description())
        }
        
        override func unbind()
        {
            
        }
        
        override func render()
        {
            super.render()
            
            self.collectionViewController.collectionView!.reloadData()
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            if (self.viewModel != nil)
            {
                return 4
            }
            else
            {
                return 0
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            var size = CGSize.zero
            
            if (indexPath.row == 0 || indexPath.row == 2)
            {
                let labelController = LabelController()
                labelController.bind()
                labelController.viewModel = self.viewModel.startDateLabelViewModel
                size = labelController.view.frame.size
                labelController.unbind()
            }
            else if (indexPath.row == 1 || indexPath.row == 3)
            {
                let datePickerInputController = DatePickerInputController()
                datePickerInputController.bind()
                datePickerInputController.viewModel = self.viewModel.startDatePickerInputViewModel
                size = datePickerInputController.view.frame.size
                datePickerInputController.unbind()
            }
            
            return size
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            var cell : UICollectionViewCell! = nil

            if (indexPath.item == 0 || indexPath.item == 2)
            {
                let labelControllerCell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelViewModel.description(),
                                                                             for: indexPath) as! LabelController.CollectionCell
                
                if (indexPath.row == 0)
                {
                    labelControllerCell.labelController.viewModel = self.viewModel.startDateLabelViewModel
                    
                    self._secondPageLabelControllerByViewModel[self.viewModel.startDateLabelViewModel] = labelControllerCell.labelController
                }
                else
                {
                    labelControllerCell.labelController.viewModel = self.viewModel.endDateLabelViewModel
                    
                    self._secondPageLabelControllerByViewModel[self.viewModel.endDateLabelViewModel] = labelControllerCell.labelController
                }
                
                cell = labelControllerCell
            }
            else if (indexPath.row == 1 || indexPath.row == 3)
            {
                let datePickerInputControllerCell = collectionView.dequeueReusableCell(withReuseIdentifier: DatePickerInputViewModel.description(),
                                                                                       for: indexPath) as! DatePickerInputController.CollectionCell
                
                if (indexPath.row == 1)
                {
                    datePickerInputControllerCell.datePickerInputController.viewModel = self.viewModel.startDatePickerInputViewModel
                    
                    self._datePickerControllerByViewModel[self.viewModel.startDatePickerInputViewModel] = datePickerInputControllerCell.datePickerInputController
                }
                else
                {
                    datePickerInputControllerCell.datePickerInputController.viewModel = self.viewModel.endDatePickerInputViewModel
                    
                    self._datePickerControllerByViewModel[self.viewModel.endDatePickerInputViewModel] = datePickerInputControllerCell.datePickerInputController
                }
                
                cell = datePickerInputControllerCell
            }
            
            return cell
        }
    }
    
    class ThirdPageController : DynamicController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    {
        private var _collectionViewController : UICollectionViewController!
        private var _collectionViewFlowLayout : UICollectionViewFlowLayout!
        @objc dynamic var viewModel : DropFormViewModel.ThirdPageViewModel!

        var collectionViewController : UICollectionViewController
        {
            get
            {
                if (self._collectionViewController == nil)
                {
                    self._collectionViewController = UICollectionViewController(collectionViewLayout: self.collectionViewFlowLayout)
                    self._collectionViewController.collectionView?.delegate = self
                    self._collectionViewController.collectionView?.dataSource = self
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
            self.collectionViewController.collectionView?.backgroundColor = UIColor.white
        }

        override func bind()
        {
            super.bind()

            self.collectionViewController.collectionView?.register(UserController.Control.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: UserViewModel.ControlCard.description())
            self.collectionViewController.collectionView?.register(DatePickerInputController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: DatePickerInputViewModel.description())
            self.collectionViewController.collectionView?.register(TextFieldInputController.CollectionCell.self,
                                                                   forCellWithReuseIdentifier: TextFieldInputViewModel.description())
        }

        override func unbind()
        {
            super.unbind()
        }

        override func render()
        {
            super.render()

            self.collectionViewController.collectionView?.reloadData()
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            if (self.viewModel != nil)
            {
                return 3
            }
            else
            {
                return 0
            }
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            var size = CGSize.zero

            if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2)
            {
                let control = UserController.Control()
                control.bind()
                control.viewModel = self.viewModel.controlCardStartTime
                size = control.view.frame.size
                control.unbind()
            }

            return size
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            var cell : UICollectionViewCell! = nil

            if (indexPath.item == 0 || indexPath.item == 1 || indexPath.item == 2)
            {
                let controlCell = collectionView.dequeueReusableCell(withReuseIdentifier: UserViewModel.ControlCard.description(),
                                                                     for: indexPath) as! UserController.Control.CollectionCell

                if (indexPath.row == 0)
                {
                    controlCell.control.viewModel = self.viewModel.controlCardStartTime
                }
                else if (indexPath.row == 1)
                {
                    controlCell.control.viewModel = self.viewModel.controlCardInterval
                }
                else
                {
                    controlCell.control.viewModel = self.viewModel.controlCardTimesPerDay
                }
                
                cell = controlCell
            }

            return cell
        }
    }
}

