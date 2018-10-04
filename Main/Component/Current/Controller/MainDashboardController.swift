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
    private var _appointmentCardCollectionController : AppointmentCardController.CollectionController!
    private var _appointmentStore : DynamicStore.Collection<AppointmentModel>!
    private var _faqCardCollectionController : FAQCardController.TableController!
//    private var _dropFormController : DropFormController!
    private var _faqStore : DynamicStore.Collection<FAQModel>!
    
    override var tabBarController : UITabBarController
    {
        get
        {
            if (self._tabBarController == nil)
            {
                self._tabBarController = UITabBarController()
                self._tabBarController.viewControllers = [self.faqCardCollectionController, self.appointmentCardCollectionController]
            }
            
            let tabBarController = self._tabBarController!
            
            return tabBarController
        }
    }
    
    func onButtonSelected()
    {
//        self.tabBarController.present(self.dropFormController.pageViewController, animated: true, completion: nil)
    }
    
    var appointmentStore : DynamicStore.Collection<AppointmentModel>
    {
        get
        {
            if (self._appointmentStore == nil)
            {
                self._appointmentStore = DynamicStore.Collection<AppointmentModel>()
            }
            
            let appointmentStore = self._appointmentStore!
            
            return appointmentStore
        }
    }
//
//    var dropFormController : DropFormController
//    {
//        get
//        {
//            if (self._dropFormController == nil)
//            {
//                self._dropFormController = DropFormController()
//            }
//
//            let dropFormController = self._dropFormController!
//
//            return dropFormController
//        }
//    }
//
    var faqStore : DynamicStore.Collection<FAQModel>
    {
        get
        {
            if (self._faqStore == nil)
            {
                self._faqStore = DynamicStore.Collection<FAQModel>()
            }
            
            let faqStore = self._faqStore!
            
            return faqStore
        }
    }
    
    @objc var appointmentStoreRepresentable : DynamicStore
    {
        get
        {
            let appointmentStoreRepresentable = self.appointmentStore
            
            return appointmentStoreRepresentable
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

    var appointmentTimeControllerSize : CGSize
    {
        get
        {
            let canvas = self.view.frame.size
            var appointmentTimeControllerSize = canvas
            appointmentTimeControllerSize.height = 9
            return appointmentTimeControllerSize
        }
    }
    
    var appointmentCardCollectionController : AppointmentCardController.CollectionController
    {
        get
        {
            if (self._appointmentCardCollectionController == nil)
            {
               self._appointmentCardCollectionController = AppointmentCardController.CollectionController()
               self._appointmentCardCollectionController.tabBarItem = UITabBarItem(title: "Appointments",
                                                                                   image: nil,
                                                                                   tag: 0)
               self._appointmentCardCollectionController.tableView.contentInset = UIEdgeInsets(top: 0,
                                                                                               left: 0,
                                                                                               bottom: self.tabBarController.tabBar.frame.height,
                                                                                               right: 0)
            }
            
            let appointmentCardCollectionController = self._appointmentCardCollectionController!
            
            return appointmentCardCollectionController
        }
    }

    var faqCardCollectionController : FAQCardController.TableController
    {
        get
        {
            if (self._faqCardCollectionController == nil)
            {
                self._faqCardCollectionController = FAQCardController.TableController()
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
            var controllerEventKeyPaths = Set<String>([DynamicKVO.keyPath(\MainDashboardController.viewModel.faqCardCollectionViewModel),
                                                       DynamicKVO.keyPath(\MainDashboardController.viewModel.appointmentCardCollectionViewModel)])
            controllerEventKeyPaths = controllerEventKeyPaths.union(super.controllerEventKeyPaths)

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
        
        self.appointmentCardCollectionController.bind()
        self.faqCardCollectionController.bind()
//        self.dropFormController.bind()
    }
    
    override func render()
    {
        super.render()
        
        self.view.frame.size = self.viewModel.size
        
        self.viewModel.appointmentCardCollectionViewModel.itemSize = CGSize(width: self.view.frame.width,
                                                                            height: 150)
        self.viewModel.appointmentCardCollectionViewModel = self.viewModel.appointmentCardCollectionViewModel

        self.viewModel.faqCardCollectionViewModel.itemSize = CGSize(width: self.view.frame.width,
                                                                    height: 5)
        self.viewModel.faqCardCollectionViewModel = self.viewModel.faqCardCollectionViewModel
    }
    
    override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\MainDashboardController.viewModel.appointmentCardCollectionViewModel))
        {
            self.appointmentCardCollectionController.viewModel = self.viewModel.appointmentCardCollectionViewModel
        }
        else if (kvoEvent.keyPath == DynamicKVO.keyPath(\MainDashboardController.viewModel.faqCardCollectionViewModel))
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
                                                            question: faqModel.question,
                                                            answer: faqModel.answer)
                    faqCardViewModels.append(faqCardViewModel)
                }
                
                let faqCardCollectionViewModel = FAQCardViewModel.CollectionViewModel(faqCardViewModels: faqCardViewModels)
                
                if (self.viewModel != nil)
                {
                    faqCardCollectionViewModel.itemSize = self.viewModel.faqCardCollectionViewModel.itemSize
                }
                
                self.viewModel.faqCardCollectionViewModel = faqCardCollectionViewModel
            }
        }
    }
    
    func loadAllStores()
    {
        self.faqStore.load(FAQOperation.GetFAQModelsQuery())
//        self.appointmentStore.load(AppointmentOperation.GetAppointmentModelsQuery())
    }
}
