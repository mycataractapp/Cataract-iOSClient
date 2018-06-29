//
//  DropOverviewController.swift
//  Cataract
//
//  Created by Rose Choi on 6/6/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DropOverviewController : DynamicController<DropOverviewViewModel>, UIListViewDelegate, UIListViewDataSource
{
    private var _listView : UIListView!
    private var _dropQueue : DynamicQueue<DropController>!

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

    var dropQueue : DynamicQueue<DropController>
    {
        get
        {
            if (self._dropQueue == nil)
            {
                self._dropQueue = DynamicQueue()
            }
            
            let dropQueue = self._dropQueue!
            
            return dropQueue
        }
    }

    var dropControllerSize : CGSize
    {
        get
        {
            var dropControllerSize = CGSize.zero
            dropControllerSize.width = self.canvas.gridSize.width
            dropControllerSize.height = self.canvas.draw(tiles: 5)
            
            return dropControllerSize
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
        self.dropQueue.purge
        { (identifier, dropController) in
            
            dropController.unbind()
        }
        
        super.unbind()
    }
    
    func listView(_ listView: UIListView, numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.dropViewModels.count
    }
    
    func listView(_ listView: UIListView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
        let dropController = self.dropQueue.retrieveElement(withIdentifier: String(indexPath.item))
        
        if (dropController != nil)
        {
            itemSize.height = dropController!.view.frame.height + self.canvas.draw(tiles: 0.25)
        }
        
        return itemSize
    }
    
    func listView(_ listView: UIListView, cellForItemAt indexPath: IndexPath) -> UIListViewCell
    {
        let cell = UIListViewCell()
        
        let dropController = self.dropQueue.dequeueElement(withIdentifier: String(indexPath.item))
        { () -> DropController in
            
            let dropController = DropController()
            
            return dropController
        }
        
        let dropViewModel = self.viewModel.dropViewModels[indexPath.item]
        dropController.bind(viewModel: dropViewModel)
        dropController.render(size: self.dropControllerSize)
        cell.addSubview(dropController.view)
        
        return cell
    }
    
    func listView(_ listView: UIListView, didEndDisplaying cell: UIListViewCell, forItemAt indexPath: IndexPath)
    {
        self.dropQueue.enqueueElement(withIdentifier: String(indexPath.item))
        { (dropController) in
            
            if (dropController != nil)
            {
                dropController!.unbind()
            }
        }
    }
}
