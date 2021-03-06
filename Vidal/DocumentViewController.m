//
//  DocumentViewController.m
//  Vidal
//
//  Created by Anton Scherbakov on 06/04/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "DocumentViewController.h"
#import "SearchViewController.h"
#import "ListOfViewController.h"

@interface DocumentViewController ()

@property (strong, nonatomic) NSMutableArray *arrPeopleInfo;

@end

@implementation DocumentViewController {
    
    NSUserDefaults *ud;
    NSMutableIndexSet *toDelete;
    NSIndexPath *selectedRowIndex;
    BOOL open;
    CGFloat sizeCell;
    NSMutableDictionary *tapsOnCell;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    ud = [NSUserDefaults standardUserDefaults];
    toDelete = [NSMutableIndexSet indexSet];
    tapsOnCell = [NSMutableDictionary dictionary];
    
    open = false;
    
    self.navigationItem.title = @"Активное вещество";
    [self.shareButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shareArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
    
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename];
    
    [ud setObject:@"0" forKey:@"share"];

    // Do any additional setup after loading the view.
}

- (void) viewWillDisappear:(BOOL)animated {
    if (self.isMovingFromParentViewController) {
        [ud removeObjectForKey:@"activeID"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    if ([[ud valueForKey:@"share"] isEqualToString:@"0"]) {
        
        NSString *request = [NSString stringWithFormat:@"select * from (select mol.*, cp.Name as Category from (select m.MoleculeID, upper(substr(m.RusName, 1, 1)) || lower(substr(m.RusName, 2)) as RusName, upper(substr(m.LatName, 1, 1)) || lower(substr(m.LatName, 2)) as LatName, doc.DocumentID, doc.CompiledComposition, doc.PhInfluence, doc.PhKinetics, doc.Indication, doc.Dosage, doc.SideEffects, doc.ContraIndication, doc.Lactation, doc.SpecialInstruction, doc.OverDosage, doc.Interaction, doc.PharmDelivery, doc.StorageCondition from Molecule_Document md inner join Molecule m on m.MoleculeID = md.MoleculeID inner join Document doc on doc.DocumentID = md.DocumentID where doc.ArticleID = 1) mol left join Document_ClPhPointers dcp on dcp.DocumentID = mol.DocumentID left join ClinicoPhPointers cp on cp.ClPhPointerID = dcp.ClPhPointerID where ifnull(dcp.ItsMainPriority,1) = 1) doc where doc.MoleculeID = %@", [ud valueForKey:@"activeID"]];
        
        
    [self loadData:request];
    
    NSInteger indexOfLatName = [self.dbManager.arrColumnNames indexOfObject:@"LatName"];
    NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"RusName"];
    NSInteger indexOfMolecule = [self.dbManager.arrColumnNames indexOfObject:@"MoleculeID"];
    
    self.latName.attributedText = [self clearString:[[[self.arrPeopleInfo objectAtIndex:0] objectAtIndex:indexOfLatName] valueForKey:@"lowercaseString"]  InTitle:YES];
    self.name.attributedText = [self clearString:[[[self.arrPeopleInfo objectAtIndex:0] objectAtIndex:indexOfName] valueForKey:@"lowercaseString"]  InTitle:YES];
    
    for (NSUInteger i = 0; i < [[self.arrPeopleInfo objectAtIndex:0] count]; i++) {
        if ([[[self.arrPeopleInfo objectAtIndex:0] objectAtIndex:i] isEqualToString:@""]
            || [[[self.arrPeopleInfo objectAtIndex:0] objectAtIndex:i] isEqualToString:@"0"]) {
            [toDelete addIndex:i];
        }
    }
    
//    NSInteger indexOfLetter = [self.dbManager.arrColumnNames indexOfObject:@"Letter"];
    NSInteger indexOfDocument = [self.dbManager.arrColumnNames indexOfObject:@"DocumentID"];
//    NSInteger indexOfArticle = [self.dbManager.arrColumnNames indexOfObject:@"ArticleID"];
    NSInteger indexOfCategory = [self.dbManager.arrColumnNames indexOfObject:@"Category"];
//    NSInteger indexOfCode = [self.dbManager.arrColumnNames indexOfObject:@"CategoryCode"];
//    NSInteger indexOfCatName = [self.dbManager.arrColumnNames indexOfObject:@"CategoryName"];
//    NSInteger indexOfRusName = [self.dbManager.arrColumnNames indexOfObject:@"RusName:1"];
//    NSInteger indexOfEngName = [self.dbManager.arrColumnNames indexOfObject:@"EngName"];
//    NSInteger indexOfCompany = [self.dbManager.arrColumnNames indexOfObject:@"CompaniesDescription"];
    
//    [toDelete addIndex:indexOfLetter];
    [toDelete addIndex:indexOfDocument];
//    [toDelete addIndex:indexOfArticle];
        
        if (indexOfCategory < 1000) {
            [toDelete addIndex:indexOfCategory];
        }
//    [toDelete addIndex:indexOfCode];
//    [toDelete addIndex:indexOfCatName];
    [toDelete addIndex:indexOfMolecule];
//    [toDelete addIndex:indexOfRusName];
//    [toDelete addIndex:indexOfEngName];
//    [toDelete addIndex:indexOfCompany];
    [toDelete addIndex:indexOfLatName];
    [toDelete addIndex:indexOfName];
    
    [[self.arrPeopleInfo objectAtIndex:0] removeObjectsAtIndexes:toDelete];
    [self.dbManager.arrColumnNames removeObjectsAtIndexes:toDelete];
    
    for (int i = 0; i < [self.dbManager.arrColumnNames count]; i++) {
        [tapsOnCell setObject:@"0" forKey:[NSString stringWithFormat:@"%d", i]];
    }
        
    [self.tableView reloadData];
    } else {
        [ud setObject:@"0" forKey:@"share"];
    }
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[tapsOnCell valueForKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]] isEqualToString:@"1"]) {
        return UITableViewAutomaticDimension;
    } else {
        return 60.0;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.arrPeopleInfo objectAtIndex:0] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrPeopleInfo == nil) {
        return nil;
    }
    
    DocsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"docCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DocsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"docCell"];
    };

    
    if (indexPath.row > 0) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0, 1.0, self.view.frame.size.width + 5.0, 1.0)];
        [line setBackgroundColor:[UIColor colorWithRed:164.0/255.0 green:164.0/255.0 blue:164.0/255.0 alpha:1.0]];
        [cell addSubview:line];
    }
    
    [cell setTag:1];
    
    cell.delegate = self;
    
    
    cell.title.text = [self changeDescName:[self.dbManager.arrColumnNames objectAtIndex:indexPath.row]];
    cell.desc.attributedText = [self clearString:[[self.arrPeopleInfo objectAtIndex:0] objectAtIndex:indexPath.row] InTitle:NO];
