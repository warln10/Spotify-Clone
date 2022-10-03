//
//  CategoryVC.swift
//  SpotifyClone
//
//  Created by Warln on 23/05/22.
//

import UIKit

class CategoryVC: UIViewController {
    
    private let category: Category
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _ , _ -> NSCollectionLayoutSection in
            // Items
            let items = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            items.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            // Horizontal Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(250)
                ),
                subitem: items,
                count: 2
            )
            group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            // Section
            let section = NSCollectionLayoutSection(group: group)
            return section
        })
    )
    
    private var playlist: [Playlist] = []
    
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        title = "Category"
        collectionView.register(
            FeaturePlaylistCell.self,
            forCellWithReuseIdentifier: FeaturePlaylistCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        
        APICaller.shared.categoryPlaylist(category: category) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let models):
                    self?.playlist = models
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

//MARK: - CollectionViewDataSoucre

extension CategoryVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FeaturePlaylistCell.identifier,
                    for: indexPath
                ) as? FeaturePlaylistCell else {
            return UICollectionViewCell()
            
        }
        let model = playlist[indexPath.row]
        cell.configure(
            with: FeaturePlayViewModel(
                name: model.name,
                imageUrl: URL(string: model.images.first?.url ?? ""),
                createName: "")
        )
        return cell
    }
}

//MARK: - UICollectionView Delegate

extension CategoryVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = playlist[indexPath.row]
        let vc = PlaylistVC(playlist: model)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}


