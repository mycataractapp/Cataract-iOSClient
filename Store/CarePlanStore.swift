//
//  CarePlanStore.swift
//  Cataract
//
//  Created by Rose Choi on 7/13/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftMoment
import CareKit

class CarePlanStore : DynamicStore<DynamicModel>, OCKCarePlanStoreDelegate
{
    private var _store : OCKCarePlanStore!
    
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
}

