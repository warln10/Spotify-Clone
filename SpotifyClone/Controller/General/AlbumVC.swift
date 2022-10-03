//
//  AlbumViewController.swift
//  SpotifyClone
//
//  Created by Warln on 18/04/22.
//

import UIKit

class AlbumVC: UIViewController {
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _ , _ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
            // Vertical And Horizontal Group
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
                subitem: item,
                count: 1
            )
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalWidth(1)
                    ),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
            ]
            return section
        })
    )
    
    private let albums: Albums
    private var viewModel: [AlbumCollectionViewModel] = []
    
    init(albums: Albums) {
        self.albums = albums
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = albums.name
        view.addSubview(collectionView)
        setup()
        collectionView.register(AlbumTrackCollectionViewCell.self, forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier)
        collectionView.register(
            CollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CollectionHeaderView.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // API Setup
    func setup() {
        APICaller.shared.getAblumDetails(for: albums) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.viewModel = model.tracks.items.compactMap({
                        AlbumCollectionViewModel(
                            name: $0.name,
                            artistName: $0.artists.first?.name ?? "Unknown"
                        )
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

//MARK: - UICollectionView Datasource

extension AlbumVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumTrackCollectionViewCell.identifier, for: indexPath) as? AlbumTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CollectionHeaderView.identifier,
            for: indexPath
        ) as? CollectionHeaderView,
              kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let headerViewModel = HeaderViewModel(
            name: albums.name,
            description: "Release Date: \(String.formattedDate(with: albums.release_date)) ",
            artist: albums.artists.first?.name ?? "Unknown",
            image: URL(string: albums.images.first?.url ?? "")
        )
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }
    
}

//MARK: - UICollectionView Delegate

extension AlbumVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


//MARK: - Collection HeaderView Delegate

extension AlbumVC: CollectionHeaderViewDelegate {
    func CollectionHeaderViewDidTapPlayAll(_ header: CollectionHeaderView) {
        print("Play All")
    }
}

