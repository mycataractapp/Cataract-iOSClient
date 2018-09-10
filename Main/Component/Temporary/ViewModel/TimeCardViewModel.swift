//
//  TimeViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/21/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class TimeViewModel : CardViewModel
{
    @objc dynamic var time : String
    @objc dynamic var period : String
    
    init(id: Int, frame: CGRect, time: String, period: String)
    {
        self.time = time
        self.period = period
        
        super.init(id: id, frame: frame)
    }
}
