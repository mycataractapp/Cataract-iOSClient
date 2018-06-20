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
    private var _states : [String]!
    
    init(states: [String])
    {
        self._states = states
        
        super.init()
    }
    
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
    
    func toggle(at index: Int)
    {
        for (counter, navigationViewModel) in self.navigationViewModels.enumerated()
        {            
            if (counter != index)
            {
                navigationViewModel.deselect()
            }
            else
            {
                navigationViewModel.select()
            }
        }
        
        self.transit(transition: "Toggle", to: self._states[index])
    }
}
