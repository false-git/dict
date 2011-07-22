#import <Cocoa/Cocoa.h>
#import <CoreServices/CoreServices.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

NSArray *DCSGetActiveDictionaries(); 
NSArray *DCSCopyAvailableDictionaries(); 
NSString *DCSDictionaryGetName(DCSDictionaryRef dictID); 
NSString *DCSDictionaryGetShortName(DCSDictionaryRef dictID); 

void usage(void)
{
    printf("Usage: dict [-jse] [lookup_word]\n");
    printf("\t-j 大辞林\n");
    printf("\t-s 類語例解辞典\n");
    printf("\t-e New Oxford American Dictionary\n");
    printf("\t※ オプションなしだとプログレッシブ英和・和英辞典\n");
    exit(1);
}

int main(int argc, char** argv)
{
    int ch;
    NSString *dicname = @"Japanese-English";
    while ((ch = getopt(argc, argv, "jse")) != -1) {
	switch (ch) {
	  case 'j':
	    dicname = @"Japanese";
	    break;
	  case 's':
	    dicname = @"Japanese Synonyms";
	    break;
	  case 'e':
	    dicname = @"Dictionary";
	    break;
	  default:
	    usage();
	}
    }
    argc -= optind;
    argv += optind;
    printf("%d\n", argc);

    if (argc != 1) usage();

    id pool = [NSAutoreleasePool new]; 

    NSString* nsarg;
    nsarg = [NSString stringWithUTF8String:argv[0]];

    CFRange range;
    range.location = 0;
    range.length = [nsarg length];

    DCSDictionaryRef dic = NULL;
    NSArray *dicts = DCSCopyAvailableDictionaries();
    for (NSObject *aDict in dicts) {
	NSString *aShortName = DCSDictionaryGetShortName((DCSDictionaryRef)aDict);
	if ([aShortName isEqualToString:dicname]) {
	    dic = (DCSDictionaryRef)aDict;
	}
    }

    CFStringRef ref = NULL;
    ref = DCSCopyTextDefinition(dic, (CFStringRef)nsarg, range);
    printf("%s\n", [(NSString*)ref UTF8String]);

    [pool drain];
    return 0;
}
