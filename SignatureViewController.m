//
//  SignatureViewController.m
//  ComSMART
//
//  Created by Lingeswaran Kandasamy on 5/8/14.
//
//

#import "SignatureViewController.h"
#import "MyView.h"
#import <QuartzCore/QuartzCore.h>



@interface SignatureViewController ()

@property (strong,nonatomic)  MyView *drawView;
@property (assign,nonatomic)  BOOL buttonHidden;
@property (assign,nonatomic)  BOOL widthHidden;


@end

@implementation SignatureViewController

static NSMutableArray *colors;
@synthesize btnClear,btnDone;
@synthesize image;
@synthesize imageViewTag;
@synthesize btnCancel;
@synthesize signatureSubview;

@synthesize ColorButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect viewFrame=CGRectMake(25,70, 540, 300);
    
    self.buttonHidden=YES;
    self.widthHidden=YES;
    self.drawView=[[MyView alloc]initWithFrame:viewFrame];
    [self.drawView setBackgroundColor:[UIColor whiteColor]];
    [self.signatureSubview addSubview: self.drawView];
    [self.signatureSubview sendSubviewToBack:self.drawView];
    [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
    signatureSubview.layer.cornerRadius=5;
    signatureSubview.layer.masksToBounds=YES;
    signatureSubview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    signatureSubview.layer.borderWidth = 3.0f;
    
    
    UIImage *buttonImageDone= [[UIImage imageNamed:@"whiteButton.png"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlightDone = [[UIImage imageNamed:@"whiteButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [btnDone setBackgroundImage:buttonImageDone forState:UIControlStateNormal]
    ;
    [btnDone setBackgroundImage:buttonImageHighlightDone forState:UIControlStateHighlighted];
    [btnCancel setBackgroundImage:buttonImageDone forState:UIControlStateNormal]
    ;
    [btnCancel setBackgroundImage:buttonImageHighlightDone forState:UIControlStateHighlighted];
    
    
}


-(IBAction)clear:(id)sender{
    NSLog(@"Clear");
    [self.drawView clear];
}
-(IBAction)clearA:(id)sender
{
    NSLog(@"Clear");
}
-(void)clearB
{
    NSLog(@"Clear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveScreen:(id)sender {
    [self.drawView setBackgroundColor:[UIColor whiteColor]];
    
    for (int i=1; i<16;i++) {
        UIView *view=[self.view viewWithTag:i];
        if ((i>=1&&i<=5)||(i>=10&&i<=15)) {
            if (view.hidden==YES) {
                continue;
            }
        }
        view.hidden=YES;
        if(i>=1&&i<=5){
            self.buttonHidden=YES;
        }
        if(i>=10&&i<=15){
            self.widthHidden=YES;
        }
    }
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect clippedRect  = CGRectMake(114,224, 350, 250);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    image   = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    
    if([imageViewTag isEqualToString:@"1"])
    {
        [self saveImageTaken:image imgName:@"Signature"];
    }
    else
    {
        [self saveImageTaken:image imgName:@"Signature_R"];
        
    }
    
    for (int i=1;i<16;i++) {
        if ((i>=1&&i<=5)||(i>=11&&i<=14)) {
            continue;
        }
        UIView *view=[self.view viewWithTag:i];
        view.hidden=NO;
    }
    if([imageViewTag isEqualToString:@"1"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DoneSignatureInspector" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DoneSignatureReviewer" object:nil];
        
    }
    
    //UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"Save OK" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    //[alertView show];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(get) name:@"goToTransactionDisplayView" object:nil];
}

-(IBAction)remove:(id)sender{
    [ self.drawView revocation];
}
-(IBAction)back:(id)sender{
    [ self.drawView refrom];
}
-(IBAction)changeColors:(id)sender{
    if (self.buttonHidden==YES) {
        for (int i=1; i<6; i++) {
            UIButton *button=(UIButton *)[self.view viewWithTag:i];
            button.hidden=NO;
            self.buttonHidden=NO;
        }
    }else{
        for (int i=1; i<6; i++) {
            UIButton *button=(UIButton *)[self.view viewWithTag:i];
            button.hidden=YES;
            self.buttonHidden=YES;
        }
        
    }
    
    
}

- (IBAction)colorSet:(id)sender {
    UIButton *button=(UIButton *)sender;
    [self.drawView setLineColor:button.tag-1];
    self.ColorButton.backgroundColor=[colors objectAtIndex:button.tag-1];
}

-(void)saveImageTaken:(UIImage *)imageNew imgName:(NSString *)imgName
{
    //store image in ducument directory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"/Signature"];
    NSLog(@"folderPath--- %@",folderPath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]){
        
        NSError *error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error])
            ;// success
        
        
        else
        {
            NSLog(@"[%@] ERROR: attempting to write create Images directory", [self class]);
        }
    }
    image = imageNew;
    if (image.size.width > 1000.0) {
        image = [self resizeImageToSize:(CGSizeMake(image.size.width/2, image.size.height/2))];
        NSLog(@"image croped %f",image.size.width);
    }
    //[imagesArray addObject:[NSString stringWithFormat:@"%@.jpg", imgName]];
    
    //NSData *imageData = UIImagePNGRepresentation(image);
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imgName]];
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
}

- (UIImage *)resizeImageToSize:(CGSize)targetSize
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // make image center aligned
        if (widthFactor < heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor > heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    return newImage ;
}


-(void)deleteAllFiles
{
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (error == nil) {
        for (NSString *path in directoryContents) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
            BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
            if (!removeSuccess) {
                // Error handling
                
            }
        }
    } else {
        // Error handling
        
    }
}

-(IBAction)removeSinature:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveSignature" object:nil];
    
}






@end
