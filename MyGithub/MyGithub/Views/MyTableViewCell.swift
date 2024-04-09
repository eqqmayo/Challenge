//
//  MyTableViewCell.swift
//  MyGithub
//
//  Created by CaliaPark on 4/3/24.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    let repoNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    let repoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [repoNameLabel, repoDescriptionLabel])
        stview.axis = .vertical
        stview.spacing = 3
        stview.alignment = .leading
        stview.distribution = .fillProportionally
        return stview
    }()
    
    let repoLanguageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        
        self.contentView.addSubview(stackView)
        self.contentView.addSubview(repoLanguageLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        repoLanguageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.repoLanguageLabel.leadingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            repoLanguageLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            repoLanguageLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
}
