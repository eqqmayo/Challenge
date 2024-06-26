//
//  ViewController.swift
//  MyGithub
//
//  Created by CaliaPark on 4/2/24.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {
    
    var profile = Profile(name: "길동이", avatarURL: "https://avatars.githubusercontent.com/u/144116848?v=4", location: "한양", followers: 123, following: 456)
    var repositories: [Repository] = []
    let dataManager = DataManager()
    
    var page = 1
    var loadMore = true
    
    lazy var profileView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        [profileImageView, nameStackView, detailStackView].forEach { view.addSubview($0) }
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var profileNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    let profileIdLabel: UILabel = {
        let label = UILabel()
        label.text = "eqqmayo"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return label
    }()
    
    lazy var nameStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [profileNameLabel, profileIdLabel])
        stview.spacing = 1
        stview.axis = .vertical
        stview.distribution = .fillProportionally
        stview.alignment = .fill
        return stview
    }()
    
    let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size.width = 20
        imageView.frame.size.height = 20
        imageView.image = UIImage(systemName: "mappin")
        imageView.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return imageView
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    lazy var locationStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [locationImageView, locationLabel])
        stview.spacing = 5
        stview.axis = .horizontal
        stview.distribution = .fill
        stview.alignment = .fill
        return stview
    }()
    
    let followImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size.width = 15
        imageView.frame.size.height = 15
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return imageView
    }()
    
    lazy var nFollowersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "followers∙"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return label
    }()
    
    lazy var nFollowingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.text = "following"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return label
    }()
    
    lazy var followStackView1: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [nFollowersLabel, followersLabel, nFollowingLabel, followingLabel])
        stview.spacing = 3
        stview.axis = .horizontal
        stview.distribution = .fill
        stview.alignment = .fill
        return stview
    }()
    
    lazy var followStackView2: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [followImageView, followStackView1])
        stview.spacing = 5
        stview.axis = .horizontal
        stview.distribution = .fill
        stview.alignment = .fill
        return stview
    }()
    
    lazy var detailStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [locationStackView, followStackView2])
        stview.spacing = 8
        stview.axis = .vertical
        stview.distribution = .fill
        stview.alignment = .leading
        return stview
    }()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.8983306289, green: 0.9440698028, blue: 0.9655331969, alpha: 1)
        setupLayout()
        setupTableView()
        Task {
            await updateData()
            }
    }
    
    func updateData() async {
        await dataManager.callAPI()
        profile = dataManager.getProfile()
        repositories = dataManager.getRepository()
        self.setData()
    }
    
    func setData() {
        tableView.reloadData()
        profileNameLabel.text = profile.name
        locationLabel.text = profile.location
        nFollowersLabel.text = "\(profile.followers)"
        nFollowingLabel.text = "\(profile.following)"
        profileImageView.kf.setImage(with: URL(string: profile.avatarURL))
    }

    func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "MyCell")

    
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshFunc), for: .valueChanged)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
        ])
    }
    
    @objc func refreshFunc() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func setupLayout() {
        
        view.addSubview(profileView)
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            profileView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            profileView.heightAnchor.constraint(equalToConstant: 270),
            
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            
            
            nameStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant:20),
            nameStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            detailStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            detailStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant:15)
        ])
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyTableViewCell
        cell.repoNameLabel.text = repositories[indexPath.row].name
        cell.repoDescriptionLabel.text = repositories[indexPath.row].description
        cell.repoLanguageLabel.text = repositories[indexPath.row].language ?? "None"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        130
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y > (tableView.contentSize.height - tableView.bounds.size.height) {
            if loadMore { beginLoadMore() }
        }
    }
        
    func beginLoadMore() {
        Task {
            await Task.sleep(700_000_000)
            self.page += 1
            self.dataManager.parameter["page"] = String(self.page)
            do {
                let newRepositories = try await self.dataManager.fetchRepositories(url: self.dataManager.urlExtraRepo, parameters: self.dataManager.parameter)
                DispatchQueue.main.async {
                    self.repositories.append(contentsOf: newRepositories)
                    self.tableView.reloadData()
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}




