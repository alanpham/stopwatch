import Foundation

struct Feedback
{
    let placeholderText: String
    let negativeButtonText: String
    let positiveButtonText: String
}

class Feedbacks
{
    static let feedback = Feedback(placeholderText: "Add your comment...",
                                        negativeButtonText: "Cancel",
                                        positiveButtonText: "Send")
}
