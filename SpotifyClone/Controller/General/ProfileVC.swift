//
//  ProfileVC.swift
//  SpotifyClone
//
//  Created by Warln on 29/03/22.
//

import UIKit
import SDWebImage

class ProfileVC: UIViewController {
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        return table
    }()
    
    private var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        fetchProfile()
    }
    
    
    private func fetchProfile() {
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            switch result {
            case .success(let title):
                DispatchQueue.main.async {
                    self?.updateUi(with: title)
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                
                
            }
        }
    }
    
    private func updateUi(with model: UserProfileResponse) {
        tableView.isHidden = false
        models.append("Id: \(model.id)")
        setTableHeader(with: model.images.first?.url, with: model.display_name)
        tableView.reloadData()
    }
     // settting header view
    private func setTableHeader(with Img: String?, with name : String ) {
        
        guard let urlString = Img, let url = URL(string: urlString) else {return}
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width / 1.5))
        let imageSize = headerView.height / 2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.center = headerView.center
        imageView.layer.cornerRadius = imageSize / 2
        imageView.layer.masksToBounds = true
        imageView.sd_setImage(with: url, completed: nil)
        let label = UILabel()
        label.frame = CGRect(x: imageView.left - 30, y: imageView.bottom + 15, width: imageSize + 50, height: 25)
        label.text = name
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        headerView.addSubview(label)
        tableView.tableHeaderView = headerView
        
    }
    
    private func failedToGetProfile () {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile"
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
    
}

//MARK: - UITableView DataSource
extension ProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}

//MARK: - UITableView Delegate
extension ProfileVC: UITableViewDelegate {
    
}
