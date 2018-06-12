//
//  NavigationOverviewViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/9/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class NavigationOverviewViewModel : DynamicViewModel
{
    private var _navigationViewModels : [NavigationViewModel]!
    
    var navigationViewModels : [NavigationViewModel]
    {
        get
        {
            if (self._navigationViewModels == nil)
            {
                self._navigationViewModels = [NavigationViewModel]()
            }
            
            let navigationViewModels = self._navigationViewModels!
            
            return navigationViewModels
        }
        
        set(newValue)
        {
            self._navigationViewModels = newValue
        }
    }
    
    func selectDrop()
    {
        self.transit(transition: "SelectDrop", to: self.state)
    }
    
    func selectAppointment()
    {
        self.transit(transition: "SelectAppointment", to: self.state)
    }
}
