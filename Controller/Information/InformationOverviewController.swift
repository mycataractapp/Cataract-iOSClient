//
//  InformationOverviewController.swift
//  Cataract
//
//  Created by Rose Choi on 7/4/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class InformationOverviewController : DynamicController<InformationOverviewViewModel>, UIListViewDelegate, UIListViewDataSource
{
    private var _listView : UIListView!
    private var _informationQueue : DynamicQueue<InformationController>!
    
    var listView : UIListView!
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
    
    var informationQueue : DynamicQueue<InformationController>
    {
        get
        {
            if (self._informationQueue == nil)
            {
                self._informationQueue = DynamicQueue()
            }
            
            let informationQueue = self._informationQueue!
            
            return informationQueue
        }
    }
    
    var informationControllerSize : CGSize
    {
        get
        {
            var informationControllerSize = CGSize.zero
            informationControllerSize.width = self.listView.frame.size.width
            informationControllerSize.height = self.canvas.draw(tiles: 5)
            
            return informationControllerSize
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
        self.informationQueue.purge
        { (indentifier, informationController) in
            
            informationController.unbind()
        }
        
        super.unbind()
    }
    
    func listView(_ listView: UIListView, numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.informationViewModels.count
    }
    
    func listView(_ listView: UIListView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
        let informationController = self.informationQueue.retrieveElement(withIdentifier: String(indexPath.item))
        
        if (informationController != nil)
        {
            itemSize.width = informationController!.view.frame.size.width
            itemSize.height = informationController!.view.frame.size.height
        }
        
        return itemSize
    }
    
    func listView(_ listView: UIListView, cellForItemAt indexPath: IndexPath) -> UIListViewCell
    {
        let cell = UIListViewCell()
        
        let informationController = self.informationQueue.dequeueElement(withIdentifier: String(indexPath.item))
        { () -> InformationController in
            
            let informationController = InformationController()
            
            return informationController
        }
        
        let informationViewModel = self.viewModel.informationViewModels[indexPath.item]
        informationController.bind(viewModel: informationViewModel)
        informationController.render(size: self.informationControllerSize)
        cell.addSubview(informationController.view)
        
        return cell
    }
    
    func listView(_ listView: UIListView, didEndDisplaying cell: UIListViewCell, forItemAt indexPath: IndexPath)
    {
        self.informationQueue.enqueueElement(withIdentifier: String(indexPath.item))
        { (informationController) in
            
            if (informationController != nil)
            {
                informationController!.unbind()
            }
        }
    }
}
