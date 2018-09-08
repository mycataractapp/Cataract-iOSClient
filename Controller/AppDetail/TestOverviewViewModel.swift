//
//  TestOverviewViewModel.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 9/5/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class TestOverviewViewModel : DynamicViewModel
{
    private var _testViewModels : [TestViewModel]!
    
    var testViewModels : [TestViewModel]
    {
        get
        {
            if (self._testViewModels == nil)
            {
                self._testViewModels = [TestViewModel]()
            }
            
            let testViewModels = self._testViewModels!
            
            return testViewModels
        }
        set(newValue)
        {
            self._testViewModels = newValue
        }
    }
}