//    cell.desc.alpha = 0;
//    [cell.desc setHidden:NO];
//    [UIView animateWithDuration:0.3 animations:^{
//        cell.alpha = 1;
//    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self perfSeg2:cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[tapsOnCell valueForKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]] isEqualToString:@"0"]) {
        
        for (NSString *value in [tapsOnCell allKeys]) {
            [tapsOnCell setObject:@"0" forKey:value];
            [self perfSeg2:[tableView cellForRowAtIndexPath:indexPath]];
        }
        
        [tapsOnCell setObject:@"1" forKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]];
        
        [self perfSeg:[tableView cellForRowAtIndexPath:indexPath]];
        
    } else {
        [tapsOnCell setObject:@"0" forKey:[NSString stringWithFormat:@"%d", (int)indexPath.row]];
        
        [self perfSeg2:[tableView cellForRowAtIndexPath:indexPath]];
    }
    
    [tableView beginUpdates];
    
    [tableView endUpdates];
    
    [tableView scrollToRowAtIndexPath:indexPath
                     atScrollPosition:UITableViewScrollPositionTop
                             animated:YES];
    
}

- (NSAttributedString *) clearString:(NSString *) input InTitle:(BOOL)isTitle {
    
    NSString *text = input;
    
    NSRange range = NSMakeRange(0, 1);
    if (![text isEqualToString:@""]) {
        text = [text stringByReplacingCharactersInRange:range withString:[[text substringToIndex:1] valueForKey:@"uppercaseString"]];
    }
    text = [text stringByReplacingOccurrencesOfString:@"[PRING]" withString:@"Вспомогательные вещества:"];
    text = [text stringByReplacingOccurrencesOfString:@"<TD colSpan=\"2\">" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"&emsp;" withString:@" "];
    text = [text stringByReplacingOccurrencesOfString:@"&trade;" withString:@"™"];
    text = [text stringByReplacingOccurrencesOfString:@"<sup>&trade;</sup>" withString:@"™"];
    text = [text stringByReplacingOccurrencesOfString:@"<SUP>&trade;</SUP>" withString:@"®"];
    text = [text stringByReplacingOccurrencesOfString:@"&ge;" withString:@"≥"];
    text = [text stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
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
    
    if (isTitle) {
        text = [self formatNameString:text];
    }

    
    if ([text containsString:@"[PRING]"]) {
        text = [text stringByReplacingOccurrencesOfString:@"[PRING]" withString:@"Вспомогательные вещества:"];
        NSMutableAttributedString *secondPart = [[NSMutableAttributedString alloc] initWithString:text];
        
        [secondPart beginEditing];
        
        [secondPart addAttribute:NSFontAttributeName
                           value:[UIFont italicSystemFontOfSize:17]
                           range:NSMakeRange(0, 25)];
        
        [secondPart addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:17]
                           range:NSMakeRange(25, [secondPart length] - 25)];
        
        [secondPart endEditing];
        
        NSAttributedString *space = [[NSAttributedString alloc] initWithString:@""];
        
        while ([secondPart.mutableString containsString:@"[PRING]"]) {
            NSRange range = [secondPart.mutableString rangeOfString:@"[PRING]"];
            [secondPart replaceCharactersInRange:range  withAttributedString:space];
        }
        
        return secondPart;
    } else {
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
        return attrText;
    }
    
}

