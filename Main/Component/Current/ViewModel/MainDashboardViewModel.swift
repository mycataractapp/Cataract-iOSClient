//
//  MainDashboardViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import Foundation

class MainDashboardViewModel : DynamicViewModel
{
    @objc dynamic var faqCardCollectionViewModel = FAQCardViewModel.CollectionViewModel(faqCardViewModels: [FAQCardViewModel]())
}
