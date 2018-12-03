//
//  YMNewsViewController.m
//  YMDoctorClient
//
//  Created by iOS on 2018/6/14.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "YMNewsViewController.h"
#import "YMSystemAlertViewController.h"

#import "YMSureCancelAlert.h"
#import "YMActiveAlertView.h"
#import "YMMBProgressHUD.h"
#import "YMUniversalSingleSelectionPickerView.h"
#import "YMCountryPickerView.h"

#import "YMBaseTableViewCell.h"

@interface YMNewsViewController ()
<UITableViewDelegate, UITableViewDataSource,
YMBasePickerViewDelegate,
UIGestureRecognizerDelegate>

/** 列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据 */
@property (nonatomic, strong) NSArray *dataArr;
/** 右侧按钮 */
@property (nonatomic, strong) UIButton *rightBtn;
/** 确定回调 */
@property (nonatomic, strong) NSDictionary *resultDict;

@end

@implementation YMNewsViewController{
    /** tableView 内容偏移 */
    CGFloat _tableViewContentOffSet;
    /** 触摸点 X */
    CGFloat _touchScreenX;
    /** 触摸点 Y */
    CGFloat _touchScreenY;
}

#pragma mark -- lifeStyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载导航数据
    [self loadNavUIData];
    // 加载视图
    [self loadSubviews];
}

#pragma mark -- 加载导航数据
- (void)loadNavUIData {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
}

#pragma mark -- 加载视图
- (void)loadSubviews {
    [self.view addSubview:self.tableView];
}

#pragma mark -- tableViewDelegate --- dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID"];
    if (cell == nil) {
        cell = [[YMBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELLID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILongPressGestureRecognizer *longPressGesture =         [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:longPressGesture];
    }

    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            // 系统富文本
            NSDate *tmpStartData = [NSDate date];
            
            [YMSystemAlertViewController ymSystemAlertVC:self.navigationController title:@"提示" message:@"请修改输入内容" type:UIAlertControllerStyleAlert sureBlock:^(UIAlertAction * _Nonnull action) {
                NSLog(@"确定了");
            } cancelBlock:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消了");
            }];
            
            double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
            NSLog(@">>>>>>>>>>cost time = %f ms", deltaTime * 1000);
        }
            break;
        case 1:
        {
            // 系统富文本底部
            NSDate *tmpStartData = [NSDate date];
            
            [YMSystemAlertViewController ymSystemAlertVC:self.navigationController title:@"提示" message:@"请修改输入内容" type:UIAlertControllerStyleActionSheet sureBlock:^(UIAlertAction * _Nonnull action) {
                NSLog(@"确定了");
            } cancelBlock:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消了");
            }];
            
            double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
            NSLog(@">>>>>>>>>>cost time = %f ms", deltaTime * 1000);
        }
            break;
        case 2:
        {
            // 自定义确定取消
            [YMSureCancelAlert alertText:@"家里卡积分" sureBtnTitle:@"确定" maxHeight:100 alertStyle:YMAlertButtonTypeStyleDefault sureBtnClick:^(UIButton * _Nonnull sureBtn) {
                NSLog(@"确定了");
            } cancelBtnClick:^(UIButton * _Nonnull cancelBtn) {
                NSLog(@"取消了");
            }];
        }
            break;
        case 3:
        {
            // 自定义确定
            [YMSureCancelAlert alertText:@"家里卡积分" sureBtnTitle:@"我知道了！" maxHeight:100 alertStyle:YMAlertButtonTypeStyleAlone sureBtnClick:^(UIButton * _Nonnull sureBtn) {
                NSLog(@"确定了");
            } cancelBtnClick:^(UIButton * _Nonnull cancelBtn) {
                NSLog(@"取消了");
            }];
        }
            break;
        case 4:
        {
            // webView 活动页
            YMActiveAlertView *active = [[YMActiveAlertView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
            [active showAlertInParsentView:self.tabBarController.view];
        }
            break;
        case 5:
        {
            // 自定义黑色小弹窗
            [YMBlackSmallAlert showAlertWithMessage:@"加载中..." time:2.0f];
        }
            break;
        case 6:
        {
            // 基于 HUD 黑色小弹窗
            [YMMBProgressHUD ymShowBlackAlert:self.view text:@"加载中..." afterDelay:2.0f];
        }
            break;
        case 7:
        {
            // 基于 HUD loading 有文字
            [YMMBProgressHUD ymShowCustomLoadingAlert:self.view text:@"加载中..."];
        }
            break;
        case 8:
        {
            // 基于 HUD loading 无文字
            [YMMBProgressHUD ymShowCustomLoadingAlert:self.view text:@""];
        }
            break;
        case 9:
        {
            // 基于 HUD 系统菊花 loading
            [YMMBProgressHUD ymShowLoadingAlert:self.view];
        }
            break;
        case 10:
        {
            // pickView
            YMUniversalSingleSelectionPickerView *pickerView = [[YMUniversalSingleSelectionPickerView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight) delegate:self title:@"日期" leftBtnTitle:@"完成" rightBtnTitle:@"确定"];
            self.resultDict = pickerView.resultDict;
            __weak typeof(&*self) ws = self;
            pickerView.resultBlock = ^(NSDictionary * _Nonnull dict) {
                ws.resultDict = [[NSDictionary alloc] initWithDictionary:dict];
            };
            [pickerView show];
        }
            break;
        case 11:
        {
            // pickView
            YMCountryPickerView *pickerView = [[YMCountryPickerView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight) delegate:self title:@"地区选择" leftBtnTitle:@"取消" rightBtnTitle:@"确定"];
            self.resultDict = pickerView.resultDict;
            __weak typeof(&*self) ws = self;
            pickerView.resultBlock = ^(NSDictionary * _Nonnull dict) {
                ws.resultDict = [[NSDictionary alloc] initWithDictionary:dict];
            };
            [pickerView show];
        }
            break;
        case 12:
        {
            // pickView
            YMTimerPickerView *pickerView = [[YMTimerPickerView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight) delegate:self title:@"时间选择" leftBtnTitle:@"取消" rightBtnTitle:@"确定"];
            self.resultDict = pickerView.resultDict;
            __weak typeof(&*self) ws = self;
            pickerView.resultBlock = ^(NSDictionary * _Nonnull dict) {
                ws.resultDict = [[NSDictionary alloc] initWithDictionary:dict];
            };
            [pickerView show];
        }
            break;
        case 13:
        {
            YMSliderVerifyAlertView *verifyView = [[YMSliderVerifyAlertView alloc] initWithMaximumVerifyNumber:3 results:^(YMSliderVerifyState state) {
                NSLog(@"%zd", state);
                switch (state) {
                    case YMSliderVerifyStateNot:
                    {
                        [YMBlackSmallAlert showAlertWithMessage:@"未验证" time:2.0f];
                    }
                        break;
                    case YMSliderVerifyStateFail:
                    {
                        [YMBlackSmallAlert showAlertWithMessage:@"验证失败" time:2.0f];
                    }
                        break;
                    case YMSliderVerifyStateSuccess:
                    {
                        [YMBlackSmallAlert showAlertWithMessage:@"验证成功" time:2.0f];
                    }
                        break;
                    case YMSliderVerifyStateIncomplete:
                    {
                        [YMBlackSmallAlert showAlertWithMessage:@"未完成验证" time:2.0f];
                    }
                        break;
                    default:
                        break;
                }
            }];
            [verifyView show];
        }
            break;
        default:
            break;
    }
}

