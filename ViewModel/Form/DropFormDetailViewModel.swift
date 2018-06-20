//
//  DropFormDetailViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/16/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DropFormDetailViewModel : DynamicViewModel
{
    private var _dropFormInputViewModel : DropFormInputViewModel!
    private var _datePickerViewModel : DatePickerViewModel!
    private var _intervalViewModel : DatePickerViewModel!
    private var _footerPanelViewModel : FooterPanelViewModel!
    private var _weekDayOverviewViewModel : WeekDayOverviewViewModel!
    
    override init()
    {
        super.init(state: "Drop")
    }
    
    
    var dropFormInputViewModel : DropFormInputViewModel
    {
        get
        {
            if (self._dropFormInputViewModel == nil)
            {
                self._dropFormInputViewModel = DropFormInputViewModel()
            }
            
            let dropFormInputViewModel = self._dropFormInputViewModel!
            
            return dropFormInputViewModel
        }
    }
    
    var datePickerViewModel : DatePickerViewModel
    {
        get
        {
            if (self._datePickerViewModel == nil)
            {
                self._datePickerViewModel = DatePickerViewModel(mode: "Date")
            }
            
            let datePickerViewModel = self._datePickerViewModel!
            
            return datePickerViewModel
        }
    }
    
    var intervalViewModel : DatePickerViewModel
    {
        get
        {
            if (self._intervalViewModel == nil)
            {
                self._intervalViewModel = DatePickerViewModel(mode: "Timer")
            }
            
            let intervalViewModel = self._intervalViewModel!
            
            return intervalViewModel
        }
        
    }
    
    var footerPanelViewModel : FooterPanelViewModel
    {
        get
        {
            if (self._footerPanelViewModel == nil)
            {
                self._footerPanelViewModel = FooterPanelViewModel(leftTitle: "Cancel", rightTitle: "Confirm")
            }
            
            let footerPanelViewModel = self._footerPanelViewModel!
            
            return footerPanelViewModel
        }
    }
    
    var weekDayOverviewViewModel : WeekDayOverviewViewModel
    {
        get
        {
            if (self._weekDayOverviewViewModel == nil)
            {
                self._weekDayOverviewViewModel = WeekDayOverviewViewModel()
            }
            
            let weekDayOverviewViewModel = self._weekDayOverviewViewModel!
            
            return weekDayOverviewViewModel
        }
    }
    
    @objc func inputDrop()
    {
        if (state == "Date")
        {
            self.transit(transition: "InputDrop", to: "Drop")
        }
    }
    
    
    @objc func inputDate()
    {
        if (state == "Drop" || state == "Interval")
        {
            self.transit(transition: "InputDate", to: "Date")
        }
    }
    
    @objc func inputInterval()
    {
        if (state == "Date" || state == "WeekDay")
        {
            self.transit(transition: "InputInterval", to: "Interval")
        }
    }
    
    @objc func inputWeekDay()
    {
        if (state == "Interval")
        {
            self.transit(transition: "InputWeekDay", to: "WeekDay")
        }
    }
}