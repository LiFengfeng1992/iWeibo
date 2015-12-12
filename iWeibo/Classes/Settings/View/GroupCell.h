//
//  GroupCell.h
//  iWeibo
//
//  Created by dengwei on 15/7/30.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "BaseCell.h"

typedef enum{
    kCellTypeNone, //没有样式
    kCellTypeArrow, //箭头
    kCellTypeLabel, //文字
    kCellTypeSwitch, //开关
    kCellTypeCheck //选中勾号
}CellType;

@interface GroupCell : BaseCell

@property (nonatomic, readonly)UISwitch *rightSwitch;
@property (nonatomic, readonly)UILabel *rightLabel;
@property (nonatomic, copy) UIButton *checkButton;
@property (nonatomic, assign)CellType cellType;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, weak)UITableView *mTableView;

@end
