//
//  ActiveViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ActiveViewController.h"
#import "SearchViewController.h"

@interface ActiveViewController ()

@property (nonatomic, strong) NSArray *firstSectionStrings;
@property (nonatomic, strong) NSArray *secondSectionStrings;
@property (nonatomic, strong) NSMutableArray *sectionsArray;
@property (nonatomic, strong) NSMutableIndexSet *expandableSections;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) ModelViewController *mvc;
@property (nonatomic, strong) NSMutableArray *arrPeopleInfo;
@property (nonatomic, strong) NSMutableArray *hello1;
@property (nonatomic, strong) NSArray *letters;
@property (nonatomic, strong) NSMutableArray *molecule;
@property (nonatomic, strong) NSMutableArray *forSearch;
@property (strong, nonatomic) UIBarButtonItem *searchButton;
@property (nonatomic, strong) IMQuickSearch *quickSearch;
@property (nonatomic, strong) NSArray *FilteredResults;
@property (nonatomic, strong) NSMutableArray *forS;

-(void)loadData:(NSString *)req;

@end

@implementation ActiveViewController {
    
    NSMutableArray *result;
    BOOL container;
    UITapGestureRecognizer *tap;
    NSIndexPath *selectedRowIndex;
    NSUserDefaults *ud;
    NSString *nextPls;
    NSMutableIndexSet *toDelete;
    CGFloat sizeCell;
    UIActivityIndicatorView *activityView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [super setLabel:@"Список активных веществ"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    ud = [NSUserDefaults standardUserDefaults];
    
    [ud removeObjectForKey:@"listOfDrugs"];
    [ud removeObjectForKey:@"info"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        activityView = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        activityView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2 - 80.0);
        [activityView startAnimating];
        [self.tableView addSubview:activityView];
        
        [self loadData:@"select Letter, Title from AlfabetMoleculeListView order by Letter"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            [activityView removeFromSuperview];
            
            [self.tableView reloadData];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    });

    
        self.searchButton = [[UIBarButtonItem alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"searchWhite"] scaledToSize:CGSizeMake(20, 20)]
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(search)];
    
        self.navigationItem.rightBarButtonItem = self.searchButton;
    
    // Do any additional setup after loading the view.
    
    [ud removeObjectForKey:@"workWith"];
    [ud removeObjectForKey:@"activeID"];
    [ud removeObjectForKey:@"pharmaList"];
    [ud removeObjectForKey:@"comp"];
    [ud removeObjectForKey:@"info"];
    [ud removeObjectForKey:@"from"];
    [ud removeObjectForKey:@"molecule"];
    [ud removeObjectForKey:@"letterDrug"];
    
}

- (void) search {
    [self performSegueWithIdentifier:@"toSearch" sender:self];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [ud removeObjectForKey:@"workWith"];
    [ud removeObjectForKey:@"activeID"];
    
    if (nextPls) {
        [ud setObject:nextPls forKey:@"molecule"];
    }
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [ud removeObjectForKey:@"howTo"];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrPeopleInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    ActiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activeCell"];
    if (cell == nil) {
        cell = [[ActiveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"activeCell"];
    }
    
    NSInteger indexOfLetter = [self.dbManager.arrColumnNames indexOfObject:@"Letter"];
    NSInteger indexOfTitle = [self.dbManager.arrColumnNames indexOfObject:@"Title"];
    
    NSString *nameMolecule = [self clearString:[[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfTitle] valueForKey:@"lowercaseString"]];
    NSString *letter = [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfLetter];
    
    cell.name.text = [nameMolecule substringToIndex:nameMolecule.length - 2];
    cell.letter.text = letter;
        
    return cell;
    

}

- (NSString*)sliceStringWithExceptionsFromString:(NSString*)string WithLetter:(NSString*)letter {
    
    if (self.view.frame.size.width == 375) {
        if ([letter isEqualToString:@"О"] || [letter isEqualToString:@"П"]) {
            
        }
    }
    
    return string;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    NSInteger indexOfLetter = [self.dbManager.arrColumnNames indexOfObject:@"Letter"];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [ud setObject:[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfLetter] forKey:@"letterActive"];
    
    [self performSegueWithIdentifier:@"newWindow" sender:self];
    
    
}


#pragma MARK - Database Methods

-(void)loadData:(NSString *)req{
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:req]];
    
    NSInteger indexOfLetter = [self.dbManager.arrColumnNames indexOfObject:@"Letter"];
    
    for (int i = 0; i < [self.arrPeopleInfo count]; i++) {
        [self.arrPeopleInfo[i] setObject:[[self.arrPeopleInfo[i] objectAtIndex:indexOfLetter] valueForKey:@"uppercaseString"] atIndex:indexOfLetter];
    }
    
