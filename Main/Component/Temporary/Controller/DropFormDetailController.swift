//
//  DropFormDetailController .swift
//  Cataract
//
//  Created by Roseanne Choi on 6/16/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit
import SwiftMoment
import UserNotifications

class DropFormDetailController : DynamicController, DynamicViewModelDelegate, UIPageViewDataSource, UIPageViewDelegate
{
    private var _button : UIButton!
    private var _pageView : UIPageView!
    private var _dateContainerView : UIView!
    private var _overLayView : UIView!
    private var _dropFormInputController : DropFormInputController!
    private var _startDateController : DatePickerController!
    private var _endDateController : DatePickerController!
    private var _startTimeController : DatePickerController!
    private var _timeIntervalController : DatePickerController!
    private var _inputController : InputController!
    private var _timeOverviewController : TimeOverviewController!
    private var _timeStampOverviewController : TimeStampOverviewController!
    private var _footerPanelController : FooterPanelController!
//    private var _timeStore : TimeStore!
    private var _dropStore : DropStore!
    private var _dropFormInputPosition : IndexPath!
    private var _dateContainerPosition : IndexPath!
    private var _timeOverviewPosition : IndexPath!

    var button : UIButton
    {
        get
        {
            if (self._button == nil)
            {
                self._button = UIButton()
                self._button.setTitle("Confirm", for: UIControlState.normal)
                self._button.backgroundColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
            }
            
            let button = self._button!
            
            return button
        }
    }
    
