//
//  CustomCardViewModel.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 9/15/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class CustomCardViewModel : CardViewModel
{
    @objc dynamic var name : String
    
    init(name: String, id: String)
    {
        self.name = name
        
        super.init(id: id)
    }
    
    class CollectionViewModel : DynamicViewModel
    {
        private var _customCardViewModels : [CustomCardViewModel]!
        
        init(customCardViewModels: [CustomCardViewModel])
        {
            self._customCardViewModels = customCardViewModels
            
            super.init()
        }
        
        var customCardViewModels : [CustomCardViewModel]
        {
            get
            {
                let customCardViewModels = self._customCardViewModels!
                
                return customCardViewModels
            }
        }
    }
}
