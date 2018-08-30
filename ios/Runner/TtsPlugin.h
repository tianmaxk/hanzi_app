#import <Flutter/Flutter.h>
@import AVFoundation;

@interface TtsPlugin : NSObject
- (BOOL) isLanguageAvailable:(NSString*) locale;
-(BOOL) setLanguage:(NSString*) locale;
-(NSArray*) getLanguages;
-(void)speak:(NSString*) text;
-(void)stop;

@property (readwrite, nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;
@property (strong) NSString *locale;
@end
