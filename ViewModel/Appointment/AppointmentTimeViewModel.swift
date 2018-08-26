//
//  AppointmentTimeViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/8/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class AppointmentTimeViewModel : DynamicViewModel
{
    @objc dynamic var title : String
    @objc dynamic var date: String
    @objc dynamic var time : String
    
    init(title: String, date: String, time: String)
    {
        self.title = title
        self.date = date
        self.time = time
        
        super.init()
    }
}
