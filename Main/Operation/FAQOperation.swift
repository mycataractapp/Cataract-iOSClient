//
//  FAQOperation.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/5/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import Foundation

class FAQOperation : NSObject
{
    class GetFAQModelsQuery : DynamicQuery
    {
        override func execute() -> DynamicPromise
        {
            let promise = DynamicPromise.resolve(value: [FAQModel]())
            .then
            { (value) -> Any? in
                
                var faqModels = value as! [FAQModel]
                
                do
                {
                    let url : URL = URL(fileURLWithPath: Bundle.main.path(forResource: "FAQData", ofType: "json")!)
                    let data : Data = try Data(contentsOf: url)
                    faqModels = try JSONDecoder().decode([FAQModel].self, from: data)             
                }
                catch
                {
                    print(error)
                }
                
                return faqModels
            }
            
            return promise
        }
    }
}
