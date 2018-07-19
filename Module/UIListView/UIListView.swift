//
//  UIListView.swift
//  Pacific
//
//  Created by Minh Nguyen on 11/24/15.
//  Copyright © 2015 Minh Nguyen. All rights reserved.
//

import UIKit

private enum UIListViewTransitionDirection : Int
{
    case none
    case forward
    case reverse
}

enum UIListViewScrollPosition : Int
{
    case none
    case top
    case middle
    case bottom
}

enum UIListViewSlideDirection : Int
{
    case forward
    case reverse
}

enum UIListViewStyle : Int
{
    case plain = 0
    case grouped = 1
}

enum UIListViewMode : Int
{
    case manualScrolling
    case autoScrolling
    case sliding
}

let UIListViewAutomaticNumberOfItems = 0
let UIListViewAutomaticDimension = UITableViewAutomaticDimension

class UIListView : UIScrollView, UIScrollViewDelegate, UIGestureRecognizerDelegate, UIListViewMetaGroupDelegate
{
    var itemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
    var estimatedItemSize = CGSize(width: UIListViewAutomaticDimension, height: UIListViewAutomaticDimension)
    var sectionHeaderHeight = UIListViewAutomaticDimension
    var estimatedSectionHeaderHeight = UIListViewAutomaticDimension
    var sectionFooterHeight = UIListViewAutomaticDimension
    var estimatedSectionFooterHeight = UIListViewAutomaticDimension
    var anchorPosition = UIListViewScrollPosition.none
    var scrollPosition = UIListViewScrollPosition.top
    var scrollSpeed : Double = 0.35
    var scrollThreshold : CGFloat = 0
    var scrollBuffer : CGFloat = 10
    var allowsSelection = true
    var allowsMultipleSelection = false
    private var _style = UIListViewStyle.plain
    private var _mode = UIListViewMode.manualScrolling
    private var _contentSize = CGSize.zero
    private var _initialOffsetY : CGFloat = 0
    private var _previousOffsetY : CGFloat = 0
    private var _canLoadPartialViews = false
    private var _numberOfItemsBySection = [Int:Int]()
    private var _visibleIndexPaths = [IndexPath]()
    private var _selectedIndexPaths = [IndexPath]()
    private var _contentIndexPathByItemIndexPath = [IndexPath:IndexPath]()
    private var _topItemIndexPath = IndexPath(item: 0, section: 0)
    private var _centerItemIndexPath = IndexPath(item: 1, section: 0)
    private var _bottomItemIndexPath = IndexPath(item: 2, section: 0)
    private var _animations = [UIListViewAnimation]()
    private var _scrollingMetaGroups : [UIListViewMetaGroup]!
    private var _slidingMetaGroup : UIListViewMetaGroup!
    private var _tapGestureRecognizer : UITapGestureRecognizer!
    private var _focusItemIndexPath : IndexPath!
    private var _focusSectionHeaderIndexPath : IndexPath?
    private var _focusSectionFooterIndexPath : IndexPath?
    private var _autoScrollingItemIndexPath : IndexPath?
    private var _decelerationOffset : CGPoint?
    private var _listHeaderView : UIView?
    private var _listFooterView : UIView?
    private var _modifiedScrollingMetaGroup : UIListViewMetaGroup?
    private var _shouldReloadAtBuffer : Bool?
    private weak var _dataSource : UIListViewDataSource?
    private weak var _delegate : UIListViewDelegate?
    
