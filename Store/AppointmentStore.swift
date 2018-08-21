//
//  AppointmentStore.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/11/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import Foundation
import SwiftyJSON

class AppointmentStore : DynamicStore<AppointmentModel>
{
    override var identifier: String?
    {
        get
        {
            return "AppointmentStore"
        }
    }
    
    override func asyncGet(count: Int, info: [String : Any]?, isNetworkEnabled: Bool) -> DynamicPromise
    {
        let promise = DynamicPromise
        { (resolve, reject) in
            
            let appointmentModels = self.decodeModels()
            
            if (appointmentModels != nil)
            {
                resolve(appointmentModels)
            }
            else
            {
                reject(DynamicPromiseError("No Local"))
            }
        }
        return promise
    }
}
