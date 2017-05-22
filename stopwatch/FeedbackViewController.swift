import UIKit

class FeedbackViewController: UIViewController
{
    @IBOutlet fileprivate weak var feedbackTextView: UITextView!
    @IBOutlet fileprivate weak var placeholderLabel: UILabel!
    @IBOutlet fileprivate weak var negativeButton: UIButton!
    @IBOutlet fileprivate weak var positiveButton: UIButton!
    @IBOutlet fileprivate weak var bottomStackViewConstraint: NSLayoutConstraint!
    
    var model: Feedback!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FeedbackViewController.keyboardWillShow(notification:)),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        
        negativeButton.layer.cornerRadius = 4
        positiveButton.layer.cornerRadius = 4
        
        placeholderLabel.text = model.placeholderText
        feedbackTextView.becomeFirstResponder()
        negativeButton.setTitle(model.negativeButtonText, for: .normal)
        positiveButton.setTitle(model.positiveButtonText, for: .normal)
    }
    
    @objc private func keyboardWillShow(notification:NSNotification)
    {
        if let keyboardRectValue = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            bottomStackViewConstraint.constant = keyboardRectValue.height + 24
        }
    }
    
    class func instance(with model: Feedback, from storyboard: UIStoryboard) -> FeedbackViewController
    {
        let vc = storyboard.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
        vc.model = model
        vc.modalPresentationStyle = .custom
        return vc
    }
}

extension FeedbackViewController: UITextViewDelegate
{
    func textViewDidChange(_ textView: UITextView)
    {
        placeholderLabel.isHidden = textView.text.characters.count > 0
    }
}
