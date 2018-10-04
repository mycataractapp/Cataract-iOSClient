//
//  UserViewModel.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 10/2/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

final class UserViewModel 
{
    class ControlCard : CardViewModel
    {
        @objc dynamic var title: String!
        @objc dynamic var display: String!
        
        init(title: String, display: String, id: String)
        {
            self.title = title
            self.display = display
            
            super.init(id: id)
        }
        
        @objc func edit()
        {
            self.transit(transition: UserViewModel.ControlCard.Transition.edit,
                         to: DynamicViewModel.State(rawValue: "Edit"))
        }
        
        struct Transition
        {
            static let edit = DynamicViewModel.Transition(rawValue: "Edit")
        }
        
        class CollectionViewModel : DynamicViewModel
        {
            var itemSize = CGSize.zero
            private var _controlCards : [ControlCard]!
            
            init(controlCards: [ControlCard])
            {
                self._controlCards = controlCards
                
                super.init()
            }
            
            var controlCards : [ControlCard]
            {
                get
                {
                    let controlCards = self._controlCards!
                    
                    return controlCards
                }
            }
        }
    }
}
