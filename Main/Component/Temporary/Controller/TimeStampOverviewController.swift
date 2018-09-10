//
//  TimeStampOverviewController.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/25/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class TimeStampOverviewController : DynamicController, UIListViewDelegate, UIListViewDataSource
{
    private var _listView : UIListView!
    private var _timeStampQueue : DynamicQueue<TimeStampController>!
    
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
    
    var timeStampQueue : DynamicQueue<TimeStampController>
    {
        get
        {
            if (self._timeStampQueue == nil)
            {
                self._timeStampQueue = DynamicQueue()
            }
            
            let timeStampQueue = self._timeStampQueue!
            
            return timeStampQueue
        }
    }
    
    var timeStampControllerSize : CGSize
    {
        get
        {
            var timeStampControllerSize = CGSize.zero
            timeStampControllerSize.width = self.listView.frame.size.width
            timeStampControllerSize.height = canvas.draw(tiles: 3)
            
            return timeStampControllerSize
        }
    }
    
    override func viewDidLoad()
    {
        self.listView.backgroundColor = UIColor.white
        
        self.view.addSubview(self.listView)
    }
    
    override func render(canvas: DynamicCanvas) -> DynamicCanvas
    {
        super.render(canvas: canvas)
        self.view.frame.size = canvas.size
        
        self.listView.frame.size = self.view.frame.size
        self.listView.reloadData()
        
        return canvas
    }
    
    override func unbind()
    {
        self.timeStampQueue.purge
        { (identifier, timeStampController) in
            
            timeStampController.unbind()
        }
        
        super.unbind()
    }
    
    func listView(_ listView: UIListView, numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.timeStampViewModels.count
    }
    
    func listView(_ listView: UIListView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
        let timeStampController = self.timeStampQueue.retrieveElement(withIdentifier: String(indexPath.item))
        
        if (timeStampController != nil)
        {
            
            itemSize.height = timeStampController!.view.frame.size.height
        }
        
        return itemSize
    }
    
    func listView(_ listView: UIListView, cellForItemAt indexPath: IndexPath) -> UIListViewCell
    {
        let cell = UIListViewCell()
        
        let timeStampController = self.timeStampQueue.dequeueElement(withIdentifier: String(indexPath.item))
        { () -> TimeStampController in
            
            let timeStampController = TimeStampController()
            
            return timeStampController
        }
        
        let timeStampViewModel = self.viewModel.timeStampViewModels[indexPath.item]
        timeStampController.viewModel = timeStampViewModel
        cell.addSubview(timeStampController.view)
        
        return cell
    }
    
    func listView(_ listView: UIListView, didEndDisplaying cell: UIListViewCell, forItemAt indexPath: IndexPath)
    {
        self.timeStampQueue.enqueueElement(withIdentifier: String(indexPath.item))
        { (timeStampController) in
            
            if (timeStampController != nil)
            {
                timeStampController!.unbind()
            }
        }
    }
}
