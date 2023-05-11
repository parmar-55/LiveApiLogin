//
//  ViewController.swift
//  LiveAPILogin
//
//  Created by Demo 01 on 02/03/23.
//  Copyright © 2023 scs. All rights reserved.


import UIKit
// "https://shivaconceptdigital.com/api/reg.php"
//struct Regdata
//{
//    let email : String
//    let pwd : String
//    let mobileno:String
//    let fullname:String
//    let statename:String
//    let cityname : String
//}
class ViewController: UIViewController {
    
    @IBOutlet weak var regBut: UIButton!
    @IBOutlet weak var loginbut: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var mobileno: UITextField!
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var cityname: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
    @IBAction func registration(_ sender : Any){setupPostMethod()}

    
    func setupPostMethod(){
        guard let emal = email.text else { return }
        guard let pswd = password.text else { return }
        guard let mobil = mobileno.text else { return }
        guard let fullNm = fullname.text else { return }
        guard let stte = self.state.text else { return }
        guard let cty = self.cityname.text else { return }
        
        if let url = URL(string: "https://shivaconceptdigital.com/api/reg.php"){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            //   request.setValue(<#T##value: String?##String?#>, forHTTPHeaderField: <#T##String#>)
            let parameters: [String : Any] = [
                "email": emal,
                "pwd": pswd ,
                "mobilno": mobil ,
                "fullname": fullNm,
                "statename": stte,
                "cityname": cty
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
                }catch let error{
                    print(error.localizedDescription)
                }
                }.resume()
        }
    }

    
    
    
    
    
}


extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
