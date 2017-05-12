
 import Foundation

 class UserSettings {

    private var defaults = UserDefaults.standard

    private let lastOpenedKey = "lastOpened"
    private let hasStartedKey = "hasStarted"
    private let hasStoppedKey = "hasStopped"
    private let hasResetKey = "hasReset"
	private let showHistoryHintKey = "showHistoryHint"

    private lazy var defaultValues : NSDictionary = [
            self.hasStartedKey : false,
            self.hasStoppedKey : false,
            self.hasResetKey : false,
            self.showHistoryHintKey: false,
            self.lastOpenedKey: Date()
    ]

    var lastOpened : Date! {
        set {
            defaults.set(newValue, forKey: lastOpenedKey)
        }
        get {
            return defaults.object(forKey: lastOpenedKey) as! Date
        }
    }

    var hasStarted : Bool {
        set {
            defaults.set(newValue, forKey: hasStartedKey)
        }
        get {
            return defaults.bool(forKey: hasStartedKey)
        }
    }

    var hasStopped : Bool {
        set {
            defaults.set(newValue, forKey: hasStoppedKey)
        }
        get {
            return defaults.bool(forKey: hasStoppedKey)
        }
    }

    var hasReset : Bool {
        set {
            defaults.set(newValue, forKey: hasResetKey)
        }
        get {
            return defaults.bool(forKey: hasResetKey)
        }
    }
	
	var showHistoryHint : Bool {
		set {
			defaults.set(newValue, forKey: showHistoryHintKey)
		}
		get {
			return defaults.bool(forKey: showHistoryHintKey)
		}
	}

    init (){
        defaults.register(defaults: defaultValues as! [String : AnyObject])
        resetIfMoreThanWeekOld()
    }

    func resetIfMoreThanWeekOld () {
        let weekInSeconds = 604800.0 //week in seconds

        let interval = Date().timeIntervalSince(lastOpened)

        if(interval > weekInSeconds){
            restoreDefaults()
        } else {
            lastOpened = Date()
        }
    }

    func restoreDefaults() {
        lastOpened = defaultValues[lastOpenedKey] as! Date
        hasStarted = defaultValues[hasStartedKey] as! Bool
        hasStopped = defaultValues[hasStoppedKey] as! Bool
        hasReset = defaultValues[hasResetKey] as! Bool
		showHistoryHint = defaultValues[showHistoryHintKey] as! Bool
    }
 }
