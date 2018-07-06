//
//  InfomationStore.swift
//  Cataract
//
//  Created by Rose Choi on 7/5/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import Foundation
import SwiftyJSON

class InformationStore : DynamicStore<InformationModel>
{
    override func asyncGet(count: Int, info: [String : Any]?, isNetworkEnabled: Bool) -> DynamicPromise
    {
        let promise = DynamicPromise
        { (resolve, reject) in
            
            do
            {
                let url : URL = URL(fileURLWithPath: Bundle.main.path(forResource: "InformationData", ofType: "json")!)
                let source : Data = try Data(contentsOf: url)
                let jsons : [JSON] = JSON(source).array!
                var informationModels = [InformationModel]()
                
                for (counter, json) in jsons.enumerated()
                {
                    let informationModel = InformationModel()
                    informationModel.data = json
                    informationModels.append(informationModel)
                }
                
                resolve(informationModels)
            }
            catch{}
        }
        
        return promise
    }
}
