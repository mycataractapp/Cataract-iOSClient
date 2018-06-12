//
//  AppointmentViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/9/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class AppointmentViewModel : DynamicViewModel
{
    @objc dynamic var title : String
    @objc dynamic var date : String
    @objc dynamic var time: String
    
    init(title: String, date: String, time: String)
    {
        self.title = title
        self.date = date
        self.time = time
        
        super.init()
    }
}
