//
//  ContactsInputViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 7/27/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class ContactsInputViewModel : DynamicViewModel, UITextFieldDelegate
{
    @objc dynamic var title : String
    private var _inputViewModel : InputViewModel!
    
    init(title: String)
    {
        self.title = title
        
        super.init()
    }
    
    var inputViewModel : InputViewModel
    {
        get
        {
            if (self._inputViewModel == nil)
            {
                self._inputViewModel = InputViewModel(placeHolder: "", value: "")
            }
            
            let inputViewModel = self._inputViewModel!
            
            return inputViewModel
        }
    }
}
