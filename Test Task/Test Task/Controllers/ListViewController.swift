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
  
  var filteredKitties = [BreedImg]()
  
  var imageDetails = [BreedImg]()
  
  var counter = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getKitties()
    configureDelegates()
    hideKeyboardOnTap()
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.isNavigationBarHidden = false
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
        
        for indexId in decodingData {
          self.getImage(kittyId: indexId.id)
        }
        
        print("Kitties list: \(decodingData)")
        
      } catch {
        print("Decoder error:  \(String(describing: error))")
      }
    }.resume()
  }
  
  func getImage(kittyId: String) {
    guard let resourceURL = URL(string:"https://api.thecatapi.com/v1/images/search?breed_id=\(kittyId)") else {fatalError()}
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
        let decodingData = try JSONDecoder().decode([BreedImg].self, from: safeData)
        self.imageDetails.append(contentsOf: decodingData)
        
        self.filteredKitties = self.imageDetails
        print("Kitties list: \(decodingData)")
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
        
      } catch {
        print("Decoder error:  \(String(describing: error))")
      }
    }.resume()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toDetails" {
      if let indexPath = tableView.indexPathForSelectedRow {
        
        let img: BreedImg
        img = imageDetails[indexPath.row]
        
        let destinationVC = segue.destination as! DetailsViewController
        destinationVC.kittyDetails = img
      }
    }
  }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    imageDetails.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "kittyCell", for: indexPath) as! KittyTableViewCell
    
    let kittyCell = imageDetails[indexPath.row]
    
    cell.nameLbl.text? = kittyCell.breeds.first!.name
    cell.originLbl.text? = kittyCell.breeds.first!.origin
    cell.imgView.downloadImage(urlString: kittyCell.url)
    
    cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
    cell.imgView.layer.cornerRadius = cell.imgView.frame.height / 2
    
    return cell
  }
}


extension ListViewController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard !searchText.isEmpty else {
      imageDetails = filteredKitties
      tableView.reloadData()
      return
    }
    imageDetails = filteredKitties.filter({ kitty -> Bool in
      kitty.breeds.first!.origin.lowercased().contains(searchText.lowercased())
    })
    tableView.reloadData()
  }
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
}
extension ListViewController: UITextFieldDelegate {
  
  func hideKeyboardOnTap() {
    let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
}


