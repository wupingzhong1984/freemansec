//
//  LiveSearchViewController.m
//  freemansec
//
//  Created by adamwu on 2017/6/30.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveSearchViewController.h"
#import "LiveSearchQuickChoiceView.h"
#import "LiveSearchResultModel.h"
#import "LiveSearchResultCollectionViewCell.h"
#import "LivePlayViewController.h"
#import "UserLivePlayViewController.h"

@interface LiveSearchViewController ()
<LiveSearchQuickChoiceViewDelegate,
UITextFieldDelegate,
UICollectionViewDelegate,UICollectionViewDataSource,
UserLivePlayViewControllerDelegate,
LivePlayViewControllerDelegate>
@property (nonatomic,strong) UITextField *searchTF;
@property (nonatomic,strong) UICollectionView *collView;
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,strong) NSMutableArray *resultArray;
@property (nonatomic,strong) LiveSearchQuickChoiceView *choiceView;
@property (nonatomic,assign) NSInteger lastSelectIndex;
@end

@implementation LiveSearchViewController

- (void)back {
    
    [_searchTF resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray*)resultArray {
    
    if (!_resultArray) {
        _resultArray = [[NSMutableArray alloc] init];
    }
    return _resultArray;
}

- (UIView*)naviBarView {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, self.navigationController.navigationBar.maxY)];
    v.backgroundColor = UIColor_navibg;
    
    UIView *whiteBg = [[UIView alloc] init];
    whiteBg.backgroundColor = [UIColor whiteColor];
    whiteBg.size = CGSizeMake(K_UIScreenWidth-15-45, 32);
    whiteBg.x = 15;
    whiteBg.centerY = (v.height - 20)/2+20;
    whiteBg.layer.cornerRadius = whiteBg.height/2;
    whiteBg.layer.borderColor = UIColor_line_d2d2d2.CGColor;
    whiteBg.layer.borderWidth = 0.5;
    [v addSubview:whiteBg];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_icon.png"]];
    icon.center = CGPointMake(whiteBg.x + 17, whiteBg.centerY);
    [v addSubview:icon];
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(icon.maxX + 10, whiteBg.y + (whiteBg.height - 17)/2, whiteBg.maxX - whiteBg.height/2 - (icon.maxX + 10), 17)];
    _searchTF.font = [UIFont systemFontOfSize:16];
    _searchTF.textColor = [UIColor darkGrayColor];
    _searchTF.placeholder = @"搜索频道栏目";
    _searchTF.returnKeyType = UIReturnKeySearch;
    _searchTF.delegate = self;
    [v addSubview:_searchTF];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    btn.size = CGSizeMake(44, whiteBg.height);
    btn.x = v.width - btn.width;
    btn.centerY = whiteBg.centerY;
    [v addSubview:btn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, v.height-0.5, v.width, 0.5)];
    line.backgroundColor = UIColor_line_d2d2d2;
    [v addSubview:line];
    
    return v;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor_vc_bgcolor_lightgray;
    
    _lastSelectIndex = -1;
    UIView *navi = [self naviBarView];
    [self.view addSubview:navi];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 20;
    layout.headerReferenceSize = CGSizeMake(0,0);
    layout.footerReferenceSize = CGSizeMake(0,0);
    CGFloat itemWidth = (K_UIScreenWidth-28-20)/2;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth*3/4 + 45);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [layout setHeaderReferenceSize:CGSizeMake(K_UIScreenWidth, 14)];
    [layout setFooterReferenceSize:CGSizeMake(K_UIScreenWidth, 14)];
    self.collView = [[UICollectionView alloc] initWithFrame:CGRectMake(14, navi.maxY, K_UIScreenWidth-28, K_UIScreenHeight - navi.maxY) collectionViewLayout:layout];
    _collView.showsVerticalScrollIndicator = NO;
    _collView.showsHorizontalScrollIndicator = NO;
    _collView.delegate = self;
    _collView.dataSource = self;
    _collView.backgroundColor = [UIColor clearColor];
    [_collView registerClass:[LiveSearchResultCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:_collView];
    
    
    [[LiveManager sharedInstance] getLiveSearchHotWordsCompletion:^(NSArray * _Nullable wordList, NSError * _Nullable error) {
        
        self.choiceView = [[LiveSearchQuickChoiceView alloc] initWithHeight:_collView.height hotwords:wordList history:[LiveManager getLiveSearchHistory]];
        _choiceView.y = navi.maxY;
        _choiceView.delegate = self;
        [self.view addSubview:_choiceView];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestSearch {
    
    [[LiveManager sharedInstance] queryLiveByWord:_searchTF.text pageNum:_pageNum completion:^(NSArray * _Nullable queryResultList, NSError * _Nullable error) {
        
        if (error) {
            [self presentViewController:[Utility createErrorAlertWithContent:[error.userInfo objectForKey:NSLocalizedDescriptionKey] okBtnTitle:nil] animated:YES completion:nil];
        } else {
            
            if (_pageNum == 1) {
                
                [self.resultArray removeAllObjects];
//                [_collView reloadData];
            }
            
            if (queryResultList.count > 0) {
                [self.resultArray addObjectsFromArray:queryResultList];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_collView reloadData];
                    
                });
            }
        }
    }];
}

