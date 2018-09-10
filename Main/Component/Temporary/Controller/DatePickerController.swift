//
//  DatePickerController.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/18/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class DatePickerController : DynamicController, DynamicViewModelDelegate
{
    private var _label : UILabel!
    private var _datePicker : UIDatePicker!
    
    var label : UILabel
    {
        get
        {
            if (self._label == nil)
            {
                self._label = UILabel()
                self._label.textAlignment = NSTextAlignment.center
                self._label.numberOfLines = 2
                self._label.textColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
            }
            
            let label = self._label!
            
            return label
        }
    }
    
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
        self.view.addSubview(self.label)
        self.view.addSubview(self.datePicker)
        
        self.datePicker.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if (self.viewModel.mode == "Interval")
        {
            self.datePicker.countDownDuration = self.viewModel.timeInterval
        }
    }
    
    override func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        super.render(canvas: canvas)
        self.view.frame.size = canvas.size
        
        self.label.font = UIFont.systemFont(ofSize: 24)
        
        self.label.frame.size.width = canvas.size.width
        self.label.frame.size.height = canvas.draw(tiles: 2)
        
        self.datePicker.frame.size.width = self.view.frame.size.width - canvas.draw(tiles: 1)
        self.datePicker.frame.size.height = self.view.frame.size.height - self.label.frame.size.height - canvas.draw(tiles: 0.75)
        
        self.label.frame.origin.x = (self.view.frame.size.width - self.label.frame.size.width) / 2
        
        self.datePicker.frame.origin.x = canvas.draw(tiles: 0.5)
        self.datePicker.frame.origin.y = self.label.frame.size.height + canvas.draw(tiles: 0.25)
        
        return canvas
    }
    
    override func bind()
    {
        super.bind()
        
        self.viewModel.delegate = self
        
        self.viewModel.addObserver(self,
                                   forKeyPath: "title",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
        
        self.viewModel.addObserver(self,
                                   forKeyPath: "mode",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
        
        self.viewModel.addObserver(self,
                                   forKeyPath: "timeInterval",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
        self.datePicker.addTarget(self.viewModel,
                                  action: #selector(self.viewModel.change(_:)),
                                  for: UIControlEvents.valueChanged)
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.viewModel.delegate = nil
        
        self.viewModel.removeObserver(self, forKeyPath: "title")
        self.viewModel.removeObserver(self, forKeyPath: "mode")
        self.viewModel.removeObserver(self, forKeyPath: "timeInterval")
        self.datePicker.removeTarget(self.viewModel,
                                     action: #selector(self.viewModel.change(_:)),
                                     for: UIControlEvents.valueChanged)
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "title")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            self.set(title: newValue)
        }
        else if (keyPath == "mode")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            
            if (self.viewModel.mode == "Date")
            {
                self._datePicker.datePickerMode = UIDatePickerMode.date
            }
            else if (self.viewModel.mode == "Time")
            {
                self._datePicker.datePickerMode = UIDatePickerMode.time
            }
            else if (self.viewModel.mode == "Interval")
            {
                self._datePicker.datePickerMode = UIDatePickerMode.countDownTimer
            }
        }
        else if (keyPath == "timeInterval")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! TimeInterval
            self.set(timeInterval: newValue)
        }
    }
    
    func set(title: String)
    {
        self.label.text = title
    }
    
    func set(timeInterval: TimeInterval)
    {
        if (self.viewModel.mode == "Date" || self.viewModel.mode == "Time")
        {
            self.datePicker.date = Date(timeIntervalSince1970: timeInterval)
        }
        else if (self.viewModel.mode == "Interval")
        {
            self.datePicker.countDownDuration = timeInterval
        }
    }

    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (transition == "Change")
        {
            if (self.viewModel.mode == "Date" || self.viewModel.mode == "Time")
            {
                self.viewModel.timeInterval = self.datePicker.date.timeIntervalSince1970
            }
            else if (self.viewModel.mode == "Interval")
            {
                self.viewModel.timeInterval = self.datePicker.countDownDuration
            }
        }
    }
}
