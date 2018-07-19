//
//  UIPageViewMetaGroup.swift
//  Pacific
//
//  Created by Minh Nguyen on 2/4/18.
//  Copyright © 2018 Langtutheky. All rights reserved.
//

import UIKit

class UIPageViewMetaGroup : NSObject, UIMetaDelegate
{
    private var _cursoredItem = 0
    private var _section = 0
    private var _initialOffset : CGFloat = 0
    private var _width : CGFloat = 0
    private var _height : CGFloat = 0
    private var _cellMetas = [UIMeta]()
    private var _maxWidthByStack = [Int:CGFloat]()
    private var _headerMeta : UIMeta!
    private var _footerMeta : UIMeta!
    private weak var _delegate : UIPageViewMetaGroupDelegate!
    
    init(section: Int, initialOffset : CGFloat, height : CGFloat, delegate: UIPageViewMetaGroupDelegate)
    {
        self._section = section
        self._initialOffset = initialOffset
        self._height = height
        self._delegate = delegate
    }
    
    var section : Int
    {
        get
        {
            let section = self._section
            
            return section
        }
    }
    
    var initialOffset : CGFloat
    {
        get
        {
            let initialOffset = self._initialOffset
            
            return initialOffset
        }
        
        set(newValue)
        {
            self._initialOffset = newValue
        }
    }
    
    var width : CGFloat
    {
        get
        {
            let width = self._width
            
            return width
        }
    }
    
    var height : CGFloat
    {
        get
        {
            let height = self._height
            
            return height
        }
    }
    
    var headerMeta : UIMeta
    {
        get
        {
            if (self._headerMeta == nil)
            {
                self._headerMeta = UIMeta(indexPath: IndexPath(item: -1, section: section),
                                          type: UIMetaType.header,
                                          delegate: self)
            }
            
            let headerMeta = self._headerMeta!
            headerMeta._globalOffset_.x = self._initialOffset
            
            return headerMeta
        }
    }
    
    var footerMeta : UIMeta
    {
        get
        {
            if (self._footerMeta == nil)
            {
                self._footerMeta = UIMeta(indexPath: IndexPath(item: 0, section: section),
                                          type: UIMetaType.footer,
                                          delegate: self)
            }
            
            let footerMeta = self._footerMeta!
            footerMeta._localOffset_.x = self.headerMeta._localOffset_.x + (self._width - footerMeta.width)
            footerMeta._globalOffset_.x = footerMeta._localOffset_.x + self._initialOffset
            
            return footerMeta
        }
    }
    
    var numberOfItems : Int
    {
        get
        {
            let numberOfItems = self._cellMetas.count
            
            return numberOfItems
        }
    }
    
    func appendCellMeta(size: CGSize)
    {
        let numberOfMetas = self._cellMetas.count
        let indexPath = IndexPath(item: numberOfMetas, section: self._section)
        let meta = UIMeta(indexPath: indexPath, type: UIMetaType.cell, delegate: self)
        meta.width = size.width
        meta.height = size.height
        self._setCellLocalOffset(for: meta)
        self.footerMeta.item = indexPath.item + 1
        self._cellMetas.append(meta)
    }
    
    func getMeta(at item: Int) -> UIMeta
    {
        var meta : UIMeta! = nil
        
        if (item == -1)
        {
            meta = self.headerMeta
        }
        else if (item == self._cellMetas.count)
        {
            meta = self.footerMeta
        }
        else
        {
            meta = self._cellMetas[item]
            self._setCellLocalOffsetIfNeeded(for: meta)
            meta._globalOffset_.x = meta._localOffset_.x + self.headerMeta._localOffset_.x + self.headerMeta.width + self._initialOffset
            meta._globalOffset_.y = meta._localOffset_.y
        }
        
        return meta
    }
    
    func meta(_ meta: UIMeta, didChangeHeightFrom oldHeight: CGFloat, to newHeight: CGFloat)
    {
        if (meta.type == UIMetaType.cell)
        {
            self._setCursoredMetaIfNeeded(for: meta)
        }
    }
    
