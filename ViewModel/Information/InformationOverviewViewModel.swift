//
//  InformationOverviewViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 7/4/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class InformationOverviewViewModel : DynamicViewModel
{
    private var _informationViewModels : [InformationViewModel]!
    
    var informationViewModels : [InformationViewModel]
    {
        get
        {
            if (self._informationViewModels == nil)
            {
                self._informationViewModels = [InformationViewModel]()
            }
            
            let informationViewModels = self._informationViewModels!
            
            return informationViewModels
        }
        
        set(newValue)
        {
            self._informationViewModels = newValue
        }
    }
}
