//
//  DatePickerController.swift
//  Cataract
//
//  Created by Rose Choi on 6/18/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DatePickerController : DynamicController<DatePickerViewModel>
{
    private var _datePicker : UIDatePicker!
    
    
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
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.datePicker.frame.size.width = self.view.frame.size.width
        self.datePicker.frame.size.height = self.view.frame.size.height
    }
    
    override func bind(viewModel: DatePickerViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.viewModel.addObserver(self,
                                   forKeyPath: "mode",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
        self.datePicker.addTarget(self.viewModel,
                                  action: #selector(self.viewModel.changeDate(_:)),
                                  for: UIControlEvents.valueChanged)
    }
    
    override func unbind()
    {
        self.viewModel.removeObserver(self, forKeyPath: "mode")
        self.datePicker.removeTarget(self.viewModel, action: #selector(self.viewModel.changeDate(_:)), for: UIControlEvents.valueChanged)
        
        super.unbind()
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "mode")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            
            if (self.viewModel.mode == "Date")
            {
                self._datePicker.datePickerMode = UIDatePickerMode.date
            }
            else if (self.viewModel.mode == "Timer")
            {
                self._datePicker.datePickerMode = UIDatePickerMode.countDownTimer
            }
        }
    }
}
