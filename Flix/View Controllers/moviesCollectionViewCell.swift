//
//  moviesCollectionViewCell.swift
//  Flix
//
//  Created by Sudipta Bhowmik on 10/26/17.
//  Copyright © 2017 Sudipta Bhowmik. All rights reserved.
//

import UIKit

class moviesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var movieCollectionTitleLabel: UILabel!
    
    @IBOutlet weak var movieCollectionTitleImage: UIImageView!
    
    var flixMovie : FlixMovie! {
        didSet{
            updateCell()
        }
    }
    
    func updateCell() {
        movieCollectionTitleLabel.text = flixMovie.title
        movieCollectionTitleImage.setImageWith(URL(string: "https://image.tmdb.org/t/p/w500" + flixMovie.posterPath)!)
    }
}
