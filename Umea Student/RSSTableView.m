//
//  RSSTableView.m
//  Umea Student
//
//  Created by Joakim Mickelsson on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RSSTableView.h"

@implementation RSSTableView
@synthesize tableView;
@synthesize rssObject;
@synthesize rssOutputData;
@synthesize xmlParserObject;
@synthesize nodecontent;
@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize dateLabel;
@synthesize cell;
@synthesize tableViewIsLoaded;
@synthesize spinner;
@synthesize headerTitle;
@synthesize webView;

// The designated initializer. Override to perform setup that is required before the view is loaded.


#pragma mark NSXMLParser delegate

//below delegate method is sent by a parser object to provide its delegate when it encounters a start tag 

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	//if element name is equat to item then only i am assingning memory to the NSObject class
    
	if([elementName isEqualToString:@"item"]){
		self.rssObject =[[RSS alloc]init];
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	//whatever data i am getting from node i am appending it to the nodecontent variable
    
    NSString *stringy = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
	[self.nodecontent appendString:stringy];
}

//bellow delegate method specify when it encounter end tag of specific that tag

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	//I am saving my nodecontent data inside the property of XMLString File class
	
	if([elementName isEqualToString:@"title"]){
		self.rssObject.title=nodecontent;
	}
	else if([elementName isEqualToString:@"link"]){
		self.rssObject.url=nodecontent;
	}
    
    else if([elementName isEqualToString:@"description"]){
        self.rssObject.description=nodecontent;
        
    }
    
    else if([elementName isEqualToString:@"dc:date"]){
        self.rssObject.pubDate=nodecontent;
        
        
    }
	
	//finally when we reaches the end of tag i am adding data inside the NSMutableArray
	if([elementName isEqualToString:@"item"]){
        if(rssObject){
            [self.rssOutputData addObject:rssObject];
            
        }
        self.rssObject = nil;
	}
    
	//reallocate the memory to get new content data from file
	self.nodecontent=[[NSMutableString alloc]init];
}

-(void)setupRSSTableView:(NSString *)urlString{
    
    self.rssOutputData = [[NSMutableArray alloc]init];
    
     NSData *xmlData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    
    //declare the object of allocated variable
    //  NSData *xmlData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:@"http://www.umu.se/om-universitetet/aktuellt/kalendarium/rss/kalender-rss/?categories=concert,conference,courseEducation,culturOnCampus,dissertation,exhibition,lecture,licentiateSeminar,meeting,theOthers,seminar,seminarSeries,umea2014,workshop&calendarIds=32&fromSiteNodeId=39132"]];
    
    //allocate memory for parser as well as 
    self.xmlParserObject =[[NSXMLParser alloc]initWithData:xmlData];
    [self.xmlParserObject setDelegate:self];
    
    //asking the xmlparser object to beggin with its parsing
    [self.xmlParserObject parse];
    
   

    
    // self.tableView.layer.cornerRadius = 10;
    
    
}



-(void)roundOfCorners{
    //  self.tableView.layer.cornerRadius = 10;
  
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES; 
    
}


#pragma Mark For Table View Method:-

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return[self.rssOutputData count];
	
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    RSS *news = [self.rssOutputData objectAtIndex:indexPath.row];
    
    CGSize titleLabelSize = [news.title sizeWithFont:[UIFont boldSystemFontOfSize:12.0f] constrainedToSize:CGSizeMake(245.0f, 1000) lineBreakMode:UILineBreakModeWordWrap];
    CGSize descriptionLabelSize = [news.description sizeWithFont:[UIFont systemFontOfSize:11.0f] constrainedToSize:CGSizeMake(245.0f, 1000) lineBreakMode:UILineBreakModeWordWrap];
    CGSize pubDateLabelSize = [news.pubDate sizeWithFont:[UIFont systemFontOfSize:11.0f] constrainedToSize:CGSizeMake(245.0f, 1000) lineBreakMode:UILineBreakModeTailTruncation];
    
    return titleLabelSize.height +descriptionLabelSize.height + pubDateLabelSize.height + 15; 
}



