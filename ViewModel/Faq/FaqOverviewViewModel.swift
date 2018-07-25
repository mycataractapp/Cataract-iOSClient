//
//  FaqOverviewViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 7/4/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class FaqOverviewViewModel : DynamicViewModel
{
    private var _faqViewModels : [FaqViewModel]!
    
    var faqViewModels : [FaqViewModel]
    {
        get
        {
            if (self._faqViewModels == nil)
            {
                self._faqViewModels = [FaqViewModel]()
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
