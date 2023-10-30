#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>

@interface NSString (MD5)

- (NSString *)MD5String;

@end

@implementation NSString (MD5)

- (NSString *)MD5String
{
    const char *cStr = [self UTF8String];
    unsigned char md5Buf[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), md5Buf);

    NSMutableString *str = [NSMutableString
        stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [str appendFormat:@"%02x", md5Buf[i]];
    }

    return str;
}

@end
