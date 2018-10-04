//
//  TextFieldInputViewModel.swift
//  Cataract
//
//  Created by Minh Nguyen on 9/10/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class TextFieldInputViewModel : CardViewModel
{
    @objc dynamic var placeHolder : String
    @objc dynamic var value : String
    
    init(placeHolder: String, value: String, id: String)
    {
        self.placeHolder = placeHolder
        self.value = value
        
        super.init(id: id)
    }
    
    @objc func change()
    {
        self.transit(transition: TextFieldInputViewModel.Transition.change,
                     to: DynamicViewModel.State(rawValue: "Keyboard"))
    }
    
    struct Transition
    {
        static let change = DynamicViewModel.Transition(rawValue: "Change")
    }
}
