//
//  DropTimeOverviewViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/6/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DropTimeOverviewViewModel : DynamicViewModel
{
    private var _dropTimeViewModels : [DropTimeViewModel]!
    
    var dropTimeViewModels : [DropTimeViewModel]
    {
        get
        {
            if (self._dropTimeViewModels == nil)
            {
                self._dropTimeViewModels = [DropTimeViewModel]()
            }
            
            let dropTimeViewModels = self._dropTimeViewModels!
            
            return dropTimeViewModels
        }
        
        set(newValue)
        {
            self._dropTimeViewModels = newValue
        }
    }
}
