//
//  TimeOperation.swift
//  Cataract
//
//  Created by Roseanne Choi on 10/22/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import Foundation

class TimeOperation : NSObject
{
    class GetTimeModelsQuery : DynamicQuery
    {
        override func execute() -> DynamicPromise
        {
            // Read from cache
            return DynamicPromise.resolve(value: [TimeModel]())
        }
    }
}

