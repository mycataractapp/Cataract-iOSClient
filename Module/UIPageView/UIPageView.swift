//
//  UIPageView.swift
//  Pacific
//
//  Created by Minh Nguyen on 11/24/15.
//  Copyright © 2015 Minh Nguyen. All rights reserved.
//

import UIKit

private enum UIPageViewTransitionDirection : Int
{
    case none
    case forward
    case reverse
}

enum UIPageViewScrollPosition : Int
{
    case none
    case left
    case middle
    case right
}

enum UIPageViewSlideDirection : Int
{
    case forward
    case reverse
}

enum UIPageViewStyle : Int
{
    case plain = 0
    case grouped = 1
}

enum UIPageViewMode : Int
{
    case manualScrolling
    case autoScrolling
    case sliding
}

let UIPageViewAutomaticNumberOfItems = 0
let UIPageViewAutomaticDimension = UITableViewAutomaticDimension

class UIPageView : UIScrollView, UIScrollViewDelegate, UIGestureRecognizerDelegate, UIPageViewMetaGroupDelegate
{
    var itemSize = CGSize(width: UIPageViewAutomaticDimension, height: UIPageViewAutomaticDimension)
    var estimatedItemSize = CGSize(width: UIPageViewAutomaticDimension, height: UIPageViewAutomaticDimension)
    var sectionHeaderWidth = UIPageViewAutomaticDimension
    var estimatedSectionHeaderWidth = UIPageViewAutomaticDimension
    var sectionFooterWidth = UIPageViewAutomaticDimension
    var estimatedSectionFooterWidth = UIPageViewAutomaticDimension
    var anchorPosition = UIPageViewScrollPosition.none
    var scrollPosition = UIPageViewScrollPosition.left
    var scrollSpeed : Double = 0.35
    var scrollThreshold : CGFloat = 0
    var scrollBuffer : CGFloat = 10
    var allowsSelection = true
    var allowsMultipleSelection = false
    private var _style = UIPageViewStyle.plain
    private var _mode = UIPageViewMode.manualScrolling
    private var _contentSize = CGSize.zero
    private var _initialOffsetX : CGFloat = 0
    private var _previousOffsetX : CGFloat = 0
    private var _canLoadPartialViews = false
    private var _numberOfItemsBySection = [Int:Int]()
    private var _visibleIndexPaths = [IndexPath]()
    private var _selectedIndexPaths = [IndexPath]()
    private var _contentIndexPathByItemIndexPath = [IndexPath:IndexPath]()
    private var _leftItemIndexPath = IndexPath(item: 0, section: 0)
    private var _centerItemIndexPath = IndexPath(item: 1, section: 0)
    private var _rightItemIndexPath = IndexPath(item: 2, section: 0)
    private var _animations = [UIPageViewAnimation]()
    private var _scrollingMetaGroups : [UIPageViewMetaGroup]!
    private var _slidingMetaGroup : UIPageViewMetaGroup!
    private var _tapGestureRecognizer : UITapGestureRecognizer!
    private var _focusItemIndexPath : IndexPath!
    private var _focusSectionHeaderIndexPath : IndexPath?
    private var _focusSectionFooterIndexPath : IndexPath?
    private var _autoScrollingItemIndexPath : IndexPath?
    private var _decelerationOffset : CGPoint?
    private var _pageHeaderView : UIView?
    private var _pageFooterView : UIView?
    private var _modifiedScrollingMetaGroup : UIPageViewMetaGroup?
    private var _shouldReloadAtBuffer : Bool?
    private weak var _dataSource : UIPageViewDataSource?
    private weak var _delegate : UIPageViewDelegate?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical = false
        self.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 241/255, alpha: 1)
        self.addGestureRecognizer(self._tapGestureRecognizer_)
    }
    
    convenience init(frame: CGRect, style: UIPageViewStyle, mode: UIPageViewMode)
    {
        self.init(frame: frame)
        
        self._style = style
        self._mode = mode
    }
    
    convenience init(style: UIPageViewStyle, mode: UIPageViewMode)
    {
        self.init(frame: CGRect.zero)
        
        self._style = style
        self._mode = mode
    }
    
    convenience init(style: UIPageViewStyle)
    {
        self.init(frame: CGRect.zero)
        
        self._style = style
        self._mode = UIPageViewMode.manualScrolling
    }
    
    convenience init(mode: UIPageViewMode)
    {
        self.init(frame: CGRect.zero)
        
        self._style = UIPageViewStyle.plain
        self._mode = mode
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    var style : UIPageViewStyle
    {
        get
        {
            let style = self._style
            
            return style
        }
    }
    
    var mode : UIPageViewMode
    {
        get
        {
            let mode = self._mode
            
            return mode
        }
    }
    
    var pageHeaderView : UIView?
    {
        get
        {
            let pageHeaderView = self._pageHeaderView
            
            return pageHeaderView
        }
        
        set(newValue)
        {
            if (self._isScrollingModeEnabled)
            {
                if (self._pageHeaderView != nil)
                {
                    self._pageHeaderView!.removeFromSuperview()
                    self._contentSize.width -= self._pageHeaderView!.frame.width
                }
                
                self._pageHeaderView = newValue
                self._contentSize.width += self._pageHeaderView!.frame.width
                self.setNeedsLayout()
            }
        }
    }
    
    var pageFooterView : UIView?
    {
        get
        {
            let pageFooterView = self._pageFooterView
            
            return pageFooterView
        }
        
        set(newValue)
        {
            if (self._isScrollingModeEnabled)
            {
                if (self._pageFooterView != nil)
                {
                    self._pageFooterView!.removeFromSuperview()
                    self._contentSize.width -= self._pageFooterView!.frame.width
                }
                
                self._pageFooterView = newValue
                self._contentSize.width += self._pageFooterView!.frame.width
                self.setNeedsLayout()
            }
        }
    }
    
    var dataSource : UIPageViewDataSource?
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
                self._delegate = newValue as? UIPageViewDelegate
                super.delegate = self
            }
        }
    }
    
    var visibleCells : [UIPageViewCell]
    {
        get
        {
            var visibleCells = [UIPageViewCell]()
            
            for visibleIndexPath in self._visibleIndexPaths
            {
                let meta = self._getMeta(item: visibleIndexPath.item, section: visibleIndexPath.section)
                
                if (meta.type == UIMetaType.cell)
                {
                    visibleCells.append(meta._view_ as! UIPageViewCell)
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
    
    private var _scrollWidth : CGFloat
    {
        get
        {
            let _scrollWidth = self._contentSize.width + self.contentInset.left + self.contentInset.right
            
            return _scrollWidth
        }
    }
    
    private var _isScrollingModeEnabled : Bool
    {
        get
        {
            let _isScrollingModeEnabled = self.mode == UIPageViewMode.manualScrolling || self.mode == UIPageViewMode.autoScrolling
            
            return _isScrollingModeEnabled
        }
    }

    private var _leftItemMeta : UIMeta
    {
        get
        {
            let _leftItemMeta = self._getMeta(item: 0, section: 0)
            
            return _leftItemMeta
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
    
    private var _rightItemMeta : UIMeta
    {
        get
        {
            let _rightItemMeta = self._getMeta(item: 2, section: 0)
            
            return _rightItemMeta
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
    
    private var _transitionDirection : UIPageViewTransitionDirection
    {
        get
        {
            var _transitionDirection = UIPageViewTransitionDirection.none
            
            if (self.mode == UIPageViewMode.autoScrolling || self.mode == UIPageViewMode.sliding)
            {
                var transitionThreshold : CGFloat = 0
                
                if (self.mode == UIPageViewMode.autoScrolling)
                {
                    transitionThreshold = self._getScrollThresholdForCellAt(indexPath: self._focusItemIndexPath_)
                }
                else
                {
                    transitionThreshold = self.frame.width / 2
                }
                
                if (self._decelerationOffset!.x <= self._initialOffsetX)
                {
                    if (self._initialOffsetX - self._decelerationOffset!.x >= transitionThreshold)
                    {
                        _transitionDirection = UIPageViewTransitionDirection.reverse
                    }
                }
                else
                {
                    if (self._decelerationOffset!.x - self._initialOffsetX >= transitionThreshold)
                    {
                        _transitionDirection = UIPageViewTransitionDirection.forward
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
    
    private var _shouldLoadRightViews : Bool
    {
        get
        {
            var _shouldLoadRightViews = self._visibleIndexPaths.count > 0
            
            if (_shouldLoadRightViews)
            {
                let lastVisibleIndexPath = self._visibleIndexPaths.last!
                let lastVisibleMeta = self._getMeta(item: lastVisibleIndexPath.item, section: lastVisibleIndexPath.section)
                
                if (lastVisibleMeta._view_ != nil)
                {
                    let frame = CGRect(x: lastVisibleMeta._globalOffset_.x,
                                       y: lastVisibleMeta._globalOffset_.y,
                                       width: lastVisibleMeta.width,
                                       height: lastVisibleMeta.height)
                    _shouldLoadRightViews = self.frame.width - (frame.maxX - self.contentOffset.x) > 1
                }
            }
            
            return _shouldLoadRightViews
        }
    }
    
    private var _shouldLoadLeftViews : Bool
    {
        get
        {
            var _shouldLoadLeftViews = self._visibleIndexPaths.count > 0
            
            if (_shouldLoadLeftViews)
            {
                let firstVisibleIndexPath = self._visibleIndexPaths.first!
                let firstVisibleMeta = self._getMeta(item: firstVisibleIndexPath.item, section: firstVisibleIndexPath.section)
                
                if (firstVisibleMeta._view_ != nil)
                {
                    let frame = CGRect(x: firstVisibleMeta._globalOffset_.x,
                                       y: firstVisibleMeta._globalOffset_.y,
                                       width: firstVisibleMeta.width,
                                       height: firstVisibleMeta.height)
                    _shouldLoadLeftViews = frame.minX - self.contentOffset.x > 1
                }
            }
            
            return _shouldLoadLeftViews
        }
    }
    
    private var _shouldUnloadRightViews : Bool
    {
        get
        {
            var _shouldUnloadRightViews = self._visibleIndexPaths.count > 0 && !self._isAnimating

            if (_shouldUnloadRightViews)
            {
                let firstVisibleIndexPath = self._visibleIndexPaths.first!
                let firstVisibleMeta = self._getMeta(item: firstVisibleIndexPath.item, section: firstVisibleIndexPath.section)
                _shouldUnloadRightViews = self.contentOffset.x + firstVisibleMeta._globalOffset_.x > -1
            }

            if (_shouldUnloadRightViews)
            {
                let lastVisibleIndexPath = self._visibleIndexPaths.last!
                let lastVisibleMeta = self._getMeta(item: lastVisibleIndexPath.item, section: lastVisibleIndexPath.section)
                
                if (lastVisibleMeta._view_ != nil)
                {
                    let frame = CGRect(x: lastVisibleMeta._globalOffset_.x,
                                       y: lastVisibleMeta._globalOffset_.y,
                                       width: lastVisibleMeta.width,
                                       height: lastVisibleMeta.height)
                    _shouldUnloadRightViews = (frame.minX - self.contentOffset.x) - self.frame.width > -1
                }
            }
            
            return _shouldUnloadRightViews
        }
    }
    
    private var _shouldUnloadLeftViews : Bool
    {
        get
        {
            var _shouldUnloadLeftViews = self._visibleIndexPaths.count > 0 && !self._isAnimating

            if (_shouldUnloadLeftViews)
            {
                let lastVisibleIndexPath = self._visibleIndexPaths.last!
                let lastVisibleMeta = self._getMeta(item: lastVisibleIndexPath.item, section: lastVisibleIndexPath.section)
                _shouldUnloadLeftViews = (lastVisibleMeta._globalOffset_.x + lastVisibleMeta.width) - (self.contentOffset.x + self.frame.width) > -1
            }
            
            if (_shouldUnloadLeftViews)
            {
                let firstVisibleIndexPath = self._visibleIndexPaths.first!
                let firstVisibleMeta = self._getMeta(item: firstVisibleIndexPath.item, section: firstVisibleIndexPath.section)

                if (firstVisibleMeta._view_ != nil)
                {
                    let frame = CGRect(x: firstVisibleMeta._globalOffset_.x,
                                       y: firstVisibleMeta._globalOffset_.y,
                                       width: firstVisibleMeta.width,
                                       height: firstVisibleMeta.height)
                    _shouldUnloadLeftViews = self.contentOffset.x - frame.maxX > -1
                }
            }
            
            return _shouldUnloadLeftViews
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
    
    internal var _scrollingMetaGroups_ : [UIPageViewMetaGroup]
    {
        get
        {
            if (self._scrollingMetaGroups == nil)
            {
                self._scrollingMetaGroups = [UIPageViewMetaGroup]()
            }
            
            let _scrollingMetaGroups_ = self._scrollingMetaGroups!
            
            return _scrollingMetaGroups_
        }
        
        set(newValue)
        {
            self._scrollingMetaGroups = newValue
        }
    }
    
    internal var _slidingMetaGroup_ : UIPageViewMetaGroup
    {
        get
        {
            if (self._slidingMetaGroup == nil)
            {
                self._slidingMetaGroup = UIPageViewMetaGroup(section: 0,
                                                             initialOffset: 0,
                                                             height: self.frame.height,
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
                self._tapGestureRecognizer.addTarget(self, action: #selector(UIPageView._toggleCell(_:)))
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
            if (self._shouldReloadAtBuffer == true || ((self._contentSize.height - self.frame.height) > 1 && self._canLoadPartialViews))
            {
                self.reloadData()
            }
            
            self._loadScrollingViews()
            self._positionAfterReloadingAtBufferIfNeeded()
        }
        else
        {
            if ((self._contentSize.height - self.frame.height) > 1 && self._canLoadPartialViews)
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
            let metaGroupRect = CGRect(x: metaGroup.initialOffset, y: 0, width: metaGroup.width, height: metaGroup.height)
            
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
    
    func scrollToItem(at indexPath: IndexPath, at scrollPosition: UIPageViewScrollPosition, animated: Bool)
    {
        self._scrollToItem(at: indexPath, at: scrollPosition, allowsAnimation: animated, isGestureRecognized: false)
    }
    
    func slideToItem(at indexPath: IndexPath, from slideDirection: UIPageViewSlideDirection, animated: Bool)
    {
        self._slideToItem(at: indexPath, from: slideDirection, allowsAnimation: animated, isGestureRecognized: false)
    }
    
    func selectItem(at indexPath: IndexPath?, animated: Bool, scrollPosition: UIPageViewScrollPosition)
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
                            let cell = meta._view_ as! UIPageViewCell
                            cell.isSelected = false
                        }
                    }
                    
                    self._selectedIndexPaths = [IndexPath]()
                }
                
                let meta = self._getMeta(item: indexPath!.item, section: indexPath!.section)
                
                if (meta._view_ != nil)
                {
                    let cell = meta._view_ as! UIPageViewCell
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
                            let cell = meta._view_ as! UIPageViewCell
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
            if (self._previousOffsetX > self.contentOffset.x)
            {
                if (self.contentOffset.x < self.scrollBuffer)
                {
                    self._shouldReloadAtBuffer = self.dataSource!.pageViewShouldReloadAtLeadingBuffer?(self)
                }
            }
            else if (self._previousOffsetX < self.contentOffset.x)
            {
                if (self.contentOffset.x > (self._scrollWidth - self.frame.size.width) - self.scrollBuffer)
                {
                    self._shouldReloadAtBuffer = self.dataSource!.pageViewShouldReloadAtTrailingBuffer?(self)
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
        if (self.mode == UIPageViewMode.autoScrolling || self.mode == UIPageViewMode.sliding)
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
        if (self.mode == UIPageViewMode.autoScrolling || self.mode == UIPageViewMode.sliding)
        {
            if (self._visibleIndexPaths.count < 2)
            {
                return
            }
            
            if (self.mode == UIPageViewMode.sliding && self._contentIndexPathByItemIndexPath.count < 2)
            {
                return
            }
            
            let transitionDirection = self._transitionDirection
            
            if (transitionDirection == UIPageViewTransitionDirection.none)
            {
                if (self.mode == UIPageViewMode.autoScrolling)
                {
                    let currentIndexPath = self._focusItemIndexPath_
                    self._scrollToItem(at: currentIndexPath, at: self.scrollPosition, allowsAnimation: true, isGestureRecognized: true)
                }
                else
                {
                    if (self._contentIndexPathByItemIndexPath[self._centerItemIndexPath] != nil)
                    {
                        self._slideToItem(at: self._contentIndexPathByItemIndexPath[self._centerItemIndexPath]!,
                                          from: UIPageViewSlideDirection.forward,
                                          allowsAnimation: true,
                                          isGestureRecognized: true)
                    }
                }
            }
            else if (transitionDirection == UIPageViewTransitionDirection.reverse)
            {
                if (self.mode == UIPageViewMode.autoScrolling)
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
                    if (self._contentIndexPathByItemIndexPath[self._leftItemIndexPath] != nil)
                    {
                        self._slideToItem(at: self._contentIndexPathByItemIndexPath[self._leftItemIndexPath]!,
                                          from: UIPageViewSlideDirection.reverse,
                                          allowsAnimation: true,
                                          isGestureRecognized: true)
                    }
                }
            }
            else if (transitionDirection == UIPageViewTransitionDirection.forward)
            {
                if (self.mode == UIPageViewMode.autoScrolling)
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
                    if (self._contentIndexPathByItemIndexPath[self._rightItemIndexPath] != nil)
                    {
                        self._slideToItem(at: self._contentIndexPathByItemIndexPath[self._rightItemIndexPath]!,
                                          from: UIPageViewSlideDirection.forward,
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
        var animations = [UIPageViewAnimation]()
        
        for animation in self._animations
        {
            if (animation.state == UIPageViewAnimationState.possible || animation.state == UIPageViewAnimationState.began)
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
            
            if (self.contentOffset.x + self.frame.width > self._scrollWidth)
            {
                self.contentOffset.x = self._scrollWidth - self.frame.width
            }
            else if (self.contentOffset.x < 0)
            {
                self.contentOffset.x = 0
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
    
    func pageViewMetaGroup(_ pageViewMetaGroup: UIPageViewMetaGroup, didChangeWidthFrom oldWidth: CGFloat, to newWidth: CGFloat)
    {
        self._contentSize.width = self._contentSize.width - oldWidth + newWidth
    }
    
    private func _scrollToItem(at indexPath: IndexPath, at scrollPosition: UIPageViewScrollPosition, allowsAnimation: Bool, isGestureRecognized: Bool)
    {
        if (self._isScrollingModeEnabled)
        {
            let animation = UIPageViewAnimation(indexPath: indexPath,
                                                at: scrollPosition,
                                                allowsAnimation: allowsAnimation,
                                                isGestureRecognized: isGestureRecognized)
            self._animations.append(animation)
            self.setNeedsLayout()
        }
    }
    
    private func _slideToItem(at indexPath: IndexPath, from slideDirection: UIPageViewSlideDirection, allowsAnimation: Bool, isGestureRecognized: Bool)
    {
        if (self._mode == UIPageViewMode.sliding)
        {
            let animation = UIPageViewAnimation(indexPath: indexPath,
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
                if (animation.state == UIPageViewAnimationState.possible)
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
    
    private func _animateScrollingAnimation(_ animation: UIPageViewAnimation)
    {
        let numberOfItems = self.numberOfItems(inSection: animation.indexPath.section)
        let shouldAnimateScrollingView = animation.indexPath.item >= 0 && animation.indexPath.item < numberOfItems
        
        if (shouldAnimateScrollingView)
        {
            self._displayVisibleScrollingViewsIfNeeded(to: animation.indexPath)
            let meta = self._getMeta(item: animation.indexPath.item, section: animation.indexPath.section)
            
            var contentOffsetX = CGFloat(0)
            
            if (animation.scrollPosition == UIPageViewScrollPosition.none)
            {
                if (meta._globalOffset_.x < self.contentOffset.x)
                {
                    self._scrollToItem(at: animation.indexPath,
                                       at: UIPageViewScrollPosition.left,
                                       allowsAnimation: animation.allowsAnimation,
                                       isGestureRecognized: animation.isGestureRecognized)
                }
                else if (meta._globalOffset_.x + meta.width > self.contentOffset.x + self.frame.width)
                {
                    self._scrollToItem(at: animation.indexPath,
                                       at: UIPageViewScrollPosition.right,
                                       allowsAnimation: animation.allowsAnimation,
                                       isGestureRecognized: animation.isGestureRecognized)
                }
                
                animation.cancel()
                
                return
            }
            else if (animation.scrollPosition == UIPageViewScrollPosition.left)
            {
                contentOffsetX = meta._globalOffset_.x
                
                if (self.style == UIPageViewStyle.plain)
                {
                    let headerMeta = self._getMeta(item: -1, section: meta.section)
                    contentOffsetX -= headerMeta.width
                }
            }
            else if (animation.scrollPosition == UIPageViewScrollPosition.middle)
            {
                contentOffsetX = meta._globalOffset_.x - (self.frame.width / 2)
            }
            else if (animation.scrollPosition == UIPageViewScrollPosition.right)
            {
                contentOffsetX = meta._globalOffset_.x - (self.frame.width - meta.width)
                
                if (self.style == UIPageViewStyle.plain)
                {
                    let footerMeta = self._getMeta(item: self.numberOfItems(inSection: meta.section), section: meta.section)
                    contentOffsetX += footerMeta.width
                }
            }
            
            if (contentOffsetX + self.frame.width > self._contentSize.width)
            {
                contentOffsetX = self._contentSize.width - self.frame.width
            }
            else if (contentOffsetX < 0)
            {
                contentOffsetX = 0
            }
            
            if (self.mode == UIPageViewMode.autoScrolling)
            {
                self._initialOffsetX = contentOffsetX
                self._focusItemIndexPath_ = animation.indexPath
            }
            
            if (self._delegate != nil)
            {
                self._delegate!.pageView?(self, willScrollToItemAt: animation.indexPath, isAnimationEnabled: animation.allowsAnimation, isGestureRecognized: animation.isGestureRecognized)
            }
            
            if (animation.allowsAnimation)
            {
                UIView.animate(withDuration: self.scrollSpeed, animations:
                {
                    animation.begin()
                    self.contentOffset = CGPoint(x: contentOffsetX, y: 0)
                    
                    if (self.style == UIPageViewStyle.plain)
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
                        self._delegate!.pageView?(self, didScrollToItemAt: animation.indexPath, isAnimationEnabled: animation.allowsAnimation, isGestureRecognized: animation.isGestureRecognized)
                    }
                })
            }
            else
            {
                self.contentOffset = CGPoint(x: contentOffsetX, y: 0)
                animation.cancel()
                self._removeAnimationsIfNeeded()
                self._loadScrollingViews()
                
                if (self._delegate != nil)
                {
                    self._delegate!.pageView?(self, didScrollToItemAt: animation.indexPath, isAnimationEnabled: animation.allowsAnimation, isGestureRecognized: animation.isGestureRecognized)
                }
            }
        }
        else
        {
            animation.cancel()
            self._removeAnimationsIfNeeded()
            
            fatalError("UIPageView: indexPath is out of bounds")
        }
    }
    
    private func _animateSlidingAnimation(_ animation: UIPageViewAnimation)
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
            
            var contentOffsetX : CGFloat! = nil
            
            if (animation.indexPath == self._contentIndexPathByItemIndexPath[self._centerItemIndexPath])
            {
                contentOffsetX = self._centerItemMeta._globalOffset_.x
                self._focusItemIndexPath_ = self._centerItemIndexPath
            }
            else if (animation.indexPath == self._contentIndexPathByItemIndexPath[self._leftItemIndexPath])
            {
                contentOffsetX = self._leftItemMeta._globalOffset_.x
                self._focusItemIndexPath_ = self._leftItemIndexPath
            }
            else if (animation.indexPath == self._contentIndexPathByItemIndexPath[self._rightItemIndexPath])
            {
                contentOffsetX = self._rightItemMeta._globalOffset_.x
                self._focusItemIndexPath_ = self._rightItemIndexPath
            }
            else
            {
                self._displayVisibleSlidingViewIfNeeded(at: animation.indexPath, for: animation.slideDirection)
                
                if (animation.slideDirection == UIPageViewSlideDirection.reverse)
                {
                    contentOffsetX = self._leftItemMeta._globalOffset_.x
                    self._focusItemIndexPath_ = self._leftItemIndexPath
                }
                else
                {
                    contentOffsetX = self._rightItemMeta._globalOffset_.x
                    self._focusItemIndexPath_ = self._rightItemIndexPath
                }
            }
            
            if (self.mode == UIPageViewMode.sliding)
            {
                self._initialOffsetX = contentOffsetX
            }
            
            if (self._delegate != nil)
            {
                self._delegate!.pageView?(self, willSlideToItemAt: animation.indexPath, isAnimationEnabled: animation.allowsAnimation, isGestureRecognized: animation.isGestureRecognized)
            }
            
            if (animation.allowsAnimation)
            {
                UIView.animate(withDuration: self.scrollSpeed, animations:
                {
                    animation.begin()
                    self.contentOffset = CGPoint(x: contentOffsetX, y: 0)
                }, completion:
                { (isCompleted) in
                    
                    animation.end()
                    self.scrollViewDidEndScrollingAnimation(self)
                    
                    if (self._delegate != nil)
                    {
                        self._delegate!.pageView?(self, didSlideToItemAt: animation.indexPath, isAnimationEnabled: animation.allowsAnimation, isGestureRecognized: animation.isGestureRecognized)
                    }
                })
            }
            else
            {
                self.contentOffset = CGPoint(x: contentOffsetX, y: 0)
                animation.cancel()
                self._removeAnimationsIfNeeded()
                self._loadSlidingViews()
                
                if (self._delegate != nil)
                {
                    self._delegate!.pageView?(self, didSlideToItemAt: animation.indexPath, isAnimationEnabled: animation.allowsAnimation, isGestureRecognized: animation.isGestureRecognized)
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
        if (self._pageHeaderView != nil)
        {
            self._pageHeaderView!.frame.origin.x = 0
            
            if (self._pageHeaderView!.superview == nil)
            {
                self.addSubview(self._pageHeaderView!)
            }
            
            for visibleIndexPath in self._visibleIndexPaths
            {
                let meta = self._getMeta(item: visibleIndexPath.item, section: visibleIndexPath.section)
                
                if (meta._view_ != nil)
                {
                    meta._view_!.frame.origin.x = meta._globalOffset_.x
                }
            }
        }
    }
    
    private func _loadFooterViewIfNeeded()
    {
        if (self._pageFooterView != nil)
        {
            if (self._pageFooterView!.superview == nil)
            {
                self.addSubview(self._pageFooterView!)
            }
            
            self._pageFooterView!.frame.origin.x = self._contentSize.width - self._pageFooterView!.frame.width
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
                    headerMeta._view_!.frame.origin.x = headerMeta._globalOffset_.x
                }
                
                self._focusSectionHeaderIndexPath = nil
            }
            
            let focusSection = self._visibleIndexPaths.first!.section
            let headerMeta = self._getMeta(item: -1, section: focusSection)
            let footerMeta = self._getMeta(item: self.numberOfItems(inSection: focusSection), section: focusSection)
            
            var headerOriginX = self.contentOffset.x
            
            var minimumOffsetX = headerMeta._globalOffset_.x
            
            if (self._pageHeaderView != nil)
            {
                minimumOffsetX += self._pageHeaderView!.frame.width
            }
            
            if (headerOriginX < minimumOffsetX)
            {
                headerOriginX = minimumOffsetX
            }
            
            if (headerMeta.width + headerOriginX > footerMeta._globalOffset_.x)
            {
                headerOriginX = footerMeta._globalOffset_.x - headerMeta.width
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
            
            headerMeta._view_!.frame.origin.x = headerOriginX
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
                    footerMeta._view_!.frame.origin.x = footerMeta._globalOffset_.x
                }
                
                self._focusSectionFooterIndexPath = nil
            }
            
            let focusSection = self._visibleIndexPaths.last!.section
            let headerMeta = self._getMeta(item: -1, section: focusSection)
            let footerMeta = self._getMeta(item: self.numberOfItems(inSection: focusSection), section: focusSection)
            
            var footerOriginX = self.contentOffset.x + self.frame.width - footerMeta.width
            
            if (footerOriginX > footerMeta._globalOffset_.x)
            {
                footerOriginX = footerMeta._globalOffset_.x
            }
            
            if (footerOriginX < headerMeta._globalOffset_.x + headerMeta.width)
            {
                footerOriginX = headerMeta._globalOffset_.x + headerMeta.width
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
            
            footerMeta._view_!.frame.origin.x = footerOriginX
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
                    if (self.contentOffset.x < self.scrollBuffer)
                    {
                        self.contentOffset.x += (self._contentSize.width - self.contentSize.width)
                        
                        if (self._mode == UIPageViewMode.autoScrolling)
                        {
                            self._autoScrollingItemIndexPath = self.indexPathForItem(at: self.contentOffset)
                            self._autoScrollingItemIndexPath!.item -= 1
                        }
                    }
                    else
                    {
                        if (self._mode == UIPageViewMode.autoScrolling)
                        {
                            self._autoScrollingItemIndexPath = self.indexPathForItem(at: self.contentOffset)
                            self._autoScrollingItemIndexPath!.item += 1
                        }
                    }
                    
                    if (self._mode == UIPageViewMode.autoScrolling)
                    {
                        self._initialOffsetX = self.contentOffset.x
                    }
                }
                
                self._shouldReloadAtBuffer = nil
            }
        }
    }
    
    private func _anchorViewsIfNeeded()
    {
        if (self.anchorPosition != UIPageViewScrollPosition.none)
        {
            if (self._scrollWidth < self.frame.width)
            {
                self.isScrollEnabled = false
                
                if (self.anchorPosition == UIPageViewScrollPosition.right)
                {
                    self.contentOffset.x = self._scrollWidth - self.frame.width
                }
                else if (self.anchorPosition == UIPageViewScrollPosition.middle)
                {
                    self.contentOffset.x = (self._scrollWidth - self.frame.width) / 2
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
            scrollThreshold = self._delegate!.pageView?(self, scrollThresholdForItemAt: indexPath)
        }
        
        if (scrollThreshold == nil)
        {
            scrollThreshold = self.scrollThreshold
        }
        
        return scrollThreshold
    }
    
    private func _getEstimatedSectionHeaderWidthAt(section: Int) -> CGFloat
    {
        var estimatedSectionHeaderWidth : CGFloat! = nil
        
        if (self._delegate != nil)
        {
            estimatedSectionHeaderWidth = self._delegate!.pageView?(self, estimatedWidthForHeaderInSection: section)
        }
        
        if (estimatedSectionHeaderWidth == nil)
        {
            estimatedSectionHeaderWidth = self.estimatedSectionHeaderWidth
        }
        
        if (estimatedSectionHeaderWidth == UIPageViewAutomaticDimension)
        {
            if (self.style == UIPageViewStyle.plain)
            {
                estimatedSectionHeaderWidth = 100
            }
            else if (self.style == UIPageViewStyle.grouped)
            {
                estimatedSectionHeaderWidth = 120
            }
        }
        
        return estimatedSectionHeaderWidth
    }
    
    private func _getEstimatedItemSizeAt(indexPath: IndexPath) -> CGSize
    {
        var estimatedItemSize : CGSize! = nil
        
        if (self._delegate != nil)
        {
            estimatedItemSize = self._delegate!.pageView?(self, estimatedSizeForItemAt: indexPath)
        }
        
        if (estimatedItemSize == nil)
        {
            estimatedItemSize = self.estimatedItemSize
        }
        
        if (estimatedItemSize.width == UIPageViewAutomaticDimension)
        {
            estimatedItemSize.width = 100
        }
        
        if (estimatedItemSize.height == UIPageViewAutomaticDimension)
        {
            estimatedItemSize.height = self.frame.height
        }
        
        return estimatedItemSize
    }
    
    private func _getEstimatedSectionFooterWidthAt(section: Int) -> CGFloat
    {
        var estimatedSectionFooterWidth : CGFloat! = nil
        
        if (self._delegate != nil)
        {
            estimatedSectionFooterWidth = self._delegate!.pageView?(self, estimatedWidthForFooterInSection: section)
        }
        
        if (estimatedSectionFooterWidth == nil)
        {
            estimatedSectionFooterWidth = self.estimatedSectionFooterWidth
        }
        
        if (estimatedSectionFooterWidth == UIPageViewAutomaticDimension)
        {
            if (self.style == UIPageViewStyle.plain)
            {
                estimatedSectionFooterWidth = 100
            }
            else if (self.style == UIPageViewStyle.grouped)
            {
                estimatedSectionFooterWidth = 100
            }
        }
        
        return estimatedSectionFooterWidth
    }
    
    private func _getSectionHeaderWidthAt(section: Int) -> CGFloat
    {
        var sectionHeaderWidth : CGFloat! = nil
        
        if (self._delegate != nil)
        {
            sectionHeaderWidth = self._delegate!.pageView?(self, widthForHeaderInSection: section)
        }
        
        if (sectionHeaderWidth == nil)
        {
            sectionHeaderWidth = self.sectionHeaderWidth
        }
        
        if (sectionHeaderWidth == UIPageViewAutomaticDimension)
        {
            if (self.style == UIPageViewStyle.plain)
            {
                sectionHeaderWidth = 100
            }
            else if (self.style == UIPageViewStyle.grouped)
            {
                sectionHeaderWidth = 120
            }
        }
        
        return sectionHeaderWidth
    }
    
    private func _getItemSizeAt(indexPath: IndexPath) -> CGSize
    {
        var itemSize : CGSize! = nil
        
        if (self._delegate != nil)
        {
            itemSize = self._delegate!.pageView?(self, sizeForItemAt: indexPath)
        }
        
        if (itemSize == nil)
        {
            itemSize = self.itemSize
        }
        
        if (itemSize.width == UIPageViewAutomaticDimension)
        {
            itemSize.width = 100
        }
        
        if (itemSize.height == UIPageViewAutomaticDimension)
        {
            itemSize.height = self.frame.height
        }
        
        return itemSize
    }
    
    private func _getSectionFooterWidthAt(section: Int) -> CGFloat
    {
        var sectionFooterWidth : CGFloat! = nil
        
        if (self._delegate != nil)
        {
            sectionFooterWidth = self._delegate!.pageView?(self, widthForFooterInSection: section)
        }
        
        if (sectionFooterWidth == nil)
        {
            sectionFooterWidth = self.sectionFooterWidth
        }
        
        if (sectionFooterWidth == UIPageViewAutomaticDimension)
        {
            if (self.style == UIPageViewStyle.plain)
            {
                sectionFooterWidth = 100
            }
            else if (self.style == UIPageViewStyle.grouped)
            {
                sectionFooterWidth = 100
            }
        }
        
        return sectionFooterWidth
    }
    
    private func _getContentView(text: String?, type: UIMetaType) -> UIPageViewHeaderFooterContentView
    {
        var title = text
        var font = UIFont.boldSystemFont(ofSize: 17)
        var textColor = UIColor(red: 115/255, green: 115/255, blue: 120/255, alpha: 1)
        
        if (self.style == UIPageViewStyle.plain)
        {
            textColor = UIColor.black
        }
        
        if (type == UIMetaType.header)
        {
            if (self.style == UIPageViewStyle.grouped)
            {
                title = text?.uppercased()
                font = UIFont.systemFont(ofSize: 16)
            }
        }
        else if (type == UIMetaType.footer)
        {
            if (self.style == UIPageViewStyle.grouped)
            {
                font = UIFont.systemFont(ofSize: 15)
            }
        }
        
        let contentView = UIPageViewHeaderFooterContentView()
        contentView.label.font = font
        contentView.label.textColor = textColor
        contentView.label.text = title
        
        if (self.style == UIPageViewStyle.plain)
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
    
    private func _displayCellViewForColumnIfNeeded(at indexPath: IndexPath) -> Bool
    {
        var shouldDisplayCellView = false
        let meta = self._getMeta(item: indexPath.item, section: indexPath.section)
        
        if (meta._view_ == nil)
        {
            if (meta.type == UIMetaType.cell)
            {
                self._displayScrollingView(at: indexPath)
                
                if (meta._view_!.frame.origin.x + meta._view_!.frame.width  < self.contentOffset.x || meta._view_!.frame.origin.x > self.contentOffset.x + self.frame.width)
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
        
        if (meta._globalOffset_.y + meta.height < self.frame.height)
        {
            if (indexPath.item + 1 <= self.numberOfItems(inSection: indexPath.section) - 1)
            {
                for item in indexPath.item + 1...self.numberOfItems(inSection: indexPath.section) - 1
                {
                    let nextIndexPath = IndexPath(item: item, section: indexPath.section)
                    
                    if (self._displayCellViewForColumnIfNeeded(at: nextIndexPath))
                    {
                        self._visibleIndexPaths.append(nextIndexPath)
                        
                        let nextMeta = self._getMeta(item: nextIndexPath.item, section: nextIndexPath.section)
                        
                        if (nextMeta._globalOffset_.y + nextMeta.height == self.frame.height)
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
        
        if (meta._globalOffset_.y > 0)
        {
            if (indexPath.item - 1 >= 0)
            {
                for item in (0...indexPath.item - 1).reversed()
                {
                    let previousIndexPath = IndexPath(item: item, section: indexPath.section)
                    
                    if (self._displayCellViewForColumnIfNeeded(at: previousIndexPath))
                    {
                        self._visibleIndexPaths.insert(previousIndexPath, at: 0)
                        
                        let previousMeta = self._getMeta(item: previousIndexPath.item, section: previousIndexPath.section)
                        
                        if (previousMeta._globalOffset_.y == 0)
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
                    headerView = self._delegate!.pageView?(self, viewForHeaderInSection: meta.section)
                }
                
                if (headerView == nil)
                {
                    let title = self.dataSource!.pageView?(self, titleForHeaderInSection: meta.section)
                    
                    if (title != nil || self.style == UIPageViewStyle.plain)
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
                        self._delegate!.pageView?(self, willDisplayHeaderView: headerView!, forSection: indexPath.section)
                    }
                    
                    self.addSubview(headerView!)
                }
            }
            else if (meta.type == UIMetaType.footer)
            {
                var footerView : UIView? = nil
                
                if (self._delegate != nil)
                {
                    footerView = self._delegate!.pageView?(self, viewForFooterInSection: meta.section)
                }
                
                if (footerView == nil)
                {
                    let title = self.dataSource!.pageView?(self, titleForFooterInSection: meta.section)
                    
                    if (title != nil || self.style == UIPageViewStyle.plain)
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
                        self._delegate!.pageView?(self, willDisplayFooterView: footerView!, forSection: indexPath.section)
                    }
                    
                    self.addSubview(footerView!)
                }
            }
            else
            {
                let cell = self.dataSource!.pageView(self, cellForItemAt: indexPath)
                meta._view_ = cell
                self._assertSize(at: indexPath)
                self._setViewFrameIfNeeded(at: indexPath)
                
                if (self._delegate != nil)
                {
                    self._delegate!.pageView?(self, willDisplay: cell, forItemAt: indexPath)
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
            let cell = self.dataSource!.pageView(self, cellForItemAt: contentIndexPath)
            meta._view_ = cell
            self._setViewFrameIfNeeded(at: metaIndexPath)
            
            if (self._delegate != nil)
            {
                self._delegate!.pageView?(self, willDisplay: cell, forItemAt: contentIndexPath)
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
                    self._delegate!.pageView?(self, didEndDisplayingHeaderView: meta._view_!, forSection: meta.section)
                }
                else if (meta.type == UIMetaType.footer)
                {
                    self._delegate!.pageView?(self, didEndDisplayingFooterView: meta._view_!, forSection: meta.section)
                }
                else
                {
                    let cell = meta._view_ as! UIPageViewCell
                    self._delegate!.pageView?(self, didEndDisplaying: cell, forItemAt: indexPath)
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
                let cell = meta._view_ as! UIPageViewCell
                
                self._delegate!.pageView?(self,
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
        
        var shiftingDirection = UIPageViewTransitionDirection.reverse
        
        if (indexPath.item > self._focusItemIndexPath_.item)
        {
            shiftingDirection = UIPageViewTransitionDirection.forward
        }
        
        if (self._visibleIndexPaths.count > 0)
        {
            var visibleIndexPaths : [IndexPath]! = nil
            
            if (shiftingDirection == UIPageViewTransitionDirection.reverse)
            {
                visibleIndexPaths = self._visibleIndexPaths
            }
            else if (shiftingDirection == UIPageViewTransitionDirection.forward)
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
        
        if (shiftingDirection == UIPageViewTransitionDirection.reverse)
        {
            self._visibleIndexPaths = newIndexPaths
        }
        else if (shiftingDirection == UIPageViewTransitionDirection.forward)
        {
            self._visibleIndexPaths = newIndexPaths.reversed()
        }
        
        self._focusItemIndexPath_ = indexPath
        self._initialOffsetX = self._focusItemMeta._globalOffset_.x
        self.setContentOffset(self._focusItemMeta._globalOffset_, animated: false)
    }
    
    private func _displayVisibleSlidingViewIfNeeded(at contentIndexPath: IndexPath, for direction: UIPageViewSlideDirection)
    {
        if (self._visibleIndexPaths.count >= 1)
        {
            var metaIndexPath : IndexPath? = nil
            
            if (direction == UIPageViewSlideDirection.reverse)
            {
                if (self._visibleIndexPaths.first != self._leftItemIndexPath)
                {
                    metaIndexPath = self._leftItemIndexPath
                    self._visibleIndexPaths.insert(metaIndexPath!, at: 0)
                }
            }
            else if (direction == UIPageViewSlideDirection.forward)
            {
                if (self._visibleIndexPaths.last != self._rightItemIndexPath)
                {
                    metaIndexPath = self._rightItemIndexPath
                    self._visibleIndexPaths.append(metaIndexPath!)
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
            
            if (self._pageHeaderView != nil)
            {
                meta._globalOffset_.x += self._pageHeaderView!.frame.width
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
            currentOffset += metaGroup.width
        }
    }
    
    private func _setInitialOffsetIfNeeded(at section: Int)
    {
        if (self._modifiedScrollingMetaGroup != nil)
        {
            if (section > self._modifiedScrollingMetaGroup!.section)
            {
                let initialOffset = self._modifiedScrollingMetaGroup!.initialOffset + self._modifiedScrollingMetaGroup!.width
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
        var size = CGSize(width: 0, height: self.frame.height)
        
        if (meta.type == UIMetaType.header)
        {
            size.width = self._getSectionHeaderWidthAt(section: indexPath.section)
        }
        else if (meta.type == UIMetaType.footer)
        {
            size.width = self._getSectionFooterWidthAt(section: indexPath.section)
        }
        else
        {
            size = self._getItemSizeAt(indexPath: indexPath)
        }
        
        if (meta.type == UIMetaType.header || meta.type == UIMetaType.footer)
        {
            if (meta._view_ != nil &&
                meta._view_ is UIPageViewHeaderFooterContentView &&
                self.numberOfSections == 1)
            {
                let view = meta._view_ as! UIPageViewHeaderFooterContentView
                
                if (view.label.text == nil || view.label.text == "")
                {
                    size.width = 0
                }
            }
        }
        
        if (meta.width != size.width || meta.height != size.height)
        {
            let metaGroup = self._scrollingMetaGroups_[indexPath.section]
            
            if (meta.width != size.width)
            {
                meta.width = size.width
            }
            
            if (meta.height != size.height)
            {
                meta.height = size.height
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
        
        self._contentSize.height = self.frame.height
        self._loadFooterViewIfNeeded()
        
        if (self.style == UIPageViewStyle.plain)
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
        
        self._contentSize.height = self.frame.height
    }
    
    private func _unloadScrollingViews()
    {
        for visibleIndexPath in self._visibleIndexPaths
        {
            self._endDisplayScrollingView(at: visibleIndexPath)
        }
        
        self._initialOffsetX = 0
        self._previousOffsetX = 0
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
        
        self._initialOffsetX = 0
        self._previousOffsetX = 0
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
                if (self.contentOffset.x < 0)
                {
                    self.contentOffset.x = 0
                }
                
                let lastContentOffset = self.contentOffset
                
                for metaGroup in self._scrollingMetaGroups_
                {
                    let initialMeta = self._getMeta(item: -1, section: metaGroup.section)
                    
                    if (initialMeta._globalOffset_.x <= lastContentOffset.x + self.frame.width)
                    {
                        let indexPath = IndexPath(item: initialMeta.item, section: initialMeta.section)
                        self._displayScrollingView(at: indexPath)
                        self._visibleIndexPaths.append(indexPath)
                    }
                    
                    self._loadRightViewsIfNeeded()
                }
                
                self.setContentOffset(lastContentOffset, animated: false)
                self._previousOffsetX = lastContentOffset.x
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
                if (self.contentOffset.x < 0)
                {
                    self.contentOffset.x = 0
                }
                
                var contentIndexPath = self.dataSource!.pageView?(self, initializeAt: self._leftItemIndexPath)
                
                if (contentIndexPath == nil)
                {
                    contentIndexPath = self._leftItemIndexPath
                }
                
                self._contentIndexPathByItemIndexPath[self._centerItemIndexPath] = contentIndexPath
                self._setFocusItemToMeta(at: self._centerItemIndexPath)
                self._previousOffsetX = self._focusItemMeta._globalOffset_.x
            }
            
            self._canLoadPartialViews = true
        }
    }
    
    private func _loadScrollingMetaGroupsIfNeeded()
    {
        if (self._scrollingMetaGroups_.count == 0)
        {
            var numberOfSections = self.dataSource?.numberOfPageSections?(in: self)
            
            if (numberOfSections != 0)
            {
                if (numberOfSections == nil)
                {
                    numberOfSections = 1
                }
                
                self._contentSize.width = 0
                
                for section in 0...numberOfSections! - 1
                {
                    let metaGroup = UIPageViewMetaGroup(section: section,
                                                        initialOffset: self._contentSize.width,
                                                        height: self.frame.height,
                                                        delegate: self)
                    self._scrollingMetaGroups_.append(metaGroup)
                    
                    let estimatedSectionHeaderWidth = self._getEstimatedSectionHeaderWidthAt(section: section)
                    metaGroup.headerMeta.width = estimatedSectionHeaderWidth
                    metaGroup.headerMeta.height = self.frame.height
                    
                    let estimatedSectionFooterWidth = self._getEstimatedSectionFooterWidthAt(section: section)
                    metaGroup.footerMeta.width = estimatedSectionFooterWidth
                    metaGroup.footerMeta.height = self.frame.height
                    
                    let numberOfItems = self.dataSource?.pageView(self, numberOfItemsInSection: section)
                    
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
                
                if (self._pageHeaderView != nil)
                {
                    self._contentSize.width += self._pageHeaderView!.frame.width
                }
                
                if (self._pageFooterView != nil)
                {
                    self._contentSize.width += self._pageFooterView!.frame.width
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
    
    private func _loadRightViewsIfNeeded()
    {
        while (self._shouldLoadRightViews)
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
                    nextIndexPath = self.dataSource!.pageView?(self, indexPathAfter: contentIndexPath!)
                }
                
                if (nextIndexPath != nil)
                {
                    if (self._focusItemIndexPath_ != self._centerItemIndexPath)
                    {
                        self._setFocusItemToMeta(at: self._centerItemIndexPath)
                    }
                    
                    self._displayVisibleSlidingViewIfNeeded(at: nextIndexPath!, for: UIPageViewSlideDirection.forward)
                }
                else
                {
                    if (self._focusItemIndexPath_ != self._rightItemIndexPath)
                    {
                        self._setFocusItemToMeta(at: self._rightItemIndexPath)
                    }
                }
                
                break
            }
        }
    }
    
    private func _loadLeftViewsIfNeeded()
    {
        while (self._shouldLoadLeftViews)
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
                    previousIndexPath = self.dataSource!.pageView?(self, indexPathBefore: contentIndexPath!)
                }
                
                if (previousIndexPath != nil)
                {
                    if (self._focusItemIndexPath_ != self._centerItemIndexPath)
                    {
                        self._setFocusItemToMeta(at: self._centerItemIndexPath)
                    }
                    
                    self._displayVisibleSlidingViewIfNeeded(at: previousIndexPath!, for: UIPageViewSlideDirection.reverse)
                }
                else
                {
                    if (self._focusItemIndexPath_ != self._leftItemIndexPath)
                    {
                        self._setFocusItemToMeta(at: self._leftItemIndexPath)
                    }
                }
                
                break
            }
        }
    }
    
    private func _unloadRightViewsIfNeeded()
    {
        while (self._shouldUnloadRightViews)
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
    
    private func _unloadLeftViewsIfNeeded()
    {
        while (self._shouldUnloadLeftViews)
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
            if (self.contentOffset.x < self._previousOffsetX)
            {
                if (self._previousOffsetX - self.contentOffset.x < self.frame.width)
                {
                    self._unloadRightViewsIfNeeded()
                    self._loadLeftViewsIfNeeded()
                }
                else
                {
                    self._loadLeftViewsIfNeeded()
                    self.setNeedsLayout()
                }
            }
            else if (self.contentOffset.x > self._previousOffsetX)
            {
                if (self.contentOffset.x - self._previousOffsetX < self.frame.width)
                {
                    self._unloadLeftViewsIfNeeded()
                    self._loadRightViewsIfNeeded()
                }
                else
                {
                    self._loadRightViewsIfNeeded()
                    self.setNeedsLayout()
                }
            }
            else
            {
                self._unloadRightViewsIfNeeded()
                self._loadLeftViewsIfNeeded()
                self._unloadLeftViewsIfNeeded()
                self._loadRightViewsIfNeeded()
            }
            
            self._previousOffsetX = self.contentOffset.x
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
                        let cell = meta._view_ as! UIPageViewCell
                        
                        if ((sender.location(in: cell).x >= 0 && sender.location(in: cell).x < cell.frame.width) &&
                            (sender.location(in: cell).y >= 0 && sender.location(in: cell).y < cell.frame.height))
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
            selectedIndexPath = self._delegate!.pageView?(self, willSelectItemAt: indexPath)
        }
        
        if (selectedIndexPath != nil)
        {
            let meta = self._getMeta(item: indexPath.item, section: indexPath.section)
            
            if (meta._view_ != nil)
            {
                let cell = meta._view_ as! UIPageViewCell
                cell.isSelected = true
            }
            
            self._selectedIndexPaths.append(indexPath)
            
            if (self._delegate != nil)
            {
                self._delegate!.pageView?(self, didSelectItemAt: selectedIndexPath!)
            }
        }
    }
    
    private func _deselectCell(at indexPath: IndexPath)
    {
        var deselectedIndexPath : IndexPath? = nil
        
        if (self._delegate != nil)
        {
            deselectedIndexPath = self._delegate!.pageView?(self, willDeselectItemAt: indexPath)
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
                        let cell = meta._view_ as! UIPageViewCell
                        cell.isSelected = false
                    }
                    
                    self._selectedIndexPaths.remove(at: counter)
                    break
                }
            }
            
            if (self._delegate != nil)
            {
                self._delegate!.pageView?(self, didDeselectItemAt: deselectedIndexPath!)
            }
        }
    }
}
