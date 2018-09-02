//
//  MenuOverviewController.swift
//  MyCataractApp
//
//  Created by Roseanne Choi on 8/26/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit

class MenuOverviewController : DynamicController<MenuOverviewViewModel>, UIListViewDelegate, UIListViewDataSource
{
    private var _listView : UIListView!
    private var _menuQueue : DynamicQueue<MenuController>!
    
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
    
    var menuQueue : DynamicQueue<MenuController>
    {
        get
        {
            if (self._menuQueue == nil)
            {
                self._menuQueue = DynamicQueue()
            }
            
            let menuQueue = self._menuQueue!
            
            return menuQueue
        }
    }
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(listView)
    }
    
    var menuControllerSize : CGSize
    {
        get
        {
            var menuControllerSize = CGSize.zero
            menuControllerSize.width = self.listView.frame.size.width
            menuControllerSize.height = self.canvas.draw(tiles: 3)
            
            return menuControllerSize
        }
    }
    
    override func render(size: CGSize)
    {
        super.render(size: size)
        
        self.listView.frame.size = self.view.frame.size
    }
    
    override func unbind()
    {
        self.menuQueue.purge
        { (identifier, menuController) in
            
            menuController.unbind()
        }
        
        super.unbind()
    }
    
    func listView(_ listView: UIListView, numberOfItemsInSection section: Int) -> Int
    {
        return self.viewModel.menuViewModels.count
    }
    
    func listView(_ listView: UIListView, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
        let menuController = self.menuQueue.retrieveElement(withIdentifier: String(indexPath.item))
        
        if (menuController != nil)
        {
            itemSize.height = menuController!.view.frame.size.height
        }
        
        return itemSize
    }
    
    func listView(_ listView: UIListView, cellForItemAt indexPath: IndexPath) -> UIListViewCell
    {
        let cell = UIListViewCell()
        
        let menuController = self.menuQueue.dequeueElement(withIdentifier: String(indexPath.item))
        { () -> MenuController in
            
            let menuController = MenuController()
            
            return menuController
        }
        
        let menuViewModel = self.viewModel.menuViewModels[indexPath.item]
        menuController.bind(viewModel: menuViewModel)
        menuController.render(size: self.menuControllerSize)
        cell.addSubview(menuController.view)
        
        return cell
    }
    
    func listView(_ listView: UIListView, didEndDisplaying cell: UIListViewCell, forItemAt indexPath: IndexPath)
    {
        self.menuQueue.enqueueElement(withIdentifier: String(indexPath.item))
        { (menuController) in
            
            menuController?.unbind()
        }
    }
    
    func listView(_ listView: UIListView, willSelectItemAt indexPath: IndexPath) -> IndexPath
    {
        self.viewModel.toggle(at: indexPath.item)
        
        return indexPath
    }
}
