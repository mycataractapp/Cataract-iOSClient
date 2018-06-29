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
    @objc dynamic var placeHolder : String
    
    init(placeHolder: String)
    {
        self.placeHolder = placeHolder
        
        super.init()
    }
}
