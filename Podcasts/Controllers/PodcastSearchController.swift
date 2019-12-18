//
//  ViewController.swift
//  Podcasts
//
//  Created by Alex Paul on 12/17/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class PodcastSearchController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var podcasts = [Podcast]() {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
    
    
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    searchBar.delegate = self
    searchBar.autocapitalizationType = .none
    searchPodcasts(with: "swift")
  }
  
    
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let podcastDetailController = segue.destination as? PodcastDetailController,
      let indexPath = tableView.indexPathForSelectedRow else {
      fatalError("could not downcast to PodcastDetailController")
    }
    let podcast = podcasts[indexPath.row]
    
    podcastDetailController.podcast = podcast
    
  }

    
    
  private func searchPodcasts(with name: String) {
    PodcastAPIClient.getPodcasts(for: name) { [weak self](result) in
        switch result {
        case .failure(let appError):
            DispatchQueue.main.async {
                self?.showAlert(title: "App Error", message: "\(appError)")
            }
            
        case .success(let podcasts):
            DispatchQueue.main.async {
                self?.podcasts = podcasts
            }
        }
    }
  }
}



extension PodcastSearchController: UITableViewDataSource {
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return podcasts.count
  }
  
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "podcastCell", for: indexPath) as? PodcastCell else {
      fatalError("could not downcast to PodcastCell")
    }
    let podcast = podcasts[indexPath.row]
    
    cell.configureCell(for: podcast)
    
    return cell
  }
}



extension PodcastSearchController: UITableViewDelegate {
    
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
  
    
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if searchBar.isFirstResponder {
      searchBar.resignFirstResponder()
    }
  }
}



extension PodcastSearchController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchPodcasts(with: searchText)
  }
}
