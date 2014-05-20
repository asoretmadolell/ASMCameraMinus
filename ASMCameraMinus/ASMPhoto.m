#import "ASMPhoto.h"


@interface ASMPhoto ()

// Private interface goes here.

@end


@implementation ASMPhoto

// Custom logic goes here.

+(instancetype)photoWithName:(NSString*)name inContext:(NSManagedObjectContext*)context
{
    ASMPhoto* photo = [ASMPhoto insertInManagedObjectContext:context];
    photo.name = name;
    photo.creationDate = [NSDate date];
    photo.modifiedDate = [NSDate date];
    
    return photo;
}

@end
