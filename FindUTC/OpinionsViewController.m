//
//  OpinionsViewController.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 08/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "OpinionsViewController.h"

@interface OpinionsViewController ()
{
    MBProgressHUD *loading;
    BOOL isLoad;
    NSMutableArray *allOpinions;
}
@end

@implementation OpinionsViewController

@synthesize store;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Les avis";
    
    //
    //  Préparation du loading
    //
    isLoad = NO;
    loading = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loading.mode = MBProgressHUDModeIndeterminate;
    [loading show:YES];
    
    //
    //  Référencement des custom Cell créées depuis un .nib
    //
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreTitleCell" bundle:nil] forCellReuseIdentifier:@"StoreTitleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OpinionCell" bundle:nil] forCellReuseIdentifier:@"OpinionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreButtonCell" bundle:nil] forCellReuseIdentifier:@"StoreButtonCell"];
    
    //
    //  Auto height
    //
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //
    //  Initialisation de l'array contenant les données de la tableView
    //  avec les données JSON de la bdd
    //
    
    if(!isLoad)
    {
        // theStore peut venir de la map et être déjà téléchargé, sinon on le télécharge
        if (allOpinions == nil) {
            allOpinions = [Opinion getAllOpinionsFromIDStore:store.idStore beforeID:nil];
        }
        
        if(allOpinions != nil)
        {
            // Autre réglages
            [loading hide:YES];
            isLoad = YES;
        }
        else
        {
            loading.mode = MBProgressHUDModeText;
            loading.labelText = @"Erreur de chargement des données.";
            loading.detailsLabelText = @"Vérifiez votre connexion à internet et réessayez.";
            loading.margin = 10.f;
        }
    }
    [self.tableView reloadData];
    //[self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isLoad)
        return 1+allOpinions.count+1;
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        NSString *simpleTableIdentifier = @"StoreTitleCell";
        StoreTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[StoreTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        cell.storeName.text = store.name;
        cell.storeCategory.text = store.nameCategory;
        cell.storeRate.text = [NSString stringWithFormat:@"%@ (%@ avis)", store.rate, store.nbOpinions];
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        return cell;
    }
    else if(indexPath.row>0 && indexPath.row<=allOpinions.count)
    {
        NSString *simpleTableIdentifier = @"OpinionCell";
        OpinionCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[OpinionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        Opinion *opinion = [allOpinions objectAtIndex:indexPath.row-1];
        
        cell.opinionRate.text = opinion.noteName;
        cell.opinionDate.text = opinion.date;
        cell.opinionMessage.text = opinion.comment;
        
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        return cell;
    }
    else
    {
        NSString *simpleTableIdentifier = @"StoreButtonCell";
        StoreButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[StoreButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        [cell setButtonTitle:@"Voir plus d'avis"];
        [cell.button addTarget:self
                        action:@selector(moreOpinions)
              forControlEvents:UIControlEventTouchUpInside];
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

#pragma mark - More opinions

- (void)moreOpinions
{
    MBProgressHUD *opinionsLoading = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    opinionsLoading.mode = MBProgressHUDModeIndeterminate;
    [opinionsLoading show:YES];
    
    Opinion *lastOpinion = [allOpinions objectAtIndex:allOpinions.count-1];
    NSArray *newOpinions = [Opinion getAllOpinionsFromIDStore:store.idStore beforeID:lastOpinion.idOpinion];
    
    if(newOpinions != nil && newOpinions.count!=0)
    {
        for(int i=0; i<newOpinions.count; i++)
        {
            [allOpinions addObject:[newOpinions objectAtIndex:i]];
        }
        [self.tableView reloadData];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Chargement des avis"
                                                        message:@"Il n'y a pas plus d'avis sur cet établissement."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [opinionsLoading hide:YES];
}

@end
