//
//  CarePlanStore.swift
//  Cataract
//
//  Created by Roseanne Choi on 11/16/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import Foundation
import CareKit

class CarePlanStore : NSObject, OCKCarePlanStoreDelegate, OCKCareCardViewControllerDelegate
{
    private var _ockCarePlanStore : OCKCarePlanStore!
    
    var ockCarePlanStore : OCKCarePlanStore
    {
        get
        {
            if (self._ockCarePlanStore == nil)
            {
                let path = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0].appendingPathComponent("OCKCarePlanStore").path
                let url = URL(fileURLWithPath: path)
                
                if !FileManager.default.fileExists(atPath: url.path)
                {
                    try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                }
                
                self._ockCarePlanStore = OCKCarePlanStore(persistenceDirectoryURL: url)
                self._ockCarePlanStore.delegate = self
            }
            
            let ockCarePlanStore = self._ockCarePlanStore!
                        
            return ockCarePlanStore
        }
    }
}
