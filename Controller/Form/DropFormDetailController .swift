//
//  DropFormDetailController .swift
//  Cataract
//
//  Created by Rose Choi on 6/16/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import SwiftMoment

class DropFormDetailController : DynamicController<DropFormDetailViewModel>, DynamicViewModelDelegate
{
    private var _label : UILabel!
    private var _pageFormView : UIPageFormView!
    private var _dateContainerView : UIView!
    private var _overLayView : UIView!
    private var _dropFormInputController : DropFormInputController!
    private var _startDateController : DatePickerController!
    private var _endDateController : DatePickerController!
    private var _timePickerController : DatePickerController!
    private var _timeIntervalController : DatePickerController!
    private var _inputController : InputController!
    private var _timeOverviewController : TimeOverviewController!
    private var _timeStampOverviewController : TimeStampOverviewController!
    private var _footerPanelController : FooterPanelController!
    
    var label : UILabel
    {
        get
        {
            if (self._label == nil)
            {
                self._label = UILabel()
                self._label.text = ""
                self._label.textColor = UIColor(red: 0/255, green: 0/255, blue: 144/255, alpha: 1)
                self._label.textAlignment = NSTextAlignment.center
            }
            
            let label = self._label!
            
            return label
        }
    }
    
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
    
    var dateContainerView : UIView
    {
        get
        {
            if (self._dateContainerView == nil)
            {
                self._dateContainerView = UIView()
                self.dateContainerView.addSubview(self.startDateController.view)
                self.dateContainerView.addSubview(self.endDateController.view)
            }
            
            let dateContainerView = self._dateContainerView!
            
            return dateContainerView
        }
    }

    
    var overLayView : UIView
    {
        get
        {
            if (self._overLayView == nil)
            {
                self._overLayView = UIView()
                self._overLayView.autoresizesSubviews = false
                self._overLayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//                self._overLayView.addSubview(self.footerPanelController.view)
            }
            
            let overLayView = self._overLayView!
            
            return overLayView
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
    
    var startDateController : DatePickerController
    {
        get
        {
            if (self._startDateController == nil)
            {
                self._startDateController = DatePickerController()
            }
            
            let startDateController = self._startDateController!
            
            return startDateController
        }
    }
    
    var endDateController : DatePickerController
    {
        get
        {
            if (self._endDateController == nil)
            {
                self._endDateController = DatePickerController()
            }
            
            let endDateController = self._endDateController!
            
            return endDateController
        }
    }
    
    var timePickerController : DatePickerController
    {
        get
        {
            if (self._timePickerController == nil)
            {
                self._timePickerController = DatePickerController()
                self._timePickerController.view.backgroundColor = UIColor.white
            }
            
            let timePickerController = self._timePickerController!
            
            return timePickerController
        }
    }
    
    var timeIntervalController : DatePickerController
    {
        get
        {
            if (self._timeIntervalController == nil)
            {
                self._timeIntervalController = DatePickerController()
                self._timeIntervalController.view.backgroundColor = UIColor.white
            }
            
            let timeIntervalController = self._timeIntervalController!
            
            return timeIntervalController
        }
    }
    
    var inputController : InputController
    {
        get
        {
            if (self._inputController == nil)
            {
                self._inputController = InputController()
                self._inputController.view.backgroundColor = UIColor.white
            }
            
            let inputController = self._inputController!
            
            return inputController
        }
    }
    
    var timeOverviewController : TimeOverviewController
    {
        get
        {
            if (self._timeOverviewController == nil)
            {
                self._timeOverviewController = TimeOverviewController()
            }
            
            let timeOverviewController = self._timeOverviewController!
            
            return timeOverviewController
        }
    }
    
    var timeStampOverviewController : TimeStampOverviewController
    {
        get
        {
            if (self._timeStampOverviewController == nil)
            {
                self._timeStampOverviewController = TimeStampOverviewController()
                self._timeStampOverviewController.listView.listFooterView = self.timeOverviewController.view
            }
            
            let timeStampOverviewController = self._timeStampOverviewController!
            
            return timeStampOverviewController
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
            dropFormInputControllerSize.height = self.pageFormView.frame.size.height - self.footerPanelController.view.frame.size.height
            
            return dropFormInputControllerSize
        }
    }

    var startDateControllerSize : CGSize
    {
        get
        {
            var startDateControllerSize = CGSize.zero
            startDateControllerSize.width = self.dateContainerView.frame.size.width
            startDateControllerSize.height = self.dateContainerView.frame.size.height / 3
            
            return startDateControllerSize
        }
        
    }
    
    var endDateControllerSize : CGSize
    {
        get
        {
            var endDateControllerSize = CGSize.zero
            endDateControllerSize.width = self.dateContainerView.frame.size.width
            endDateControllerSize.height = self.dateContainerView.frame.size.height / 3
            
            return endDateControllerSize
        }
    }
    
    var timePickerControllerSize : CGSize
    {
        get
        {
            var timePickerControllerSize = CGSize.zero
            timePickerControllerSize.width = self.overLayView.frame.size.width
            timePickerControllerSize.height = self.overLayView.frame.size.height / 4
            
            return timePickerControllerSize
        }
    }
    
    var timeIntervalControllerSize : CGSize
    {
        get
        {
            var timeIntervalControllerSize = CGSize.zero
            timeIntervalControllerSize.width = self.overLayView.frame.size.width
            timeIntervalControllerSize.height = self.overLayView.frame.size.height / 4
            
            return timeIntervalControllerSize
        }
    }
    
    var inputControllerSize : CGSize
    {
        get
        {
            var inputControllerSize = CGSize.zero
            inputControllerSize.width = self.overLayView.frame.size.width
            inputControllerSize.height = self.overLayView.frame.size.height / 4
            
            return inputControllerSize
        }
    }
    
    var timeOverviewControllerSize : CGSize
    {
        get
        {
            var timeOverviewControllerSize = CGSize.zero
            timeOverviewControllerSize.width = self.pageFormView.frame.size.width
            timeOverviewControllerSize.height = self.pageFormView.frame.size.height - self.footerPanelController.view.frame.size.height
            
            return timeOverviewControllerSize
        }
    }
    
    var timeStampOverviewControllerSize : CGSize
    {
        get
        {
            var timeStampOverviewControllerSize = CGSize.zero
            timeStampOverviewControllerSize.width = self.pageFormView.frame.size.width
            timeStampOverviewControllerSize.height = self.pageFormView.frame.size.height - self.footerPanelController.view.frame.size.height
            
            return timeStampOverviewControllerSize
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

    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.pageFormView)
        self.view.addSubview(self.overLayView)
        self.view.addSubview(self.footerPanelController.view)
        self.view.addSubview(self.timePickerController.view)
        self.view.addSubview(self.timeIntervalController.view)
        self.view.addSubview(self.inputController.view)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.pageFormView.frame.size = self.view.frame.size
        
        self.label.font = UIFont.systemFont(ofSize: 24)
        
        self.label.frame.size.width = self.canvas.gridSize.width - self.canvas.draw(tiles: 1)
        self.label.frame.size.height = self.canvas.draw(tiles: 2)
        
        self.footerPanelController.render(size: self.footerPanelControllerSize)
        self.dropFormInputController.render(size: self.dropFormInputControllerSize)
        
        self.dateContainerView.frame.size.width = self.view.frame.size.width
        self.dateContainerView.frame.size.height = self.pageFormView.frame.size.height - self.footerPanelController.view.frame.size.height
        
        self.overLayView.frame.size = self.view.frame.size
        self.overLayView.frame.origin.y = self.view.frame.height
        
        self.startDateController.render(size: self.startDateControllerSize)
        self.endDateController.render(size: self.endDateControllerSize)
        self.timePickerController.render(size: self.timePickerControllerSize)
        self.timeIntervalController.render(size: self.timeIntervalControllerSize)
        self.inputController.render(size: self.inputControllerSize)
        self.timeOverviewController.render(size: self.timeOverviewControllerSize)
        self.timeStampOverviewController.render(size: self.timeStampOverviewControllerSize)
        
        self.footerPanelController.view.frame.origin.y = self.canvas.gridSize.height - self.footerPanelController.view.frame.size.height
        
        self.startDateController.view.frame.origin.y = (self.view.frame.size.height - self.startDateController.view.frame.size.height - self.endDateController.view.frame.size.height - self.canvas.draw(tiles: 2.5)) / 2
        self.endDateController.view.frame.origin.y = self.startDateController.view.frame.origin.y + self.startDateController.view.frame.height + self.canvas.draw(tiles: 0.5)
        
        self.timePickerController.view.frame.origin.y = self.view.frame.height
        self.timeIntervalController.view.frame.origin.y = self.view.frame.height
        self.inputController.view.frame.origin.y = self.view.frame.height
    }
    
    override func bind(viewModel: DropFormDetailViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.viewModel.delegate = self
        self.viewModel.keyboardViewModel.delegate = self
        
        self.footerPanelController.bind(viewModel: self.viewModel.footerPanelViewModel)
        self.dropFormInputController.bind(viewModel: self.viewModel.dropFormInputViewModel)
        self.startDateController.bind(viewModel: self.viewModel.startDateViewModel)
        self.endDateController.bind(viewModel: self.viewModel.endDateViewModel)
        self.timePickerController.bind(viewModel: self.viewModel.timePickerViewModel)
        self.timeIntervalController.bind(viewModel: self.viewModel.timeIntervalViewModel)
        self.inputController.bind(viewModel: self.viewModel.inputViewModel)
        self.timeOverviewController.bind(viewModel: self.viewModel.timeOverviewViewModel)
        self.timeStampOverviewController.bind(viewModel: self.viewModel.timeStampOverviewViewModel)
        
        NotificationCenter.default.addObserver(self.viewModel.keyboardViewModel,
                                               selector: #selector(self.viewModel.keyboardViewModel.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)

//        self.viewModel.dropFormInputViewModel.inputViewModel.addObserver(self,
//                                                                         forKeyPath: "event",
//                                                                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
//                                                                                                        NSKeyValueObservingOptions.initial]),
//                                                                         context: nil)
//        self.viewModel.inputViewModel.addObserver(self,
//                                                  forKeyPath: "event",
//                                                  options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
//                                                                                       NSKeyValueObservingOptions.initial]),
//                                                  context: nil)
        self.viewModel.dropFormInputViewModel.iconOverviewViewModel.addObserver(self,
                                                                                forKeyPath: "event",
                                                                                options:
                                                                                    NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                    NSKeyValueObservingOptions.initial]),
                                                                                context: nil)
        self.viewModel.timePickerViewModel.addObserver(self,
                                                       forKeyPath: "event",
                                                       options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                             NSKeyValueObservingOptions.initial]),
                                                       context: nil)
        