    var pageView : UIPageView
    {
        get
        {
            if (self._pageView == nil)
            {
                self._pageView = UIPageView(mode: UIPageViewMode.sliding)
                self._pageView.isScrollEnabled = false
                self._pageView.delegate = self
                self._pageView.dataSource = self
            }
            
            let pageView = self._pageView!
            
            return pageView
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
    
    var startTimeController : DatePickerController
    {
        get
        {
            if (self._startTimeController == nil)
            {
                self._startTimeController = DatePickerController()
                self._startTimeController.view.backgroundColor = UIColor.white
            }
            
            let startTimeController = self._startTimeController!
            
            return startTimeController
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
                self._timeOverviewController.listView.listHeaderView = self.timeStampOverviewController.view
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
                self._timeStampOverviewController.listView.isScrollEnabled = false
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
    
//    var timeStore : TimeStore
//    {
//        get
//        {
//            if (self._timeStore == nil)
//            {
//                self._timeStore = TimeStore()
//            }
//
//            let timeStore = self._timeStore!
//
//            return timeStore
//        }
//    }
    
    var dropStore : DropStore
    {
        get
        {
            if (self._dropStore == nil)
            {
                self._dropStore = DropStore()
            }
            
            let dropStore = self._dropStore!
            
            return dropStore
        }
        
        set(newValue)
        {
            self._dropStore = newValue
        }
    }

    var dropFormInputControllerSize : CGSize
    {
        get
        {
            var dropFormInputControllerSize = CGSize.zero
            dropFormInputControllerSize.width = self.pageView.frame.size.width
            dropFormInputControllerSize.height = self.pageView.frame.size.height - self.footerPanelController.view.frame.size.height
            
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
    
    var startTimeControllerSize : CGSize
    {
        get
        {
            var startTimeControllerSize = CGSize.zero
            startTimeControllerSize.width = self.overLayView.frame.size.width
            startTimeControllerSize.height = canvas.draw(tiles: 7)
            
            return startTimeControllerSize
        }
    }
    
    var timeIntervalControllerSize : CGSize
    {
        get
        {
            var timeIntervalControllerSize = CGSize.zero
            timeIntervalControllerSize.width = self.overLayView.frame.size.width
            timeIntervalControllerSize.height = canvas.draw(tiles: 7)
            
            return timeIntervalControllerSize
        }
    }
    
    var inputControllerSize : CGSize
    {
        get
        {
            var inputControllerSize = CGSize.zero
            inputControllerSize.width = self.overLayView.frame.size.width
            inputControllerSize.height = canvas.draw(tiles: 3)
            
            return inputControllerSize
        }
    }
    
    var timeOverviewControllerSize : CGSize
    {
        get
        {
            var timeOverviewControllerSize = CGSize.zero
            timeOverviewControllerSize.width = self.pageView.frame.size.width
            timeOverviewControllerSize.height = self.pageView.frame.size.height - self.footerPanelController.view.frame.size.height
            
            return timeOverviewControllerSize
        }
    }
    
    var timeStampOverviewControllerSize : CGSize
    {
        get
        {
            var timeStampOverviewControllerSize = CGSize.zero
            timeStampOverviewControllerSize.width = self.pageView.frame.size.width
            timeStampOverviewControllerSize.height = canvas.draw(tiles: 10)
            
            return timeStampOverviewControllerSize
        }
    }

    var footerPanelControllerSize : CGSize
    {
        get
        {
            var footerPanelControllerSize = CGSize.zero
            footerPanelControllerSize.width = self.view.frame.width
            footerPanelControllerSize.height = canvas.draw(tiles: 3)
            
            return footerPanelControllerSize
        }
    }

    var dropFormInputPosition : IndexPath
    {
        if (self._dropFormInputPosition == nil)
        {
            self._dropFormInputPosition = IndexPath(item: 0, section: 0)
        }
        
        return self._dropFormInputPosition!
    }
    
    var dateContainerPosition : IndexPath
    {
        if (self._dateContainerPosition == nil)
        {
            self._dateContainerPosition = IndexPath(item: 1, section: 0)
        }
        
        return self._dateContainerPosition!
    }
    
    var timeOverviewPosition : IndexPath
    {
        if (self._timeOverviewPosition == nil)
        {
            self._timeOverviewPosition = IndexPath(item: 2, section: 0)
        }
        
        return self._timeOverviewPosition!
    }
    
    override func viewDidLoad()
    {        
        self.view.backgroundColor = UIColor.white
        self.pageView.backgroundColor = UIColor.white
        
        self.view.addSubview(self.pageView)
        self.view.addSubview(self.overLayView)
        self.view.addSubview(self.footerPanelController.view)
        self.view.addSubview(self.startTimeController.view)
        self.view.addSubview(self.timeIntervalController.view)
        self.view.addSubview(self.inputController.view)
        self.view.addSubview(self.button)
    }
    
    override func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        super.render(canvas: canvas)
        self.view.frame.size = canvas.size
        
        self.button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        
        self.pageView.frame.size = self.view.frame.size
        
        self.button.frame.size.width = self.startTimeController.view.frame.size.width
        self.button.frame.size.height = canvas.draw(tiles: 3)
        
        self.dateContainerView.frame.size.width = self.view.frame.size.width
        self.dateContainerView.frame.size.height = self.pageView.frame.size.height - self.footerPanelController.view.frame.size.height
        
        self.overLayView.frame.size = self.view.frame.size
        self.overLayView.frame.origin.y = self.view.frame.height
        
        self.footerPanelController.view.frame.origin.y = canvas.size.height - self.footerPanelController.view.frame.size.height
        self.startDateController.view.frame.origin.y = (self.view.frame.size.height - self.startDateController.view.frame.size.height - self.endDateController.view.frame.size.height - canvas.draw(tiles: 2.5)) / 2
        self.endDateController.view.frame.origin.y = self.startDateController.view.frame.origin.y + self.startDateController.view.frame.height + canvas.draw(tiles: 0.5)
        self.button.frame.origin.y = UIScreen.main.bounds.height
        self.startTimeController.view.frame.origin.y = UIScreen.main.bounds.height
        self.timeIntervalController.view.frame.origin.y = UIScreen.main.bounds.height
        self.inputController.view.frame.origin.y = UIScreen.main.bounds.height
        
        return canvas
    }
    
    override func bind()
    {
        super.bind()
                
        self.viewModel.delegate = self
        self.viewModel.keyboardViewModel.delegate = self
        
        self.footerPanelController.bind()
        self.dropFormInputController.bind()
        self.startDateController.bind()
        self.endDateController.bind()
        self.startTimeController.bind()
        self.timeIntervalController.bind()
        self.inputController.bind()
        self.timeOverviewController.bind()
        self.timeStampOverviewController.bind()
        
        NotificationCenter.default.addObserver(self.viewModel.keyboardViewModel,
                                               selector: #selector(self.viewModel.keyboardViewModel.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        self.viewModel.dropFormInputViewModel.iconOverviewViewModel.addObserver(self,
                                                                                forKeyPath: "event",
                                                                                options:
                                                                                    NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                    NSKeyValueObservingOptions.initial]),
                                                                                context: nil)
        self.viewModel.startTimeViewModel.addObserver(self,
                                                       forKeyPath: "event",
                                                       options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                             NSKeyValueObservingOptions.initial]),
                                                       context: nil)
        
        self.viewModel.timeIntervalViewModel.addObserver(self,
                                                         forKeyPath: "event",
                                                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                              NSKeyValueObservingOptions.initial]),
                                                         context: nil)
        self.viewModel.inputViewModel.addObserver(self,
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
//        self.timeStore.addObserver(self,
//                                   forKeyPath: "models",
//                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
//                                                                        NSKeyValueObservingOptions.initial]),
//                                   context: nil)
        
        self.button.addTarget(self.viewModel,
                              action: #selector(self.viewModel.previewSchedule),
                              for: UIControlEvents.touchDown)
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.viewModel.delegate = nil
        
        self.footerPanelController.unbind()
        self.dropFormInputController.unbind()
        self.startDateController.unbind()
        self.endDateController.unbind()
        self.startTimeController.unbind()
        self.timeIntervalController.unbind()
        self.inputController.unbind()
        self.timeOverviewController.unbind()
        
        self.viewModel.footerPanelViewModel.removeObserver(self, forKeyPath: "event")
        self.viewModel.startTimeViewModel.removeObserver(self, forKeyPath: "event")
        self.viewModel.timeIntervalViewModel.removeObserver(self, forKeyPath: "event")
//        self.timeStore.removeObserver(self, forKeyPath: "models")

        for timeStampViewModel in self.timeStampOverviewController.viewModel.timeStampViewModels
        {
            timeStampViewModel.removeObserver(self, forKeyPath: "event")
        }
        
        self.timeStampOverviewController.unbind()
    }
    
