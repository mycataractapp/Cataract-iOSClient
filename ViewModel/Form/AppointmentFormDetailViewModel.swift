//
//  AppointmentFormDetailViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/15/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit
import SwiftMoment

class AppointmentFormDetailViewModel : DynamicViewModel
{
    private var _preOpInputViewModel : AppointmentInputViewModel!
    private var _firstEyeSurgeryInputViewModel : AppointmentInputViewModel!
    private var _firstPostOpInputViewModel : AppointmentInputViewModel!
    private var _secondEyeSurgeryInputViewModel : AppointmentInputViewModel!
    private var _secondPostOpInputViewModel : AppointmentInputViewModel!
    private var _appointmentInputOverviewViewModel : AppointmentInputOverviewViewModel!
    private var _inputViewModel : InputViewModel!
    private var _keyboardViewModel : KeyboardViewModel!
    private var _footerPanelViewModel : FooterPanelViewModel!
    private var _datePickerViewModel : DatePickerViewModel!
    private var _timePickerViewModel : DatePickerViewModel!

    override init()
    {
        super.init(state: "Appointment")
    }
    
    
    var preOpInputViewModel : AppointmentInputViewModel
    {
        get
        {
            if (self._preOpInputViewModel == nil)
            {
                self._preOpInputViewModel = AppointmentInputViewModel(title: "Pre-Op Clinic", isSelected: false)
            }
            
            let preOpInputViewModel = self._preOpInputViewModel!
            
            return preOpInputViewModel
        }
    }
    
    var firstEyeSurgeryInputViewModel : AppointmentInputViewModel
    {
        get
        {
            if (self._firstEyeSurgeryInputViewModel == nil)
            {
                self._firstEyeSurgeryInputViewModel = AppointmentInputViewModel(title: "First Eye Surgery", isSelected: false)
            }
            
            let firstEyeSurgeryInputViewModel = self._firstEyeSurgeryInputViewModel!
            
            return firstEyeSurgeryInputViewModel
        }
    }
    
    var firstPostOpInputViewModel : AppointmentInputViewModel
    {
        get
        {
            if (self._firstPostOpInputViewModel == nil)
            {
                self._firstPostOpInputViewModel = AppointmentInputViewModel(title: "Post-Op 1", isSelected: false)
            }
            
            let firstPostOpInputViewModel = self._firstPostOpInputViewModel!
            
            return firstPostOpInputViewModel
        }
    }
    
    var secondEyeSurgeryViewModel : AppointmentInputViewModel
    {
        get
        {
            if (self._secondEyeSurgeryInputViewModel == nil)
            {
                self._secondEyeSurgeryInputViewModel = AppointmentInputViewModel(title: "Second Eye Surgery", isSelected: false)
            }
            
            let secondEyeSurgeryInputViewModel = self._secondEyeSurgeryInputViewModel!
            
            return secondEyeSurgeryInputViewModel
        }
    }
    
    var secondPostOpInputViewModel : AppointmentInputViewModel
    {
        get
        {
            if (self._secondPostOpInputViewModel == nil)
            {
                self._secondPostOpInputViewModel = AppointmentInputViewModel(title: "Post-Op 2", isSelected: false)
            }
            
            let secondPostOpInputViewModel = self._secondPostOpInputViewModel!
            
            return secondPostOpInputViewModel
        }
    }
    
    var appointmentInputOverviewViewModel : AppointmentInputOverviewViewModel
    {
        get
        {
            if (self._appointmentInputOverviewViewModel == nil)
            {
                self._appointmentInputOverviewViewModel = AppointmentInputOverviewViewModel()
                self._appointmentInputOverviewViewModel.appointmentInputViewModels.append(self.preOpInputViewModel)
                self._appointmentInputOverviewViewModel.appointmentInputViewModels.append(self.firstEyeSurgeryInputViewModel)
                self._appointmentInputOverviewViewModel.appointmentInputViewModels.append(self.firstPostOpInputViewModel)
                self._appointmentInputOverviewViewModel.appointmentInputViewModels.append(self.secondEyeSurgeryViewModel)
                self._appointmentInputOverviewViewModel.appointmentInputViewModels.append(self.secondPostOpInputViewModel)
            }
            
            let appointmentInputOverviewViewModel = self._appointmentInputOverviewViewModel!
            
            return appointmentInputOverviewViewModel
        }
    }
    
    var inputViewModel : InputViewModel
    {
        get
        {
            if (self._inputViewModel == nil)
            {
                self._inputViewModel = InputViewModel(placeHolder: "Example : Follow-Up 1", value: "")
            }
            
            let inputViewModel = self._inputViewModel!
            
            return inputViewModel
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
    
    var datePickerViewModel : DatePickerViewModel
    {
        get
        {
            if (self._datePickerViewModel == nil)
            {
                self._datePickerViewModel = DatePickerViewModel(title: "Set appointment date", mode: "Date", timeInterval: Date().timeIntervalSince1970)
            }
            
            let datePickerViewModel = self._datePickerViewModel!
            
            return datePickerViewModel
        }
    }
    
    var timePickerViewModel : DatePickerViewModel
    {
        get
        {
            if (self._timePickerViewModel == nil)
            {
                self._timePickerViewModel = DatePickerViewModel(title: "Set time of appointment", mode: "Time", timeInterval: Date().timeIntervalSince1970)
            }
            
            let timePickerViewModel = self._timePickerViewModel!
            
            return timePickerViewModel
        }
    }
    
    @objc func previewAppointment()
    {
        if (self.state == "Date" || self.state == "Custom")
        {
            self.transit(transition: "PreviewAppointment", to: "Appointment")
        }
    }
    
    @objc func customizeAppointment()
    {
        if (self.state == "Appointment")
        {
            self.transit(transition: "CustomizeAppointment", to: "Custom")
        }
    }
    
    @objc func inputDate()
    {
        if (self.state == "Appointment" || self.state == "Custom")
        {
            self.transit(transition: "InputDate", to: "Date")
        }
    }
    
    @objc func createAppointment()
    {
        if (self.state == "Date")
        {
            self.transit(transition: "CreateAppointment", to: "Completion")
        }
    }
    
    @objc func exitAppointment()
    {
        if (self.state == "Appointment")
        {
            self.transit(transition: "ExitAppointment", to: "Cancellation")
        }
    }
}
