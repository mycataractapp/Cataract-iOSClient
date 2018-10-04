//
//  FooterPanelViewModel.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 9/25/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class FooterPanelViewModel : CardViewModel
{
    @objc func back()
    {
        self.transit(transition: FooterPanelViewModel.Transition.back,
                     to: FooterPanelViewModel.State.left)
    }
    
    @objc func next()
    {
        self.transit(transition: FooterPanelViewModel.Transition.next,
                     to: FooterPanelViewModel.State.right)
    }
    
    struct Transition
    {
        static let back = DynamicViewModel.Transition(rawValue: "Back")
        static let next = DynamicViewModel.Transition(rawValue: "Next")
    }
    
    struct State
    {
        static let left = DynamicViewModel.State(rawValue: "Left")
        static let right = DynamicViewModel.State(rawValue: "Right")
    }
}
