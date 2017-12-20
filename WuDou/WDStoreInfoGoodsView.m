//
//  WDStoreInfoGoodsView.m
//  WuDou
//
//  Created by admin on 2017/12/11.
//  Copyright © 2017年 os1. All rights reserved.
//

#import "WDStoreInfoGoodsView.h"
#import "WDStoreInfoCatesModel.h"


@implementation WDStoreInfoGoodsView
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.dataArray = [NSMutableArray new];
        self.selectArray = [NSMutableArray new];
        self.selectIndex = 0;
        self.leftTableView = [self createTableView];
        self.leftTableView.frame = CGRectMake(0, 0, 120, frame.size.height);
        [self.leftTableView registerNib:[UINib nibWithNibName:@"WDListRihtTableViewCell" bundle:nil] forCellReuseIdentifier:@"rcell"];
        self.leftTableView.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
        [self addSubview:self.leftTableView];
        
        self.rightTableView = [self createTableView];
        self.rightTableView.frame = CGRectMake(120, 0, kScreenWidth - 120, frame.size.height);
        [self.rightTableView registerNib:[UINib nibWithNibName:@"WDNearDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"Ncell"];
        [self addSubview:self.rightTableView];
    }
    return self;
}
- (void)setDataArray:(NSMutableArray *)dataList selectList:(NSMutableArray *)selectList {
    self.dataArray = dataList;
    self.selectArray = selectList;
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
}
- (void)setDataArray:(NSMutableArray *)dataList selectList:(NSMutableArray *)selectList indexPath:(NSIndexPath *)indexPath{
    self.dataArray = dataList;
    self.selectArray = selectList;
    [self.rightTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
- (UITableView *)createTableView{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    return tableView;
}
#pragma mark NearCellDelegate
- (void)addBtnClicked:(WDSearchInfosModel *)model count:(NSString *)count indexPath:(NSIndexPath *)indexPath
{
    if (_delegate) {
        [_delegate addBtnClicked:model count:count indexPath:indexPath];
    }
}
-(void)deleteBtnClicked:(WDSearchInfosModel *)model count:(NSString *)count indexPath:(NSIndexPath *)indexPath
{
    if (_delegate) {
        [_delegate deleteBtnClicked:model count:count indexPath:indexPath];
    }
}
#pragma mark UItableViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _rightTableView) {
        if (_isDidSelect) {
            return;
        }
        NSIndexPath* index = [_rightTableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
        _selectIndex = index.section;
       
        [_leftTableView reloadData];
        
        
        if (scrollView.contentOffset.y == 0) {
            if (_delegate) {
                _isScroll = NO;
                [_delegate didScrollToDown];
            }
        }
        if (scrollView.contentOffset.y>0) {
            if (!_isScroll) {
                _isScroll = YES;
                if (_delegate) {
                    [_delegate didScrollToUp];
                }
            }
        }
    }

    
   
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _rightTableView) {
        UIView *headView = [[UIView alloc] init];
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth/4*3-10, 30)];
        if (_dataArray.count>0) {
            WDStoreInfoCatesModel *cateModel = _dataArray[section];
            headLabel.text = [NSString stringWithFormat:@"%@（%ld）",cateModel.name,cateModel.productsList.count];
            headLabel.font = [UIFont systemFontOfSize:12];
            headLabel.textColor = [UIColor blackColor];
            [headView addSubview:headLabel];
        }
        headView.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
        return headView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _rightTableView) {
         WDStoreInfoCatesModel *cateModel = _dataArray[section];
        if ([cateModel.tag isEqualToString:@"1"]) {
            return 0;
        }
        return 30;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _rightTableView) {
        return _dataArray.count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTableView) {
        return _dataArray.count;
    }else{
        if (_dataArray.count>0) {
            WDStoreInfoCatesModel *cateModel = _dataArray[section];
            return cateModel.productsList.count;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView) {
        return 40;
    }else{
        return 94;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView) {
        WDListRihtTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"rcell"];
        
        if (_dataArray.count > 0)
        {
            WDStoreInfoCatesModel * details = _dataArray[indexPath.row];
            cell.nameLabel.text = details.name;
            if ([details.tag isEqualToString:@"1"]) {
                cell.colorView.backgroundColor = KSYSTEM_COLOR;
                cell.nameLabel.textColor = KSYSTEM_COLOR;
                cell.backgroundColor = [UIColor clearColor];
                cell.nameLabel.font = [UIFont systemFontOfSize:15];
                
            }else{
                cell.nameLabel.font = [UIFont systemFontOfSize:13];
                if (indexPath.row == _selectIndex) {
                     cell.colorView.backgroundColor = [UIColor clearColor];
//                    cell.colorView.backgroundColor = KSYSTEM_COLOR;
                    cell.nameLabel.textColor = KSYSTEM_COLOR;
                    cell.backgroundColor = [UIColor clearColor];
                }else{
                    cell.colorView.backgroundColor = [UIColor clearColor];
                    cell.nameLabel.textColor = [UIColor blackColor];
                    cell.backgroundColor = [UIColor clearColor];
                }
            }
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        WDNearDetailsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Ncell"];
        WDStoreInfoCatesModel *cateModel = _dataArray[indexPath.section];
        WDSearchInfosModel * goods = cateModel.productsList[indexPath.row];
        cell.delegate = self;
        [cell setSearchInfoModel:goods count:_selectArray[indexPath.section][indexPath.row] indexPath:indexPath];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView) {
        if (_selectIndex == indexPath.row) {
            return;
        }else{
            _isDidSelect = YES;
            _selectIndex = indexPath.row;
            [_leftTableView reloadData];
            WDStoreInfoCatesModel *model = _dataArray[_selectIndex];
            if ([model.tag isEqualToString:@"1"]) {
              
            }else{
               
                if (model.productsList.count>0) {
                    [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_selectIndex] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
                _isDidSelect = NO;
            }
            
            
        }
    }else{

        WDStoreInfoCatesModel *cateModel = _dataArray[indexPath.section];
        WDSearchInfosModel * goods = cateModel.productsList[indexPath.row];
        if (_delegate) {
            [_delegate didClickedGood:goods];
        }
    }
}

@end
