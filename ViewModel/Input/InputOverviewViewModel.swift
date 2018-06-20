//
//  InputOverviewViewModel.swift
//  Rose
//
//  Created by Rose Choi on 5/12/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
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
