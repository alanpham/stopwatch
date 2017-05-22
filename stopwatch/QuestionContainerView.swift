import UIKit

@IBDesignable
class QuestionContainerView: UIView
{
    @IBInspectable
    var drawnBackgroundColor: UIColor = UIColor.white
    {
        didSet
        {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect)
    {
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 6, height: 6))
        rectanglePath.close()
        drawnBackgroundColor.setFill()
        rectanglePath.fill()
    }
}
