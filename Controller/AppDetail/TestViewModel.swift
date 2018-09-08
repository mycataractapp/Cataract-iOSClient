//
//  TestViewModel.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 9/4/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class TestViewModel : DynamicViewModel
{
    @objc dynamic var title : String
    
    init(title: String)
    {
        self.title = title
        
        super.init()
    }
}
