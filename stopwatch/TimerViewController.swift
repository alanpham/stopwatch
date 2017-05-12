import UIKit

class TimerViewController: UIViewController
{
    //MARK: Properties
    let pulse = Pulse ()
    let shakeView = ShakeableView()
    let clockFace = ClockFace()
    @IBOutlet weak var timer: TimerView!
	@IBOutlet weak var historyButton: UIButton!
	@IBOutlet weak var historyHintView: UIView!
	@IBOutlet weak var historyHintArrow: UIImageView!
	@IBOutlet weak var historyHintCircles: UIImageView!
	
	var shakeTimer: Foundation.Timer?
	
	var pulseTimer: Foundation.Timer?

    var settings : UserSettings!
	
	var delegate: TimerDelegate?
    
    //MARK: Actions
    @IBAction func timerAction(_ sender: UITapGestureRecognizer)
    {
        if(timer.isRunning())
        {
			if pulseTimer != nil
            {
				pulseTimer?.invalidate()
				pulseTimer = nil
			}
            timer.stop()
            settings.hasStopped = true
            pulse.hide()
            if (!settings.hasReset)
            {
               shakeTimer = Foundation.Timer.schedule(delay: 1, handler: { timer in self.shakeView.show()})
            }
        }
        else
        {
			if shakeTimer != nil
            {
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
            if(!settings.hasStopped)
            {
                pulseTimer = Foundation.Timer.schedule(delay: 5, handler: { timer in
                    if !self.timer.isRunning()
                    {
                        return
                    }
                    self.pulse.show()
                })
            }
        }
    }

    override func viewDidLoad()
    {
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
            Foundation.Timer.schedule(delay: 0.5, handler: { timer in
                if self.timer.isRunning()
                {
                    return
                }
                self.pulse.show()
            })
        }
		
		historyButton.setImage(AppDelegate.instance.colorScheme.historyButton, for: .normal)
		historyHintArrow.image = AppDelegate.instance.colorScheme.historyHintArrow
		historyHintCircles.image = AppDelegate.instance.colorScheme.historyHintCircles
		
		refreshHistoryHint()
    }
	
	override func viewDidAppear(_ animated: Bool)
    {
		super.viewDidAppear(animated)
		becomeFirstResponder()
	}
	
    override var canBecomeFirstResponder : Bool
    {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?)
    {
        if (motion == .motionShake && !timer.timer.isValid && abs(timer.interval) > 0)
        {
            reset()
        }
    }
	
	func refreshHistoryHint()
    {
		if historyHintView.isHidden && settings.showHistoryHint
        {
			historyHintView.isHidden = false
			historyHintView.alpha = 0
			historyButton.isHidden = false
			historyButton.alpha = 0
			UIView.animate(withDuration: 0.5, animations: {
				self.historyHintView.alpha = 1
				self.historyButton.alpha = 1
			}) 
		}
        else
        {
			historyHintView.isHidden = settings.showHistoryHint == false
		}
	}
	
	func reset()
    {
		if (!settings.hasReset)
        {
			confirmReset()
		}
        else
        {
			refreshHistoryHint()
			delegate?.timerReset()
			Datastore.instance.saveTimer(timer.startTime, duration: abs(timer.interval))
			delegate?.timerSaved()
			timer.reset()
		}
	}

    func confirmReset()
    {
        let confirmDialog = UIAlertController(title: "Reset", message: "Do you want to reset the timer?", preferredStyle: .alert)
        confirmDialog.addAction(UIAlertAction(title: "Reset", style: .default, handler: { action in
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
        confirmDialog.addAction(UIAlertAction(title: "Do nothing", style: .cancel, handler: nil))
        present(confirmDialog, animated: true, completion: nil)
    }
	
	@IBAction func showHistory()
    {
		delegate?.showHistory()
	}
}
