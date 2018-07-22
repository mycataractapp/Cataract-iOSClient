//
//  AppointmentTimeOverviewViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/8/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class AppointmentTimeOverviewViewModel : DynamicViewModel
{
    private var _appointmentTimeOverviewViewModels : [AppointmentTimeViewModel]!
    
    var appointmentTimeViewModels : [AppointmentTimeViewModel]
    {
        get
        {
            if (self._appointmentTimeOverviewViewModels == nil)
            {
                self._appointmentTimeOverviewViewModels = [AppointmentTimeViewModel]()
            }
            
            let appointmentTimeOverviewViewModels = self._appointmentTimeOverviewViewModels!
            
            return appointmentTimeOverviewViewModels
        }
        
        set(newValue)
        {
            self._appointmentTimeOverviewViewModels = newValue
        }
    }
    
    @objc func addAppointment()
    {
        self.transit(transition: "AddAppointment", to: self.state)
    }
}
