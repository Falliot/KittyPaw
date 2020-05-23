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
  
  var utility = Utility()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureDelegates()
    hideKeyboardOnTap()
    
    // Do any additional setup after loading the view.
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getKittyId()
    self.navigationController?.isNavigationBarHidden = false
  }
  
  //MARK: Cancelling all requests and erasing data when moving back to parent VC
  
  override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent)
    if parent == nil {
      for imgURL in imageDetails {
        cancelTaskWithUrl(imgURL.url)
        print("Cancelled: \(imgURL.breeds.first?.name)")
      }
      for kittyData in kittyArray {
        cancelTaskWithUrl("https://api.thecatapi.com/v1/images/search?breed_id=\(kittyData.id)")
        print("Cancelled: \(kittyData.id)")
      }
      cancelTaskWithUrl("https://api.thecatapi.com/v1/breeds")
      self.kittyArray.removeAll()
      self.imageDetails.removeAll()
      self.filteredKitties.removeAll()
      self.tableView.reloadData()
      print("imageDetails.count\(imageDetails.count)")
    }
  }
  
  //MARK: Method for delegates
  
  func configureDelegates() {
    searchBar.delegate = self
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  //MARK: Method for getting kitty's id
  
  func getKittyId() {
    guard let resourceURL = URL(string:"https://api.thecatapi.com/v1/breeds") else {fatalError()}
    var urlRequest = URLRequest(url: resourceURL)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("eb4517d5-865b-4e49-9b2f-96acfa53c0b2", forHTTPHeaderField: "x-api-key")
    
    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
      
      if error != nil {
        self.utility.getError(error: error! as NSError, controller: self)
        print("Error occured: \(String(describing: error))")
        return
      }
      
      guard let safeData = data  else { return }
      
      do {
        let decodingData = try JSONDecoder().decode([KittyData].self, from: safeData)
        self.kittyArray = decodingData
        
        for indexId in decodingData {
          self.getKittyData(kittyId: indexId.id)
        }
        
        print("Kitties list: \(decodingData)")
        
      } catch {
        print("Decoder error:  \(String(describing: error))")
      }
    }.resume()
  }
  
  //MARK: Method for getting kitty's data
  
  func getKittyData(kittyId: String) {
    guard let resourceURL = URL(string:"https://api.thecatapi.com/v1/images/search?breed_id=\(kittyId)") else {fatalError()}
    var urlRequest = URLRequest(url: resourceURL)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("eb4517d5-865b-4e49-9b2f-96acfa53c0b2", forHTTPHeaderField: "x-api-key")
    
    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
      
      if error != nil {
        self.utility.getError(error: error! as NSError, controller: self)
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
  
  //MARK: Method for passing data when moving to DetailsVC
  
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
  
  //MARK: Method for cancelling URL tasks
  
  func cancelTaskWithUrl(_ stringUrl: String) {
    let url = URL(string: stringUrl)
    URLSession.shared.getAllTasks { tasks in
      tasks
        .filter { $0.state == .running }
        .filter { $0.originalRequest?.url == url }.first?
        .cancel()
    }
  }
}

//MARK: Extensions

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
  
    
    cell.imgView.downloadImage(urlString: kittyCell.url, completion: { result in
      switch result {
      case .success:
        print("\(String(describing: cell.nameLbl.text)) image was loaded")
      case .failure(let error):
        self.utility.getError(error: error as NSError, controller: self)
      }
    })
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


