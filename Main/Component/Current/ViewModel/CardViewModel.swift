//
//  CardViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class CardViewModel : DynamicViewModel
{
    private var _id : String
    var size = CGSize.zero
    
    init(id: String)
    {
        self._id = id
        
        super.init()
    }
    
    init(id: String, state: DynamicViewModel.State)
    {
        self._id = id
        
        super.init(state: state)
    }
    
    var id : String
    {
        get
        {
            let id = self._id
            
            return id
        }
    }
}
