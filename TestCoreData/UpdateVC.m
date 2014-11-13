//
//  UpdateVC.m
//  TestCoreData
//
//  Created by Winson on 14/11/11.
//  Copyright (c) 2014年 Fangdr. All rights reserved.
//

#import "UpdateVC.h"

@interface UpdateVC ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_detailsArray;
}
@end

@implementation UpdateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _myAppdelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    _detailsArray=[[NSMutableArray alloc]init];

    [self selectAllRecords];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//展开下拉列表
- (IBAction)showOptions:(UIButton *)sender {
    self.resultTF.text=nil;
    self.nResultTF.text=nil;
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"选择字段"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"name",@"sex",@"age",@"phone", nil];
    [actionSheet showInView:self.view];
}

//修改
- (IBAction)updateRecord:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    //获取表
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.myAppdelegate.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //查询条件《正则表达式》
    NSPredicate *predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == '%@'",self.optionsTF.text,self.resultTF.text]];
    [fetchRequest setPredicate:predicate];
    
    //查询结果
    NSError *error=nil;
    NSMutableArray *mutableFetresult=[[self.myAppdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if (mutableFetresult==nil) {
        NSLog(@"Error=%@",error);
    }
    else
    {
        if (mutableFetresult.count==0) {
//            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"查询结果" message:@"对不起，没有找到你要的值，无法替换。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alertView show];
            
            self.messageLB.alpha=1;
            self.messageLB.backgroundColor=[UIColor redColor];
            self.messageLB.text=@"不存在该值";
            [self performSelector:@selector(dismissMessageLB) withObject:self afterDelay:0.5];
            [self.tableView reloadData];
        }
        else
        {
            NSLog(@"count=%d",(int)mutableFetresult.count);
            
            for (User *user in mutableFetresult) {
                if ([self.optionsTF.text isEqualToString:@"name"]) {
                    [user setName:self.nResultTF.text];
                }
                else if ([self.optionsTF.text isEqualToString:@"sex"])
                {
                    [user setSex:self.nResultTF.text];
                }
                else if ([self.optionsTF.text isEqualToString:@"age"])
                {
                    [user setAge:[NSNumber numberWithInt:[self.nResultTF.text intValue]]];
                }
                else if([self.optionsTF.text isEqualToString:@"phone"])
                {
                    [user setPhone:[NSNumber numberWithLongLong:[self.nResultTF.text longLongValue]]];
                }
                else
                {}
            }
            [self.myAppdelegate.managedObjectContext save:&error];
            
            self.messageLB.alpha=1;
            self.messageLB.backgroundColor=[UIColor brownColor];
            self.messageLB.text=@"修改成功！";
            
            [self performSelector:@selector(dismissMessageLB) withObject:self afterDelay:0.5];
            //刷新tableView
            [self selectAllRecords];
//            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"修改结果" message:@"修改成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alertView show];
            
        }
    }
    
    
}

-(void)dismissMessageLB
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.messageLB.alpha=0;
    [UIView commitAnimations];
}

//查询所有数据并显示在tableView上面
-(void)selectAllRecords
{
    [_detailsArray removeAllObjects];
    //获取表
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *user=[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.myAppdelegate.managedObjectContext];
    [fetchRequest setEntity:user];
    
    //执行查询
    NSError *error=nil;
    NSMutableArray *mutableFetchResult=[[self.myAppdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSLog(@"allRecords=%@",mutableFetchResult);
    
    //把值装入数组并reloadTableView
    if (mutableFetchResult==nil) {
        NSLog(@"Error=%@",error);
    }
    else
    {
        if (mutableFetchResult.count==0) {
            NSLog(@"查询结果为空");
        }
        else
        {
            for (User *user in mutableFetchResult) {
                NSArray *tmpArray=[NSArray arrayWithObjects:user.name,user.sex,user.age,user.phone, nil];
                [_detailsArray addObject:tmpArray];
            }
            [self.tableView reloadData];
        }
    }
    
}


#pragma mark
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=4) {
        self.optionsTF.text=[actionSheet buttonTitleAtIndex:buttonIndex];
    }
    
}


#pragma mark
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"customCell"];
    cell.textLabel.text=@"123";
    cell.detailTextLabel.text=@"123";
    
    
    NSArray *tmparr=[_detailsArray objectAtIndex:indexPath.row];
    NSString *otherStr=[NSString stringWithFormat:@"%@,%@,%@",[tmparr objectAtIndex:1],[tmparr objectAtIndex:2],[tmparr objectAtIndex:3]];
    cell.textLabel.text=[tmparr objectAtIndex:0];
    cell.detailTextLabel.text=otherStr;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _detailsArray.count;
}

//清空
- (IBAction)cleallAll:(UIButton *)sender {
    self.resultTF.text=nil;
    self.nResultTF.text=nil;
    [self.resultTF becomeFirstResponder];
    
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
