import UIKit

class DynamicCanvas : NSObject
{
    private var _numberOfColumns : CGFloat = 10
    private var _numberOfRows : CGFloat = 10
    private var _size = CGSize.zero
    
    override init()
    {
        self._size = UIScreen.main.bounds.size
        
        super.init()
    }
    
    init(size: CGSize)
    {
        self._size = size
    }
    
    var size : CGSize
    {
        get
        {
            let size = self._size
            
            return size
        }
    }
    
    var numberOfHorizontalTiles : CGFloat
    {
        get
        {
            return self.size.height / self._tileLength
        }
    }
    
    var numberOfVerticalTiles : CGFloat
    {
        get
        {
            return self.size.width / self._tileLength
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
            return self.size.width / self._numberOfColumns
        }
    }
    
    private var _rowLength : CGFloat
    {
        get
        {
            return self.size.height / self._numberOfRows
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
    
    func render(style: DynamicCanvas.Style, in view: UIView)
    {
        let canvasView = DynamicCanvas.View()
        
        for subview in view.subviews
        {
            if (subview is DynamicCanvas.View)
            {
                subview.removeFromSuperview()
            }
        }
        
        canvasView.frame.size = self.size
        
        if (style == DynamicCanvas.Style.titles)
        {
            canvasView.renderTiles(numberOfVerticalTiles: Int(self.numberOfVerticalTiles),
                                         numberOfHorizontalTiles: Int(self.numberOfHorizontalTiles),
                                         canvas: self)
        }
        else
        {
            canvasView.renderColumnsAndRows(numberOfColumns: Int(self._numberOfColumns),
                                                  numberOfRows: Int(self._numberOfRows),
                                                  canvas: self)
        }
        
        view.insertSubview(canvasView, at: 0)
    }
    
    enum Style
    {
        case titles
        case columnsAndRows
    }
    
    private class View : UIView
    {
        func renderTiles(numberOfVerticalTiles: Int, numberOfHorizontalTiles: Int, canvas: DynamicCanvas)
        {
            for counter in 0...numberOfVerticalTiles
            {
                let tiles = CGFloat(counter)
                let verticalLine = UIView(frame: CGRect(x: canvas.draw(tiles: tiles), y: 0, width: 1, height: self.frame.height))
                verticalLine.backgroundColor = UIColor.orange
                self.addSubview(verticalLine)
            }
            
            for counter in 0...numberOfVerticalTiles - 1
            {
                let tiles = CGFloat(counter)
                let numberLabel = UILabel(frame: CGRect(x: canvas.draw(tiles: tiles), y: 0, width: canvas.draw(tiles: 1), height: canvas.draw(tiles: 1)))
                numberLabel.text = String(counter)
                numberLabel.textColor = UIColor.orange
                numberLabel.font = UIFont.italicSystemFont(ofSize: canvas.draw(tiles: 0.5))
                numberLabel.textAlignment = NSTextAlignment.center
                self.addSubview(numberLabel)
            }
            
            for counter in 0...numberOfHorizontalTiles
            {
                let tiles = CGFloat(counter)
                let horizontalLine = UIView(frame: CGRect(x: 0, y: canvas.draw(tiles: tiles), width: self.frame.width, height: 1))
                horizontalLine.backgroundColor = UIColor.orange
                self.addSubview(horizontalLine)
            }
            
            for counter in 0...numberOfHorizontalTiles - 1
            {
                let tiles = CGFloat(counter)
                let numberLabel = UILabel(frame: CGRect(x: 0, y: canvas.draw(tiles: tiles), width: canvas.draw(tiles: 1), height: canvas.draw(tiles: 1)))
                numberLabel.text = String(counter)
                numberLabel.textColor = UIColor.orange
                numberLabel.font = UIFont.italicSystemFont(ofSize: canvas.draw(tiles: 0.5))
                numberLabel.textAlignment = NSTextAlignment.center
                self.addSubview(numberLabel)
            }
        }
        
        func renderColumnsAndRows(numberOfColumns: Int, numberOfRows: Int, canvas: DynamicCanvas)
        {
            for counter in 0...numberOfColumns
            {
                let columns = CGFloat(counter)
                let verticalLine = UIView(frame: CGRect(x: canvas.draw(columns: columns), y: 0, width: 1, height: self.frame.height))
                verticalLine.backgroundColor = UIColor.orange
                self.addSubview(verticalLine)
            }
            
            for counter in 0...numberOfColumns - 1
            {
                let columns = CGFloat(counter)
                let numberLabel = UILabel(frame: CGRect(x: canvas.draw(columns: columns), y: 0, width: canvas.draw(columns: 1), height: canvas.draw(rows: 1)))
                numberLabel.text = String(counter)
                numberLabel.textColor = UIColor.orange
                numberLabel.font = UIFont.italicSystemFont(ofSize: canvas.draw(tiles: 0.5))
                numberLabel.textAlignment = NSTextAlignment.center
                self.addSubview(numberLabel)
            }
            
            for counter in 0...numberOfRows
            {
                let rows = CGFloat(counter)
                let horizontalLine = UIView(frame: CGRect(x: 0, y: canvas.draw(rows: rows), width: self.frame.width, height: 1))
                horizontalLine.backgroundColor = UIColor.orange
                self.addSubview(horizontalLine)
            }
            
            for counter in 0...numberOfRows - 1
            {
                let rows = CGFloat(counter)
                let numberLabel = UILabel(frame: CGRect(x: 0, y: canvas.draw(rows: rows), width: canvas.draw(columns: 1), height: canvas.draw(rows: 1)))
                numberLabel.text = String(counter)
                numberLabel.textColor = UIColor.orange
                numberLabel.font = UIFont.italicSystemFont(ofSize: canvas.draw(tiles: 0.5))
                numberLabel.textAlignment = NSTextAlignment.center
                self.addSubview(numberLabel)
            }
        }
    }
}
