//
//  SelectVC.m
//  TestCoreData
//
//  Created by Winson on 14/11/11.
//  Copyright (c) 2014年 Fangdr. All rights reserved.
//

#import "SelectVC.h"



@interface SelectVC ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_detailsArray;
}
@end

@implementation SelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _myAppdelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    _detailsArray=[[NSMutableArray alloc]init];
    
    NSLog(@"oh no");
    [self selectAllRecords:nil];
}




//打开下拉列表框
- (IBAction)showOptions:(UIButton *)sender {
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"选择字段"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"name",@"sex",@"age",@"phone", nil];
    [actionSheet showInView:self.view];
}


//根据条件查询
- (IBAction)doSelect:(UIButton *)sender {
    [self.view endEditing:YES];
    [_detailsArray removeAllObjects];
    
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.myAppdelegate.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    NSLog(@"%@==%@",self.optionsTF.text,self.resultTF.text);
    //查询条件
    NSPredicate *predicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ contains[cd] '%@'",self.optionsTF.text,self.resultTF.text]];
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
        [_detailsArray addObject:tmpArr];
    }
    [self.tableView reloadData];
}


//查询所有数据并将它们显示在tableView
- (IBAction)selectAllRecords:(UIButton *)sender {
    [self.view endEditing:YES];
    [_detailsArray removeAllObjects];
    
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *user=[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.myAppdelegate.managedObjectContext];
    [fetchRequest setEntity:user];
    NSError *error=nil;
    NSMutableArray *mutableFetchResult=[[self.myAppdelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error=%@",error);
    }
    NSLog(@"总共有<%d>条记录。",(int)[mutableFetchResult count]);
    for (User *user in mutableFetchResult) {
        NSLog(@"user.name=%@",user.name);
        NSArray *tmpArr=[NSArray arrayWithObjects:user.name,user.sex,user.age,user.phone, nil];
        [_detailsArray addObject:tmpArr];
    }
    [self.tableView reloadData];
}

#pragma mark

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tmparr=[_detailsArray objectAtIndex:indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"customCell"];
    cell.textLabel.text=@"Title";
    cell.detailTextLabel.text=@"subtitle";
    
    NSString *subtitleStr=[NSString stringWithFormat:@"%@,%@,%@",[tmparr objectAtIndex:1],[tmparr objectAtIndex:2],[tmparr objectAtIndex:3]];
    cell.textLabel.text=[tmparr objectAtIndex:0];
    cell.detailTextLabel.text=subtitleStr;
    
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _detailsArray.count;
}

#pragma mark
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=4) {
        self.optionsTF.text=[actionSheet buttonTitleAtIndex:buttonIndex];
        self.resultTF.text=nil;
    }
}

















-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
