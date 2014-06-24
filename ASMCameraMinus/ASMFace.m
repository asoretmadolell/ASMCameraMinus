#import "ASMFace.h"


@interface ASMFace ()

// Private interface goes here.

@end


@implementation ASMFace

// Custom logic goes here.

+(instancetype)faceWithPhoto:(ASMPhoto*)photo inContext:(NSManagedObjectContext*)context
{
    ASMFace* face = [ASMFace insertInManagedObjectContext:context];
    
    face.photo = photo;
    
    return face;
}

@end
