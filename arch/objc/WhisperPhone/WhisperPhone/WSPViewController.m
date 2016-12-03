//
//  ViewController.m
//  WhisperPhone
//
//  Created by fantaros on 2016/11/27.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import "WSPViewController.h"
#import "WSPWhisperAlgorithm.h"

@interface WSPViewController ()

@property (weak, nonatomic) IBOutlet UITextField *msgText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UITextView *resultView;


@end

@implementation WSPViewController

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
    WSPWhisperData *inputData = [WSPWhisperData whisperDataWithNoneHeaderData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    if (inputData != nil) {
        WSPWhisperAlgorithm *algorithm = [WSPWhisperAlgorithm whisperAlgorithmWithBlockSize:3];
        WSPWhisperKey *key = [WSPWhisperKey whisperKeyWithPassword:pwd];
        WSPWhisperData *outputData = [algorithm encrypt:inputData key:key];
        self.resultView.text = [outputData base64String];
        WSPWhisperData *deinput = [WSPWhisperData whisperDataWithData: [outputData data]];
        WSPWhisperKey *dekey = [WSPWhisperKey whisperKeyWithPassword:pwd];
        WSPWhisperData *deoutput = [algorithm decrypt:deinput key:dekey];
        NSString *outStr = [[NSString alloc] initWithData:[deoutput dataWithoutHeader] encoding:NSUTF8StringEncoding];
        NSLog(@"deoutputData = %@", outStr);
        NSLog(@"org = %@", msg);
    }
}

- (IBAction)deButtonClick:(UIButton *)sender {
    
}


@end
