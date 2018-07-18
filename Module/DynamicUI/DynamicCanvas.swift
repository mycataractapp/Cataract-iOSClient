import UIKit

class DynamicCanvas : NSObject
{
    private var _isRendered = false
    private var _numberOfColumns : CGFloat = 12
    private var _numberOfRows : CGFloat = 12
    private var _canvasView : DynamicCanvasView!
    private weak var _gridView : UIView!
    
    init(view: UIView)
    {
        self._gridView = view
            
        super.init()
    }
    
    var screenSize : CGSize
    {
        get
        {
            let screenSize = UIScreen.main.bounds.size
            
            return screenSize
        }
    }
    
    var gridSize : CGSize
    {
        get
        {
            var gridSize : CGSize! = nil
            
            if (self._gridView != nil)
            {
                gridSize = self._gridView.frame.size
            }
            
            if (gridSize == CGSize.zero)
            {
                gridSize = self.screenSize
            }
            
            return gridSize!
        }
    }
    
    var numberOfHorizontalTiles : CGFloat
    {
        get
        {
            return self.gridSize.height / self._tileLength
        }
    }
    
    var numberOfVerticalTiles : CGFloat
    {
        get
        {
            return self.gridSize.width / self._tileLength
        }
    }
        
    private var _tileLength : CGFloat
    {
        get
        {
            return 25
        }
    }
    
    private var _columnLength : CGFloat
    {
        get
        {
            return self.gridSize.width / self._numberOfColumns
        }
    }
    
    private var _rowLength : CGFloat
    {
        get
        {
            return self.gridSize.height / self._numberOfRows
        }
    }
    
    func draw(tiles: CGFloat) -> CGFloat
    {
        return self._tileLength * tiles
    }
    
    func draw(columns: CGFloat) -> CGFloat
    {
        return self._columnLength * columns
    }
    
    func draw(rows: CGFloat) -> CGFloat
    {
        return self._rowLength * rows
    }
        
    func renderTiles()
    {
        if (self._isRendered)
        {
            self._canvasView = DynamicCanvasView()
            
            for subview in self._gridView!.subviews
            {
                if (subview is DynamicCanvasView)
                {
                    subview.removeFromSuperview()
                }
            }
        }
        
        self._canvasView.frame.size = self.gridSize
        self._canvasView.renderTiles(numberOfVerticalTiles: Int(self.numberOfVerticalTiles),
                                     numberOfHorizontalTiles: Int(self.numberOfHorizontalTiles),
                                     canvas: self)
        self._gridView!.insertSubview(self._canvasView, at: 0)
        self._isRendered = true
    }
    
    func renderColumnsAndRows()
    {
        if (self._isRendered)
        {
            self._canvasView = DynamicCanvasView()
            
            for subview in self._gridView!.subviews
            {
                if (subview is DynamicCanvasView)
                {
                    subview.removeFromSuperview()
                }
            }
        }
        
        self._canvasView.frame.size = self.gridSize
        self._canvasView.renderColumnsAndRows(numberOfColumns: Int(self._numberOfColumns),
                                              numberOfRows: Int(self._numberOfRows),
                                              canvas: self)
        self._gridView!.insertSubview(self._canvasView, at: 0)
        self._isRendered = true
    }
}
