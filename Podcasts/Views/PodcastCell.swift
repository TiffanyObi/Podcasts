//
//  PodcastCell.swift
//  Podcasts
//
//  Created by Alex Paul on 12/17/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class PodcastCell: UITableViewCell {
  
  @IBOutlet weak var podcastImageView: UIImageView!
  @IBOutlet weak var collectionNameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  
  // keep track of the cell's image url string to prevent flickering caused by dequeueReusableCell
  private var urlString = ""
  
  func configureCell(for podcast: Podcast) {
    
    collectionNameLabel.text = podcast.collectionName
    artistNameLabel.text = podcast.artistName
    guard let imageURL = podcast.artworkUrl100 else {
      podcastImageView.image = UIImage(systemName: "mic.fill")
      return
    }
    
    urlString = imageURL
    
    podcastImageView.getImage(with: imageURL) { [weak self] result in
      switch result {
      case .failure:
        DispatchQueue.main.async {
          self?.podcastImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        }
      case .success(let image):
        DispatchQueue.main.async {
          // only set the cell's image if this url string is equal to the cell's urlString property
          // again here we are avoiding flickering of images
          if self?.urlString == imageURL {
            self?.podcastImageView.image = image
          }
        }
      }
    }
  }
  
  // we also reset the cell's image right before it gets set as a final measure to prevent flickering
  override func prepareForReuse() {
    super.prepareForReuse()
    podcastImageView.image = UIImage(systemName: "mic.fill")
  }
  
  
}
