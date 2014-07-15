#import "ASMFilter.h"


@interface ASMFilter ()

// Private interface goes here.

@end


@implementation ASMFilter

// Custom logic goes here.

+(instancetype)filterWithPhoto:(ASMPhoto*)photo inContext:(NSManagedObjectContext*)context
{
    ASMFilter* filter = [ASMFilter insertInManagedObjectContext:context];
    
    filter.photo = photo;
    
    return filter;
}

@end
