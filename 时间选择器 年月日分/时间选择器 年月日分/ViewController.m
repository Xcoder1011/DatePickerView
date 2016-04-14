//
//  ViewController.m
//  时间选择器 年月日分
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    UITextField *field;
}

@property (nonatomic,strong)NSMutableArray *date;
@property (nonatomic,strong)NSDictionary *dataDic;
@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,copy)NSString *str;
@property (nonatomic,copy)NSString *str1;
@property (nonatomic,copy)NSString *str2;
@property (nonatomic,copy)NSString *str3;
@property (nonatomic,copy)NSString *str4;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    
    field = [[UITextField alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 30)];
    
    [self.view addSubview:field];

    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 300)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_pickerView];
    
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    self.date = [NSMutableArray array];
    //存储年份的数组
    NSMutableArray *yearArray = [[NSMutableArray alloc] initWithCapacity:50];
    for (int i = 0; i < 50; i ++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d年", 1990 + i]];
    }
    //存储月份的数组
    NSMutableArray *monthArray = [[NSMutableArray alloc] initWithCapacity:12];
    for (int i = 0; i < 12; i ++)
    {
        [monthArray addObject:[NSString stringWithFormat:@"%d月", i + 1]];
    }
    //存储天数的数组
    NSMutableArray *dayArray = [[NSMutableArray alloc] initWithCapacity:31];
    for (int i = 0; i < 31; i ++)
    {
        [dayArray addObject:[NSString stringWithFormat:@"%d日", i + 1]];
    }
     //存储小时的数组
    NSMutableArray *timeArray = [[NSMutableArray alloc] initWithCapacity:23];
    for (int i = 0; i < 23; i ++)
    {
        [timeArray addObject:[NSString stringWithFormat:@"%d", i + 1]];
    }
     //存储分的数组
    NSMutableArray *partArray = [[NSMutableArray alloc] initWithCapacity:59];
    for (int i = 0; i < 59; i ++)
    {
        [partArray addObject:[NSString stringWithFormat:@"%d", i + 1]];
    }
    [self.date addObject:yearArray];
     [self.date addObject:monthArray];
     [self.date addObject:dayArray];
     [self.date addObject:timeArray];
     [self.date addObject:partArray];
  
    
    
    //将年、月、日都存放进字典
    _dataDic = [[NSDictionary alloc] initWithObjectsAndKeys:timeArray, @"time",partArray, @"part",dayArray, @"day", yearArray, @"year", monthArray, @"month", nil];
    
    //计算今天的日期
    NSDate *date = [NSDate date];
    date = [date dateByAddingTimeInterval:8 * 60 * 60];
    NSString *today = [date description];
    int yearNow = [[today substringToIndex:4] intValue];
    int monthNow = [[today substringWithRange:NSMakeRange(5, 2)] intValue];
    int dayNow = [[today substringWithRange:NSMakeRange(8, 2)] intValue];
    int timeNow = [[today substringWithRange:NSMakeRange(11, 2)]intValue];
    int partNow = [[today substringWithRange:NSMakeRange(14, 2)]intValue];
    //日期指定到今天，让日历默认显示今天的日期
    [_pickerView selectRow:(yearNow - 1990) inComponent:0 animated:NO];
    [_pickerView selectRow:(monthNow - 1) inComponent:1 animated:NO];
    [_pickerView selectRow:(dayNow - 1) inComponent:2 animated:NO];
    [_pickerView selectRow:(timeNow - 1) inComponent:3 animated:NO];
    [_pickerView selectRow:(partNow - 1) inComponent:4 animated:NO];
    
   field.text = [NSString stringWithFormat:@"%d/%d/%d/%d/%d",yearNow,monthNow,dayNow,timeNow,partNow];
    self.str = [NSString stringWithFormat:@"%d",yearNow];
    self.str1 = [NSString stringWithFormat:@"%d",monthNow];
    self.str2 = [NSString stringWithFormat:@"%d",dayNow];
    self.str3 = [NSString stringWithFormat:@"%d",timeNow];
    self.str4 = [NSString stringWithFormat:@"%d",partNow];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _dataDic.count; //设置选择器的列数，即显示年、月、日三列
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *keyArray = [_dataDic allKeys];
    NSArray *contentArray = [_dataDic objectForKey:keyArray[component]];
    //显示每月的天数跟年份和月份都有关系，所以需要判断条件
    if (component == 2)
    {
        NSInteger month = [_pickerView selectedRowInComponent:1] + 1;
        NSInteger year = [_pickerView selectedRowInComponent:0] + 1990;
        switch (month)
        {
                //每个月的天数不一样
            case 4: case 6: case 9: case 11:
            {
                contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 30)];//4、6、9、11月的天数是30天
                return contentArray.count;
            }
            case 2:
            {
                if ( [self isLeapYear:year])
                {
                    //如果是闰年，二月有 29 天
                    contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 29)];
                }
                else
                {
                    //不是闰年，二月只有 28 天
                    contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 28)];
                }
                
                return contentArray.count;
            }
            default:
                return contentArray.count;  //1、3、5、7、8、10、12 月的天数都是31天
        }
    }
    
    return contentArray.count;  //返回每列的行数
}
//返回高度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 100;
    }
    return (self.view.frame.size.width - 20 - 100)/ 4; //设置每列的宽度
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50; //设置每行的高度
}

//设置所在列每行的显示标题，与设置所在列的行数一样，天数的标题设置仍旧需要非一番功夫
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *keyArray = [_dataDic allKeys];
    NSArray *contentArray = [_dataDic objectForKey:keyArray[component]];
    
    if (component == 2)
    {
        NSInteger month = [pickerView selectedRowInComponent:1] + 1;
        NSInteger year = [pickerView selectedRowInComponent:0] +1990;
        switch (month)
        {
            case 4: case 6: case 9: case 11:
            {
                contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 30)];
                return contentArray[row];
            }
            case 2:
            {
                if ( [self isLeapYear:(int)year])
                {
                    //闰年
                    contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 29)];
                }
                else
                {
                    contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 28)];
                }
                
                return contentArray[row];
            }
            default:
                return contentArray[row];
        }
    }
    return contentArray[row];
}

//当选择的行数改变时触发的方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
     NSString *name = self.date[component][row];
    //第一列的被选择行变化，即年份改变，则刷新月份和天数
    if (component == 0)
    {
        [pickerView reloadAllComponents]; //刷新月份与日期
        //下面是将月份和天数都定位到第一行
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        self.str = name;
        [_pickerView reloadAllComponents];
    }
    //第二列的被选择行变化，即月份发生变化，刷新天这列的内容
    if (component == 1)
    {
        [pickerView reloadAllComponents];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        self.str1 = name;
    }//需要这些条件的原因是年份和月份的变化，都会引起每月的天数的变化，他们之间是有联系的，要掌握好他们之间的对应关系
    if (component == 2) {
        self.str2 = name;
        
    }if (component == 3) {
        self.str3 = name;
    }if (component == 4) {
        self.str4 = name;
    }
    field.text = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",self.str,self.str1,self.str2,self.str3,self.str4];
   
}

//判断是否闰年
- (BOOL)isLeapYear:(NSInteger)year
{
    if ((year % 400 == 0) || ((year % 4 == 0) && (year % 100 != 0)))
    {
        return YES; //是闰年返回 YES
    }
    
    return NO; //不是闰年，返回 NO
}

// 设置字体大小
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumFontSize = 8.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:UITextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}







@end


