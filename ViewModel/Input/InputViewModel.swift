//
//  InputViewModel.swift
//  Rose
//
//  Created by Rose Choi on 5/11/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class InputViewModel : DynamicViewModel
{
    var keyboardFrame : CGRect!
    @objc dynamic var placeHolder : String
    
    init(placeHolder: String)
    {
        self.placeHolder = placeHolder
        
        super.init()
    }
    
    @objc func keyboardWillShow(notification: Notification)
    {
        self.keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue) as! CGRect
        self.transit(transition: "KeyboardWillShow", to: self.state)
    }
}
