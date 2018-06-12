//
//  DropStore.swift
//  Cataract
//
//  Created by Rose Choi on 6/9/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import Foundation
import SwiftyJSON

class DropStore : DynamicStore<DropModel>
{
    override func asyncGet(count: Int, info: [String : Any]?, isNetworkEnabled: Bool) -> DynamicPromise
    {
        let promise = DynamicPromise
        { (resolve, reject) in

            do
            {
                let url : URL = URL(fileURLWithPath: Bundle.main.path(forResource: "DropData", ofType: "json")!)
                let source : Data = try Data(contentsOf: url)
                let jsons : [JSON] = JSON(source).array!
                var dropModels = [DropModel]()


                for (counter, json) in jsons.enumerated()
                {
                    let dropModel = DropModel()
                    dropModel.data = json
                    dropModels.append(dropModel)
                }

                resolve(dropModels)
            }
            catch{}
        }

        return promise
    }
}


