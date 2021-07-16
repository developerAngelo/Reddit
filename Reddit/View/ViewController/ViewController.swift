//
//  ViewController.swift
//  Reddit
//
//  Created by Angelo Acero on 5/9/21.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

final class ViewController: UIViewController, UISearchControllerDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel = CommunityViewModel()
    
    private var emptyView = CommunityViewModel()
    
    let searchText = BehaviorRelay<String>(value: "")
    
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        searchBarObserver()
        configureSubscription()
        filterCommunityData()
    }
    
    //Mark: - TableViewSetup..
    private func tableViewSetup(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75.0
    }
    
    //Mark: - Filter community post
    private func filterCommunityData(){
        emptyView.posts.accept(viewModel.posts.value)
        searchText.asObservable().subscribe(onNext: { query in
            var currentPosts = self.viewModel.posts.value
            currentPosts = currentPosts.filter{ post in
                return post.display_name_prefixed!.lowercased().contains(query.lowercased())
            }
            self.viewModel.posts.accept(currentPosts)
        }).disposed(by: disposeBag)
    }
    
    //Mark: - SearchBar Setup..
    private func searchBarObserver(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        searchController.searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe{ [weak self] query in
                guard let query = query.element else{return}
                self?.searchText.accept(query)
                if query == "" {
                    //Give back the old the after empty
                    guard let value = self?.emptyView.posts.value else {return}
                    self?.viewModel.posts.accept(value)
                }
            }.disposed(by: disposeBag)
    }
    
    //Mark: Configure Cell Display..
    private func configureSubscription(){
        tableView.register(UINib(nibName: "CommunityTableViewCell", bundle: nil), forCellReuseIdentifier: "CommunityTableViewCell")
        viewModel.posts.asObservable()
            .bind(to: tableView.rx.items){(tableView, row, post) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityTableViewCell",
                                                         for: IndexPath(row: row, section: 0)) as! CommunityTableViewCell
                cell.post = post
                return cell
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CommunityTableViewCellViewModel.self)
            .subscribe(onNext: { selected in
                if let communityPost = self.storyboard?.instantiateViewController(identifier: "web") as? CommunityPostViewController{
                    communityPost.redditPost = selected.display_name_prefixed
                self.navigationController?.pushViewController(communityPost, animated: true)
              }
            }).disposed(by: disposeBag)
    }
}
