//
//  AddressPage.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "AddressPage.h"
#import "BarView.h"
#import "InsetTextField.h"
#import "AddressPickerView.h"
#import "AccountManager.h"
#import "RespondModel.h"

@interface AddressPage ()<UITextFieldDelegate,AddressPickerViewDelegate>

@property (strong, nonatomic) BarView *barView;
@property (strong, nonatomic) UIView *bodyView;
@property (strong, nonatomic) InsetTextField *receiverTextField;
@property (strong, nonatomic) InsetTextField *phoneNumTextField;
@property (strong, nonatomic) UIButton *areaBtn;
@property (strong, nonatomic) InsetTextField *addressTextField;
@property (strong, nonatomic) UIButton *saveBtn;
@property (strong, nonatomic) AddressPickerView *addressPickerView;
@property (strong, nonatomic) UILabel *areahintLabel;

@end

@implementation AddressPage{
    AddressModel *model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self requestAddress];
}

-(void)initView{
    
    _barView = [[BarView alloc]initWithTitle:@"地址信息" page:self];
    [self.view addSubview:_barView];
    
    _bodyView = [[UIView alloc]init];
    _bodyView.backgroundColor = c07_bar;
    _bodyView.frame = CGRectMake(0,_barView.mj_h + _barView.mj_y +  [PUtil getActualHeight:20], ScreenWidth, [PUtil getActualHeight:570]);
    [self.view addSubview:_bodyView];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(0, [PUtil getActualWidth:30], 0, [PUtil getActualWidth:30]);
    _receiverTextField = [[InsetTextField alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, [PUtil getActualHeight:110]) andInsets:inset hint:@"收货人"];
    _receiverTextField.backgroundColor = c07_bar;
    _receiverTextField.textColor = c08_text;
    _receiverTextField.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    [_receiverTextField check];
    [_bodyView addSubview:_receiverTextField];
    [self buildLineView:_receiverTextField.mj_y + _receiverTextField.mj_h];
    
    _phoneNumTextField = [[InsetTextField alloc]initWithFrame:CGRectMake(0, [PUtil getActualHeight:110],ScreenWidth, [PUtil getActualHeight:110]) andInsets:inset hint:@"手机号"];
    _phoneNumTextField.backgroundColor = c07_bar;
    _phoneNumTextField.textColor = c08_text;
    _phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumTextField.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    [_phoneNumTextField check];
    [_bodyView addSubview:_phoneNumTextField];
    [self buildLineView:_phoneNumTextField.mj_y + _phoneNumTextField.mj_h];
    
    _areahintLabel = [[UILabel alloc]init];
    _areahintLabel.frame = CGRectMake([PUtil getActualWidth:30],  [PUtil getActualHeight:220],ScreenWidth, [PUtil getActualHeight:110]);
    _areahintLabel.alpha = 0.5f;
    _areahintLabel.text = @"地区";
    _areahintLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    _areahintLabel.textColor = c08_text;
    [_bodyView addSubview:_areahintLabel];
    


    _areaBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,  [PUtil getActualHeight:220],ScreenWidth, [PUtil getActualHeight:110])];
    [_areaBtn setTitleColor:c08_text forState:UIControlStateNormal];
    _areaBtn.titleLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    _areaBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _areaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _areaBtn.titleEdgeInsets = UIEdgeInsetsMake(0, [PUtil getActualWidth:30], 0, 0);
    [_areaBtn addTarget:self action:@selector(OnAddressClick) forControlEvents:UIControlEventTouchUpInside];
    [_bodyView addSubview:_areaBtn];
    [self buildLineView:_areaBtn.mj_y+_areaBtn.mj_h];
    
    _addressTextField = [[InsetTextField alloc]initWithFrame:CGRectMake(0,  [PUtil getActualHeight:330],ScreenWidth, [PUtil getActualHeight:240]) andInsets:inset hint:@"详细地址"];
    _addressTextField.backgroundColor = c07_bar;
    _addressTextField.textColor = c08_text;
    _addressTextField.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    [_addressTextField check];
    [_bodyView addSubview:_addressTextField];
    
    _saveBtn = [[UIButton alloc]init];
    _saveBtn.frame = CGRectMake((ScreenWidth - [PUtil getActualWidth:542])/2, [PUtil getActualHeight:60]+_bodyView.mj_h+_bodyView.mj_y ,[PUtil getActualWidth:542] , [PUtil getActualHeight:100]);
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    _saveBtn.layer.masksToBounds = YES;
    _saveBtn.layer.cornerRadius = [PUtil getActualHeight:100]/2;
    [_saveBtn addTarget:self action:@selector(doSave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBtn];
    [ColorUtil setGradientColor:_saveBtn startColor:c01_blue endColor:c02_red director:Left];
}