    func pageView(_ pageView: UIPageView, numberOfItemsInSection section: Int) -> Int
    {
        return UIPageViewAutomaticNumberOfItems
    }
    
    func pageView(_ pageView: UIPageView, cellForItemAt indexPath: IndexPath) -> UIPageViewCell
    {
        let cell = UIPageViewCell()
        
        if (indexPath == self.dropFormInputPosition)
        {
            cell.addSubview(self.dropFormInputController.view)
        }
        else if (indexPath == self.dateContainerPosition)
        {
            cell.addSubview(self.dateContainerView)
        }
        else if (indexPath == self.timeOverviewPosition)
        {
            cell.addSubview(self.timeOverviewController.view)
        }
        
        return cell
    }
    
//    override func shouldInsertKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
//    {
//        if (keyPath == "models")
//        {
//            let indexSet = change![NSKeyValueChangeKey.indexesKey] as! IndexSet
//
//            if (self.timeStore === object as! NSObject)
//            {
//                self.timeOverviewController.viewModel.timeViewModels = [TimeViewModel]()
//
//                for index in indexSet
//                {
//                    let timeModel = self.timeStore.retrieve(at: index)
//                    let timeViewModel = TimeViewModel(time: timeModel.time,
//                                                      period: timeModel.period,
//                                                      timeInterval: timeModel.timeInterval)
//
//                    self.timeOverviewController.viewModel.timeViewModels.append(timeViewModel)
//                }
//
//                self.timeOverviewController.listView.reloadData()
//            }
//        }
//    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "event")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String

