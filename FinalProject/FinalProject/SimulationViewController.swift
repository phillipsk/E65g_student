
import UIKit

class SimulationViewController: UIViewController, EngineDelegate, GridViewDataSource {

    @IBOutlet weak var gridView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StandardEngine.sharedEngine.delegate = self
        gridView.gridDataSource = self
        gridView.gridSize = GridSize(
            StandardEngine.sharedEngine.rows,
            StandardEngine.sharedEngine.cols
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func step(_ sender: UIButton) {
        StandardEngine.sharedEngine.next()
        gridView.setNeedsDisplay()
    }
    
    @IBAction func onReset(_ sender: Any) {
        StandardEngine.sharedEngine.reset()
    }
    
    @IBAction func onSave(_ sender: Any) {
        let alert = UIAlertController(title: "What do you want to save this grid as?", message: "Enter name:", preferredStyle: .alert)
        
        let saveAlertAction = UIAlertAction(title: "Save", style: .default) {_ in
            let gridNameTextField = alert.textFields![0] as UITextField
            
            let contents = Configurations.gridToContents(StandardEngine.sharedEngine.grid as! Grid)
            let configuration = NSMutableDictionary()
            
            configuration["title"] = gridNameTextField.text
            configuration["contents"] = contents
            
            Configurations.sharedConfigurations.addConfiguration(configuration as NSDictionary)
            
            let defaults = UserDefaults.standard
            defaults.set(configuration, forKey: "lastSavedConfiguration")
        }
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(saveAlertAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil));
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public subscript (row: Int, col: Int) -> CellState {
        get { return StandardEngine.sharedEngine.grid[row,col] }
        set { StandardEngine.sharedEngine.grid[row,col] = newValue }
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        gridView.gridSize = GridSize(
            StandardEngine.sharedEngine.rows,
            StandardEngine.sharedEngine.cols
        )
        gridView.setNeedsDisplay()
    }
}

