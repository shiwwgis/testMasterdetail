//
//  MasterViewController.swift
//  testMasterdetail
//
//  Created by shiweiwei on 16/3/5.
//  Copyright © 2016年 shiweiwei. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var siteNames: [String]?
    var siteAddresses: [String]?
    var siteLists: [String]?
    
    private var listImg=["master1","master2","master3"];

    
    
    var maillistViewController: MailListViewController? = nil
    var objects = [AnyObject]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        siteNames = ["网易", "百度", "Apple"]
        siteLists = ["新闻","科技","财经","搜索","地图","百科","iPad","iPhone","Mac"]
        siteAddresses = ["http://news.163.com","http://tech.163.com","http://auto.163.com" ,"http://www.baidu.com", "http://map.baidu.com","http://baike.baidu.com","http://www.apple.com/ipad", "http://www.apple.com/ipone","http://www.apple.com/mac"]
        
        siteNames?.appendContentsOf(siteNames!);
        siteLists?.appendContentsOf(siteLists!);
        siteAddresses?.appendContentsOf(siteAddresses!);

        siteNames?.appendContentsOf(siteNames!);
        siteLists?.appendContentsOf(siteLists!);
        siteAddresses?.appendContentsOf(siteAddresses!);

        siteNames?.appendContentsOf(siteNames!);
        siteLists?.appendContentsOf(siteLists!);
        siteAddresses?.appendContentsOf(siteAddresses!);
        
        for index in 0...siteNames!.count-1
        {
            siteNames![index]=siteNames![index]+"--\(index+1)";
        }

        //1.加左边按钮
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        //2.加右边按钮
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        
//        //3.创建Header
//        //创建表头标签
//        let headerLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, 30))
//        headerLabel.backgroundColor = UIColor.blackColor()
//        headerLabel.textColor = UIColor.whiteColor()
//        headerLabel.numberOfLines = 0
//        headerLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        headerLabel.text = "高级 UIKit 控件"
//        headerLabel.font = UIFont.italicSystemFontOfSize(20)
//        self.tableView!.tableHeaderView = headerLabel
        
        self.maillistViewController = MailListViewController();
        
/*        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }*/
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed;
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("here");
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let urlString = siteAddresses?[indexPath.row]
                
                let controller = (segue.destinationViewController
                    as! UINavigationController).topViewController
                    as! DetailViewController
                
                controller.detailItem = urlString
                controller.navigationItem.leftBarButtonItem =
                    splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        
        //显示二级目录
        if segue.identifier == "ShowMaillist" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let i = indexPath.row*3;
                
                var mailList=[String]();
                var urlList=[String]();
                
                for index in i...i+2
                {
                    mailList.append(self.siteLists![index]);
                    urlList.append(self.siteAddresses![index]);
                }

                
                let controller = (segue.destinationViewController
                    as! UINavigationController).topViewController
                    as! MailListViewController;
                
                controller.mailList = mailList;
                controller.urlList = urlList;
                
                controller.navigationItem.leftBarButtonItem =
                    splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }

    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("master count=\(siteNames!.count)");
        var count:Int=1;
        if section==0 //第一节
        {
            count=3;
        }
        else //第二节
        {
            count=siteNames!.count-3;
        }
        return count;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
         cell.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator;

        let section=indexPath.section;
        
        if section==0
        {
            cell.textLabel!.text = siteNames![indexPath.row]
            
            cell.detailTextLabel!.text="\(indexPath.row+1)";
            
            if indexPath.row==1
            {
                cell.accessoryType=UITableViewCellAccessoryType.DetailDisclosureButton
            }
        }
        else
        {
            cell.textLabel!.text = siteNames![indexPath.row+3]
            
            cell.detailTextLabel!.text="\(indexPath.row+4)";

        }
        
        let imgIndex=indexPath.row%3
        
        cell.imageView?.image=UIImage(named: listImg[imgIndex]);
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    // UITableViewDelegate协议方法，点击时调用
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
 /*       // 跳转到detailViewController，取消选中状态
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        //更具定义的Segue Indentifier进行跳转
        self.performSegueWithIdentifier("ShowMaillist", sender: siteLists![indexPath.row])*/
        
        if indexPath.row >= 0
        {
            self.maillistViewController?.hidesBottomBarWhenPushed=true;
            let i = indexPath.row*3;
            
            var mailList=[String]();
            var urlList=[String]();
            
            for index in i...i+2
            {
                mailList.append(self.siteLists![index]);
                urlList.append(self.siteAddresses![index]);
            }
            
            maillistViewController!.urlList=urlList;
            
            maillistViewController!.mailList = mailList;
            

            //隐藏导航栏
            self.navigationController?.pushViewController(maillistViewController!, animated: true);
            
            self.maillistViewController?.refresh();

        }
    }
    
    //设置2个分区
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }
    
    // UITableViewDataSource协议中的方法，该方法的返回值决定指定分区的Header文字信息
    override func tableView(tableView:UITableView, titleForHeaderInSection
        section:Int)->String?
    {
        var str:String?;//="TEST";
        if section>0
        {
            str="邮箱";
        }
        return str;

    }
    
    // UITableViewDataSource协议中的方法，该方法的返回值决定指定分区的尾部
    override func tableView(tableView:UITableView, titleForFooterInSection
        section:Int)->String?
    {
        var str:String?;
        if section==1
        {
            str = "刚刚更新";
        }
        return str;
    }
    
    
}

