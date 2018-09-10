//
//  AppointmentViewModel.swift
//  Cataract
//
//  Created by Minh Nguyen on 9/8/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import Foundation

class AppointmentTimeViewModel : DynamicViewModel
{
    @objc dynamic var title : String
    @objc dynamic var date: String
    @objc dynamic var time : String
    var id : String
    
    init(title: String, date: String, time: String, id: String)
    {
        self.title = title
        self.date = date
        self.time = time
        self.id = id
        
        super.init()
    }
    
    @objc func remove()
    {
        self.transit(transition: "Remove", to: self.state)
    }
}
