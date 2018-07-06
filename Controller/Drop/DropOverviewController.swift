//
//  DropOverviewController.swift
//  Cataract
//
//  Created by Rose Choi on 6/6/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class DropOverviewController : DynamicController<DropOverviewViewModel>, UIListViewDelegate, UIListViewDataSource, DynamicViewModelDelegate
{
    private var _listView : UIListView!
    private var _button : UIButton!
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
    
    var button : UIButton
    {
        get
        {
            if (self._button == nil)
            {
                self._button = UIButton()
                self._button.setImage(UIImage(contentsOfFile: Bundle.main.path(forResource: "Add", ofType: "png")!),
                                      for: UIControlState.normal)
            }
            
            let button = self._button!
            
            return button
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
        self.view.addSubview(self.button)
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.button.frame.size.width = self.canvas.draw(tiles: 1)
        self.button.frame.size.height = self.button.frame.size.width
        self.button.frame.origin.x = self.view.frame.size.width - self.canvas.draw(tiles: 1)
        self.button.frame.origin.y = self.view.frame.size.height - self.canvas.draw(tiles: 1)
        
        self.listView.frame.size.width = self.view.frame.size.width
        self.listView.frame.size.height = self.view.frame.size.height - self.button.frame.size.height
    }
    
    override func bind(viewModel: DropOverviewViewModel)
    {
        super.bind(viewModel: viewModel)
        
        self.viewModel.delegate = self
        
        self.button.addTarget(self.viewModel,
                              action: #selector(self.viewModel.add),
                              for: UIControlEvents.touchDown)
    }
    
    override func unbind()
    {
        self.viewModel.delegate = nil
        
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
    
    func viewModel(_ viewModel: DynamicViewModel, transition: String, from oldState: String, to newState: String)
    {
        if (transition == "Add")
        {
        }
    }
}
