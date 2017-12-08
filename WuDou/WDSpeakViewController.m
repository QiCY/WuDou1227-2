//
//  WDSpeakViewController.m
//  WuDou
//
//  Created by huahua on 16/7/6.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDSpeakViewController.h"
#import "WDListRihtTableViewCell.h"
#import "WDDetailsViewController.h"
#import "WDRightCategoriesCell.h"
#import "WDCatesCollectionReusableView.h"
#import "KeyboardToolBar.h"


#define kLineSpacing 5
#define kInteritemSpacing 5

@interface WDSpeakViewController ()<UITextFieldDelegate>
{
    NSMutableArray * _heardArr;
    NSMutableArray * _newHeardArr;
    NSMutableArray * _leftArr;
    NSMutableArray * _cellArr;
    NSMutableArray * _newcellArr;
    
    NSMutableArray * _bigClassArr;
    NSMutableArray * _newArray;
    NSMutableArray * _newClassArr;
    NSMutableArray * _allDetailArr;
    
    NSMutableArray * _classArr1;
    NSMutableArray * _classArr2;
    NSMutableArray * _allClassArr;
    
    NSMutableArray * _bigDetailArr1;
    NSMutableArray * _detailArr1;
    NSMutableArray * _detailArr2;
    
    NSMutableArray * _bigDetailArr2;
    NSMutableArray * _detailArr3;
    NSMutableArray * _detailArr4;
    
    NSIndexPath * _selIndex;
}

//@property(nonatomic,assign)NSIndexPath* selIndex;  //当前选中的行

@end

static NSString *headerReuseId = @"WDCatesCollectionReusableView";
@implementation WDSpeakViewController

