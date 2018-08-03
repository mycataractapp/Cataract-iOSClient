//
//  TimeStampViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/25/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class TimeStampViewModel : DynamicViewModel
{
    @objc dynamic var title : String!
    @objc dynamic var display : String!
    
    init(title: String, display: String)
    {
        self.title = title
        self.display = display
        
        super.init()
    }
    
    @objc func edit()
    {
        self.transit(transition: "Edit", to: self.state)
    }
}
