//
//  InputViewModel.swift
//  Rose
//
//  Created by Roseanne Choi on 5/11/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class InputViewModel : DynamicViewModel
{
    @objc dynamic var placeHolder : String
    @objc dynamic var value : String
    
    init(placeHolder: String, value: String)
    {
        self.placeHolder = placeHolder
        self.value = value
        
        super.init()
    }
    
    @objc func textFieldTextDidChange(notification: Notification)
    {
        self.transit(transition: "TextFieldTextDidChange", to: self.state)
    }
}
