//
//  PersonalPage.m
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "PersonalPage.h"
#import "BarView.h"
#import "TitleButton.h"
#import "UserModel.h"
#import "AccountManager.h"
#import "RespondModel.h"
#import "LoginPage.h"
#import "UploadImageUtil.h"

@interface PersonalPage ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UploadImageDelegate>

@property(strong, nonatomic) BarView *barView;
@property(strong, nonatomic) UIButton *headBtn;
@property(strong, nonatomic) UIImageView *headImageView;
@property(strong, nonatomic) UIButton *nickNameBtn;
@property(strong, nonatomic) UILabel *nickNameLabel;
@property(strong, nonatomic) UIButton *genderBtn;
@property(strong, nonatomic) UILabel *genderLabel;
@property(strong, nonatomic) UIButton *logoutBtn;


@end

@implementation PersonalPage{
    NSString *userNameStr;
    NSString *genderStr;
    NSString *avatarStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];

}

-(void)initView{
    _barView = [[BarView alloc]initWithTitle:@"个人信息" page:self];
    [self.view addSubview:_barView];
    [self initBody];
}

-(void)initBody{
    
    UserModel *userModel = [[AccountManager sharedAccountManager]getUserInfo];
    userNameStr = userModel.username;
    genderStr = userModel.gender;
    avatarStr = userModel.avatar;
    
    _headBtn = [[TitleButton alloc]initWithTitle:@"头像"];
    _headBtn.frame = CGRectMake(0, _barView.mj_y + _barView.mj_h + [PUtil getActualHeight:20],ScreenWidth, [PUtil getActualHeight:110]);
    [_headBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headBtn];
    [self buildLineView:_headBtn.mj_h+_headBtn.mj_y];
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.frame = CGRectMake([PUtil getActualWidth:622], [PUtil getActualHeight:26], [PUtil getActualWidth:58], [PUtil getActualWidth:58]);
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = [PUtil getActualWidth:58]/2;
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.backgroundColor = c01_blue;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.avatar]];
    [_headBtn addSubview:_headImageView];
    
    _nickNameBtn = [[TitleButton alloc]initWithTitle:@"昵称"];
    _nickNameBtn.frame = CGRectMake(0, _headBtn.mj_y + _headBtn.mj_h,ScreenWidth, [PUtil getActualHeight:110]);
    [_nickNameBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nickNameBtn];
    [self buildLineView:_nickNameBtn.mj_h+_nickNameBtn.mj_y];
    
    _nickNameLabel = [[UILabel alloc]init];
    _nickNameLabel.textColor = c08_text;
    _nickNameLabel.alpha = 0.5;
    _nickNameLabel.text = userModel.username;
    _nickNameLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    _nickNameLabel.textAlignment = NSTextAlignmentCenter;
    _nickNameLabel.frame = CGRectMake(ScreenWidth - [PUtil getActualWidth:84] - _nickNameLabel.contentSize.width, 0, _nickNameLabel.contentSize.width, _nickNameBtn.mj_h);
    [_nickNameBtn addSubview:_nickNameLabel];
    
    _genderBtn = [[TitleButton alloc]initWithTitle:@"性别"];
    _genderBtn.frame = CGRectMake(0, _nickNameBtn.mj_y + _nickNameBtn.mj_h,ScreenWidth, [PUtil getActualHeight:110]);
    [_genderBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_genderBtn];
    
    _genderLabel = [[UILabel alloc]init];
    _genderLabel.textColor = c08_text;
    _genderLabel.alpha = 0.5;
    if([userModel.gender isEqualToString: @"male"]){
        _genderLabel.text = @"男";
    }else{
        _genderLabel.text = @"女";
    }
    _genderLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:34]];
    _genderLabel.textAlignment = NSTextAlignmentCenter;
    _genderLabel.frame = CGRectMake(ScreenWidth - [PUtil getActualWidth:84] - _genderLabel.contentSize.width, 0, _genderLabel.contentSize.width, _nickNameBtn.mj_h);
    [_genderBtn addSubview:_genderLabel];
    
    _logoutBtn = [[UIButton alloc]init];
    _logoutBtn.frame = CGRectMake((ScreenWidth - [PUtil getActualWidth:542])/2, ScreenHeight - [PUtil getActualHeight:200],[PUtil getActualWidth:542] , [PUtil getActualHeight:100]);
    [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    _logoutBtn.layer.masksToBounds = YES;
    _logoutBtn.layer.cornerRadius = [PUtil getActualHeight:100]/2;
    [_logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_logoutBtn];
    [ColorUtil setGradientColor:_logoutBtn startColor:c01_blue endColor:c02_red director:Left];
    
}