        self.viewModel.timeIntervalViewModel.addObserver(self,
                                                         forKeyPath: "event",
                                                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                              NSKeyValueObservingOptions.initial]),
                                                         context: nil)
        
        for timeStampViewModel in self.timeStampOverviewController.viewModel.timeStampViewModels
        {
           timeStampViewModel.addObserver(self,
                                          forKeyPath: "event",
                                          options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                               NSKeyValueObservingOptions.initial]),
                                          context: nil)
        }
        
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
        self.startDateController.unbind()
        self.endDateController.unbind()
        self.timePickerController.unbind()
        self.timeIntervalController.unbind()
        self.inputController.unbind()
        self.timeOverviewController.unbind()
        self.timeStampOverviewController.unbind()
        
        self.viewModel.dropFormInputViewModel.inputViewModel.removeObserver(self, forKeyPath: "event")
        self.viewModel.footerPanelViewModel.removeObserver(self, forKeyPath: "event")
        self.viewModel.timePickerViewModel.removeObserver(self, forKeyPath: "event")
        self.viewModel.timeIntervalViewModel.removeObserver(self, forKeyPath: "event")
        
        for timeStampViewModel in self.timeStampOverviewController.viewModel.timeStampViewModels
        {
            timeStampViewModel.removeObserver(self, forKeyPath: "event")
        }
        
        super.unbind()
    }
    
    override func shouldInsertKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
