//
//  ThumbnailScrollView.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/20/12.
//  Copyright 2012 Woow!Tag. All rights reserved.
//

#import "ThumbnailScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

@interface ThumbnailScrollView()
- (void)layoutScrollImages;
-(void) handleTapOnImage:(id)sender;

@end
@implementation ThumbnailScrollView
@synthesize thumbnailScrollView = _thumbnailScrollView;
@synthesize bookmarkImageView =_bookmarkImageView;
@synthesize images =_images;
@synthesize products =_products;
@synthesize delegate = _delegate;
@synthesize titlelabel;
#define IMAGE_WIDTH       100
#define IMAGE_HEIGHT      100
#define IMAGE_SPACING      5
#define IMAGE_PADDING      5
- (id)init
{   
    UIImage *bookmarkimg = [UIImage imageNamed:@"history_tag.png"];
    self.bookmarkImageView = [[UIImageView alloc] initWithImage:bookmarkimg];
    self.bookmarkImageView.frame = CGRectMake(280,   0 , self.bookmarkImageView.frame.size.width, self.bookmarkImageView.frame.size.height);

    self = [super initWithFrame:CGRectMake(0, 0, 320, 160)];
    [self setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.bookmarkImageView];
    
    
    self.thumbnailScrollView.clipsToBounds = YES;		
	self.thumbnailScrollView.scrollEnabled = YES;
    [self.thumbnailScrollView setShowsHorizontalScrollIndicator:NO];
    self.titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 320, 15)];
    self.titlelabel.font=  [UIFont fontWithName:@"Arial" size:10];;
    self.titlelabel.text = @"The latest search products";
    self.titlelabel.textColor = [UIColor blackColor];
    [self.titlelabel setBackgroundColor: [UIColor clearColor]];
    self.thumbnailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, 320, 120)];
    [self.thumbnailScrollView setBackgroundColor:[UIColor  grayColor]];
    [self addSubview:self.titlelabel];
    self.tag = GRID_LASTSEARCH_SCROLLVIEW;
    [self addSubview:self.thumbnailScrollView];
    [self addSubview:self.titlelabel];
	if (self) {
        
		self.opaque = NO;
        
    }
    return self;
}


-(void) setProductsImage:(NSArray *) items{
    // load all the images from our bundle and add them to the scroll view
    self.products = nil;
    for(UIView *subview in [self.thumbnailScrollView subviews]) {
        [subview removeFromSuperview];
    }
    self.products = items;
	for (int i = 0; i <[self.products count]  ; i++)
	{
        
        Product* prod = [self.products objectAtIndex:i] ;
        
        
        NSString *urlstring= [prod.imagelinks objectAtIndex:0];
        
        
        UIView *frameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_WIDTH ,IMAGE_HEIGHT )];
        
        [[frameView layer] setBorderColor:[[UIColor blackColor] CGColor]];
        [[frameView layer] setBorderWidth: 1.0];
        [[frameView layer] setBackgroundColor:[[UIColor whiteColor] CGColor]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, IMAGE_WIDTH-10, IMAGE_HEIGHT-10) ];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSURL *url = [NSURL URLWithString:urlstring];
        [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"product_preview"]];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnImage:)];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnImage:)];
        [frameView addGestureRecognizer:singleTap];
        [frameView addGestureRecognizer:doubleTap];
        frameView.tag = i+1   ;
        [frameView addSubview:imageView];
        [self.thumbnailScrollView addSubview:frameView];
        
 
  		// now place the photos in serial layout within the scrollview
    }
    [self layoutScrollImages];
}

- (void)layoutScrollImages
{
	UIView *view = nil;
	NSArray *subviews = [self.thumbnailScrollView subviews];
    
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curXLoc = IMAGE_PADDING;
    int count = [subviews count];
    int imageindex = 0;
	for (int i=0 ; i<count  ; i++)
	{   view =  [subviews objectAtIndex:i];
		if ([view isKindOfClass:[UIView class]] && view.tag  >0)
		{   CGRect frame = view.frame;
            
            if(imageindex==0){
                frame.origin = CGPointMake(curXLoc, 15);
                view.frame = frame;
                curXLoc += (IMAGE_WIDTH);
            }else{
                curXLoc+= IMAGE_SPACING;
                frame.origin = CGPointMake(curXLoc, 15);
                view.frame = frame;
                curXLoc += (IMAGE_WIDTH);
            }
            imageindex++;
		}
	}
	
    
    
    [self.thumbnailScrollView setContentSize:CGSizeMake(([self.products count]  * IMAGE_WIDTH)+(([self.products count]-1)*IMAGE_SPACING)+ IMAGE_PADDING *2, IMAGE_HEIGHT )];
    
}

-(void) handleTapOnImage:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageClickedAtView:)]) {
        [self.delegate performSelector:@selector(imageClickedAtView:) withObject:sender];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
