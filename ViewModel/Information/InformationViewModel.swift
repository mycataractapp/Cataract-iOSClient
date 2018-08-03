//
//  InformationViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/24/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class InformationViewModel : DynamicViewModel
{
    @objc dynamic var title : String!
    
    init(title: String)
    {
        self.title = title
        
        super.init()
    }
}
