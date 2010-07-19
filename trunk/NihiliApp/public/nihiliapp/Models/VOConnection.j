@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>

@implementation VOConnection : CPObject
{
	CPString server @accessors;
	CPString username @accessors;
	CPString password @accessors;
	CPString pathname @accessors;
	CPString protocol @accessors;
}

@end
