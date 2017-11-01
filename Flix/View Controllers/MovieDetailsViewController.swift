//
//  MovieDetailsViewController.swift
//  Flix
//
//  Created by Sudipta Bhowmik on 10/10/17.
//  Copyright © 2017 Sudipta Bhowmik. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    var flixMovie : FlixMovie?
    
    @IBOutlet weak var movieDetailsContainerView: UIView!
    @IBOutlet weak var movieDetailsScrollView: UIScrollView!
    
    @IBOutlet weak var movieDetailsRuntimeLabel: UILabel!
    @IBOutlet weak var movieDetailsRatingsLabel: UILabel!
    @IBOutlet weak var movieDetailsDateLabel: UILabel!
    @IBOutlet weak var movieDetailsTitleLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieDetailsImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        //Set up the labels
        if let movie = flixMovie {
            movieDetailsDateLabel.text = movie.releaseDate
            movieDetailsTitleLabel.text = movie.title
            movieDetailsRatingsLabel.text = String(movie.voteAverage)
            movieOverviewLabel.text = movie.overview
            movieDetailsImageView.setImageWith(URL(string: "https://image.tmdb.org/t/p/w500" + (flixMovie?.posterPath)!)!)
            
        }
        
        //Set up scroll view
        movieOverviewLabel.sizeToFit()
        
        //Set the height of the container view
       movieDetailsContainerView.frame.size = CGSize(width: view.frame.size.width, height: movieDetailsTitleLabel.frame.height + movieDetailsDateLabel.frame.height + movieOverviewLabel.frame.size.height + 100)
        
        movieDetailsScrollView.contentSize = CGSize(width: view.frame.size.width, height: movieDetailsContainerView.frame.origin.y + movieDetailsContainerView.frame.size.height)
        
        movieDetailsContainerView.backgroundColor = UIColor.black
        
        /*let layer = CAGradientLayer()
        layer.frame = movieDetailsContainerView.bounds
        
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.locations = [0.2, 1.0]
        movieDetailsContainerView.layer.addSublayer(layer)*/
        
    }

    override func viewDidLayoutSubviews()
    {
        let scrollViewBounds = movieDetailsScrollView.bounds
        let contentViewBounds = movieDetailsContainerView.bounds
        
        var scrollViewInsets = UIEdgeInsets.zero
        scrollViewInsets.top = scrollViewBounds.size.height - contentViewBounds.size.height
        
        /*scrollViewInsets.bottom = scrollViewBounds.size.height/2.0
        scrollViewInsets.bottom -= contentView.bounds.size.height/2.0;
        scrollViewInsets.bottom += 1*/
        
        movieDetailsScrollView.contentInset = scrollViewInsets
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
        
    
    

}
