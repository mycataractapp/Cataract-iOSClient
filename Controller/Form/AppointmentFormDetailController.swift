//
//  AppointmentFormDetailController.swift
//  Cataract
//
//  Created by Rose Choi on 7/15/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class AppointmentFormDetailController : DynamicController<AppointmentFormDetailViewModel>, DynamicViewModelDelegate, UIPageViewDelegate, UIPageViewDataSource
{
    private var _overlayView : UIView!
    private var _appointmentLabel : UILabel!
    private var _dateLabel : UILabel!
    private var _button : UIButton!
    private var _pageView : UIPageView!
    private var _appointmentInputOverviewController : AppointmentInputOverviewController!
    private var _inputController : InputController!
    private var _datePicker : UIDatePicker!
    private var _footerPanelController : FooterPanelController!
    private var _appointmentInputOverviewPosition : IndexPath!
    private var _datePickerPosition : IndexPath!

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
    
    var dateLabel : UILabel
    {
        get
        {
            if (self._dateLabel == nil)
            {
                self._dateLabel = UILabel()
                self._dateLabel.text = "Select a date, and time for your appointment."
                self._dateLabel.textAlignment = NSTextAlignment.center
                self._dateLabel.numberOfLines = 2
                self._dateLabel.textColor = UIColor.white
                self._dateLabel.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 144/255, alpha: 1)
            }
            
            let dateLabel = self._dateLabel!
            
            return dateLabel
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
    
    var datePicker : UIDatePicker
    {
        get
        {
            if (self._datePicker == nil)
            {
                self._datePicker = UIDatePicker()
                self._datePicker.backgroundColor = UIColor.white
            }
            
            let datePicker = self._datePicker!
            
            return datePicker
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
    
    var datePickerPosition : IndexPath
    {
        if (self._datePickerPosition == nil)
        {
            self._datePickerPosition = IndexPath(item: 1, section: 0)
        }
        
        return self._datePickerPosition!
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
        self.dateLabel.font = UIFont.systemFont(ofSize: 24)
        
        self.pageView.frame.size = self.view.frame.size
        
        self.overlayView.frame.size = self.view.frame.size
        self.overlayView.frame.origin.y = self.view.frame.height
        
        self.footerPanelController.render(size: self.footerPanelControllerSize)
        self.appointmentInputOverviewController.render(size: self.appointmentInputOverviewControllerSize)
        self.inputController.render(size: self.inputControllerSize)
        
        self.appointmentLabel.frame.size.width = self.view.frame.size.width
        self.appointmentLabel.frame.size.height = self.canvas.draw(tiles: 3)
        
        self.dateLabel.frame.size.width = self.view.frame.size.width
        self.dateLabel.frame.size.height = self.canvas.draw(tiles: 3)
        
        self.button.frame.size.width = self.canvas.draw(tiles: 3)
        self.button.frame.size.height = self.button.frame.size.width
        
        self.datePicker.frame.size.width = self.view.frame.size.width - self.canvas.draw(tiles: 1)
        self.datePicker.frame.size.height = self.canvas.draw(tiles: 6)
        
        self.appointmentLabel.frame.origin.x = (self.view.frame.size.width - self.appointmentLabel.frame.size.width) / 2
        
        self.button.frame.origin.x = self.pageView.frame.size.width - self.button.frame.size.width - self.canvas.draw(tiles: 0.5)
        self.button.frame.origin.y = self.appointmentInputOverviewController.view.frame.size.height - self.canvas.draw(tiles: 4)
        
        self.datePicker.frame.origin.x = self.canvas.draw(tiles: 0.5)
        self.datePicker.center.y = self.view.frame.size.height / 2
        
        self.inputController.view.frame.origin.y = self.pageView.frame.size.height
        
        self.footerPanelController.view.frame.origin.y = self.view.frame.size.height - self.footerPanelController.view.frame.size.height
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
        else if (indexPath == self.datePickerPosition)
        {
            cell.addSubview(self.dateLabel)
            cell.addSubview(self.datePicker)
            
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.10
            cell.layer.shadowRadius = 2
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
                self.pageView.slideToItem(at: self.datePickerPosition,
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
        }
    }
}


