//
//  FaqViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/4/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class FaqViewModel : DynamicViewModel
{
    @objc dynamic var heading : String!
    @objc dynamic var info : String!
    
    init(heading: String, info: String)
    {
        self.heading = heading
        self.info = info
        
        super.init()
    }
}
