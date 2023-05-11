//
//  TableViewController.swift
//  LiveAPILogin
//
//  Created by Demo 01 on 03/03/23.
//  Copyright © 2023 scs. All rights reserved.
//

import UIKit


struct Model : Decodable
{
    var coursename: String
    var path:String
    var fees: Int
    var duration: String
    var url:String
    }

class TableViewController: UITableViewController {

    //var arr = [Model]()
    var arr1 = [String]()
    var arr2 = [UIImage]()
    
     override func viewDidLoad() {
            super.viewDidLoad()
            getRequest()
        
        }
        // Do any additional setup after loading the view.
   
    
    func getRequest() {
        
        // request url
        let url = URL(string: "https://shivaconceptdigital.com/api/viewallcourse.php") // change the url
        
        // create URLSession with default configuration
        let session = URLSession.shared
        
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: url!) { data, response, error in
            
            if let error = error {
                print("GET Request Error: \(error.localizedDescription)")
                return
            }
            
            // ensure there is valid response code returned from this HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Invalid Response received from the server")
                    return
            }
            
            // ensure there is data returned
            guard let responseData = data else {
                print("nil Data received from the server")
                return
            }
            
            do {
                // serialise the data object into Dictionary [String : Any]
               
            // if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any]
                let json = try! JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any]
                if let data = json?["result"] as? [Any]
                    
                {
                    for item in data {
                        let object = item as? [String: Any]
                        let id = object?["courseid"]
                        let name = object?["coursename"]
                        let dur = object?["duration"]
                        let fees = object?["fees"]
                        let path = object?["path"]
                        var data = "\(id!) \(name!) \(fees!)"
                        self.arr1.append(data)
                        //var data1v = ""
                     // self.arr2.append(path!)
                
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                
                } else {
                    print("data maybe corrupted or in wrong format")
                    throw URLError(.badServerResponse)
                }
            } catch let error {
                print("JSON Parsing Error: \(error.localizedDescription)")
            }
        }
        // resume the task
     task.resume()
        
    }
    
    
    
   
   
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = arr1[indexPath.row]
        return cell
    }
    
}
    
    

