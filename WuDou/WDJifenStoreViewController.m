//
//  WDJifenStoreViewController.m
//  WuDou
//
//  Created by huahua on 16/11/4.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDJifenStoreViewController.h"
#import "WDLunBoView.h"
#import "WDJifenShopCell.h"
#import "WDJifenMsgViewController.h"
#import "WDNearDetailsViewController.h"
#import "WDGoodsInfoViewController.h"
#import "WDStoreDetailViewController.h"

@interface WDJifenStoreViewController ()<UITableViewDelegate,UITableViewDataSource,WDLunBoViewDelegate>
{
    WDLunBoView *_topLunbo;
    UITableView *_jifenTableView;
    NSMutableArray *_lunboDatasArr;
    NSMutableArray *_dataArr;
    
    NSInteger _page;
}
/** 轮播图片数组*/
@property(nonatomic,strong)NSMutableArray *lunboArray;
@end

static NSString *jifenId = @"WDJifenShopCell";
@implementation WDJifenStoreViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (NSMutableArray *)lunboArray{
    
    if (!_lunboArray) {
        
        _lunboArray = [NSMutableArray array];
    }
    
    return _lunboArray;
}

/** 加载数据*/
- (void)_loadModelDatas{
    
    [WDMainRequestManager requestLoadJifenStoreAdsWithCompletion:^(NSMutableArray *array, NSString *error) {
        
        if (error) {
            
            SHOW_ALERT(error);
            return ;
        }
        
        
        _lunboDatasArr = array;
        
        for (WDAdvertisementModel *model in array) {
            
            NSString *image = model.img;
            [self.lunboArray addObject:image];
        }
        
        if (self.lunboArray.count == 0) {
            
            _topLunbo.imageURLStringsGroup = [NSMutableArray arrayWithObject:@"http://pic.baa.bitautotech.com/img/V2img4.baa.bitautotech.com/space/2011/03/04/b1c2da5e-52a6-4d9c-a67c-682a17fb8cb0_735_0_max_jpg.jpg"];
        }else{
            
            _topLunbo.imageURLStringsGroup = self.lunboArray;
        }
        
    }];
    
    [WDMainRequestManager requestLoadJifenStoreProductsWithCurrentPage:@"1" completion:^(NSMutableArray *array, NSString *error) {
        
        if (error) {
            SHOW_ALERT(error)
            [SVProgressHUD dismiss];
            return ;
        }
        
        [SVProgressHUD dismiss];
        
        _dataArr = array;
        [_jifenTableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"积分商城";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    // 显示指示器
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    [self _setupNavigation];
    
    [self _loadModelDatas];
    
    [self _setUI];
}
//  自定义导航栏返回按钮
- (void)_setupNavigation{
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 60, 40);
     [btn setImageEdgeInsets:UIEdgeInsetsMake(12, 5, 12,45)];
    [btn setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = back;
}

- (void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**  创建UI界面*/
- (void)_setUI{
    
    [self _createTopLunboView];
    
    _jifenTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topLunbo.frame)+10, kScreenWidth, kScreenHeight - CGRectGetMaxY(_topLunbo.frame) - 74) style:UITableViewStylePlain];
    
    _jifenTableView.showsVerticalScrollIndicator = NO;
    _jifenTableView.delegate = self;
    _jifenTableView.dataSource = self;
    [_jifenTableView registerNib:[UINib nibWithNibName:@"WDJifenShopCell" bundle:nil] forCellReuseIdentifier:jifenId];
    
    [self.view addSubview:_jifenTableView];
    
    _page = 1;
    
    [self _setFooterRefresh];
}

/**  创建顶部轮播图*/
- (void)_createTopLunboView{
    
    //    NSArray *testArray = @[@"http://pic24.nipic.com/20121025/10444819_041559015351_2.jpg",@"http://a.hiphotos.baidu.com/zhidao/pic/item/09fa513d269759eea57ece50b2fb43166d22df7b.jpg",@"http://imgsrc.baidu.com/forum/pic/item/e73649178a82b9013946e4b8738da9773b12ef98.jpg"];
    //    _lunboArray = [NSMutableArray arrayWithArray:testArray];
    
    CGFloat lunboH = kScreenWidth / 8*3;
    _topLunbo = [WDLunBoView lunBoViewWithFrame:CGRectMake(0, 0, kScreenWidth, lunboH) delegate:self placeholderImage:[UIImage imageNamed:@"noproduct.png"]];
    _topLunbo.autoScrollTimeInterval = 2.0f;
    _topLunbo.showPageControl = YES;
    _topLunbo.pageControlBottomOffset = -15;
    _topLunbo.pageControlAliment = WDLunBoViewPageContolAlimentCenter;
    _topLunbo.currentPageDotColor = KSYSTEM_COLOR;
    _topLunbo.pageDotColor = [UIColor lightGrayColor];
    [self.view addSubview:_topLunbo];
    
}

/** 下拉加载*/
- (void)_setFooterRefresh{
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    footer.automaticallyChangeAlpha = YES;
    
    // 马上进入刷新状态
    //    [header beginRefreshing];
    
    // 设置header
    _jifenTableView.mj_footer = footer;
}
- (void)loadMoreData{
    
    _page ++;
    NSLog(@"_page = %ld",_page);
    
    [WDMainRequestManager requestLoadJifenStoreProductsWithCurrentPage:[NSString stringWithFormat:@"%ld",(long)_page] completion:^(NSMutableArray *array, NSString *error) {
        
        if (error) {
            
            [_jifenTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        if (array.count == 0) {
            [_jifenTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        [_dataArr addObjectsFromArray:array];
        
        [_jifenTableView reloadData];
        [_jifenTableView.mj_footer endRefreshing];
        
    }];
}

#pragma mark - <WDLunBoViewDelegate>
- (void)cycleScrollView:(WDLunBoView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    WDAdvertisementModel *model1 = _lunboDatasArr[index];
    
    NSString *type1 = model1.urltype;
    if ([type1 isEqualToString:@"1"]) {
        
//        WDNearDetailsViewController *nearVC = [[WDNearDetailsViewController alloc]init];
        WDStoreDetailViewController *nearVC = [[WDStoreDetailViewController alloc]init];
        nearVC.type = 1;
        NSString *storeId = model1.url;
        nearVC.storeId = storeId;
        [WDAppInitManeger saveStrData:storeId withStr:@"shopID"];
        [self.navigationController pushViewController:nearVC animated:YES];
    }else{
        
        WDGoodsInfoViewController *infosVC = [[WDGoodsInfoViewController alloc]init];
        NSString *goodID = model1.url;
        infosVC.goodsID = goodID;
        [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
        infosVC.goodsImage = model1.img;
        [self.navigationController pushViewController:infosVC animated:YES];
    }
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_dataArr.count > 0) {
        
        return _dataArr.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WDJifenShopCell *cell = [tableView dequeueReusableCellWithIdentifier:jifenId forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.shopImageView.image = [UIImage imageNamed:@"商品2"];
    
    if (_dataArr.count > 0) {
        
        WDCreditProductsModel *model = _dataArr[indexPath.row];
        cell.shopInfos.text = model.name;
        [cell.shopImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
        cell.totalCount.text = [NSString stringWithFormat:@"数量：%@",model.stock];
        cell.lastCount.text = [NSString stringWithFormat:@"已兑：%@",model.exchangecount];
        cell.shopCoins.text = model.shopprice;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDJifenMsgViewController *jifenInfosVC = [[WDJifenMsgViewController alloc]init];
    
    WDCreditProductsModel *model = _dataArr[indexPath.row];
    jifenInfosVC.pid = model.pid;
    
    [self.navigationController pushViewController:jifenInfosVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}


@end
