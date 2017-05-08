

import Foundation


public protocol EngineDelegate {
    func engineDidUpdate(withGrid: GridProtocol)
}

public protocol EngineProtocol {
    var delegate: EngineDelegate? { get }
    var grid: GridProtocol { get }
    var refreshRate: Double { get set }
    var refreshTimer: Timer? { get set }
    var rows: Int { get set }
    var cols: Int { get set }
    func next() -> Void
}


public class StandardEngine: EngineProtocol {
    static let sharedEngine = StandardEngine(10, 10)
    
    public var delegate: EngineDelegate?
    public var grid: GridProtocol
    
    public var refreshRate: Double = 0.0
    public var refreshTimer: Timer?
    public var rows: Int
    public var cols: Int
    
    public init(_ rows: Int, _ cols: Int) {
        self.grid = Grid(rows, cols)
        self.rows = rows
        self.cols = cols
    }
    
    public func reset() {
        updateGrid(Grid(10, 10))
    }
    
    public func updateGrid(_ updatedGrid: GridProtocol) {
        self.rows = updatedGrid.size.rows
        self.cols = updatedGrid.size.cols
        self.grid = updatedGrid
        sendUpdate()
    }
    
    public func sendUpdate() {
        delegate?.engineDidUpdate(withGrid: grid)
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        let n = Notification(name: name, object: nil, userInfo: ["engine" : self])
        nc.post(n)
    }
    
    public func next() {
        grid = grid.next()
    }
}
