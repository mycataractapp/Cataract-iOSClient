//
//  DropFormViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/13/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DropFormViewModel : DynamicViewModel
{
    @objc dynamic var name : String!
    
    init(name: String)
    {
        self.name = name
        
        super.init()
    }
}
