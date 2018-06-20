//
//  DropFormDetailController .swift
//  Cataract
//
//  Created by Rose Choi on 6/16/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DropFormDetailController : DynamicController<DropFormDetailViewModel>, DynamicViewModelDelegate
{
    private var _pageFormView : UIPageFormView!
    private var _dropFormInputController : DropFormInputController!
    private var _datePickerController : DatePickerController!
    private var _intervalController : DatePickerController!
    private var _weekDayOverviewController : WeekDayOverviewController!
    private var _footerPanelController : FooterPanelController!
    private var _weekDayStore : WeekDayStore!
        
    var pageFormView : UIPageFormView
    {
        get
        {
            if (self._pageFormView == nil)
            {
                self._pageFormView = UIPageFormView()
                self._pageFormView.setView(self.dropFormInputController.view,
                                           direction: UIPageFormViewNavigationDirection.forward,
                                           animated: false)
            }
            
            let pageFormView = self._pageFormView!
            
            return pageFormView
        }
    }
    
    var dropFormInputController : DropFormInputController
    {
        get
        {
            if (self._dropFormInputController == nil)
            {
                self._dropFormInputController = DropFormInputController()
            }
            
            let dropFormInputController = self._dropFormInputController!
            
            return dropFormInputController
        }
    }
    
    var datePickerController : DatePickerController
    {
        get
        {
            if (self._datePickerController == nil)
            {
                self._datePickerController = DatePickerController()
            }
            
            let datePickerController = self._datePickerController!
            
            return datePickerController
        }
    }
    
    var intervalController : DatePickerController
    {
        get
        {
            if (self._intervalController == nil)
            {
                self._intervalController = DatePickerController()
            }
            
            let intervalController = self._intervalController!
            
            return intervalController
        }
    }
    
    var weekDayOverviewController : WeekDayOverviewController
    {
        get
        {
            if (self._weekDayOverviewController == nil)
            {
                self._weekDayOverviewController = WeekDayOverviewController()
            }
            
            let weekDayOverviewController = self._weekDayOverviewController!
            
            return weekDayOverviewController
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
    
    var dropFormInputControllerSize : CGSize
    {
        get
        {
            var dropFormInputControllerSize = CGSize.zero
            dropFormInputControllerSize.width = self.pageFormView.frame.size.width
            dropFormInputControllerSize.height = self.pageFormView.frame.size.height - self.footerPanelControllerSize.height
            
            return dropFormInputControllerSize
        }
    }
    
    var datePickerControllerSize : CGSize
    {
        get
        {
            var datePickerControllerSize = CGSize.zero
            datePickerControllerSize.width = self.pageFormView.frame.size.width
            datePickerControllerSize.height = self.pageFormView.frame.size.height - self.footerPanelControllerSize.height
            
            return datePickerControllerSize
        }
        
    }
    
    var intervalControllerSize : CGSize
    {
        get
        {
            var intervalControllerSize = CGSize.zero
            intervalControllerSize.width = self.pageFormView.frame.size.width
            intervalControllerSize.height = self.pageFormView.frame.size.height - self.footerPanelControllerSize.height
            
            return intervalControllerSize
        }
    }
    
    var weekDayOverviewViewControllerSize : CGSize
    {
        get
        {
            var weekDayOverviewViewControllerSize = CGSize.zero
            weekDayOverviewViewControllerSize.width = self.pageFormView.frame.size.width
            weekDayOverviewViewControllerSize.height = self.pageFormView.frame.size.height - self.footerPanelControllerSize.height
            
            return weekDayOverviewViewControllerSize
        }
    }

    
    var footerPanelControllerSize : CGSize
    {
        get
        {
            var footerPanelControllerSize = CGSize.zero
            footerPanelControllerSize.width = self.view.frame.width
            footerPanelControllerSize.height = self.canvas.draw(tiles: 3)
            
            return footerPanelControllerSize
        }
    }

    var weekDayStore : WeekDayStore
    {
        get
        {
            if (self._weekDayStore == nil)
            {
                self._weekDayStore = WeekDayStore()
            }
            
            let weekDayStore = self._weekDayStore!
            
            return weekDayStore
        }
        
    }
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.pageFormView)
        self.view.addSubview(self.footerPanelController.view)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.pageFormView.frame.size = self.view.frame.size
        
        self.footerPanelController.render(size: self.footerPanelControllerSize)
        self.footerPanelController.view.frame.origin.y = self.canvas.gridSize.height - self.footerPanelController.view.frame.size.height
        
        self.dropFormInputController.render(size: self.dropFormInputControllerSize)
        self.datePickerController.render(size: self.datePickerControllerSize)
        self.intervalController.render(size: self.intervalControllerSize)
        self.weekDayOverviewController.render(size: self.weekDayOverviewViewControllerSize)
    }
    
    override func bind(viewModel: DropFormDetailViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.viewModel.delegate = self
        
        self.footerPanelController.bind(viewModel: self.viewModel.footerPanelViewModel)
        self.dropFormInputController.bind(viewModel: self.viewModel.dropFormInputViewModel)
        self.datePickerController.bind(viewModel: self.viewModel.datePickerViewModel)
        self.intervalController.bind(viewModel: self.viewModel.intervalViewModel)
        self.weekDayOverviewController.bind(viewModel: self.viewModel.weekDayOverviewViewModel)
        
        NotificationCenter.default.addObserver(self.viewModel.dropFormInputViewModel.inputViewModel,
                                               selector: #selector(self.viewModel.dropFormInputViewModel.inputViewModel.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        self.weekDayStore.addObserver(self,
                                      forKeyPath: "models",
                                      options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                           NSKeyValueObservingOptions.initial]),
                                        context: nil)
        
        self.viewModel.dropFormInputViewModel.inputViewModel.addObserver(self,
                                                                         forKeyPath: "event",
                                                                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                                        NSKeyValueObservingOptions.initial]),
                                                                         context: nil)
        
        self.viewModel.dropFormInputViewModel.iconOverviewViewModel.addObserver(self,
                                                                                forKeyPath: "event",
                                                                                options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                                                     NSKeyValueObservingOptions.initial]),
                                                                                context: nil)
        
        self.viewModel.footerPanelViewModel.addObserver(self,
                                                        forKeyPath: "event",
                                                        options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                             NSKeyValueObservingOptions.initial]),
                                                        context: nil)
    }
    
    override func unbind()
    {
        self.viewModel.delegate = nil
        
        self.footerPanelController.unbind()
        self.dropFormInputController.unbind()
        self.datePickerController.unbind()
        self.intervalController.unbind()
        self.weekDayOverviewController.unbind()
        
        self.viewModel.dropFormInputViewModel.inputViewModel.removeObserver(self, forKeyPath: "event")
        self.viewModel.footerPanelViewModel.removeObserver(self, forKeyPath: "event")
        
        super.unbind()
    }
    
    override func shouldInsertKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "models")
        {
            let indexSet = change![NSKeyValueChangeKey.indexesKey] as! IndexSet
            
            if (self.weekDayStore === object as! NSObject)
            {
                self.weekDayOverviewController.viewModel.weekDayViewModels = [WeekDayViewModel]()
                
                for index in indexSet
                {
                    let weekDayModel = self.weekDayStore.retrieve(at: index)
                    let weekDayViewModel = WeekDayViewModel(weekDay: weekDayModel.weekDay, isChecked: weekDayModel.isChecked)
                    
                    self.weekDayOverviewController.viewModel.weekDayViewModels.append(weekDayViewModel)
                }
                
                self.weekDayOverviewController.listView.reloadData()
            }
            
        }
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "event")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            
            if (self.viewModel.dropFormInputViewModel.inputViewModel === object as! NSObject)
            {
                if (newValue == "DidKeyboardWillShow")
                {
                    let keyboardFrame = self.viewModel.dropFormInputViewModel.inputViewModel.keyboardFrame

                    let contentInsets = UIEdgeInsetsMake(0, 0, self.dropFormInputController.listView.convert(keyboardFrame!, from: nil).intersection(self.dropFormInputController.listView.bounds).height, 0)
                    self.dropFormInputController.listView.scrollIndicatorInsets = contentInsets
                    self.dropFormInputController.listView.contentInset = contentInsets
                }
            }
            else if (self.viewModel.dropFormInputViewModel.iconOverviewViewModel === object as! NSObject)
            {
                if (newValue == "DidToggle")
                {
                    self.dropFormInputController.inputController.textfield.resignFirstResponder()
                }
            }
            else if (self.viewModel.footerPanelViewModel === object as! NSObject)
            {
                if (newValue == "DidConfirm")
                {
                    if (self.viewModel.state == "Drop")
                    {
                        self.viewModel.inputDate()
                    }
                    else if (self.viewModel.state == "Date")
                    {
                        self.viewModel.inputInterval()
                    }
                    else if (self.viewModel.state == "Interval")
                    {
                        self.viewModel.inputWeekDay()
                    }
                }
                else if (newValue == "DidCancel")
                {
                    if (self.viewModel.state == "Date")
                    {
                        self.viewModel.inputDrop()
                    }
                    else if (self.viewModel.state == "Interval")
                    {
                        self.viewModel.inputDate()
                    }
                    else if (self.viewModel.state == "WeekDay")
                    {
                        self.viewModel.inputInterval()
                    }
                }
            }
        }
    }
    
    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (transition == "InputDrop")
        {
            self.pageFormView.setView(self.dropFormInputController.view,
                                      direction: UIPageFormViewNavigationDirection.reverse,
                                      animated: true)
        }
        else if (transition == "InputDate")
        {
            if (oldState == "Drop")
            {
                self.pageFormView.setView(self.datePickerController.view,
                                          direction: UIPageFormViewNavigationDirection.forward,
                                          animated: true)
            }
            else if (oldState == "Interval")
            {
                self.pageFormView.setView(self.datePickerController.view,
                                          direction: UIPageFormViewNavigationDirection.reverse,
                                          animated: true)
            }
        }
        else if (transition == "InputInterval")
        {
            if (oldState == "Date")
            {
                self.pageFormView.setView(self.intervalController.view,
                                          direction: UIPageFormViewNavigationDirection.forward,
                                          animated: true)
            }
            else if (oldState == "WeekDay")
            {
                self.pageFormView.setView(self.intervalController.view,
                                          direction: UIPageFormViewNavigationDirection.reverse,
                                          animated: true)
            }
        }
        else if (transition == "InputWeekDay")
        {
            self.pageFormView.setView(self.weekDayOverviewController.view,
                                      direction: UIPageFormViewNavigationDirection.forward, animated: true)
        }
    }
}
