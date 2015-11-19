//
//  CategorySearchViewController.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 08/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "CategorySearchViewController.h"

@interface CategorySearchViewController ()
{
    NSMutableArray *allStoresByCategory;
    NSMutableArray *allStoresNames;
    NSMutableArray *allStores;
    NSDictionary *sortedStores;
    NSArray *sectionsTitles;
    NSArray *indexTitles;
    MBProgressHUD *loading;
    BOOL isLoad;
}
@end

@implementation CategorySearchViewController

@synthesize category;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isLoad = NO;
    loading = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loading.mode = MBProgressHUDModeIndeterminate;
    [loading show:YES];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    indexTitles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    //
    //  Titre
    //
    self.title = category.nameCategoryPlural;
    
    //
    //  Custom Cell depuis un nib
    //
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreCell" bundle:nil] forCellReuseIdentifier:@"StoreCell"];
    
    //
    //  Barre de recherche
    //
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"CategorySearchResultsNavController"];
    
    // Our instance of UISearchController will use searchResults
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    
    // The searchcontroller's searchResultsUpdater property will contain our tableView.
    self.searchController.searchResultsUpdater = self;
    
    // The searchBar contained in XCode's storyboard is a leftover from UISearchDisplayController.
    // Don't use this. Instead, we'll create the searchBar programatically.
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
    // Custom de la searchBar
    self.searchController.searchBar.placeholder = @"Rechercher";
    self.searchController.searchBar.barTintColor = [UIColor colorWithRed:76.0/255.0 green:157.0/255.0 blue:104.0/255.0 alpha:1.0];
    self.searchController.searchBar.tintColor = [UIColor colorWithRed:76.0/255.0 green:157.0/255.0 blue:104.0/255.0 alpha:1.0];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor whiteColor], NSForegroundColorAttributeName, nil]
                                                                                        forState:UIControlStateNormal];
     self.searchController.dimsBackgroundDuringPresentation = NO;

    // Placement de la searchBar
    self.definesPresentationContext = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];

    if(!isLoad)
    {
        //
        //  Récupération des données
        //
        allStoresByCategory = [Store getAllStoresByCategory:category.idCategory];
        NSLog(@"allStoresByCategory: %@", allStoresByCategory);
        
        if(allStoresByCategory != nil && allStoresByCategory.count>=1)
        {
            //
            // Tri des données
            //
            
            // Array des noms de Store
            allStoresNames = [[NSMutableArray alloc] init];
            for(int i=0; i<allStoresByCategory.count; i++)
            {
                Store *store = [allStoresByCategory objectAtIndex:i];
                [allStoresNames addObject:store.name];
            }
            
            // Dictionnaire alphabétique des Stores
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (Store *aStore in allStoresByCategory)
            {
                NSString *firstLetter = [[aStore.name substringToIndex:1] uppercaseString];
                NSMutableArray *letterList = [dict objectForKey:firstLetter];
                if (!letterList) {
                    letterList = [NSMutableArray array];
                    [dict setObject:letterList forKey:firstLetter];
                }
                [letterList addObject:aStore];
            }
            
            allStores = allStoresNames;
            sortedStores = dict;
            sectionsTitles = [[sortedStores allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            
            // Autre réglages
            [loading hide:YES];
            isLoad = YES;
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
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
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(isLoad)
        return sortedStores.count;
    else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isLoad)
    {
        NSString *sectionTitle = [sectionsTitles objectAtIndex:section];
        NSArray *sectionStore = [sortedStores objectForKey:sectionTitle];
        return [sectionStore count];
    }
    else
    {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionsTitles objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return indexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [sectionsTitles indexOfObject:title];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    // Label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:13.0]];
    [label setText:[sectionsTitles objectAtIndex:section]];
    [label setTextColor:[UIColor whiteColor]];
    
    // Background
    [view setBackgroundColor:[UIColor colorWithRed:76.0/255.0 green:157.0/255.0 blue:104.0/255.0 alpha:1.0]];
    
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"StoreCell";
    StoreCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[StoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *sectionTitle = [sectionsTitles objectAtIndex:indexPath.section];
    NSArray *sectionStores = [sortedStores objectForKey:sectionTitle];
    Store *theStore = [sectionStores objectAtIndex:indexPath.row];
    
    cell.name.text = theStore.name;
    
    if(![theStore.nbOpinions isEqualToString:@"0"])
        cell.nbOpinions.text = [NSString stringWithFormat:@"%@ (%@ avis)", theStore.rate, theStore.nbOpinions];
    else
        cell.nbOpinions.text = @"Pas encore d'avis";
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Lettre de la section sélectionnée
    NSArray *sectionLetter = [sectionsTitles objectAtIndex:indexPath.section];
    
    // Array des stores de cette lettre
    NSArray *storesInSection = [sortedStores objectForKey:sectionLetter];
    
    // Store sélectionné dans cette section
    Store *storeSelected = [storesInSection objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"goToStoreFromSearch" sender:storeSelected];
}

#pragma mark - UISearchControllerDelegate & UISearchResultsDelegate

// Called when the search bar becomes first responder
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    // Set searchString equal to what's typed into the searchbar
    NSString *searchString = self.searchController.searchBar.text;
    
    
    [self updateFilteredContentForAirlineName:searchString];
    
    // If searchResultsController
    if (self.searchController.searchResultsController) {
        
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        
        // Present SearchResultsTableViewController as the topViewController
        CategorySearchResultsViewController *vc = (CategorySearchResultsViewController*)navController.topViewController;
        
        // Update searchResults
        vc.searchResults = self.searchResults;
        
        // And reload the tableView with the new data
        [vc.tableView reloadData];
    }
}

// Update self.searchResults based on searchString, which is the argument in passed to this method
- (void)updateFilteredContentForAirlineName:(NSString *)storeName
{
    
    if (storeName == nil)
    {
        // If empty the search results are the same as the original data
        self.searchResults = [allStoresByCategory mutableCopy];
    }
    else
    {
        NSMutableArray *results = [[NSMutableArray alloc] init];
        
        // Else if the store's name is
        for (Store *aStore in allStoresByCategory)
        {
            // Condition de matching entre la recherche et les données
            if ([aStore.name rangeOfString:storeName options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [results addObject:aStore];
            }
            self.searchResults = results;
        }
        
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"goToStoreFromSearch"])
    {
        Store *storeSelected = sender;
        MainStoreViewController *destViewController = segue.destinationViewController;
        destViewController.store = storeSelected;
    }
}


@end
