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
    private var _dropsMenuOverlayViewModel : UserViewModel.MenuOverlayViewModel!
    
    @objc var dropsMenuOverlayViewModel : UserViewModel.MenuOverlayViewModel
    {
        get
        {
            if (self._dropsMenuOverlayViewModel == nil)
            {
                self._dropsMenuOverlayViewModel = UserViewModel.MenuOverlayViewModel()
            }
            
            let dropsMenuOverlayViewModel = self._dropsMenuOverlayViewModel!
            
            return dropsMenuOverlayViewModel
        }
    }
    
    @objc func enterMenu()
    {
        self.transit(transition: DropCardViewModel.Transition.enterMenu, to: DropCardViewModel.State.options)
    }
    
    struct Transition
    {
        static let enterMenu = DynamicViewModel.Transition(rawValue: "EnterMenu")
    }
    
    struct State
    {
        static let options = DynamicViewModel.State(rawValue: "Options")
    }
}
