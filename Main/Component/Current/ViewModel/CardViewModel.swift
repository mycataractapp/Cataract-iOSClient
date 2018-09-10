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
    private var _size : CGSize
    
    init(id: String, size: CGSize)
    {
        self._id = id
        self._size = size
        
        super.init()
    }
    
    init(id: String, size: CGSize, state: DynamicViewModel.State)
    {
        self._id = id
        self._size = size
        
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
    
    var size : CGSize
    {
        get
        {
            let size = self._size
            
            return size
        }
    }
}
