@import <AppKit/CPView.j>
@import <AppKit/CPImage.j>
@import <AppKit/CPImageView.j>


var NIDefaultFileType = @"blank",
	NIDefaultImageExtension = @"png";

// Tablica przechowywująca wczytane ikony, typów plików
var NIImageExtensionCache = {};

@implementation NIFileExplorerFileDataView : CPView
{
	CPString filename @accessors;
	CPString _filetype;
	CPString imageExtension @accessors;
	
	CPImage image;
	CPImageView imageView @accessors;
	CPTextField textField @accessors;
	
	CPString _imageDidErrorWithFilename;
	
	id target @accessors;
	SEL action @accessors;
}

- (void)rightMouseDown:(CPEvent)anEvent
{
	CPLog.error(@"rightMouseDown:");
	
	if ([anEvent clickCount] > 1) 
	{
		if ([[self target] respondsToSelector: [self action]]) {
			CPLog.error(@"ON:");
			[[self target] performSelector:[self action] withObject:self];
		} else {
			CPLog.fatal(@"NIE:");
		}		
	} else {
		CPLog.debug(@"mało zliczeń:");		
	}
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
	if(self)
	{
		_imageDidErrorWithFilename = nil;
	
		[self setImageExtension:NIDefaultImageExtension];

		imageView = [[CPImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(aFrame), CGRectGetMinY(aFrame) + 2, 16,16)];
		[imageView setImageScaling: CPScaleProportionally];
		//[imageView setImageAlignment: CPImageAlignLeft];
		[self addSubview: imageView];
		
		textField = [[CPTextField alloc] initWithFrame: CGRectMake(CGRectGetMinX(aFrame) + 20, CGRectGetMinY(aFrame) + 2, CGRectGetWidth(aFrame) - 20, CGRectGetHeight(aFrame))];
		[self addSubview: textField];
	}
	return self;
}

/*
	Inichowanie wyświetlenia komórki w tabeli
*/
- (void)setObjectValue:(CPString)aValue
{	
	CPLog.debug("OutlineView ustawia wartość: " + aValue);
	
	[self setFilename:aValue];
	[[self textField] setObjectValue: aValue];
	[[self textField] sizeToFit];
	[self initImage];
}

/*
	Inicjowanie wczytywania grafiki (ikony typu pliku)
	
	Sprawdzany jest cache, jeżeli istnieje grafika w cache
	to jest wyciągana z niego. Dodatkowo jeżeli wczytywana grafika z cache 
	jest wykryta jako wartość domyślna dla nieistniejącego typu pliku 
	to domyślna wartość jest dodawana do cache dla nieistniejącego typu pliku.
*/
- (void)initImage
{
	var cacheKey = [self imageFilepath],
		image;
	
	CPLog.debug("Sprawdzam czy grafika istnieje w cache: " + cacheKey);
	
	if (NIImageExtensionCache[cacheKey]) {
		CPLog.debug("Cache: Wczytuję grafikę z cache");
		
		image =	NIImageExtensionCache[cacheKey];

		if (_imageDidErrorWithFilename) 
		{
			NIImageExtensionCache[_imageDidErrorWithFilename] = image;
			_imageDidErrorWithFilename = nil;
		}
	} else {
		CPLog.debug("Inicjuję nową grafikę");
		
		image = [[CPImage alloc] initWithContentsOfFile:[self imageFilepath] size:CGSizeMake(16.0, 16.0)];
		[image setDelegate:self];
	}

	[[self imageView] setImage: image];
}

/*
	Wczytane grafiki są dodawane do cache.
	
	W przypadku gdy grafika nie została znaleziona i jest wczytywana 
	domyślna grafika - cache dla nie istniejącej grafiki również jest tworzony
	tylko z grafiką domyślną.
*/
- (void)imageDidLoad:(CPImage)aImage
{
	CPLog.warn(@"Grafika została wczytana pomyślnie: " + [aImage filename]);
	
	var cacheKey;
	
	if (_imageDidErrorWithFilename) 
	{
		cacheKey = _imageDidErrorWithFilename;
		_imageDidErrorWithFilename = nil;				
	} else {
		cacheKey = [aImage filename];
	}

	if (!NIImageExtensionCache[cacheKey]) {
		CPLog.debug(@"Cache: Dodaję grafikę do cache.");
		
		NIImageExtensionCache[cacheKey] = aImage;
	} else {
		CPLog.debug(@"Cache: Grafika już jest w cache");
	}
}

