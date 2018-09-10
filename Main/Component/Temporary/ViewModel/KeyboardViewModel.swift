//
//  KeyboardViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/28/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class KeyboardViewModel : DynamicViewModel
{
    var keyboardFrame : CGRect!
    
    @objc func keyboardWillShow(notification: Notification)
    {
        self.keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue) as! CGRect
        self.transit(transition: "KeyboardWillShow", to: self.state)
    }
    
    @objc func keyboardWillResign(notification: Notification)
    {
        self.keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue) as! CGRect
        self.transit(transition: "KeyboardWillResign", to: self.state)
    }
}

