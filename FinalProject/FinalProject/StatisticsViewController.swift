

import UIKit

class StatisticsViewController: UIViewController {
    
    
    @IBOutlet weak var aliveCountLabel: UILabel!
    @IBOutlet weak var deadCountLabel: UILabel!
    @IBOutlet weak var bornCountLabel: UILabel!
    @IBOutlet weak var emptyCountLabel: UILabel!

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
            .forEach {j in
                switch grid[i, j] {
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
        
        self.aliveCountLabel.text = String(aliveCount)
        self.deadCountLabel.text = String(deadCount)
        self.bornCountLabel.text = String(bornCount)
        self.emptyCountLabel.text = String(emptyCount)
        
        self.aliveCountLabel.setNeedsDisplay()
        self.deadCountLabel.setNeedsDisplay()
        self.bornCountLabel.setNeedsDisplay()
        self.emptyCountLabel.setNeedsDisplay()
    }
}