- (void)LiveSearchQuickChoiceViewDelegateDidScroll {
    
    [_searchTF resignFirstResponder];
}

- (void)LiveSearchQuickChoiceViewDelegateSearchWord:(NSString *)word {
    
    _searchTF.text = word;
    _choiceView.hidden = YES;
    
    //update history
    NSMutableArray *historys = [LiveManager getLiveSearchHistory];
    if (!historys) {
        historys = [[NSMutableArray alloc] init];
    } else if (historys.count > 0 && [[historys firstObject] isEqualToString:word]) {
        [historys removeObjectAtIndex:0];
    }
    [historys insertObject:word atIndex:0];
    if (historys.count > 25){
        
        [historys removeLastObject];
    }
    [LiveManager saveLiveSearchHistory:historys];
    
    _pageNum = 1;
    [self requestSearch];
    [_searchTF resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    _choiceView.hidden = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
//    if (textField.text.length == 0) {
//        return NO;
//    }
    
    if (textField.text.length > 0) {
        
        //update history
        NSMutableArray *historys = [LiveManager getLiveSearchHistory];
        if (!historys) {
            historys = [[NSMutableArray alloc] init];
        } else if (historys.count > 0 && [[historys firstObject] isEqualToString:textField.text]) {
            [historys removeObjectAtIndex:0];
        }
        if(historys.count > 0) {
            [historys insertObject:textField.text atIndex:0];
        } else {
            [historys addObject:textField.text];
        }
        if (historys.count > 25){
            
            [historys removeLastObject];
        }
        [LiveManager saveLiveSearchHistory:historys];
    }
    
    _choiceView.hidden = YES;
    _pageNum = 1;
    [self requestSearch];
    [textField resignFirstResponder];
    
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_collView] && scrollView.contentOffset.y == roundf(scrollView.contentSize.height-scrollView.frame.size.height)) {

        [self.collView performBatchUpdates:^{
            
            _pageNum ++;
            [self requestSearch];
            
        } completion:nil];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.resultArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LiveSearchResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.resultModel = [_resultArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _lastSelectIndex = indexPath.row;
    
    LiveSearchResultModel *model = [_resultArray objectAtIndex:indexPath.row];
    
    if (model.cid.length > 0 ) { //个人
        
        UserLivePlayViewController *vc = [[UserLivePlayViewController alloc] init];
        vc.userLiveChannelModel = model;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else { //官方
        
        LiveChannelModel *channel = [[LiveChannelModel alloc] init];
        channel.liveId = model.liveId;
        channel.liveName = model.liveName;
        channel.liveImg = model.liveImg;
        channel.liveIntroduce = model.liveIntroduce;
        channel.livelink = model.livelink;
        channel.anchorId = model.anchorId;
        channel.anchorName = model.nickName;
        channel.anchorImg = model.headImg;
        channel.isAttent = model.isAttent;
        
        LivePlayViewController *vc = [[LivePlayViewController alloc] init];
        vc.liveChannelModel = channel;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didLiveAttent:(BOOL)attent {
    
    if (_lastSelectIndex > -1) {
        
        LiveSearchResultModel *model = [_resultArray objectAtIndex:_lastSelectIndex];
        model.isAttent = attent?@"1":@"0";
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
