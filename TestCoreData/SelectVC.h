//
//  SelectVC.h
//  TestCoreData
//
//  Created by Winson on 14/11/11.
//  Copyright (c) 2014年 Fangdr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "User.h"

@interface SelectVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *optionsTF;//查询的字段名

@property (weak, nonatomic) IBOutlet UITextField *resultTF;//字段名对应的值







@property(strong,nonatomic)AppDelegate *myAppdelegate;

@end
