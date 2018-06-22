//
//  AppDetailController.swift
//  Cataract
//
//  Created by Rose Choi on 6/9/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class AppDetailController : DynamicController<AppDetailViewModel>, UIPageViewDelegate, UIPageViewDataSource
{
    private var _pageView : UIPageView!
    private var _dropTrackerController : DropTrackerController!
    private var _dropOverviewController : DropOverviewController!
    private var _appointmentController : AppointmentController!
    private var _appointmentTimeOverviewController : AppointmentTimeOverviewController!
    private var _navigationOverviewController : NavigationOverviewController!
    private var _dropStore : DropStore!
    private var _appointmentStore : AppointmentStore!
    
    var pageView : UIPageView
    {
        get
        {
            if (self._pageView == nil)
            {
                self._pageView = UIPageView()
                self._pageView.delegate = self
                self._pageView.dataSource = self
                self._pageView.isSlidingEnabled = true
                self._pageView.backgroundColor = UIColor.white
            }
            
            let pageView = self._pageView!
            
            return pageView
        }
    }
    
    var dropTrackerController : DropTrackerController
    {
        get
        {
            if (self._dropTrackerController == nil)
            {
                self._dropTrackerController = DropTrackerController()
            }

            let dropTrackerController = self._dropTrackerController!

            return dropTrackerController
        }
    }
    
    var dropOverviewController : DropOverviewController
    {
        get
        {
            if (self._dropOverviewController == nil)
            {
                self._dropOverviewController = DropOverviewController()
            }
            
            let dropOverviewController = self._dropOverviewController!
            
            return dropOverviewController
        }
    }
    
    var appointmentController : AppointmentController
    {
        get
        {
            if (self._appointmentController == nil)
            {
                self._appointmentController = AppointmentController()
            }
            
            let appointmentController = self._appointmentController!
            
            return appointmentController
        }
    }
    
    var appointmentTimeOverviewController : AppointmentTimeOverviewController
    {
        get
        {
            if (self._appointmentTimeOverviewController == nil)
            {
                self._appointmentTimeOverviewController = AppointmentTimeOverviewController()
                self._appointmentTimeOverviewController.listView.listHeaderView = self.appointmentController.view
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
    
    var dropStore : DropStore
    {
        get
        {
            if (self._dropStore == nil)
            {
                self._dropStore = DropStore()
            }
            
            let dropStore = self._dropStore!
            
            return dropStore
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
    
    var dropTrackerControllerSize : CGSize
    {
        get
        {
            var dropTrackerControllerSize = CGSize.zero
            dropTrackerControllerSize.width = self.view.frame.size.width
            dropTrackerControllerSize.height = self.canvas.draw(tiles: 9)

            return dropTrackerControllerSize
        }
    }
    
    var dropOverviewControllerSize : CGSize
    {
        get
        {
            var dropOverviewControllerSize = CGSize.zero
            dropOverviewControllerSize.width = self.pageView.frame.size.width
            dropOverviewControllerSize.height = self.pageView.frame.height - self.dropTrackerController.view.frame.height
            
            return dropOverviewControllerSize
        }
    }
    
    var appointmentControllerSize : CGSize
    {
        get
        {
            var appointmentControllerSize = CGSize.zero
            appointmentControllerSize.width = self.view.frame.size.width
            appointmentControllerSize.height = self.canvas.draw(tiles: 9)
            
            return appointmentControllerSize
        }
    }
    
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
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.pageView)
        self.view.addSubview(self.navigationOverviewController.view)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.navigationOverviewController.render(size: self.navigationOverviewControllerSize)
        self.navigationOverviewController.view.frame.origin.y = self.canvas.gridSize.height - self.navigationOverviewController.view.frame.size.height
        
        self.pageView.frame.size.width = self.view.frame.width
        self.pageView.frame.size.height = self.view.frame.height - self.navigationOverviewController.view.frame.height
        self.pageView.slidingDistance = self.pageView.frame.width / 2
        
        self.dropTrackerController.render(size: self.dropTrackerControllerSize)
        self.dropOverviewController.render(size: self.dropOverviewControllerSize)
        self.appointmentController.render(size: self.appointmentControllerSize)
        self.appointmentTimeOverviewController.render(size: self.appointmentTimeOverviewControllerSize)
        
        self.dropOverviewController.view.frame.origin.y = self.dropTrackerController.view.frame.size.height
    }
    
    override func bind(viewModel: AppDetailViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.dropTrackerController.bind(viewModel: self.viewModel.dropTrackerViewModel)
        self.dropOverviewController.bind(viewModel: viewModel.dropOverviewViewModel)
        self.appointmentController.bind(viewModel: viewModel.appointmentViewModel)
        self.appointmentTimeOverviewController.bind(viewModel: viewModel.appointmentTimeOverviewViewModel)
        self.navigationOverviewController.bind(viewModel: viewModel.navigationOverviewViewModel)
        
        self.dropStore.addObserver(self,
                                   forKeyPath: "models",
                                   options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                        NSKeyValueObservingOptions.initial]),
                                   context: nil)
        self.appointmentStore.addObserver(self,
                                          forKeyPath: "models",
                                          options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                               NSKeyValueObservingOptions.initial]),
                                          context: nil)
        self.navigationOverviewController.viewModel.addObserver(self,
                                                      forKeyPath: "event",
                                                      options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                           NSKeyValueObservingOptions.initial]),
                                                      context: nil)
    }
    
    override func unbind()
    {
        self.dropTrackerController.unbind()
        self.dropOverviewController.unbind()
        self.appointmentController.unbind()
        self.appointmentTimeOverviewController.unbind()
        self.navigationOverviewController.unbind()
        
        self.navigationOverviewController.removeObserver(self, forKeyPath: "event")

        super.unbind()
    }
    
    override func shouldInsertKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "models")
        {
            let indexSet = change![NSKeyValueChangeKey.indexesKey] as! IndexSet

            if (self.dropStore === object as! NSObject)
            {
                self.dropOverviewController.viewModel.dropViewModels = [DropTrackerTimeViewModel]()
                
                for index in indexSet
                {
                    let dropModel = self.dropStore.retrieve(at: index)
                    let dropViewModel = DropTrackerTimeViewModel(colorPathByState: dropModel.colorPathByState,
                                                              drop: dropModel.drop,
                                                              time: dropModel.time,
                                                              isSelected: false)
                    self.dropOverviewController.viewModel.dropViewModels.append(dropViewModel)
                }
                
                self.dropOverviewController.listView.reloadData()
            }
            else if (self.appointmentStore === object as! NSObject)
            {
                self.appointmentTimeOverviewController.viewModel.appointmentTimeViewModels = [AppointmentTimeViewModel]()
                
                for index in indexSet
                {
                    let appointmentModel = self.appointmentStore.retrieve(at: index)
                    let appointmentTimeViewModel = AppointmentTimeViewModel(title: appointmentModel.title,
                                                                            date: appointmentModel.date,
                                                                            time: appointmentModel.time)
                    self.appointmentTimeOverviewController.viewModel.appointmentTimeViewModels.append(appointmentTimeViewModel)
                }
                
                self.appointmentTimeOverviewController.listView.reloadData()
            }
        }
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "event")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String
            
            if (newValue == "EnterDropTracker")
            {
                self.pageView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UIPageViewScrollPosition.left, animated: true)
            }
            else if (newValue == "EnterAppointment")
            {
                self.pageView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UIPageViewScrollPosition.left, animated: true)
            }
        }
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
            itemSize.width = self.dropOverviewController.view.frame.width
        }
        else if (indexPath.item == 1)
        {
            itemSize.width = appointmentTimeOverviewController.view.frame.width
        }
        
        return itemSize
    }
    
    func pageView(_ pageView: UIPageView, cellForItemAt indexPath: IndexPath) -> UIPageViewCell
    {
        let cell = UIPageViewCell()

        if (indexPath.item == 0)
        {
            cell.addSubview(self.dropTrackerController.view)
            cell.addSubview(self.dropOverviewController.view)
        }
        else if (indexPath.item == 1)
        {
            cell.addSubview(self.appointmentTimeOverviewController.view)
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
