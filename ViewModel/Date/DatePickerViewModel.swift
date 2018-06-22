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
    @objc dynamic var title : String!
    @objc dynamic var mode : String!
    
    init(title: String, mode: String)
    {
        self.title = title
        self.mode = mode
        
        super.init()
    }
    
    @objc func changeDate(_ sender: UIDatePicker)
    {
        self.transit(transition: "ChangeDate", to: self.state)
    }
}
