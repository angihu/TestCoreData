//
//  ViewController.m
//  TestCoreData
//
//  Created by Winson on 14/11/10.
//  Copyright (c) 2014年 Fangdr. All rights reserved.
//

#import "InsertVC.h"
#import "User.h"


@interface InsertVC ()

@end

@implementation InsertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myAppdelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"modified hello world");
    NSLog(@"hello world");
}


- (IBAction)selectSex:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"男"]) {
        if (_wBtn.selected==YES) {
            _wBtn.selected=NO;
            sender.selected=YES;
            [_wBtn setImage:[UIImage imageNamed:@"checkno"] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"checkyes"] forState:UIControlStateNormal];
        }
        NSLog(@"男");
    }
    else
    {
        if (_mBtn.selected==YES) {
            _mBtn.selected=NO;
            sender.selected=YES;
            [_mBtn setImage:[UIImage imageNamed:@"checkno"] forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"checkyes"] forState:UIControlStateNormal];
        }
        NSLog(@"女");
    }
}

//清空
- (IBAction)clearAll:(UIButton *)sender {
    _nameTF.text=nil;
    _ageTF.text=nil;
    _phoneTF.text=nil;
}

#pragma mark
#pragma mark ------------------------数据库操作------------------------
//保存到数据库
- (IBAction)saveToDatabase:(UIButton *)sender {
    
    User *user=(User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.myAppdelegate.managedObjectContext];
    [user setName:_nameTF.text];
    [user setAge:[NSNumber numberWithInt:[_ageTF.text intValue]]];
    [user setPhone:[NSNumber numberWithLongLong:[_phoneTF.text longLongValue]]];
    if (_mBtn.selected) {
        [user setSex:_mBtn.currentTitle];
    }else
        [user setSex:_wBtn.currentTitle];
    NSError *error;
    BOOL isSaveSuccessed=[self.myAppdelegate.managedObjectContext save:&error];
    if (!isSaveSuccessed) {
        NSLog(@"Error:%@",error);
    }
    else
    {
        NSLog(@"Save successful!");
//        [self clearAll:nil];
//        [self.nameTF becomeFirstResponder];
        [self showMessageLB];
        [self performSelector:@selector(dismissMessageLB) withObject:self afterDelay:1.5];
        
    }
    
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"docPath=%@",docPath);
    
}

#pragma mark
//显示保存成功Label
-(void)showMessageLB
{
    self.messageLB.alpha=1;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    CGRect tmpRect=self.messageLB.frame;
    tmpRect.origin.y+=tmpRect.size.height;
    self.messageLB.frame=tmpRect;
    [UIView commitAnimations];
}
//隐藏保存成功的Label
-(void)dismissMessageLB
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    CGRect tmpRect=self.messageLB.frame;
    tmpRect.origin.y-=tmpRect.size.height;
    self.messageLB.alpha=0;
    self.messageLB.frame=tmpRect;
    [UIView commitAnimations];
    
}


















































































#pragma mark

//点击空白处回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"！！！！！！！！！！内存警告！！！！！！！！！！");
}

@end
