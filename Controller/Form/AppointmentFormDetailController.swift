//
//  AppointmentFormDetailController.swift
//  Cataract
//
//  Created by Rose Choi on 7/15/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import SwiftMoment

class AppointmentFormDetailController : DynamicController<AppointmentFormDetailViewModel>, DynamicViewModelDelegate, UIPageViewDelegate, UIPageViewDataSource
{
    private var _overlayView : UIView!
    private var _dateContainerView : UIView!
    private var _appointmentLabel : UILabel!
    private var _button : UIButton!
    private var _pageView : UIPageView!
    private var _appointmentInputOverviewController : AppointmentInputOverviewController!
    private var _inputController : InputController!
    private var _datePickerController : DatePickerController!
    private var _timePickerController : DatePickerController!
    private var _footerPanelController : FooterPanelController!
    private var _appointmentInputOverviewPosition : IndexPath!
    private var _dateContainerViewPosition : IndexPath!
    private var _appointmentStore : AppointmentStore!

    var overlayView : UIView
    {
        get
        {
            if (self._overlayView == nil)
            {
                self._overlayView = UIView()
                self._overlayView.autoresizesSubviews = false
                self._overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            }
            
            let overlayView = self._overlayView!
            
            return overlayView
        }
    }
    
    var dateContainerView : UIView
    {
        get
        {
            if (self._dateContainerView == nil)
            {
                self._dateContainerView = UIView()
                self.dateContainerView.addSubview(self.datePickerController.view)
                self.dateContainerView.addSubview(self.timePickerController.view)
            }
            
            let dateContainerView = self._dateContainerView!
            
            return dateContainerView
        }
    }
    
