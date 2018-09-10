//
//  AppointmentOverviewViewModel.swift
//  Cataract
//
//  Created by Minh Nguyen on 9/8/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import Foundation

class AppointmentTimeOverviewViewModel : DynamicViewModel
{
    var selectId : String!
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
    
    @objc func Delete()
    {
        self.transit(transition: "Delete", to: self.state)
    }
}