//        if (keyPath == "models")
//        {
//            let indexSet = change![NSKeyValueChangeKey.indexesKey] as! IndexSet
//        }
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "event")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String

            if (self.viewModel.dropFormInputViewModel.iconOverviewViewModel === object as! NSObject)
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
                        self.viewModel.previewSchedule()
                    }
                }
                else if (newValue == "DidCancel")
                {
                    if (self.viewModel.state == "Date")
                    {
                        self.viewModel.inputDrop()
                    }
                    else if (self.viewModel.state == "Schedule")
                    {
                        self.viewModel.inputDate()
                    }
                    else if (self.viewModel.state == "StartTime" || self.viewModel.state == "IntervalTime" || self.viewModel.state == "RepeatTime")
                    {
                        self.viewModel.previewSchedule()
                    }
                }
            }
            else if (self.viewModel.startTimeStampViewModel === object as! NSObject)
            {
                if (newValue == "DidEdit")
                {
                    if (self.viewModel.state == "Schedule")
                    {
                        self.viewModel.inputStartTime()
                    }
                }
            }
            else if (self.viewModel.intervalTimeStampViewModel === object as! NSObject)
            {
                if (newValue == "DidEdit")
                {
                    if (self.viewModel.state == "Schedule")
                    {
                        self.viewModel.inputIntervalTime()
                    }
                }
            }
            else if (self.viewModel.repeatTimeStampViewModel === object as! NSObject)
            {
                if (newValue == "DidEdit")
                {
                    if (self.viewModel.state == "Schedule")
                    {
                        self.viewModel.inputRepeatTime()
                    }
                }
            }
            else if (self.viewModel.timePickerViewModel === object as! NSObject)
            {
                if (newValue == "DidChange")
                {
                    let aMoment = moment(self.timePickerController.viewModel.timeInterval)
                    self.viewModel.startTimeStampViewModel.display = aMoment.format("hh:mm")
                }
            }
            else if (self.viewModel.timeIntervalViewModel === object as! NSObject)
            {
                if (newValue == "DidChange")
                {
                    let hours = Int(self.timeIntervalController.viewModel.timeInterval) / 3600
                    let minutes = (Int(self.timeIntervalController.viewModel.timeInterval) % 3600) / 60
                    var display = ""
                    
                    if (hours > 0)
                    {
                        display += String(hours) + " hrs "
                    }
                    
                    if (minutes > 0)
                    {
                        display += String(minutes) + " mins"
                    }
                    
                    self.viewModel.intervalTimeStampViewModel.display = display
                }
            }
            else if (self.viewModel.inputViewModel === object as! NSObject)
            {
                if (newValue == "DidKeyboardWillShow")
                {
                    
                }
            }
        }
    }

    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (self.viewModel.keyboardViewModel === viewModel)
        {
            if (transition == "KeyboardWillShow")
            {
                if (self.viewModel.state == "Drop")
                {
                    let keyboardFrame = self.viewModel.keyboardViewModel.keyboardFrame
                    let contentInsets = UIEdgeInsetsMake(0, 0, self.dropFormInputController.listView.convert(keyboardFrame!, from: nil).intersection(self.dropFormInputController.listView.bounds).height, 0)
                    self.dropFormInputController.listView.scrollIndicatorInsets = contentInsets
                    self.dropFormInputController.listView.contentInset = contentInsets
                }
                else if (self.viewModel.state == "RepeatTime")
                {
                    UIView.animate(withDuration: 0.25)
                    {
                        let keyboardFrame = self.viewModel.keyboardViewModel.keyboardFrame
                        self.footerPanelController.view.frame.origin.y = self.view.frame.height - (keyboardFrame?.height)! - self.footerPanelController.view.frame.height
                        self.inputController.view.frame.origin.y = self.view.frame.height - (keyboardFrame?.height)! - self.footerPanelController.view.frame.size.height - self.inputController.view.frame.height
                    }
                }
            }
        }
        else if (self.viewModel === viewModel)
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
                    
                    self.pageFormView.setView(self.dateContainerView,
                                              direction: UIPageFormViewNavigationDirection.forward,
                                              animated: true)
                }
                else if (oldState == "Schedule")
                {
                    self.pageFormView.setView(self.dateContainerView,
                                              direction: UIPageFormViewNavigationDirection.reverse,
                                              animated: true)
                }
            }
            else if (transition == "PreviewSchedule")
            {
                if (oldState == "Date")
                {
                    self.pageFormView.setView(self.timeStampOverviewController.view,
                                              direction: UIPageFormViewNavigationDirection.forward,
                                              animated: true)
                }
                else if (oldState == "StartTime")
                {
                    UIView.animate(withDuration: 0.25, animations:
                    {
                        self.timePickerController.view.frame.origin.y = self.view.frame.height
                    })
                    { (isCompleted) in
                        
                        self.overLayView.frame.origin.y = self.view.frame.height
                    }
                }
                else if (oldState == "IntervalTime")
                {
                    UIView.animate(withDuration: 0.25, animations:
                    {
                            self.timeIntervalController.view.frame.origin.y = self.view.frame.height
                    })
                    { (isCompleted) in
                        
                        self.overLayView.frame.origin.y = self.view.frame.height
                    }
                }
                else if (oldState == "RepeatTime")
                {
                    UIView.animate(withDuration: 0.25, animations:
                    {
                        self.inputController.textfield.resignFirstResponder()
                        self.inputController.view.frame.origin.y = self.view.frame.height
                        self.footerPanelController.view.frame.origin.y = self.view.frame.height - self.footerPanelController.view.frame.size.height
                    })
                    { (isCompleted) in
                        
                        self.overLayView.frame.origin.y = self.view.frame.height
                    }
                }
            }
            else if (transition == "InputStartTime")
            {
                self.overLayView.frame.origin.y = 0
                self.footerPanelController.view.frame.origin.y = self.view.frame.height
                
                UIView.animate(withDuration: 0.25)
                {
                    self.timePickerController.view.frame.origin.y = self.view.frame.height - self.timePickerController.view.frame.height - self.footerPanelController.view.frame.height
                    self.footerPanelController.view.frame.origin.y = self.view.frame.height - self.footerPanelController.view.frame.height
                }
            }
            else if (transition == "InputIntervalTime")
            {
                self.overLayView.frame.origin.y = 0
                
                UIView.animate(withDuration: 0.25)
                {
                    self.timeIntervalController.view.frame.origin.y = self.view.frame.height - self.timeIntervalController.view.frame.height - self.footerPanelController.view.frame.height
                }

            }
            else if (transition == "InputRepeatTime")
            {
                self.overLayView.frame.origin.y = 0

                self.inputController.textfield.becomeFirstResponder()
            }
        }
    }
}
