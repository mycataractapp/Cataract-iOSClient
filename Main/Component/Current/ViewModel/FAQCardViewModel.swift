//
//  FAQCardViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class FAQCardViewModel : CardViewModel
{
    @objc dynamic var question : String!
    @objc dynamic var answer : String!
    
    init(id: String, question: String, answer: String)
    {
        self.question = question
        self.answer = answer
        
        super.init(id: id)
    }
    
    class CollectionViewModel : DynamicViewModel
    {
        var itemSize = CGSize.zero
        private var _faqCardViewModels : [FAQCardViewModel]
        
        init(faqCardViewModels: [FAQCardViewModel])
        {
            self._faqCardViewModels = faqCardViewModels
            
            super.init()
        }
        
        var faqCardViewModels : [FAQCardViewModel]
        {
            get
            {
                let faqCardViewModels = self._faqCardViewModels
                
                return faqCardViewModels
            }
        }
    }
}
