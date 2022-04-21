//
//  CharacterListViewController.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import UIKit

class CharacterListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var characterListViewModel: CharactersListViewModel?
    private var viewData: [CharacterListInfoViewData] = []
    
    required init(characterListViewModel: CharactersListViewModel) {
        self.characterListViewModel = characterListViewModel
        super.init(nibName: "CharacterListViewController", bundle: .main)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Disallowed the usage of this init.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.characterListViewModel?.navigationTitle
        
        self.setupTableView()
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
