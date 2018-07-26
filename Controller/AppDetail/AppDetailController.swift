//
//  AppDetailController.swift
//  Cataract
//
//  Created by Rose Choi on 6/9/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class AppDetailController : DynamicController<AppDetailViewModel>, UIPageViewDelegate, UIPageViewDataSource, DynamicViewModelDelegate
{
    var dropFormDetailController : DropFormDetailController?
    private var _pageView : UIPageView!
    private var _appleCareNavigationController : AppleCareNavigationController!
//    private var _dropOverviewController : DropOverviewController!
    private var _appointmentTimeOverviewController : AppointmentTimeOverviewController!
    private var _navigationOverviewController : NavigationOverviewController!
    private var _faqOverviewController : FaqOverviewController!
    var appointmentFormDetailController : AppointmentFormDetailController!
    private var _appointmentStore : AppointmentStore!
    private var _colorStore : ColorStore!
    private var _faqStore : FaqStore!
    private var _dropButton : UIButton!
    private var _appointmentButton : UIButton!
    
    var dropButton : UIButton
    {
        get
        {
            if (self._dropButton == nil)
            {
                self._dropButton = UIButton()
                self._dropButton.setImage(UIImage(contentsOfFile: Bundle.main.path(forResource: "Add", ofType: "png")!),
                                      for: UIControlState.normal)
            }
            
            let dropButton = self._dropButton!
            
            return dropButton
        }
    }
    
    var appointmentButton : UIButton
    {
        get
        {
            if (self._appointmentButton == nil)
            {
                self._appointmentButton = UIButton()
                self._appointmentButton.setImage(UIImage(contentsOfFile: Bundle.main.path(forResource: "Add", ofType: "png")!),
                                                 for: UIControlState.normal)
            }
            
            let appointmentButton = self._appointmentButton!
            
            return appointmentButton
        }
    }
    
    var pageView : UIPageView
    {
        get
        {
            if (self._pageView == nil)
            {
                self._pageView = UIPageView(mode: UIPageViewMode.autoScrolling)
                self._pageView.delegate = self
                self._pageView.dataSource = self
                self._pageView.isScrollEnabled = true
                self._pageView.backgroundColor = UIColor.white
            }
            
            let pageView = self._pageView!
            
            return pageView
        }
    }
    
    var appleCareNavigationController : AppleCareNavigationController
    {
        get
        {
            if (self._appleCareNavigationController == nil)
            {
                self._appleCareNavigationController = AppleCareNavigationController()
                self._appleCareNavigationController.view.addSubview(self.dropButton)
            }
            
            let appleCareNavigationController = self._appleCareNavigationController!
            
            return appleCareNavigationController
        }
    }
    
//    var dropOverviewController : DropOverviewController
//    {
//        get
//        {
//            if (self._dropOverviewController == nil)
//            {
//                self._dropOverviewController = DropOverviewController()
//                self._dropOverviewController.listView.showsVerticalScrollIndicator = false
//            }
//
//            let dropOverviewController = self._dropOverviewController!
//
//            return dropOverviewController
//        }
//    }
    
    var appointmentTimeOverviewController : AppointmentTimeOverviewController
    {
        get
        {
            if (self._appointmentTimeOverviewController == nil)
            {
                self._appointmentTimeOverviewController = AppointmentTimeOverviewController()
                self._appointmentTimeOverviewController.view.addSubview(self.appointmentButton)
            }
            
            let appointmentTimeOverviewController = self._appointmentTimeOverviewController!
            
            return appointmentTimeOverviewController
        }
    }
    
    var navigationOverviewController : NavigationOverviewController
    {
        get
        {
            if (self._navigationOverviewController == nil)
            {
                self._navigationOverviewController = NavigationOverviewController()
            }
            
            let navigationOverviewController = self._navigationOverviewController!
            
            return navigationOverviewController
        }
    }
    
    var faqOverviewController : FaqOverviewController
    {
        get
        {
            if (self._faqOverviewController == nil)
            {
                self._faqOverviewController = FaqOverviewController()
            }
            
            let faqOverviewController = self._faqOverviewController!
            
            return faqOverviewController
        }
    }

    var appointmentStore : AppointmentStore
    {
        get
        {
            if (self._appointmentStore == nil)
            {
                self._appointmentStore = AppointmentStore()
            }
            
            let appointmentStore = self._appointmentStore!
            
            return appointmentStore
        }
    }
    
    var faqStore : FaqStore
    {
        get
        {
            if (self._faqStore == nil)
            {
                self._faqStore = FaqStore()
            }
            
            let faqStore = self._faqStore!
            
            return faqStore
        }
    }
    
    var appleCareNavigationControllerSize : CGSize
    {
        get
        {
            var appleCareNavigationControllerSize = CGSize.zero
            appleCareNavigationControllerSize.width = self.pageView.frame.size.width
            appleCareNavigationControllerSize.height = self.pageView.frame.height

            return appleCareNavigationControllerSize
        }
    }
    
//    var dropOverviewControllerSize : CGSize
//    {
//        get
//        {
//            var dropOverviewControllerSize = CGSize.zero
//            dropOverviewControllerSize.width = self.pageView.frame.size.width
//            dropOverviewControllerSize.height = self.pageView.frame.height - self.appleCareNavigationControllerSize.height
//
//            return dropOverviewControllerSize
//        }
//    }
    
    var appointmentTimeOverviewControllerSize : CGSize
    {
        get
        {
            var appointmentTimeOverviewControllerSize = CGSize.zero
            appointmentTimeOverviewControllerSize.width = self.pageView.frame.size.width
            appointmentTimeOverviewControllerSize.height = self.pageView.frame.height
            
            return appointmentTimeOverviewControllerSize
        }
    }
    
    var navigationOverviewControllerSize : CGSize
    {
        get
        {
            var navigationOverviewControllerSize = CGSize.zero
            navigationOverviewControllerSize.width = self.view.frame.size.width
            navigationOverviewControllerSize.height = self.canvas.draw(tiles: 3)
            
            return navigationOverviewControllerSize
        }
    }
    
    var faqOverviewControllerSize : CGSize
    {
        get
        {
            var faqOverviewControllerSize = CGSize.zero
            faqOverviewControllerSize.width = self.pageView.frame.size.width
            faqOverviewControllerSize.height = self.pageView.frame.size.height

            return faqOverviewControllerSize
        }
    }

    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.pageView)
        self.view.addSubview(self.navigationOverviewController.view)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.dropButton.frame.size.width = self.canvas.draw(tiles: 3)
        self.dropButton.frame.size.height = self.dropButton.frame.size.width
        
        self.appointmentButton.frame.size.width = self.canvas.draw(tiles: 3)
        self.appointmentButton.frame.size.height = self.dropButton.frame.size.width
        
        self.navigationOverviewController.render(size: self.navigationOverviewControllerSize)
        self.navigationOverviewController.view.frame.origin.y = self.canvas.gridSize.height - self.navigationOverviewController.view.frame.size.height
        
        self.pageView.frame.size.width = self.view.frame.width
        self.pageView.frame.size.height = self.view.frame.height - self.navigationOverviewController.view.frame.height
        self.pageView.scrollThreshold = self.pageView.frame.width / 2
        
        self.appleCareNavigationController.render(size: self.appleCareNavigationControllerSize)
