#import <UIKit/UIKit.h>
@interface DeviceSearchView : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSTimer* searchTimer;
    long handle;
    NSMutableArray* deviceList;
    BOOL isPresent;
}
@property (retain, nonatomic) IBOutlet UITableView *deviceTableView;
@property (retain, nonatomic) IBOutlet UILabel *loadLabel;

@end
