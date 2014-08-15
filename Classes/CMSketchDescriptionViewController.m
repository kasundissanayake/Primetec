//
//  CMSketchDescriptionViewController.m
//  TabAndSplitApp
//
//  Created by Prime on 6/6/14.
//
//

#import "CMSketchDescriptionViewController.h"
#import "TabAndSplitAppAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface CMSketchDescriptionViewController ()
{
   TabAndSplitAppAppDelegate *appDelegate;
}

@end

@implementation CMSketchDescriptionViewController
@synthesize tag;
@synthesize imageName;
@synthesize txvDescription;
@synthesize addCommentView;
@synthesize btnSave;

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
    // Do any additional setup after loading the view.
    appDelegate=(TabAndSplitAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    addCommentView.layer.cornerRadius = 5;
    addCommentView.layer.masksToBounds = YES;
    addCommentView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    addCommentView.layer.borderWidth = 5.0f;
    txvDescription.layer.borderColor= [UIColor lightGrayColor].CGColor;
    txvDescription.layer.borderWidth = 3.0f;
    UIImage *buttonImageSave= [[UIImage imageNamed:@"whiteButton.png"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlightSave = [[UIImage imageNamed:@"whiteButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [btnSave setBackgroundImage:buttonImageSave forState:UIControlStateNormal]
    ;
    [btnSave setBackgroundImage:buttonImageHighlightSave forState:UIControlStateHighlighted];
    
    
    
    for (int i=0;i<appDelegate.sketchesArray.count; i++) {
        //addImageTag=@"";
        if([[[appDelegate.sketchesArray objectAtIndex:i]valueForKey:@"tag"] isEqualToString:tag])
        {
            txvDescription.text=[[appDelegate.sketchesArray objectAtIndex:i]valueForKey:@"description"];
            break;
        }
    }

}
-(IBAction)saveDesc:(id)sender
{
    // NSString *imageName=[NSString stringWithFormat:@"Sketch_%@",[self getCurrentDateTimeAsNSString]];
    NSMutableDictionary *decDictionary = [[NSMutableDictionary alloc] init];
    
    
    
    decDictionary=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                   tag, @"tag",
                   imageName, @"name",
                   txvDescription.text, @"description",
                   nil];
    
    
    for (int i=0;i<appDelegate.sketchesArray.count; i++) {
        //addImageTag=@"";
        if([[[appDelegate.sketchesArray objectAtIndex:i]valueForKey:@"tag"] isEqualToString:tag])
        {
            //[appDelegate.arrayImages objectAtIndex:i];
            [appDelegate.sketchesArray removeObjectAtIndex:i];
            break;
        }
    }
    
    
    
    [appDelegate.sketchesArray addObject:decDictionary];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSketch" object:nil];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
