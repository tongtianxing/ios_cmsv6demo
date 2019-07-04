//
//  PlaybackListCell.m
//  cmsv6
//
//  Created by tongtianxing on 2018/8/22.
//  Copyright © 2018年 babelstar. All rights reserved.
//

#import "PlaybackListCell.h"
#import "TTXPlaybackSearchModel.h"
//#import "TTXAppDelegate.h"
#define IS_IPHONE_6_OR_LATER (([[UIScreen mainScreen] bounds].size.height - 568) > 0)
@interface PlaybackListCell()
{
    UIImageView *imageView;
    UILabel *dateLabel;
    UILabel *timeLabel;
    UILabel *chFileTypeLabel;
  
}
@end;
@implementation PlaybackListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 8, 90, 60)];
        [imageView setImage:[UIImage imageNamed:@"images/video/file_default.png"]];
        imageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:imageView];
        dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, 8, 100, 25)];
        dateLabel.text = @"0000-00-00";
        [self.contentView addSubview:dateLabel];
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dateLabel.frame)+5, 8, 200, 25)];
//        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.text = @"00:00:00 - 00:00:00";
        timeLabel.font = [UIFont fontWithName:timeLabel.font.fontName size:dateLabel.font.pointSize-1];
        [self.contentView addSubview:timeLabel];
        chFileTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, CGRectGetMaxY(timeLabel.frame)+10, 130, 25)];
        chFileTypeLabel.text = @"CH1   ";
        [self.contentView addSubview:chFileTypeLabel];
        
        if(!IS_IPHONE_6_OR_LATER)
        {
            dateLabel.font = [UIFont fontWithName:dateLabel.font.fontName size:14];
             timeLabel.font = [UIFont fontWithName:timeLabel.font.fontName size:13];
             chFileTypeLabel.font = [UIFont fontWithName:chFileTypeLabel.font.fontName size:14];
            timeLabel.frame = CGRectMake(CGRectGetMaxX(dateLabel.frame)-12, 8, 200, 25);
        }
    }
    return self;
}


-(void)setPlaybackListModel:(TTXPlaybackSearchModel*)model
{
    dateLabel.text = [NSString stringWithFormat:@"%04zd-%02zd-%02zd",model.year,model.month,model.day];
    
//    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat: @"HH:mm:ss"];
//     NSString* beginTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.beginTime]];
//       NSString* endTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.endTime]];
    timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[self getTimeStr:model.beginTime],[self getTimeStr:model.endTime]];
    BOOL baojing = false;
    if (model.fileType > 0) {
        baojing = true;
    }
    
    NSMutableString *chFileTypeStr = [[NSMutableString alloc]init];
    NSInteger chnMask = model.chnMask;
    NSInteger chn = model.chn;
    BOOL isEmpty = true;
    for (int k = 0; k < chn; k++) {
        if ( (chnMask >> k) & 0x01 ) {
            isEmpty = false;
            [chFileTypeStr appendFormat:@"CH%d,",k+1];
        }
    }
    if (isEmpty) {
        if (chn == 98) {
            [chFileTypeStr appendFormat:@"%@ ",NSLocalizedString(@"playback_channel_all", nil)];
        }else{
            [chFileTypeStr appendFormat:@"CH%zd ",chn + 1];
        }
    }else{
        [chFileTypeStr replaceCharactersInRange:NSMakeRange(chFileTypeStr.length-1, 1) withString:@" "];
    }
    model.isMultChn = !isEmpty;//多通道
    
    if (baojing) {
        chFileTypeLabel.text = [NSString stringWithFormat:@"%@%@",chFileTypeStr,NSLocalizedString(@"playback_video_type_alarm",@"")];
    }else{
        chFileTypeLabel.text = [NSString stringWithFormat:@"%@%@",chFileTypeStr,NSLocalizedString(@"playback_video_type_normal",@"")];
    }
    
    dateLabel.textColor = baojing ? [UIColor redColor] : [UIColor blackColor];
     timeLabel.textColor = baojing ? [UIColor redColor] : [UIColor blackColor];
     chFileTypeLabel.textColor = baojing ? [UIColor redColor] : [UIColor blackColor];
    
}

-(NSString *)getTimeStr:(NSInteger)time
{
    NSInteger hour = time / 3600;
    NSInteger minute = (time - 3600 * hour) / 60;
    NSInteger second = time - 3600 * hour - 60 * minute;
    return [NSString stringWithFormat:@"%02zd:%02zd:%02zd",hour,minute,second];
}







@end
