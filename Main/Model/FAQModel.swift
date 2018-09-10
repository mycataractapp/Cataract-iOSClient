//
//  FAQModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/5/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import Foundation

final class FAQModel : DynamicModel, Decodable
{
    private var _question : String!
    private var _answer : String!
    
    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self._question = try values.decode(String.self, forKey: FAQModel.CodingKeys.question)
        self._answer = try values.decode(String.self, forKey: FAQModel.CodingKeys.answer)
        
        super.init()
    }
    
    var question : String
    {
        get
        {
            let question = self._question!
            
            return question
        }
    }
    
    var answer : String
    {
        get
        {
            let answer = self._answer!
            
            return answer
        }
    }
    
    enum CodingKeys: String, CodingKey
    {
        case question
        case answer
    }
}
