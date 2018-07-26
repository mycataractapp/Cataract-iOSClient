//
//  InformationViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 7/24/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
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
