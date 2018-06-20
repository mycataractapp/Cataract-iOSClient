//
//  DatePickerViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/18/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DatePickerViewModel : DynamicViewModel
{
    @objc dynamic var mode : String!
    
    init(mode: String)
    {
        self.mode = mode
        
        super.init()
    }
    
    @objc func changeDate(_ sender: UIDatePicker)
    {
        self.transit(transition: "ChangeDate", to: self.state)
    }
}
