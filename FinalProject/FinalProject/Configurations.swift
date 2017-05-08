
import Foundation

let finalProjectURL = "https://dl.dropboxusercontent.com/u/7544475/S65g.json"

public class Configurations {
    static let sharedConfigurations = Configurations()
    
    static func contentsToGrid(_ contents: [[Int]]) -> Grid {
        var maxSize: Int = 5
        contents.forEach {gridPosition in
            let row = gridPosition[0]
            let col = gridPosition[1]
            if max(row, col) > maxSize {
                maxSize = max(row, col)
            }
        }
        
        maxSize = maxSize * 2
        
        var grid = Grid(maxSize, maxSize)
        contents.forEach {gridPosition in
            let row = gridPosition[0]
            let col = gridPosition[1]
            grid[row, col] = .alive
        }
        
        return grid
    }
    
    static func gridToContents(_ grid: Grid) -> [[Int]] {
        var contents = [[Int]]()
        
        let gridSize = grid.size
        (0 ..< gridSize.rows)
        .forEach {row in
            (0 ..< gridSize.cols)
            .forEach { col in
                let gridCell = grid[row, col]
                if (gridCell.isAlive) {
                    contents.append([row, col])
                }
            }
        }
        
        return contents
    }
    
    public var configurations = [NSDictionary]()
    
    private init() {}
    
    public func addConfiguration(_ newConfiguration: NSDictionary) {
        configurations.append(newConfiguration)
        sendUpdate()
    }
    
    private func sendUpdate() {
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "ConfigurationsUpdate")
        let n = Notification(name: name, object: nil, userInfo: ["configurations" : self])
        nc.post(n)
    }
    
    public func initialfetchConfigurations() {
        let fetcher = Fetcher()
        fetcher.fetchJSON(url: URL(string:finalProjectURL)!) { (json: Any?, message: String?) in
            guard message == nil else {
                print(message ?? "nil")
                return
            }
            guard let json = json else {
                print("no json")
                return
            }
            
            let newConfigurations = json as! [NSDictionary]
            self.configurations += newConfigurations
            self.sendUpdate()
        }
    }
}


