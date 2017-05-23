import UIKit

class QuestionViewController: UIViewController
{
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var negativeButton: UIButton!
    @IBOutlet private weak var positiveButton: UIButton!
    
    var model: Question!
    var negativeAction: (() -> Void)?
    var positiveAction: (() -> Void)?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        negativeButton.layer.cornerRadius = 4
        positiveButton.layer.cornerRadius = 4
        
        questionLabel.text = model.text
        negativeButton.setTitle(model.negativeButtonText, for: .normal)
        positiveButton.setTitle(model.positiveButtonText, for: .normal)
    }
    
    @IBAction func negativeButtonTapped(_ sender: UIButton)
    {
        negativeAction?()
    }
    
    @IBAction func positiveButtonTapped(_ sender: UIButton)
    {
        positiveAction?()
    }
    
    class func instance(with model: Question,
                        from storyboard: UIStoryboard,
                        negativeAction: (() -> Void)? = nil,
                        positiveAction: (() -> Void)? = nil) -> QuestionViewController
    {
        let vc = storyboard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        vc.model = model
        vc.negativeAction = negativeAction
        vc.positiveAction = positiveAction
        vc.modalPresentationStyle = .custom
        return vc
    }
}
