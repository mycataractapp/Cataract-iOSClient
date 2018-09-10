//
//  ColorOperation.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/18/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import Foundation

class ColorOperation : NSObject
{
    class GetColorModelsQuery : DynamicQuery
    {
        override func execute() -> DynamicPromise
        {
            let promise = DynamicPromise.resolve(value: [ColorModel]())
            .then
            { (value) -> Any? in
                
                var colorModels = value as! [ColorModel]
                
                do
                {
                    let url : URL = URL(fileURLWithPath: Bundle.main.path(forResource: "ColorData", ofType: "json")!)
//                    let source : Data = try Data(contentsOf: url)
//                    let jsons : [JSON] = JSON(source).array!
//                    var colorModels = [ColorModel]()
//                    
//                    for json in jsons
//                    {
//                        let colorModel = ColorModel(data: json)
//                        colorModels.append(colorModel)
//                    }
                }
                catch{}
                
                return colorModels
            }
            
            return promise
        }
    }
}
