//
//  Assignment3
//
//  Received help from Andrea Salkey.
//  Created by Kevin Phillips on 3/26/17.

import UIKit

@IBDesignable class GridView: UIView {
    
    @IBInspectable var size: Int = 20 {
        didSet {
            grid = Grid(size,size)
        }
    }
    
    var grid = Grid(20, 20)
    
    @IBInspectable var livingColor = UIColor.black
    @IBInspectable var emptyColor = UIColor.green
    @IBInspectable var bornColor = UIColor.red
    @IBInspectable var gridColor = UIColor.blue
    @IBInspectable var diedColor = UIColor.yellow
    
    @IBInspectable var gridWidth = CGFloat(2.0)
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation. */
    
    override func draw(_ rect: CGRect) {
        let gsize = CGSize(
            width: rect.size.width / CGFloat(self.size),
            height: rect.size.height / CGFloat(self.size)
        )
        
        let base = rect.origin
        
        /*circles*/
        (0 ..< self.size).forEach { i in
            (0 ..< self.size).forEach { j in
                let origin = CGPoint(
                    x: base.x + (CGFloat(j) * gsize.width),
                    y: base.y + (CGFloat(i) * gsize.height)
                )
                let subRect = CGRect(
                    origin: origin,
                    size: gsize
                )
                
                let path = UIBezierPath(ovalIn: subRect)
                
                switch grid[(i, j)] {
                case .alive:
                    livingColor.setFill()
                case .empty:
                    emptyColor.setFill()
                case .born:
                    bornColor.setFill()
                case .died:
                    diedColor.setFill()
                }
                
                path.fill()
            }
        }
        
        /*lines*/
        (0 ..< self.size + 1).forEach {
            drawLine(
                start: CGPoint(x: CGFloat($0)/CGFloat(self.size) * rect.size.width, y: 0.0),
                end:   CGPoint(x: CGFloat($0)/CGFloat(self.size) * rect.size.width, y: rect.size.height)
            )
            
            drawLine(
                start: CGPoint(x: 0.0, y: CGFloat($0)/CGFloat(self.size) * rect.size.height ),
                end: CGPoint(x: rect.size.width, y: CGFloat($0)/CGFloat(self.size) * rect.size.height)
            )
        }
    }
    
    func drawLine(start:CGPoint, end: CGPoint) {
        let path = UIBezierPath()
        
        path.lineWidth = gridWidth
        
        path.move(to: start)
        
        path.addLine(to: end)
        
        gridColor.setStroke()
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
    
    typealias Position = (row: Int, col: Int)
    var lastTouchedPosition: Position?
    
    func process(touches: Set<UITouch>) -> Position? {
        guard touches.count == 1 else { return nil }
        let pos = convert(touch: touches.first!)
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        
        grid[pos] = grid[pos].toggle(value: grid[pos])
        setNeedsDisplay()
        return pos
    }
    
    func convert(touch: UITouch) -> Position {
        let touchY = touch.location(in: self).y
        let gridHeight = frame.size.height
        let row = touchY / gridHeight * CGFloat(self.size)
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let col = touchX / gridWidth * CGFloat(self.size)
        let position = (row: Int(row), col: Int(col))
        return position
    }
    
    func next(){
        grid = grid.next()
        setNeedsDisplay()
    }
}
