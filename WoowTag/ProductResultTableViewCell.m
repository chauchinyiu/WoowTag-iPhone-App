// ProductResultTableViewCell.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ProductResultTableViewCell.h"
#import "WoowTagContstant.h"
#import "Product.h"
#import "SaveProduct.h"

#import "UIImageView+AFNetworking.h"

@implementation ProductResultTableViewCell {
       
}

@synthesize product = _product;
@synthesize saveProduct = _saveProduct;
@synthesize title = _title;
@synthesize price = _price;
@synthesize numberInStock = _numberInStock;
@synthesize store = _store;
@synthesize address = _address;
@synthesize thumbnail = _thumbnail;
@synthesize rateView = _rateView; 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }

    return self;
}

- (void)setProduct:(Product *)product {
    
    UIImageView  *thumbnail = (UIImageView *)[self viewWithTag:CELL_THUMBNAIL_IMAGE];
	UILabel *lblTitle = (UILabel *)[self viewWithTag:CELL_TITLE_LABEL];
	UILabel *lblPrice = (UILabel *)[self viewWithTag:CELL_PRICE_LABEL];
	UILabel *lblNumberInStock = (UILabel *)[self viewWithTag:CELL_STOCK_NUMBER_LABEL];
	UILabel *lblStore = (UILabel *)[self viewWithTag:CELL_STORE_LABEL];

    _rateView =  [[DYRateView alloc] initWithFrame:CGRectMake(190, 71, 140, 14)]  ;
    [self addSubview:_rateView];
    
    _product = product;
    lblTitle.text= _product.name;
    lblPrice.text = [NSString stringWithFormat:@"%@",_product.price]; 
    lblNumberInStock.text = [NSString stringWithFormat:@"%@",_product.stock];
    lblStore.text =  [[_product store] name];
    
    _rateView.rate = [_product.rate floatValue];
    _rateView.alignment = RateViewAlignmentLeft;
     NSURL *url = [NSURL URLWithString: [_product.imagelinks objectAtIndex:0]];
    [thumbnail setImageWithURL:url placeholderImage:[UIImage imageNamed:@"product_preview"]];
    
    
}

- (void)setSaveProduct:(SaveProduct *)saveproduct {
    
    UIImageView  *thumbnail = (UIImageView *)[self viewWithTag:CELL_THUMBNAIL_IMAGE];
	UILabel *lblTitle = (UILabel *)[self viewWithTag:CELL_TITLE_LABEL];
	UILabel *lblPrice = (UILabel *)[self viewWithTag:CELL_PRICE_LABEL];
	UILabel *lblNumberInStock = (UILabel *)[self viewWithTag:CELL_STOCK_NUMBER_LABEL];
	UILabel *lblStore = (UILabel *)[self viewWithTag:CELL_STORE_LABEL];
 
    _rateView =  [[DYRateView alloc] initWithFrame:CGRectMake(190, 73, 140, 14)]  ;
    [self addSubview:_rateView];
    _saveProduct = saveproduct;
    lblTitle.text= _saveProduct.name;
    lblPrice.text = [NSString stringWithFormat:@"%@",_saveProduct.price]; 
    lblNumberInStock.text = [NSString stringWithFormat:@"%@",_saveProduct.stock];
    lblStore.text =  [_saveProduct  storename];
    _rateView.rate = [_saveProduct.rate floatValue]; 
    _rateView.alignment = RateViewAlignmentLeft;
    NSURL *url = [NSURL URLWithString: [_saveProduct.imagelinks objectAtIndex:0]];
    [thumbnail setImageWithURL:url placeholderImage:[UIImage imageNamed:@"product_preview"]];
    
    
}

@end
