//
//  DropTimeOverviewController.swift
//  Cataract
//
//  Created by Rose Choi on 6/6/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DropTimeOverviewController : DynamicController<DropTimeOverviewViewModel>, UIListViewDelegate, UIListViewDataSource
{
    private var _listView : UIListView!
    private var _dropTimeQueue : DynamicQueue<DropTimeController>!

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

    var dropTimeQueue : DynamicQueue<DropTimeController>
    {
        get
        {
            if (self._dropTimeQueue == nil)
            {
                self._dropTimeQueue = DynamicQueue()
            }
            
            let dropTimeQueue = self._dropTimeQueue!
            
            return dropTimeQueue
        }
    }

    var dropTimeControllerSize : CGSize
    {
        get
        {
            var dropTimeControllerSize = CGSize.zero
            dropTimeControllerSize.width = self.canvas.gridSize.width
            dropTimeControllerSize.height = self.canvas.draw(tiles: 5)
            
            return dropTimeControllerSize
        }
    }
    
    override func viewDidLoad()
    {
        self.view.addSubview(self.listView)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        self.listView.frame.size = self.view.frame.size
    }
    
    override func unbind()
    {
        self.dropTimeQueue.purge
        { (identifier, dropTimeController) in
            
            dropTimeController.unbind()
        }
        
        super.unbind()
    }
    
    func listView(_ listView: UIListView, numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.dropTimeViewModels.count
    }
    
    func listView(_ listView: UIListView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
        let dropTimeController = self.dropTimeQueue.retrieveElement(withIdentifier: String(indexPath.item))
        
        if (dropTimeController != nil)
        {
            itemSize.height = dropTimeController!.view.frame.height + self.canvas.draw(tiles: 0.25)
        }
        
        return itemSize
    }
    
    func listView(_ listView: UIListView, cellForItemAt indexPath: IndexPath) -> UIListViewCell
    {
        let cell = UIListViewCell()
        
        let dropTimeController = self.dropTimeQueue.dequeueElement(withIdentifier: String(indexPath.item))
        { () -> DropTimeController in
            
            let dropTimeController = DropTimeController()
            
            return dropTimeController
        }
        
        let dropTimeViewModel = self.viewModel.dropTimeViewModels[indexPath.item]
        dropTimeController.bind(viewModel: dropTimeViewModel)
        dropTimeController.render(size: self.dropTimeControllerSize)
        cell.addSubview(dropTimeController.view)
        
        return cell
    }
    
    func listView(_ listView: UIListView, didEndDisplaying cell: UIListViewCell, forItemAt indexPath: IndexPath)
    {
        self.dropTimeQueue.enqueueElement(withIdentifier: String(indexPath.item))
        { (dropTimeController) in
            
            if (dropTimeController != nil)
            {
                dropTimeController!.unbind()
            }
        }
    }
}
