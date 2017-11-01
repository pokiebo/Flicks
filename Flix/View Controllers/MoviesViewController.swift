//
//  ViewController.swift
//  Flix
//
//  Created by Sudipta Bhowmik on 9/28/17.
//  Copyright © 2017 Sudipta Bhowmik. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating {
    
    //MARK - Outlets
    //===================
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var NetworkErrView: UIView!
    @IBOutlet weak var moviesSegmentedCtrl: UISegmentedControl!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    //MARK - Variables
    //===================
    var moviesResponse : [NSDictionary] = []
    var total_results : Int = 0
    var FlixMovieArray : [FlixMovie]? {
        didSet {
            updateTableView()
            updateCollectionView()
        }
    }
    var endpoint : String = ""
    var isTableView = true
    var searchingMoviesArray : [FlixMovie]? = []
    
    //Controls
    let moviesSearchController = UISearchController(searchResultsController: nil)
    //===================
    
    //MARK - Functions
    //===================
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Set up the table view
        setupTableView()
        
        //Setup Collection View
        setupCollectionView()
        
        //Set up the UI refresh Control
        setupRefreshControl()
        
        //Set up the navigation Bar attributes
        SetNavBarAttributes()
        
        //Set Up Segmented Control
       // moviesSegmentedCtrl.removeBorders()
        
        
        
        //Load data
        loadData()
        
    }

    func setupTableView()  {
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.rowHeight = 150
        //self.moviesTableView.tableHeaderView = self.moviesSearchController.searchBar
        
    }
    
    func setupCollectionView() {
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
    }
    
    func SetNavBarAttributes() {
       // self.navigationItem.title = "Flix"
        
       // self.navigationController?.navigationBar.barTintColor = UIColor.white
      //  self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.red, NSAttributedStringKey.font : UIFont(name: "Chalkduster"
         //   , size: 25.0)!]
        
        //This is to remove the 1px border under the navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
   
        //Set up the search controller
        self.moviesSearchController.searchResultsUpdater = self
        self.moviesSearchController.obscuresBackgroundDuringPresentation = false
        self.moviesSearchController.searchBar.backgroundColor = UIColor.orange
        self.moviesSearchController.searchBar.alpha = 1.0
        self.moviesSearchController.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = moviesSearchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        self.moviesTableView.addSubview(refreshControl)
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        loadData()
            
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
   
    }
    
    func updateTableView() {
        moviesTableView.reloadData()
    }
    
    func updateCollectionView() {
        moviesCollectionView.reloadData()
    }
    
    func DisplayViewLayout() {
        if self.isTableView {
            self.moviesTableView.isHidden = false
            self.moviesCollectionView.isHidden = true
            self.moviesTableView.reloadData()
        } else {
            self.moviesTableView.isHidden = true
            self.moviesCollectionView.isHidden = false
            self.moviesCollectionView.reloadData()
        }
    }
    func isSearchControllerEmpty() -> Bool {
        return moviesSearchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(searchText: String) {
        
        self.searchingMoviesArray = FlixMovieArray?.filter({ (flixMovie : FlixMovie) -> Bool in
            
            if (flixMovie.title.lowercased().contains(searchText.lowercased())) {
                return true
            } else {
                return false
            }
        })
        //print (self.searchingMoviesArray?.count)
        moviesTableView.reloadData()
    }
    
    func isSearching() -> Bool {
        return (moviesSearchController.isActive && !isSearchControllerEmpty())
    }
    
    func loadData() {
        
        //Show the HUD
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        print("endpt is : \(endpoint)")
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let error = error {
                    print ("error")
                    print(error.localizedDescription)
                    self.NetworkErrView.isHidden = false
                    //Hide the HUD
                    MBProgressHUD.hide(for: self.view, animated: false)
                }
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                        // This is how we get the 'results' field
                        self.moviesResponse = responseDictionary["results"] as! [NSDictionary]
                        
                        //Copy the response Dictionary items to the FlixMovieArray
                        self.FlixMovieArray = self.moviesResponse.map{FlixMovie(movieDict: $0)}
                        
                        //Get the total number of results
                        self.total_results = responseDictionary["total_results"] as! Int
                        
                        //Hide the HUD
                        MBProgressHUD.hide(for: self.view, animated: false)
                        
                        //Display the appropriate layout i.e grid or list
                        self.DisplayViewLayout()
                        
                    }
                }
                
        });
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
//PROTOCOL STUBS
    
    //MARK:- Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (isSearching()) {
            return searchingMoviesArray?.count ?? 0
        } else {
            return FlixMovieArray?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MoviesTableViewCell
        
        if (isSearching()) {
            
            cell.flixMovie = self.searchingMoviesArray?[indexPath.row]
        } else {
            cell.flixMovie = self.FlixMovieArray?[indexPath.row]
        }
        return cell
    }
    
    //MARK:- Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FlixMovieArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionViewCell", for: indexPath) as! moviesCollectionViewCell
        collectionViewCell.flixMovie = self.FlixMovieArray?[indexPath.row]
        return collectionViewCell
        
    }
    
    //MARK:- UISearchController
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        
    }
    
    
//DELEGATES
    @IBAction func SegmentSelected(_ sender: UISegmentedControl) {
        switch moviesSegmentedCtrl.selectedSegmentIndex {
        case 0:
            isTableView = true
    
        case 1:
            isTableView = false
            
        default:
            break
        }
        
        loadData()
    }
    
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let movieDetailsVC = segue.destination as! MovieDetailsViewController
        let indexPath = moviesTableView.indexPath(for: sender as! UITableViewCell)
        
        movieDetailsVC.flixMovie = FlixMovieArray?[(indexPath?.row)!]
        
    }
}



extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: frame.size.width/2, height: 30.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}

