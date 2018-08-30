#import "TtsPlugin.h"

static TtsPlugin *ttsPlug = nil;

@implementation TtsPlugin

- (instancetype)init {
    if(ttsPlug==nil){
        self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    }
    
    return self;
}

- (BOOL) isLanguageAvailable:(NSString*) locale {
    NSArray<AVSpeechSynthesisVoice*> *voices = [AVSpeechSynthesisVoice speechVoices];
    for (AVSpeechSynthesisVoice* voice in voices) {
        if([voice.language isEqualToString:locale])
            return YES;
    }
    return NO;
}

-(BOOL) setLanguage:(NSString*) locale {
    if([self isLanguageAvailable:locale]){
        self.locale = locale;
        return YES;
    }
    return NO;
}

-(NSArray*) getLanguages {
    NSMutableArray* languages = [[NSMutableArray alloc] init];
    for (AVSpeechSynthesisVoice* voice in [AVSpeechSynthesisVoice speechVoices]) {
        [languages addObject:voice.language];
    }
    NSArray *arr = [languages copy];
    return arr;
    
}

-(void)speak:(NSString*) text {
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:text];
    if(self.locale == nil){
        self.locale = @"zh-CN";
    }
    if(self.locale != nil){
        AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:self.locale];
        utterance.voice = voice;
    }
    [self.speechSynthesizer speakUtterance:utterance];
    
}

-(void)stop {
    [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

+ (TtsPlugin*)sharedManager
{
    @synchronized(self) {
        if (ttsPlug == nil) {
            ttsPlug = [[super allocWithZone:NULL] init];
        }
    }
    return ttsPlug;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
