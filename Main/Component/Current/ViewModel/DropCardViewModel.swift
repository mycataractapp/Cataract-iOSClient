//
//  DropCardViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 11/6/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DropCardViewModel : CardViewModel
{
    private var _dropsMenuOverlayViewModel : UserViewModel.DropsMenuOverlayViewModel!
    
    @objc var dropsMenuOverlayViewModel : UserViewModel.DropsMenuOverlayViewModel
    {
        get
        {
            if (self._dropsMenuOverlayViewModel == nil)
            {
                self._dropsMenuOverlayViewModel = UserViewModel.DropsMenuOverlayViewModel()
            }
            
            let dropsMenuOverlayViewModel = self._dropsMenuOverlayViewModel!
            
            return dropsMenuOverlayViewModel
        }
    }
    
    @objc func edit()
    {
        self.transit(transition: DropCardViewModel.Transition.edit, to: DropCardViewModel.State.options)
    }
    
    struct Transition
    {
        static let edit = DynamicViewModel.Transition(rawValue: "Edit")
    }
    
    struct State
    {
        static let options = DynamicViewModel.State(rawValue: "Options")
    }
}
