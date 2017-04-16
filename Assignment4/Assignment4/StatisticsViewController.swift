

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var aliveCount: UILabel!
    @IBOutlet weak var deadCount: UILabel!
    @IBOutlet weak var bornCount: UILabel!
    @IBOutlet weak var emptyCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) {(n) in
            self.setLabels()
        }
        
        self.setLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setLabels() {
        var aliveCount = 0
        var deadCount = 0
        var bornCount = 0
        var emptyCount = 0
        
        let grid = StandardEngine.sharedEngine.grid
        
        (0 ..< StandardEngine.sharedEngine.rows)
        .forEach {i in
            (0 ..< StandardEngine.sharedEngine.cols)
            .forEach {ii in
                switch grid[i, ii] {
                case .alive:
                    aliveCount += 1
                    break
                case .died:
                    deadCount += 1
                    break
                case .born:
                    bornCount += 1
                    break
                case .empty:
                    emptyCount += 1
                    break
                }
            }
        }
        
        self.aliveCount.text = String(aliveCount)
        self.deadCount.text = String(deadCount)
        self.bornCount.text = String(bornCount)
        self.emptyCount.text = String(emptyCount)
        
        self.aliveCount.setNeedsDisplay()
        self.deadCount.setNeedsDisplay()
        self.bornCount.setNeedsDisplay()
        self.emptyCount.setNeedsDisplay()
    }
}
