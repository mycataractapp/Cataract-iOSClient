//
//  TimeViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/21/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class TimeViewModel : DynamicViewModel
{
    @objc dynamic var time : String
    @objc dynamic var period : String
    
    init(time: String, period: String)
    {
        self.time = time
        self.period = period
        
        super.init()
    }
}
