//
//  FAQViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/4/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class FAQViewModel : DynamicViewModel
{
    @objc dynamic var heading : String!
    @objc dynamic var content : String!
    
    init(heading: String, content: String)
    {
        self.heading = heading
        self.content = content
        
        super.init()
    }
}
