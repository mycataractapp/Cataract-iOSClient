//
//  DropTrackerViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/6/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
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
