//
//  MasterTableViewController.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/12/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit
import Alamofire
import ObjectMapper

class MasterTableViewController: UITableViewController {
    
    let model = MasterViewModel()
    
    let hud = ProgressHUD(text: "Sync".localized)
    
    var detailView: PostDetailViewController?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitViewController?.preferredDisplayMode = .allVisible
        
        tableView.allowsMultipleSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        prepareDetailView()
        prepareSearchBar()
        bond()
    }
    
    func prepareDetailView() {
        detailView = UIStoryboard(name: "PostDetail", bundle: nil).instantiateInitialViewController() as? PostDetailViewController
        splitViewController?.showDetailViewController(detailView!, sender: self)
    }
    
    func prepareSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.autocapitalizationType = .none
    }
    
    func bond() {
        model.title.bind(to: navigationItem.reactive.title)
        model.posts.bind(to: tableView, createCell: createCell)
        _ = model.postSyncing.observeNext(with: showIndicator)
        _ = model.selectedId.observeNext(with: updateSelected)
    }
    
    func updateSelected(id: Int) {
        detailView?.model.id.value = id
    }
    
    func showIndicator(active: Bool) {
        if active {
            if self.hud.superview == nil {
                UIApplication.shared.keyWindow!.addSubview(self.hud)
            }
        } else {
            self.hud.removeFromSuperview()
        }
    }
    
    func createCell(posts: [MasterViewModel.Post], indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuserIdentifier")
        
        let post = posts[indexPath.row]
        post.title.bind(to: cell.textLabel!.reactive.text).dispose(in: cell.bag)
        post.email.bind(to: cell.detailTextLabel!.reactive.text).dispose(in: cell.bag)
        
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.fetchPosts()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.selectedId.value = model.posts.value[indexPath.row].id.value
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            tableView.beginUpdates()
            self.model.removePost(id: self.model.posts.value[indexPath.row].id.value)
            tableView.deleteRows(at: [indexPath], with: .top)
            self.model.selectedId.value = -1
            tableView.endUpdates()
            
        })
        return [deleteAction]
    }
}

extension MasterTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        model.filter.value = searchController.searchBar.text ?? ""
    }
}
