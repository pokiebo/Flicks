//
//  MoviesTableViewCell.swift
//  Flix
//
//  Created by Sudipta Bhowmik on 9/28/17.
//  Copyright © 2017 Sudipta Bhowmik. All rights reserved.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImgView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
   
    var flixMovie : FlixMovie! {
        didSet{
            updateCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell() {
        titleLabel.text = flixMovie.title
        descLabel.text = flixMovie.overview
        movieImgView.setImageWith(URL(string: "https://image.tmdb.org/t/p/w500" + flixMovie.posterPath)!)
    }

}
