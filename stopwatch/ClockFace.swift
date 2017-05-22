import UIKit

class ClockFace: UIView
{
    var dotWidth = CGFloat(8)

    var clockHand = CAShapeLayer()
    var midLayer = CALayer()
    var centerDot = CALayer()
    var currentSeconds = 0.0

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    init(containerSize: CGSize = CGSize(width: ClockFace.clockHandSize(), height: ClockFace.clockHandSize()),
         centerRadius: CGFloat = 8)
    {
        super.init(frame: CGRect (origin: CGPoint.zero, size: containerSize))

        backgroundColor = UIColor.clear
        setColorScheme()
        clockHand.path = getHandPath(extended: false)

        let scale = (CGFloat(ClockFace.clockHandSize()) / containerSize.width) + (CGFloat(ClockFace.clockHandSize()) / containerSize.height)
        clockHand.lineWidth = 0.01 * (scale / 2)
        dotWidth = centerRadius

        midLayer.addSublayer(clockHand)
        midLayer.setAffineTransform(CGAffineTransform.init(a: frame.width/4.0, b: 0, c: 0, d: frame.height / 4.0, tx: frame.width / 2.0, ty: frame.height / 2.0))
        scaleDot(0)
        layer.addSublayer(midLayer)
        layer.addSublayer(centerDot)
    }

    func getHandPath(extended : Bool) -> CGPath
    {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: extended ? -2 : 0))
        return path
    }
    
    func animate(_ seconds: Double)
    {
        
        if seconds == currentSeconds { return } //don't run the animation on every call (run it 10 times a second).
            
        currentSeconds = seconds;
        
        let angle = seconds * 6.0
        let rotation = CGAffineTransform(rotationAngle: CGFloat(Double(angle) / 180.0 * Double.pi))
        self.clockHand.setAffineTransform(rotation)
    }
    
    func scaleDot(_ size : CGFloat)
    {
        centerDot.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        centerDot.bounds = CGRect(x: 0, y: 0, width: size, height: size)
        centerDot.cornerRadius = size / 2
    }
    
    func hide()
    {
        animateLayer(clockHand,
            duration: 0.4,
            animation: { layer in
                layer.path = self.getHandPath(extended: false)
            },
            properties: "path"
        )
        animateLayer(centerDot,
                     duration: 0.4, delay: 0.25,
                     timingFunction: CAMediaTimingFunction(controlPoints: 0.4, 0, 1, 1),
                     animation: { layer in
                        self.scaleDot(0)
            }, properties: "position", "bounds", "cornerRadius"
        )
    }
    
    func show()
    {
        isHidden = false
        animateLayer(clockHand,
            duration: 1, delay: 0.7,
            timingFunction: CAMediaTimingFunction(controlPoints: 0, 1, 1, 1),
            animation: { layer in
                layer.path = self.getHandPath(extended: true)
            },
            properties: "path"
        )
        animateLayer(centerDot,
                     duration: 0.5,
                     timingFunction: CAMediaTimingFunction(controlPoints: 0, 2, 0.5, 1),
                     animation: { layer in
                        self.scaleDot(self.dotWidth)
            }, properties: "position", "bounds", "cornerRadius"
        )
    }

    func setColorScheme()
    {
        centerDot.backgroundColor = AppDelegate.instance.colorScheme.dotColor.cgColor
        clockHand.strokeColor = AppDelegate.instance.colorScheme.handColor.cgColor
    }

    static func clockHandSize() -> Double
    {
        if(AppDelegate.isIPhone5orLower())
        {
            return 300.0
        }
        else
        {
            return 330.0
        }
    }

    static func clockHandLocation(_ superView: UIView, clockFaceView: UIView) -> CGPoint
    {
        //if small, x points from top, if large, put in center
        if(AppDelegate.isIPhone5orLower())
        {
            return CGPoint(x: superView.center.x, y: 64 + clockFaceView.bounds.height / 2)
        }
        return superView.center
    }
}

