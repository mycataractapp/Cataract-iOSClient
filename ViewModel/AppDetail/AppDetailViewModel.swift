//
//  AppDetailViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/9/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class AppDetailViewModel : DynamicViewModel
{
    private var _dropViewModel : DropViewModel!
    private var _dropTimeOverviewViewModel : DropTimeOverviewViewModel!
    private var _appointmentViewModel : AppointmentViewModel!
    private var _appointmentTimeOverviewViewModel : AppointmentTimeOverviewViewModel!
    private var _navigationOverviewViewModel : NavigationOverviewViewModel!
    
    var dropViewModel : DropViewModel
    {
        get
        {
            if (self._dropViewModel == nil)
            {
                self._dropViewModel = DropViewModel(time: "12:00pm")
            }
            
            let dropViewModel = self._dropViewModel!
            
            return dropViewModel
        }
    }
    
    var dropTimeOverviewViewModel : DropTimeOverviewViewModel
    {
        get
        {
            if (self._dropTimeOverviewViewModel == nil)
            {
                self._dropTimeOverviewViewModel = DropTimeOverviewViewModel()
            }
            
            let dropTimeOverviewViewModel = self._dropTimeOverviewViewModel!
            
            return dropTimeOverviewViewModel
        }
    }
    
    var appointmentViewModel : AppointmentViewModel
    {
        get
        {
            if (self._appointmentViewModel == nil)
            {
                self._appointmentViewModel = AppointmentViewModel(title: "Pre-Op", date: "June 8th, 2018", time: "12:00pm")
            }
            
            let appointmentViewModel = self._appointmentViewModel!
            
            return appointmentViewModel
        }
    }
    
    var appointmentTimeOverviewViewModel : AppointmentTimeOverviewViewModel
    {
        get
        {
            if (self._appointmentTimeOverviewViewModel == nil)
            {
                self._appointmentTimeOverviewViewModel = AppointmentTimeOverviewViewModel()
            }
            
            let appointmentTimeOverviewViewModel = self._appointmentTimeOverviewViewModel!
            
            return appointmentTimeOverviewViewModel
        }
    }
    
    var navigationOverviewViewModel : NavigationOverviewViewModel
    {
        get
        {
            if (self._navigationOverviewViewModel == nil)
            {
                self._navigationOverviewViewModel = NavigationOverviewViewModel()
            }
            
            let navigationOverviewViewModel = self._navigationOverviewViewModel!
            
            return navigationOverviewViewModel
        }
    }
    
    override init()
    {
        super.init(state: "Drops")
    }
    
    
}
