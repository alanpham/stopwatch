import Foundation

struct Question
{
    let text: String
    let negativeButtonText: String
    let positiveButtonText: String
}

class Questions
{
    static let firstQuestion = Question(text: "Enjoying Stopwatch?",
                                        negativeButtonText: "Not Really",
                                        positiveButtonText: "Yes!")
    
    static let secondQuestion = Question(text: "Whould you mind talking a moment to rate it in the App Store?",
                                        negativeButtonText: "No, thanks",
                                        positiveButtonText: "Ok, sure")
    
    static let thirdQuestion = Question(text: "Would you mind giving us some feedback?",
                                        negativeButtonText: "No, thanks",
                                        positiveButtonText: "Ok, sure")
}
