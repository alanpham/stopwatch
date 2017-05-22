import Foundation
import UIKit

protocol TimerDelegate
{
    func timerStarted()
    func timerReset()
    func timerSaved()
    func getSecondaryClockFaces() -> [ClockFace]
    func getSecondaryLabels() -> [UILabel]
    func getPrettySecondaryLabels() -> [UILabel]
    func showHistory()
}

protocol HistoryDelegate
{
    func showTimer()
}

class MainViewController: UIViewController, UIScrollViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!

    var timerController: TimerViewController?

    var historyController: HistoryViewController?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = AppDelegate.instance.colorScheme.backgroundColor
    }

    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.frame.width * 2, height: view.frame.height)
        scrollView.delegate = self

        historyController = storyboard?.instantiateViewController(withIdentifier: "HistoryController")
            as? HistoryViewController
        historyController?.delegate = self
        addChildViewController(historyController!)
        historyController?.view.frame.origin.x = view.frame.size.width
        scrollView.addSubview((historyController?.view)!)
        historyController?.didMove(toParentViewController: self)

        timerController = storyboard?.instantiateViewController(withIdentifier: "TimerController")
            as? TimerViewController
        timerController?.delegate = self
        addChildViewController(timerController!)
        scrollView.addSubview((timerController?.view)!)
        timerController?.didMove(toParentViewController: self)

        scrollView.isScrollEnabled = UserSettings().hasReset
        timerController?.historyButton.isHidden = !UserSettings().hasReset
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView.contentOffset.x >= scrollView.frame.width * 0.9
                && timerController?.settings.showHistoryHint == true
        {
            timerController?.settings.showHistoryHint = false
            timerController?.refreshHistoryHint()
        }
    }

    override var prefersStatusBarHidden : Bool
    {
        return true
    }
}

extension MainViewController: TimerDelegate
{
    func timerStarted()
    {
        historyController?.showCurrentTimerView()
    }

    func timerReset()
    {
        scrollView.isScrollEnabled = true
        timerController?.refreshHistoryHint()
        historyController?.hideCurrentTimerView()
    }

    func timerSaved()
    {
        historyController?.loadData()
    }

    func getSecondaryClockFaces() -> [ClockFace]
    {
        return [(historyController?.clockFace)!]
    }

    func getSecondaryLabels() -> [UILabel]
    {
        return [(historyController?.currentDetailsLabel)!]
    }

    func getPrettySecondaryLabels() -> [UILabel]
    {
        return [(historyController?.currentDurationLabel)!]
    }

    func showHistory()
    {
        var rect = view.frame
        rect.origin.x = rect.width
        scrollView.scrollRectToVisible(rect, animated: true)
    }
}

extension MainViewController: HistoryDelegate
{
    func showTimer()
    {
        scrollView.scrollRectToVisible(view.frame, animated: true)
    }
}
