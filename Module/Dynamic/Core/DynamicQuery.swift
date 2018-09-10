//
//  DynamicQuery.swift
//  Pacific
//
//  Created by Minh Nguyen on 8/15/18.
//  Copyright © 2018 Minh Nguyen. All rights reserved.
//

import Foundation

class DynamicQuery : NSObject
{
    private var _limit : Int
    private var _offset : Int
    private var _models : [DynamicModel]!
    
    override init()
    {
        self._limit = 0
        self._offset = 0
        
        super.init()
    }
    
    init(limit: Int, offset: Int)
    {
        self._limit = limit
        self._offset = offset
    }
    
    init(models: [DynamicModel])
    {
        self._limit = models.count
        self._offset = 0
        self._models = models
    }
    
    var limit : Int
    {
        get
        {
            let limit = self._limit
            
            return limit
        }
        
        set(newValue)
        {
            self._limit = newValue
        }
    }
    
    var offset : Int
    {
        get
        {
            let offset = self._offset
            
            return offset
        }
        
        set(newValue)
        {
            self._offset = newValue
        }
    }
    
    var models : [DynamicModel]
    {
        get
        {
            if (self._models == nil)
            {
                self._models = [DynamicModel]()
            }
            
            let models = self._models!
            
            return models
        }
    }
    
    func execute() -> DynamicPromise
    {
        let promise = DynamicPromise.resolve(value: self.models)
        
        return promise
    }
}
