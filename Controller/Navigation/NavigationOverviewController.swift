//
//  NavigationOverviewController.swift
//  Cataract
//
//  Created by Rose Choi on 6/9/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class NavigationOverviewController : DynamicController<NavigationOverviewViewModel>, UIPageViewDelegate, UIPageViewDataSource
{
    private var _pageView : UIPageView!
    private var _navigationQueue : DynamicQueue<NavigationController>!
    
    var pageView : UIPageView
    {
        get
        {
            if (self._pageView == nil)
            {
                self._pageView = UIPageView()
                self._pageView.delegate = self
                self._pageView.dataSource = self
                self._pageView.backgroundColor = UIColor.white
            }
            
            let pageView = self._pageView!
            
            return pageView
        }
    }
    
    var navigationQueue : DynamicQueue<NavigationController>!
    {
        get
        {
            if (self._navigationQueue == nil)
            {
                self._navigationQueue = DynamicQueue()
            }
            
            let navigationQueue = self._navigationQueue!
            
            return navigationQueue
        }
    }
    
    var navigationControllerSize : CGSize
    {
        get
        {
            var navigationControllerSize = CGSize.zero
            navigationControllerSize.width = self.canvas.gridSize.width / CGFloat(self.viewModel.navigationViewModels.count)
            navigationControllerSize.height = self.view.frame.height
            
            return navigationControllerSize
        }
    }
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.pageView)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.pageView.frame.size = self.view.frame.size
    }
    
    override func unbind()
    {
        self.navigationQueue.purge
        { (identifier, navigationController) in
            
            navigationController.unbind()
        }
        
        super.unbind()
    }
    
    func pageView(_ pageView: UIPageView, numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.navigationViewModels.count
    }
    
    func pageView(_ pageView: UIPageView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
        let navigationController = self.navigationQueue.retrieveElement(withIdentifier: String(indexPath.item))
        
        if (navigationController != nil)
        {
            itemSize.width = navigationController!.view.frame.width
        }
        
        return itemSize
    }
    
    func pageView(_ pageView: UIPageView, cellForItemAt indexPath: IndexPath) -> UIPageViewCell
    {
        let cell = UIPageViewCell()
        
        let navigationController = self.navigationQueue.dequeueElement(withIdentifier: String(indexPath.item))
        { () -> NavigationController in
            
            let navigationController = NavigationController()
            
            return navigationController
        }
        
        let navigationViewModel = self.viewModel.navigationViewModels[indexPath.item]
        navigationController.bind(viewModel: navigationViewModel)
        navigationController.render(size: self.navigationControllerSize)
        cell.addSubview(navigationController.view)
        
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.10
        cell.layer.shadowRadius = 20
        
        return cell
    }
    
    func pageView(_ pageView: UIPageView, didEndDisplaying cell: UIPageViewCell, forItemAt indexPath: IndexPath)
    {
        self.navigationQueue.enqueueElement(withIdentifier: String(indexPath.item))
        { (navigationController) in
            
            if (navigationController != nil)
            {
                navigationController!.unbind()
            }
        }
    }
    
    func pageView(_ pageView: UIPageView, willSelectItemAt indexPath: IndexPath) -> IndexPath?
    {
        self.viewModel.toggle(at: indexPath.item)
        
        return indexPath
    }
}

//navigationOverviewViewModel contains an array of navigationViewModels, use that array to access the appropriate navigationViewModel to call select or deselect.
