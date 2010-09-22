@import <AppKit/CPPanel.j>

var NIPreviewPanel = nil;

@implementation NIPreviewPanel : CPPanel
{
	CPTextView textarea @accessors;
}

- (id)init
{
	self = [super initWithContentRect:CGRectMake(50,50,400,200) 
							styleMask:CPClosableWindowMask | CPHUDBackgroundWindowMask];
	if(self)
	{
		[self setTitle:@"Podgląd"];
		//[self center];
		[self setFloatingPanel:YES];
		
		var contentView = [self contentView],
			bounds = [contentView bounds];
		
		textarea = [[CPTextView alloc] initWithFrame: bounds];
			// [textarea setEditable:YES];
			// [textarea setBordered:YES];
			// [textarea setBezeled:NO];
		
		[contentView addSubview:textarea];
		//[self setWorksWhenModal:YES];
	}
	return self;
}

@end


@implementation CPFakeTextView : CPView 
{ 
    Element _textarea; 
} 

- (id)initWithFrame:(CPRect)aFrame 
{ 
    if (self = [super initWithFrame:aFrame]) 
    { 
        _textarea = document.createElement("textarea"); 
        _textarea.style.width = "100%"; 
        _textarea.style.height = "100%"; 
		_textarea.style.border = "1px solid red";
        _DOMElement.appendChild(_textarea); 

		// [self set]
        // other initialization code 
    } 
    return self; 
}

// Changing the first responder
/*!
    Returns \c YES if the receiver is able to become the first responder. \c NO otherwise.
*/
- (BOOL)acceptsFirstResponder
{
    return NO;
}

/*!
    Notifies the receiver that it will become the first responder. The receiver can reject first
    responder if it returns \c NO. The default implementation always returns \c YES.
    @return \c YES if the receiver accepts first responder status.
*/
- (BOOL)becomeFirstResponder
{
    return NO;
}

@end


@import <AppKit/CPView.j>

DefaultFontName = "arial";

CPTextViewDidFocusNotification = @"CPTextViewDidFocusNotification";
CPTextViewDidBlurNotification  = @"CPTextViewDidBlurNotification";

@implementation CPTextView : CPControl
{
  DOMElement _inputElement;
  id _delegate;
  CPScrollView _scrollView;
  CPView _contentView;
  JSObject _blurFunction;
  BOOL _isEditing;
  BOOL _isResigning;
  BOOL _didBlur;
}

