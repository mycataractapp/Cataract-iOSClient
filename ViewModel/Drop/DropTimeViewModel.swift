//
//  DropTimeViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/6/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DropTimeViewModel : DynamicViewModel
{
    @objc var colorPath : String
    @objc var drop : String
    @objc var time : String
    
    init(colorPath: String, drop: String, time: String)
    {
        self.colorPath = colorPath
        self.drop = drop
        self.time = time
        
        super.init()
    }

    @objc func check()
    {
        self.transit(transition: "Check", to: self.state)
    }
}
