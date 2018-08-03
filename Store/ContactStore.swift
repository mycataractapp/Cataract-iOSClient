//
//  ContactStore.swift
//  Cataract
//
//  Created by Rose Choi on 7/27/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import Foundation
import SwiftyJSON

class ContactStore : DynamicStore<ContactModel>
{
    override func asyncGet(count: Int, info: [String : Any]?, isNetworkEnabled: Bool) -> DynamicPromise
    {
        let promise = DynamicPromise
        { (resolve, reject) in
            
            do
            {
                let url : URL = URL(fileURLWithPath: Bundle.main.path(forResource: "ContactData", ofType: "json")!)
                let source : Data = try Data(contentsOf: url)
                let jsons : [JSON] = JSON(source).array!
                var contactModels = [ContactModel]()
                
                
                for (counter, json) in jsons.enumerated()
                {
                    let contactModel = ContactModel()
                    contactModel.data = json
                    contactModels.append(contactModel)
                }
                
                resolve(contactModels)
            }
            catch{}
        }
        
        return promise
    }
}
