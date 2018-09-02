//
//  InputOverviewController.swift
//  Cataract
//
//  Created by Roseanne Choi on 7/15/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import UIKit

class InputOverviewController : DynamicController<InputOverviewViewModel>, UIListViewDataSource, UIListViewDelegate
{
    private var _listView : UIListView!
    private var _inputQueue : DynamicQueue<InputController>!
    
    var listView : UIListView!
    {
        get
        {
            if (self._listView == nil)
            {
                self._listView = UIListView()
                self._listView.dataSource = self
                self._listView.delegate = self
            }
            
            let listView = self._listView
            
            return listView
        }
    }
    
    var inputQueue : DynamicQueue<InputController>!
    {
        get
        {
            if (self._inputQueue == nil)
            {
                self._inputQueue = DynamicQueue()
            }
            
            let inputQueue = self._inputQueue
            
            return inputQueue
        }
    }
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.listView)
    }
    
    var inputControllerSize : CGSize
    {
        get
        {
            var inputControllerSize = CGSize.zero
            inputControllerSize.width = self.view.frame.size.width
            inputControllerSize.height = self.canvas.draw(tiles: 3)
            
            return inputControllerSize
        }
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.listView.frame.size = self.view.frame.size
    }
    
    override func unbind()
    {
        self.inputQueue.purge
        { (identifier, inputController) in
                
            inputController.unbind()
        }
        
        super.unbind()
    }
    
    func listView(_ listView: UIListView, numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.inputViewModels.count
    }
    
    func listView(_ listView: UIListView, cellForItemAt indexPath: IndexPath) -> UIListViewCell
    {
        let cell = UIListViewCell()
        
        let inputController = self.inputQueue.dequeueElement(withIdentifier: String(indexPath.item))
        { () -> InputController in
            
            let inputController = InputController()
            
            return inputController
        }
        
        let inputViewModel = self.viewModel.inputViewModels[indexPath.item]
        inputController.bind(viewModel: inputViewModel)
        inputController.render(size: self.inputControllerSize)
        cell.addSubview(inputController.view)
        
        return cell
    }
    
    func listView(_ listView: UIListView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
        let inputController = self.inputQueue.retrieveElement(withIdentifier: String(indexPath.item))
        
        if (inputController != nil)
        {
            itemSize.height = inputController!.view.frame.size.height
        }
        
        return itemSize
    }
    
    func listView(_ listView: UIListView, didEndDisplaying cell: UIListViewCell, forItemAt indexPath: IndexPath)
    {
        self.inputQueue.enqueueElement(withIdentifier: String(indexPath.item))
        { (inputController) in
            
            if (inputController != nil)
            {
                inputController!.unbind()
            }
        }
    }
}
