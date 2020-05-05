//
//  ListViewController.swift
//  Test Task
//
//  Created by Anton on 5/5/20.
//  Copyright © 2020 falli_ot. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  var kittyData = [KittyData]()
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    getKitties()
    configureDelegates()
    
        // Do any additional setup after loading the view.
    }
 
  func configureDelegates() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  
   func getKitties() {
     guard let resourceURL = URL(string:"https://api.thecatapi.com/v1/breeds") else {fatalError()}
     var urlRequest = URLRequest(url: resourceURL)
     urlRequest.httpMethod = "GET"
     urlRequest.setValue("eb4517d5-865b-4e49-9b2f-96acfa53c0b2", forHTTPHeaderField: "x-api-key")
     
     URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
       
       if error != nil {
         print("Error occured: \(String(describing: error))")
         return
       }
       
       guard let safeData = data  else { return }
       do {
         
         let decodingData = try JSONDecoder().decode([KittyData].self, from: safeData)
        self.kittyData = decodingData
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
         print("Kitties list: \(decodingData)")
         
       } catch {
         print("Decoder error:  \(String(describing: error))")
       }
     }.resume()
   }
  
  
  
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    kittyData.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "kittyCell", for: indexPath) as! KittyTableViewCell
    
    cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
    
    let kittyCell = kittyData[indexPath.row]
    
    cell.nameLbl.text? = kittyCell.name
    cell.originLbl.text? = kittyCell.origin
    cell.imgView.image = UIImage(named: "lion")
    
    cell.imgView.layer.cornerRadius = cell.imgView.frame.height / 2
    
    return cell
  }
  
  
}
