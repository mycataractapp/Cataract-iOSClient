//
//  FAQOverviewViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/4/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class FAQOverviewViewModel : DynamicViewModel
{
    private var _faqViewModels : [FAQViewModel]!
    
    var faqViewModels : [FAQViewModel]
    {
        get
        {
            if (self._faqViewModels == nil)
            {
                self._faqViewModels = [FAQViewModel]()
            }
            
            let faqViewModels = self._faqViewModels!
            
            return faqViewModels
        }
        
        set(newValue)
        {
            self._faqViewModels = newValue
        }
    }
}