            if (self.viewModel.dropFormInputViewModel.iconOverviewViewModel === object as! NSObject)
            {
                if (newValue == "DidToggle")
                {
                    self.dropFormInputController.inputController.textField.resignFirstResponder()
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
                    else if (self.viewModel.state == "Schedule")
                    {
                        let dropModel = DropModel()
                        var selectedIconViewModel : IconViewModel? = nil
                        var timeModels = [TimeModel]()
                        
                        for iconViewModel in self.dropFormInputController.iconOverviewController.viewModel.iconViewModels
                        {
                            if (iconViewModel.state == "On")
                            {
                                selectedIconViewModel = iconViewModel                                
                                break
                            }
                        }
                        
                        for timeViewModel in self.timeOverviewController.viewModel.timeViewModels
                        {        
                            let timeModel = TimeModel()
                            timeModel.identifier = UUID().uuidString
                            timeModel.timeInterval = timeViewModel.timeInterval

                            timeModels.append(timeModel)
                        }
                        
                        if (selectedIconViewModel != nil)
                        {
                            dropModel.colorModel.name = selectedIconViewModel!.title
                            dropModel.colorModel.redValue = selectedIconViewModel!.colorCode["red"]!
                            dropModel.colorModel.greenValue = selectedIconViewModel!.colorCode["green"]!
                            dropModel.colorModel.blueValue = selectedIconViewModel!.colorCode["blue"]!
                            dropModel.colorModel.alphaValue = selectedIconViewModel!.colorCode["alpha"]!
                        }

                        dropModel.startDate = self.startDateController.viewModel.timeInterval
                        dropModel.endDate = self.endDateController.viewModel.timeInterval
                        dropModel.title = self.dropFormInputController.viewModel.inputViewModel.value
                        dropModel.timeModels = timeModels
                        
//                        self.notification(dropModel: dropModel)
                        
                        self.dropStore.push(dropModel, isNetworkEnabled: false)
                        .then
                        { (value) -> Any? in

                            self.dropStore.encodeModels()
                            
                            return nil
                        }
                        
                        self.dropStore.notification(dropModel: dropModel, startDateController: self.startDateController)
                        
                        self.viewModel.createDrop()
                    }
                }
                else if (newValue == "DidCancel")
                {
                    if (self.viewModel.state == "Drop")
                    {
                        self.viewModel.exitDrop()
                    }
                    else if (self.viewModel.state == "Date")
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
            else if (self.viewModel.startTimeViewModel === object as! NSObject)
            {
                if (newValue == "DidChange")
                {
                    let aMoment = moment(self.startTimeController.viewModel.timeInterval)
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
                if (newValue == "DidTextFieldTextDidChange")
                {
                    let value = self.viewModel.inputViewModel.value
                    
                    self.viewModel.repeatTimeStampViewModel.display = value
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
                    let keyboardFrameInListView = self.dropFormInputController.listView.convert(keyboardFrame!, from: nil)
                    let keyboardIntersection = keyboardFrameInListView.intersection(self.dropFormInputController.listView.bounds)
                    let contentInsets = UIEdgeInsetsMake(0, 0, keyboardIntersection.height, 0)
                    self.dropFormInputController.listView.scrollIndicatorInsets = contentInsets
                    self.dropFormInputController.listView.contentInset = contentInsets
                }
                else if (self.viewModel.state == "RepeatTime")
                {
                    UIView.animate(withDuration: 0.25)
                    {
                        let keyboardFrame = self.viewModel.keyboardViewModel.keyboardFrame
                        self.button.frame.origin.y = (UIScreen.main.bounds.height - (keyboardFrame?.height)! - self.button.frame.height) - self.view.frame.origin.y - self.view.superview!.frame.origin.y
                        self.inputController.view.frame.origin.y = (UIScreen.main.bounds.height - (keyboardFrame?.height)! - self.button.frame.height - self.inputController.view.frame.size.height) - self.view.frame.origin.y - self.view.superview!.frame.origin.y
                    }
                }
            }
        }
        else if (self.viewModel === viewModel)
        {
            if (newState == "Drop")
            {
                if (oldState == "Date")
                {
                    self.pageView.slideToItem(at: self.dropFormInputPosition,
                                              from: UIPageViewSlideDirection.reverse,
                                              animated: true)
                }
                
            }
            else if (newState == "Date")
            {
                if (oldState == "Drop")
                {
                    self.pageView.slideToItem(at: self.dateContainerPosition,
                                              from: UIPageViewSlideDirection.forward,
                                              animated: true)
                }
                else if (oldState == "Schedule")
                {
                    self.pageView.slideToItem(at: self.dateContainerPosition,
                                              from: UIPageViewSlideDirection.reverse,
                                              animated: true)
                }
            }
            else if (newState == "Schedule")
            {
                let screen = UIScreen.main.bounds.height
                
                if (oldState == "Date")
                {
                    self.pageView.slideToItem(at: self.timeOverviewPosition,
                                              from: UIPageViewSlideDirection.forward,
                                              animated: true)
                }
                else if (oldState == "StartTime")
                {
                    UIView.animate(withDuration: 0.25, animations:
                    {
                        self.startTimeController.view.frame.origin.y = screen
                        self.button.frame.origin.y = screen
                    })
                    { (isCompleted) in
                        
                        self.overLayView.frame.origin.y = self.view.frame.height
                    }
                }
                else if (oldState == "IntervalTime")
                {
                    UIView.animate(withDuration: 0.25, animations:
                    {
                        self.timeIntervalController.view.frame.origin.y = screen
                        self.button.frame.origin.y = screen
                    })
                    { (isCompleted) in
                        
                        self.overLayView.frame.origin.y = self.view.frame.height
                    }
                }
                else if (oldState == "RepeatTime")
                {
                    UIView.animate(withDuration: 0.25, animations:
                    {
                        self.inputController.textField.resignFirstResponder()
                        self.inputController.view.frame.origin.y = screen
                        self.button.frame.origin.y = screen
                    })
                    { (isCompleted) in
                        
                        self.overLayView.frame.origin.y = self.view.frame.height
                    }
                }
                
                self.timeOverviewController.viewModel.timeViewModels = [TimeViewModel]()
                let maxCount = Int(self.inputController.viewModel.value)
                var timeInterval = self.startTimeController.viewModel.timeInterval
                
                for counter in 0...maxCount! - 1
                {
                    let aMoment = moment(timeInterval)
                    let timeViewModel = TimeViewModel(time: aMoment.format("hh:mm"), period: aMoment.format("a"), timeInterval: timeInterval)
                    self.timeOverviewController.viewModel.timeViewModels.append(timeViewModel)
                
                    let duration = Int(self.timeIntervalController.viewModel.timeInterval).seconds
                    timeInterval = aMoment.add(duration).date.timeIntervalSince1970
                }
                
                self.timeOverviewController.listView.reloadData()
            } 
            else if (newState == "StartTime")
            {
                self.overLayView.frame.origin.y = 0
                
                UIView.animate(withDuration: 0.25)
                {
                    self.startTimeController.view.frame.origin.y = self.view.frame.height - self.startTimeController.view.frame.height - self.button.frame.height
                    self.button.frame.origin.y = self.view.frame.height - self.button.frame.height
                }
            }
            else if (newState == "IntervalTime")
            {
                self.overLayView.frame.origin.y = 0
                
                UIView.animate(withDuration: 0.25)
                {
                    self.timeIntervalController.view.frame.origin.y = self.view.frame.height - self.timeIntervalController.view.frame.height - self.button.frame.height
                    self.button.frame.origin.y = self.view.frame.height - self.button.frame.height
                }
            }
            else if (newState == "RepeatTime")
            {
                self.overLayView.frame.origin.y = 0

                self.inputController.textField.keyboardType = UIKeyboardType.numberPad
                self.inputController.textField.becomeFirstResponder()
            }
        }
    }
}
