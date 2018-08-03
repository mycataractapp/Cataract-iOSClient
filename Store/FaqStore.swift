//
//  InfomationStore.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/5/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import Foundation
import SwiftyJSON

class FaqStore : DynamicStore<FaqModel>
{
    override func asyncGet(count: Int, info: [String : Any]?, isNetworkEnabled: Bool) -> DynamicPromise
    {
        let promise = DynamicPromise
        { (resolve, reject) in
            
            do
            {
                let url : URL = URL(fileURLWithPath: Bundle.main.path(forResource: "FaqData", ofType: "json")!)
                let source : Data = try Data(contentsOf: url)
                let jsons : [JSON] = JSON(source).array!
                var faqModels = [FaqModel]()
                
                for (counter, json) in jsons.enumerated()
                {
                    let faqModel = FaqModel()
                    faqModel.data = json
                    faqModels.append(faqModel)
                }
                
                resolve(faqModels)
            }
            catch{}
        }
        
        return promise
    }
}
