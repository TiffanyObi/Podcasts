//
//  PodcastViewController.swift
//  Podcasts
//
//  Created by Alex Paul on 12/17/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class PodcastDetailController: UIViewController {
  
  @IBOutlet weak var podcastImageView: UIImageView!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var favoriteButtonK: UIBarButtonItem!
  var podcast: Podcast?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }
  
  private func updateUI() {
    guard let podcast = podcast else {
      fatalError("could not access podcast, verify it was passed in prepare(for segue:)")
    }
    if podcast.favoritedBy != nil {
        favoriteButtonK.isEnabled = false }
    artistNameLabel.text = podcast.artistName
    collectionNameLabel.text = podcast.collectionName
    podcastImageView.getImage(with: podcast.artworkUrl600) { [weak self] (result) in
      switch result {
      case .failure:
        DispatchQueue.main.async {
          self?.podcastImageView.image = UIImage(systemName: "mic.fill")
        }
      case .success(let image):
        DispatchQueue.main.async {
          self?.podcastImageView.image = image
        }
      }
    }
  }
  
  @IBAction func favoritePodcast(_ sender: UIBarButtonItem) {
    sender.isEnabled = false
        
    let favorite = Podcast(artworkUrl600: podcast?.artworkUrl600 ?? "", collectionName: podcast?.collectionName ?? "", artworkUrl100: podcast?.artworkUrl100, artistName: podcast?.artistName, favoritedBy: "Tiffany Obi")
        
       PodcastAPIClient.favoritePodcast(for: favorite) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Couldn't Add As Favorite", message: "\(appError)")
            }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Awesome! We Love That Podcast Too!", message: "\(favorite.collectionName) was posted!")
                }
        }
    }
  }
  
}
