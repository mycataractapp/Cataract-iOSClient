//
//  DatePickerViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/18/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class DatePickerViewModel : DynamicViewModel
{
    @objc dynamic var title : String!
    @objc dynamic var mode : String!
    @objc dynamic var timeInterval : TimeInterval
    
    init(title: String, mode: String, timeInterval: TimeInterval)
    {
        self.title = title
        self.mode = mode
        self.timeInterval = timeInterval
        
        super.init()
    }

    @objc func change(_ sender: UIDatePicker)
    {
        self.transit(transition: "Change", to: self.state)
    }
}
