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
    
    @IBOutlet weak var tableView: UITableView!
    
    private var characterListViewModel: CharactersListViewModelInterface
    private let delegate: CharacterListViewControllerDelegate?
    
    private var viewData: [CharacterListInfoViewData] = []
    private var loading = LoadingView()
    
    required init(characterListViewModel: CharactersListViewModelInterface, delegate: CharacterListViewControllerDelegate?) {
        self.characterListViewModel = characterListViewModel
        self.delegate = delegate
        
        super.init(nibName: "CharacterListViewController", bundle: .main)
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
            self?.viewData = characters
            self?.reloadData()
        }
        
        self.characterListViewModel.onCharactersError = { [weak self] error in
            self?.presentInfoAlert(title: L10n.General.errorTitle, message: error, dismissTitle: L10n.General.ok)
        }
        
        self.characterListViewModel.onLoadingStatusChanged = { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.loading.show(in: self.view)
            } else {
                self.loading.hide()
            }
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.characterListViewModel.getCharacters()
    }
    
    func setupTableView() {
        self.tableView.estimatedRowHeight = 70
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "CharacterListCell", bundle: nil), forCellReuseIdentifier: "CharacterListCell")
    }
    
    func reloadData() {
        self.tableView.reloadData()
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
