import Foundation

class FeedbackAPI
{
    private static let username = ""
    private static let password = ""
    private static let apiBaseURL = "https://toggl.com/api/"
    private static let apiVersion = "v9"
    private static let feedbackEndPoint = "/stopwatch/feedback"
    
    static func send(feedback: String)
    {
        let url = URL(string: apiBaseURL + apiVersion + feedbackEndPoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try? JSONSerialization.data(withJSONObject: ["message": feedback], options: .prettyPrinted)
        request.httpBody = jsonData
        
        let task = self.defaultURLSession().dataTask(with: request)
        task.resume()
    }
    
    private static func base64LoginString() -> String
    {
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        return "Basic \(loginData.base64EncodedString())"
    }
    
    private static func defaultURLSession() -> URLSession
    {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization" : base64LoginString()]
        return URLSession(configuration: config)
    }
}
