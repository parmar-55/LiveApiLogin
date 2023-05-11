//
//  LoginViewController.swift
//  LiveAPILogin
//
//  Created by Demo 01 on 02/03/23.
//  Copyright © 2023 scs. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func loginID(_ sender: Any) {

    self.loginPostMethod()
    
}
    func loginPostMethod(){
        guard let emal = loginEmail.text else { return }
        guard let pswd = loginPassword.text else { return }
        
        
        if let url = URL(string: "https://shivaconceptdigital.com/api/login.php"){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            //   request.setValue(<#T##value: String?##String?#>, forHTTPHeaderField: <#T##String#>)
            let parameters: [String : Any] = [
                "email": emal,
                "pwd": pswd ,
                
                ]
            
            request.httpBody = parameters.percentEscaped().data(using: .utf8)
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    if error == nil{
                        print(error?.localizedDescription ?? "Unknown Error")
                    }
                    return
                }
                
                if let response = response as? HTTPURLResponse{
                    guard (200 ... 299) ~= response.statusCode else {
                        print("Status code :- \(response.statusCode)")
                        print(response)
                        return
                    }
                }
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    print("jii")
                }catch let error{
                    print(error.localizedDescription)
                    print("hello")
                }
                }.resume()
        }
    }
    
    
    
    
    
    
}
extension Dictionary {
        func percentEscaped1() -> String {
            return map { (key, value) in
                let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
                let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
                return escapedKey + "=" + escapedValue
                }
                .joined(separator: "&")
        }
    }
    
extension CharacterSet {
        static let urlQueryValueAllowed1: CharacterSet = {
            let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
            let subDelimitersToEncode = "!$&'()*+,;="
            
            var allowed = CharacterSet.urlQueryAllowed
            allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
            return allowed
        }()
    }

    
    
    
    
    
    
    
    
    

