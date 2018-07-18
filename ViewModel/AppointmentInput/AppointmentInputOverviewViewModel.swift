//
//  AppointmentInputOverviewViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 7/12/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class AppointmentInputOverviewViewModel : DynamicViewModel
{
    private var _appointmentInputViewModels : [AppointmentInputViewModel]!
    
    var appointmentInputViewModels : [AppointmentInputViewModel]
    {
        get
        {
            if (self._appointmentInputViewModels == nil)
            {
                self._appointmentInputViewModels = [AppointmentInputViewModel]()
            }
            
            let appointmentInputViewModels = self._appointmentInputViewModels!
            
            return appointmentInputViewModels
        }
        
        set(newValue)
        {
            self._appointmentInputViewModels = newValue
        }
    }
    
//State is not necessary because no specific component needs to be rendered, for a specific interaction. Example, navigation needs a state because different components need to be rendered for specific reasons.
        //**UPDATE REASON, BETTER REVISION IS NEEDED.
    
    @objc func toggle(at index: Int)
    {
        for (counter, appointmentInputViewModel) in self.appointmentInputViewModels.enumerated()
        {
            if (counter != index)
            {
                appointmentInputViewModel.deselect()
            }
            else
            {
                appointmentInputViewModel.select()
            }
        }
        self.transit(transition: "Toggle", to: self.state)
    }
}
