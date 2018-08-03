//
//  DropOverviewViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/6/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class DropOverviewViewModel : DynamicViewModel
{
    private var _dropViewModels : [DropViewModel]!

    var dropViewModels : [DropViewModel]
    {
        get
        {
            if (self._dropViewModels == nil)
            {
                self._dropViewModels = [DropViewModel]()
            }
            
            let dropViewModels = self._dropViewModels!
            
            return dropViewModels
        }
        
        set(newValue)
        {
            self._dropViewModels = newValue
        }
    }
    
    @objc func add()
    {
        self.transit(transition: "Add", to: self.state)
    }
}
