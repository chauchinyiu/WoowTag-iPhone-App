//
//  WoowTagContstant.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/3/12.
//  Copyright 2012 WoowTag. All rights reserved.
//
#define kHongKongCoordinate CLLocationCoordinate2DMake(22.3000, -114.1667)

#define SEARCH_PRODUCT_URL @"http://woowtag-production.herokuapp.com/dev1/product_search?"
#define SEARCH_STORE_URL @"http://woowtag-production.herokuapp.com/dev1/store_search?"
#define PRODUCT_DETAIL_URL @"http://woowtag-production.herokuapp.com/dev1/product?id="
#define WOOWTAG_API @"http://woowtag-production.herokuapp.com/dev1/"
#define LASTSEARCH_KEY @"com.woowtag.mobile.lastsearch"
#define LASTSEARCH_DATE @"com.woowtag.mobile.lastsearch.date"
#define LASTSEARCH_TITLE @"The latest search products"
#define RESULTSNUMBER_PER_PAGE 5
#define RESULTS_FIRSTPAGE 1

#define GRID_BTN_SEARCH       11
#define GRID_BTN_FAV_STORE    12
#define GRID_BTN_FAV_PRODUCT  13
#define GRID_BTN_INFO         14

#define GRID_LASTSEARCH_SCROLLVIEW 15
#define GRID_LASTSEARCH_BOOKMARK 16

#define SEARCH_TEXTFIELD_LOCATION 19 

#define CELL_THUMBNAIL_IMAGE 21
#define CELL_TITLE_LABEL  22
#define CELL_PRICE_LABEL  23
#define CELL_STOCK_NUMBER_LABEL 24
#define CELL_STORE_LABEL 25
#define CELL_RATEVIEW 26
#define CELL_SHOWMORECELL_LOADING 27
#define CELL_SHOWMORECELL_BUTTON 28


#define DETAIL_MAIN_SCROLLVIEW 30
#define DETAIL_IMAGE_OVERVIEW_SCROLLVIEW 31
#define CELL_DETAIL_INFO_ICON 32
#define CELL_DETAIL_INFO_LABEL 33

#define CELL_STORE_INFO_ICON 40
#define CELL_STORE_INFO_LABEL 41


#define CELL_STORE_THUMBNAIL_IMAGE 50
#define CELL_STORE_TITLE_LABEL  51
#define CELL_STORE_ADDRESS_LABEL 52
#define CELL_STORE_TAGS_LABEL 53
#define CELL_STORE_PHONE_LABEL 54

#define SORT_KEYS  [NSArray arrayWithObjects: @"price", @"distance", @"relevance", @"created_date", nil]	
#define SORT_TITLES  [NSArray arrayWithObjects: @"Price", @"Distance", @"Relevance", @"Upload Date", nil]	


#define PIC_SMALL @"small"
#define PIC_THUMBNAIL @"thumb"
#define PIC_MEDIUM @"medium"
#define PIC_LARGER @"large"
#define PIC_ORIGINAL @"original"