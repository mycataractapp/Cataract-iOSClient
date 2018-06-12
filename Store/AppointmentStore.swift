//
//  AppointmentStore.swift
//  Cataract
//
//  Created by Rose Choi on 6/11/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import Foundation
import SwiftyJSON

class AppointmentStore : DynamicStore<AppointmentModel>
{
    override func asyncGet(count: Int, info: [String : Any]?, isNetworkEnabled: Bool) -> DynamicPromise
    {
        let promise = DynamicPromise
        { (resolve, reject) in
            
            do
            {
                let url : URL = URL(fileURLWithPath: Bundle.main.path(forResource: "AppointmentData", ofType: "json")!)
                let source : Data = try Data(contentsOf: url)
                let jsons : [JSON] = JSON(source).array!
                var appointmentModels = [AppointmentModel]()
                
                
                for (counter, json) in jsons.enumerated()
                {
                    let appointmentModel = AppointmentModel()
                    appointmentModel.data = json
                    appointmentModels.append(appointmentModel)
                }
                
                resolve(appointmentModels)
            }
            catch{}
        }
    
        return promise
    }
}
