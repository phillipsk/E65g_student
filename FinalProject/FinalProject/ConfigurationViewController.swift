

import UIKit

class ConfigurationViewController: UIViewController, GridViewDataSource {
    
    @IBOutlet weak var configurationTextView: UITextField!
    @IBOutlet weak var configurationGridView: GridView!
    
    var grid: Grid?
    var configuration: NSDictionary?
    var saveClosure: ((NSDictionary) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        configurationGridView.gridDataSource = self
        
        if self.configuration != nil {
            configurationTextView.text = configuration!["title"] as? String
            let configurationContents = configuration!["contents"] as! [[Int]]
            self.grid = Configurations.contentsToGrid(configurationContents)
            configurationGridView.gridSize = self.grid!.size
        }
    }
    
    public subscript (row: Int, col: Int) -> CellState {
        get { return self.grid![row,col] }
        set { self.grid?[row,col] = newValue }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func onSave(_ sender: Any) {
        if let saveClosure = saveClosure {
            let newValue = configurationTextView.text! as String
            let updatedContents = Configurations.gridToContents(self.grid!)
            let updatedConfiguration = NSMutableDictionary()
            
            updatedConfiguration["title"] = newValue
            updatedConfiguration["contents"] = updatedContents
            
            StandardEngine.sharedEngine.updateGrid(grid!)
            
            saveClosure(updatedConfiguration as NSDictionary)
            self.navigationController!.popViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
