//
//  DeleteVC.h
//  TestCoreData
//
//  Created by Winson on 14/11/11.
//  Copyright (c) 2014年 Fangdr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "User.h"

@interface DeleteVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *optionsTF;//字段名

@property (weak, nonatomic) IBOutlet UITextField *resultTF;//字段名中对应的值





@property(strong,nonatomic)AppDelegate *myAppdelegate;
@end