/*
	W przypadku gdy nie została znaleziona ikona reprezentująca rozszeżenie do pliku,
	wczytywana jest domyślna ikona. 
	
	Gdy zostanie znaleziona ikona domyślna zostaje przypisana w cache
	ale pod kluczem nie istniejącej ukony @see imageDidLoad:
*/
- (void)imageDidError:(CPImage)aImage
{
	CPLog.warn(@"imageDidError, filename: " + [aImage filename]);
	
	if (_imageDidErrorWithFilename)
		return;

	_imageDidErrorWithFilename = [aImage filename];
	
	CPLog.info(@"Wczytaj kolejną grafikę");
		
	[self setFiletype:NIDefaultFileType withImageExtension:NIDefaultImageExtension];
	[self initImage];
}

/*
	Ustawienie typu pliku nie jest wymagane.
	Jeżeli nie zostanie ustawiony typ pliku,
	wartość zostanie określona z jego rozszeżenia.
*/
- (void)setFiletype:(CPString)aFiletype
{
	CPLog.debug(@"Ustawiam wartość setFiletype: " + aFiletype);
	_filetype = aFiletype;
}

- (void)setFiletype:(CPString)aFiletype withImageExtension:(CPString)anImageExtension
{
	CPLog.debug(@"Ustawiam wartość setFiletype: "+ aFiletype +" withImageExtension: " + anImageExtension);
	[self setFiletype:aFiletype];
	[self setImageExtension:anImageExtension];
}

/*
	Pobieranie wartości typu pliku.
	Typ pliku jest określany na podstawie jego rozszeżenia.
*/
- (CPString)filetype
{
	CPLog.debug(@"Pobieram typ pliku: " + _filetype + ", dla " + filename);
	
	if (_imageDidErrorWithFilename)
		return _filetype;

	/* 
		tylko pliki mogą mieć dynamiczne ikony
	 	- folder - jest folderem
		- spinner - jest typem specjalnym pokazującym się podczas wczytywania plików
	*/
	if (_filetype != @"folder" && _filetype != @"spinner") 
	{
		_filetype = [[filename pathExtension] lowercaseString];
		if (!_filetype) {
			_filetype = NIDefaultFileType;
		}
	}
	
	CPLog.debug(@"Ostatecznie zwracany typ pliku: " + _filetype + ", dla " + filename);

	return _filetype;
}

/*
	Scieżka do pliku graficznego
*/
- (CPString)imageFilepath
{
	filepath = [self filetype] + @"." + [self imageExtension];
	
	CPLog.debug("Wczytuję grafikę: " + filepath);
	
	filepath = [[CPBundle bundleForClass:[self class]] pathForResource:filepath];
	return filepath;
}

@end



var NIFileExplorerFileDataViewImageView = @"NIFileExplorerFileDataViewImageView",
	NIFileExplorerFileDataViewTextField = @"NIFileExplorerFileDataViewTextField",
	NIFileExplorerFileDataViewImageExtension = @"NIFileExplorerFileDataViewImageExtension",
	NIFileExplorerFileDataViewFiletype = @"NIFileExplorerFileDataViewFiletype",
	NIFileExplorerFileDataViewFilename = @"NIFileExplorerFileDataViewFilename";


@implementation NIFileExplorerFileDataView (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super initWithCoder:aCoder];

    if (self)
    {
        [self setImageView:[aCoder decodeObjectForKey:NIFileExplorerFileDataViewImageView]];
		[self setTextField:[aCoder decodeObjectForKey:NIFileExplorerFileDataViewTextField]];
		[self setImageExtension:[aCoder decodeObjectForKey:NIFileExplorerFileDataViewImageExtension]];
		[self setFiletype:[aCoder decodeObjectForKey:NIFileExplorerFileDataViewFiletype]];
		[self setFilename:[aCoder decodeObjectForKey:NIFileExplorerFileDataViewFilename]];
    }

    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:[self imageView] forKey:NIFileExplorerFileDataViewImageView];
	[aCoder encodeObject:[self textField] forKey:NIFileExplorerFileDataViewTextField];
	[aCoder encodeObject:[self imageExtension] forKey:NIFileExplorerFileDataViewImageExtension];
	[aCoder encodeObject:[self filetype] forKey:NIFileExplorerFileDataViewFiletype];
	[aCoder encodeObject:[self filename] forKey:NIFileExplorerFileDataViewFilename];
}

@end