//
//  DatePickerInputViewModel.swift
//  Cataract
//
//  Created by Minh Nguyen on 9/10/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DatePickerInputViewModel : DynamicViewModel
{
    var size = CGSize.zero
    @objc dynamic var mode : DatePickerInputViewModel.Mode
    @objc dynamic var timeInterval : TimeInterval
    
    init(mode: DatePickerInputViewModel.Mode, timeInterval: TimeInterval)
    {
        self.mode = mode
        self.timeInterval = timeInterval
        
        super.init()
    }
    
    @objc func change(_ sender: UIDatePicker)
    {
        self.transit(transition: TextFieldInputViewModel.Transition.change, to: self.state)
    }
    
    struct Transition
    {
        static let change = DynamicViewModel.Transition(rawValue: "Change")
    }
    
    @objc enum Mode : Int
    {
        case date
        case time
        case interval
    }
}

