//
//  PlaybackViewController.m
//  cmsv6demo
//
//  Created by tongtianxing on 2018/9/3.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "PlaybackViewController.h"
#import "iToast.h"
#import "VehicleInfoModel.h"
#import "EquipmentInfoModel.h"
#import "RMDateSelectionViewController.h"
#import "TTXPlaybackSearch.h"
#import "TTXPlaybackVideoController.h"
#import "PlaybackListCell.h"


@interface PlaybackViewController ()<RMDateSelectionViewControllerDelegate,TTXPlaybackSearchDelegate,UITableViewDelegate,UITableViewDataSource>
{

     NSInteger selectChannel;
    
    NSDate* dateSelect;
    NSDate* dateBeginTime;
    NSDate* dateEndTime;
        int pickerType;
    NSString* queryDate;
    NSString* beginTime;
    NSString* endTime;
    
    NSArray *msearchList;

}
@property (weak, nonatomic) IBOutlet UIButton *terminal;
@property (weak, nonatomic) IBOutlet UISegmentedControl *location;
@property (weak, nonatomic) IBOutlet UIButton *channel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *videoType;
@property (weak, nonatomic) IBOutlet UIButton *date;
@property (weak, nonatomic) IBOutlet UIButton *selectBegin;
@property (weak, nonatomic) IBOutlet UIButton *selectEnd;
@property (weak, nonatomic) IBOutlet UIButton *serch;
@property (weak, nonatomic) IBOutlet UITableView *searchList;

@end

@implementation PlaybackViewController
- (IBAction)terminalBtnClick:(id)sender {

}
- (IBAction)selectChannelBtnClick:(id)sender {
    if (_currentVehicle == nil) {
        return;
    }
    VehicleInfoModel *vmodel = _currentVehicle;
    EquipmentInfoModel *emodel = vmodel.dl[0];
     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"channel" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];

        UIAlertAction *action = [UIAlertAction actionWithTitle:@"all" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_channel setTitle:@"all" forState:UIControlStateNormal];
            selectChannel = -1;
        }];
        [alert addAction:action];
    NSArray *cn  = [emodel.cn componentsSeparatedByString:@","];
        for (int i = 0; i < emodel.cc; i++) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:cn[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [_channel setTitle:cn[i] forState:UIControlStateNormal];
                selectChannel = i;
            }];
            [alert addAction:action];
        }
          [self presentViewController:alert animated:YES completion:nil];

}
- (IBAction)selectDateBtnClick:(id)sender {
    pickerType = 0;
    [self onSelectDate:@"select time" pickerMode:UIDatePickerModeDate date:dateSelect];
}

- (IBAction)selectBeginBtnClick:(id)sender {
       pickerType = 1;
      [self onSelectDate:@"begin time" pickerMode:UIDatePickerModeTime date:dateBeginTime];
}
- (IBAction)selectEndBtnClick:(id)sender {
     pickerType = 2;
         [self onSelectDate:@"end time" pickerMode:UIDatePickerModeTime date:dateEndTime];
}
- (IBAction)searchBtn:(id)sender {
    if (_currentVehicle != nil) {
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents* compsBegin = [calendar components:unitFlags fromDate:dateBeginTime];
        int beginHour = (int)[compsBegin hour];
        int beginMinute = (int)[compsBegin minute];
        int beginSecond = (int)[compsBegin second];
        
        NSDateComponents* compsEnd = [calendar components:unitFlags fromDate:dateEndTime];
        int endHour = (int)[compsEnd hour];
        int endMinute = (int)[compsEnd minute];
        int endSecond = (int)[compsEnd second];
        int nBeginTime = (beginHour * 3600 + beginMinute * 60 + beginSecond);
        int nEndTime = (endHour * 3600 + endMinute * 60 + endSecond);
        
        if (nBeginTime  >= nEndTime)
        {
            [[iToast makeText:@"Begin time should not greater than end time!"] show];
            return ;
        }
        TTXPlaybackSearch * tsf = [[TTXPlaybackSearch alloc]init];
        tsf.delegate = self;

    EquipmentInfoModel *model1 = _currentVehicle.dl[0];
     NSString *vehiId =_currentVehicle.nm;//车牌号
      NSString *deviceId  = model1.id2;//设备ID
      
        [tsf onsearch:deviceId  vehiIdno:vehiId vehiId:(int)_currentVehicle.id1 devChnCout:(int)model1.cc location:(int)_location.selectedSegmentIndex channel:(int)selectChannel type:(int)_videoType.selectedSegmentIndex-1 date:queryDate beginTime:nBeginTime endTime:nEndTime];
    }
}

