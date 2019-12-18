//
//  FavoritesViewController.swift
//  Podcasts
//
//  Created by Alex Paul on 12/17/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var refreshControl: UIRefreshControl!
  
  private var podcasts = [Podcast]() {
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
    configureRefreshControl()
    fetchFavorites()
  }
  
  private func configureRefreshControl() {
    refreshControl = UIRefreshControl()
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(fetchFavorites), for: .valueChanged)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let podcastDetailController = segue.destination as? PodcastDetailController,
      let indexPath = tableView.indexPathForSelectedRow else {
        fatalError("could not downcast to PodcastDetailController")
    }
    let podcast = podcasts[indexPath.row]
    podcastDetailController.podcast = podcast
  }
  
  @objc
  private func fetchFavorites() {
    PodcastAPIClient.getFavoritesList { [weak self](result) in
        switch result {
        case .failure(let appError):
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.showAlert(title: "App Error", message: "\(appError)")
            }
            
        case .success(let favorites):
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.podcasts = favorites.filter {$0.favoritedBy == "Tiffany Obi"}
            }
        }
    }
}
}

extension FavoritesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return podcasts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "podcastCell", for: indexPath) as? PodcastCell else {
      fatalError("could not downcast a PodcastCell")
    }
    let podcast = podcasts[indexPath.row]
    cell.configureCell(for: podcast)
    return cell
  }
}

extension FavoritesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
}
