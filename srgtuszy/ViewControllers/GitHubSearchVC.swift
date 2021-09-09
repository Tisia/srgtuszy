//
//  ViewController.swift
//  srgtuszy
//
//  Created by admin on 9/9/21.
//

import UIKit
import SafariServices

final class GitHubSearchVC: UIViewController {
    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let queryService = GitHubQueryService()
    private var repositoryResults: Repository?
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.delegate = self
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.placeholder = "Search keywords or qualifiers"
    }

    private func setupTableView() {
        let cellIdentifier = String(describing: RepositoryTableViewCell.self)
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
    private func loadRepositoriesData(search q: String) {
        queryService.getSearchResults(search: q) { (results) in
            switch results {
            case .success(let repositories):
                print(repositories.items)
                self.repositoryResults = repositories
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension GitHubSearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryResults?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepositoryTableViewCell.self)) as! RepositoryTableViewCell
        cell.setRepositoryItem(repositoryResults?.items[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let repository = repositoryResults?.items[indexPath.row],
              let repositoryURL = repository.htmlUrl else {
            return
        }
        
        let safariVC = SFSafariViewController(url: repositoryURL)
        self.present(safariVC, animated: true, completion: nil)
    }
}

extension GitHubSearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { (_) in
            self.loadRepositoriesData(search: searchText)
        })
    }
}

