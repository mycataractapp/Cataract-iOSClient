//
//  ColorStore.swift
//  Cataract
//
//  Created by Rose Choi on 6/18/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import Foundation
import SwiftyJSON

class ColorStore : DynamicStore<ColorModel>
{
    override func asyncGet(count: Int, info: [String : Any]?, isNetworkEnabled: Bool) -> DynamicPromise
    {
        let promise = DynamicPromise
        { (resolve, reject) in
            
            do
            {
                let url : URL = URL(fileURLWithPath: Bundle.main.path(forResource: "ColorData", ofType: "json")!)
                let source : Data = try Data(contentsOf: url)
                let jsons : [JSON] = JSON(source).array!
                var colorModels = [ColorModel]()
                
                for json in jsons
                {
                    let colorModel = ColorModel()
                    colorModel.data = json
                    colorModels.append(colorModel)
                }
                
                resolve(colorModels)
            }
            catch{}
        }
        
        return promise
    }
}
