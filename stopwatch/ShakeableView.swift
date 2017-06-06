
import UIKit

class ShakeableView: UIView
{
    var leftArrow = UIImageView()
    var rightArrow = UIImageView()
    var shakeable = UIImageView()
    let shakeAnimation = CABasicAnimation(keyPath: "position")


    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    init()
    {
        super.init(frame: CGRect (x: 0.0, y:0.0, width: 1.0, height: 1.0))

        leftArrow = getTintedImage("LeftArrow")
        rightArrow = getTintedImage("RightArrow")
        shakeable = getTintedImage("Shake")

        self.backgroundColor = UIColor.clear
        let shakeView = UIView.init(frame: CGRect(
            x: 0, y: 0,
            width: shakeable.image!.size.width,
            height: leftArrow.image!.size.height + shakeable.image!.size.height))
        shakeable.alpha = 0.39
        shakeable.frame = CGRect(x: -(shakeView.frame.width / 2), y: leftArrow.image!.size.height, width: shakeable.image!.size.width, height: shakeable.image!.size.height)
        leftArrow.frame = CGRect(x: -(shakeView.frame.width / 2), y: 0, width: leftArrow.image!.size.width, height: leftArrow.image!.size.height)
        rightArrow.frame = CGRect(x: (shakeView.frame.width / 2) - rightArrow.image!.size.width, y: 0, width: rightArrow.image!.size.width, height: rightArrow.image!.size.height)
        shakeView.addSubview(leftArrow)
        shakeView.addSubview(rightArrow)
        shakeView.addSubview(shakeable)

        Foundation.Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(ShakeableView.shakeOnce), userInfo: nil, repeats: true)

        self.addSubview(shakeView)

        setColorScheme()
    }

    func shakeOnce()
    {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 3
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: shakeable.center.x - 5, y: shakeable.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: shakeable.center.x + 5, y: shakeable.center.y))
        shakeable.layer.add(shakeAnimation, forKey: "position")
    }

    func getTintedImage(_ nameOfImage: String) -> UIImageView
    {
        let imageView = UIImageView ()
        if let image = UIImage(named: nameOfImage)
        {
            imageView.image = image.withRenderingMode(.alwaysTemplate)
        }
        imageView.tintColor = AppDelegate.instance.colorScheme.shakerColor
        return imageView
    }

    func hide()
    {
        fadeToOpacity(0)
    }

    func show()
    {
        fadeToOpacity(1)
    }

    func fadeToOpacity(_ opacity : Float)
    {
        animateLayer(layer, duration: 0.5, animation: { l in l.opacity = opacity }, properties: "opacity")
    }

    func setColorScheme()
    {
        rightArrow.tintColor = AppDelegate.instance.colorScheme.shakerColor
        leftArrow.tintColor = AppDelegate.instance.colorScheme.shakerColor
        shakeable.tintColor = AppDelegate.instance.colorScheme.shakerColor
    }
}
