//
//  AlbumTrackCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Warln on 08/05/22.
//

import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumTrackCollectionViewCell"
    
    private let TrackNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20, weight: .semibold)
        return lbl
    }()
    
    private let artistNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15, weight: .thin)
        return lbl
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(TrackNameLbl)
        contentView.addSubview(artistNameLbl)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        TrackNameLbl.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.width - 15,
            height: contentView.height/2
        )
        
        artistNameLbl.frame = CGRect(
            x: 10,
            y: contentView.height/2,
            width: contentView.width-15,
            height: contentView.height/2
        )

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.TrackNameLbl.text = nil
        self.artistNameLbl.text = nil
    }
    
    func configure(with viewModel: AlbumCollectionViewModel ) {
        TrackNameLbl.text = viewModel.name
        artistNameLbl.text = viewModel.artistName
    }
}
