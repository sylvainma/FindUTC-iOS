//
//  MainStoreViewController.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 08/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "MainStoreViewController.h"

@interface MainStoreViewController ()
{
    MBProgressHUD *loading;
    BOOL isLoad;
    int nbInfosSup;
}
@end

@implementation MainStoreViewController

@synthesize store;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Détails";
    
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
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreInfoCell" bundle:nil] forCellReuseIdentifier:@"StoreInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreInfoCategoryCell" bundle:nil] forCellReuseIdentifier:@"StoreInfoCategoryCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreDescriptionCell" bundle:nil] forCellReuseIdentifier:@"StoreDescriptionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreButtonCell" bundle:nil] forCellReuseIdentifier:@"StoreButtonCell"];
    
    //
    //  Auto height
    //
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70.0;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    
    //
    //  Initialisation de l'array contenant les données de la tableView
    //  avec les données JSON de la bdd
    //
    
    if(!isLoad)
    {
        // On récupère l'intégralité des données à partir de son idStore
        store = [Store getStoreByID:store.idStore];
        
        if(store != nil)
        {
            // Autre réglages
            [loading hide:YES];
            isLoad = YES;
            [self.tableView reloadData];
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
    {
        nbInfosSup = 0;
    
        if(store.phone != nil && ![store.phone isEqualToString:@""])
            nbInfosSup++;
        if(store.hours != nil && ![store.hours isEqualToString:@""])
            nbInfosSup++;
        
        return 7+nbInfosSup;
    }
    else
    {
        return 0;
    }
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
        
        if([store.nbOpinions isEqualToString:@"0"])
            cell.storeRate.text = @"Pas encore d'avis";
        else
            cell.storeRate.text = [NSString stringWithFormat:@"%@ (%@ avis)", store.rate, store.nbOpinions];
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return cell;
    }
    else if(indexPath.row>0 && indexPath.row<=1+nbInfosSup)
    {
        NSString *simpleTableIdentifier = @"StoreInfoCell";
        StoreInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[StoreInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        if (indexPath.row==1) {
            cell.info.text = store.adress;
            [cell setImageName:@"StoreAdress"];
        }
        else if (indexPath.row==2) {
            cell.info.text = store.phone;
            [cell setImageName:@"StorePhone"];
        }
        else if (indexPath.row==3) {
            cell.info.text = store.hours;
            [cell setImageName:@"StoreInfo"];
        }
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return cell;
    }
    else if(indexPath.row==1+nbInfosSup+1)
    {
        NSString *simpleTableIdentifier = @"StoreInfoCategoryCell";
        StoreInfoCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[StoreInfoCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        cell.title.text = @"Description";
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return cell;
    }
    else if(indexPath.row==1+nbInfosSup+2)
    {
        NSString *simpleTableIdentifier = @"StoreDescriptionCell";
        StoreDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[StoreDescriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        cell.comment.text = store.desc;
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return cell;
    }
    else if(indexPath.row==1+nbInfosSup+3 || indexPath.row==1+nbInfosSup+4 || indexPath.row==1+nbInfosSup+5)
    {
        NSString *simpleTableIdentifier = @"StoreButtonCell";
        StoreButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[StoreButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        if(indexPath.row == 1+nbInfosSup+3) {
            if([store.nbOpinions isEqualToString:@"0"]) {
                [cell setButtonTitle:@"Il n'y a pas encore d'avis"];
            }
            else {
                [cell setButtonTitle:[NSString stringWithFormat:@"Voir les avis (%@)", store.nbOpinions]];
                [cell.button addTarget:self
                                    action:@selector(goToOpinions)
                        forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else if (indexPath.row == 1+nbInfosSup+4) {
            [cell setButtonTitle:@"Rédiger un avis"];
            [cell.button addTarget:self
                                action:@selector(goToWrite)
                      forControlEvents:UIControlEventTouchUpInside];
        }
        else if (indexPath.row == 1+nbInfosSup+5) {
            [cell setButtonTitle:@"Voir sur la carte"];
            [cell.button addTarget:self
                                action:@selector(goToMap)
                      forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [cell setButtonTitle:@"Erreur"];
        }
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return cell;
    }
    else
    {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];;
    }
}

#pragma mark - Segue

- (void)goToOpinions
{
    [self performSegueWithIdentifier:@"goToOpinions" sender:self];
}

- (void)goToWrite
{
   [self performSegueWithIdentifier:@"goToWrite" sender:self];
}

- (void)goToMap
{
    [self performSegueWithIdentifier:@"goToMapFromStore" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"goToOpinions"])
    {
        OpinionsViewController *destViewController = segue.destinationViewController;
        destViewController.store = store;
    }
    else if([segue.identifier isEqualToString:@"goToWrite"])
    {
        MainWriteViewController *destViewController = (MainWriteViewController*)[[segue destinationViewController] topViewController];
        destViewController.store = store;
    }
    else if([segue.identifier isEqualToString:@"goToMapFromStore"])
    {
        StoreMapViewController *destViewController = (StoreMapViewController*)[[segue destinationViewController] topViewController];
        destViewController.store = store;
    }
}

@end
