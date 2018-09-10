//
//  MainDashboardController.swift
//  Cataract
//
//  Created by Roseanne Choi on 9/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class MainDashboardController : DynamicController
{
    @objc dynamic var viewModel : MainDashboardViewModel!
    private var _tabBarController : UITabBarController!
    private var _faqCardCollectionController : FAQCardController.CollectionController!
    private var _faqStore : DynamicStore.Collection<FAQModel>!
    
    override var tabBarController : UITabBarController
    {
        get
        {
            if (self._tabBarController == nil)
            {
                self._tabBarController = UITabBarController()
                self._tabBarController.viewControllers = [self.faqCardCollectionController]
            }
            
            let tabBarController = self._tabBarController!
            
            return tabBarController
        }
    }
    
    var faqStore : DynamicStore.Collection<FAQModel>
    {
        get
        {
            if (self._faqStore == nil)
            {
                self._faqStore = DynamicStore.Collection<FAQModel>()
                self._faqStore.load(FAQOperation.GetFAQModelsQuery())
            }
            
            let faqStore = self._faqStore!
            
            return faqStore
        }
    }
    
    @objc var faqStoreRepresentable : DynamicStore
    {
        get
        {
            let faqStoreRepresentable = self.faqStore
            
            return faqStoreRepresentable
        }
    }
    
    var faqControllerSize : CGSize
    {
        get
        {
            let canvas = DynamicCanvas(size: self.view.frame.size)
            var faqControllerSize = canvas.size
            faqControllerSize.height = canvas.draw(tiles: 5)

            return faqControllerSize
        }
    }

    var faqCardCollectionController : FAQCardController.CollectionController
    {
        get
        {
            if (self._faqCardCollectionController == nil)
            {
                self._faqCardCollectionController = FAQCardController.CollectionController()
                self._faqCardCollectionController.tabBarItem = UITabBarItem(title: "FAQ",
                                                                            image: nil,
                                                                            tag: 0)
                self._faqCardCollectionController.tableView.contentInset = UIEdgeInsets(top: 0,
                                                                                        left: 0,
                                                                                        bottom: self.tabBarController.tabBar.frame.height,
                                                                                        right: 0)
            }
            
            let faqCardCollectionController = self._faqCardCollectionController!
            
            return faqCardCollectionController
        }
    }
    
    override var controllerEventKeyPaths: Set<String>
    {
        get
        {
            let controllerEventKeyPaths = super.controllerEventKeyPaths.union([DynamicKVO.keyPath(\MainDashboardController.viewModel.faqCardCollectionViewModel)])
            
            return controllerEventKeyPaths
        }
    }
    
    override var storeEventKeyPaths: Set<String>
    {
        get
        {
            let storeEventKeyPaths = super.storeEventKeyPaths.union([DynamicKVO.keyPath(\MainDashboardController.faqStoreRepresentable.event)])
            
            return storeEventKeyPaths
        }
    }
    
    override func bind()
    {
        super.bind()
        
        self.faqCardCollectionController.bind()
    }
    
    override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\MainDashboardController.viewModel.faqCardCollectionViewModel))
        {
            self.faqCardCollectionController.viewModel = self.viewModel.faqCardCollectionViewModel
        }
    }
    
    override func observeStore(for storeEvent: DynamicStore.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\MainDashboardController.faqStoreRepresentable.event))
        {
            if (storeEvent.operation == DynamicStore.Event.Operation.load)
            {
                let faqModels = storeEvent.models as! [FAQModel]
                var faqCardViewModels = [FAQCardViewModel]()
                
                for faqModel in faqModels
                {
                    let faqCardViewModel = FAQCardViewModel(id: faqModel.id,
                                                            size: self.faqControllerSize,
                                                            question: faqModel.question,
                                                            answer: faqModel.answer)
                    faqCardViewModels.append(faqCardViewModel)
                }
                
                self.viewModel.faqCardCollectionViewModel = FAQCardViewModel.CollectionViewModel(faqCardViewModels: faqCardViewModels)
            }
        }
    }
}
