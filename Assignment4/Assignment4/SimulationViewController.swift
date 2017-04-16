

import UIKit

class SimulationViewController: UIViewController, EngineDelegate {

    @IBOutlet weak var gridView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StandardEngine.sharedEngine.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func step(_ sender: UIButton) {
        StandardEngine.sharedEngine.next()
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        gridView.setNeedsDisplay()
    }
}