//        self.dropOverviewController.render(size: self.dropOverviewControllerSize)
        self.appointmentTimeOverviewController.render(size: self.appointmentTimeOverviewControllerSize)
        self.faqOverviewController.render(size: self.faqOverviewControllerSize)
        
//        self.dropOverviewController.view.frame.origin.y = self.appleCareNavigationController.view.frame.size.height
        
        self.dropButton.frame.origin.x = self.appleCareNavigationController.view.frame.size.width - self.canvas.draw(tiles: 4.5)
        self.dropButton.frame.origin.y = self.appleCareNavigationController.view.frame.size.height - self.navigationOverviewController.view.frame.size.height - self.dropButton.frame.size.height
        
        self.appointmentButton.frame.origin.x = self.appointmentTimeOverviewController.view.frame.size.width - self.canvas.draw(tiles: 4.5)
        self.appointmentButton.frame.origin.y = self.appointmentTimeOverviewController.view.frame.size.height - self.navigationOverviewController.view.frame.size.height - self.appointmentButton.frame.size.height
    }
    
    override func bind(viewModel: AppDetailViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.viewModel.delegate = self
        
        self.appleCareNavigationController.bind(viewModel: self.viewModel.appleCareNavigationViewModel)
//        self.dropOverviewController.bind(viewModel: viewModel.dropOverviewViewModel)
        self.appointmentTimeOverviewController.bind(viewModel: self.viewModel.appointmentTimeOverviewViewModel)
        self.navigationOverviewController.bind(viewModel: viewModel.navigationOverviewViewModel)
        self.faqOverviewController.bind(viewModel: viewModel.faqOverviewViewModel)

        self.appointmentStore.addObserver(self,
                                          forKeyPath: "models",
                                          options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                               NSKeyValueObservingOptions.initial]),
                                          context: nil)
        self.faqStore.addObserver(self,
                                          forKeyPath: "models",
                                          options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                               NSKeyValueObservingOptions.initial]),
                                          context: nil)
        self.navigationOverviewController.viewModel.addObserver(self,
                                                                forKeyPath: "event",
                                                                options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                                       NSKeyValueObservingOptions.initial]),
                                                                context: nil)
