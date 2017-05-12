import Foundation
import UIKit

struct ColorScheme
{
	var backgroundColor: UIColor
	var textColor: UIColor
	var secondaryTextColor: UIColor
	var separatorColor: UIColor
	var dotColor: UIColor
	var handColor: UIColor
	var timerColor: UIColor
	var pulseColor: UIColor
	var shakerColor: UIColor
	var historyButton: UIImage
	var backButton: UIImage
	var historyHintArrow: UIImage
	var historyHintCircles: UIImage
}

class ColorSchemes
{
	static let dayScheme = ColorScheme(
		backgroundColor: UIColor(red: 241/255.0, green: 207/255.0, blue: 99/255.0, alpha: 1.0),
		textColor: UIColor(red: 32/255.0, green: 31/255.0, blue: 61/255.0, alpha: 1.0),
		secondaryTextColor: UIColor(red: 32/255.0, green: 31/255.0, blue: 61/255.0, alpha: 0.6),
		separatorColor: UIColor(red: 32/255.0, green: 31/255.0, blue: 61/255.0, alpha: 0.19),
		dotColor: UIColor(red: 240/255.0, green: 123/255.0, blue: 63/255.0, alpha: 1.0),
		handColor: UIColor(red: 32/255.0, green: 31/255.0, blue: 61/255.0, alpha: 1.0),
		timerColor: UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0),
		pulseColor: UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 0.11),
		shakerColor: UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0),
		historyButton: UIImage(named: "HistoryDay")!,
		backButton: UIImage(named: "BackDay")!,
		historyHintArrow: UIImage(named: "SwipeLeftDay")!,
		historyHintCircles: UIImage(named: "CirclesDay")!
	
	)
	static let nightScheme = ColorScheme(
		backgroundColor: UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0),
		textColor: UIColor(red: 255/255.0, green: 212/255.0, blue: 96/255.0, alpha: 1.0),
		secondaryTextColor: UIColor(red: 255/255.0, green: 212/255.0, blue: 96/255.0, alpha: 0.6),
		separatorColor: UIColor(red: 255/255.0, green: 212/255.0, blue: 96/255.0, alpha: 0.19),
		dotColor: UIColor(red: 255/255.0, green: 212/255.0, blue: 96/255.0, alpha: 1.0),
		handColor: UIColor(red: 240/255.0, green: 123/255.0, blue: 63/255.0, alpha: 1.0),
		timerColor: UIColor(red: 241/255.0, green: 207/255.0, blue: 99/255.0, alpha: 1.0),
		pulseColor: UIColor(red: 255/255.0, green: 212/255.0, blue: 96/255.0, alpha: 0.11),
		shakerColor: UIColor(red: 255/255.0, green: 212/255.0, blue: 96/255.0, alpha: 1.0),
		historyButton: UIImage(named: "HistoryNight")!,
		backButton: UIImage(named: "BackNight")!,
		historyHintArrow: UIImage(named: "SwipeLeftNight")!,
		historyHintCircles: UIImage(named: "CirclesNight")!
	)
}
