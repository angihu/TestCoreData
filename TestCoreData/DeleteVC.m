//
//  DeleteVC.m
//  TestCoreData
//
//  Created by Winson on 14/11/11.
//  Copyright (c) 2014年 Fangdr. All rights reserved.
//

#import "DeleteVC.h"

@interface DeleteVC ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_detailArray;
}
@end

@implementation DeleteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _myAppdelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    _detailArray=[[NSMutableArray alloc]init];
    [self selectAllRecords];
    
    
    //右上角添加一个显示全部的按钮
    UIBarButtonItem *showAllBtn=[[UIBarButtonItem alloc] initWithTitle:@"显示全部" style:UIBarButtonItemStylePlain target:self action:@selector(selectAllRecords)];
    self.navigationItem.rightBarButtonItem=showAllBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//打开下拉列表框
- (IBAction)showOptions:(UIButton *)sender {
    self.resultTF.text=nil;
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"选择字段"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"name",@"sex",@"age",@"phone", nil];
    [actionSheet showInView:self.view];
}




//删除
- (IBAction)doSelect:(UIButton *)sender {
    [_detailArray removeAllObjects];
//    //找到表
//    NSFetchRequest *fetchrequest=[[NSFetchRequest alloc]init];
//    NSEntityDescription *user=[NSEntityDescription entityForName:@"User" inManagedObjectContext:_myAppdelegate.managedObjectContext];
//    [fetchrequest setEntity:user];
//    
//    //筛选条件
//    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"%@ BEGINSWITH[c] '%@'",self.optionsTF.text,self.resultTF.text];
//    [fetchrequest setPredicate:predicate];
//    
//    //获取数据
//    NSError *error=nil;
//    NSMutableArray *mutableFetchResult=[[_myAppdelegate.managedObjectContext executeFetchRequest:fetchrequest error:&error] mutableCopy];
//    if (mutableFetchResult==nil) {
//        NSLog(@"Error=%@",error);
//    }
//    else
//    {
//        if (mutableFetchResult.count==0) {
//            NSLog(@"找到0条记录");
//        }
//        else
//        {
//            for (User *user in mutableFetchResult) {
//                NSArray *tmpArr=[NSArray arrayWithObjects:user.name,user.sex,user.age,user.phone, nil];
//                [_detailArray addObject:tmpArr];
//            }
//        }
//        [self.tableView reloadData];
//    }

    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.myAppdelegate.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    NSLog(@"%@==%@",self.optionsTF.text,self.resultTF.text);
    //查询条件
    NSPredicate *predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ contains[c] '%@'",self.optionsTF.text,self.resultTF.text]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error=nil;
    NSMutableArray *mutableFetresult=[[self.myAppdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (mutableFetresult==nil) {
        NSLog(@"Error=%@",error);
    }
    
    NSLog(@"mutable=%@",mutableFetresult);
    
    //取出查询结果赋值装入数组
    for (User *user in mutableFetresult) {
        NSArray *tmpArr=[NSArray arrayWithObjects:user.name,user.sex,user.age,user.phone, nil];
        [_detailArray addObject:tmpArr];
    }
    [self.tableView reloadData];
}

-(void)selectAllRecords
{
    [_detailArray removeAllObjects];
    //找到表
    NSFetchRequest *fetchrequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *user=[NSEntityDescription entityForName:@"User" inManagedObjectContext:_myAppdelegate.managedObjectContext];
    [fetchrequest setEntity:user];
    
    //获取数据
    NSError *error=nil;
    NSMutableArray *mutableFetchResult=[[_myAppdelegate.managedObjectContext executeFetchRequest:fetchrequest error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error=%@",error);
    }
    else
    {
        if (mutableFetchResult.count==0) {
            NSLog(@"找到0条记录");
        }
        else
        {
            for (User *user in mutableFetchResult) {
                NSArray *tmpArr=[NSArray arrayWithObjects:user.name,user.sex,user.age,user.phone, nil];
                [_detailArray addObject:tmpArr];
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
    
    NSArray *tmpArr=[_detailArray objectAtIndex:indexPath.row];
    NSString *subtitleStr=[NSString stringWithFormat:@"%@,%@,%@",[tmpArr objectAtIndex:1],[tmpArr objectAtIndex:2],[tmpArr objectAtIndex:3]];
    
    cell.textLabel.text=[tmpArr objectAtIndex:0];
    cell.detailTextLabel.text=subtitleStr;
    
    
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _detailArray.count;
}




-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //获取当前的记录的name的值
        UITableViewCell *cell=(UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.myAppdelegate.managedObjectContext];
        [fetchRequest setEntity:entityDescription];
        
        NSLog(@"%@==%@",self.optionsTF.text,self.resultTF.text);
        //查询条件
        NSPredicate *predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name =='%@'",cell.textLabel.text]];
        [fetchRequest setPredicate:predicate];
        
        NSError *error=nil;
        NSMutableArray *mutableFetresult=[[self.myAppdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
        if (mutableFetresult==nil) {
            NSLog(@"Error=%@",error);
        }
        
        NSLog(@"mutable=%@",mutableFetresult);
        
        //取出查询结果赋值装入数组
        for (User *user in mutableFetresult) {
            
            [self.myAppdelegate.managedObjectContext deleteObject:user];
            
            
            NSArray *tmpArr=[NSArray arrayWithObjects:user.name,user.sex,user.age,user.phone, nil];
            [_detailArray removeObject:tmpArr];
        }
        [self.myAppdelegate.managedObjectContext save:&error];
        
        
        
        [self.tableView reloadData];
    }
    
    
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
