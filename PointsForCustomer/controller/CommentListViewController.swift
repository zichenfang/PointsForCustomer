//
//  CommentListViewController.swift
//  PointsForCustomer
//
//  Created by 殷玉秋 on 2017/9/29.
//  Copyright © 2017年 fff. All rights reserved.
//

import UIKit

class CommentListViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate{
    @IBOutlet var tableView: UITableView!
    @IBOutlet var shopNameLabel: UILabel!
    @IBOutlet var commentCountLabel: UILabel!
    convenience init() {
        self.init(nibName: "CommentListViewController", bundle: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "评价";
        tableView.register(UINib.init(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "comment");
        shopNameLabel.text = "鹏鹏烧烤店"
        commentCountLabel.text = "21" + "评价"
    }
    //    MARK:UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :CommentTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentTableViewCell;
        //测试 只有图
        if indexPath.row%3 == 0 {
            cell.insertImagesViewHeight.constant = SCREEN_WIDTH * 0.2
            cell.commentLabel.text = nil
        }
            //只有文字
        else if indexPath.row%3 == 1
        {
            cell.insertImagesViewHeight.constant = 0
            cell.commentLabel.text = "我们可以在构造器中为存储型属性设置初始值；同样，也可以在属性声明时为其设置默认值。我们可以在构造器中为存储型属性设置初始值；同样，也可以在属性声明时为其设置默认值。我们可以在构造器中为存储型属性设置初始值；同样，也可以在属性声明时为其设置默认值。我们可以在构造器中为存储型属性设置初始值；同样，也可以在属性声明时为其设置默认值。"
        }
            //图文都有
        else{
            cell.insertImagesViewHeight.constant = SCREEN_WIDTH * 0.2
            cell.commentLabel.text = "我们可以在构造器中为存储型属性设置初始值；同样，也可以在属性声明时为其设置默认值。我们可以在构造器中为存储型属性设置初始值；同样，也可以在属性声明时为其设置默认值。我们可以在构造器中为存储型属性设置初始值；同样，也可以在属性声明时为其设置默认值。我们可以在构造器中为存储型属性设置初始值；同样，也可以在属性声明时为其设置默认值。"
        }
        return cell!;
        
    }
    //    MARK:UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let comment = "我们可以在构造器中为存储型属性设置初始值；同样，也可以在属性声明时为其设置默认值。我们可以在构造器中为存储型属性设置初始值；同样，也可以在属性声明时为其设置默认值。我们可以在构造器中为存储型属性设置初始值；同样，也可以在属性声明时为其设置默认值。我们可以在构造器中为存储型属性设置初始值；同样，也可以在属性声明时为其设置默认值。"
        //测试 只有图
        if indexPath.row%3 == 0 {
            return 74 + SCREEN_WIDTH * 0.2 + 15
        }
            //只有文字
        else if indexPath.row%3 == 1
        {
            return 74 + comment.heightWithFountAndWidth(font: UIFont.systemFont(ofSize: 14), width: SCREEN_WIDTH - 10*2) + 15
        }
            //图文都有
        else{
            return 74 + SCREEN_WIDTH * 0.2 + comment.heightWithFountAndWidth(font: UIFont.systemFont(ofSize: 14), width: SCREEN_WIDTH - 10*2) + 15
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
