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
    private var _dropController : DropController!
    private var _dropTimeOverviewController : DropTimeOverviewController!
    private var _appointmentController : AppointmentController!
    private var _appointmentTimeOverviewController : AppointmentTimeOverviewController!
    private var _navigationOverviewController : NavigationOverviewController!
    
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
    
    var dropController : DropController
    {
        get
        {
            if (self._dropController == nil)
            {
                self._dropController = DropController()
            }

            let dropController = self._dropController!

            return dropController
        }
    }
    
    var dropTimeOverviewController : DropTimeOverviewController
    {
        get
        {
            if (self._dropTimeOverviewController == nil)
            {
                self._dropTimeOverviewController = DropTimeOverviewController()
            }
            
            let dropTimeOverviewController = self._dropTimeOverviewController!
            
            return dropTimeOverviewController
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
    
    var dropControllerSize : CGSize
    {
        get
        {
            var dropControllerSize = CGSize.zero
            dropControllerSize.width = self.view.frame.size.width
            dropControllerSize.height = self.canvas.draw(tiles: 9)

            return dropControllerSize
        }
    }
    
    var dropTimeOverviewControllerSize : CGSize
    {
        get
        {
            var dropTimeOverviewControllerSize = CGSize.zero
            dropTimeOverviewControllerSize.width = self.pageView.frame.size.width
            dropTimeOverviewControllerSize.height = self.pageView.frame.height - self.dropController.view.frame.height
            
            return dropTimeOverviewControllerSize
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
        
        self.dropController.render(size: self.dropControllerSize)
        self.dropTimeOverviewController.render(size: self.dropTimeOverviewControllerSize)
        self.appointmentController.render(size: self.appointmentControllerSize)
        self.appointmentTimeOverviewController.render(size: self.appointmentTimeOverviewControllerSize)
        
        self.dropTimeOverviewController.view.frame.origin.y = self.dropController.view.frame.size.height
//        self.appointmentTimeOverviewController.view.frame.origin.y = self.appointmentController.view.frame.size.height
    }
    
    override func bind(viewModel: AppDetailViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.dropController.bind(viewModel: self.viewModel.dropViewModel)
        self.dropTimeOverviewController.bind(viewModel: viewModel.dropTimeOverviewViewModel)
        self.appointmentController.bind(viewModel: viewModel.appointmentViewModel)
        self.appointmentTimeOverviewController.bind(viewModel: viewModel.appointmentTimeOverviewViewModel)
        self.navigationOverviewController.bind(viewModel: viewModel.navigationOverviewViewModel)
        
        self.navigationOverviewController.viewModel.addObserver(self,
                                                      forKeyPath: "event",
                                                      options: NSKeyValueObservingOptions([NSKeyValueObservingOptions.new,
                                                                                           NSKeyValueObservingOptions.initial]),
                                                      context: nil)
    }
    
    override func unbind()
    {
        self.dropController.unbind()
        self.dropTimeOverviewController.unbind()
        self.appointmentController.unbind()
        self.appointmentTimeOverviewController.unbind()
        self.navigationOverviewController.unbind()
        
        self.navigationOverviewController.removeObserver(self, forKeyPath: "event")

        super.unbind()
    }
    
    override func shouldSetKeyPath(_ keyPath: String?, ofObject object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "event")
        {
            let newValue = change![NSKeyValueChangeKey.newKey] as! String

            if (newValue == "DidSelectDrop")
            {
                self.pageView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UIPageViewScrollPosition.left, animated: true)
            }
            else if (newValue == "DidSelectAppointment")
            {
                self.pageView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UIPageViewScrollPosition.left, animated: true)
            }
        }
    }
    
    func pageView(_ pageView: UIPageView, numberOfItemsInSection section: Int) -> Int
    {
//        return self.viewModel.navigationOverviewViewModel.navigationViewModels.count
        return 2
    }
    
    func pageView(_ pageView: UIPageView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)

        if (indexPath.item == 0)
        {
            itemSize.width = self.dropTimeOverviewController.view.frame.width
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
            cell.addSubview(self.dropController.view)
            cell.addSubview(self.dropTimeOverviewController.view)
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
}
