//
//  UpdateVC.h
//  TestCoreData
//
//  Created by Winson on 14/11/11.
//  Copyright (c) 2014年 Fangdr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "User.h"

@interface UpdateVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *optionsTF;//字段名


@property (weak, nonatomic) IBOutlet UITextField *resultTF;//字段的值

@property (weak, nonatomic) IBOutlet UITextField *nResultTF;//要修改的新值

@property (weak, nonatomic) IBOutlet UILabel *messageLB;//提示文字







@property(strong,nonatomic)AppDelegate *myAppdelegate;
@end
