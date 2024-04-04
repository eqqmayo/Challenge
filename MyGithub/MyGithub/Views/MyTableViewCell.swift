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
        
        self.contentView.addSubview(repoNameLabel)
        self.contentView.addSubview(repoLanguageLabel)
        
        repoNameLabel.translatesAutoresizingMaskIntoConstraints = false
        repoLanguageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            repoNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            repoNameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            repoLanguageLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            repoLanguageLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
}
