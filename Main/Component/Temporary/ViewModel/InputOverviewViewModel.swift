//
//  InputOverviewViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/15/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class InputOverviewViewModel : DynamicViewModel
{
    private var _inputViewModels : [InputViewModel]!
    
    var inputViewModels : [InputViewModel]
    {
        get
        {
            if (self._inputViewModels == nil)
            {
                self._inputViewModels = [InputViewModel]()
            }
            
            let inputViewModels = self._inputViewModels!
            
            return inputViewModels
        }
        
        set(newValue)
        {
            self._inputViewModels = newValue
        }
    }
}
