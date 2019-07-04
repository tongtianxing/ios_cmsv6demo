#import "DeviceSearchView.h"
#import "iToast.h"
#import "TTXDeviceSearchModel.h"
#import "TTXRealVideoView.h"
#import "TTXDeviceSearch.h"

#define SEARCH_DEFAULT_PORT  6688
@interface DeviceSearchView ()<TTXDeviceSearchDelegate>

@property (nonatomic , strong)TTXRealVideoView *video1;
@property (nonatomic ,strong)TTXDeviceSearch *deviceSearch;
@end
@implementation DeviceSearchView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _deviceSearch = [[TTXDeviceSearch alloc] init];
    _deviceSearch.delegate = self;
    
    CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kScreenHeight = [UIScreen mainScreen].bounds.size.height;
    self.navigationItem.title = NSLocalizedString(@"devsearch_title", "");
    self.navigationController.navigationBarHidden =NO;
    self.deviceTableView.dataSource = self;
    self.deviceTableView.delegate = self;
    self.deviceTableView.separatorStyle = NO;
    [self.deviceTableView setBackgroundView:nil];

    _video1 = [[TTXRealVideoView alloc] init];
    CGFloat wh = (kScreenWidth - 15) / 2;
    _video1.frame = CGRectMake(5, kScreenHeight / 2.0 + 5, wh, wh);
    [self.view addSubview:_video1];
    _loadLabel.hidden = YES;
    _loadLabel.textAlignment = NSTextAlignmentCenter;
    _loadLabel.textColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1];
    
    _loadLabel.frame = CGRectMake(kScreenWidth /2 - 310/2, kScreenHeight/2 - 30/2, 310, 30);
    deviceList = [[NSMutableArray alloc]init];
    isPresent = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)dealloc {
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!isPresent) {
        [_deviceSearch startSearchDevice];
    }
    isPresent = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_deviceSearch stopSearchDevice];
}


- (void)showToast:(NSString*)key
{
    [[[iToast makeText:NSLocalizedString(key, "")] setGravity:iToastGravityCenter offsetLeft:0 offsetTop:-56] show];
}
- (void)onBack:(UIButton*)btn  {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (deviceList != nil) {
        return 1;
    } else {
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [deviceList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *DSCellIdentifier = @"DSCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DSCellIdentifier];
//    DeviceCell *cell = (DeviceCell *)[tableView dequeueReusableCellWithIdentifier:DSCellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DSCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    unsigned long row = [indexPath row];
    TTXDeviceSearchModel* search = [deviceList objectAtIndex:row];
    NSString *devIdno = [NSString stringWithFormat:@"IDNO:%@ ", search.devIdno];
    NSString* netInfo;
    if (search.netType == 0) {
        netInfo = [NSString stringWithFormat:@"%@", @"3G"];
    } else if (search.netType == 1) {
        netInfo =  [NSString stringWithFormat:@"Wifi(%@)  %@", search.netName, search.ipAddr ];
    } else {
        netInfo =  [NSString stringWithFormat:@"Net  %@", search.ipAddr ];
    }
    cell.textLabel.text = [devIdno stringByAppendingString:netInfo];
//    cell.mLbStatus.text = netInfo;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTXDeviceSearchModel* search = [deviceList objectAtIndex:indexPath.row];
    [_video1 StopAV];
    [_video1 setViewInfo:search.devIdno chn:0 mode:0];
    [_video1 setTitleInfo:search.devIdno chName:@"CH1"];
    [_video1 setLanInfo:search.ipAddr port:SEARCH_DEFAULT_PORT];
    [_video1 StartAV];
}
#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}


#pragma mark - TTXSearchDevice
-(void)searchFinishHaveDevice:(NSArray *)searchList
{
    if (searchList.count == 0) {
        NSLog(@"搜索不到");
    }
    deviceList = [NSMutableArray arrayWithArray:searchList];
    [_deviceTableView reloadData];
}

@end
