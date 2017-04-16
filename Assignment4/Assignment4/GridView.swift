

import UIKit

@IBDesignable class GridView: UIView {

    @IBInspectable var livingColor = UIColor.green
    @IBInspectable var emptyColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
    @IBInspectable var bornColor = UIColor.gray
    @IBInspectable var diedColor = UIColor.red
    @IBInspectable var gridColor = UIColor.brown
    @IBInspectable var gridWidth: CGFloat = 2.0
    
    private var lastTouchedPosition: GridPosition?
    
    override func draw(_ rect: CGRect) {
        drawRectangle(rect)
    }
    
    func drawRectangle(_ rectangle: CGRect) {
        let rectangleSize = StandardEngine.sharedEngine.grid.size
        
        let size = CGSize(
            width: rectangle.size.width / CGFloat(rectangleSize.rows),
            height: rectangle.size.height / CGFloat(rectangleSize.cols)
        )
        
        let base = rectangle.origin
        (0 ..< rectangleSize.rows).forEach { i in
            (0 ..< rectangleSize.cols).forEach { ii in
                let origin = CGPoint(
                    x: base.x + (CGFloat(i) * size.width),
                    y: base.y + (CGFloat(ii) * size.height)
                )
                
                let subRect = CGRect(
                    origin: origin,
                    size: size
                )
                
                var fillColor: UIColor
                
                switch StandardEngine.sharedEngine.grid[(i, ii)] {
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

        (0 ... rectangleSize.rows).forEach {
            drawLine(
                start: CGPoint(x: CGFloat($0)/CGFloat(rectangleSize.rows) * rectangle.size.width, y: 0.0),
                end:   CGPoint(x: CGFloat($0)/CGFloat(rectangleSize.rows) * rectangle.size.width, y: rectangle.size.height)
            )
        }
        
        (0 ... rectangleSize.cols).forEach {
            drawLine(
                start: CGPoint(x: 0.0, y: CGFloat($0)/CGFloat(rectangleSize.cols) * rectangle.size.height ),
                end: CGPoint(x: rectangle.size.width, y: CGFloat($0)/CGFloat(rectangleSize.cols) * rectangle.size.height)
            )
        }
    }
    
    func drawLine(start:CGPoint, end: CGPoint) {
        let path = UIBezierPath()
        path.lineWidth = self.gridWidth
        path.move(to: start)
        path.addLine(to: end)
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
        
        let cellValue = StandardEngine.sharedEngine.grid[(pos.row, pos.col)]
        StandardEngine.sharedEngine.grid[(pos.row, pos.col)] = cellValue.toggle(value: cellValue)
        
        setNeedsDisplay()
        return pos
    }
    
    func convert(touch: UITouch) -> GridPosition {
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let row = touchX / gridWidth * CGFloat(StandardEngine.sharedEngine.grid.size.rows)
        
        let touchY = touch.location(in: self).y
        let gridHeight = frame.size.height
        let col = touchY / gridHeight * CGFloat(StandardEngine.sharedEngine.grid.size.cols)
        
        return GridPosition(row: Int(row), col: Int(col))
    }

}
