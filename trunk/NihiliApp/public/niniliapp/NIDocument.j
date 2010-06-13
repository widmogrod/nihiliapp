@import <AppKit/CPDocument.j>
@import "Controllers/NIPageWindowController.j"

@implementation NIDocument : CPDocument
{
	CPSet _elements;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
    	console.log("open");
//    	{
//    		"id":1,
//    		name:"2R System",
//    		url:"2rsyste.pl",
//    		pages:[
//    			{
//    				"id": 1
//    				name : "Strona główna",
//    				url : "index.html",
//    				elements: [
//    					{
//    						"path":"/div/div/",
//    						"type":"text"
//    						"content":"to jest treść"
//    					}
//    				]
//    				
//    			}
//    		]
//    		
//    	};
    }
    
    return self;
}

/*
	Zestaw elementów wchodzących w skład SIDocument
*/
- (CPSet)elements
{
	return _elements;
}

/*
	Zwracanie zestawu elementów, które są zaznaczone
*/
- (CPSet)selectedElements
{
	var selected = [_elements copy];
	var elements = [selected allObjects];
	for(var i=0; i < [elements count]; i++)
	{
		var element = [elements objectAtIndex:i];
		if (![element selected])
		{
			[selected removeObject:element];
		}
	}

	return selected;
}

- (void)makeWindowControllers
{


	/*
		TODO: Czy te okna w kontrolerze nie powinny być sinlegonem?
			  - okno opcji wydaje mi się że powinno być jak najbardziej,
			  - nie jestem pewien co do okna wizualizacji elementów..
	*/

	// dodaj kontroler okna wizualizacji podstron
	var pageWindowController = [[NIPageWindowController alloc] init];
	[self addWindowController: pageWindowController];
}

@end