//        self.dropOverviewController.viewModel.addObserver(self,
//                                                          forKeyPath: "event",
//                                                          options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
//                                                                                     NSKeyValueObservingOptions.initial]),
//                                                          context: nil)
        
        self.appointmentTimeOverviewController.viewModel.addObserver(self,
                                                                     forKeyPath: "event",
                                                                     options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                                         NSKeyValueObservingOptions.initial]),
                                                                     context: nil)
        
        self.dropButton.addTarget(self.viewModel,
                                  action: #selector(self.viewModel.addDropForm),
                                  for: UIControlEvents.touchDown)
        
        self.appointmentButton.addTarget(self.viewModel,
                                         action: #selector(self.viewModel.addAppointmentForm),
                                         for: UIControlEvents.touchDown)
        
    }
    
    override func unbind()
    {
        self.viewModel.delegate = nil
        
        self.appleCareNavigationController.unbind()
//        self.dropOverviewController.unbind()
        self.appointmentTimeOverviewController.unbind()
        self.navigationOverviewController.unbind()
        self.faqOverviewController.unbind()
        
        self.navigationOverviewController.removeObserver(self, forKeyPath: "event")
//        self.dropOverviewController.removeObserver(self, forKeyPath: "event")
        
        self.dropButton.removeTarget(self.viewModel,
                                     action: #selector(self.viewModel.addDropForm),
                                     for: UIControlEvents.touchDown)
        
        self.appointmentButton.removeTarget(self.viewModel,
                                            action: #selector(self.viewModel.addAppointmentForm),
                                            for: UIControlEvents.touchDown)
        
        super.unbind()
    }
    
    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (transition == "AddDropForm")
        {
            self.enterDropForm()
        }
        else if (transition == "AddAppointmentForm")
        {
            self.enterAppointmentForm()
        }
    }
    
    override func shouldInsertKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "models")
        {
            let indexSet = change![NSKeyValueChangeKey.indexesKey] as! IndexSet

            if (self.appointmentStore === object as! NSObject)
            {
                for index in indexSet
                {
                    let appointmentModel = self.appointmentStore.retrieve(at: index)
                    let appointmentTimeViewModel = AppointmentTimeViewModel(title: appointmentModel.title,
                                                                            date: appointmentModel.date,
                                                                            time: appointmentModel.time,
                                                                            period: "")
                    self.appointmentTimeOverviewController.viewModel.appointmentTimeViewModels.insert(appointmentTimeViewModel, at: index)
                }
                self.appointmentTimeOverviewController.listView.reloadData()
            }
            else if (self.faqStore === object as! NSObject)
            {
                for index in indexSet
                {
                    let faqModel = self.faqStore.retrieve(at: index)
                    let faqViewModel = FaqViewModel(heading: faqModel.heading,
                                                                    info: faqModel.info)
                    self.faqOverviewController.viewModel.faqViewModels.append(faqViewModel)
                }
                
                self.faqOverviewController.listView.reloadData()
            }
        }
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "models")
        {
            if (self.appointmentStore === object as! NSObject)
            {
                self.appointmentTimeOverviewController.viewModel.appointmentTimeViewModels = [AppointmentTimeViewModel]()
                
                for appointmentModel in self.appointmentStore
                {
                    let appointmentTimeViewModel = AppointmentTimeViewModel(title: appointmentModel.title,
                                                                            date: appointmentModel.date,
                                                                            time: appointmentModel.time,
                                                                            period: "")
                    self.appointmentTimeOverviewController.viewModel.appointmentTimeViewModels.append(appointmentTimeViewModel)
                }
                
                self.appointmentTimeOverviewController.listView.reloadData()
            }
            else if (self.faqStore === object as! NSObject)
            {
                self.faqOverviewController.viewModel.faqViewModels = [FaqViewModel]()
                
                for faqModel in self.faqStore
                {
                    let faqViewModel = FaqViewModel(heading: faqModel.heading,
                                                    info: faqModel.info)
                    self.faqOverviewController.viewModel.faqViewModels.append(faqViewModel)
                }
                
                self.faqOverviewController.listView.reloadData()
            }
        }
        else if (keyPath == "event")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String

            if (self.viewModel.navigationOverviewViewModel === object as! NSObject)
            {
                if (newValue == "EnterDrop")
                {
                    self.pageView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UIPageViewScrollPosition.left, animated: true)
                }
                else if (newValue == "EnterAppointment")
                {
                    self.pageView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UIPageViewScrollPosition.right, animated: true)
                }
                else if (newValue == "EnterFaq")
                {
                    self.pageView.scrollToItem(at: IndexPath(item: 2, section: 0), at: UIPageViewScrollPosition.right, animated: true)
                }
                else if (newValue == "EnterInformation")
                {
                    self.pageView.scrollToItem(at: IndexPath(item: 3, section: 0), at: UIPageViewScrollPosition.right, animated: true)
                }
            }
            else if (self.dropFormDetailController != nil && self.dropFormDetailController!.viewModel === object as! NSObject)
            {
                if (newValue == "DidCreateDrop" || newValue == "DidExitDrop")
                {
                    self.exitDropForm()
                }
            }
            else if (self.appointmentFormDetailController != nil && self.appointmentFormDetailController!.viewModel === object as! NSObject)
            {
                if (newValue == "DidCreateAppointment" || newValue == "DidExitAppointment")
                {
                    self.exitAppointmentForm()
                }
            }
        }
    }
    
    @objc func enterDropForm()
    {
        self.dropFormDetailController = DropFormDetailController()
        self.dropFormDetailController!.dropStore = self.appleCareNavigationController.dropStore
        let dropFormDetailViewModel = DropFormDetailViewModel()
        self.dropFormDetailController!.bind(viewModel: dropFormDetailViewModel)
        self.dropFormDetailController!.render(size: self.view.frame.size)
        self.dropFormDetailController!.viewModel.addObserver(self,
                                                             forKeyPath: "event",
                                                             options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                                  NSKeyValueObservingOptions.initial]),
                                                             context: nil)
        self.dropFormDetailController!.dropFormInputController.colorStore.load(count: 7, info: nil, isNetworkEnabled: false)
        self.view.addSubview(self.dropFormDetailController!.view)
    }
    
    func exitDropForm()
    {
        self.dropFormDetailController!.viewModel.removeObserver(self, forKeyPath: "event")
        self.dropFormDetailController!.unbind()
        self.dropFormDetailController!.view.removeFromSuperview()
        self.dropFormDetailController = nil
    }

    func enterAppointmentForm()
    {
        self.appointmentFormDetailController = AppointmentFormDetailController()
        self.appointmentFormDetailController.appointmentStore = self.appointmentStore
        let appointmentFormDetailViewModel = AppointmentFormDetailViewModel()
        self.appointmentFormDetailController!.bind(viewModel: appointmentFormDetailViewModel)
        self.appointmentFormDetailController!.render(size: self.view.frame.size)
        self.appointmentFormDetailController!.viewModel.addObserver(self,
                                                                    forKeyPath: "event",
                                                                    options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                                         NSKeyValueObservingOptions.initial]),
                                                                    context: nil)
        self.view.addSubview(self.appointmentFormDetailController!.view)
    }
    
    func exitAppointmentForm()
    {
        self.appointmentFormDetailController!.viewModel.removeObserver(self, forKeyPath: "event")
        self.appointmentFormDetailController!.unbind()
        self.appointmentFormDetailController.view.removeFromSuperview()
        self.appointmentFormDetailController = nil
    }
    
    func pageView(_ pageView: UIPageView, numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.navigationOverviewViewModel.navigationViewModels.count
    }
    
    func pageView(_ pageView: UIPageView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)

        if (indexPath.item == 0)
        {
            itemSize.width = self.appleCareNavigationController.view.frame.width
        }
        else if (indexPath.item == 1)
        {
            itemSize.width = self.appointmentTimeOverviewController.view.frame.width
        }
        else if (indexPath.item == 2)
        {
            itemSize.width = self.faqOverviewController.view.frame.width
        }
        else if (indexPath.item == 3)
        {
        }
        
        return itemSize
    }
    
    func pageView(_ pageView: UIPageView, cellForItemAt indexPath: IndexPath) -> UIPageViewCell
    {
        let cell = UIPageViewCell()

        if (indexPath.item == 0)
        {
            cell.addSubview(self.appleCareNavigationController.view)
//            cell.addSubview(self.dropOverviewController.view)
        }
        else if (indexPath.item == 1)
        {
            cell.addSubview(self.appointmentTimeOverviewController.view)

        }
        else if (indexPath.item == 2)
        {
            cell.addSubview(self.faqOverviewController.view)
        }
        else if (indexPath.item == 3)
        {
        }

        return cell
    }
    
    func pageView(_ pageView: UIPageView, didEndDisplaying cell: UIPageViewCell, forItemAt indexPath: IndexPath)
    {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        get
        {
            return UIStatusBarStyle.lightContent
        }
    }
}
