#import "_ASMFilter.h"

@interface ASMFilter : _ASMFilter {}
// Custom logic goes here.

+(instancetype)filterWithPhoto:(ASMPhoto*)photo inContext:(NSManagedObjectContext*)context;

@end
