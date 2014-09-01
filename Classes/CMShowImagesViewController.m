//
//  CMShowImagesViewController.m
//  TabAndSplitApp
//
//  Created by Prime on 6/5/14.
//
//

#import "CMShowImagesViewController.h"
#import "TabAndSplitAppAppDelegate.h"

@interface CMShowImagesViewController ()
{
    NSString *folderName;
    NSString *tag;
    UIButton *btnCloseShowImage;
    TabAndSplitAppAppDelegate *appDelegate;
 
}

@end

@implementation CMShowImagesViewController
@synthesize arrayImages;
@synthesize txtDescription;
@synthesize scrollView,pageControl;
@synthesize viewGallery;
@synthesize isFromSketches;
@synthesize isFromReport;

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
    // Do any additional setup after loading the view from its nib.
    self.scrollView.scrollsToTop=NO;
    self.scrollView.delegate=self;
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
   
        folderName=@"DECK";
        //self.navigationItem.title=[NSString stringWithFormat:@"Add Images - %@",folderName];
    NSLog(@"Arrayyy -----");
   
    
    viewGallery.layer.borderColor = [UIColor lightGrayColor].CGColor;
    viewGallery.layer.borderWidth = 3.0f;
    [self setLibrary];


}
-(void)setLibrary
{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * arrayImages.count, self.scrollView.frame.size.height);
    for (int i = 0; i < arrayImages.count; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        UIImageView* imgView = [[UIImageView alloc] init];
        imgView.image =[self getImageFromFileName:[NSString stringWithFormat:@"%@.jpg", [[arrayImages objectAtIndex:i]valueForKey:@"name"]]];
        //[images objectAtIndex:i];
        imgView.frame = frame;
        [scrollView addSubview:imgView];
    }
    self.pageControl.currentPage = 0;
    if(arrayImages.count>0)
    {
        txtDescription.text=[[arrayImages objectAtIndex:0]valueForKey:@"description"];
         }
    if(!isFromSketches)
    {
        
    
    }
    else
    {
        appDelegate.sketchesArray = appDelegate.sketchesArray;
    }
    
    self.pageControl.numberOfPages = arrayImages.count;
}


-(UIImage *)getImageFromFileName:(NSString *)fileName
{
    //get images from document directory
    NSLog(@"image name......%@",fileName);
    UIImage *current_img;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *folderPath;
    
    if(isFromSketches)
    {
        folderPath= [documentsDirectory stringByAppendingPathComponent:@"/DESK"];
    }
    else
    {
        
        folderPath= [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    }
    
    NSString *fullPath = [folderPath stringByAppendingPathComponent:fileName];
    current_img=[UIImage imageWithContentsOfFile:fullPath];
    NSLog(@"current_img %@",current_img);
    return current_img;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (!pageControlBeingUsed) {
        // Switch the indicator when more than 50% of the previous/next page is visible
        CGFloat pageWidth = self.scrollView.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pageControl.currentPage = page;
        txtDescription.text=[[arrayImages objectAtIndex:page]valueForKey:@"description"];
        
    }
}

- (IBAction)changePage{
    // update the scroll view to the appropriate page
    NSLog(@"Eeeeeeeeeeeeeeeee");
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    int page=self.pageControl.currentPage;
    
    txtDescription.text=[[arrayImages objectAtIndex:page]valueForKey:@"description"];
     pageControlBeingUsed = YES;
}
-(IBAction)doneViewImages:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
