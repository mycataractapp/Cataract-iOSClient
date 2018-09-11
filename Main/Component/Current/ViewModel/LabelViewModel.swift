//
//  LabelViewModel.swift
//  Cataract
//
//  Created by Minh Nguyen on 9/10/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class LabelViewModel : DynamicViewModel
{
    var size : CGSize
    @objc dynamic var text : String!
    @objc dynamic var color : ColorCardViewModel!
    
    init(text: String, color: ColorCardViewModel, size: CGSize)
    {
        self.text = text
        self.color = color
        self.size = size
        
        super.init()
    }
}
