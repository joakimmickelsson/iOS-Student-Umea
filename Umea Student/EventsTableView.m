/*
 File: EventsTableView.m
 
 Abstract: Detta NSObject Hanterar Evenemangslistan i huvudfönstret. Har en inbyggd TableView och agerar som delegate och datasource. Hämtar data från Umeå Universitets RSS Kalendarium .
 
 Version: 1.0
 
 Copyright (C) 2012 Umeå Universitet. All Rights Reserved.
 
 */

#import "EventsTableView.h"

@interface EventsTableView ()

@end

@implementation EventsTableView

@synthesize tableView;
@synthesize eventsObject;
@synthesize rssOutputData;
@synthesize xmlParserObject;
@synthesize nodecontent;
@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize dateLabel;
@synthesize cell;
@synthesize tableViewIsLoaded;

// The designated initializer. Override to perform setup that is required before the view is loaded.


#pragma mark NSXMLParser delegate

//below delegate method is sent by a parser object to provide its delegate when it encounters a start tag 

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	//if element name is equat to item then only i am assingning memory to the NSObject class
    
	if([elementName isEqualToString:@"item"]){
		self.eventsObject =[[RSS alloc]init];
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
		self.eventsObject.title=nodecontent;
	}
	else if([elementName isEqualToString:@"link"]){
		self.eventsObject.url=nodecontent;
	}
    
    else if([elementName isEqualToString:@"description"]){
        self.eventsObject.description=nodecontent;
        
    }
    
    else if([elementName isEqualToString:@"dc:date"]){
        self.eventsObject.pubDate=nodecontent;
        
        
    }
	
	//finally when we reaches the end of tag i am adding data inside the NSMutableArray
	if([elementName isEqualToString:@"item"]){
        if(eventsObject){
            [self.rssOutputData addObject:eventsObject];

        }
        self.eventsObject = nil;
	}
    
	//reallocate the memory to get new content data from file
	self.nodecontent=[[NSMutableString alloc]init];
}

-(void)setUpEventsTableView{

    self.rssOutputData = [[NSMutableArray alloc]init];
    
    //declare the object of allocated variable
    NSData *xmlData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:@"http://www.umu.se/om-universitetet/aktuellt/kalendarium/rss/kalender-rss/?categories=concert,conference,courseEducation,culturOnCampus,dissertation,exhibition,lecture,licentiateSeminar,meeting,theOthers,seminar,seminarSeries,umea2014,workshop&calendarIds=32&fromSiteNodeId=39132"]];
    
    //allocate memory for parser as well as 
    self.xmlParserObject =[[NSXMLParser alloc]initWithData:xmlData];
    [self.xmlParserObject setDelegate:self];
    
    //asking the xmlparser object to beggin with its parsing
    [self.xmlParserObject parse];
    
      self.tableView.layer.cornerRadius = 10;
     self.tableView.layer.borderWidth = 0.1;
     self.tableView.layer.borderColor = [UIColor blackColor].CGColor;

    // self.tableView.layer.cornerRadius = 10;
    

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
    
    NSString *text = [[self.rssOutputData objectAtIndex:indexPath.row] description];

    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGSize withinSize = CGSizeMake(self.tableView.frame.size.width, 1000);
    CGSize size = [text sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];    
    
         return size.height+20;    

    
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
        
        cell.descriptionLabel.numberOfLines = 0;
        cell.descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        cell.titleLabel.numberOfLines = 0;
        cell.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        
    }
    RSS *news = [self.rssOutputData objectAtIndex:indexPath.row];
    
	// Set up the cell
	cell.titleLabel.text= news.title;
    
    if(news.description == nil){
    	cell.descriptionLabel.text = news.title;
    }
    else{
    	cell.descriptionLabel.text = news.description;
        
    }
	cell.descriptionLabel.text = news.description;
    cell.dateLabel.text  = news.pubDate;
    
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

        
    label.text = @"Evenemang";
   
    
    
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Chalkboard SE" size:15]];
    [headerView addSubview:label];

    
    
    return headerView;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    
    if ([segue.identifier isEqualToString:@"webViewSegue"]) 
    {
        
        WebViewController *webViewController = (WebViewController *) segue.destinationViewController;
        
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        RSS *newsItem = [rssOutputData objectAtIndex:indexPath.row];
        
        NSArray *listItems = [newsItem.url componentsSeparatedByString:@"?eventId="];
        
        
        NSLog(@"%@",[listItems lastObject]);
        
        webViewController.urlString = [@"http://api.eks.nu/evenemang.php?eventId=" stringByAppendingString:[listItems lastObject]];
        
        NSLog(@"%@",webViewController.urlString);
        
    }
}


@end
