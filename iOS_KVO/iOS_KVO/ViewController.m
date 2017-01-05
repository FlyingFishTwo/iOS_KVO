//
//  ViewController.m
//  KVO01.05Demo
//
//  Created by li on 2017/1/5.
//  Copyright © 2017年 RYT. All rights reserved.
//

#import "ViewController.h"
#import "People.h"

@interface ViewController ()

@property (nonatomic,strong) People    *p;

@property (nonatomic,strong) UILabel     *label;
@property (nonatomic,strong) UILabel     *heightLabel;

@property (nonatomic,strong) UIButton    *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self addAllSubView];   //添加子控件
    
    [self getObjectAttributeWithPeople]; //用KVO获取对象属性
    
}

- (void)getObjectAttributeWithPeople{
    
    People *people = [People new];
    people.name = @"旧的名字";
    people.height = 100.0f;
    
    self.p = people;   //最好用接收一下 的方法
    
    /*1.注册对象myKVO为被观察者:
     option中，
     NSKeyValueObservingOptionOld 以字典的形式提供 “初始对象数据”;
     NSKeyValueObservingOptionNew 以字典的形式提供 “更新后新的数据”;
     */
    
    //注册对象的时候一定要注意   是对象的属性   name的注册
    [self.p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    //height的注册
    [self.p addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    
}

/* 2.只要object的keyPath属性发生变化，就会调用此回调方法，进行相应的处理：UI更新：*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    /*
     这里用了keyPath 来区分是哪个属性发生变化
     */
    if ([keyPath isEqualToString:@"name"] && object == self.p) {
        //相应变化处理    更新UI  这里用label文本改变
        self.label.text = [NSString stringWithFormat:@"当前的值为  ：%@",[change valueForKey:@"new"]];
        
        //上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
        NSLog(@"\nold name:%@ new name:%@",[change valueForKey:@"old"],[change valueForKey:@"new"]);
        
    } else if([keyPath isEqualToString:@"height"] && object == self.p){
        
        self.heightLabel.text = [NSString stringWithFormat:@"当前的身高 ： %@",[change valueForKey:@"new"]];
        
    }
}


//点击按钮   得到新的值  name文本的值需要重新改变后才能得到新的值
- (void)buttonClick{
    //改变属性的值
    self.p.name = @"路上下雨了";
    self.p.height = self.p.height + 1;
}



-(void)viewWillDisappear:(BOOL)animated{
    /*
     3.移除KVO    谁注册的   谁来移除
     */
    [self.p removeObserver:self forKeyPath:@"name" context:nil];
    [self.p removeObserver:self forKeyPath:@"height" context:nil];
}








- (void)addAllSubView{
    [self.view addSubview:self.label];
    [self.view addSubview:self.heightLabel];
    [self.view addSubview:self.btn];
}

#pragma mark-------   @property

- (UIButton*)btn{
    if (_btn == nil) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(10, self.heightLabel.frame.origin.y+100, self.view.frame.size.width-20, 40);
        [_btn setBackgroundColor:[UIColor grayColor]];
        [_btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (UILabel*)heightLabel{
    if (_heightLabel == nil) {
        _heightLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 240, self.view.frame.size.width-20, 40)];
        _heightLabel.backgroundColor = [UIColor brownColor];
        _heightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _heightLabel;
}


- (UILabel*)label{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(10, 180, self.view.frame.size.width-20, 40)];
        _label.backgroundColor = [UIColor brownColor];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