#pragma mark - - YMBasePickerViewDelegate
- (void)actionWithButton:(UIButton *)sender title:(nonnull NSString *)title {
    switch (sender.tag) {
        case 100:
        {
            [YMBlackSmallAlert showAlertWithMessage:sender.titleLabel.text time:2.0f];
        }
            break;
        case 101:
        {
            NSLog(@"self.resultDict-- == %@", self.resultDict);
            NSString *pickerViewTitle = self.resultDict[@"pickerViewTitle"];
            [YMBlackSmallAlert showAlertWithMessage:pickerViewTitle time:2.0f];
            
            if (![title isEqualToString:@"时间选择"]) {
                [[YMObtainUserLocationManager shareManager] transferMapWithAddress:pickerViewTitle view:self.view];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark -- 隐藏按钮点击调用
- (void)rightBtnClick {
    [YMMBProgressHUD ymHideLoadingAlert:self.view];
}

#pragma mark  cell 长按
- (void)cellLongPress:(UILongPressGestureRecognizer *)recognizer {
    YMBaseTableViewCell *cell = (YMBaseTableViewCell *)recognizer.view;
    CGPoint point = [recognizer locationInView:[recognizer view]]; //返回触摸点在视图中的当前坐标
    CGFloat x = point.x;
    CGFloat y = point.y;
    _touchScreenX = x;
    _touchScreenY = y;
    if (cell.top - _tableViewContentOffSet > (MainScreenWidth - NavBarHeight) / 2) {
        _touchScreenY = cell.top - _tableViewContentOffSet - cell.height - cell.height / 2;
    } else {
        _touchScreenY = cell.top - _tableViewContentOffSet + cell.height + cell.height / 2;
    }
    
    if (_touchScreenX > MainScreenWidth / 2) {
        _touchScreenX = _touchScreenX - 130;
    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        NSMutableArray *listMarr = @[].mutableCopy;
        for (int i = 0; i < 3; i++) {
            NSMutableDictionary *dictM = @{}.mutableCopy;
            [dictM setObject:[NSString stringWithFormat:@"至尊王者 - %d", i + 1] forKey:@"filtratename"];
            [dictM setObject:[NSString stringWithFormat:@"%d", i] forKey:@"filtrateid"];
            [listMarr addObject:dictM];
        }
        
        YMMiddleMenuView *menuView = [[YMMiddleMenuView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
        menuView.tabFrame = CGRectMake(_touchScreenX, _touchScreenY, 130, 100);
        menuView.titleArray = listMarr;
        [[UIApplication sharedApplication].keyWindow addSubview:menuView];
        
        menuView.blockSelectedMenu = ^(NSInteger menuRow, NSString *filtratename, NSString *filtrateid) {
            [YMBlackSmallAlert showAlertWithMessage:filtratename time:2.0f];
        };
    }
}

#pragma mark - - lazyLoadUI
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, YMSCROLLVIEW_TOP_MARGIN, MainScreenWidth, MainScreenHeight - NavBarHeight - TabBarHeight) style:UITableViewStylePlain];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; //UIScrollView也适用
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 55;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton *)rightBtn {
    if (_rightBtn == nil) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitle:@"隐藏 loading" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

#pragma mark -- getter
- (NSArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [[NSArray alloc] initWithObjects:@"系统富文本【中间】", @"系统富文本【底部】", @"自定义确定取消", @"自定义确定", @"webView 活动页", @"自定义黑色小弹窗", @"基于 HUD 黑色小弹窗", @"基于 HUD loading 有文字", @"基于 HUD loading 无文字", @"基于 HUD 系统菊花 loading", @"pickerView", @"省市区 pickerView", @"时间选择", @"滑块验证码", nil];
    }
    return _dataArr;
}
@end
