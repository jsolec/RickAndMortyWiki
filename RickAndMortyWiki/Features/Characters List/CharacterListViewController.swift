//
//  CharacterListViewController.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import UIKit

protocol CharacterListViewControllerDelegate: AnyObject {
    func characterListViewControllerDidRequestCharacter(withId id: Int)
}

class CharacterListViewController: UIViewController, CanPresentAlerts {
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    private var characterListViewModel: CharactersListViewModelInterface
    private let delegate: CharacterListViewControllerDelegate?
    
    private var viewData: [CharacterListInfoViewData] = []
    private var loading = LoadingView()
    
    private var isLoading = false
    
    required init(characterListViewModel: CharactersListViewModelInterface, delegate: CharacterListViewControllerDelegate?) {
        self.characterListViewModel = characterListViewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Disallowed the usage of this init.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.characterListViewModel.navigationTitle
        
        self.setupTableView()
        
        self.characterListViewModel.onCharactersRetrieved = { [weak self] characters in
            guard let self = self else { return }
            self.viewData.append(contentsOf: characters)
            self.reloadData()
        }
        
        self.characterListViewModel.onCharactersError = { [weak self] error in
            self?.presentInfoAlert(title: L10n.General.errorTitle, message: error, dismissTitle: L10n.General.ok)
        }
        
        self.characterListViewModel.onLoadingStatusChanged = { [weak self] isLoading in
            guard let self = self else { return }
            self.isLoading = isLoading
            if isLoading {
                self.loading.show(in: self.view)
            } else {
                self.loading.hide()
            }
        }

        
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.characterListViewModel.getCharacters()
    }
    
    private func setupTableView() {
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        self.tableView.estimatedRowHeight = 70
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(CharacterListCell.self, forCellReuseIdentifier: "CharacterListCell")
    }
    
    private func reloadData() {
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
    }
    
    @objc private func refresh(_ sender: Any) {
        self.refreshControl.beginRefreshing()
        self.characterListViewModel.getCharacters()
    }
}

//MARK: - UITableViewDelegate
extension CharacterListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.characterListViewControllerDidRequestCharacter(withId: self.viewData[indexPath.row].id)
    }
}

//MARK: - UITableViewDataSource
extension CharacterListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterListCell", for: indexPath) as! CharacterListCell
        cell.configure(viewData: self.viewData[indexPath.row])
        return cell
    }
}

//MARK: - UITableViewDataSourcePrefetching
extension CharacterListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollMargin: CGFloat = 50
        if scrollView.contentOffset.y > self.tableView.contentSize.height - scrollMargin - scrollView.frame.size.height {
            guard !self.isLoading else { return }
            self.characterListViewModel.getCharacters()
        }
    }
}
