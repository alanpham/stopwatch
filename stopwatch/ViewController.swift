import UIKit

class ViewController: UIViewController {

    //MARK: Color constants
    let dayBackgroundColor = UIColor(red: 241/255.0, green: 207/255.0, blue: 99/255.0, alpha: 1.0)
    let nightBackgroundColor = UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0)
    let nightTimerColor = UIColor(red: 241/255.0, green: 207/255.0, blue: 99/255.0, alpha: 1.0)
    let dayTimerColor = UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0)

    //MARK: Properties
    @IBOutlet weak var timerLabel: Timer!
    @IBOutlet weak var clockFace: ClockFace!

    var settings : UserSettings!
    
    //MARK: Actions
    @IBAction func timerAction(sender: UITapGestureRecognizer) {
        timerLabel.startOrStop()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setColors()
        settings = UserSettings()
        timerLabel.clockFace = clockFace
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if (motion == .MotionShake && !timerLabel.timer.valid){
            if(!settings.hasResetted){
                confirmReset()
            }else {
                timerLabel.reset()
            }
        }
    }
    
    func setColors() {
        let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        let isDay = hour < 20 && hour > 8
        self.view.backgroundColor = isDay ? dayBackgroundColor : nightBackgroundColor
        timerLabel.textColor = isDay ? dayTimerColor : nightTimerColor
    }

    func confirmReset() {
        let confirmDialog = UIAlertController(title: "Reset", message: "Do you want to reset the timer?", preferredStyle: .Alert)
        confirmDialog.addAction(UIAlertAction(title: "Reset", style: .Default, handler: { action in
            self.settings.hasResetted = true
            self.timerLabel.reset()
            }
        ))
        confirmDialog.addAction(UIAlertAction(title: "Do nothing", style: .Cancel, handler: nil))
        presentViewController(confirmDialog, animated: true, completion: nil)
    }
}


