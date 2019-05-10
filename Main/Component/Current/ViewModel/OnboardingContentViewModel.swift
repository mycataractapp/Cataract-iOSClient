//
//  OnboardingContentViewModel.swift
//  Cataract
//
//  Created by Roseanne Choi on 5/8/19.
//  Copyright © 2019 Rose Choi. All rights reserved.
//

import UIKit

class OnboardingContentViewModel : DynamicViewModel
{
    var size = CGSize.zero
    @objc var image : String
    
    init(image: String)
    {
        self.image = image
        
        super.init()
    }
    
    class CollectionViewModel : DynamicViewModel
    {
        var itemSize = CGSize.zero
        private var _onboardingContentViewModels : [OnboardingContentViewModel]!

        var onboardingContentViewModels : [OnboardingContentViewModel]
        {
            get
            {
                var viewModels = [OnboardingContentViewModel]()
                
                if (self._onboardingContentViewModels == nil)
                {
                    var onboardingContentViewModel : OnboardingContentViewModel!
                    
                    for index in 0...5
                    {
                        if (index == 0)
                        {
                            onboardingContentViewModel = OnboardingContentViewModel(image: "NavigationTools")
                            
                            viewModels.append(onboardingContentViewModel)
                        }
                        else if (index == 1)
                        {
                            onboardingContentViewModel = OnboardingContentViewModel(image: "AddTool")
                            
                            viewModels.append(onboardingContentViewModel)
                        }
                        else if (index == 2)
                        {
                            onboardingContentViewModel = OnboardingContentViewModel(image: "EditDropsTool1")
                            
                            viewModels.append(onboardingContentViewModel)
                        }
                        else if (index == 3)
                        {
                            onboardingContentViewModel = OnboardingContentViewModel(image: "EditDropsTool2")
                            
                            viewModels.append(onboardingContentViewModel)
                        }
                        else if (index == 4)
                        {
                            onboardingContentViewModel = OnboardingContentViewModel(image: "DropsOverview")
                            
                            viewModels.append(onboardingContentViewModel)
                        }
                        else if (index == 5)
                        {
                            onboardingContentViewModel = OnboardingContentViewModel(image: "AppointmentsTool")
                            
                            viewModels.append(onboardingContentViewModel)
                        }
                    }
                    
                    self._onboardingContentViewModels = viewModels
                }
                
                let onboardingContentViewModel = self._onboardingContentViewModels!
                
                return onboardingContentViewModel
            }
        }
        
        @objc func start()
        {
            self.transit(transition: OnboardingContentViewModel.CollectionViewModel.Transition.start,
                         to: OnboardingContentViewModel.CollectionViewModel.State.mainApp)
            
            UserDefaults.standard.set(true, forKey: "onboardingComplete")
            
        }
        
        struct Transition
        {
            static let start = DynamicViewModel.Transition(rawValue: "Start")
        }
        
        struct State
        {
            static let mainApp = DynamicViewModel.State(rawValue: "MainApp")
        }
    }
}
