//
//  WeekDayStore.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/19/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import Foundation
import SwiftyJSON

class WeekDayStore : DynamicStore<WeekDayModel>
{
    override func asyncGet(count: Int, info: [String : Any]?, isNetworkEnabled: Bool) -> DynamicPromise
    {
        let promise = DynamicPromise
        { (resolve, reject) in
            
            do
            {
                let url : URL = URL(fileURLWithPath: Bundle.main.path(forResource: "WeekDayData", ofType: "json")!)
                let source : Data = try Data(contentsOf: url)
                let jsons : [JSON] = JSON(source).array!
                var weekDayModels = [WeekDayModel]()
                
                for (counter, json) in jsons.enumerated()
                {
                    let weekDayModel = WeekDayModel()
                    weekDayModel.data = json
                    weekDayModels.append(weekDayModel)
                }
                
                resolve(weekDayModels)
            }
            catch{}
        }
        
        return promise
    }
}
