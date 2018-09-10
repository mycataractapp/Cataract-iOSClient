//
//  ContactOperation.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/27/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import Foundation

class ContactOperation : NSObject
{
    class GetContactModelsQuery : DynamicQuery
    {
        override func execute() -> DynamicPromise
        {
            // Read from cache
            return DynamicPromise.resolve(value: nil)
        }
    }
}
