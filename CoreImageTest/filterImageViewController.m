//
//  filterImageViewController.m
//  CoreImageTest
//
//  Created by YeYiFeng on 2018/4/2.
//  Copyright © 2018年 叶子. All rights reserved.
//

#import "filterImageViewController.h"
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
@interface filterImageViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImageView *imageView;
}

@end
/*
 
 CIFilter: 可变类，用于代表某种特定的处理效果，需要接收至少一个输入并产生一个输出图像
 
 CIImage: 不可变的图像类，可以通过合成数据，或者读取文件，也可以通过获取CIFilter对象的输出来得到CIImage对象
 
 CIContext: 它是core image用来绘制CIFilter所产生的目标图像的地方的对象，这个上下文可以是基于CPU也可以是基于GPU
 
 
 */

@implementation filterImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
      self.navigationItem.title = @"滤镜效果";
    
    imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit; // 填充模式
    [self.view addSubview:imageView];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.813 green:1.000 blue:0.564 alpha:1.000];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(50, 100, 120, 45);
    [button1 setTitle:@"找图片" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor brownColor];
    [button1 addTarget:self action:@selector(doit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(200, 100, 150, 45);
    [button setTitle:@"添加滤镜" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:102/255.0f green:153/255.0f blue:0.0f alpha:1] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button.layer setCornerRadius:5];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorRef = CGColorCreate(colorSpace,(CGFloat[]){ 102/255.0f, 153/255.0f, 0.0f, 1 });
    [button.layer setBorderColor:colorRef];
    [button.layer setBorderWidth:1.0f];
    [button addTarget:self action:@selector(addColorFilter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

//跳转相册的触发方法
- (void)doit{
    UIImagePickerController *vc = [[UIImagePickerController alloc]init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
    
    
}
//让图片显示在VC上面的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@",info);
    //获得选中的图像
    UIImage *chooseImage = info[UIImagePickerControllerOriginalImage];
    //给imageView赋值
    imageView.image = chooseImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)addColorFilter{
    
    // 1. 通过imageView转换为CIImage类型
    CIImage * inputImage = [CIImage imageWithCGImage:imageView.image.CGImage];
    NSLog(@"%@",[CIFilter filterNamesInCategory:kCICategoryDistortionEffect]);
    // 2. 初始化滤镜 设置属性
    CIFilter * filter = [CIFilter filterWithName:@"CIColorMonochrome"];// CIColorMonochrome CoreImage过滤器
    // 属性赋值
    [filter setValue:inputImage forKey:kCIInputImageKey];
    CIColor * color = [CIColor colorWithRed:1.0 green:0.75 blue:05 alpha:1];
    [filter setValue:color forKey:kCIInputColorKey];
    /*
     // 3.使用滤镜输出图像
     CIContext * context = [CIContext contextWithOptions:nil];
     // 滤镜处理之后，进行和原图片进行糅合
     CIImage * outPutImage = filter.outputImage;
     //1 滤镜输出的图像    2.合成之后图像的尺寸   图像.extent
     CGImageRef image = [context createCGImage:outPutImage fromRect:outPutImage.extent];
     // 4.展示
     imageView.image = [UIImage imageWithCGImage:image];
     */
    
    CIImage * outPutImage = filter.outputImage;
    [self addFilterLinkerWithImage:outPutImage]; // 添加滤镜链
    
}
//再次添加滤镜  ->  形成滤镜链
- (void)addFilterLinkerWithImage:(CIImage *)image
{
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setValue:image forKey:kCIInputImageKey];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef resultImage = [context createCGImage:filter.outputImage fromRect:filter.outputImage.extent];
    imageView.image = [UIImage imageWithCGImage:resultImage];
    //把添加好滤镜效果的图片   保存到相册
    //不可以直接保存 outputImage  ->  这是一个没有吧滤镜效果和源图合成的图像
    UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
//保存图片回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"保存成功");
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
