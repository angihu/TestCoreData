//
//  ViewController.h
//  TestCoreData
//
//  Created by Winson on 14/11/10.
//  Copyright (c) 2014年 Fangdr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface InsertVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTF;//姓名
@property (weak, nonatomic) IBOutlet UIButton *mBtn;//男
@property (weak, nonatomic) IBOutlet UIButton *wBtn;//女
@property (weak, nonatomic) IBOutlet UITextField *ageTF;//年龄
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;//电话

@property (weak, nonatomic) IBOutlet UILabel *messageLB;//保存成功提示框




@property(strong,nonatomic)AppDelegate *myAppdelegate;



@end

