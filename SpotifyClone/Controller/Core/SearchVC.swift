//
//  SearchVC.swift
//  SpotifyClone
//
//  Created by Warln on 27/03/22.
//

import UIKit

class SearchVC: UIViewController {
    private let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultVC())
        vc.searchBar.placeholder = "Albums,Artists,Tracks"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            // Items
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
            // Horizontal Group
            let Group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(150)),
                subitem: item,
                count: 2
            )
            Group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 2, bottom: 10, trailing: 2)
            let section = NSCollectionLayoutSection(group: Group)
            return section
        })
    )
    
    private var category: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        view.addSubview(collectionView)
        collectionView.register(CategoriesCollectionCell.self, forCellWithReuseIdentifier: CategoriesCollectionCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        APICaller.shared.getCategories { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let models):
                    self?.category = models.items
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
}

//MARK: - UISearchResultsUpdating
extension SearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultController = searchController.searchResultsController as? SearchResultVC,
              let query = searchController.searchBar.text , !query.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        print(query)
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultController = searchController.searchResultsController as? SearchResultVC,
              let query = searchBar.text , !query.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        resultController.delegate = self
        APICaller.shared.getSearch(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    resultController.update(with: results)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

//MARK: - SearchController Result
extension SearchVC: SearchResultVCDelegate {
    func didTapResult(result: SearchResult) {
        switch result {
        case .Album(let model):
            let vc = AlbumVC(albums: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .Playlist(let model):
            let vc = PlaylistVC(playlist: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .track(let model):
            break
        case .artist(let model):
            break
        }
    }
}

//MARK: - UICollectionView DataSource

extension SearchVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoriesCollectionCell.identifier,
            for: indexPath
        ) as? CategoriesCollectionCell else {
            return UICollectionViewCell()
        }
        let model = category[indexPath.row]
        cell.configure(with: CategoryViewModel(title: model.name, imgURl: URL(string: model.icons.first?.url ?? "")))
        return cell
    }
}

//MARK: - UICollectionView Delegate

extension SearchVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = CategoryVC(category: category[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
