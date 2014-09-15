#import "MySplitViewController.h"
static int MV_WIDTH  =320.0;	// Main view width
static int SV_GAP    =   2.0;	// Gap size
static int SB_HEIGHT =  0.0;	// Status bar height


@implementation MySplitViewController
@synthesize leftController,rightController;

- (MySplitViewController*) initWithLeftVC:(UIViewController*)leftvc rightVC:(UIViewController*)rightvc
{
	if(self=[super init])
	{
		UINavigationController *lnc=[[UINavigationController alloc] initWithRootViewController:leftvc];
		lnc.navigationBarHidden=NO;
		self.leftController=lnc;
        UIImage *image = [UIImage imageNamed:@"Bar.png"];
        [lnc.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        
               
        
        
        UINavigationController *rnc=[[UINavigationController alloc] initWithRootViewController:rightvc];
		rnc.navigationBarHidden=NO;
        [rnc.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
		self.rightController=rnc;
	}
	return self;
}

//---------------------------------------------------------------------------------------- viewDidLoad
- (void)viewDidLoad 
{ 
	[super viewDidLoad];
	self.view.autoresizesSubviews=YES;
	self.view.backgroundColor=[UIColor blackColor];
	
	[self.leftController viewDidLoad];
	[self.view addSubview:self.leftController.view];
	
	[self.rightController viewDidLoad];
	[self.view addSubview:self.rightController.view];
    
    
    
    

}

//---------------------------------------------------------------------------------------- viewDidAppear
- (void)viewDidAppear:(BOOL)animated 
{	
	self.leftController.view.frame=CGRectMake(0,SB_HEIGHT,MV_WIDTH,self.view.frame.size.height-SB_HEIGHT);
	[self.leftController viewDidAppear:animated];
	[self.view addSubview:self.leftController.view];
	
	self.rightController.view.frame=CGRectMake(MV_WIDTH+SV_GAP,SB_HEIGHT,700,self.view.frame.size.height-SB_HEIGHT);
	[self.rightController viewDidAppear:animated];
	[self.view addSubview:self.rightController.view];
}

//---------------------------------------------------------------------------------------- viewWillAppear
- (void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
	
	[self layoutViews:UIInterfaceOrientationPortrait initialVerticalOffset:SB_HEIGHT];
	
	[self.leftController viewWillAppear:animated];
	[self.rightController viewWillAppear:animated];
}

- (void)layoutSubviews 
{
	
}

//---------------------------------------------------------------------------------------- layoutViews
- (void)layoutViews:(UIInterfaceOrientation)orientation initialVerticalOffset:(float)offset {
	
	self.leftController.view.autoresizingMask=UIViewAutoresizingFlexibleHeight;
	
	
	CGRect svf = self.view.frame;

	if (offset > 0.0) 
	{
		svf.origin.y = offset;
		[self.view setFrame:svf];
	}
	
	CGRect mvf = self.leftController.view.frame;
	CGRect dvf = self.rightController.view.frame;
	
	mvf.origin.x		= 0;
	mvf.origin.y		= SB_HEIGHT;
	mvf.size.width  = MV_WIDTH;
	mvf.size.height = svf.size.height;
	
	[self.leftController.view setFrame:mvf];
	
	if (orientation==UIInterfaceOrientationLandscapeLeft || orientation==UIInterfaceOrientationLandscapeRight) {
		return; // the detail view will be properly sized, so don't mess with it
	}
		
	dvf.origin.x		= MV_WIDTH + SV_GAP;
	dvf.origin.y		= SB_HEIGHT;
	dvf.size.width	= svf.size.width - MV_WIDTH - SV_GAP;
	dvf.size.height = svf.size.height;
	
	[self.rightController.view setFrame:dvf];
}

-(BOOL)shouldAutorotate
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		return YES;
	}
	
	return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll;
}

//
//
// ROTATION
//
//---------------------------------------------------------------------------------------- shouldAutorotateToInterfaceOrientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {      
		return YES;
	} else {
		return (toInterfaceOrientation==UIInterfaceOrientationPortrait); //
	}

}

//---------------------------------------------------------------------------------------- didRotateFromInterfaceOrientation
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation 
{
	[self.leftController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[self.rightController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

//---------------------------------------------------------------------------------------- willAnimateRotationToInterfaceOrientation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{
	[self.leftController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self.rightController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

//
//
// CLEANUP
//
//---------------------------------------------------------------------------------------- didReceiveMemoryWarning
- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

//---------------------------------------------------------------------------------------- viewDidUnload
- (void)viewDidUnload 
{
	[super viewDidUnload];

}

	//---------------------------------------------------------------------------------------- dealloc

@end
