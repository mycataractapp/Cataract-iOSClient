//
//  AppointmentTimeViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/8/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class AppointmentTimeViewModel : DynamicViewModel
{
    @objc dynamic var title : String
    @objc dynamic var date: String
    @objc dynamic var time : String
    @objc dynamic var period : String
    
    init(title: String, date: String, time: String, period: String)
    {
        self.title = title
        self.date = date
        self.time = time
        self.period = period
        
        super.init()
    }
}