- (void)setCurrentVehicle:(VehicleInfoModel *)currentVehicle
{
    _currentVehicle = currentVehicle;
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_currentVehicle) {
        [self.terminal setTitle:_currentVehicle.nm forState:UIControlStateNormal];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
//    selectTerminal = -1;
    selectChannel = -1;
    _searchList.delegate = self;
    _searchList.dataSource = self;
    
    [_channel setTitle:@"all" forState:UIControlStateNormal];
    
    
    dateSelect = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDate *startDate = [calendar dateFromComponents:components];
    dateBeginTime = startDate;
    
    NSDateComponents *endComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:startDate];
    [endComponents setMinute:-5];
    [endComponents setDay:+1];
    NSDate *endDate = [calendar dateFromComponents:endComponents];
    dateEndTime = endDate;
    
      queryDate = [dateToString(dateSelect) copy];
    [_date setTitle:queryDate forState:UIControlStateNormal];
    
    beginTime = [[ self datePickerToTime:dateBeginTime ] copy];
    [_selectBegin setTitle:beginTime forState:UIControlStateNormal];
    
    endTime = [[ self datePickerToTime:dateEndTime ] copy];
    [_selectEnd setTitle:endTime forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)onSelectDate:(NSString*)title pickerMode:(int)_mode date:(NSDate*)_date
{
    [RMDateSelectionViewController setLocalizedTitleForCancelButton:NSLocalizedString(@"cancel", @"")];
    [RMDateSelectionViewController setLocalizedTitleForSelectButton:NSLocalizedString(@"ok", @"")];
    RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    dateSelectionVC.delegate = self;
    
    dateSelectionVC.titleLabel.text = title;
    dateSelectionVC.hideNowButton = YES;
    //You can enable or disable blur, bouncing and motion effects
    dateSelectionVC.disableBouncingWhenShowing = YES;
    //dateSelectionVC.disableMotionEffects = !self.motionSwitch.on;
    dateSelectionVC.disableBlurEffects = NO;
    dateSelectionVC.blurEffectStyle = UIBlurEffectStyleExtraLight;
    
    //Enable the following lines if you want a black version of RMDateSelectionViewController but also disabled blur effects (or run on iOS 7)
    //dateSelectionVC.tintColor = [UIColor whiteColor];
    //dateSelectionVC.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
    //dateSelectionVC.selectedBackgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
    //You can access the actual UIDatePicker via the datePicker property
    dateSelectionVC.datePicker.datePickerMode = _mode;
    dateSelectionVC.datePicker.minuteInterval = 5;
    dateSelectionVC.datePicker.date = _date;
    
//    if(!isPad) {
        [dateSelectionVC show];
//    } else {
//        [dateSelectionVC showFromRect:[searchTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] inView:self.view];
//    }
}

#pragma mark - RMDAteSelectionViewController Delegates
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    switch (pickerType) {
        case 0:
            queryDate = [dateToString(aDate) copy];
            dateSelect = [aDate copy];
            [_date setTitle:queryDate forState:UIControlStateNormal];
            break;
        case 1:
        {
            beginTime = [[ self datePickerToTime:aDate ] copy];
            dateBeginTime = [aDate copy];
            [_selectBegin setTitle:beginTime forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            endTime = [[ self datePickerToTime:aDate ] copy];
            dateEndTime = [aDate copy];
            [_selectEnd setTitle:endTime forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}
-(void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc
{
    NSLog(@"cancel");
}

NSString* dateToString(NSDate* date)
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
//    [formatter release];
    return dateString;
}
- (NSString*)datePickerToTime:(NSDate*)_date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"HH:mm:ss"];
    NSString* time = [formatter stringFromDate:_date];
    //    [formatter release];
    return time;
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
#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return msearchList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TTXPlaybackSearchModel *model = msearchList[indexPath.row];
    
   if([model checkIsMultChn])
   {
       UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"playback_channel", nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
       NSInteger chnMask = model.chnMask;
       NSInteger chn = model.chn;
       for (NSInteger k = 0; k < chn; k++) {
           if ( (chnMask >> k) & 0x01 ) {
               UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"CH%li",k+1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   model.selectChn = k;
                   
                   TTXPlaybackVideoController *pbvVC = [[TTXPlaybackVideoController alloc]init];
                   pbvVC.selectedModel = model;
                   [self presentViewController:pbvVC animated:NO completion:nil];
               }];
               [alertController addAction:action];
           }
       }
       [self presentViewController:alertController animated:YES completion:nil];
    
   }else{
    TTXPlaybackVideoController *pbvVC = [[TTXPlaybackVideoController alloc]init];
    pbvVC.selectedModel = model;
    [self presentViewController:pbvVC animated:NO completion:nil];
   }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"search cell";
    PlaybackListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PlaybackListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    TTXPlaybackSearchModel *model = msearchList[indexPath.row];
    [cell setPlaybackListModel:model];
    
    return cell;
}


#pragma mark - TTXPlaybackSearchDelegate
-(void)searchFinishHavePlayback:(NSArray *)searchList
{
    NSLog(@"searchList = %@",searchList);
    EquipmentInfoModel *model1 = _currentVehicle.dl[0];
    [searchList enumerateObjectsUsingBlock:^(TTXPlaybackSearchModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.is1078 = model1.is1078;
    }];
    msearchList = searchList;
    [_searchList reloadData];
}
-(void)searchError:(NSString *)error
{
    NSLog(@"searchError = %@",error);
}


@end
