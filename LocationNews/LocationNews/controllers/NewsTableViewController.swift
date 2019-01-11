//
//  NewsTableViewController.swift
//  LocationNews
//
//  Created by Kiko Santos on 10/01/19.
//  Copyright © 2019 Kiko Santos. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {

    var articles: [[String: AnyObject]]?
    var query: String!
    
    var spinnerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadNews(query: self.query)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_news", for: indexPath) as! NewsTableViewCell

        cell.titleLabel.text = articles?[indexPath.row][NewsApiClient.JSONResponseKeys.Title] as? String
        cell.descriptionLabel.text = articles?[indexPath.row][NewsApiClient.JSONResponseKeys.Description] as? String

        return cell
    }

    func loadNews(query: String) {
        self.spinnerView = UIViewController.displaySpinner(onView: self.view)
        NewsApiClient.sharedInstance().retrieveNews(query, completionHandlerForRetrieveNews: { (results, errorString) in
            UIViewController.removeSpinner(spinner: self.spinnerView)
            performUIUpdatesOnMain {
                if let results = results as? [String: AnyObject] {
                    if (results.count > 0) {
                        if let articlesResult = results[NewsApiClient.JSONResponseKeys.Articles] as? [[String: AnyObject]] {
                            if (articlesResult.count > 0) {
                                self.articles = articlesResult
                                self.tableView.reloadData()
                            }
                        }
                    }
                } else {
                    if let errorString = errorString {
                        GeneralUtilities.sharedInstance().displayError(errorString, self)
                    } else {
                        GeneralUtilities.sharedInstance().displayError("Unknown error", self)
                    }
                }
            }
        })
        
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToNewsDetailSegue" {
            let vc = segue.destination as! NewsDetailViewController
            if let indexRow = tableView.indexPathForSelectedRow?.row, let selectedArticle = articles?[indexRow] {
                vc.url = selectedArticle[NewsApiClient.JSONResponseKeys.Url] as? String
            }
        }
    }

}
