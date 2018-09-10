//
//  DynamicViewModelDelegate.swift
//  Pacific
//
//  Created by Minh Nguyen on 12/13/17.
//  Copyright © 2017 Langtutheky. All rights reserved.
//

import Foundation

protocol DynamicViewModelDelegate : class
{
    func viewModel(_ viewModel: DynamicViewModel, transitWith event: DynamicViewModel.Event)
}
