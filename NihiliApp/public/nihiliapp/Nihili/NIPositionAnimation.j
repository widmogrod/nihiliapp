@import <AppKit/CPAnimation.j>

/*
	Prosta animacja pozycji okna

*/
@implementation NIPositionAnimation : CPAnimation
{
	CPWindow _window;
	
	float _x;

	CPValue _start;
	CPValue _end;
}

- (id)initWithWindow:(CPWindow)aWindow
{
	self = [super initWithDuration:1.0 animationCurve:CPAnimationLinear];
	if(self)
	{
		if([aWindow respondsToSelector:@selector(frame)]){
			_window = aWindow;
			_x = CGRectGetMinX([aWindow frame]);
		} else {
			return null;
		}
	}

	return self;
}

- (void)setCurrentProgress:(float)progress
{
	[super setCurrentProgress:progress];

	progress = [self currentValue];	
	progress = (progress * (_end - _start)) + _start;

	[_window setFrameOrigin:CGPointMake(_x, progress)];
}

- (void)setStart:(float)aValue
{
	_start = aValue;
}

- (float)start
{
	return _start;
}

- (void)setEnd:(float)aValue
{
	_end = aValue;
}

- (float)end
{
	return _end;
}

@end