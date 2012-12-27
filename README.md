IndeterminateProgressView
=========================

A customizable indeterminate progress view for iOS without using images.

### Setup

Clone the repo and add the folder to your project.

Import the header

	#import "IndeterminateProgressView.h"

Initialize the control

	IndeterminateProgressView *v = [[IndeterminateProgressView alloc] initWithFrame:CGRectMake(20, 20, 280, 30)];

Customize the control

	[v setBottomFillColor:[UIColor colorWithWhite:0.2f alpha:1.0f]];
	[v setTopFillColor:[UIColor colorWithWhite:0.3f alpha:1.0f]];
	[v setBorderRadius:15.0f];
	[v setBorderWidth:2.0f];
	[v setStripeWidth:10.0f];
	
Add it to your view
	
	[self.view addSubview:v];

Manually Start Progress
- I did this to allow for the customization

	[v startProgressing];


