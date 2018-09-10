//
//  FooterPanelViewModel.swift
//  Rose
//
//  Created by Roseanne Choi on 5/11/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class FooterPanelViewModel : DynamicViewModel
{
    @objc dynamic var leftTitle : String!
    @objc dynamic var rightTitle : String!
    
    init(leftTitle: String, rightTitle: String)
    {
        self.leftTitle = leftTitle
        self.rightTitle = rightTitle
        
        super.init()
    }
    
    @objc func confirm()
    {
        self.transit(transition: "Confirm", to: self.state)
    }
    
    @objc func cancel()
    {
        self.transit(transition: "Cancel", to: self.state)
    }
}
