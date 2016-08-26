import UIKit

class TimerViewController: UIViewController {

    //MARK: Properties
    let pulse = Pulse ()
    let shakeView = ShakeableView()
    let clockFace = ClockFace()
    let buttonAreaHeight = 132
    let smallTitle = 67
    let bigTitle = 86
    
    @IBOutlet weak var timer: TimerView!
	@IBOutlet weak var historyButton: UIButton!
	@IBOutlet weak var historyHintView: UIView!
	@IBOutlet weak var historyHintArrow: UIImageView!
	@IBOutlet weak var historyHintCircles: UIImageView!
	
	var shakeTimer: NSTimer?
	
	var pulseTimer: NSTimer?

    var settings : UserSettings!
	
	var delegate: TimerDelegate?
    
    var isEnjoyingDialog: UIView!
    var askRatingDialog: UIView!
    var askFeedbackDialog: UIView!
    
    //MARK: Actions
    @IBAction func timerAction(sender: UITapGestureRecognizer) {
        if(timer.isRunning()) {
			if pulseTimer != nil {
				pulseTimer?.invalidate()
				pulseTimer = nil
			}
            timer.stop()
            settings.hasStopped = true
            pulse.hide()
            if (!settings.hasReset) {
               shakeTimer = NSTimer.schedule(delay: 1, handler: { timer in self.shakeView.show()})
            }
        } else {
			if shakeTimer != nil {
				shakeTimer?.invalidate()
				shakeTimer = nil
			}
			timer.secondaryClockFaces = (delegate?.getSecondaryClockFaces())!
			timer.secondaryLabels = (delegate?.getSecondaryLabels())!
			timer.prettySecondaryLabels = (delegate?.getPrettySecondaryLabels())!
            shakeView.hide()
            timer.start()
			delegate?.timerStarted()
            settings.hasStarted = true
            pulse.hide()
            if(!settings.hasStopped){
                pulseTimer = NSTimer.schedule(delay: 5, handler: { timer in
                    if !self.timer.isRunning() {
                        return
                    }
                    self.pulse.show()
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(timer)
        clockFace.center = ClockFace.clockHandLocation(view, clockFaceView: clockFace)
        view.addSubview(clockFace)
        settings = UserSettings()

        timer.clockFace = clockFace
        shakeView.center = CGPoint (x: view.center.x - shakeView.bounds.size.width, y: view.center.y + 90)
        pulse.center = CGPoint (x: view.center.x, y: view.center.y + 90)
        shakeView.hide()

        view.addSubview(shakeView)
        view.addSubview(pulse)

        if !settings.hasStarted {
            NSTimer.schedule(delay: 0.5, handler: { timer in
                if self.timer.isRunning() {
                    return
                }
                self.pulse.show()
            })
        }
		
		historyButton.setImage(AppDelegate.instance.colorScheme.historyButton, forState: .Normal)
		historyHintArrow.image = AppDelegate.instance.colorScheme.historyHintArrow
		historyHintCircles.image = AppDelegate.instance.colorScheme.historyHintCircles
		
		refreshHistoryHint()
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		becomeFirstResponder()
        
        setupDialog()
	}
	
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if (motion == .MotionShake && !timer.timer.valid && abs(timer.interval) > 0){
            reset()
            
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(rateApp), userInfo: nil, repeats: false)
        }
    }
	
	func refreshHistoryHint() {
		if historyHintView.hidden && settings.showHistoryHint {
			historyHintView.hidden = false
			historyHintView.alpha = 0
			historyButton.hidden = false
			historyButton.alpha = 0
			UIView.animateWithDuration(0.5) {
				self.historyHintView.alpha = 1
				self.historyButton.alpha = 1
			}
		} else {
			historyHintView.hidden = settings.showHistoryHint == false
		}
	}
	
	func reset() {
		if (!settings.hasReset){
			confirmReset()
		} else {
			refreshHistoryHint()
			delegate?.timerReset()
			Datastore.instance.saveTimer(timer.startTime, duration: abs(timer.interval))
			delegate?.timerSaved()
			timer.reset()
		}
	}

    func meetRatingCriteria() -> Bool{
        
        if(settings.hasAskedFeedback){
            return false
        }
        
        settings.updateUsageDay()
        
        let timers = Datastore.instance.fetchTimers()
        if(timers.count >= 10 && settings.usageDay >= 3){
            return true
        }else{
            return false
        }
    }
    
    func confirmReset() {
        let confirmDialog = UIAlertController(title: "Reset", message: "Do you want to reset the timer?", preferredStyle: .Alert)
        confirmDialog.addAction(UIAlertAction(title: "Reset", style: .Default, handler: { action in
			self.delegate?.timerReset()
			self.settings.showHistoryHint = true
			self.refreshHistoryHint()
			Datastore.instance.saveTimer(self.timer.startTime, duration: abs(self.timer.interval))
			self.delegate?.timerSaved()
            self.settings.hasReset = true
            self.shakeView.hide()
            self.timer.reset()
            }
        ))
        confirmDialog.addAction(UIAlertAction(title: "Do nothing", style: .Cancel, handler: nil))
        presentViewController(confirmDialog, animated: true, completion: nil)
    }
	
	@IBAction func showHistory() {
		delegate?.showHistory()
	}
    
    func setupDialog(){
        isEnjoyingDialog = createDialog(
            "Enjoying Stopwatch?", titleHeight: smallTitle,
            yesString: "Yes!", yesCallback: #selector(self.enjoyYesClick),
            noString: "Not really", noCallbalk: #selector(self.enjoyNoClick)
        )
        
        askRatingDialog = createDialog(
            "Would you mind taking a moment\nto rate it in the App Store?", titleHeight: bigTitle,
            yesString: "Ok, sure", yesCallback: #selector(self.ratingYesClick),
            noString: "No, thanks", noCallbalk: #selector(self.ratingNoClick)
        )

        let feedbackTitleHeight = AppDelegate.isIPhone5orLower() ? bigTitle : smallTitle
        askFeedbackDialog = createDialog(
            "Would you mind giving us some feedback?", titleHeight: feedbackTitleHeight,
            yesString: "Ok, sure", yesCallback: #selector(self.feedbackYesClick),
            noString: "No, thanks", noCallbalk: #selector(self.feedbackNoClick)
        )
    }
    
    func rateApp() {
        
        //if(!meetRatingCriteria()) return
        
        settings.hasAskedFeedback = true
        toggleDialog(isEnjoyingDialog, isHiding: false)
    }

    
    func enjoyYesClick(){
        toggleDialog(askRatingDialog, isHiding: false)
        toggleDialog(isEnjoyingDialog, isHiding: true)
    }
    
    func enjoyNoClick(){
        toggleDialog(askFeedbackDialog, isHiding: false)
        toggleDialog(isEnjoyingDialog, isHiding: true)
    }
    
    func ratingYesClick(){
        let appId = "id1126783712"
        
        toggleDialog(askRatingDialog, isHiding: true)
        UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/" + appId)!)
    }
    
    func ratingNoClick(){
        toggleDialog(askRatingDialog, isHiding: true)
    }
    
    func feedbackYesClick(){
        toggleDialog(askFeedbackDialog, isHiding: true)
        
        let feedbackViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FeedbackController")
            as! FeedbackViewController
        self.presentViewController(feedbackViewController, animated: true, completion: nil)
    }
    
    func feedbackNoClick(){
        toggleDialog(askFeedbackDialog, isHiding: true)
    }
    
    func toggleDialog(dialog: UIView, isHiding: Bool) {
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        let newFrame = CGRect(
            x: 0,
            y: isHiding ? screenHeight : 0,
            width: screenWidth,
            height: screenHeight)
        
        UIView.animateWithDuration(1.0, animations: { dialog.frame = newFrame })
    }
    
    func createDialog(title: String, titleHeight: Int,
                      yesString: String, yesCallback: Selector,
                      noString: String, noCallbalk: Selector) -> UIView {
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        let fullScreen = CGRect(
            x: 0,
            y: screenHeight,
            width: screenWidth,
            height: screenHeight
        )
        
        let canvasView = UIView(frame: fullScreen)
        
        let tap = UITapGestureRecognizer(target: self, action: nil)
        canvasView.addGestureRecognizer(tap)
        
        let frame = CGRect(
            x: 0,
            y: Int(screenHeight) - buttonAreaHeight - titleHeight,
            width: Int(screenWidth),
            height: buttonAreaHeight + titleHeight
        )
        
        let dialogView = UIView(frame: frame)
        canvasView.addSubview(dialogView)
        let margin = 20
            
        dialogView.backgroundColor = UIColor.whiteColor()
        dialogView.layer.cornerRadius = 6
            
        let titleTextView = UITextView(frame: CGRect(x: margin, y: 20, width: Int(screenWidth) - 2 * margin,height: 50))
        titleTextView.text = title
        titleTextView.font = UIFont(name: titleTextView.font!.fontName, size: 16)
        titleTextView.textAlignment = NSTextAlignment.Center
            
        dialogView.addSubview(titleTextView)
        
        let noButton = UIButton(frame: CGRect(
                x: margin, y: titleHeight, width: Int(screenWidth) - 2 * margin, height: 46))
        noButton.setTitle(noString, forState: UIControlState.Normal)
        noButton.backgroundColor = UIColor(red: 255/255.0, green: 212/255.0, blue: 96/255.0, alpha: 1)
        noButton.addTarget(self, action: noCallbalk, forControlEvents: .TouchUpInside)
        noButton.titleLabel?.font = UIFont(name: noButton.titleLabel!.font!.fontName, size: 16)
        noButton.layer.cornerRadius = 4
        dialogView.addSubview(noButton)
            
        let yesButton = UIButton(frame: CGRect(x: margin, y: 62 + titleHeight, width: Int(screenWidth) - 2 * margin, height: 46))
        yesButton.setTitle(yesString, forState: UIControlState.Normal)
        yesButton.backgroundColor = UIColor(red: 240/255.0, green: 123/255.0, blue: 63/255.0, alpha: 1)
        yesButton.addTarget(self, action: yesCallback, forControlEvents: .TouchUpInside)
        yesButton.titleLabel?.font = UIFont(name: yesButton.titleLabel!.font!.fontName, size: 16)
        yesButton.layer.cornerRadius = 4
        dialogView.addSubview(yesButton)
    
        self.view.addSubview(canvasView)
        
        return canvasView
    }
}
