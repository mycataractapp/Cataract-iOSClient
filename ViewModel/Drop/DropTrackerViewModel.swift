//
//  DropTrackerViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/6/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class DropTrackerViewModel : DynamicViewModel
{
    @objc dynamic var time : String!
    @objc dynamic var completionRate : Double = 0.0
    
    init(time: String)
    {
        self.time = time
        
        super.init()
    }
}