    var appointmentLabel : UILabel
    {
        get
        {
            if (self._appointmentLabel == nil)
            {
                self._appointmentLabel = UILabel()
                self._appointmentLabel.text = "Choose Pre-Set Appointments, and add more."
                self._appointmentLabel.textAlignment = NSTextAlignment.center
                self._appointmentLabel.numberOfLines = 2
                self._appointmentLabel.textColor = UIColor.white
                self._appointmentLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 144/255, alpha: 1)
            }
            
            let appointmentLabel = self._appointmentLabel!
            
            return appointmentLabel
        }
    }

    var button : UIButton
    {
        get
        {
            if (self._button == nil)
            {
                self._button = UIButton()
                self._button.setImage(UIImage(contentsOfFile: Bundle.main.path(forResource: "Add", ofType: "png")!),
                                      for: UIControlState.normal)
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

    var appointmentInputOverviewController : AppointmentInputOverviewController
    {
        get
        {
            if (self._appointmentInputOverviewController == nil)
            {
                self._appointmentInputOverviewController = AppointmentInputOverviewController()
                self._appointmentInputOverviewController.listView.isScrollEnabled = false
                self._appointmentInputOverviewController.listView.listHeaderView = self.appointmentLabel
                self._appointmentInputOverviewController.view.addSubview(self.button)
            }
            
            let appointmentInputOverviewController = self._appointmentInputOverviewController!
            
            return appointmentInputOverviewController
        }
    }
    
    var inputController : InputController
    {
        get
        {
            if (self._inputController == nil)
            {
                self._inputController = InputController()
            }
            
            let inputController = self._inputController!
            
            return inputController
        }
    }
    
    var datePickerController : DatePickerController
    {
        get
        {
            if (self._datePickerController == nil)
            {
                self._datePickerController = DatePickerController()
                self._datePickerController.view.backgroundColor = UIColor.white
                
                self._datePickerController.label.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 144/255, alpha: 1)
                self._datePickerController.label.textColor = UIColor.white
                
                self._datePickerController.view.layer.masksToBounds = false
                self._datePickerController.view.layer.shadowColor = UIColor.black.cgColor
                self._datePickerController.view.layer.shadowOpacity = 0.1
                self._datePickerController.view.layer.shadowRadius = 20
            }
            
            let datePickerController = self._datePickerController!
            
            return datePickerController
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
                
                self._timePickerController.label.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 144/255, alpha: 1)
                self._timePickerController.label.textColor = UIColor.white
                
                self._timePickerController.view.layer.masksToBounds = false
                self._timePickerController.view.layer.shadowColor = UIColor.black.cgColor
                self._timePickerController.view.layer.shadowOpacity = 0.1
                self._timePickerController.view.layer.shadowRadius = 20
            }
            
            let timePickerController = self._timePickerController!
            
            return timePickerController
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
    
    var appointmentInputOverviewControllerSize : CGSize
    {
        get
        {
            var appointmentInputOverviewControllerSize = CGSize.zero
            appointmentInputOverviewControllerSize.width = self.pageView.frame.size.width
            appointmentInputOverviewControllerSize.height = self.pageView.frame.size.height - self.footerPanelController.view.frame.size.height
            
            return appointmentInputOverviewControllerSize
        }
    }
    
    var inputControllerSize : CGSize
    {
        get
        {
            var inputControllerSize = CGSize.zero
            inputControllerSize.width = self.pageView.frame.size.width
            inputControllerSize.height = self.canvas.draw(tiles: 3)
            
            return inputControllerSize
        }
    }

    var datePickerControllerSize : CGSize
    {
        get
        {
            var datePickerControllerSize = CGSize.zero
            datePickerControllerSize.width = self.dateContainerView.frame.size.width - self.canvas.draw(tiles: 1)
            datePickerControllerSize.height = self.canvas.draw(tiles: 10)
            
            return datePickerControllerSize
        }
    }
    
    var timePickerControllerSize : CGSize
    {
        get
        {
            var timePickerControllerSize = CGSize.zero
            timePickerControllerSize.width = self.dateContainerView.frame.size.width - self.canvas.draw(tiles: 1)
            timePickerControllerSize.height = self.canvas.draw(tiles: 10)

            return timePickerControllerSize
        }
    }
    
    var footerPanelControllerSize : CGSize
    {
        get
        {
            var footerPanelControllerSize = CGSize.zero
            footerPanelControllerSize.width = self.view.frame.size.width
            footerPanelControllerSize.height = self.canvas.draw(tiles: 3)
            
            return footerPanelControllerSize
        }
    }
    
    var appointmentInputOverviewPosition : IndexPath
    {
        if (self._appointmentInputOverviewPosition == nil)
        {
            self._appointmentInputOverviewPosition = IndexPath(item: 0, section: 0)
        }
        
        return self._appointmentInputOverviewPosition!
    }
    
    var dateContainerViewPosition : IndexPath
    {
        if (self._dateContainerViewPosition == nil)
        {
            self._dateContainerViewPosition = IndexPath(item: 1, section: 0)
        }
        
        return self._dateContainerViewPosition!
    }
    
    var appointmentStore : AppointmentStore
    {
        get
        {
            if (self._appointmentStore == nil)
            {
                self._appointmentStore = AppointmentStore()
            }
            
            let appointmentStore = self._appointmentStore!
            
            return appointmentStore
        }
        set(newValue)
        {
            self._appointmentStore = newValue
        }
    }

    override func viewDidLoad()
    {
        self.view.addSubview(self.pageView)
        self.view.addSubview(self.overlayView)
        self.view.addSubview(self.inputController.view)
        self.view.addSubview(self.footerPanelController.view)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.appointmentLabel.font = UIFont.systemFont(ofSize: 24)
        
        self.pageView.frame.size = self.view.frame.size
        
        self.overlayView.frame.size = self.view.frame.size
        self.overlayView.frame.origin.y = self.view.frame.height
        
        self.footerPanelController.render(size: self.footerPanelControllerSize)
        
        self.dateContainerView.frame.size.width = self.pageView.frame.size.width
        self.dateContainerView.frame.size.height = self.pageView.frame.size.height - self.footerPanelController.view.frame.size.height
        
        self.appointmentInputOverviewController.render(size: self.appointmentInputOverviewControllerSize)
        self.inputController.render(size: self.inputControllerSize)
        self.datePickerController.render(size: self.datePickerControllerSize)
        self.timePickerController.render(size: self.timePickerControllerSize)
        
        self.appointmentLabel.frame.size.width = self.view.frame.size.width
        self.appointmentLabel.frame.size.height = self.canvas.draw(tiles: 3)
        
        self.button.frame.size.width = self.canvas.draw(tiles: 3)
        self.button.frame.size.height = self.button.frame.size.width
        
        self.appointmentLabel.frame.origin.x = (self.view.frame.size.width - self.appointmentLabel.frame.size.width) / 2
        
        self.button.frame.origin.x = self.pageView.frame.size.width - self.button.frame.size.width - self.canvas.draw(tiles: 0.5)
        self.button.frame.origin.y = self.appointmentInputOverviewController.view.frame.size.height - self.canvas.draw(tiles: 4)
        
        self.inputController.view.frame.origin.y = self.pageView.frame.size.height
        
        self.footerPanelController.view.frame.origin.y = self.view.frame.size.height - self.footerPanelController.view.frame.size.height
        
        self.datePickerController.view.frame.origin.x = self.canvas.draw(tiles: 0.5)
        self.datePickerController.view.frame.origin.y = (self.dateContainerView.frame.size.height - self.datePickerController.view.frame.size.height - self.timePickerController.view.frame.size.height - self.canvas.draw(tiles: 1.5)) / 2
        
        self.timePickerController.view.frame.origin.x = self.datePickerController.view.frame.origin.x
        self.timePickerController.view.frame.origin.y = self.datePickerController.view.frame.origin.y + self.datePickerController.view.frame.size.height + self.canvas.draw(tiles: 0.5)
    }
    
    override func bind(viewModel: AppointmentFormDetailViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.viewModel.delegate = self
        self.viewModel.keyboardViewModel.delegate = self
        
        NotificationCenter.default.addObserver(self.viewModel.keyboardViewModel,
                                               selector: #selector(self.viewModel.keyboardViewModel.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)        
        self.appointmentInputOverviewController.bind(viewModel: self.viewModel.appointmentInputOverviewViewModel)
        self.inputController.bind(viewModel: self.viewModel.inputViewModel)
        self.datePickerController.bind(viewModel: self.viewModel.datePickerViewModel)
        self.timePickerController.bind(viewModel: self.viewModel.timePickerViewModel)
        self.footerPanelController.bind(viewModel: self.viewModel.footerPanelViewModel)
        
        self.viewModel.footerPanelViewModel.addObserver(self,
                                                        forKeyPath: "event",
                                                        options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                             NSKeyValueObservingOptions.initial]),
                                                        context: nil)
        for appointmentInputViewModel in self.appointmentInputOverviewController.viewModel.appointmentInputViewModels
        {
            appointmentInputViewModel.addObserver(self,
                                                  forKeyPath: "event",
                                                  options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                NSKeyValueObservingOptions.initial]),
                                                  context: nil)
        }
        
        self.button.addTarget(self.viewModel,
                              action: #selector(self.viewModel.customizeAppointment),
                              for: UIControlEvents.touchDown)
    }
    
    override func unbind()
    {
        self.viewModel.delegate = nil
                
        self.appointmentInputOverviewController.unbind()
        self.inputController.unbind()
        self.datePickerController.unbind()
        self.timePickerController.unbind()
        self.footerPanelController.unbind()
        
        super.unbind()
    }
    
    func pageView(_ pageView: UIPageView, numberOfItemsInSection section: Int) -> Int
    {
        return UIPageViewAutomaticNumberOfItems
    }
    
    func pageView(_ pageView: UIPageView, cellForItemAt indexPath: IndexPath) -> UIPageViewCell
    {
        let cell = UIPageViewCell()
        
        if (indexPath == self.appointmentInputOverviewPosition)
        {
            cell.addSubview(self.appointmentInputOverviewController.view)
        }
        else if (indexPath == self.dateContainerViewPosition)
        {
            cell.addSubview(self.dateContainerView)
        }
        
        return cell
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "event")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            
            if (self.viewModel.footerPanelViewModel === object as! NSObject)
            {
                if (newValue == "DidConfirm")
                {
                    if (self.viewModel.state == "Appointment" || self.viewModel.state == "Custom")
                    {
                        self.viewModel.inputDate()
                    }
                    else if (self.viewModel.state == "Date")
                    {
                        self.viewModel.createAppointment()
                    }
                }
                else if (newValue == "DidCancel")
                {
                    if (self.viewModel.state == "Custom" || self.viewModel.state == "Date")
                    {
                        self.viewModel.previewAppointment()
                    }
                }
            }
        }
    }

    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (self.viewModel.keyboardViewModel == viewModel)
        {
            if (transition == "KeyboardWillShow")
            {
                if (self.viewModel.state == "Custom")
                {
                    let keyboardFrame = self.viewModel.keyboardViewModel.keyboardFrame
    
                    self.footerPanelController.view.frame.origin.y = self.view.frame.height - (keyboardFrame?.height)! - self.footerPanelController.view.frame.height
                    self.inputController.view.frame.origin.y = self.view.frame.height - (keyboardFrame?.height)! - self.footerPanelController.view.frame.size.height - self.inputController.view.frame.height
                }
            }
        }
        else if (self.viewModel == viewModel)
        {
            if (newState == "Appointment")
            {
                self.pageView.slideToItem(at: self.appointmentInputOverviewPosition,
                                          from: UIPageViewSlideDirection.reverse,
                                          animated: true)

                if (oldState == "Custom")
                {
                    UIView.animate(withDuration: 0.25, animations:
                    {
                        self.inputController.textField.resignFirstResponder()
                        self.inputController.view.frame.origin.y = self.view.frame.height
                        self.footerPanelController.view.frame.origin.y = self.view.frame.height - self.footerPanelController.view.frame.size.height
                    })
                    { (isCompleted) in
                        
                        self.overlayView.frame.origin.y = self.view.frame.height
                    }
                }
            }
            else if (newState == "Custom")
            {
                self.overlayView.frame.origin.y = 0
                self.inputController.textField.becomeFirstResponder()
            }
            else if (newState == "Date")
            {
                self.pageView.slideToItem(at: self.dateContainerViewPosition,
                                          from: UIPageViewSlideDirection.forward,
                                          animated: true)
                
                if (oldState == "Custom")
                {
                    UIView.animate(withDuration: 0.25, animations:
                    {
                        self.inputController.textField.resignFirstResponder()
                        self.inputController.view.frame.origin.y = self.view.frame.height
                        self.footerPanelController.view.frame.origin.y = self.view.frame.height - self.footerPanelController.view.frame.size.height
                    })
                    { (isCompleted) in
                        
                        self.overlayView.frame.origin.y = self.view.frame.height
                    }
                }
            }
            else if (newState == "Main")
            {
                for appointmentInputViewModel in self.viewModel.appointmentInputOverviewViewModel.appointmentInputViewModels
                {
                    if (appointmentInputViewModel.state == "On")
                    {
                        let selectedAppointmentInputViewModel = appointmentInputViewModel
                
                        let aMomentDate = moment(self.viewModel.datePickerViewModel.timeInterval)
                        let aMomentTime = moment(self.viewModel.timePickerViewModel.timeInterval)
        
                        let appointmentModel = AppointmentModel()
                        appointmentModel.title = selectedAppointmentInputViewModel.title
                        print(appointmentModel.title)
                        appointmentModel.date = aMomentDate.format("MMMM d Y")
                        print(appointmentModel.date)
                        appointmentModel.time = aMomentTime.format("hh:mm")
                        print(appointmentModel.time)
                        self.appointmentStore.push(appointmentModel, isNetworkEnabled: false)
                
                        break
                    }
                }
                
                print("back to main page")
//                self.view.removeFromSuperview()
            }
        }
    }
}

