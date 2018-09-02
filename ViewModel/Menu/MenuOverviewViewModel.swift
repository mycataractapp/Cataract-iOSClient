//
//  MenuOverviewViewModel.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 8/26/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class MenuOverviewViewModel : DynamicViewModel
{
    private var _menuViewModels : [MenuViewModel]!
    private var _states : [String]!
    
    init(states: [String])
    {
        self._states = states
        
        super.init()
    }
    
    var menuViewModels : [MenuViewModel]
    {
        get
        {
            if (self._menuViewModels == nil)
            {
                self._menuViewModels = [MenuViewModel]()
            }
            
            let menuViewModels = self._menuViewModels!
            
            return menuViewModels
        }
        
        set(newValue)
        {
            self._menuViewModels = newValue
        }
    }
    
    @objc func toggle(at index: Int)
    {
        for (counter, menuViewModel) in self.menuViewModels.enumerated()
        {
            if (counter != index)
            {
                menuViewModel.deselect()
            }
            else
            {
                menuViewModel.select()
            }
        }
        
        self.transit(transition: "Toggle", to: self.state)
    }
}
