//
//  ViewController.swift
//  fptech
//
//  Created by Pankaj Verma on 08/01/19.
//  Copyright © 2019 Pankaj Verma. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    let  cellIdentifier = "NewsTableViewCell";
    
    var pageUrl = "https://newsapi.org/v2/top-headlines?country=us&category=technology&apiKey=a8fabd9ff4234c82aad08eaaa4ea17a0&pageSize=5&page="
    var newsUrlString:String?
    var page:Int = 1{
        willSet(nextPage) {
            newsUrlString = "\(pageUrl)\(nextPage)"
        }
        
    }
    
    var totalNews = 0;
    var newsData: [NewsModel] = []{
        didSet {
            tableView.reloadData()
        }
    }
    var refreshControl = UIRefreshControl()
    lazy var coreDataManager:CoreDataManager = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsUrlString = "\(pageUrl)1" //first page
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        tableView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false;
        
        loadNews()
    }
    
    
    @objc func refresh(sender:AnyObject) {
        let dispatchGroup = DispatchGroup()
        for  n in 1...page{
            dispatchGroup.enter()
            refreshPage(page: n, completion: {
                dispatchGroup.leave()
            })
        }
        dispatchGroup.notify(queue: .main){
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        
    }
    
    
    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NewsTableViewCell
        cell.configure(with: newsData[indexPath.row])
        cell.onClicked = {urlString in
            let detailsVC = DetailsViewController()
            detailsVC.urlString = urlString
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
        return cell;
    }
    
    //MARK:- UITableViewDelegate : paginated loading
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == newsData.count - 1 && newsData.count < totalNews {
            //last cell, load more...
            page += 1;
            loadNews()
        }
    }
    
    
    func loadNews() -> Void {
        guard let newsUrlString = newsUrlString else {return}
        guard let newsUrl = URL(string: newsUrlString) else { return }
        //fetch from core data, if found return
        if let data = coreDataManager.fetchNewsDataForPageNumber(page){
            processData(data: data)
            return
        }
        URLSession.shared.dataTask(with: newsUrl) {[unowned self] (data, response
            , error) in
            guard let data = data else { return }
            //save in core data
            DispatchQueue.main.async {
                self.coreDataManager.saveNewsData(data: data, pageNumber: self.page)
            }
            self.processData(data: data)
            }.resume()
    }
    func refreshPage(page:Int,  completion:@escaping ()->())  {
        let urlString = "\(pageUrl)\(page)"
        guard let newsUrl = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: newsUrl) {[unowned self] (data, response
            , error) in
            //save in core data
            DispatchQueue.main.async {[unowned self] in
                guard let data = data else { return }
                self.processData(data: data)
                self.coreDataManager.saveNewsData(data: data, pageNumber: self.page)
                completion()
            }
            }.resume()
    }
    
    func processData(data:Data){
        do {
            let decoder = JSONDecoder()
            let dt = try decoder.decode(Root.self, from: data)
            DispatchQueue.main.async { [unowned self] in
                if let news = dt.articles{
                    self.newsData.append(contentsOf: news)
                }
                
                if let count = dt.totalResults {
                    self.totalNews = count
                }
            }
        } catch let err {
            print("Err", err)
        }
    }
}