-(void)buildLineView : (int)height{
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = c05_divider;
    lineView.frame = CGRectMake([PUtil getActualWidth:30], height-1, ScreenWidth -[PUtil getActualWidth:30] , 1);
    [_bodyView addSubview:lineView];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_receiverTextField resignFirstResponder];
    [_addressTextField resignFirstResponder];
    [_phoneNumTextField resignFirstResponder];
}


-(void)OnAddressClick{
    if([_addressPickerView isShow]){
        return;
    }
    [_receiverTextField resignFirstResponder];
    [_addressTextField resignFirstResponder];
    [_phoneNumTextField resignFirstResponder];
    
    _addressPickerView = [[AddressPickerView alloc]initWithFrame:CGRectMake(0, ScreenHeight ,ScreenWidth , ScreenHeight)];
    _addressPickerView.delegate = self;
    [self.view addSubview:_addressPickerView];
    [_addressPickerView show];
}

-(void)cancelBtnClick{
    [_addressPickerView hide];
}

-(void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
    [_addressPickerView hide];
    NSString *result = [NSString stringWithFormat:@"%@%@%@",province,city,area];
    [_areaBtn setTitle:result forState:UIControlStateNormal];
    _areahintLabel.hidden = YES;
}


-(void)doSave{
    [UMUtil clickEvent:EVENT_SAVE_ADDRESS];
    if(IS_NS_STRING_EMPTY(_receiverTextField.text)){
        [DialogHelper showFailureAlertSheet:@"请填写收货人"];
        return;
    }
    if(IS_NS_STRING_EMPTY(_phoneNumTextField.text)){
        [DialogHelper showFailureAlertSheet:@"请填写手机号"];
        return;
    }
    if(IS_NS_STRING_EMPTY(_areaBtn.titleLabel.text)){
        [DialogHelper showFailureAlertSheet:@"请填写地区"];
        return;
    }
    if(IS_NS_STRING_EMPTY(_addressTextField.text)){
        [DialogHelper showFailureAlertSheet:@"请填写详细地址"];
        return;
    }
    [self requestUpdateAddress];
}

-(void)updateAddress{
    _receiverTextField.text = model.receiver;
    _phoneNumTextField.text = model.tel;
    if(!IS_NS_STRING_EMPTY(model.location)){
        _areahintLabel.hidden = YES;
    }
    [_areaBtn setTitle:model.location forState:UIControlStateNormal];
    _addressTextField.text = model.address_detail;
    [_receiverTextField check];
    [_phoneNumTextField check];
    [_addressTextField check];
}


-(void)requestAddress{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ByNetUtil get:API_GET_ADDRESS parameters:nil success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            id data = respondModel.data;
            model = [AddressModel mj_objectWithKeyValues:data];
            [self updateAddress];

        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"请求失败"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void)requestUpdateAddress{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"receiver"]= _receiverTextField.text;
    dic[@"tel"]= _phoneNumTextField.text;
    dic[@"address_detail"]= _areaBtn.titleLabel.text;
    dic[@"location"]= _addressTextField.text;
    [ByNetUtil post:API_UPDATE_ADDRESS parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            [DialogHelper showSuccessTips:@"保存成功"];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"请求失败"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}


@end
