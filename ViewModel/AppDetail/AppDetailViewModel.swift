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
    private var _dropTrackerViewModel : DropTrackerViewModel!
    private var _dropOverviewViewModel : DropOverviewViewModel!
    private var _appointmentViewModel : AppointmentViewModel!
    private var _appointmentTimeOverviewViewModel : AppointmentTimeOverviewViewModel!
    private var _navigationOverviewViewModel : NavigationOverviewViewModel!
    private var _informationOverviewViewModel : InformationOverviewViewModel!
    
    override init()
    {
        super.init(state: "Drops")
    }
    
    var dropTrackerViewModel : DropTrackerViewModel
    {
        get
        {
            if (self._dropTrackerViewModel == nil)
            {
                self._dropTrackerViewModel = DropTrackerViewModel(time: "12:00pm")
            }
            
            let dropTrackerViewModel = self._dropTrackerViewModel!
            
            return dropTrackerViewModel
        }
    }
    
    var dropOverviewViewModel : DropOverviewViewModel
    {
        get
        {
            if (self._dropOverviewViewModel == nil)
            {
                self._dropOverviewViewModel = DropOverviewViewModel()
            }
            
            let dropOverviewViewModel = self._dropOverviewViewModel!
            
            return dropOverviewViewModel
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
                self._navigationOverviewViewModel = NavigationOverviewViewModel(states: ["Drop", "Appointment", "Information"])
                
                var navigationViewModel : NavigationViewModel!

                for index in 0...2
                {
                    if (index == 0)
                    {
                        let imagePathByState = ["On": Bundle.main.path(forResource: "DropOn", ofType: "png")!,
                                                "Off": Bundle.main.path(forResource: "DropOff", ofType: "png")!]

                        navigationViewModel = NavigationViewModel(imagePathByState: imagePathByState, isSelected: true)
                    }
                    else if (index == 1)
                    {
                        let imagePathByState = ["On": Bundle.main.path(forResource: "AppointmentOn", ofType: "png")!,
                                                "Off": Bundle.main.path(forResource: "AppointmentOff", ofType: "png")!]
                        
                        navigationViewModel = NavigationViewModel(imagePathByState: imagePathByState, isSelected: false)
                    }
                    else if (index == 2)
                    {
                        let imagePathByState = ["On": Bundle.main.path(forResource: "InformationOn", ofType: "png")!,
                                                "Off": Bundle.main.path(forResource: "InformationOff", ofType: "png")!]
                        navigationViewModel = NavigationViewModel(imagePathByState: imagePathByState, isSelected: false)
                    }

                    self.navigationOverviewViewModel.navigationViewModels.append(navigationViewModel)
                }
            }
            
            let navigationOverviewViewModel = self._navigationOverviewViewModel!
            
            return navigationOverviewViewModel
        }
    }
    
    var informationOverviewViewModel : InformationOverviewViewModel
    {
        get
        {
            if (self._informationOverviewViewModel == nil)
            {
                self._informationOverviewViewModel = InformationOverviewViewModel()
            }
            
            let informationOverviewViewModel = self._informationOverviewViewModel!
            
            return informationOverviewViewModel
        }
    }
}