    func meta(_ meta: UIMeta, didChangeWidthFrom oldWidth: CGFloat, to newWidth: CGFloat)
    {
        if (meta.type == UIMetaType.cell)
        {
            self._setCursoredMetaIfNeeded(for: meta)
        }
        else
        {
            self._setWidth(self._width - oldWidth + newWidth)
        }
    }
    
    private func _setWidth(_ width: CGFloat)
    {
        let oldWidth = self._width
        let newWidth = width
        self._delegate.pageViewMetaGroup?(self, willChangeWidthFrom: oldWidth, to: newWidth)
        self._width = width
        self._delegate.pageViewMetaGroup?(self, didChangeWidthFrom: oldWidth, to: newWidth)
    }
    
    private func _setCellLocalOffset(for meta: UIMeta)
    {
        var previousMeta : UIMeta? = nil
        
        if (meta.item - 1 >= 0)
        {
            previousMeta = self._cellMetas[meta.item - 1]
        }
        
        if (meta.stack != nil && meta._localOffset_.y == 0)
        {
            let maxWidth = self._maxWidthByStack[meta.stack]
            
            if (maxWidth != nil)
            {
                self._setWidth(self._width - maxWidth!)
                self._maxWidthByStack[meta.stack] = nil
            }
        }
        
        var localOffsetX : CGFloat = 0
        var localOffsetY : CGFloat = 0
        
        if (previousMeta != nil)
        {
            if (previousMeta!._localOffset_.y + previousMeta!.height + meta.height <= self.height)
            {
                localOffsetX = previousMeta!._localOffset_.x
                localOffsetY = previousMeta!._localOffset_.y + previousMeta!.height
                meta.stack = previousMeta!.stack
            }
            else
            {
                localOffsetX = previousMeta!._localOffset_.x + self._maxWidthByStack[previousMeta!.stack]!
                meta.stack = previousMeta!.stack + 1
            }
        }
        
        let localOffset = CGPoint(x: localOffsetX, y: localOffsetY)
        meta._localOffset_ = localOffset
        
        if (meta.stack == nil)
        {
            meta.stack = 0
        }
        
        var maxWidth : CGFloat! = self._maxWidthByStack[meta.stack]
        
        if (maxWidth == nil)
        {
            maxWidth = 0
        }
        
        if (maxWidth <= meta.width)
        {
            self._setWidth(self._width - maxWidth + meta.width)
            self._maxWidthByStack[meta.stack] = meta.width
        }
    }
    
    private func _setCellLocalOffset(from startIndex: Int, to endIndex: Int)
    {
        for index in startIndex...endIndex
        {
            let meta = self._cellMetas[index]
            self._setCellLocalOffset(for: meta)
        }
    }
    
    private func _setCellLocalOffsetIfNeeded(for meta: UIMeta)
    {
        if (meta.item < self._cellMetas.count && meta.type == UIMetaType.cell)
        {
            if (meta.item > self._cursoredItem)
            {
                self._setCellLocalOffset(from: self._cursoredItem + 1, to: meta.item)
                self._cursoredItem = meta.item
            }
        }
    }
    
    private func _setCursoredMetaIfNeeded(for meta: UIMeta)
    {
        if (meta.item < self._cellMetas.count && self._cellMetas.count > 0)
        {
            var cursoredMeta = meta
            
            for index in (0...meta.item).reversed()
            {
                let cellMeta = self._cellMetas[index]
                
                if (cellMeta._localOffset_.x == meta._localOffset_.x)
                {
                    if (cellMeta._localOffset_.y == 0)
                    {
                        cursoredMeta = cellMeta
                        break
                    }
                    else
                    {
                        continue
                    }
                }
                else
                {
                    break
                }
            }
            
            self._setCellLocalOffsetIfNeeded(for: cursoredMeta)
            self._cursoredItem = cursoredMeta.item - 1
        }
    }
}