-(void)buildLineView : (int)height{
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = c05_divider;
    lineView.frame = CGRectMake([PUtil getActualWidth:30], height-1, ScreenWidth -[PUtil getActualWidth:30] , 1);
    [self.view addSubview:lineView];
    
}

-(void)OnClick : (id)sender{
    UIButton *button = sender;
    if(button == _headBtn){
        [self selectImage];
    }else if(button == _nickNameBtn){
        [self selectNickName];
    }else if(button == _genderBtn){
        [self selectGender];
    }
}


//
-(void)selectImage{
    [UMUtil clickEvent:EVENT_HEAD];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
    
    UIAlertAction *photosAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [alert addAction:cameraAction];
    }
    [alert addAction:photosAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _headImageView.image = image;
    NSData *data = UIImagePNGRepresentation(image);
    [UploadImageUtil getUploadToken:data delegate:self];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)uploadSuccess:(NSString *)imageUrl{
    UserModel *userModel = [[AccountManager sharedAccountManager]getUserInfo];
    avatarStr = imageUrl;
    [[AccountManager sharedAccountManager]saveUserInfo:userModel];
    [self updateUserInfo:YES];
}

-(void)uploadFail{
    [DialogHelper showFailureAlertSheet:@"上传失败"];
}

-(void)selectNickName{
    [UMUtil clickEvent:EVENT_NICKNAME];

    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"修改昵称"
                                                                              message: nil
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入昵称";
        textField.textColor = [UIColor blackColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
 
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * textField = textfields[0];
        if(IS_NS_STRING_EMPTY(textField.text)){
            [DialogHelper showFailureAlertSheet:@"昵称不能为空"];
            return;
        }
        _nickNameLabel.text = textField.text;
         CGSize size = [textField.text boundingRectWithSize:CGSizeMake( ScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[PUtil getActualHeight:34]]} context:nil].size;
        _nickNameLabel.frame = CGRectMake(ScreenWidth - [PUtil getActualWidth:84] - size.width, 0, size.width, _nickNameBtn.mj_h);
        userNameStr = textField.text;
        [self updateUserInfo : NO];
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


//
-(void)selectGender{
    
    [UMUtil clickEvent:EVENT_GENDER];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _genderLabel.text = @"男";
        genderStr = @"male";
        [self updateUserInfo : NO];
    }];
    
    UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        _genderLabel.text = @"女";
        genderStr = @"female";
        [self updateUserInfo : NO];
    }];
 
    [alert addAction:maleAction];
    [alert addAction:femaleAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)logout{
    [UMUtil clickEvent:EVENT_LOGOUT];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"refresh_token"] = [[AccountManager sharedAccountManager] getAccount].refresh_token;
    [ByNetUtil post:API_LOGOUT parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            [[AccountManager sharedAccountManager] clear];
            LoginPage *page = [[LoginPage alloc]init];
            [self pushPage:page];
        }else{
            [DialogHelper showFailureAlertSheet:respondModel.msg];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        [DialogHelper showFailureAlertSheet:@"请求失败"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
}

-(void)updateUserInfo : (Boolean)uploadAvatar{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic= [[NSMutableDictionary alloc]init];
    dic[@"username"] = userNameStr;
    dic[@"avatar"] = avatarStr;
    dic[@"gender"] = genderStr;
    [ByNetUtil post:API_UPLOAD_USERINFO parameters:dic success:^(RespondModel *respondModel) {
        if(respondModel.code == 200){
            if(uploadAvatar){
                [DialogHelper showSuccessTips:@"上传成功"];
            }
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
