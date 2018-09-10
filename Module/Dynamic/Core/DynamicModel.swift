//
//  DynamicModel.swift
//  Pacific
//
//  Created by Minh Nguyen on 8/31/16.
//  Copyright © 2017 Langtutheky. All rights reserved.
//

import Foundation

class DynamicModel : NSObject
{
    private var _id : String!
    
    override init()
    {
        super.init()
    }
    
    init(id: String)
    {
        self._id = id
        
        super.init()
    }
    
    var id : String
    {
        get
        {
            if (self._id == nil)
            {
                self._id = UUID().uuidString
            }
            
            let id = self._id!
            
            return id
        }
    }
}

