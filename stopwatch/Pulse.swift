import UIKit

class Pulse: UIView
{
    let radExt = CGFloat(50)
    let radInt = CGFloat(30)
    let internalCircle = CAShapeLayer ()
    let externalCircle = CAShapeLayer ()
    let nightColor = UIColor(red: 255/255.0, green: 212/255.0, blue: 96/255.0, alpha: 0.11).cgColor
    let dayColor = UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 0.11).cgColor

    init()
    {
        super.init(frame: CGRect (x: 0.0, y:0.0, width: 1.0, height: 1.0))
        initAnim()
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    func initAnim ()
    {
        let path = UIBezierPath ()
        path.addArc(withCenter: CGPoint.init(x:0,y:0), radius: radInt, startAngle: 0.0 * CGFloat ((Double.pi/180.0)), endAngle: 360 * CGFloat((Double.pi/180.0)), clockwise: true)
        internalCircle.path = path.cgPath

        let staticPath = UIBezierPath ()
        staticPath.addArc(withCenter: CGPoint.init(x:0,y:0), radius: radExt, startAngle: 0.0 * CGFloat ((Double.pi/180.0)), endAngle: 360 * CGFloat((Double.pi/180.0)), clockwise: true)
        externalCircle.path = staticPath.cgPath

        layer.addSublayer(externalCircle)
        layer.addSublayer(internalCircle)
        
        Foundation.Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(Pulse.animInnerOnce), userInfo: nil, repeats: true)
        Foundation.Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(Pulse.animOuterOnce), userInfo: nil, repeats: true)
        animInnerOnce()
        animOuterOnce()
        
        layer.opacity = 0

        setColorScheme()
    }
    
    func animInnerOnce()
    {
        let bounceScaleAnim = CAKeyframeAnimation ()
        bounceScaleAnim.keyPath = "transform.scale.xy"
        bounceScaleAnim.values = [0.6, 0.67, 0.6]
        
        let animGroup = CAAnimationGroup ()
        animGroup.animations =  [bounceScaleAnim]
        animGroup.duration = 2
        animGroup.fillMode = kCAFillModeForwards
        animGroup.isRemovedOnCompletion = false
        
        internalCircle.add(animGroup, forKey: "scale")
    }
    
    func animOuterOnce()
    {
        let simpleScale = CABasicAnimation ()
        simpleScale.keyPath = "transform.scale.xy"
        simpleScale.fromValue = 0
        simpleScale.toValue = 1.0
        
        let simpleAlpha = CABasicAnimation ()
        simpleAlpha.keyPath = "opacity"
        simpleAlpha.fromValue = 1
        simpleAlpha.toValue = 0.0
        
        let animGroup = CAAnimationGroup ()
        animGroup.animations = [simpleScale, simpleAlpha]
        animGroup.duration = 3
        animGroup.fillMode = kCAFillModeForwards
        animGroup.isRemovedOnCompletion = false
        
        externalCircle.add(animGroup, forKey: "pulse")
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
        internalCircle.fillColor = AppDelegate.instance.colorScheme.pulseColor.cgColor
        externalCircle.fillColor = AppDelegate.instance.colorScheme.pulseColor.cgColor
    }
}
