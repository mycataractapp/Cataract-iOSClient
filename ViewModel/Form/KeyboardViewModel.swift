//
//  KeyboardViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/28/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
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
}

