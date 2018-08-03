//
//  TimeOverviewController.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/21/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class TimeOverviewController : DynamicController<TimeOverviewViewModel>, UIListViewDelegate, UIListViewDataSource
{
    private var _listView : UIListView!
    private var _timeQueue : DynamicQueue<TimeController>!
    
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
    
    var timeQueue : DynamicQueue<TimeController>
    {
        get
        {
            if (self._timeQueue == nil)
            {
                self._timeQueue = DynamicQueue()
            }
            
            let timeQueue = self._timeQueue!
            
            return timeQueue
        }
    }
    
    var timeControllerSize : CGSize
    {
        get
        {
            var timeControllerSize = CGSize.zero
            timeControllerSize.width = self.listView.frame.size.width
            timeControllerSize.height = self.canvas.draw(tiles: 5)
            
            return timeControllerSize
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
        self.timeQueue.purge
        { (identifier, timeController) in
            
            timeController.unbind()
        }
        
        super.unbind()
    }

    func listView(_ listView: UIListView, numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.timeViewModels.count
    }
    
    func listView(_ listView: UIListView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
        let timeController = self.timeQueue.retrieveElement(withIdentifier: String(indexPath.item))
        
        if (timeController != nil)
        {
            
            itemSize.height = timeController!.view.frame.size.height
        }
        
        return itemSize
    }
    
    func listView(_ listView: UIListView, cellForItemAt indexPath: IndexPath) -> UIListViewCell
    {
        let cell = UIListViewCell()
        
        let timeController = self.timeQueue.dequeueElement(withIdentifier: String(indexPath.item))
        { () -> TimeController in
            
            let timeController = TimeController()
            
            return timeController
        }
        
        let timeViewModel = self.viewModel.timeViewModels[indexPath.item]
        timeController.bind(viewModel: timeViewModel)
        timeController.render(size: self.timeControllerSize)
        cell.addSubview(timeController.view)
        
        return cell
    }
    
    func listView(_ listView: UIListView, didEndDisplaying cell: UIListViewCell, forItemAt indexPath: IndexPath)
    {
        self.timeQueue.enqueueElement(withIdentifier: String(indexPath.item))
        { (timeController) in
            
            if (timeController != nil)
            {
                timeController!.unbind()
            }
        }
    }
}
