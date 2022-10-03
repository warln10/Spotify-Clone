//
//  SearchResultVC.swift
//  SpotifyClone
//
//  Created by Warln on 15/05/22.
//

import UIKit

struct SearchSection {
    let title: String
    let result: [SearchResult]
}

protocol SearchResultVCDelegate: AnyObject {
    func didTapResult(result: SearchResult)
}

class SearchResultVC: UIViewController {
    
    private var tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .grouped)
        t.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        t.backgroundColor = .systemBackground
        t.isHidden = true
        return t
    }()
    private var sections: [SearchSection] = []
    
    weak var delegate: SearchResultVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with result: [SearchResult]) {
        let artist = result.filter({
            switch $0 {
            case .artist:
                return true
            default:
                return false
            }
        })
        
        let track = result.filter({
            switch $0 {
            case .track:
                return true
            default:
                return false
            }
        })
        let playlist = result.filter({
            switch $0 {
            case .Playlist:
                return true
            default:
                return false
            }
        })
        let album = result.filter({
            switch $0 {
            case .Album:
                return true
            default:
                return false
            }
        })
        self.sections = [
            SearchSection(title: "Song", result: track),
            SearchSection(title: "Artist", result: artist),
            SearchSection(title: "Playlist", result: playlist),
            SearchSection(title: "Albums", result: album)
        ]
        tableView.reloadData()
        tableView.isHidden = result.isEmpty
    }
    

}

//MARK: - UItableView DataSource

extension SearchResultVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let result = sections[indexPath.section].result[indexPath.row]
        switch result {
        case .Album(let model):
            cell.textLabel?.text = model.name
        case .Playlist(let model):
            cell.textLabel?.text = model.name
        case .track(let model):
            cell.textLabel?.text = model.name
        case .artist(let model):
            cell.textLabel?.text = model.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}

//MARK: - UItableView Delegate

extension SearchResultVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].result[indexPath.row]
        delegate?.didTapResult(result: result)
    }
}