//    [self.arrPeopleInfo removeObjectAtIndex:0];
//    [self.arrPeopleInfo removeObjectAtIndex:0];
    
    // Reload the table view.
    [self.tableView reloadData];
}

- (NSString *) clearString:(NSString *) input {
    
    NSString *text = input;
    
    if ([text hasSuffix:@".."]) {
        text = [text stringByAppendingString:@"."];
    }
    
    NSRange range = NSMakeRange(0, 1);
    
    text = [text stringByReplacingCharactersInRange:range withString:[[text substringToIndex:1] valueForKey:@"uppercaseString"]];
    
    while (range.location < text.length) {
        range.length = text.length - range.location;
        range = [text rangeOfString:@"," options:0 range:range];
        if (range.length > 0) {
            range.location += 2;
            range.length = 1;
            text = [text stringByReplacingCharactersInRange:range withString:[[text substringWithRange:range] uppercaseString]];
        } else {
            break;
        }
    }
    
    [text stringByReplacingOccurrencesOfString:@",.." withString:@".."];
    
    text = [text stringByReplacingOccurrencesOfString:@"&amp;>" withString:@"&"];
    text = [text stringByReplacingOccurrencesOfString:@"<TD colSpan=\"2\">" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"&emsp;" withString:@" "];
    text = [text stringByReplacingOccurrencesOfString:@"<sup>&trade;</sup>" withString:@"™"];
    text = [text stringByReplacingOccurrencesOfString:@"<SUP>&trade;</SUP>" withString:@"™"];
    text = [text stringByReplacingOccurrencesOfString:@"&trade;" withString:@"™"];
    text = [text stringByReplacingOccurrencesOfString:@"&laquo;" withString:@"«"];
    text = [text stringByReplacingOccurrencesOfString:@"&laquo;" withString:@"«"];
    text = [text stringByReplacingOccurrencesOfString:@"&raquo;" withString:@"»"];
    text = [text stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    text = [text stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    text = [text stringByReplacingOccurrencesOfString:@"&-nb-sp;" withString:@" "];
    text = [text stringByReplacingOccurrencesOfString:@"&ndash;" withString:@"–"];
    text = [text stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"–"];
    text = [text stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
    text = [text stringByReplacingOccurrencesOfString:@"&loz;" withString:@"◊"];
    text = [text stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
    text = [text stringByReplacingOccurrencesOfString:@"<SUP>&reg;</SUP>" withString:@"®"];
    text = [text stringByReplacingOccurrencesOfString:@"<sup>&reg;</sup>" withString:@"®"];
    text = [text stringByReplacingOccurrencesOfString:@"<P>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<B>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<I>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<TR>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<TD>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</P>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</B>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<BR />" withString:@"\n"];
    text = [text stringByReplacingOccurrencesOfString:@"<FONT class=\"F7\">" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</FONT>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</I>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</TR>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</TD>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<TABLE width=\"100%\" border=\"1\">" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</TABLE>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"</SUB>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<SUB>" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"<P class=\"F7\">" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"&deg;" withString:@"°"];
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return text;
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"newWindow"]) {
        
        ListOfViewController *lovc = [segue destinationViewController];
        
        lovc.dataBase = self.dbManager.arrColumnNames;
    } else if ([segue.identifier isEqualToString:@"toSearch"]) {
        SearchViewController *vc = [segue destinationViewController];
        [vc setSearchType:SearchMolecule];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