    override init(frame: CGRect)
    {        
        super.init(frame: frame)
        
        self.alwaysBounceHorizontal = false
        self.alwaysBounceVertical = true
        self.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 241/255, alpha: 1)
        self.addGestureRecognizer(self._tapGestureRecognizer_)
    }
    
    convenience init(frame: CGRect, style: UIListViewStyle, mode: UIListViewMode)
    {
        self.init(frame: frame)
        
        self._style = style
        self._mode = mode
    }
    
    convenience init(style: UIListViewStyle, mode: UIListViewMode)
    {
        self.init(frame: CGRect.zero)
        
        self._style = style
        self._mode = mode
    }
    
    convenience init(style: UIListViewStyle)
    {
        self.init(frame: CGRect.zero)
        
        self._style = style
        self._mode = UIListViewMode.manualScrolling
    }
    
    convenience init(mode: UIListViewMode)
    {
        self.init(frame: CGRect.zero)
        
        self._style = UIListViewStyle.plain
        self._mode = mode
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    var style : UIListViewStyle
    {
        get
        {
            let style = self._style
            
            return style
        }
    }
    
    var mode : UIListViewMode
    {
        get
        {
            let mode = self._mode
            
            return mode
        }
    }
    
    var listHeaderView : UIView?
    {
        get
        {
            let listHeaderView = self._listHeaderView
            
            return listHeaderView
        }
        
        set(newValue)
        {
            if (self._isScrollingModeEnabled)
            {
                if (self._listHeaderView != nil)
                {
                    self._listHeaderView!.removeFromSuperview()
                    self._contentSize.height -= self._listHeaderView!.frame.height
                }
                
                self._listHeaderView = newValue
                self._contentSize.height += self._listHeaderView!.frame.height
                self.setNeedsLayout()
            }
        }
    }
    
    var listFooterView : UIView?
    {
        get
        {
            let listFooterView = self._listFooterView
            
            return listFooterView
        }
        
        set(newValue)
        {
            if (self._isScrollingModeEnabled)
            {
                if (self._listFooterView != nil)
                {
                    self._listFooterView!.removeFromSuperview()
                    self._contentSize.height -= self._listFooterView!.frame.height
                }
                
                self._listFooterView = newValue
                self._contentSize.height += self._listFooterView!.frame.height
                self.setNeedsLayout()
            }
        }
    }
    
    var dataSource : UIListViewDataSource?
    {
        get
        {
            return self._dataSource
        }
        
        set(newValue)
        {
            self._dataSource = newValue
        }
    }
    
    override var delegate: UIScrollViewDelegate?
    {
        get
        {
            let delegate = self._delegate
            
            return delegate
        }
        
        set(newValue)
        {
            if (newValue != nil)
            {
                self._delegate = newValue as? UIListViewDelegate
                super.delegate = self
            }
        }
    }
    
    var visibleCells : [UIListViewCell]
    {
        get
        {
            var visibleCells = [UIListViewCell]()
            
            for visibleIndexPath in self._visibleIndexPaths
            {
                let meta = self._getMeta(item: visibleIndexPath.item, section: visibleIndexPath.section)
                
                if (meta.type == UIMetaType.cell)
                {
                    visibleCells.append(meta._view_ as! UIListViewCell)
                }
            }
            
            return visibleCells
        }
    }
    
    var indexPathsForVisibleItems : [IndexPath]?
    {
        get
        {
            var indexPaths : [IndexPath]? = nil
            
            if (self._isScrollingModeEnabled)
            {
                if (self._visibleIndexPaths.count > 0)
                {
                    indexPaths = [IndexPath]()
                    
                    for visibleIndexPath in self._visibleIndexPaths
                    {
                        let meta = self._getMeta(item: visibleIndexPath.item, section: visibleIndexPath.section)
                        
                        if (meta.type == UIMetaType.cell)
                        {
                            let indexPath = IndexPath(item: meta.item, section: meta.section)
                            indexPaths!.append(indexPath)
                        }
                    }
                }
            }
            else
            {
                if (self._contentIndexPathByItemIndexPath.count > 0)
                {
                    indexPaths = [IndexPath]()
                    
                    for contentIndexPath in self._contentIndexPathByItemIndexPath.values
                    {
                        indexPaths!.append(contentIndexPath)
                    }
                }
            }
            
            return indexPaths
        }
    }
    
    var indexPathForSelectedItem : IndexPath?
    {
        get
        {
            var indexPath : IndexPath? = nil
            
            if (self._selectedIndexPaths.count > 0)
            {
                for selectedIndexPath in self._selectedIndexPaths
                {
                    let meta = self._getMeta(item: selectedIndexPath.item, section: selectedIndexPath.section)
                    
                    if (meta.type == UIMetaType.cell)
                    {
                        indexPath = IndexPath(item: meta.item, section: meta.section)
                        break
                    }
                }
            }
            
            return indexPath
        }
    }
    
    var indexPathsForSelectedItems : [IndexPath]?
    {
        get
        {
            var indexPaths : [IndexPath]? = nil
            
            if (self._selectedIndexPaths.count > 0)
            {
                indexPaths = [IndexPath]()
                
                for selectedIndexPath in self._selectedIndexPaths
                {
                    let meta = self._getMeta(item: selectedIndexPath.item, section: selectedIndexPath.section)
                    
                    if (meta.type == UIMetaType.cell)
                    {
                        let indexPath = IndexPath(item: meta.item, section: meta.section)
                        indexPaths!.append(indexPath)
                    }
                }
            }
            
            return indexPaths
        }
    }
    
    var numberOfSections : Int
    {
        get
        {
            let numberOfSections = self._scrollingMetaGroups_.count
            
            return numberOfSections
        }
    }
    
    private var _scrollHeight : CGFloat
    {
        get
        {
            let _scrollHeight = self._contentSize.height + self.contentInset.bottom + self.contentInset.top
            
            return _scrollHeight
        }
    }
    
    private var _isScrollingModeEnabled : Bool
    {
        get
        {
            let _isScrollingModeEnabled = self.mode == UIListViewMode.manualScrolling || self.mode == UIListViewMode.autoScrolling
            
            return _isScrollingModeEnabled
        }
    }
    
    private var _topItemMeta : UIMeta
    {
        get
        {
            let _topItemMeta = self._getMeta(item: 0, section: 0)
            
            return _topItemMeta
        }
    }
    
    private var _centerItemMeta : UIMeta
    {
        get
        {
            let _centerItemMeta = self._getMeta(item: 1, section: 0)
            
            return _centerItemMeta
        }
    }
    
    private var _bottomItemMeta : UIMeta
    {
        get
        {
            let _bottomItemMeta = self._getMeta(item: 2, section: 0)
            
            return _bottomItemMeta
        }
    }
    
    private var _focusItemMeta : UIMeta
    {
        get
        {
            let _focusItemMeta = self._getMeta(item: self._focusItemIndexPath_.item, section: self._focusItemIndexPath_.section)
            
            return _focusItemMeta
        }
    }
    
    private var _transitionDirection : UIListViewTransitionDirection
    {
        get
        {
            var _transitionDirection = UIListViewTransitionDirection.none
            
            if (self.mode == UIListViewMode.autoScrolling || self.mode == UIListViewMode.sliding)
            {
                var transitionThreshold : CGFloat = 0
                
                if (self.mode == UIListViewMode.autoScrolling)
                {
                    transitionThreshold = self._getScrollThresholdForCellAt(indexPath: self._focusItemIndexPath_)
                }
                else
                {
                    transitionThreshold = self.frame.height / 2
                }
                
                if (self._decelerationOffset!.y <= self._initialOffsetY)
                {
                    if (self._initialOffsetY - self._decelerationOffset!.y >= transitionThreshold)
                    {
                        _transitionDirection = UIListViewTransitionDirection.reverse
                    }
                }
                else
                {
                    if (self._decelerationOffset!.y - self._initialOffsetY >= transitionThreshold)
                    {
                        _transitionDirection = UIListViewTransitionDirection.forward
                    }
                }
            }
            
            return _transitionDirection
        }
    }
    
    private var _canReloadAtBuffer : Bool
    {
        get
        {
            let _canReloadAtBuffer = self._isScrollingModeEnabled && self._shouldReloadAtBuffer == nil && self.dataSource != nil  && !self._isAnimating
            
            return _canReloadAtBuffer
        }
    }
    
    private var _shouldLoadBottomViews : Bool
    {
        get
        {
            var _shouldLoadBottomViews = self._visibleIndexPaths.count > 0
            
            if (_shouldLoadBottomViews)
            {
                let lastVisibleIndexPath = self._visibleIndexPaths.last!
                let lastVisibleMeta = self._getMeta(item: lastVisibleIndexPath.item, section: lastVisibleIndexPath.section)
                
                if (lastVisibleMeta._view_ != nil)
                {
                    let frame = CGRect(x: lastVisibleMeta._globalOffset_.x,
                                       y: lastVisibleMeta._globalOffset_.y,
                                       width: lastVisibleMeta.width,
                                       height: lastVisibleMeta.height)
                    _shouldLoadBottomViews = self.frame.height - (frame.maxY - self.contentOffset.y) > 1
                }
            }
            
            return _shouldLoadBottomViews
        }
    }
    
    private var _shouldLoadTopViews : Bool
    {
        get
        {
            var _shouldLoadTopViews = self._visibleIndexPaths.count > 0
            
            if (_shouldLoadTopViews)
            {
                let firstVisibleIndexPath = self._visibleIndexPaths.first!
                let firstVisibleMeta = self._getMeta(item: firstVisibleIndexPath.item, section: firstVisibleIndexPath.section)
                
                if (firstVisibleMeta._view_ != nil)
                {
                    let frame = CGRect(x: firstVisibleMeta._globalOffset_.x,
                                       y: firstVisibleMeta._globalOffset_.y,
                                       width: firstVisibleMeta.width,
                                       height: firstVisibleMeta.height)
                    _shouldLoadTopViews = frame.minY - self.contentOffset.y > 1
                }
            }
            
            return _shouldLoadTopViews
        }
    }
    
    private var _shouldUnloadBottomViews : Bool
    {
        get
        {
            var _shouldUnloadBottomViews = self._visibleIndexPaths.count > 0 && !self._isAnimating
            
            if (_shouldUnloadBottomViews)
            {
                let firstVisibleIndexPath = self._visibleIndexPaths.first!
                let firstVisibleMeta = self._getMeta(item: firstVisibleIndexPath.item, section: firstVisibleIndexPath.section)
                _shouldUnloadBottomViews = self.contentOffset.y + firstVisibleMeta._globalOffset_.y > -1
            }
            
            if (_shouldUnloadBottomViews)
            {
                let lastVisibleIndexPath = self._visibleIndexPaths.last!
                let lastVisibleMeta = self._getMeta(item: lastVisibleIndexPath.item, section: lastVisibleIndexPath.section)
                
                if (lastVisibleMeta._view_ != nil)
                {
                    let frame = CGRect(x: lastVisibleMeta._globalOffset_.x,
                                       y: lastVisibleMeta._globalOffset_.y,
                                       width: lastVisibleMeta.width,
                                       height: lastVisibleMeta.height)
                    _shouldUnloadBottomViews = (frame.minY - self.contentOffset.y) - self.frame.height > -1
                }
            }
            
            return _shouldUnloadBottomViews
        }
    }
    
    private var _shouldUnloadTopViews : Bool
    {
        get
        {
            var _shouldUnloadTopViews = self._visibleIndexPaths.count > 0 && !self._isAnimating
            
            if (_shouldUnloadTopViews)
            {
                let lastVisibleIndexPath = self._visibleIndexPaths.last!
                let lastVisibleMeta = self._getMeta(item: lastVisibleIndexPath.item, section: lastVisibleIndexPath.section)
                _shouldUnloadTopViews = (lastVisibleMeta._globalOffset_.y + lastVisibleMeta.height) - (self.contentOffset.y + self.frame.height) > -1
            }
            
            if (_shouldUnloadTopViews)
            {
                let firstVisibleIndexPath = self._visibleIndexPaths.first!
                let firstVisibleMeta = self._getMeta(item: firstVisibleIndexPath.item, section: firstVisibleIndexPath.section)
                
                if (firstVisibleMeta._view_ != nil)
                {
                    let frame = CGRect(x: firstVisibleMeta._globalOffset_.x,
                                       y: firstVisibleMeta._globalOffset_.y,
                                       width: firstVisibleMeta.width,
                                       height: firstVisibleMeta.height)
                    _shouldUnloadTopViews = self.contentOffset.y - frame.maxY > -1
                }
            }
            
            return _shouldUnloadTopViews
        }
    }
    
    private var _isAnimating : Bool
    {
        get
        {
            let _isAnimating = self._animations.count > 0
            
            return _isAnimating
        }
    }
    
    internal var _scrollingMetaGroups_ : [UIListViewMetaGroup]
    {
        get
        {
            if (self._scrollingMetaGroups == nil)
            {
                self._scrollingMetaGroups = [UIListViewMetaGroup]()
            }
            
            let _scrollingMetaGroups_ = self._scrollingMetaGroups!
            
            return _scrollingMetaGroups_
        }
        
        set(newValue)
        {
            self._scrollingMetaGroups = newValue
        }
    }
    
    internal var _slidingMetaGroup_ : UIListViewMetaGroup
    {
        get
        {
            if (self._slidingMetaGroup == nil)
            {
                self._slidingMetaGroup = UIListViewMetaGroup(section: 0,
                                                             initialOffset: 0,
                                                             width: self.frame.width,
                                                             delegate: self)
            }
            
            let _slidingMetaGroup_ = self._slidingMetaGroup!
            
            return _slidingMetaGroup_
        }
        
        set(newValue)
        {
            self._slidingMetaGroup_ = newValue
        }
    }
    
    internal var _tapGestureRecognizer_ : UITapGestureRecognizer
    {
        get
        {
            if (self._tapGestureRecognizer == nil)
            {
                self._tapGestureRecognizer = UITapGestureRecognizer()
                self._tapGestureRecognizer.addTarget(self, action: #selector(UIListView._toggleCell(_:)))
                self._tapGestureRecognizer.cancelsTouchesInView = false
                self._tapGestureRecognizer.delegate = self
            }
            
            let _tapGestureRecognizer_ = self._tapGestureRecognizer!
            
            return _tapGestureRecognizer_
        }
    }
    
    internal var _focusItemIndexPath_ : IndexPath
    {
        get
        {
            if (self._focusItemIndexPath == nil)
            {
                if (self._isScrollingModeEnabled)
                {
                    self._focusItemIndexPath = IndexPath(item: 0, section: 0)
                }
                else
                {
                    self._focusItemIndexPath = self._centerItemIndexPath
                }
            }
            
            let _focusItemIndexPath_ = self._focusItemIndexPath!
            
            return _focusItemIndexPath_
        }
        
        set(newValue)
        {
            self._focusItemIndexPath = newValue
        }
    }
    
    override func layoutSubviews()
    {
        if (self._isScrollingModeEnabled)
        {
            if (self._shouldReloadAtBuffer == true || ((self._contentSize.width - self.frame.width) > 1 && self._canLoadPartialViews))
            {
                self.reloadData()
            }
            
            self._loadScrollingViews()
            self._positionAfterReloadingAtBufferIfNeeded()
        }
        else
        {
            if ((self._contentSize.width - self.frame.width) > 1 && self._canLoadPartialViews)
            {
                self.reloadData()
            }
            
            self._loadSlidingViews()
        }
        
        self._animateIfNeeded()
        self.contentSize = self._contentSize
        
        if (self._isScrollingModeEnabled)
        {
            self._anchorViewsIfNeeded()
        }
    }
    
    func reloadData()
    {
        if (self._isScrollingModeEnabled)
        {
            self._unloadScrollingViews()
            self._loadScrollingMetaGroupsIfNeeded()
            
            if (self._scrollingMetaGroups_.count > 0)
            {
                self.setNeedsLayout()
            }
        }
        else
        {
            self._unloadSlidingViews()
            self._loadSlidingMetaGroupIfNeeded()
            
            if (self._slidingMetaGroup_.numberOfItems > 0)
            {
                self.setNeedsLayout()
            }
        }
    }

    func numberOfItems(inSection section: Int) -> Int
    {
        var numberOfItems = 0
        
        if (self._isScrollingModeEnabled)
        {
            if (self._numberOfItemsBySection[section] == nil)
            {
                self._numberOfItemsBySection[section] = self._scrollingMetaGroups_[section].numberOfItems
            }
            
            numberOfItems = self._numberOfItemsBySection[section]!
        }
        
        return numberOfItems
    }
    
    func indexPathForItem(at point: CGPoint) -> IndexPath?
    {
        var indexPath : IndexPath? = nil
        
        findMetaGroup:
        for metaGroup in self._scrollingMetaGroups_
        {
            let metaGroupRect = CGRect(x: 0, y: metaGroup.initialOffset, width: metaGroup.width, height: metaGroup.height)
            
            if (metaGroupRect.contains(point))
            {
                findMeta:
                for index in 0...metaGroup.numberOfItems
                {
                    let meta = metaGroup.getMeta(at: index)
                    let metaRect = CGRect(origin: meta._globalOffset_, size: CGSize(width: meta.width, height: meta.height))
                    
                    if (metaRect.contains(point))
                    {
                        indexPath = IndexPath(item: meta.item, section: meta.section)
                        break findMetaGroup
                    }
                }
            }
        }
        
        return indexPath
    }
    
    func scrollToItem(at indexPath: IndexPath, at scrollPosition: UIListViewScrollPosition, animated: Bool)
    {
        self._scrollToItem(at: indexPath, at: scrollPosition, allowsAnimation: animated, isGestureRecognized: false)
    }
    
    func slideToItem(at indexPath: IndexPath, from slideDirection: UIListViewSlideDirection, animated: Bool)
    {
        self._slideToItem(at: indexPath, from: slideDirection, allowsAnimation: animated, isGestureRecognized: false)
    }
    
    func selectItem(at indexPath: IndexPath?, animated: Bool, scrollPosition: UIListViewScrollPosition)
    {
        if (self._isScrollingModeEnabled)
        {
            if (self.allowsSelection && indexPath != nil)
            {
                if (!self.allowsMultipleSelection)
                {
                    for selectedIndexPath in self._selectedIndexPaths
                    {
                        let meta = self._getMeta(item: selectedIndexPath.item, section: selectedIndexPath.section)
                        
                        if (meta._view_ != nil)
                        {
                            let cell = meta._view_ as! UIListViewCell
                            cell.isSelected = false
                        }
                    }
                    
                    self._selectedIndexPaths = [IndexPath]()
                }
                
                let meta = self._getMeta(item: indexPath!.item, section: indexPath!.section)
                
                if (meta._view_ != nil)
                {
                    let cell = meta._view_ as! UIListViewCell
                    cell.isSelected = true
                }
                
                self._selectedIndexPaths.append(indexPath!)
            }
        }
    }
    
    func deselectItem(at indexPath: IndexPath, animated: Bool)
    {
        if (self._isScrollingModeEnabled)
        {
            if (self.allowsSelection)
            {
                for (counter, selectedIndexPath) in self._selectedIndexPaths.enumerated().reversed()
                {
                    if (selectedIndexPath == indexPath)
                    {
                        let meta = self._getMeta(item: selectedIndexPath.item, section: selectedIndexPath.section)
                        
                        if (meta._view_ != nil)
                        {
                            let cell = meta._view_ as! UIListViewCell
                            cell.isSelected = false
                        }
                        
                        self._selectedIndexPaths.remove(at: counter)
                        break
                    }
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if (self._canReloadAtBuffer)
        {
            if (self._previousOffsetY > self.contentOffset.y)
            {
                if (self.contentOffset.y < self.scrollBuffer)
                {
                    self._shouldReloadAtBuffer = self.dataSource!.listViewShouldReloadAtLeadingBuffer?(self)
                }
            }
            else if (self._previousOffsetY < self.contentOffset.y)
            {
                if (self.contentOffset.y > (self._scrollHeight - self.frame.size.height) - self.scrollBuffer)
                {
                    self._shouldReloadAtBuffer = self.dataSource!.listViewShouldReloadAtTrailingBuffer?(self)
                }
            }
            
            if (self._shouldReloadAtBuffer == nil)
            {
                self._shouldReloadAtBuffer = false
            }
        }
        
        if (self._delegate != nil)
        {
            self._delegate!.scrollViewDidScroll?(self)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        if (self._delegate != nil)
        {
            self._delegate!.scrollViewWillBeginDragging?(self)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    {
        if (self._delegate != nil)
        {
            self._delegate!.scrollViewWillBeginDecelerating?(self)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if (self._delegate != nil)
        {
            self._delegate!.scrollViewDidEndDecelerating?(self)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        if (self.mode == UIListViewMode.autoScrolling || self.mode == UIListViewMode.sliding)
        {
            self._decelerationOffset = targetContentOffset.pointee
            targetContentOffset.pointee = self.contentOffset
        }
        
        if (self._delegate != nil)
        {
            self._delegate!.scrollViewWillEndDragging?(self, withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if (self.mode == UIListViewMode.autoScrolling || self.mode == UIListViewMode.sliding)
        {
            if (self._visibleIndexPaths.count < 2)
            {
                return
            }
            
            if (self.mode == UIListViewMode.sliding && self._contentIndexPathByItemIndexPath.count < 2)
            {
                return
            }
            
            let transitionDirection = self._transitionDirection
            
            if (transitionDirection == UIListViewTransitionDirection.none)
            {
                if (self.mode == UIListViewMode.autoScrolling)
                {
                    let currentIndexPath = self._focusItemIndexPath_
                    self._scrollToItem(at: currentIndexPath, at: self.scrollPosition, allowsAnimation: true, isGestureRecognized: true)
                }
                else
                {
                    if (self._contentIndexPathByItemIndexPath[self._centerItemIndexPath] != nil)
                    {
                        self._slideToItem(at: self._contentIndexPathByItemIndexPath[self._centerItemIndexPath]!,
                                          from: UIListViewSlideDirection.forward,
                                          allowsAnimation: true,
                                          isGestureRecognized: true)
                    }
                }
            }
            else if (transitionDirection == UIListViewTransitionDirection.reverse)
            {
                if (self.mode == UIListViewMode.autoScrolling)
                {
                    var previousIndexPath : IndexPath? = nil
                    
                    if (self._autoScrollingItemIndexPath != nil)
                    {
                        previousIndexPath = self._autoScrollingItemIndexPath!
                        self._autoScrollingItemIndexPath = nil
                    }
                    else
                    {
                        previousIndexPath = self._getPreviousIndexPath(from: self._focusItemIndexPath_,
                                                                       isHeaderAndFooterIncluded: false)
                    }
                    
                    if (previousIndexPath != nil)
                    {
                        self._scrollToItem(at: previousIndexPath!,
                                           at: self.scrollPosition,
                                           allowsAnimation: true,
                                           isGestureRecognized: true)
                    }
                }
                else
                {
                    if (self._contentIndexPathByItemIndexPath[self._topItemIndexPath] != nil)
                    {
                        self._slideToItem(at: self._contentIndexPathByItemIndexPath[self._topItemIndexPath]!,
                                          from: UIListViewSlideDirection.reverse,
                                          allowsAnimation: true,
                                          isGestureRecognized: true)
                    }
                }
            }
            else if (transitionDirection == UIListViewTransitionDirection.forward)
            {
                if (self.mode == UIListViewMode.autoScrolling)
                {
                    var nextIndexPath : IndexPath? = nil
                    
                    if (self._autoScrollingItemIndexPath != nil)
                    {
                        nextIndexPath = self._autoScrollingItemIndexPath!
                        self._autoScrollingItemIndexPath = nil
                    }
                    else
                    {
                        nextIndexPath = self._getNextIndexPath(from: self._focusItemIndexPath_, isHeaderAndFooterIncluded: false)
                    }
                    
                    if (nextIndexPath != nil)
                    {
                        self._scrollToItem(at: nextIndexPath!, at: self.scrollPosition, allowsAnimation: true, isGestureRecognized: true)
                    }
                }
                else
                {
                    if (self._contentIndexPathByItemIndexPath[self._bottomItemIndexPath] != nil)
                    {
                        self._slideToItem(at: self._contentIndexPathByItemIndexPath[self._bottomItemIndexPath]!,
                                          from: UIListViewSlideDirection.forward,
                                          allowsAnimation: true,
                                          isGestureRecognized: true)
                    }
                }
            }
        }
        
        if (self._delegate != nil)
        {
            self._delegate!.scrollViewDidEndDragging?(self, willDecelerate: decelerate)
        }
    }
    
    private func _removeAnimationsIfNeeded()
    {
        var animations = [UIListViewAnimation]()
        
        for animation in self._animations
        {
            if (animation.state == UIListViewAnimationState.possible || animation.state == UIListViewAnimationState.began)
            {
                animations.append(animation)
            }
        }
        
        self._animations = animations
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        self._removeAnimationsIfNeeded()
        
        if (self._isScrollingModeEnabled)
        {
            self._loadScrollingViews()
            
            if (self.contentOffset.y + self.frame.height > self._scrollHeight)
            {
                self.contentOffset.y = self._scrollHeight - self.frame.height
            }
            else if (self.contentOffset.y < 0)
            {
                self.contentOffset.y = 0
            }
        }
        else
        {
            self._loadSlidingViews()
        }
        
        if (self._delegate != nil)
        {
            self._delegate!.scrollViewDidEndScrollingAnimation?(self)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (gestureRecognizer === self._tapGestureRecognizer_)
        {
            if (touch.view is UIControl)
            {
                return false
            }
        }
        
        return true
    }
    
    func listViewMetaGroup(_ listViewMetaGroup: UIListViewMetaGroup, didChangeHeightFrom oldHeight: CGFloat, to newHeight: CGFloat)
    {
        self._contentSize.height = self._contentSize.height - oldHeight + newHeight
    }
    
    private func _scrollToItem(at indexPath: IndexPath, at scrollPosition: UIListViewScrollPosition, allowsAnimation: Bool, isGestureRecognized: Bool)
    {
        if (self._isScrollingModeEnabled)
        {
            let animation = UIListViewAnimation(indexPath: indexPath,
                                                at: scrollPosition,
                                                allowsAnimation: allowsAnimation,
                                                isGestureRecognized: isGestureRecognized)
            self._animations.append(animation)
            self.setNeedsLayout()
        }
    }
    
    private func _slideToItem(at indexPath: IndexPath, from slideDirection: UIListViewSlideDirection, allowsAnimation: Bool, isGestureRecognized: Bool)
    {
        if (self._mode == UIListViewMode.sliding)
        {
            let animation = UIListViewAnimation(indexPath: indexPath,
                                                from: slideDirection,
                                                allowsAnimation: allowsAnimation,
                                                isGestureRecognized: isGestureRecognized)
            self._animations.append(animation)
            self.setNeedsLayout()
        }
    }
    
    private func _animateIfNeeded()
    {
        if (self._animations.count > 0)
        {
            for animation in self._animations
            {
                if (animation.state == UIListViewAnimationState.possible)
                {
                    if (self._isScrollingModeEnabled)
                    {
                        self._animateScrollingAnimation(animation)
                    }
                    else
                    {
                        self._animateSlidingAnimation(animation)
                    }
                }
            }
        }
    }
    
    private func _animateScrollingAnimation(_ animation: UIListViewAnimation)
    {
        let numberOfItems = self.numberOfItems(inSection: animation.indexPath.section)
        let shouldAnimateScrollingView = animation.indexPath.item >= 0 && animation.indexPath.item < numberOfItems
        
        if (shouldAnimateScrollingView)
        {
            self._displayVisibleScrollingViewsIfNeeded(to: animation.indexPath)
            let meta = self._getMeta(item: animation.indexPath.item, section: animation.indexPath.section)
            
            var contentOffsetY = CGFloat(0)
            
            if (animation.scrollPosition == UIListViewScrollPosition.none)
            {
                if (meta._globalOffset_.y < self.contentOffset.y)
                {
                    self._scrollToItem(at: animation.indexPath,
                                       at: UIListViewScrollPosition.top,
                                       allowsAnimation: animation.allowsAnimation,
                                       isGestureRecognized: animation.isGestureRecognized)
                }
                else if (meta._globalOffset_.y + meta.height > self.contentOffset.y + self.frame.height)
                {
                    self._scrollToItem(at: animation.indexPath,
                                       at: UIListViewScrollPosition.bottom,
                                       allowsAnimation: animation.allowsAnimation,
                                       isGestureRecognized: animation.isGestureRecognized)
                }
                
                animation.cancel()
                
                return
            }
            else if (animation.scrollPosition == UIListViewScrollPosition.top)
            {
                contentOffsetY = meta._globalOffset_.y
                
                if (self.style == UIListViewStyle.plain)
                {
                    let headerMeta = self._getMeta(item: -1, section: meta.section)
                    contentOffsetY -= headerMeta.height
                }
            }
            else if (animation.scrollPosition == UIListViewScrollPosition.middle)
            {
                contentOffsetY = meta._globalOffset_.y - (self.frame.height / 2)
            }
            else if (animation.scrollPosition == UIListViewScrollPosition.bottom)
            {
                contentOffsetY = meta._globalOffset_.y - (self.frame.height - meta.height)
                
                if (self.style == UIListViewStyle.plain)
                {
                    let footerMeta = self._getMeta(item: self.numberOfItems(inSection: meta.section), section: meta.section)
                    contentOffsetY += footerMeta.height
                }
            }
            
            if (contentOffsetY + self.frame.height > self._contentSize.height)
            {
                contentOffsetY = self._contentSize.height - self.frame.height
            }
            else if (contentOffsetY < 0)
            {
                contentOffsetY = 0
            }
            
            if (self.mode == UIListViewMode.autoScrolling)
            {
                self._initialOffsetY = contentOffsetY
                self._focusItemIndexPath_ = animation.indexPath
            }
            
            if (self._delegate != nil)
            {
                self._delegate!.listView?(self, willScrollToItemAt: animation.indexPath, isAnimationEnabled: animation.allowsAnimation, isGestureRecognized: animation.isGestureRecognized)
            }
            
            if (animation.allowsAnimation)
            {
                UIView.animate(withDuration: self.scrollSpeed, animations:
                {
                    animation.begin()
                    self.contentOffset = CGPoint(x: 0, y: contentOffsetY)
                    
                    if (self.style == UIListViewStyle.plain)
                    {
                        self._displaySectionHeaderViewIfNeeded()
                        self._displaySectionFooterViewIfNeeded()
                    }
                }, completion:
                { (isCompleted) in
                    
                    animation.end()
                    self.scrollViewDidEndScrollingAnimation(self)
                    
                    if (self._delegate != nil)
                    {
                        self._delegate!.listView?(self, didScrollToItemAt: animation.indexPath, isAnimationEnabled: animation.allowsAnimation, isGestureRecognized: animation.isGestureRecognized)
                    }
                })
            }
            else
            {
                self.contentOffset = CGPoint(x: 0, y: contentOffsetY)
                animation.cancel()
                self._removeAnimationsIfNeeded()
                self._loadScrollingViews()
                
                if (self._delegate != nil)
                {
                    self._delegate!.listView?(self, didScrollToItemAt: animation.indexPath, isAnimationEnabled: animation.allowsAnimation, isGestureRecognized: animation.isGestureRecognized)
                }
            }
        }
        else
        {
            animation.cancel()
            self._removeAnimationsIfNeeded()
            
            fatalError("UIListView: indexPath is out of bounds")
        }
    }
    
    private func _animateSlidingAnimation(_ animation: UIListViewAnimation)
    {
        var shouldAnimateSlidingView = self._visibleIndexPaths.count > 1
        
        if (!shouldAnimateSlidingView)
        {
            shouldAnimateSlidingView = animation.indexPath != self._contentIndexPathByItemIndexPath[self._focusItemIndexPath_]
        }
        
        if (shouldAnimateSlidingView)
        {
            if (self._focusItemIndexPath_ != self._centerItemIndexPath)
            {
                self._setFocusItemToMeta(at: self._centerItemIndexPath)
            }
            
            var contentOffsetY : CGFloat! = nil
            
            if (animation.indexPath == self._contentIndexPathByItemIndexPath[self._centerItemIndexPath])
            {
                contentOffsetY = self._centerItemMeta._globalOffset_.y
                self._focusItemIndexPath_ = self._centerItemIndexPath
            }
            else if (animation.indexPath == self._contentIndexPathByItemIndexPath[self._topItemIndexPath])
            {
                contentOffsetY = self._topItemMeta._globalOffset_.y
                self._focusItemIndexPath_ = self._topItemIndexPath
            }
            else if (animation.indexPath == self._contentIndexPathByItemIndexPath[self._bottomItemIndexPath])
            {
                contentOffsetY = self._bottomItemMeta._globalOffset_.y
                self._focusItemIndexPath_ = self._bottomItemIndexPath
            }
            else
            {
                self._displayVisibleSlidingViewIfNeeded(at: animation.indexPath, for: animation.slideDirection)
                
                if (animation.slideDirection == UIListViewSlideDirection.reverse)
                {
                    contentOffsetY = self._topItemMeta._globalOffset_.y
                    self._focusItemIndexPath_ = self._topItemIndexPath
                }
                else
                {
                    contentOffsetY = self._bottomItemMeta._globalOffset_.y
                    self._focusItemIndexPath_ = self._bottomItemIndexPath
                }
            }
            
            if (self.mode == UIListViewMode.sliding)
            {
                self._initialOffsetY = contentOffsetY
            }
            
            if (self._delegate != nil)
            {
                self._delegate!.listView?(self, willSlideToItemAt: animation.indexPath, isAnimationEnabled: animation.allowsAnimation, isGestureRecognized: animation.isGestureRecognized)
            }
            
            if (animation.allowsAnimation)
            {
                UIView.animate(withDuration: self.scrollSpeed, animations:
                {
                    animation.begin()
                    self.contentOffset = CGPoint(x: 0, y: contentOffsetY)
                }, completion:
                { (isCompleted) in
                    
                    animation.end()
                    self.scrollViewDidEndScrollingAnimation(self)
                    
                    if (self._delegate != nil)
                    {
                        self._delegate!.listView?(self, didSlideToItemAt: animation.indexPath, isAnimationEnabled: animation.allowsAnimation, isGestureRecognized: animation.isGestureRecognized)
                    }
                })
            }
            else
            {
                self.contentOffset = CGPoint(x: 0, y: contentOffsetY)
                animation.cancel()
                self._removeAnimationsIfNeeded()
                self._loadSlidingViews()
                
                if (self._delegate != nil)
                {
                    self._delegate!.listView?(self, didSlideToItemAt: animation.indexPath, isAnimationEnabled: animation.allowsAnimation, isGestureRecognized: animation.isGestureRecognized)
                }
            }
        }
        else
        {
            animation.cancel()
            self._removeAnimationsIfNeeded()
        }
    }
    
    private func _loadHeaderViewIfNeeded()
    {
        if (self._listHeaderView != nil)
        {
            self._listHeaderView!.frame.origin.y = 0
            
            if (self._listHeaderView!.superview == nil)
            {
                self.addSubview(self._listHeaderView!)
            }
            
            for visibleIndexPath in self._visibleIndexPaths
            {
                let meta = self._getMeta(item: visibleIndexPath.item, section: visibleIndexPath.section)
                
                if (meta._view_ != nil)
                {
                    meta._view_!.frame.origin.y = meta._globalOffset_.y
                }
            }
        }
    }
    
    private func _loadFooterViewIfNeeded()
    {
        if (self._listFooterView != nil)
        {
            if (self._listFooterView!.superview == nil)
            {
                self.addSubview(self._listFooterView!)
            }
            
            self._listFooterView!.frame.origin.y = self._contentSize.height - self._listFooterView!.frame.height
        }
    }
    
    private func _displaySectionHeaderViewIfNeeded()
    {
        if (self._visibleIndexPaths.count > 0)
        {
            if (self._focusSectionHeaderIndexPath != nil)
            {
                let headerMeta = self._getMeta(item: self._focusSectionHeaderIndexPath!.item,
                                              section: self._focusSectionHeaderIndexPath!.section)
                
                if (headerMeta._view_ != nil)
                {
                    headerMeta._view_!.frame.origin.y = headerMeta._globalOffset_.y
                }
                
                self._focusSectionHeaderIndexPath = nil
            }
            
            let focusSection = self._visibleIndexPaths.first!.section
            let headerMeta = self._getMeta(item: -1, section: focusSection)
            let footerMeta = self._getMeta(item: self.numberOfItems(inSection: focusSection), section: focusSection)
            
            var headerOriginY = self.contentOffset.y
            
            var minimumOffsetY = headerMeta._globalOffset_.y
            
            if (self._listHeaderView != nil)
            {
                minimumOffsetY += self._listHeaderView!.frame.height
            }
            
            if (headerOriginY < minimumOffsetY)
            {
                headerOriginY = minimumOffsetY
            }

            if (headerMeta.height + headerOriginY > footerMeta._globalOffset_.y)
            {
                headerOriginY = footerMeta._globalOffset_.y - headerMeta.height
            }
            
            let indexPath = IndexPath(item: headerMeta.item, section: headerMeta.section)
            
            if (headerMeta._view_ == nil)
            {
                self._displayScrollingView(at: indexPath)
            }
            else
            {
                self.addSubview(headerMeta._view_!)
            }
            
            headerMeta._view_!.frame.origin.y = headerOriginY
            self._focusSectionHeaderIndexPath = indexPath
        }
    }
    
    private func _displaySectionFooterViewIfNeeded()
    {
        if (self._visibleIndexPaths.count > 0)
        {
            if (self._focusSectionFooterIndexPath != nil)
            {
                let footerMeta = self._getMeta(item: self._focusSectionFooterIndexPath!.item,
                                              section: self._focusSectionFooterIndexPath!.section)
                
                if (footerMeta._view_ != nil)
                {
                    footerMeta._view_!.frame.origin.y = footerMeta._globalOffset_.y
                }
                
                self._focusSectionFooterIndexPath = nil
            }
            
            let focusSection = self._visibleIndexPaths.last!.section
            let headerMeta = self._getMeta(item: -1, section: focusSection)
            let footerMeta = self._getMeta(item: self.numberOfItems(inSection: focusSection), section: focusSection)

            var footerOriginY = self.contentOffset.y + self.frame.height - footerMeta.height

            if (footerOriginY > footerMeta._globalOffset_.y)
            {
                footerOriginY = footerMeta._globalOffset_.y
            }
            
            if (footerOriginY < headerMeta._globalOffset_.y + headerMeta.height)
            {
                footerOriginY = headerMeta._globalOffset_.y + headerMeta.height
            }

            let indexPath = IndexPath(item: footerMeta.item, section: footerMeta.section)
            
            if (footerMeta._view_ == nil)
            {
                self._displayScrollingView(at: indexPath)
            }
            else
            {
                self.addSubview(footerMeta._view_!)
            }

            footerMeta._view_!.frame.origin.y = footerOriginY
            self._focusSectionFooterIndexPath = indexPath
        }
    }
    
    private func _positionAfterReloadingAtBufferIfNeeded()
    {
        if (self._isScrollingModeEnabled)
        {
            if (self._shouldReloadAtBuffer != nil)
            {
                if (self._shouldReloadAtBuffer == true)
                {
                    if (self.contentOffset.y < self.scrollBuffer)
                    {
                        self.contentOffset.y += (self._contentSize.height - self.contentSize.height)
                        
                        if (self._mode == UIListViewMode.autoScrolling)
                        {
                            self._autoScrollingItemIndexPath = self.indexPathForItem(at: self.contentOffset)
                            self._autoScrollingItemIndexPath!.item -= 1
                        }
                    }
                    else
                    {
                        if (self._mode == UIListViewMode.autoScrolling)
                        {
                            self._autoScrollingItemIndexPath = self.indexPathForItem(at: self.contentOffset)
                            self._autoScrollingItemIndexPath!.item += 1
                        }
                    }
                    
                    if (self._mode == UIListViewMode.autoScrolling)
                    {
                        self._initialOffsetY = self.contentOffset.y
                    }
                }
                
                self._shouldReloadAtBuffer = nil
            }
        }
    }
    
    private func _anchorViewsIfNeeded()
    {
        if (self.anchorPosition != UIListViewScrollPosition.none)
        {
            if (self._scrollHeight < self.frame.height)
            {
                self.isScrollEnabled = false
                
                if (self.anchorPosition == UIListViewScrollPosition.bottom)
                {
                    self.contentOffset.y = self._scrollHeight - self.frame.height
                }
                else if (self.anchorPosition == UIListViewScrollPosition.middle)
                {
                    self.contentOffset.y = (self._scrollHeight - self.frame.height) / 2
                }                
            }
            else
            {
                self.isScrollEnabled = true
            }
        }
    }
    
    private func _getScrollThresholdForCellAt(indexPath: IndexPath) -> CGFloat
    {
        var scrollThreshold : CGFloat! = nil
        
        if (self._delegate != nil)
        {
            scrollThreshold = self._delegate!.listView?(self, scrollThresholdForItemAt: indexPath)
        }
        
        if (scrollThreshold == nil)
        {
            scrollThreshold = self.scrollThreshold
        }
        
        return scrollThreshold
    }
    
    private func _getEstimatedSectionHeaderHeightAt(section: Int) -> CGFloat
    {
        var estimatedSectionHeaderHeight : CGFloat! = nil
        
        if (self._delegate != nil)
        {
            estimatedSectionHeaderHeight = self._delegate!.listView?(self, estimatedHeightForHeaderInSection: section)
        }
        
        if (estimatedSectionHeaderHeight == nil)
        {
            estimatedSectionHeaderHeight = self.estimatedSectionHeaderHeight
        }
        
        if (estimatedSectionHeaderHeight == UIListViewAutomaticDimension)
        {
            if (self.style == UIListViewStyle.plain)
            {
                estimatedSectionHeaderHeight = 40
            }
            else if (self.style == UIListViewStyle.grouped)
            {
                estimatedSectionHeaderHeight = 60
            }
        }
        
        return estimatedSectionHeaderHeight
    }
    
    private func _getEstimatedItemSizeAt(indexPath: IndexPath) -> CGSize
    {
        var estimatedItemSize : CGSize! = nil
        
        if (self._delegate != nil)
        {
            estimatedItemSize = self._delegate!.listView?(self, estimatedSizeForItemAt: indexPath)
        }
        
        if (estimatedItemSize == nil)
        {
            estimatedItemSize = self.estimatedItemSize
        }
        
        if (estimatedItemSize.height == UIListViewAutomaticDimension)
        {
            estimatedItemSize.height = 40
        }
        
        if (estimatedItemSize.width == UIListViewAutomaticDimension)
        {
            estimatedItemSize.width = self.frame.width
        }
        
        return estimatedItemSize
    }
    
    private func _getEstimatedSectionFooterHeightAt(section: Int) -> CGFloat
    {
        var estimatedSectionFooterHeight : CGFloat! = nil
        
        if (self._delegate != nil)
        {
            estimatedSectionFooterHeight = self._delegate!.listView?(self, estimatedHeightForFooterInSection: section)
        }
        
        if (estimatedSectionFooterHeight == nil)
        {
            estimatedSectionFooterHeight = self.estimatedSectionFooterHeight
        }
        
        if (estimatedSectionFooterHeight == UIListViewAutomaticDimension)
        {
            if (self.style == UIListViewStyle.plain)
            {
                estimatedSectionFooterHeight = 40
            }
            else if (self.style == UIListViewStyle.grouped)
            {
                estimatedSectionFooterHeight = 40
            }
        }
        
        return estimatedSectionFooterHeight
    }
    
    private func _getSectionHeaderHeightAt(section: Int) -> CGFloat
    {
        var sectionHeaderHeight : CGFloat! = nil
        
        if (self._delegate != nil)
        {
            sectionHeaderHeight = self._delegate!.listView?(self, heightForHeaderInSection: section)
        }
        
        if (sectionHeaderHeight == nil)
        {
            sectionHeaderHeight = self.sectionHeaderHeight
        }
        
        if (sectionHeaderHeight == UIListViewAutomaticDimension)
        {
            if (self.style == UIListViewStyle.plain)
            {
                sectionHeaderHeight = 40
            }
            else if (self.style == UIListViewStyle.grouped)
            {
                sectionHeaderHeight = 60
            }
        }
        
        return sectionHeaderHeight
    }
    
    private func _getItemSizeAt(indexPath: IndexPath) -> CGSize
    {
        var itemSize : CGSize! = nil
        
        if (self._delegate != nil)
        {
            itemSize = self._delegate!.listView?(self, sizeForItemAt: indexPath)
        }
        
        if (itemSize == nil)
        {
            itemSize = self.itemSize
        }
        
        if (itemSize.height == UIListViewAutomaticDimension)
        {
            itemSize.height = 40
        }
        
        if (itemSize.width == UIListViewAutomaticDimension)
        {
            itemSize.width = self.frame.width
        }
        
        return itemSize
    }
    
    private func _getSectionFooterHeightAt(section: Int) -> CGFloat
    {
        var sectionFooterHeight : CGFloat! = nil
        
        if (self._delegate != nil)
        {
            sectionFooterHeight = self._delegate!.listView?(self, heightForFooterInSection: section)
        }
        
        if (sectionFooterHeight == nil)
        {
            sectionFooterHeight = self.sectionFooterHeight
        }
        
        if (sectionFooterHeight == UIListViewAutomaticDimension)
        {
            if (self.style == UIListViewStyle.plain)
            {
                sectionFooterHeight = 40
            }
            else if (self.style == UIListViewStyle.grouped)
            {
                sectionFooterHeight = 40
            }
        }
        
        return sectionFooterHeight
    }
    
    private func _getContentView(text: String?, type: UIMetaType) -> UIListViewHeaderFooterContentView
    {
        var title = text
        var font = UIFont.boldSystemFont(ofSize: 17)
        var textColor = UIColor(red: 115/255, green: 115/255, blue: 120/255, alpha: 1)
        
        if (self.style == UIListViewStyle.plain)
        {
            textColor = UIColor.black
        }
        
        if (type == UIMetaType.header)
        {
            if (self.style == UIListViewStyle.grouped)
            {
                title = text?.uppercased()
                font = UIFont.systemFont(ofSize: 16)
            }
        }
        else if (type == UIMetaType.footer)
        {
            if (self.style == UIListViewStyle.grouped)
            {
                font = UIFont.systemFont(ofSize: 15)
            }
        }
        
        let contentView = UIListViewHeaderFooterContentView()
        contentView.label.font = font
        contentView.label.textColor = textColor
        contentView.label.text = title
        
        if (self.style == UIListViewStyle.plain)
        {
            contentView.backgroundColor = self.backgroundColor
        }
        
        return contentView
    }
    
    private func _setViewFrameIfNeeded(at indexPath: IndexPath)
    {
        let meta = self._getMeta(item: indexPath.item, section: indexPath.section)
        
        if (meta._view_ != nil)
        {
            meta._view_!.frame = CGRect(x: meta._globalOffset_.x,
                                        y: meta._globalOffset_.y,
                                        width: meta.width,
                                        height: meta.height)
        }
    }
    
    private func _displayCellViewForRowIfNeeded(at indexPath: IndexPath) -> Bool
    {
        var shouldDisplayCellView = false
        let meta = self._getMeta(item: indexPath.item, section: indexPath.section)
        
        if (meta._view_ == nil)
        {
            if (meta.type == UIMetaType.cell)
            {
                self._displayScrollingView(at: indexPath)
                
                if (meta._view_!.frame.origin.y + meta._view_!.frame.height  < self.contentOffset.y || meta._view_!.frame.origin.y > self.contentOffset.y + self.frame.height)
                {
                    self._endDisplayScrollingView(at: indexPath)
                }
                else
                {
                    shouldDisplayCellView = true
                }
            }
        }
        else
        {
            self._setViewFrameIfNeeded(at: indexPath)
        }
        
        return shouldDisplayCellView
    }
    
    private func _displayNextCellViewsIfNeeded(from indexPath: IndexPath)
    {
        let meta = self._getMeta(item: indexPath.item, section: indexPath.section)
        
        if (meta._globalOffset_.x + meta.width < self.frame.width)
        {
            if (indexPath.item + 1 <= self.numberOfItems(inSection: indexPath.section) - 1)
            {
                for item in indexPath.item + 1...self.numberOfItems(inSection: indexPath.section) - 1
                {
                    let nextIndexPath = IndexPath(item: item, section: indexPath.section)
                    
                    if (self._displayCellViewForRowIfNeeded(at: nextIndexPath))
                    {
                        self._visibleIndexPaths.append(nextIndexPath)
                        
                        let nextMeta = self._getMeta(item: nextIndexPath.item, section: nextIndexPath.section)
                        
                        if (nextMeta._globalOffset_.x + nextMeta.width == self.frame.width)
                        {
                            break
                        }
                    }
                    else
                    {
                        break
                    }
                }
            }
        }
    }
    
    private func _displayPreviousCellViewsIfNeeded(from indexPath: IndexPath)
    {
        let meta = self._getMeta(item: indexPath.item, section: indexPath.section)
        
        if (meta._globalOffset_.x > 0)
        {
            if (indexPath.item - 1 >= 0)
            {
                for item in (0...indexPath.item - 1).reversed()
                {
                    let previousIndexPath = IndexPath(item: item, section: indexPath.section)
                    
                    if (self._displayCellViewForRowIfNeeded(at: previousIndexPath))
                    {
                        self._visibleIndexPaths.insert(previousIndexPath, at: 0)
                        
                        let previousMeta = self._getMeta(item: previousIndexPath.item, section: previousIndexPath.section)
                        
                        if (previousMeta._globalOffset_.x == 0)
                        {
                            break
                        }
                    }
                    else
                    {
                        break
                    }
                }
            }
        }
    }
    
    private func _displayScrollingView(at indexPath: IndexPath)
    {
        let meta = self._getMeta(item: indexPath.item, section: indexPath.section)

        if (meta._view_ == nil)
        {
            if (meta.type == UIMetaType.header)
            {
                var headerView : UIView? = nil
                
                if (self._delegate != nil)
                {
                    headerView = self._delegate!.listView?(self, viewForHeaderInSection: meta.section)
                }
                
                if (headerView == nil)
                {
                    let title = self.dataSource!.listView?(self, titleForHeaderInSection: meta.section)
                    
                    if (title != nil || self.style == UIListViewStyle.plain)
                    {
                        headerView = self._getContentView(text: title, type: meta.type)
                    }
                }
                
                meta._view_ = headerView
                self._assertSize(at: indexPath)
                
                if (headerView != nil)
                {
                    self._setViewFrameIfNeeded(at: indexPath)
                    
                    if (self._delegate != nil)
                    {
                        self._delegate!.listView?(self, willDisplayHeaderView: headerView!, forSection: indexPath.section)
                    }
                    
                    self.addSubview(headerView!)
                }
            }
            else if (meta.type == UIMetaType.footer)
            {
                var footerView : UIView? = nil
                
                if (self._delegate != nil)
                {
                    footerView = self._delegate!.listView?(self, viewForFooterInSection: meta.section)
                }
                
                if (footerView == nil)
                {
                    let title = self.dataSource!.listView?(self, titleForFooterInSection: meta.section)
                    
                    if (title != nil || self.style == UIListViewStyle.plain)
                    {
                        footerView = self._getContentView(text: title, type: meta.type)
                    }
                }
                
                meta._view_ = footerView
                self._assertSize(at: indexPath)
                
                if (footerView != nil)
                {
                    self._setViewFrameIfNeeded(at: indexPath)
                    
                    if (self._delegate != nil)
                    {
                        self._delegate!.listView?(self, willDisplayFooterView: footerView!, forSection: indexPath.section)
                    }
                    
                    self.addSubview(footerView!)
                }
            }
            else
            {
                let cell = self.dataSource!.listView(self, cellForItemAt: indexPath)
                meta._view_ = cell
                self._assertSize(at: indexPath)
                self._setViewFrameIfNeeded(at: indexPath)
                
                if (self._delegate != nil)
                {
                    self._delegate!.listView?(self, willDisplay: cell, forItemAt: indexPath)
                }
                
                self.addSubview(cell)
            }
        }
        else
        {
            self._setViewFrameIfNeeded(at: indexPath)
        }
    }
    
    private func _displaySlidingView(for contentIndexPath: IndexPath, at metaIndexPath: IndexPath)
    {
        let meta = self._getMeta(item: metaIndexPath.item, section: metaIndexPath.section)
        
        if (meta._view_ == nil)
        {
            let cell = self.dataSource!.listView(self, cellForItemAt: contentIndexPath)
            meta._view_ = cell
            self._setViewFrameIfNeeded(at: metaIndexPath)
            
            if (self._delegate != nil)
            {
                self._delegate!.listView?(self, willDisplay: cell, forItemAt: contentIndexPath)
            }
            
            self.addSubview(cell)
        }
        else
        {
            self._setViewFrameIfNeeded(at: metaIndexPath)
        }
        
        self._contentIndexPathByItemIndexPath[metaIndexPath] = contentIndexPath
    }
    
    private func _endDisplayScrollingView(at indexPath: IndexPath)
    {
        let meta = self._getMeta(item: indexPath.item, section: indexPath.section)
        
        if (meta._view_ != nil)
        {
            meta._view_!.removeFromSuperview()
            
            if (self._delegate != nil)
            {
                if (meta.type == UIMetaType.header)
                {
                    self._delegate!.listView?(self, didEndDisplayingHeaderView: meta._view_!, forSection: meta.section)
                }
                else if (meta.type == UIMetaType.footer)
                {
                    self._delegate!.listView?(self, didEndDisplayingFooterView: meta._view_!, forSection: meta.section)
                }
                else
                {
                    let cell = meta._view_ as! UIListViewCell
                    self._delegate!.listView?(self, didEndDisplaying: cell, forItemAt: indexPath)
                }
            }
            
            meta._view_ = nil
        }
    }
    
    private func _endDisplaySlidingView(at metaIndexPath: IndexPath)
    {
        let meta = self._getMeta(item: metaIndexPath.item, section: metaIndexPath.section)
        
        if (meta._view_ != nil)
        {
            meta._view_!.removeFromSuperview()
            
            if (self._delegate != nil)
            {
                let cell = meta._view_ as! UIListViewCell
                self._delegate!.listView?(self,
                                          didEndDisplaying: cell,
                                          forItemAt: self._contentIndexPathByItemIndexPath[metaIndexPath]!)
            }
            
            meta._view_ = nil
        }
        
        self._contentIndexPathByItemIndexPath[metaIndexPath] = nil
    }
    
    private func _setFocusItemToMeta(at indexPath: IndexPath)
    {
        var oldIndexPaths = [IndexPath]()
        var newIndexPaths = [IndexPath]()
        
        var shiftingDirection = UIListViewTransitionDirection.reverse
        
        if (indexPath.item > self._focusItemIndexPath_.item)
        {
            shiftingDirection = UIListViewTransitionDirection.forward
        }
        
        if (self._visibleIndexPaths.count > 0)
        {
            var visibleIndexPaths : [IndexPath]! = nil
            
            if (shiftingDirection == UIListViewTransitionDirection.reverse)
            {
                visibleIndexPaths = self._visibleIndexPaths
            }
            else if (shiftingDirection == UIListViewTransitionDirection.forward)
            {
                visibleIndexPaths = self._visibleIndexPaths.reversed()
            }
            
            for visibleIndexPath in visibleIndexPaths
            {
                var newIndexPath : IndexPath? = nil
                
                if (visibleIndexPath != self._focusItemIndexPath_)
                {
                    let item = visibleIndexPath.item + (indexPath.item - self._focusItemIndexPath_.item)
                    
                    if (item < 0 || item > 2)
                    {
                        self._endDisplaySlidingView(at: visibleIndexPath)
                        continue
                    }
                    else
                    {
                        newIndexPath = IndexPath(item: item, section: 0)
                    }
                }
                else
                {
                    newIndexPath = indexPath
                }
                
                if (newIndexPath != nil)
                {
                    oldIndexPaths.append(visibleIndexPath)
                    newIndexPaths.append(newIndexPath!)
                }
            }
        }
        else
        {
            oldIndexPaths.append(indexPath)
            newIndexPaths.append(indexPath)
        }
        
        for (index, oldIndexPath) in oldIndexPaths.enumerated()
        {
            let newIndexPath = newIndexPaths[index]
            let newMeta = self._getMeta(item: newIndexPath.item, section: newIndexPath.section)
            let oldMeta = self._getMeta(item: oldIndexPath.item, section: oldIndexPath.section)
            let view = oldMeta._view_
            oldMeta._view_ = nil
            let contentIndexPath = self._contentIndexPathByItemIndexPath[oldIndexPath]!
            self._contentIndexPathByItemIndexPath[oldIndexPath] = nil
            newMeta._view_ = view
            self._contentIndexPathByItemIndexPath[newIndexPath] = contentIndexPath
            self._displaySlidingView(for: self._contentIndexPathByItemIndexPath[newIndexPath]!, at: newIndexPath)
        }
        
        if (shiftingDirection == UIListViewTransitionDirection.reverse)
        {
            self._visibleIndexPaths = newIndexPaths
        }
        else if (shiftingDirection == UIListViewTransitionDirection.forward)
        {
            self._visibleIndexPaths = newIndexPaths.reversed()
        }
        
        self._focusItemIndexPath_ = indexPath
        self._initialOffsetY = self._focusItemMeta._globalOffset_.y
        self.setContentOffset(self._focusItemMeta._globalOffset_, animated: false)
    }
    
    private func _displayVisibleSlidingViewIfNeeded(at contentIndexPath: IndexPath, for direction: UIListViewSlideDirection)
    {
        if (self._visibleIndexPaths.count >= 1)
        {
            var metaIndexPath : IndexPath! = nil
            
            if (direction == UIListViewSlideDirection.reverse)
            {
                if (self._visibleIndexPaths.first != self._topItemIndexPath)
                {
                    metaIndexPath = self._topItemIndexPath
                    self._visibleIndexPaths.insert(metaIndexPath, at: 0)
                }
            }
            else if (direction == UIListViewSlideDirection.forward)
            {
                if (self._visibleIndexPaths.first != self._bottomItemIndexPath)
                {
                    metaIndexPath = self._bottomItemIndexPath
                    self._visibleIndexPaths.append(metaIndexPath)
                }
            }
            
            if (metaIndexPath != nil)
            {
                self._displaySlidingView(for: contentIndexPath, at: metaIndexPath!)
            }
        }
    }
    
    private func _getMeta(item: Int, section: Int) -> UIMeta
    {
        var meta : UIMeta! = nil
        
        if (self._isScrollingModeEnabled)
        {
            self._setInitialOffsetIfNeeded(at: section)
            let metaGroup = self._scrollingMetaGroups_[section]
            meta = metaGroup.getMeta(at: item)
            
            if (self._listHeaderView != nil)
            {
                meta._globalOffset_.y += self._listHeaderView!.frame.height
            }
        }
        else
        {
            meta = self._slidingMetaGroup_.getMeta(at: item)
        }
        
        return meta
    }

    private func _setInitialOffset(from startIndex: Int, to endIndex: Int, with initialOffset: CGFloat)
    {
        var currentOffset = initialOffset
        
        for index in startIndex...endIndex
        {
            let metaGroup = self._scrollingMetaGroups_[index]
            metaGroup.initialOffset = currentOffset
            currentOffset += metaGroup.height
        }
    }
    
    private func _setInitialOffsetIfNeeded(at section: Int)
    {
        if (self._modifiedScrollingMetaGroup != nil)
        {
            if (section > self._modifiedScrollingMetaGroup!.section)
            {
                let initialOffset = self._modifiedScrollingMetaGroup!.initialOffset + self._modifiedScrollingMetaGroup!.height
                self._setInitialOffset(from: self._modifiedScrollingMetaGroup!.section  + 1,
                                      to: section,
                                      with: initialOffset)
                self._modifiedScrollingMetaGroup = self._scrollingMetaGroups_[section]
            }
        }
    }
    
    private func _assertSize(at indexPath: IndexPath)
    {
        let meta = self._getMeta(item: indexPath.item, section: indexPath.section)
        var size = CGSize(width: self.frame.width, height: 0)
        
        if (meta.type == UIMetaType.header)
        {
            size.height = self._getSectionHeaderHeightAt(section: indexPath.section)
        }
        else if (meta.type == UIMetaType.footer)
        {
            size.height = self._getSectionFooterHeightAt(section: indexPath.section)
        }
        else
        {
            size = self._getItemSizeAt(indexPath: indexPath)
        }
        
        if (meta.type == UIMetaType.header || meta.type == UIMetaType.footer)
        {
            if (meta._view_ != nil &&
                meta._view_ is UIListViewHeaderFooterContentView &&
                self.numberOfSections == 1)
            {
                let view = meta._view_ as! UIListViewHeaderFooterContentView
                
                if (view.label.text == nil || view.label.text == "")
                {
                    size.height = 0
                }
            }            
        }
        
        if (meta.width != size.width || meta.height != size.height)
        {
            let metaGroup = self._scrollingMetaGroups_[indexPath.section]
            
            if (meta.height != size.height)
            {
                meta.height = size.height
            }
            
            if (meta.width != size.width)
            {
                meta.width = size.width
            }
            
            self._setInitialOffsetIfNeeded(at: indexPath.section)
            self._modifiedScrollingMetaGroup = metaGroup
        }
    }
    
    private func _loadScrollingViews()
    {
        self._loadHeaderViewIfNeeded()
        
        if (self._canLoadPartialViews)
        {
            self._loadPartialViewsIfNeeded()
        }
        else
        {
            self._loadInitialScrollingViewsIfNeeded()
        }
        
        self._contentSize.width = self.frame.width
        self._loadFooterViewIfNeeded()
        
        if (self.style == UIListViewStyle.plain)
        {
            self._displaySectionHeaderViewIfNeeded()
            self._displaySectionFooterViewIfNeeded()
        }
    }
    
    private func _loadSlidingViews()
    {
        if (self._canLoadPartialViews)
        {
            self._loadPartialViewsIfNeeded()
        }
        else
        {
            self._loadInitialSlidingViewsIfNeeded()
        }
        
        self._contentSize.width = self.frame.height
    }
    
    private func _unloadScrollingViews()
    {
        for visibleIndexPath in self._visibleIndexPaths
        {
            self._endDisplayScrollingView(at: visibleIndexPath)
        }
        
        self._initialOffsetY = 0
        self._previousOffsetY = 0
        self._visibleIndexPaths = [IndexPath]()
        self._selectedIndexPaths = [IndexPath]()
        self._canLoadPartialViews = false
        self._scrollingMetaGroups = nil
        self._focusItemIndexPath = nil
        self._focusSectionHeaderIndexPath = nil
        self._focusSectionFooterIndexPath = nil
        self._numberOfItemsBySection = [Int:Int]()
    }
    
    private func _unloadSlidingViews()
    {
        for visibleIndexPath in self._visibleIndexPaths
        {
            self._endDisplaySlidingView(at: visibleIndexPath)
        }
        
        self._initialOffsetY = 0
        self._previousOffsetY = 0
        self._visibleIndexPaths = [IndexPath]()
        self._contentIndexPathByItemIndexPath = [IndexPath:IndexPath]()
        self._canLoadPartialViews = false
        self._slidingMetaGroup = nil
        self._focusItemIndexPath = nil
    }
    
    private func _loadInitialScrollingViewsIfNeeded()
    {
        if (self.dataSource != nil)
        {
            self._loadScrollingMetaGroupsIfNeeded()
            
            if (self._scrollingMetaGroups_.count > 0)
            {
                if (self.contentOffset.y < 0)
                {
                    self.contentOffset.y = 0
                }
                
                let lastContentOffset = self.contentOffset
             
                for metaGroup in self._scrollingMetaGroups_
                {
                    let initialMeta = self._getMeta(item: -1, section: metaGroup.section)
                    
                    if (initialMeta._globalOffset_.y <= lastContentOffset.y + self.frame.height)
                    {
                        let indexPath = IndexPath(item: initialMeta.item, section: initialMeta.section)
                        self._displayScrollingView(at: indexPath)
                        self._visibleIndexPaths.append(indexPath)
                    }
                    
                    self._loadBottomViewsIfNeeded()
                }
                
                self.setContentOffset(lastContentOffset, animated: false)
                self._previousOffsetY = lastContentOffset.y
                self._canLoadPartialViews = true
            }
        }
    }
    
    private func _loadInitialSlidingViewsIfNeeded()
    {
        if (self.dataSource != nil)
        {
            self._loadSlidingMetaGroupIfNeeded()
            
            if (self._slidingMetaGroup_.numberOfItems > 0)
            {
                if (self.contentOffset.y < 0)
                {
                    self.contentOffset.y = 0
                }
                
                var contentIndexPath = self.dataSource!.listView?(self, initializeAt: self._topItemIndexPath)
                
                if (contentIndexPath == nil)
                {
                    contentIndexPath = self._topItemIndexPath
                }
                
                self._contentIndexPathByItemIndexPath[self._centerItemIndexPath] = contentIndexPath
                self._setFocusItemToMeta(at: self._centerItemIndexPath)
                self._previousOffsetY = self._focusItemMeta._globalOffset_.y
            }
            
            self._canLoadPartialViews = true
        }
    }
    
    private func _loadScrollingMetaGroupsIfNeeded()
    {
        if (self._scrollingMetaGroups_.count == 0)
        {
            var numberOfSections = self.dataSource?.numberOfListSections?(in: self)
            
            if (numberOfSections != 0)
            {
                if (numberOfSections == nil)
                {
                    numberOfSections = 1
                }
                
                self._contentSize.height = 0
                
                for section in 0...numberOfSections! - 1
                {
                    let metaGroup = UIListViewMetaGroup(section: section,
                                                        initialOffset: self._contentSize.height,
                                                        width: self.frame.width,
                                                        delegate: self)
                    self._scrollingMetaGroups_.append(metaGroup)
                    
                    let estimatedSectionHeaderHeight = self._getEstimatedSectionHeaderHeightAt(section: section)
                    metaGroup.headerMeta.width = self.frame.width
                    metaGroup.headerMeta.height = estimatedSectionHeaderHeight
                    
                    let estimatedSectionFooterHeight = self._getEstimatedSectionFooterHeightAt(section: section)
                    metaGroup.footerMeta.width = self.frame.width
                    metaGroup.footerMeta.height = estimatedSectionFooterHeight
                    
                    let numberOfItems = self.dataSource?.listView(self, numberOfItemsInSection: section)
                    
                    if (numberOfItems != nil && numberOfItems! > 0)
                    {
                        for counter in 0...numberOfItems! - 1
                        {
                            let indexPath = IndexPath(item: counter, section: section)
                            let estimatedItemSize = self._getEstimatedItemSizeAt(indexPath: indexPath)
                            metaGroup.appendCellMeta(size: estimatedItemSize)
                        }
                    }
                }
                
                if (self._listHeaderView != nil)
                {
                    self._contentSize.height += self._listHeaderView!.frame.height
                }
                
                if (self._listFooterView != nil)
                {
                    self._contentSize.height += self._listFooterView!.frame.height
                }
            }
        }
    }
    
    private func _loadSlidingMetaGroupIfNeeded()
    {
        if (self._slidingMetaGroup_.numberOfItems == 0)
        {
            let itemSize = self.frame.size
            
            for _ in 0...2
            {
                self._slidingMetaGroup_.appendCellMeta(size: itemSize)
            }
        }
    }
    
    private func _getPreviousIndexPath(from currentIndexPath: IndexPath, isHeaderAndFooterIncluded: Bool) -> IndexPath?
    {
        var previousIndexPath : IndexPath? = nil
        var isPreviousIndexPathAvailableInCurrentSection = !isHeaderAndFooterIncluded && currentIndexPath.item - 1 > -1
        
        if (!isPreviousIndexPathAvailableInCurrentSection)
        {
            isPreviousIndexPathAvailableInCurrentSection = isHeaderAndFooterIncluded && currentIndexPath.item - 1 >= -1
        }
        
        if (isPreviousIndexPathAvailableInCurrentSection)
        {
            previousIndexPath = IndexPath(item: currentIndexPath.item - 1, section: currentIndexPath.section)
        }
        else if (currentIndexPath.section - 1 >= 0)
        {
            var previousItem : Int! = nil
            
            if (!isHeaderAndFooterIncluded)
            {
                previousItem = self.numberOfItems(inSection: currentIndexPath.section - 1) - 1
            }
            else
            {
                previousItem = self.numberOfItems(inSection: currentIndexPath.section - 1)
            }
            
            previousIndexPath = IndexPath(item: previousItem, section: currentIndexPath.section - 1)
        }
        
        return previousIndexPath
    }
    
    private func _getNextIndexPath(from currentIndexPath: IndexPath, isHeaderAndFooterIncluded: Bool) -> IndexPath?
    {
        var nextIndexPath : IndexPath? = nil
        var isNextIndexPathAvailableInCurrentSection = !isHeaderAndFooterIncluded && currentIndexPath.item + 1 < self.numberOfItems(inSection: currentIndexPath.section)
        
        if (!isNextIndexPathAvailableInCurrentSection)
        {
            isNextIndexPathAvailableInCurrentSection = isHeaderAndFooterIncluded && currentIndexPath.item + 1 <= self.numberOfItems(inSection: currentIndexPath.section)
        }
        
        if (isNextIndexPathAvailableInCurrentSection)
        {
            nextIndexPath = IndexPath(item: currentIndexPath.item + 1, section: currentIndexPath.section)
        }
        else if (currentIndexPath.section + 1 < self._scrollingMetaGroups_.count)
        {
            if (!isHeaderAndFooterIncluded)
            {
                nextIndexPath = IndexPath(item: 0, section: currentIndexPath.section + 1)
            }
            else
            {
                nextIndexPath = IndexPath(item: -1, section: currentIndexPath.section + 1)
            }
        }
        
        return nextIndexPath
    }
    
    private func _loadBottomViewsIfNeeded()
    {
        while (self._shouldLoadBottomViews)
        {
            if (self._isScrollingModeEnabled)
            {
                let nextIndexPath = self._getNextIndexPath(from: self._visibleIndexPaths.last!,
                                                           isHeaderAndFooterIncluded: true)
                
                if (nextIndexPath != nil)
                {
                    self._displayScrollingView(at: nextIndexPath!)
                    self._visibleIndexPaths.append(nextIndexPath!)
                    self._displayNextCellViewsIfNeeded(from: nextIndexPath!)
                }
                else
                {
                    break
                }
            }
            else
            {
                let contentIndexPath = self._contentIndexPathByItemIndexPath[self._focusItemIndexPath_]
                var nextIndexPath : IndexPath? = nil
                
                if (contentIndexPath != nil)
                {
                    nextIndexPath = self.dataSource!.listView?(self, indexPathAfter: contentIndexPath!)
                }
                
                if (nextIndexPath != nil)
                {
                    if (self._focusItemIndexPath_ != self._centerItemIndexPath)
                    {
                        self._setFocusItemToMeta(at: self._centerItemIndexPath)
                    }
                    
                    self._displayVisibleSlidingViewIfNeeded(at: nextIndexPath!, for: UIListViewSlideDirection.forward)
                }
                else
                {
                    if (self._focusItemIndexPath_ != self._bottomItemIndexPath)
                    {
                        self._setFocusItemToMeta(at: self._bottomItemIndexPath)
                    }
                }
                
                break
            }
        }
    }
    
    private func _loadTopViewsIfNeeded()
    {
        while (self._shouldLoadTopViews)
        {
            if (self._isScrollingModeEnabled)
            {
                let previousIndexPath = self._getPreviousIndexPath(from: self._visibleIndexPaths.first!,
                                                                   isHeaderAndFooterIncluded: true)
                
                if (previousIndexPath != nil)
                {
                    self._displayScrollingView(at: previousIndexPath!)
                    self._visibleIndexPaths.insert(previousIndexPath!, at: 0)
                    self._displayPreviousCellViewsIfNeeded(from: previousIndexPath!)
                }
                else
                {
                    break
                }
            }
            else
            {
                let contentIndexPath = self._contentIndexPathByItemIndexPath[self._focusItemIndexPath_]
                var previousIndexPath : IndexPath? = nil
                
                if (contentIndexPath != nil)
                {
                    previousIndexPath = self.dataSource!.listView?(self, indexPathBefore: contentIndexPath!)
                }
                
                if (previousIndexPath != nil)
                {
                    if (self._focusItemIndexPath_ != self._centerItemIndexPath)
                    {
                        self._setFocusItemToMeta(at: self._centerItemIndexPath)
                    }
                    
                    self._displayVisibleSlidingViewIfNeeded(at: previousIndexPath!, for: UIListViewSlideDirection.reverse)
                }
                else
                {
                    if (self._focusItemIndexPath_ != self._topItemIndexPath)
                    {
                        self._setFocusItemToMeta(at: self._topItemIndexPath)
                    }
                }
                
                break
            }
        }
    }
    
    private func _unloadBottomViewsIfNeeded()
    {
        while (self._shouldUnloadBottomViews)
        {
            if (self._isScrollingModeEnabled)
            {
                if (self._visibleIndexPaths.count > 1)
                {
                    self._endDisplayScrollingView(at: self._visibleIndexPaths.last!)
                    self._visibleIndexPaths.removeLast()
                }
                else
                {
                    break
                }
            }
            else
            {
                if (self._visibleIndexPaths.count > 1)
                {
                    self._endDisplaySlidingView(at: self._visibleIndexPaths.last!)
                    self._visibleIndexPaths.removeLast()
                }
                
                break
            }
        }
    }
    
    private func _unloadTopViewsIfNeeded()
    {
        while (self._shouldUnloadTopViews)
        {
            if (self._isScrollingModeEnabled)
            {
                if (self._visibleIndexPaths.count > 1)
                {
                    self._endDisplayScrollingView(at: self._visibleIndexPaths.first!)
                    self._visibleIndexPaths.removeFirst()
                }
                else
                {
                    break
                }
            }
            else
            {
                if (self._visibleIndexPaths.count > 1)
                {
                    self._endDisplaySlidingView(at: self._visibleIndexPaths.first!)
                    self._visibleIndexPaths.removeFirst()
                }
                
                break
            }
        }
    }
    
    private func _loadPartialViewsIfNeeded()
    {
        if (self._visibleIndexPaths.count > 0)
        {
            if (self.contentOffset.y < self._previousOffsetY)
            {
                if (self._previousOffsetY - self.contentOffset.y < self.frame.height)
                {
                    self._unloadBottomViewsIfNeeded()
                    self._loadTopViewsIfNeeded()
                }
                else
                {
                    self._loadTopViewsIfNeeded()
                    self.setNeedsLayout()
                }
            }
            else if (self.contentOffset.y > self._previousOffsetY)
            {
                if (self.contentOffset.y - self._previousOffsetY < self.frame.height)
                {
                    self._unloadTopViewsIfNeeded()
                    self._loadBottomViewsIfNeeded()
                }
                else
                {
                    self._loadBottomViewsIfNeeded()
                    self.setNeedsLayout()
                }
            }
            else
            {
                self._unloadBottomViewsIfNeeded()
                self._loadTopViewsIfNeeded()
                self._unloadTopViewsIfNeeded()
                self._loadBottomViewsIfNeeded()
            }
            
            self._previousOffsetY = self.contentOffset.y
        }
    }
    
    private func _displayVisibleScrollingViewsIfNeeded(to indexPath: IndexPath)
    {
        let meta = self._getMeta(item: indexPath.item, section: indexPath.section)
        
        if (meta._view_ == nil)
        {
            var startSection = indexPath.section
            var endSection = indexPath.section
            var initialItem : Int! = nil
            var finalItem : Int! = nil
            var shouldAssertSizes = true
            
            if (indexPath.section < self.indexPathsForVisibleItems!.first!.section)
            {
                endSection = self.indexPathsForVisibleItems!.first!.section
                initialItem = indexPath.item
                finalItem = self.indexPathsForVisibleItems!.first!.item - 1
            }
            else if (indexPath.section > self.indexPathsForVisibleItems!.last!.section)
            {
                startSection = self.indexPathsForVisibleItems!.last!.section
                initialItem = self.indexPathsForVisibleItems!.last!.item + 1
                finalItem = indexPath.item
            }
            else
            {
                if (indexPath.item < self.indexPathsForVisibleItems!.first!.item)
                {
                    initialItem = indexPath.item
                    finalItem = self.indexPathsForVisibleItems!.first!.item - 1
                }
                else if (indexPath.item > self.indexPathsForVisibleItems!.last!.item)
                {
                    initialItem = self.indexPathsForVisibleItems!.last!.item + 1
                    finalItem = indexPath.item
                }
                else
                {
                    shouldAssertSizes = false
                }
            }
            
            if (shouldAssertSizes)
            {
                for section in startSection...endSection
                {
                    var startItem = -1
                    var endItem = self.numberOfItems(inSection: section)
                    
                    if (section == startSection)
                    {
                        startItem = initialItem
                    }
                    
                    if (section == endSection)
                    {
                        endItem = finalItem
                    }
                    
                    for item in startItem...endItem
                    {
                        let indexPath = IndexPath(item: item, section: section)
                        self._displayScrollingView(at: indexPath)
                    }
                }
            }
        }
    }
    
    @objc private func _toggleCell(_ sender: UITapGestureRecognizer!)
    {
        if (self._isScrollingModeEnabled && self.allowsSelection)
        {
            if (sender.state == UIGestureRecognizerState.ended)
            {
                var toggledIndexpath : IndexPath? = nil
                var isToggledCellSelected = false
                
                for visibleIndexPath in self._visibleIndexPaths
                {
                    let meta = self._getMeta(item: visibleIndexPath.item, section: visibleIndexPath.section)
                    
                    if (meta.type == UIMetaType.cell)
                    {
                        let cell = meta._view_ as! UIListViewCell
                        
                        if ((sender.location(in: cell).y >= 0 && sender.location(in: cell).y < cell.frame.height) && (sender.location(in: cell).x >= 0 && sender.location(in: cell).x < cell.frame.width))
                        {
                            isToggledCellSelected = cell.isSelected
                            toggledIndexpath = visibleIndexPath
                            break
                        }
                    }
                }
                
                if (toggledIndexpath != nil)
                {
                    if (self.allowsMultipleSelection)
                    {
                        if (isToggledCellSelected)
                        {
                            self._deselectCell(at: toggledIndexpath!)
                        }
                        else
                        {
                            self._selectCell(at: toggledIndexpath!)
                        }
                    }
                    else
                    {
                        for selectedIndexPath in self._selectedIndexPaths
                        {
                            self._deselectCell(at: selectedIndexPath)
                        }
                        
                        self._selectCell(at: toggledIndexpath!)
                    }
                }
            }
        }
    }
    
    private func _selectCell(at indexPath: IndexPath)
    {
        var selectedIndexPath : IndexPath? = nil
        
        if (self._delegate != nil)
        {
            selectedIndexPath = self._delegate!.listView?(self, willSelectItemAt: indexPath)
        }
        
        if (selectedIndexPath != nil)
        {
            let meta = self._getMeta(item: indexPath.item, section: indexPath.section)
            
            if (meta._view_ != nil)
            {
                let cell = meta._view_ as! UIListViewCell
                cell.isSelected = true
            }
            
            self._selectedIndexPaths.append(indexPath)
            
            if (self._delegate != nil)
            {
                self._delegate!.listView?(self, didSelectItemAt: selectedIndexPath!)
            }
        }
    }
    
    private func _deselectCell(at indexPath: IndexPath)
    {
        var deselectedIndexPath : IndexPath? = nil
        
        if (self._delegate != nil)
        {
            deselectedIndexPath = self._delegate!.listView?(self, willDeselectItemAt: indexPath)
        }
        
        if (deselectedIndexPath != nil)
        {
            for (counter, selectedIndexPath) in self._selectedIndexPaths.enumerated().reversed()
            {
                if (selectedIndexPath == indexPath)
                {
                    let meta = self._getMeta(item: selectedIndexPath.item, section: selectedIndexPath.section)
                    
                    if (meta._view_ != nil)
                    {
                        let cell = meta._view_ as! UIListViewCell
                        cell.isSelected = false
                    }
                    
                    self._selectedIndexPaths.remove(at: counter)
                    break
                }
            }
            
            if (self._delegate != nil)
            {
                self._delegate!.listView?(self, didDeselectItemAt: deselectedIndexPath!)
            }
        }
    }
}
