//
//  NavigationViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/9/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class NavigationViewModel : DynamicViewModel
{
    @objc dynamic var imagePath : String
    
    init(imagePath: String)
    {
        self.imagePath = imagePath
        
        super.init()
    }
}
