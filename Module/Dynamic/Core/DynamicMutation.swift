//
//  DynamicMutation.swift
//  Pacific
//
//  Created by Minh Nguyen on 7/20/18.
//  Copyright © 2018 Minh Nguyen. All rights reserved.
//

import Foundation

class DynamicMutation : NSObject
{
    func execute<ModelType: DynamicModel>(operation: DynamicMutation.Operation, models: [ModelType]) -> DynamicPromise
    {
        var value : Any? = models
        
        if (models.count == 1)
        {
            value = models.first
        }
        
        let promise = DynamicPromise.resolve(value: value)
        
        return promise
    }
    
    @objc
    enum Operation : Int
    {
        case insert
        case delete
        case update
    }
}
