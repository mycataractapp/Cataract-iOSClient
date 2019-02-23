//
//  DropCardController.swift
//  Cataract
//
//  Created by Roseanne Choi on 11/5/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import CareKit

class DropCardController : DynamicController, DynamicViewModelDelegate, OCKCarePlanStoreDelegate, OCKCareCardViewControllerDelegate
{
    private var _navigationController: UINavigationController!
    private var _careCardViewController : OCKCareCardViewController!
    private var _carePlanStore : CarePlanStore!
    private var _dropsMenuOverlay : UIView!
    private var _dropsMenuOverlayController : UserController.MenuOverlayController!
    var interventionActivity : OCKCarePlanActivity!
    @objc dynamic var viewModel : DropCardViewModel!
    
    override var navigationController: UINavigationController
    {
        get
        {
            if (self._navigationController == nil)
            {
                self._navigationController = UINavigationController()
                self._navigationController.pushViewController(self.careCardViewController, animated: false)
            }

            let navigationController = self._navigationController!

            return navigationController
        }
    }

    var careCardViewController : OCKCareCardViewController
    {
        get
        {
            if (self._careCardViewController == nil)
            {
                self._careCardViewController = OCKCareCardViewController(carePlanStore: self.carePlanStore.ockCarePlanStore)
                self._careCardViewController.glyphType = .blood
                self._careCardViewController.glyphTintColor = UIColor(red: 51/255, green: 127/255, blue: 159/255, alpha: 1)
                self._careCardViewController.delegate = self
            }

            let careCardViewController = self._careCardViewController!
            
            return careCardViewController
        }
    }
    
    var carePlanStore : CarePlanStore
    {
        get
        {
            if (self._carePlanStore == nil)
            {
                self._carePlanStore = CarePlanStore()
            }
            
            let carePlanStore = self._carePlanStore!
                        
            return carePlanStore
        }
    }
    
    var dropsMenuOverlay : UIView
    {
        get
        {
            if (self._dropsMenuOverlay == nil)
            {
                self._dropsMenuOverlay = UIView()
                self._dropsMenuOverlay.autoresizesSubviews = false
                self._dropsMenuOverlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            }
            
            let dropsMenuOverlay = self._dropsMenuOverlay!
            
            return dropsMenuOverlay
        }
    }
    
    var dropsMenuOverlayController : UserController.MenuOverlayController
    {
        get
        {
            if (self._dropsMenuOverlayController == nil)
            {
                self._dropsMenuOverlayController = UserController.MenuOverlayController()
            }
            
            let dropsMenuOverlayController = self._dropsMenuOverlayController!
            
            return dropsMenuOverlayController
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.navigationController.view)
        self.view.addSubview(self.dropsMenuOverlay)
        self.view.addSubview(self.dropsMenuOverlayController.view)
    }
    
    override func render()
    {
        super.render()
  
        self.view.frame.size = self.viewModel.size
        
        self.dropsMenuOverlay.frame.size = self.view.frame.size
        self.dropsMenuOverlay.frame.origin.y = self.view.frame.size.height
        
        self.dropsMenuOverlayController.view.frame.origin.y = self.view.frame.size.height
        
        self.viewModel.dropsMenuOverlayViewModel.size.width = self.view.frame.size.width
        self.viewModel.dropsMenuOverlayViewModel.size.height = 285
    
        self.dropsMenuOverlayController.viewModel = self.viewModel.dropsMenuOverlayViewModel
    }
    
    override func bind()
    {
        super.bind()
        
        self.dropsMenuOverlayController.bind()
        
        self.addObserver(self,
                         forKeyPath: "viewModel.dropsMenuOverlayViewModel.event",
                         options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                              NSKeyValueObservingOptions.initial]),
                         context: nil)
    }
    
    override func unbind()
    {
        super.unbind()
        
        self.dropsMenuOverlayController.unbind()
        
        self.removeObserver(self, forKeyPath: "viewModel.dropsMenuOverlayViewModel.event")
    }

    override func observeController(for controllerEvent: DynamicController.Event, kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == DynamicKVO.keyPath(\DropCardController.viewModel))
        {
            if (controllerEvent.operation == DynamicController.Event.Operation.bind)
            {
                self.viewModel.delegate = self
            }
            else
            {
                self.viewModel.delegate = nil
            }
        }
    }
    
    func careCardViewController(_ viewController: OCKCareCardViewController, didSelectRowWithInterventionActivity interventionActivity: OCKCarePlanActivity)
    {
        self.interventionActivity = interventionActivity
                
        self.viewModel.enterMenu()
    }

    func viewModel(_ viewModel: DynamicViewModel, transitWith event: DynamicViewModel.Event)
    {
        if (event.newState == DropCardViewModel.State.options)
        {
            UIView.animate(withDuration: 0.25, animations:
            {
                self.dropsMenuOverlayController.view.frame.origin.y = self.view.frame.size.height - self.viewModel.dropsMenuOverlayViewModel.size.height - 50
            })
            { (isCompleted) in

                self.dropsMenuOverlay.frame.origin.y = 0
            }
        }
    }

    override func observeKeyValue(for kvoEvent: DynamicKVO.Event)
    {
        if (kvoEvent.keyPath == "viewModel.dropsMenuOverlayViewModel.event")
        {
            if (self.viewModel != nil)
            {
                if (self.viewModel.dropsMenuOverlayViewModel.state == UserViewModel.MenuOverlayViewModel.State.end)
                {                    
                    self.carePlanStore.ockCarePlanStore.remove(self.interventionActivity)
                    { (isCompleted, error) in
                    }

                    UIView.animate(withDuration: 0.25, animations:
                    {
                        self.dropsMenuOverlayController.view.frame.origin.y = self.view.frame.size.height
                    })
                    { (isCompleted) in

                        self.dropsMenuOverlay.frame.origin.y = self.view.frame.size.height
                    }
                }
                else if (self.viewModel.dropsMenuOverlayViewModel.state == UserViewModel.MenuOverlayViewModel.State.idle)
                {
                    UIView.animate(withDuration: 0.25, animations:
                    {
                        self.dropsMenuOverlayController.view.frame.origin.y = self.view.frame.size.height
                    })
                    { (isCompleted) in

                        self.dropsMenuOverlay.frame.origin.y = self.view.frame.size.height
                    }
                }
            }
        }
    }
}
