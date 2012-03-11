scriptname ArrayList hidden

bool _initialized = false
Form[] _array
int _size

bool property Initialized
	bool function Get()
		return _initialized
	endfunction
endproperty

;*****************************************************************************;
; Initialisation
;*****************************************************************************;
function LazyInit()
	if( _array == None )
		Init16()
		Debug.Trace( "DPP::ArrayList::LazyInit: Lazily initialised array with default size " + _array.Length )
	endif
endfunction

function Init8()
	_array = new Form[ 8 ]
	_size = 0
	
	_initialized = true
endfunction

function Init16()
	_array = new Form[ 16 ]
	_size = 0
	
	_initialized = true
endfunction

function Init32()
	_array = new Form[ 32 ]
	_size = 0
	
	_initialized = true
endfunction

function Init64()
	_array = new Form[ 64 ]
	_size = 0
	
	_initialized = true
endfunction

function Init128()
	_array = new Form[ 128 ]
	_size = 0
	
	_initialized = true
endfunction

;*****************************************************************************;
; Modification
;*****************************************************************************;
function Add( Form akFormID )
{ Adds the provided item to the list }
	LazyInit()
	
	if( _size < _array.Length )
		_array[ _size ] = akFormID
		_size += 1
	endif
	
	Debug.Trace( "DPP::ArrayList::Add: Ran out of array space when adding form!" )
endfunction

function Remove( Form akFormID )
{ Removes the first instance of the provided item from the list }
	LazyInit()
	
	int i = 0
	bool found = false
	
	while( i < _size && !found )
		if( _array[ i ] == akFormID )
			found = true
		endif
		
		i += 1
	endwhile
	
	; Move the remaining poisons down the list
	if( found )
		while( i < _size )
			_array[ i - 1 ] = _array[ i ]
			
			i += 1
		endwhile
		
		_size -= 1
		_array[ _size ] = None
		
		return
	endif
	
	Debug.Trace( "DPP::ArrayList::Remove: Could not find form to remove!" )
endfunction

function Clear()
{ Removes all items from the list }
	LazyInit()
	
	int i = 0
	
	while( i < _size )
		_array[ i ] = None
		
		i += 1
	endwhile
	
	_size = 0
	
	return
endfunction

;*****************************************************************************;
; Queries
;*****************************************************************************;
int function Size()
{ Returns the amount of items in the list }
	LazyInit()
	
	return _size
endfunction

int function Count( Form akFormID )
{ Returns the amount of times the provided item is present in the list }
	LazyInit()
	
	int i = 0
	int count = 0
	
	while( i < _size )
		if( _array[ i ] == akFormID )
			count += 1
		endif
		
		i += 1
	endwhile
	
	return count
endfunction

bool function Contains( Form akFormID )
{ Returns true if the provided item is present in the list, false otherwise }
	LazyInit()
	
	int i = 0
	
	while( i < _array.Length )
		if( _array[ i ] == akFormID )
			return true
		endif
	endwhile
	
	return false
endfunction

Form function PeekFront()
{ Returns the first item contained in the list }
	LazyInit()

	return _array[ 0 ]
endfunction

Form function PeekLast()
{ Returns the last item contained in the list }
	LazyInit()
	
	if( _size == 0 )
		return None
	endif
	
	return _array[ _size - 1 ]
endfunction

Form function PopFront()
{ Returns the first item contained in the list }
	LazyInit()

	if( _size == 0 )
		Debug.Trace( "DPP::ArrayList::PopFront: Refusing to pop from an empty list" )
		return None
	endif
	
	Form ret = _array[ 0 ]
	
	int i = 1
	while( i < _size )
		_array[ i - 1 ] = _array[ i ]
		i += 1
	endwhile
	
	_size -= 1
	_array[ _size ] = None
	
	return ret
endfunction

Form function PopLast()
{ Returns the last item contained in the list }
	LazyInit()
	
	if( _size == 0 )
		Debug.Trace( "DPP::ArrayList::PopLast: Refusing to pop from an empty list" )
		return None
	endif
	
	Form ret = _array[ _size - 1 ]
	
	_size -= 1
	_array[ _size ] = None
	
	return ret
endfunction

Form function At( int index )
{ Returns the item located at the specified index }
	LazyInit()
	
	if( index >= 0 && index < _size )
		return _array[ index ]
	endif
	
	Debug.Trace( "DPP::ArrayList::At: index out of bounds" )
	return None
endfunction
