//
//  GroupCell.m
//  iWeibo
//
//  Created by dengwei on 15/7/30.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "GroupCell.h"
#import "UIImage+X.h"

@interface GroupCell ()
{
    UIImageView *_rightArrow;
}

@end

@implementation GroupCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //清空label的背景色
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
    }
    
    return self;
}

-(void)setCellType:(CellType)cellType
{
    _cellType = cellType;
    
    if (cellType == kCellTypeLabel) {
        if(_rightLabel == nil){
            UILabel *label = [[UILabel alloc]init];
            label.bounds = CGRectMake(0, 0, 60, 44);
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:12];
            _rightLabel = label;
        }
        
        self.accessoryView = _rightLabel;
        
    }else if(cellType == kCellTypeArrow){
        if (_rightArrow == nil) {
            _rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_icon_arrow.png"]];
        }
        
        self.accessoryView = _rightArrow;
    }else if(cellType == kCellTypeNone){
        self.accessoryView = nil;
    }else if(cellType == kCellTypeSwitch){
        if(_rightSwitch == nil){
            _rightSwitch = [[UISwitch alloc]init];
        }
        
        self.accessoryView = _rightSwitch;
    }else if (cellType == kCellTypeCheck){
        //self.accessoryType = UITableViewCellAccessoryCheckmark;
        if (_checkButton == nil) {
            _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
            CGRect checkboxRect = CGRectMake(0,0,25,25);
            [_checkButton setFrame:checkboxRect];
            [_checkButton setImage:[UIImage imageNamed:@"font_confirm.png"] forState:UIControlStateSelected];
        }
        self.accessoryView = _checkButton;
    }
    
    
}

-(void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    //当前组总行数
    int count = (int)[_mTableView numberOfRowsInSection:indexPath.section];
    
    if (count == 1) { //当前组只有一行
        _bg.image = [UIImage resizedImage:@"common_card_background.png"];
        _selectedBg.image = [UIImage resizedImage:@"common_card_background_highlighted.png"];
    }else if (indexPath.row == 0) { //当前组的首行
        _bg.image = [UIImage resizedImage:@"common_card_top_background.png"];
        _selectedBg.image = [UIImage resizedImage:@"common_card_top_background_highlighted.png"];
    }else if(indexPath.row == count - 1){ //当前组的末行
        _bg.image = [UIImage resizedImage:@"common_card_bottom_background.png"];
        _selectedBg.image = [UIImage resizedImage:@"common_card_bottom_background_highlighted.png"];
    }else{//当前组的中间行
        _bg.image = [UIImage resizedImage:@"common_card_middle_background.png"];
        _selectedBg.image = [UIImage resizedImage:@"common_card_middle_background_highlighted.png"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFrame:(CGRect)frame
{
    frame.origin.x = kTableBorderWidth;
    frame.size.width -= 2 * kTableBorderWidth;
    
    [super setFrame:frame];
}

@end
