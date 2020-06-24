//
//  ViewController.swift
//  RxZhihuDaily
//
//  Created by 陈浩宇 on 2020/6/23.
//  Copyright © 2020 陈浩宇. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import HYSwift
import SDWebImage

final class HomeViewController: UIViewController, Routable {
    
    let viewmodel = HomeViewModel()
    let tableView = UITableView.create()

    override func viewDidLoad() {
        super.viewDidLoad()
        Router.shared.register(aClass: StoryDetailViewController.self, for: "detail")
        view.addSubview(tableView)
        tableView.register(StoryTableViewCell.self)
        tableView.rowHeight =  104
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        bind()
        
        viewmodel.fetchLatest()
        
        tableView.rx.modelSelected(Story.self)
        .map{ $0.id }
        .subscribe(onNext: {id in
            guard let id = id else {
                return
            }
            Router.shared.open(url: URL(string: "detail://"), params:["StoryID": id])
        }).disposed(by: bag)

    }
    
    func bind() {
        viewmodel.stories.bind(to: tableView.rx.items(cellIdentifier: String(describing: StoryTableViewCell.self))) { row, story, cell in
            let cell = cell as! StoryTableViewCell
            cell.titleLabel.text = story.title
            cell.subTitleLabel.text = story.hint
            cell.imgView.sd_setImage(with: URL(string: story.images?[0] ?? ""))
        }.disposed(by: bag)
    }
    
    convenience init(params: [String : Any]) {
        self.init(nibName: nil, bundle: nil)
    }
}