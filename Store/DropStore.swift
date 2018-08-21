//
//  DropStore.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import Foundation
import SwiftyJSON
import CareKit

class DropStore : DynamicStore<DropModel>, OCKCarePlanStoreDelegate
{
    private var _store : OCKCarePlanStore!
    
    override var identifier: String?
    {
        get
        {
            return "DropStore"
        }
    }

    var store : OCKCarePlanStore
    {
        get
        {
            if (self._store == nil)
            {
                let path = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0].appendingPathComponent("DropStore").path
                let url = URL(fileURLWithPath: path)

                if !FileManager.default.fileExists(atPath: url.path)
                {
                    try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                }

                self._store = OCKCarePlanStore(persistenceDirectoryURL: url)
                self._store.delegate = self
            }

            let store = self._store!

            return store
        }
    }
    
//    override func asyncGet(count: Int, info: [String : Any]?, isNetworkEnabled: Bool) -> DynamicPromise
//    {
//        let promise = DynamicPromise
//        { (resolve, reject) in
//
//            let models = self.decodeModels()
//
//            if (models != nil)
//            {
//                resolve(models)
//            }
//            else
//            {
//                reject(DynamicPromiseError("Something went wrong"))
//            }
//        }
//
//        return promise
//    }

    override func asyncAdd(_ model: DropModel, isNetworkEnabled: Bool) -> DynamicPromise
    {
        let promise = DynamicPromise
        { (resolve, reject) in

            self.store.add(model.activity, completion:
            { (isCompleted, error) in

                resolve(model)
//                DispatchQueue.main.async
//                {
//                    self.encodeModels()
//                    resolve(model)
//                }
            })
        }

        return promise
    }
}