- (void) perfSeg:(DocsTableViewCell *)sender {
    
    [sender rotateImage:M_PI_2];
    
}

- (void) perfSeg2:(DocsTableViewCell *)sender {
    
    [sender rotateImage:0];
    
}

- (IBAction)toList:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toList" sender:self];
    
}

- (IBAction)share:(UIButton *)sender {
    
    [ud setObject:@"1" forKey:@"share"];
    
    NSString *text = self.name.text;
    
    UIActivityViewController *controller =
    [[UIActivityViewController alloc]
     initWithActivityItems:@[text, @"Я узнал об этом веществе через приложение Видаль-кардиология", @"vidal.ru"]
     applicationActivities:nil];
    
    [self presentViewController:controller animated:YES completion:nil];
    
    
}

-(void)loadData:(NSString *)req{
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    
    self.arrPeopleInfo = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:req]];
    
    [self.tableView reloadData];
    // Reload the table view.
}

- (NSString *) changeDescName:(NSString *) input {
    
    NSString *output = input;
    
    if ([output isEqualToString:@"CompiledComposition"]) {
        return @"Описание состава и формы выпуска";
    } else if ([output isEqualToString:@"YearEdition"]) {
        return @"Год издания";
    } else if ([output isEqualToString:@"Elaboration"]) {
        return output;
    } else if ([output isEqualToString:@"PhInfluence"]) {
        return @"Фармакологическое действие";
    } else if ([output isEqualToString:@"PhKinetics"]) {
        return @"Фармакокинетика";
    } else if ([output isEqualToString:@"Dosage"]) {
        return @"Режим дозирования";
    } else if ([output isEqualToString:@"OverDosage"]) {
        return @"Передозировка";
    } else if ([output isEqualToString:@"Interaction"]) {
        return @"Лекарственное взаимодействие";
    } else if ([output isEqualToString:@"Lactation"]) {
        return @"При беременности, родах и лактации";
    } else if ([output isEqualToString:@"SideEffects"]) {
        return @"Побочное действие";
    } else if ([output isEqualToString:@"StorageCondition"]) {
        return @"Условия и сроки хранения";
    } else if ([output isEqualToString:@"Indication"]) {
        return @"Показания к применению";
    } else if ([output isEqualToString:@"ContraIndication"]) {
        return @"Противопоказания";
    } else if ([output isEqualToString:@"SpecialInstruction"]) {
        return @"Особые указания";
    } else if ([output isEqualToString:@"PharmDelivery"]) {
        return @"Условия отпуска из аптек";
    } else {
        return output;
    }
}



- (void) search {
    SearchViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    [vc setSearchType:SearchMolecule];
    [self.navigationController pushViewController:vc animated:NO];
}


- (NSString*)formatNameString:(NSString*)name {
    NSArray *parts = [name componentsSeparatedByString:@" "];
    for (int i = 0; i < [parts count]; i++) {
        if (i == 1 || i == 2) {
            NSString *partString = parts[i];
            if ([partString length] <= 3) {
                partString = [partString uppercaseString];
            } else {
                partString = [partString capitalizedString];
            }
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:parts];
            [tempArray setObject:partString atIndexedSubscript:i];
            parts = tempArray;
        }
    }
    name = [parts componentsJoinedByString:@" "];
    
    return name;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toList"]) {
        ListOfViewController *vc = segue.destinationViewController;
        vc.activeID = [ud objectForKey:@"activeID"];
    }
}

@end