- (RSSCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"Cell";
	
	self.cell = [self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
	
	// If no cell is available, create a new one using the given identifier
	if (cell == nil) {
		
		//add some extra text on table cell .........
        cell = [[RSSCell alloc]
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:MyIdentifier];
        
    }
    
    RSS *news = [self.rssOutputData objectAtIndex:indexPath.row];
    
	// Set up the cell
	cell.titleLabel.text= news.title;
    cell.dateLabel.text  = news.pubDate;

    if(news.description == nil){
    	cell.descriptionLabel.text = news.title;
    }
    else{
    	cell.descriptionLabel.text = news.description;
        
    }
    
    cell.titleLabel.numberOfLines = 0;
        cell.descriptionLabel.numberOfLines = 0;
    
    CGSize titleLabelSize = [cell.titleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:12.0f] constrainedToSize:CGSizeMake(245.0f, 1000) lineBreakMode:UILineBreakModeWordWrap];
    
    CGSize descriptionLabelSize = [cell.descriptionLabel.text sizeWithFont:[UIFont systemFontOfSize:11.0f] constrainedToSize:CGSizeMake(245.0f, 1000) lineBreakMode:UILineBreakModeWordWrap];
    
    CGSize pubDateLabelSize = [news.pubDate sizeWithFont:[UIFont systemFontOfSize:11.0f] constrainedToSize:CGSizeMake(245.0f, 1000) lineBreakMode:UILineBreakModeTailTruncation];
    
    cell.titleLabel.frame = CGRectMake(20, 2, 245, titleLabelSize.height);   

    cell.descriptionLabel.frame = CGRectMake(20, 5 + titleLabelSize.height, 245, descriptionLabelSize.height);    
    
    cell.dateLabel.frame = CGRectMake(20, 5 + cell.descriptionLabel.frame.origin.y + descriptionLabelSize.height, 245, pubDateLabelSize.height);    
    
    
    [cell.descriptionLabel sizeToFit];
    [cell.titleLabel sizeToFit];
    [cell.dateLabel sizeToFit];
    
       
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    //Backgrund
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 0)] ;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"listheader.png"]];
    
    imageView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 30);
    
    [headerView addSubview:imageView];
    
    //Texten
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.tableView.bounds.size.width - 10, 15)] ;
    
    if(self.headerTitle){
        label.text = self.headerTitle;
    }
    else{
    label.text = @"Ingen title satt i RSSTableViewobjektet";
    }
    
    
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Chalkboard SE" size:15]];
    [headerView addSubview:label];
    
    
    if(!spinner){
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
    [spinner setHidesWhenStopped:YES];
    
    [spinner setFrame:CGRectMake(271, 0, 30, 30)];
    
    [headerView addSubview:spinner];
    
    NSLog(@"setting spinner");
    }


    
    return headerView;
    
    
}

-(void)stopSpinner{

    [self.spinner stopAnimating];

}


-(IBAction)flipBackFromWebView:(id)sender{
    
    [self flipToView:self.webView.superview :self.tableView];
    
    //  self.savedTableView = nil;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"zooming");
    //zooms content to fit thw webview
        if ([self.webView respondsToSelector:@selector(scrollView)])
        {
            UIScrollView *scroll=[self.webView scrollView];
            
            float zoom=self.webView.bounds.size.width/scroll.contentSize.width;
            [scroll setZoomScale:zoom animated:YES];
        }

    
}

-(void)setupwebView:(NSString *)urlString{

    if(self.webView == nil){
        self.webView = [[UIWebView alloc] initWithFrame:self.tableView.frame];
        self.webView.delegate = self;
        // self.tableView.layer.cornerRadius = 10;
        //  self.tableView.layer.masksToBounds  = YES;
        self.webView.scrollView.bounces = NO;
        self.webView.scalesPageToFit = YES;
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(flipBackFromWebView:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setFrame:CGRectMake(self.webView.frame.size.width-32, 0, 32, 32)];
        
        
        [self.webView addSubview:button];        
        
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString: urlString]
                                               cachePolicy: NSURLRequestReloadRevalidatingCacheData
                                           timeoutInterval: 60*60] ];
    
    // [self.webView scalesPageToFit];

}

-(void)flipToView:(UIView *)parentContainer :(UIView *)to{
    
    to.layer.masksToBounds = YES;
    
    [UIView transitionWithView:parentContainer duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft //change to whatever animation you like
                    animations:^ { 
                        
                        
                        
                        [parentContainer addSubview:to]; 
                        
                        
                    }
                    completion:nil];
    
}




@end

