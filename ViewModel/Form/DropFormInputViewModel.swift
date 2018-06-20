//
//  DropFormInputViewModel.swift
//  Cataract
//
//  Created by Rose Choi on 6/19/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DropFormInputViewModel : DynamicViewModel
{
    private var _inputViewModel : InputViewModel!
    private var _iconOverviewViewModel : IconOverviewViewModel!
    
    var inputViewModel : InputViewModel
    {
        get
        {
            if (self._inputViewModel == nil)
            {
                self._inputViewModel = InputViewModel(placeHolder: "Example : Pink Top")
            }
            
            let inputViewModel = self._inputViewModel!
            
            return inputViewModel
        }
    }
    
    var iconOverviewViewModel : IconOverviewViewModel
    {
        get
        {
            if (self._iconOverviewViewModel == nil)
            {
                self._iconOverviewViewModel = IconOverviewViewModel()
            }

            let iconOverviewViewModel = self._iconOverviewViewModel!

            return iconOverviewViewModel
        }
    }
}
