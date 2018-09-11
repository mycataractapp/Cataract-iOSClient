//
//  DatePickerInputController.swift
//  Cataract
//
//  Created by Minh Nguyen on 9/10/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DatePickerInputController : DynamicController, DynamicViewModelDelegate
{
    private var _datePicker : UIDatePicker!
    @objc dynamic var viewModel : DatePickerInputViewModel!
    
    var datePicker : UIDatePicker
    {
        get
        {
            if (self._datePicker == nil)
            {
                self._datePicker = UIDatePicker()
            }
            
            let datePicker = self._datePicker!
            
            return datePicker
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.datePicker)
        
        self.datePicker.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if (self.viewModel.mode == DatePickerInputViewModel.Mode.interval)
        {
            self.datePicker.countDownDuration = self.viewModel.timeInterval
        }
    }
    
    override func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        super.render(canvas: canvas)
        self.view.frame.size = canvas.size

        self.datePicker.frame.size = self.view.frame.size
//        self.datePicker.frame.size.width = self.view.frame.size.width - canvas.draw(tiles: 1)
//        self.datePicker.frame.size.height = self.view.frame.size.height - canvas.draw(tiles: 0.75)
//
//        self.label.frame.origin.x = (self.view.frame.size.width - self.label.frame.size.width) / 2
//
//        self.datePicker.frame.origin.x = canvas.draw(tiles: 0.5)
//        self.datePicker.frame.origin.y = self.label.frame.size.height + canvas.draw(tiles: 0.25)
//
        return canvas
    }
    
    override func bind()
    {
        super.bind()
        
        self.addObserver(self,
                         forKeyPath: DynamicKVO.keyPath(\DatePickerInputController.viewModel.mode),
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
        
        self.addObserver(self,
                         forKeyPath: DynamicKVO.keyPath(\DatePickerInputController.viewModel.timeInterval),
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\DatePickerInputController.viewModel.mode))
        self.removeObserver(self, forKeyPath: DynamicKVO.keyPath(\DatePickerInputController.viewModel.timeInterval))
    }
    
    override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\DatePickerInputController.viewModel))
        {
            if (controllerEvent.operation == DynamicController.Event.Operation.bind)
            {
                self.viewModel.delegate = self
                self.datePicker.addTarget(self.viewModel,
                                          action: #selector(self.viewModel.change(_:)),
                                          for: UIControlEvents.valueChanged)
            }
            else
            {
                self.viewModel.delegate = nil
                self.datePicker.removeTarget(self.viewModel,
                                             action: #selector(self.viewModel.change(_:)),
                                             for: UIControlEvents.valueChanged)
            }
        }
    }
    
    override func observeKeyValue(for kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\DatePickerInputController.viewModel.mode))
        {
            let newValue = kvoEvent.newValue as? DatePickerInputViewModel.Mode
            
            if (newValue != nil)
            {
                self.set(mode: newValue!)
            }
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\DatePickerInputController.viewModel.timeInterval))
        {
            let newValue = kvoEvent.newValue as? TimeInterval
            
            if (newValue != nil)
            {
                self.set(timeInterval: newValue!)
            }
        }
    }
        
    func set(mode: DatePickerInputViewModel.Mode)
    {
        if (mode == DatePickerInputViewModel.Mode.date)
        {
            self._datePicker.datePickerMode = UIDatePickerMode.date
        }
        else if (mode == DatePickerInputViewModel.Mode.time)
        {
            self._datePicker.datePickerMode = UIDatePickerMode.time
        }
        else if (mode == DatePickerInputViewModel.Mode.interval)
        {
            self._datePicker.datePickerMode = UIDatePickerMode.countDownTimer
        }
    }
    
    func set(timeInterval: TimeInterval)
    {
        if (self.viewModel.mode == DatePickerInputViewModel.Mode.date || self.viewModel.mode == DatePickerInputViewModel.Mode.time)
        {
            self.datePicker.date = Date(timeIntervalSince1970: timeInterval)
        }
        else if (self.viewModel.mode == DatePickerInputViewModel.Mode.interval)
        {
            self.datePicker.countDownDuration = timeInterval
        }
    }
    
    func viewModel(_ viewModel: DynamicViewModel, transitWith event: DynamicViewModel.Event)
    {
        if (event.transition == DatePickerInputViewModel.Transition.change)
        {
            if (self.viewModel.mode == DatePickerInputViewModel.Mode.date || self.viewModel.mode == DatePickerInputViewModel.Mode.time)
            {
                self.viewModel.timeInterval = self.datePicker.date.timeIntervalSince1970
            }
            else if (self.viewModel.mode == DatePickerInputViewModel.Mode.interval)
            {
                self.viewModel.timeInterval = self.datePicker.countDownDuration
            }
        }
    }
}
