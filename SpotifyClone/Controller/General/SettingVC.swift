//
//  SettingVC.swift
//  SpotifyClone
//
//  Created by Warln on 29/03/22.
//

import UIKit

class SettingVC: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var sections = [Setting]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configure(){
        sections.append(Setting(titles: "Profile", options: [Options(titles: "View your profile", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.viewProfile()
            }
        })]))
        sections.append(Setting(titles: "Account", options: [Options(titles: "Sign Out", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.viewLogOut()
            }
        })]))
        
    }
    
    private func viewLogOut () {
        
    }
    
    private func viewProfile () {
        let vc = ProfileVC()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    

}

//MARK: - UItableView DataSource
extension SettingVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = sections[indexPath.section].options[indexPath.row].titles
        cell.textLabel?.text = model
        return cell
    }
}
//MARK: - UITableView Delegate
extension SettingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section].titles.capitalziedFirst()
        return model
    }
}
