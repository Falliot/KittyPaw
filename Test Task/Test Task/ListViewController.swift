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
  @IBOutlet weak var searchBar: UISearchBar!
  
  var kittyArray = [KittyData]()
  
  var filteredKitties = [KittyData]()
  
  let searchController = UISearchController(searchResultsController: nil)
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    getKitties()
    configureDelegates()

    // Do any additional setup after loading the view.
  }
  
  func configureDelegates() {
    searchBar.delegate = self
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
        self.kittyArray = decodingData
        self.filteredKitties = self.kittyArray
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
        print("Kitties list: \(decodingData)")
        
      } catch {
        print("Decoder error:  \(String(describing: error))")
      }
    }.resume()
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toDetails" {
      if let indexPath = tableView.indexPathForSelectedRow {
        
        let kitty: KittyData
  
        kitty = kittyArray[indexPath.row]
        
        let destinationVC = segue.destination as! DetailsViewController
          destinationVC.kittyDetails = kitty
      }
    }
  }
  
  
  
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    kittyArray.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "kittyCell", for: indexPath) as! KittyTableViewCell
    
    cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
    
    let kittyCell = kittyArray[indexPath.row]
    
    cell.nameLbl.text? = kittyCell.name
    cell.originLbl.text? = kittyCell.origin
    cell.imgView.image = UIImage(named: "lion")
    
    cell.imgView.layer.cornerRadius = cell.imgView.frame.height / 2
    
    return cell
  }
}

extension ListViewController: UISearchBarDelegate {
 
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard !searchText.isEmpty else {
      kittyArray = filteredKitties
      tableView.reloadData()
      return
    }
    kittyArray = filteredKitties.filter({ kitty -> Bool in
      kitty.origin.lowercased().contains(searchText.lowercased())
    })
    tableView.reloadData()
  }
  
  
}
