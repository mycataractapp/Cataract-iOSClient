//
//  DropViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/6/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DropViewModel : DynamicViewModel
{
    @objc var time : String!
    
    init(time: String)
    {
        self.time = time
        
        super.init()
    }
}
