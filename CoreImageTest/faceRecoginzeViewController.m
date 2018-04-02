//
//  faceRecoginzeViewController.m
//  CoreImageTest
//
//  Created by YeYiFeng on 2018/4/2.
//  Copyright © 2018年 叶子. All rights reserved.
//

#import "faceRecoginzeViewController.h"

@interface faceRecoginzeViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImageView *imageView;
}
@property (strong, nonatomic) UIImagePickerController *imagePicker;


@end

@implementation faceRecoginzeViewController
- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
    }
    return _imagePicker;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagePicker.delegate = self;
 
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"人脸识别";
    
    imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"1"];
    imageView.contentMode = UIViewContentModeScaleAspectFit; // 填充模式
    [self.view addSubview:imageView];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.813 green:1.000 blue:0.564 alpha:1.000];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(20, 70, 50, 45);
    [button1 setTitle:@"拍照" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor brownColor];
    [button1 addTarget:self action:@selector(doit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-70, 70, 50, 45);
    [button setTitle:@"开始识别" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:102/255.0f green:153/255.0f blue:0.0f alpha:1] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button.layer setCornerRadius:5];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorRef = CGColorCreate(colorSpace,(CGFloat[]){ 102/255.0f, 153/255.0f, 0.0f, 1 });
    [button.layer setBorderColor:colorRef];
    [button.layer setBorderWidth:1.0f];
    [button addTarget:self action:@selector(goFace) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
}
// 拍照
-(void)doit {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"需要真机运行，才能打开相机哦" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    _imagePicker.allowsEditing = false;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    
   
}
// 开始识别 方法
-(void)goFace
{
    [self facedetect:imageView.image];
    
}
#pragma mark - 开始识别
- (void)facedetect:(UIImage*)faceImage
{
    
    
    // 图像识别能力
    NSDictionary * opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    // 将图像转换为CIImage
    CIImage * faceImg = [CIImage imageWithCGImage:faceImage.CGImage];
//    CIImage * faceImg = [CIImage imageWithCGImage:SteveCurry.CGImage];
    // 开始进行识别
    CIDetector * faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:opts];
    // 识别出人脸数组
    NSArray * features = [faceDetector featuresInImage:faceImg];
    // 得到图片的尺寸
    CGSize inputImageSize = [faceImg extent].size;
    // 转换坐标系
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
    //将图片上移
    transform = CGAffineTransformTranslate(transform, 0, -inputImageSize.height);
    
    // 取出所有人脸
    for (CIFaceFeature *faceFeature in features){
        //获取人脸的frame
        CGRect faceViewBounds = CGRectApplyAffineTransform(faceFeature.bounds, transform);
        CGSize viewSize = imageView.bounds.size;
        CGFloat scale = MIN(viewSize.width / inputImageSize.width,
                            viewSize.height / inputImageSize.height);
        CGFloat offsetX = (viewSize.width - inputImageSize.width * scale) / 2;
        CGFloat offsetY = (viewSize.height - inputImageSize.height * scale) / 2;
        // 缩放
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
        // 修正
        faceViewBounds = CGRectApplyAffineTransform(faceViewBounds,scaleTransform);
        faceViewBounds.origin.x += offsetX;
        faceViewBounds.origin.y += offsetY;
        
        //描绘人脸区域
        UIView* faceView = [[UIView alloc] initWithFrame:faceViewBounds];
        faceView.layer.borderWidth = 2;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        [imageView addSubview:faceView];
        
        // 判断是否有左眼位置
        if(faceFeature.hasLeftEyePosition){}
        // 判断是否有右眼位置
        if(faceFeature.hasRightEyePosition){}
        // 判断是否有嘴位置
        if(faceFeature.hasMouthPosition){}
    }
    
    if (features.count > 0) {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到了人脸" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];

    } else {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未检测到人脸" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];

    }
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

@end
