//
//  ViewController.m
//  WhisperPhone
//
//  Created by fantaros on 2016/11/27.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import "ViewController.h"
#import "WSPWhisperAlgorithm.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *msgText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UITextView *resultView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)wspButtonClick:(UIButton *)sender {
    NSString *msg = self.msgText.text;
    NSString *pwd = self.pwdText.text;
    WSPWhisperData *inputData = [WSPWhisperData whisperDataWithData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    if (inputData != nil) {
        WSPWhisperAlgorithm *algorithm = [WSPWhisperAlgorithm whisperAlgorithm];
        WSPWhisperKey *key = [WSPWhisperKey whisperKeyWithPassword:pwd];
        WSPWhisperData *outputData = [algorithm encrypto:inputData key:key];
        self.resultView.text = [outputData base64String];
    }
}

@end
