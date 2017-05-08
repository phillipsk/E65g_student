

import UIKit

public protocol GridViewDataSource {
    subscript (row: Int, col: Int) -> CellState { get set }
}


@IBDesignable class GridView: UIView {

    @IBInspectable var livingColor = UIColor.green
    @IBInspectable var emptyColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
    @IBInspectable var bornColor = UIColor.lightGray
    @IBInspectable var diedColor = UIColor.red
    @IBInspectable var gridColor = UIColor.black
    @IBInspectable var gridWidth: CGFloat = 2.0
    
    private var lastTouchedPosition: GridPosition?
    
    public var gridDataSource: GridViewDataSource?
    public var gridSize: GridSize?
    
    override func draw(_ rect: CGRect) {
        drawRectangle(rect)
    }
    
    func drawRectangle(_ rect: CGRect) {
        guard let rectSize = gridSize else { return }
        guard let grid = gridDataSource else { return }
        
        let size = CGSize(
            width: rect.size.width / CGFloat(rectSize.rows),
            height: rect.size.height / CGFloat(rectSize.cols)
        )
        
        // fill in the circles
        let base = rect.origin
        (0 ..< rectSize.rows).forEach { i in
            (0 ..< rectSize.cols).forEach { j in
                let origin = CGPoint(
                    x: base.x + (CGFloat(i) * size.width),
                    y: base.y + (CGFloat(j) * size.height)
                )
                
                let subRect = CGRect(
                    origin: origin,
                    size: size
                )
                
                var fillColor: UIColor
                
                switch grid[(i, j)] {
                case .alive: fillColor = self.livingColor
                case .born: fillColor = self.bornColor
                case .died: fillColor = self.diedColor
                case .empty: fillColor = self.emptyColor
                }
                
                let path = UIBezierPath(ovalIn: subRect)
                fillColor.setFill()
                path.fill()
            }
        }

        //create the grid
        (0 ... rectSize.rows).forEach {
            drawLine(
                start: CGPoint(x: CGFloat($0)/CGFloat(rectSize.rows) * rect.size.width, y: 0.0),
                end:   CGPoint(x: CGFloat($0)/CGFloat(rectSize.rows) * rect.size.width, y: rect.size.height)
            )
        }
        
        (0 ... rectSize.cols).forEach {
            drawLine(
                start: CGPoint(x: 0.0, y: CGFloat($0)/CGFloat(rectSize.cols) * rect.size.height ),
                end: CGPoint(x: rect.size.width, y: CGFloat($0)/CGFloat(rectSize.cols) * rect.size.height)
            )
        }
    }
    
    func drawLine(start:CGPoint, end: CGPoint) {
        let path = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        path.lineWidth = self.gridWidth
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        path.move(to: start)
        
        //add a point to the path at the end of the stroke
        path.addLine(to: end)
        
        //draw the stroke
        self.gridColor.setStroke()
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = nil
    }
    
    func process(touches: Set<UITouch>) -> GridPosition? {
        guard touches.count == 1 else { return nil }
        
        let touchY = touches.first!.location(in: self).y
        let touchX = touches.first!.location(in: self).x
        guard touchX > 0 && touchX < frame.size.width else { return nil }
        guard touchY > 0 && touchY < frame.size.height else { return nil }
        
        let pos = convert(touch: touches.first!)
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        
        if (gridDataSource != nil) {
            let cellValue = gridDataSource![(pos.row, pos.col)]
            gridDataSource![(pos.row, pos.col)] = cellValue.toggle(value: cellValue)
            setNeedsDisplay()
        }
        
        
        
        return pos
    }
    
    func convert(touch: UITouch) -> GridPosition {
        guard let rectSize = gridSize else { return (0, 0) }
        
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let row = touchX / gridWidth * CGFloat(rectSize.rows)
        
        let touchY = touch.location(in: self).y
        let gridHeight = frame.size.height
        let col = touchY / gridHeight * CGFloat(rectSize.cols)
        
        return GridPosition(row: Int(row), col: Int(col))
    }

}