-(void)viewWillAppear:(BOOL)animated
{
    _searchField.delegate = self;
    [KeyboardToolBar registerKeyboardToolBar:_searchField];
    //打开导航条
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    _searchField.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    _bigClassArr = [[NSMutableArray alloc]initWithObjects:@"果蔬生鲜", @"肉禽蛋奶",  @"冷热速食", @"休闲食品", @"酒水饮料", @"粮油调味", @"清洁日化", @"家具用品", @"鲜花蛋糕", @"便民服务",nil];
    _classArr1 = [[NSMutableArray alloc]initWithObjects:@"水果", @"蔬菜", nil];
    _classArr2 = [[NSMutableArray alloc]initWithObjects:@"鲜肉", @"蛋奶", nil];
    
    _detailArr1 = [[NSMutableArray alloc]initWithObjects:@"苹果", @"梨子",  @"桃子", @"哈密瓜", nil];
    _detailArr2 = [[NSMutableArray alloc]initWithObjects:@"根茎类", @"叶菜类",  @"瓜果类", @"菌菇类", @"调味类", nil];
    _bigDetailArr1 = [[NSMutableArray alloc]initWithObjects:_detailArr1, _detailArr2, nil];
    
    _detailArr3 = [[NSMutableArray alloc]initWithObjects:@"猪肉", @"牛肉",  @"家禽肉", @"羊肉", @"鲜鱼", nil];
    _detailArr4 = [[NSMutableArray alloc]initWithObjects:@"鸡蛋", @"鸭蛋", @"皮蛋", @"咸鱼", @"牛奶", @"咸鸭蛋", nil];
    _bigDetailArr2 = [[NSMutableArray alloc]initWithObjects:_detailArr3, _detailArr4, nil];
    
//    _allDetailArr = [[NSMutableArray alloc]initWithObjects:_bigDetailArr1, _bigDetailArr2, nil];
//    _allClassArr = [[NSMutableArray alloc]initWithObjects:_classArr1, _classArr2, nil];
    _newArray = [[NSMutableArray alloc]init];
    _newClassArr = [[NSMutableArray alloc]init];
//    _newArray = _bigDetailArr1;
//    _newClassArr = _classArr1;
    
    [self.rightTableView registerNib:[UINib nibWithNibName:@"WDListRihtTableViewCell" bundle:nil] forCellReuseIdentifier:@"rcell"];
    self.rightTableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.rightTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.itemSize = CGSizeMake(70, 100);
    flow.minimumLineSpacing = kLineSpacing;
    flow.minimumInteritemSpacing = kInteritemSpacing;
    flow.headerReferenceSize = CGSizeMake(self.leftCollectionView.width, 20);
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.leftCollectionView.collectionViewLayout = flow;
    [self.leftCollectionView registerNib:[UINib nibWithNibName:@"WDRightCategoriesCell" bundle:nil] forCellWithReuseIdentifier:@"rightCates"];
    [self.leftCollectionView registerClass:[UICollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseId];
    
    self.rightTableView.showsVerticalScrollIndicator = NO;
 
    // 请求数据
    [self _requestModelDatas];
}

/** 请求数据*/
- (void)_requestModelDatas{
    
    _leftArr = [[NSMutableArray alloc]init];
    _heardArr = [[NSMutableArray alloc]init];
    _newHeardArr = [[NSMutableArray alloc]init];
    _cellArr = [[NSMutableArray alloc]init];
    _newcellArr = [[NSMutableArray alloc]init];
    [WDSpeakCategoriesManager requestCategoriesWithCompletion:^(NSMutableArray *array, NSString *error) {
        
        if (error) {
            
            SHOW_ALERT(error)
            return ;
        }
        self.allDatasArray = array;
        _leftArr = self.allDatasArray[0];
        _heardArr = self.allDatasArray[1];
        _cellArr = self.allDatasArray[2];
        _newHeardArr = _heardArr[0];
        _newcellArr = _cellArr[0];
        NSLog(@"%@",_leftArr);
        [self.rightTableView reloadData];
        [self.leftCollectionView reloadData];
        
    }];

}

#pragma mark - tableview协议方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_leftArr.count > 0)
    {
        return _leftArr.count;
    }
    else
    {
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.rightTableView)
    {
        WDListRihtTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"rcell"];
        if (_leftArr.count > 0)
        {
            WDCategoriesModel * leftModel = _leftArr[indexPath.row];
            cell.nameLabel.text = leftModel.name;
            if (_selIndex)
            {
                if(indexPath.row == _selIndex.row)
                {
                    cell.colorView.backgroundColor = [UIColor colorWithRed:80/255.0 green:160/255.0 blue:80/255.0 alpha:1.0];
                    cell.nameLabel.textColor = [UIColor colorWithRed:80/255.0 green:160/255.0 blue:80/255.0 alpha:1.0];
                    cell.backgroundColor = [UIColor clearColor];
                }
                else
                {
                    cell.colorView.backgroundColor = [UIColor clearColor];
                    cell.nameLabel.textColor = [UIColor blackColor];
                    cell.backgroundColor = [UIColor clearColor];
                }
                
            }
            else
            {
                if (indexPath.row == 0)
                {
                    _selIndex = indexPath;
                    cell.colorView.backgroundColor = [UIColor colorWithRed:80/255.0 green:160/255.0 blue:80/255.0 alpha:1.0];
                    cell.nameLabel.textColor = [UIColor colorWithRed:80/255.0 green:160/255.0 blue:80/255.0 alpha:1.0];
                    cell.backgroundColor = [UIColor whiteColor];
                }
                else
                {
                    cell.colorView.backgroundColor = [UIColor clearColor];
                    cell.nameLabel.textColor = [UIColor blackColor];
                    cell.backgroundColor = [UIColor clearColor];
                }
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    if (tableView == self.rightTableView)
    {
        if(_selIndex)//如果上一次的选中的行存在,并且不是当前选中的这一样,则让上一行不选中
        {
            WDListRihtTableViewCell * cell= (WDListRihtTableViewCell *)[tableView cellForRowAtIndexPath:_selIndex];
            cell.colorView.backgroundColor = [UIColor clearColor];
            cell.nameLabel.textColor = [UIColor blackColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        _selIndex = indexPath;
        WDListRihtTableViewCell * cell= (WDListRihtTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.colorView.backgroundColor = [UIColor colorWithRed:80/255.0 green:160/255.0 blue:80/255.0 alpha:1.0];
        cell.nameLabel.textColor = [UIColor colorWithRed:80/255.0 green:160/255.0 blue:80/255.0 alpha:1.0];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        //之前选中的，取消选择
        if (indexPath.row < _heardArr.count)
        {
            _newHeardArr = _heardArr[indexPath.row];
            _newcellArr = _cellArr[indexPath.row];
//            [self.leftTableView reloadData];
            [self.leftCollectionView reloadData];
            [self.rightTableView reloadData];
        }
        else
        {
            _newHeardArr = nil;
            _newcellArr = nil;
//            [self.leftTableView reloadData];
            [self.leftCollectionView reloadData];
            [self.rightTableView reloadData];
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.leftTableView)
    {
        UIView * view = [[UIView alloc]initWithFrame:self.leftTableView.frame];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 80, 30)];
        nameLabel.textColor = [UIColor colorWithRed:80/255.0 green:160/255.0 blue:80/255.0 alpha:1.0];
        nameLabel.font = [UIFont systemFontOfSize:16.0];
        if (_newHeardArr.count > 0)
        {
            WDCategoriesModel * heardModel = _newHeardArr[section];
            nameLabel.text = heardModel.name;
        }
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 39.5, view.width-30, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:lineView];
        
        UILabel * manyLabei = [[UILabel alloc]initWithFrame:CGRectMake(view.width - 100, 5, 80, 30)];
        manyLabei.textColor = [UIColor blackColor];
        manyLabei.font = [UIFont systemFontOfSize:12.0];
        manyLabei.textAlignment = NSTextAlignmentRight;
        manyLabei.text = @"更多>>";
        
        UIButton * btn = [[UIButton alloc]initWithFrame:manyLabei.frame];
        btn.tag = 123 + section;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:manyLabei];
        [view addSubview:nameLabel];
        [view addSubview:btn];
        
        return view;
    }
    return nil;
}

-(void)btnClick:(UIButton *)btn
{
    WDCategoriesModel * heardModel = _newHeardArr[btn.tag - 123];
    
    WDDetailsViewController * detailVC = [[WDDetailsViewController alloc]init];
    detailVC.numberId = heardModel.catenumber;
    detailVC.isCategories = 0;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (_newHeardArr.count > 0)
    {
        return _newHeardArr.count;
    }
    else
    {
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSMutableArray * array = _newcellArr[section];
    if (array.count > 0)
    {
        return array.count;
    }
    else
    {
        return 0;
    }

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WDRightCategoriesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rightCates" forIndexPath:indexPath];
    
    NSMutableArray * array = _newcellArr[indexPath.section];
    if (array.count > 0)
    {
        WDCategoriesModel * model3 = array[indexPath.row];
        cell.cellName.text = model3.name;
        [cell.cellImage sd_setImageWithURL:[NSURL URLWithString:model3.img]];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        WDCatesCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseId forIndexPath:indexPath];
        
        UILabel *headerText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, header.width - 20, 20)];
        headerText.textColor = KSYSTEM_COLOR;
        headerText.textAlignment = NSTextAlignmentLeft;
        headerText.font = [UIFont systemFontOfSize:15.0];
        
        if (_newHeardArr.count > 0)
        {
            WDCategoriesModel * heardModel = _newHeardArr[indexPath.section];
            headerText.text = heardModel.name;
        }
        
        for (UIView *view in header.subviews) {
            [view removeFromSuperview];
        } // 防止复用分区头
        
        [header addSubview:headerText];

        return header;
    } else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray * array = _newcellArr[indexPath.section];
    
    WDCategoriesModel *model = array[indexPath.row];
    WDDetailsViewController * detailVC = [[WDDetailsViewController alloc]init];
    detailVC.numberId = model.catenumber;
    detailVC.isCategories = 0;
    detailVC.navtitle = model.name;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UISearchBarDelegate
//  点击键盘上的 search 按钮时触发
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (![searchBar.text isEqualToString:@""]) {
        
        //进入搜索页面
        WDDetailsViewController *detailsVC = [[WDDetailsViewController alloc] init];
        detailsVC.searchMsg = searchBar.text;
        detailsVC.isCategories = YES;
        detailsVC.navtitle = @"搜索列表";
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
    
    [searchBar resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    NSString * searchStr = [_searchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![searchStr isEqualToString:@""]) {
        
        //进入搜索页面
        WDDetailsViewController *detailsVC = [[WDDetailsViewController alloc] init];
        detailsVC.searchMsg = _searchField.text;
        detailsVC.isCategories = YES;
        detailsVC.navtitle = @"搜索列表";
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)searchBtnClick:(UIButton *)sender
{
    NSString * searchStr = [_searchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![searchStr isEqualToString:@""]) {
        
        //进入搜索页面
        WDDetailsViewController *detailsVC = [[WDDetailsViewController alloc] init];
        detailsVC.searchMsg = _searchField.text;
        detailsVC.isCategories = YES;
        detailsVC.navtitle = @"搜索列表";
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
    
    [_searchField resignFirstResponder];
}
@end
