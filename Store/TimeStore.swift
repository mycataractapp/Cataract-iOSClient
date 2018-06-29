//
//  TimeStore.swift
//  Cataract
//
//  Created by Rose Choi on 6/29/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import Foundation
import SwiftyJSON

class TimeStore : DynamicStore<TimeModel>
{
    override func asyncGet(count: Int, info: [String : Any]?, isNetworkEnabled: Bool) -> DynamicPromise
    {
        let promise = DynamicPromise
        { (resolve, reject) in
            
            do
            {
                let url : URL = URL(fileURLWithPath: Bundle.main.path(forResource: "TimeData", ofType: "json")!)
                let source : Data = try Data(contentsOf: url)
                let jsons : [JSON] = JSON(source).array!
                var timeModels = [TimeModel]()
                
                for (counter, json) in jsons.enumerated()
                {
                    let timeModel = TimeModel()
                    timeModel.data = json
                    timeModels.append(timeModel)
                }
                
                resolve(timeModels)
            }
            catch{}
        }
        
        return promise
    }
}
