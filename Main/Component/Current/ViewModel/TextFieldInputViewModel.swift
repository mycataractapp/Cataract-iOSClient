//
//  TextFieldInputViewModel.swift
//  Cataract
//
//  Created by Minh Nguyen on 9/10/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import Foundation

class TextFieldInputViewModel : DynamicViewModel
{
    @objc dynamic var placeHolder : String
    @objc dynamic var value : String
    
    init(placeHolder: String, value: String)
    {
        self.placeHolder = placeHolder
        self.value = value
        
        super.init()
    }
    
    @objc func change(notification: Notification)
    {
        self.transit(transition: TextFieldInputViewModel.Transition.change, to: self.state)
    }
    
    struct Transition
    {
        static let change = DynamicViewModel.Transition(rawValue: "Change")
    }
}
