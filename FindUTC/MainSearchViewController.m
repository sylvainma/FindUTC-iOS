//
//  MainSearchViewController.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 07/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "MainSearchViewController.h"

@interface MainSearchViewController ()
{
    NSMutableArray *allCategories;
    NSArray *logos;
    BOOL isLoad;
}
@end

@implementation MainSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isLoad = NO;
    
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    
    if(!isLoad)
    {
        allCategories = [StoreCategory getAllCategories];
        NSLog(@"%@", allCategories);
        
        if(allCategories==nil || allCategories.count<1)
        {
            MBProgressHUD *loading;
            loading = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            loading.mode = MBProgressHUDModeText;
            loading.labelText = @"Erreur de chargement des données.";
            loading.detailsLabelText = @"Vérifiez votre connexion à internet et réessayez.";
            loading.margin = 10.f;
            [loading show:YES];
        }
        else
        {
            // Ajout de la fausse catégorie "Toutes", d'idCategory=0
            StoreCategory *toutes = [[StoreCategory alloc] init];
            toutes.idCategory = @"0";
            toutes.nameCategory = @"Tous";
            toutes.nameCategoryPlural = @"Tous";
            
            // Calcul du nombre total de stores
            int nbStores = 0;
            for(int i=0; i<allCategories.count; i++)
            {
                StoreCategory *category = [allCategories objectAtIndex:i];
                nbStores = nbStores+[category.nbStores intValue];
            }
            
            // Ajout
            toutes.nbStores = [NSString stringWithFormat:@"%d", nbStores];
            [allCategories insertObject:toutes atIndex:0];
            
            isLoad = YES;
            [self.tableView reloadData];
        }
    
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isLoad)
        return allCategories.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"CategoryCell";
    
    if(indexPath.row==0)
    {
        CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        StoreCategory *category = [allCategories objectAtIndex:indexPath.row];
        NSString *categoryText;
        
        if([category.nbStores isEqualToString:@"0"] || [category.nbStores isEqualToString:@"1"])
            categoryText = [NSString stringWithFormat:@"%@ (%@)", category.nameCategory, category.nbStores];
        else
            categoryText = [NSString stringWithFormat:@"%@ (%@)", category.nameCategoryPlural, category.nbStores];
        
        cell.name.text = categoryText;
        cell.logo.image = [UIImage imageNamed:@"CategoryToutes"];;
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return cell;
    }
    else
    {
        CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        StoreCategory *category = [allCategories objectAtIndex:indexPath.row];
        NSString *categoryText;
    
        if([category.nbStores isEqualToString:@"0"] || [category.nbStores isEqualToString:@"1"])
            categoryText = [NSString stringWithFormat:@"%@ (%@)", category.nameCategory, category.nbStores];
        else
            categoryText = [NSString stringWithFormat:@"%@ (%@)", category.nameCategoryPlural, category.nbStores];
    
        cell.name.text = categoryText;
        cell.logo.image = [self getImageFromNameCategory:category.nameCategory];
    
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UIImage*)getImageFromNameCategory:(NSString*)nameCategory
{
    NSString *CCnameCategory = nameCategory;
    
    // Les accents
    CCnameCategory = [CCnameCategory stringByReplacingOccurrencesOfString:@"é" withString:@"e"];
    CCnameCategory = [CCnameCategory stringByReplacingOccurrencesOfString:@"ê" withString:@"e"];
    CCnameCategory = [CCnameCategory stringByReplacingOccurrencesOfString:@"à" withString:@"a"];
    CCnameCategory = [CCnameCategory stringByReplacingOccurrencesOfString:@"ç" withString:@"c"];
    CCnameCategory = [CCnameCategory stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    
    // Les espaces+majuscules
    CCnameCategory = [NSString stringWithFormat:@"Category%@", [CCnameCategory.capitalizedString stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    UIImage *image = [UIImage imageNamed:CCnameCategory];
    
    if(image)
        return image;
    else
        return [UIImage imageNamed:@"CategoryAutres"];
}

#pragma mark - Segue

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"goToCategoryStoreList" sender:[allCategories objectAtIndex:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"goToCategoryStoreList"])
    {
        CategorySearchViewController *destViewController = segue.destinationViewController;
        destViewController.category = sender;
    }
}

@end
