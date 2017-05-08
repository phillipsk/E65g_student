
import UIKit

@available(iOS 10.0, *)
class InstrumentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var rowsStepper: UIStepper!
    @IBOutlet weak var rowTextField: UITextField!
    
    @IBOutlet weak var colsTextField: UITextField!
    @IBOutlet weak var colsStepper: UIStepper!
    
    @IBOutlet weak var refreshRateSlider: UISlider!
    
    @IBOutlet weak var timedRefreshSwitch: UISwitch!
    
    @IBOutlet weak var configurationTableView: UITableView!
    
    var timerInterval: TimeInterval = 0.0 {
        didSet {
            StandardEngine.sharedEngine.refreshTimer?.invalidate()
            
            StandardEngine.sharedEngine.refreshTimer =
                Timer.scheduledTimer(
                withTimeInterval: timerInterval,
                repeats: true
            ) { (t: Timer) in
                if (self.timedRefreshSwitch.isOn) {
                    StandardEngine.sharedEngine.next()
                    StandardEngine.sharedEngine.sendUpdate()
                }
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rows = StandardEngine.sharedEngine.rows
        let cols = StandardEngine.sharedEngine.cols
        
        rowTextField.text = String(rows)
        colsTextField.text = String(cols)
        
        rowsStepper.value = Double(rows)
        colsStepper.value = Double(cols)
        
        let nc = NotificationCenter.default
        
        let configurationUpdate = Notification.Name(rawValue: "ConfigurationsUpdate")
        nc.addObserver(forName: configurationUpdate, object: nil, queue: nil) {(n) in
            OperationQueue.main.addOperation {
                self.configurationTableView.reloadData()
            }
        }
        
        let engineUpdate = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(forName: engineUpdate, object: nil, queue: nil) {(n) in
            OperationQueue.main.addOperation {
                let updatedRows = StandardEngine.sharedEngine.rows
                let updatedCols = StandardEngine.sharedEngine.cols
                self.rowTextField.text = String(updatedRows)
                self.colsTextField.text = String(updatedCols)
                self.rowsStepper.value = Double(updatedRows)
                self.colsStepper.value = Double(updatedCols)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateStandardEngineGrid() {
        StandardEngine.sharedEngine.grid = Grid(
            StandardEngine.sharedEngine.rows,
            StandardEngine.sharedEngine.cols
        )
        StandardEngine.sharedEngine.sendUpdate()
    }
    
    //MARK: TableView DataSource and Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Configurations.sharedConfigurations.configurations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "basic"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        label.text = Configurations.sharedConfigurations.configurations[indexPath.row]["title"] as? String
        
        return cell
    }
    
    @IBAction func onAddRow(_ sender: Any) {
        let blankContents = [[Int]]()
        let blankConfiguration = NSMutableDictionary()
        
        blankConfiguration["title"] = "New Row"
        blankConfiguration["contents"] = blankContents
        
        Configurations.sharedConfigurations.addConfiguration(blankConfiguration as NSDictionary)
        configurationTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = configurationTableView.indexPathForSelectedRow
        if let indexPath = indexPath {
            let configuration = Configurations.sharedConfigurations.configurations[indexPath.row]
            if let vc = segue.destination as? ConfigurationViewController {
                vc.configuration = configuration
                vc.saveClosure = { newValue in
                    Configurations.sharedConfigurations.configurations[indexPath.row] = newValue
                    
                    let updatedRows = StandardEngine.sharedEngine.rows
                    let updatedCols = StandardEngine.sharedEngine.cols
                    
                    self.rowsStepper.value = Double(updatedRows)
                    self.colsStepper.value = Double(updatedCols)
                    
                    self.rowTextField.text = String(updatedRows)
                    self.colsTextField.text = String(updatedCols)
                    
                    self.configurationTableView.reloadData()
                    self.rowsStepper.setNeedsDisplay()
                    self.colsStepper.setNeedsDisplay()
                    self.rowTextField.setNeedsDisplay()
                    self.colsTextField.setNeedsDisplay()
                }
            }
        }
    }
    
    @IBAction func refreshRateSliderValueChange(_ sender: UISlider) {
        timerInterval = TimeInterval(1 / sender.value)
    }

    @IBAction func rowsStepperStep(_ sender: UIStepper) {
        StandardEngine.sharedEngine.rows = Int(sender.value)
        rowTextField.text = String(StandardEngine.sharedEngine.rows)
        updateStandardEngineGrid()
    }
    
    @IBAction func colsStepperStep(_ sender: UIStepper) {
        StandardEngine.sharedEngine.cols = Int(sender.value)
        colsTextField.text = String(StandardEngine.sharedEngine.cols)
        updateStandardEngineGrid()
    }
    
    func rowsTextFieldIsDone(_ sender: UITextField) {
        guard let updatedValue = Int(sender.text!), updatedValue >= 0 else {
            rowTextField.text = String(StandardEngine.sharedEngine.rows)
            sender.resignFirstResponder()
            return
        }
        
        StandardEngine.sharedEngine.rows = updatedValue
        rowsStepper.value = Double(updatedValue)
        updateStandardEngineGrid()
        sender.resignFirstResponder()
    }
    
    func colsTextFieldIsDone(_ sender: UITextField) {
        guard let updatedValue = Int(sender.text!), updatedValue >= 0 else {
            rowTextField.text = String(StandardEngine.sharedEngine.cols)
            sender.resignFirstResponder()
            return
        }
        
        StandardEngine.sharedEngine.cols = updatedValue
        colsStepper.value = Double(updatedValue)
        updateStandardEngineGrid()
        sender.resignFirstResponder()
    }
    
    @IBAction func rowsTextFieldDone(_ sender: UITextField) {
        rowsTextFieldIsDone(sender);
    }
    

    @IBAction func rowsTextFieldDidEnd(_ sender: UITextField) {
        rowsTextFieldIsDone(sender);
    }
    
    
    @IBAction func colsTextFieldDidEnd(_ sender: UITextField) {
        colsTextFieldIsDone(sender)
        
    }
    
    @IBAction func colsTextFieldDone(_ sender: UITextField) {
        colsTextFieldIsDone(sender)
    }
    
}

