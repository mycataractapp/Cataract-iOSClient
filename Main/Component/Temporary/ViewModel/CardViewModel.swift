//
//  CardViewModel.swift
//  Cataract
//
//  Created by Minh Nguyen on 9/9/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class CardViewModel : DynamicViewModel
{
    private var _id : Int
    private var _frame : CGRect
    
    init(id: Int, frame: CGRect)
    {
        self._id = id
        self._frame = frame
        
        super.init()
    }
    
    init(id: Int, frame: CGRect, state: DynamicViewModel.State)
    {
        self._id = id
        self._frame = frame
        
        super.init(state: state)
    }
    
    var id : Int
    {
        get
        {
            let id = self._id
            
            return id
        }
    }
    
    var frame : CGRect
    {
        get
        {
            let frame = self._frame
            
            return frame
        }
    }
}
