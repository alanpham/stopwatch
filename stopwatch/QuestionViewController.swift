import UIKit

class QuestionViewController: UIViewController
{
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var negativeButton: UIButton!
    @IBOutlet private weak var positiveButton: UIButton!
    
    var model: Question!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        negativeButton.layer.cornerRadius = 4
        positiveButton.layer.cornerRadius = 4
        
        questionLabel.text = model.text
        negativeButton.setTitle(model.negativeButtonText, for: .normal)
        positiveButton.setTitle(model.positiveButtonText, for: .normal)
    }
    
    class func instance(with model: Question, from storyboard: UIStoryboard) -> QuestionViewController
    {
        let vc = storyboard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        vc.model = model
        vc.modalPresentationStyle = .custom
        return vc
    }
}