- (JSObject)_blurFunction
{
  if (!_blurFunction) {
    _blurFunction = function(anEvent) {
      if (!_isResigning) {
	[[self window] makeFirstResponder:nil];
	return;
      }
      // TODO - not entirely sure what this does, but CPTextField's blur function does it
      [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
      _didBlur = YES;

      return true;
    }
  }
  return _blurFunction;
}

- (void)keyDown:(CPEvent)anEvent
{
  if ([anEvent keyCode]  == CPDownArrowKeyCode || [anEvent keyCode] == CPUpArrowKeyCode ||
      [anEvent keyCode] == CPLeftArrowKeyCode || [anEvent keyCode] == CPRightArrowKeyCode) {
    [self scrollToCaret];
    [[[self window] platformWindow] _propagateCurrentDOMEvent:YES];
  }

  else if ([anEvent keyCode] == CPTabKeyCode) {
    var pos = [self _inputElement].selectionStart,
      val = [self _inputElement].value;
    [self _inputElement].value = val.substring(0, pos) + String.fromCharCode(CPTabKeyCode) + val.substring(pos);
    [self _inputElement].selectionStart = pos+1;
    [self _inputElement].selectionEnd = pos+1;	
    [[[self window] platformWindow] _propagateCurrentDOMEvent:NO];
  }
  else
    [[[self window] platformWindow] _propagateCurrentDOMEvent:YES];
  [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
}

- (void)keyUp:(CPEvent)anEvent
{
  if ([anEvent keyCode]  == CPEscapeKeyCode) {
    if (_isEditing) {
      _isEditing = NO;
      [self textDidEndEditing:[CPNotification notificationWithName:CPControlTextDidEndEditingNotification object:self userInfo:nil]];
    }
    [self sendAction:[self action] to:[self target]];
    [[[self window] platformWindow] _propagateCurrentDOMEvent:NO];
    return;
  }

  var oldValue = [self stringValue];
  [self _setStringValue:[self _inputElement].value];
      
  if (oldValue != [self stringValue]) {
    if (_isEditing) {
      _isEditing = YES;
      [self textDidBeginEditing:[CPNotification notificationWithName:CPControlTextDidBeginEditingNotification object:self userInfo:nil]];
    }

    [self textDidChange:[CPNotification notificationWithName:CPControlTextDidChangeNotification object:self userInfo:nil]];
    [self scrollToCaret];
  }
  [[[self window] platformWindow] _propagateCurrentDOMEvent:YES];
}

- (DOMElement)_inputElement
{
  if (!_inputElement) {
    if (document) {
      _inputElement = document.createElement("textarea");
    
      _inputElement.style.width  = "100%";
      _inputElement.style.height = "100%";
    
      if(document.selection)
	_inputElement.style.overflow = "auto";
      else
	_inputElement.style.overflow = "hidden";
        
      _inputElement.style.position = "absolute";
    
      _inputElement.style.left    = "0";
      _inputElement.style.top     = "0";
      _inputElement.style.margin  = "0";
      _inputElement.style.padding = "0";
    
      _inputElement.style.backgroundColor = "transparent";
      _inputElement.style.fontSize = "14px";
      _inputElement.style.fontFamily = DefaultFontName;
     
      _inputElement.style.resize = "none";
      _inputElement.style.outlineStyle = "none";
    
      _inputElement.style.border = "none";
      if (document.attachEvent) {
	_inputElement.attachEvent("onBlur", [self _blurFunction]);
      }
      else {
	_inputElement.addEventListener("blur", [self _blurFunction], NO);
      }
    }
  }
  return _inputElement;
}

- (id)initWithFrame:(CGRect)aFrame
{
  self = [super initWithFrame: aFrame];
  if (self) {
    _DOMElement.appendChild([self _inputElement]);
    [self setStringValue:@""];
    _sendActionOn = CPKeyUpMask | CPKeyDownMask;
  }
  return self;
}

- (BOOL)acceptsFirstResponder
{
  return YES;
}

 (BOOL)becomeFirstResponder
{
  _isEditing = NO;

  window.setTimeout(function() { 
      element.focus();
    }, 0.0);
 
  [[[self window] platformWindow] _propagateCurrentDOMEvent:YES];
        
  [self textDidFocus:[CPNotification notificationWithName:CPTextViewDidFocusNotification object:self userInfo:nil]];

  return YES;
}

- (BOOL)resignFirstResponder
{
  // If one of our notifications causes this text view to lose first responder while it is
  // already losing first responder, we should ignore it
  if (_isResigning)
    return;
  _isResigning = YES;
  var element = [self _inputElement];

  element.blur();
    
  if (!_didBlur)
    [self _blurFunction]();
    
  _didBlur = NO;

  //post CPControlTextDidEndEditingNotification
  if (_isEditing) {
    _isEditing = NO;
    [self textDidEndEditing:[CPNotification notificationWithName:CPControlTextDidEndEditingNotification object:self userInfo:nil]];
    
    if ([self sendsActionOnEndEditing])
      [self sendAction:[self action] to:[self target]];
  }

  [self textDidBlur:[CPNotification notificationWithName:CPTextViewDidBlurNotification object:self userInfo:nil]];

  _isResigning = NO;
  return YES;
}

- (void)textDidBlur:(CPNotification)note
{
  [[CPNotificationCenter defaultCenter] postNotification:note];
}

- (void)textDidFocus:(CPNotification)note
{
  [[CPNotificationCenter defaultCenter] postNotification:note];
}

- (void)_setStringValue:(id)aValue
{
  [self willChangeValueForKey:@"objectValue"];
  [super setObjectValue:String(aValue)];
  [self didChangeValueForKey:@"objectValue"];
}

- (void)setObjectValue:(id)aValue
{
  var previousValue = [self stringValue];
  [super setObjectValue:aValue];

  [self _inputElement].value = aValue;
  if (previousValue !== aValue)
    [self textDidChange:nil];
}
 
- (void)selectText:(id)sender
{
  var element = _inputElement;
  [[self window] makeFirstResponder:self];
  window.setTimeout(function() { element.select(); }, 0);
}

- (void)mouseDown:(CPEvent)anEvent
{
  [[[self window] platformWindow] _propagateCurrentDOMEvent:YES];
  [[self window] makeFirstResponder:self];
}

- (void)mouseUp:(CPEvent)anEvent
{
  [[[self window] platformWindow] _propagateCurrentDOMEvent:YES];
}

- (void)mouseDragged:(CPEvent)anEvent
{
  [[[self window] platformWindow] _propagateCurrentDOMEvent:YES];
}

- (void)setDelegate:(id)aDelegate
{
    var defaultCenter = [CPNotificationCenter defaultCenter];
    
    //unsubscribe the existing delegate if it exists
    if (_delegate)
    {
        [defaultCenter removeObserver:_delegate name:CPControlTextDidBeginEditingNotification object:self];
        [defaultCenter removeObserver:_delegate name:CPControlTextDidChangeNotification object:self];
        [defaultCenter removeObserver:_delegate name:CPControlTextDidEndEditingNotification object:self];
        [defaultCenter removeObserver:_delegate name:CPTextViewDidFocusNotification object:self];
        [defaultCenter removeObserver:_delegate name:CPTextViewDidBlurNotification object:self];
    }
    
    _delegate = aDelegate;
    
    if ([_delegate respondsToSelector:@selector(controlTextDidBeginEditing:)])
        [defaultCenter
            addObserver:_delegate
               selector:@selector(controlTextDidBeginEditing:)
                   name:CPControlTextDidBeginEditingNotification
                 object:self];
    
    if ([_delegate respondsToSelector:@selector(controlTextDidChange:)])
        [defaultCenter
            addObserver:_delegate
               selector:@selector(controlTextDidChange:)
                   name:CPControlTextDidChangeNotification
                 object:self];
    
    
    if ([_delegate respondsToSelector:@selector(controlTextDidEndEditing:)])
        [defaultCenter
            addObserver:_delegate
               selector:@selector(controlTextDidEndEditing:)
                   name:CPControlTextDidEndEditingNotification
                 object:self];

    if ([_delegate respondsToSelector:@selector(controlTextDidFocus:)])
        [defaultCenter
            addObserver:_delegate
               selector:@selector(controlTextDidFocus:)
                   name:CPTextViewDidFocusNotification
                 object:self];

    if ([_delegate respondsToSelector:@selector(controlTextDidBlur:)])
        [defaultCenter
            addObserver:_delegate
               selector:@selector(controlTextDidBlur:)
                   name:CPTextViewDidBlurNotification
                 object:self];
}

- (id)delegate
{
    return _delegate;
}

- (void)textDidChange:(CPNotification)aNote
{
  if (aNote)
    [super textDidChange:aNote];

  if (!_contentView)
    return;
    
  var bounds = [_contentView bounds];
 
  [self _inputElement].style.height = CGRectGetHeight(bounds) + "px";
  // If there is already text in the input element, but we haven't yet edited the input element, 
  // the scrollHeight is 0 until a key gets pressed - so we set the scroll height here manually
  // in this case
  var newHeight = 0;
  if ([self _inputElement].scrollHeight == 0 && [self _inputElement].value && [self _inputElement].value != "")
    newHeight = MAX([[self _inputElement].value 
					 sizeWithFont:[CPFont fontWithName:DefaultFontName size:14.0]
					 inWidth:CGRectGetWidth(bounds)].height, CGRectGetHeight(bounds));
  else 
    newHeight = MAX(CGRectGetHeight(bounds), [self _inputElement].scrollHeight);

  if (newHeight != parseInt([self _inputElement].style.height, 10))
    [self _inputElement].style.height = newHeight + "px";
  [self setFrameSize:CGSizeMake(CGRectGetWidth(bounds), newHeight)];
}

- (void)scrollToCaret
{
  if(![_scrollView verticalScroller] || [[_scrollView verticalScroller] isHidden])
    return;
            
  if([self _inputElement].selectionStart) {
    var start = [self _inputElement].selectionStart,
      end = [self _inputElement].selectionEnd;
 
    var imposter = document.createElement('div'),
      referenceSpan = document.createElement('span'),
      stringValue = [self _inputElement].value;
        
    imposter.style.overflow   = "hidden";
    imposter.style.fontSize   = "14px";
    imposter.style.padding    = "0";
    imposter.style.margin     = "0";
    imposter.style.height     = [self _inputElement].style.height;
    imposter.style.width      = getComputedStyle([self _inputElement], "").getPropertyValue('width');
    imposter.style.fontFamily = getComputedStyle([self _inputElement], "").getPropertyValue('font-family');    
        
    for(var i=0; i<start; i++) {
      referenceSpan.innerHTML = stringValue.charAt(i).replace("\n", "<br />");
      imposter.appendChild(referenceSpan.cloneNode(true));
    }
    
    while (imposter.childNodes[start - 1] && imposter.childNodes[start - 1].innerHTML == " ")
      start--;
                
    document.body.appendChild(imposter);
    
    var caretOffsetTop = imposter.childNodes[start - 1].offsetTop - imposter.offsetTop,
      caretHeight = imposter.childNodes[start-1].offsetHeight;
        
    document.body.removeChild(imposter);
  }
  else if(document.selection) {
    [self _inputElement].focus();
    var range = document.selection.createRange();
        
    window.range = range;
    if(range.parentElement() != [self _inputElement]) 
      return;
                            
    var caretOffsetTop = range.offsetTop + _DOMElement.offsetTop - 18,
      caretHeight = 18;
  }
  else
    return;
 
  [self scrollRectToVisible:CGRectMake(1, caretOffsetTop, 1, caretHeight)];
}
 
- (void)viewDidMoveToSuperview
{
  _scrollView = [self enclosingScrollView];
  if (_scrollView) {
    _contentView = [_scrollView contentView];
  }
}
@end

