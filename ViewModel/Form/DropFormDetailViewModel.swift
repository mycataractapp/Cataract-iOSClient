//
//  DropFormDetailViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/16/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import SwiftMoment

class DropFormDetailViewModel : DynamicViewModel
{
    private var _dropFormInputViewModel : DropFormInputViewModel!
    private var _startDateViewModel : DatePickerViewModel!
    private var _endDateViewModel : DatePickerViewModel!
    private var _timePickerViewModel : DatePickerViewModel!
    private var _timeIntervalViewModel : DatePickerViewModel!
    private var _inputViewModel : InputViewModel!
    private var _timeOverviewViewModel: TimeOverviewViewModel!
    private var _timeStampOverviewViewModel : TimeStampOverviewViewModel!
    private var _footerPanelViewModel : FooterPanelViewModel!
    private var _timeFooterPanelViewModel : FooterPanelViewModel!
    private var _startTimeStampViewModel : TimeStampViewModel!
    private var _intervalTimeStampViewModel : TimeStampViewModel!
    private var _repeatTimeStampViewModel : TimeStampViewModel!
    private var _keyboardViewModel : KeyboardViewModel!
    
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
    
    var startDateViewModel : DatePickerViewModel
    {
        get
        {
            if (self._startDateViewModel == nil)
            {
                self._startDateViewModel = DatePickerViewModel(title: "Choose a date to begin", mode: "Date", timeInterval: Date().timeIntervalSince1970)
            }
            
            let startDateViewModel = self._startDateViewModel!
            
            return startDateViewModel
        }
    }
    
    var endDateViewModel : DatePickerViewModel
    {
        get
        {
            if (self._endDateViewModel == nil)
            {
                self._endDateViewModel = DatePickerViewModel(title: "Choose a date to end", mode: "Date", timeInterval: Date().timeIntervalSince1970)
            }
            
            let endDateViewModel = self._endDateViewModel!
            
            return endDateViewModel
        }
    }
    
    var timePickerViewModel : DatePickerViewModel
    {
        get
        {
            if (self._timePickerViewModel == nil)
            {
                let aMoment = moment("08:00:00")
                
                self._timePickerViewModel = DatePickerViewModel(title: "Choose a start time", mode: "Time", timeInterval: aMoment!.date.timeIntervalSince1970)
            }
            
            let timePickerViewModel = self._timePickerViewModel!
            
            return timePickerViewModel
        }
    }
    
    var timeIntervalViewModel : DatePickerViewModel
    {
        get
        {
            if (self._timeIntervalViewModel == nil)
            {
                let aDuration = 4.hours 
                self._timeIntervalViewModel = DatePickerViewModel(title: "After every hour", mode: "Interval", timeInterval: aDuration.seconds)
            }
            
            let timeIntervalViewModel = self._timeIntervalViewModel!
            
            return timeIntervalViewModel
        }
    }
    
    var inputViewModel : InputViewModel
    {
        get
        {
            if (self._inputViewModel == nil)
            {
                self._inputViewModel = InputViewModel(placeHolder: "", value: "4")
            }
            
            let inputViewModel = self._inputViewModel!
            
            return inputViewModel
        }
    }
    
    var timeOverviewViewModel : TimeOverviewViewModel
    {
        get
        {
            if (self._timeOverviewViewModel == nil)
            {
                self._timeOverviewViewModel = TimeOverviewViewModel()
            }
            
            let timeOverviewViewModel = self._timeOverviewViewModel!
            
            return timeOverviewViewModel
        }
    }
    
    var timeStampOverviewViewModel : TimeStampOverviewViewModel
    {
        get
        {
            if (self._timeStampOverviewViewModel == nil)
            {
                self._timeStampOverviewViewModel = TimeStampOverviewViewModel()
                self.timeStampOverviewViewModel.timeStampViewModels.append(self.startTimeStampViewModel)
                self.timeStampOverviewViewModel.timeStampViewModels.append(self.intervalTimeStampViewModel)
                self.timeStampOverviewViewModel.timeStampViewModels.append(self.repeatTimeStampViewModel)
            }
            
            let timeStampOverviewViewModel = self._timeStampOverviewViewModel!
            
            return timeStampOverviewViewModel
        }
    }
    
