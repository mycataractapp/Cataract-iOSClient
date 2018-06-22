//
//  WeekDayOverviewController.swift
//  Cataract
//
//  Created by Rose Choi on 6/19/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class WeekDayOverviewController : DynamicController<WeekDayOverviewViewModel>, UIListViewDelegate, UIListViewDataSource
{
    private var _listView : UIListView!
    private var _weekDayQueue : DynamicQueue<WeekDayController>!
    
    var listView : UIListView
    {
        get
        {
            if (self._listView == nil)
            {
                self._listView = UIListView()
                self._listView.delegate = self
                self._listView.dataSource = self
            }
            
            let listView = self._listView!
            
            return listView
        }
    }
    
    var weekDayQueue : DynamicQueue<WeekDayController>
    {
        get
        {
            if (self._weekDayQueue == nil)
            {
                self._weekDayQueue = DynamicQueue()
            }
            
            let weekDayQueue = self._weekDayQueue!
            
            return weekDayQueue
        }
    }
    
    var weekDayControllerSize : CGSize
    {
        get
        {
            var weekDayControllerSize = CGSize.zero
            weekDayControllerSize.width = self.view.frame.size.width
            weekDayControllerSize.height = self.listView.frame.size.height / CGFloat(self.viewModel.weekDayViewModels.count + 1)
            
            return weekDayControllerSize
        }
    }
    
    override func viewDidLoad()
    {
        self.listView.backgroundColor = UIColor.white
        
        self.view.addSubview(self.listView)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.listView.frame.size = self.view.frame.size
    }
    
    override func unbind()
    {
        self.weekDayQueue.purge
        { (identifier, weekDayController) in
                
            weekDayController.unbind()
        }
        
        super.unbind()
    }
    
    func listView(_ listView: UIListView, numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.weekDayViewModels.count
    }
    
    func listView(_ listView: UIListView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
        let weekDayController = self.weekDayQueue.retrieveElement(withIdentifier: String(indexPath.item))
        
        if (weekDayController != nil)
        {
            itemSize.width = weekDayController!.view.frame.size.width
            itemSize.height = weekDayController!.view.frame.size.height
        }
        
        return itemSize
    }
    
    func listView(_ listView: UIListView, cellForItemAt indexPath: IndexPath) -> UIListViewCell
    {
        let cell = UIListViewCell()
        
        let weekDayController = self.weekDayQueue.dequeueElement(withIdentifier: String(indexPath.item))
        { () -> WeekDayController in
            
            let weekDayController = WeekDayController()
            
            return weekDayController
        }
        
        let weekDayViewModel = self.viewModel.weekDayViewModels[indexPath.item]
        weekDayController.bind(viewModel: weekDayViewModel)
        weekDayController.render(size: self.weekDayControllerSize)
        cell.addSubview(weekDayController.view)
        
        return cell
    }
    
    func listView(_ listView: UIListView, willSelectItemAt indexPath: IndexPath) -> IndexPath?
    {
        let weekDayViewModel = self.viewModel.weekDayViewModels[indexPath.item]
        weekDayViewModel.toggle()
        
        return indexPath
    }
    
    func listView(_ listView: UIListView, didEndDisplaying cell: UIListViewCell, forItemAt indexPath: IndexPath)
    {
        self.weekDayQueue.enqueueElement(withIdentifier: String(indexPath.item))
        { (weekDayController) in
            
            if (weekDayController != nil)
            {
                weekDayController!.unbind()
            }
        }
    }
}
