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
    var keyboardHeight : CGFloat!
    @objc dynamic var placeHolder : String
    
    init(placeHolder: String)
    {
        self.placeHolder = placeHolder
        
        super.init()
    }
    
    @objc func keyboardWillShow(notification: Notification)
    {
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        self.keyboardHeight = keyboardSize!.height
        
        self.transit(transition: "KeyboardWillShow", to: self.state)
    }
}