    var footerPanelViewModel : FooterPanelViewModel
    {
        get
        {
            if (self._footerPanelViewModel == nil)
            {
                self._footerPanelViewModel = FooterPanelViewModel(leftTitle: "Back", rightTitle: "Next")
            }
            
            let footerPanelViewModel = self._footerPanelViewModel!
            
            return footerPanelViewModel
        }
    }
    
    var timeFooterPanelViewModel : FooterPanelViewModel
    {
        get
        {
            if (self._timeFooterPanelViewModel == nil)
            {
                self._timeFooterPanelViewModel = FooterPanelViewModel(leftTitle: "Cancel", rightTitle: "Confirm")
            }
            
            let timeFooterPanelViewModel = self._timeFooterPanelViewModel!
            
            return timeFooterPanelViewModel
        }
    }
    
    var startTimeStampViewModel : TimeStampViewModel
    {
        get
        {
            if (self._startTimeStampViewModel == nil)
            {
                self._startTimeStampViewModel = TimeStampViewModel(title: "Set Start Time", display: "8:00")
            }
            
            let startTimeStampViewModel = self._startTimeStampViewModel!
            
            return startTimeStampViewModel
        }
    }
    
    var intervalTimeStampViewModel : TimeStampViewModel
    {
        get
        {
            if (self._intervalTimeStampViewModel == nil)
            {
                self._intervalTimeStampViewModel = TimeStampViewModel(title: "Set Interval", display: "4")
            }
            
            let intervalTimeStampViewModel = self._intervalTimeStampViewModel!
            
            return intervalTimeStampViewModel
        }
    }
    
    var repeatTimeStampViewModel : TimeStampViewModel
    {
        get
        {
            if (self._repeatTimeStampViewModel == nil)
            {
                self._repeatTimeStampViewModel = TimeStampViewModel(title: "Repeat", display: "4")
            }
            
            let repeatTimeStampViewModel = self._repeatTimeStampViewModel!
            
            return repeatTimeStampViewModel
        }
    }
    
    var keyboardViewModel : KeyboardViewModel
    {
        get
        {
            if (self._keyboardViewModel == nil)
            {
                self._keyboardViewModel = KeyboardViewModel()
            }
            
            let keyboardViewModel = self._keyboardViewModel!
            
            return keyboardViewModel
        }
    }
    
    @objc func inputDrop()
    {
        if (self.state == "Date")
        {
            self.transit(transition: "InputDrop", to: "Drop")
        }
    }

    @objc func inputDate()
    {
        if (self.state == "Drop" || self.state == "Schedule")
        {
            self.transit(transition: "InputDate", to: "Date")
        }
    }
    
    @objc func previewSchedule()
    {
        if (self.state == "Date" || self.state == "StartTime" || self.state == "IntervalTime" || self.state == "RepeatTime")
        {
            self.transit(transition: "PreviewSchedule", to: "Schedule")
        }
    }

    @objc func inputStartTime()
    {
        if (self.state == "Schedule")
        {
            self.transit(transition: "InputStartTime", to: "StartTime")
        }
    }
    
    @objc func inputIntervalTime()
    {
        if (self.state == "Schedule")
        {
            self.transit(transition: "InputIntervalTime", to: "IntervalTime")
        }
    }
    
    @objc func inputRepeatTime()
    {
        if (self.state == "Schedule")
        {
            self.transit(transition: "InputRepeatTime", to: "RepeatTime")
        }
    }
    
    func createDrop()
    {
        if (self.state == "Schedule")
        {
            self.transit(transition: "CreateDrop", to: "Main")
        }
    }
}
