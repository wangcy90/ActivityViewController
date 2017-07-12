//
//  ActivityViewController.m
//  TRUMate
//
//  email：chongyangfly@163.com
//  QQ：1909295866
//  github：https://github.com/wangcy90
//  blog：http://wangcy90.github.io
//
//  Created by WangChongyang on 2016/10/11.
//  Copyright © 2016年 WangChongyang. All rights reserved.
//

#import "ActivityViewController.h"

@interface ActivityAction()

@property (nonatomic, copy, readwrite) NSString *title;

@property (nonatomic, copy, readwrite) NSString *imageName;

@property (nonatomic, copy)void(^handler)(ActivityAction *action);

@end

@implementation ActivityAction

+ (instancetype)actionWithTitle:(NSString *)title imageName:(NSString *)imageName handler:(void (^)(ActivityAction *))handler {
    return [[self alloc] initWithTitle:title imageName:imageName handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName handler:(void (^)(ActivityAction *))handler {
    if (self = [super init]) {
        self.title = title;
        self.imageName = imageName;
        self.handler = handler;
    }
    return self;
}

@end

@interface ActivityCell : UICollectionViewCell

@property(nonatomic, strong)ActivityAction *action;

@property(nonatomic, copy)void(^clickHandler)();

@property(nonatomic, strong)UIButton *imageButton;

@property(nonatomic, strong)UILabel *textLabel;

@end

@implementation ActivityCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    [self.contentView addSubview:self.imageButton];
    
    [self.contentView addSubview:self.textLabel];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:58]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:58]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_imageButton attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (void)buttonClick:(UIButton *)sender {
    if (self.clickHandler) {
        self.clickHandler();
    }
    if (_action.handler) {
        _action.handler(_action);
    }
}

- (void)setAction:(ActivityAction *)action {
    _action = action;
    [_imageButton setImage:[UIImage imageNamed:action.imageName] forState:UIControlStateNormal];
    _textLabel.text = action.title;
}

- (UIButton *)imageButton {
    if (!_imageButton) {
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_imageButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageButton;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 2;
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textLabel;
}

@end

@interface ActivityViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property(nonatomic,copy)NSString *titleText;

@property(nonatomic,copy)NSString *desc;

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSMutableArray *dataSource;

@property(nonatomic,strong)NSLayoutConstraint *constraint;

@property(nonatomic,assign)BOOL appearing;

@end

@implementation ActivityViewController

static NSString * const activityReuseIdentifier = @"ActivityViewControllerCell";

+ (instancetype)activityControllerWithTitle:(NSString *)title description:(NSString *)description {
    return [[self alloc] initWithTitle:title description:description];
}

- (instancetype)initWithTitle:(NSString *)title description:(NSString *)description {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        self.titleText = title;
        self.desc = description;
    }
    return self;
}

- (void)addAction:(ActivityAction *)action {
    if (action) {
        [self.dataSource addObject:action];
        [self.collectionView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self activity_setupUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.presentedViewController.preferredStatusBarStyle;
}

- (void)activity_setupUI {
    
    UIView *tapView = [[UIView alloc]init];
    [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)]];
    tapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tapView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tapView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tapView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:contentView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    UIView *topView;
    
    if (self.titleText.length > 0) {
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.text = self.titleText;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 2;
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [contentView addSubview:titleLabel];
        
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
        
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
        
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
        
        topView = titleLabel;
        
    }
    
    if (self.desc.length > 0) {
        
        UILabel *descLabel = [UILabel new];
        descLabel.font = [UIFont systemFontOfSize:12];
        descLabel.text = self.desc;
        descLabel.numberOfLines = 2;
        descLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
        descLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [contentView addSubview:descLabel];
        
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:descLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
        
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:descLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
        
        if (topView) {
            [contentView addConstraint:[NSLayoutConstraint constraintWithItem:descLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
        }else {
            [contentView addConstraint:[NSLayoutConstraint constraintWithItem:descLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
        }
        
        topView = descLabel;
        
    }
    
    [contentView addSubview:self.collectionView];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    if (topView) {
        if (self.desc.length > 0) {
            [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];
        }else {
            [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
        }
    }else {
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1 constant:20]];
    }
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeBottom multiplier:1 constant:15]];
    
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100]];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:0.25 green:0.61 blue:0.97 alpha:1.00] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.layer.cornerRadius = 5;
    cancelButton.layer.masksToBounds = YES;
    cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:cancelButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cancelButton attribute:NSLayoutAttributeTop multiplier:1 constant:-10]];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:1000];
    bottomConstraint.priority = UILayoutPriorityDefaultLow;
    [self.view addConstraint:bottomConstraint];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    
    self.constraint = [NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
}

#pragma mark - UICollectionView methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(78, CGRectGetHeight(collectionView.bounds));
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:activityReuseIdentifier forIndexPath:indexPath];
    
    cell.action = self.dataSource[indexPath.row];
    
    cell.clickHandler = ^{
        [self dismiss];
    };
    
    return cell;
}

#pragma mark - UIViewControllerTransitioning methods

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    UIView *containerView = [transitionContext containerView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    if (_appearing) {
        
        fromView.userInteractionEnabled = NO;
        
        [containerView addSubview:toView];
        
        [toView layoutIfNeeded];
        
        [toView addConstraint:self.constraint];
        
        [UIView animateWithDuration:duration animations:^{
            fromView.alpha = 0.5;
            [toView layoutIfNeeded];
        } completion:^(BOOL completed){
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    }else {
        
        [fromView removeConstraint:self.constraint];
        
        [UIView animateWithDuration:duration animations:^{
            [fromView layoutIfNeeded];
            toView.alpha = 1.0;
        } completion:^(BOOL completed){
            [fromView removeFromSuperview];
            toView.userInteractionEnabled = YES;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.appearing = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.appearing = NO;
    return self;
}

#pragma mark - target actions

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [_collectionView registerClass:[ActivityCell class] forCellWithReuseIdentifier:activityReuseIdentifier];
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (NSString *)cancelButtonTitle {
    if (!_cancelButtonTitle) {
        _cancelButtonTitle = @"Cancel";
    }
    return _cancelButtonTitle;
}

@end
