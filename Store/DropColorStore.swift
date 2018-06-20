//
//  DropColorStore.swift
//  Cataract
//
//  Created by Rose Choi on 6/18/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import Foundation
import SwiftyJSON

class DropColorStore : DynamicStore<DropColorModel>
{
    override func asyncGet(count: Int, info: [String : Any]?, isNetworkEnabled: Bool) -> DynamicPromise
    {
        let promise = DynamicPromise
        { (resolve, reject) in
            
            do
            {
                let url : URL = URL(fileURLWithPath: Bundle.main.path(forResource: "DropColorData", ofType: "json")!)
                let source : Data = try Data(contentsOf: url)
                let jsons : [JSON] = JSON(source).array!
                var dropColorModels = [DropColorModel]()
                
                for json in jsons
                {
                    let dropColorModel = DropColorModel()
                    dropColorModel.data = json
                    dropColorModels.append(dropColorModel)
                }
                
                resolve(dropColorModels)
            }
            catch{}
        }
        
        return promise
    }
}
