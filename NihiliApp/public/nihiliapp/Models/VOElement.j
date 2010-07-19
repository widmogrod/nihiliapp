@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>

@implementation VOElement : CPObject
{
	CPString nodePath @accessors;
	CPString tagName @accessors;
	CPString content @accessors;
	unsigned id revision @accessors;
}
@end
