//
//  TestStore.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 8/30/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import Foundation

class TestStore : DynamicStore<TestModel>
{
    override var identifier: String?
    {
        get
        {
            return "TestStore"
        }
    }
    
    override func asyncGet(count: Int, info: [String : Any]?, isNetworkEnabled: Bool) -> DynamicPromise
    {
        let promise = DynamicPromise
        { (resolve, reject) in
            
            let testModels = self.decodeModels()
            
            if (testModels != nil)
            {
                resolve(testModels)
            }
            else
            {
                reject(DynamicPromiseError("error"))
            }
        }

        return promise
    }
    
    override func asyncAdd(_ model: TestModel, isNetworkEnabled: Bool) -> DynamicPromise
    {
        let promise = DynamicPromise
        { (resolve, reject) in

            self.encodeModels()
            
            resolve(model)
        }
        
        return promise
    }
}
