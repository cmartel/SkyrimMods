scriptname ArrayUtil hidden

;*****************************************************************************;
; Template
; To use, copy everything in between the curly brackets, and paste it in the
; script you want to use the array with. Then, pick the init function from the
; second block that most closely matches the size you will need. Copy and paste
; it alongside the previous template block. 
; Lastly, do a search and replace to substitute all occurrences of WOOF in the
; pasted text with the name of whatever you wish your array to manage.
; You will then have to make sure to call the Init(YourArrayName) function
; somewhere before any other array calls are made.
;*****************************************************************************;
{
Form[] _WOOF_array = None
int[] _WOOF_size = None

function AddWOOF( Form akFormID )
	ArrayUtil._Add( _WOOF_array, _WOOF_size, akFormID )
endfunction

bool function RemoveWOOF( Form akFormID )
	return ArrayUtil._Remove( _WOOF_array, _WOOF_size, akFormID )
endfunction

function ClearWOOF()
	ArrayUtil._Clear( _WOOF_array, _WOOF_size )
endfunction

int function SizeWOOF()
	return ArrayUtil._Size( _WOOF_array, _WOOF_size )
endfunction

int function CountWOOF( Form akFormID )
	return ArrayUtil._Count( _WOOF_array, _WOOF_size, akFormID )
endfunction

bool function ContainsWOOF( Form akFormID )
	return ArrayUtil._Contains( _WOOF_array, _WOOF_size, akFormID )
endfunction

Form function PeekFrontWOOF()
	return ArrayUtil._PeekFront( _WOOF_array, _WOOF_size )
endfunction

Form function PeekLastWOOF()
	return ArrayUtil._PeekLast( _WOOF_array, _WOOF_size )
endfunction

Form function PopFrontWOOF()
	return ArrayUtil._PopFront( _WOOF_array, _WOOF_size )
endfunction

Form function PopLastWOOF()
	return ArrayUtil._PopLast( _WOOF_array, _WOOF_size )
endfunction

Form function AtWOOF( int index )
	return ArrayUtil._At( _WOOF_array, _WOOF_size, index )
endfunction

;*****************************************************************************;
; Initialization templates
;*****************************************************************************;

function InitWOOF()
	if( _WOOF_array == None )
		_WOOF_array = new Form[ 8 ]
		_WOOF_size = new int[ 1 ]
		_WOOF_size[0] = 0
	endif
endfunction

function InitWOOF()
	if( _WOOF_array == None )
		_WOOF_array = new Form[ 16 ]
		_WOOF_size = new int[ 1 ]
		_WOOF_size[0] = 0
	endif
endfunction

function InitWOOF()
	if( _WOOF_array == None )
		_WOOF_array = new Form[ 32 ]
		_WOOF_size = new int[ 1 ]
		_WOOF_size[0] = 0
	endif
endfunction

function InitWOOF()
	if( _WOOF_array == None )
		_WOOF_array = new Form[ 64 ]
		_WOOF_size = new int[ 1 ]
		_WOOF_size[0] = 0
	endif
endfunction

function InitWOOF()
	if( _WOOF_array == None )
		_WOOF_array = new Form[ 128 ]
		_WOOF_size = new int[ 1 ]
		_WOOF_size[0] = 0
	endif
endfunction
}

;*****************************************************************************;
; Modification
;*****************************************************************************;
function _Add( Form[] _array, int[] _size, Form akFormID ) global
{ Adds the provided item to the list }
	
	if( _size[0] < _array.Length )
		_array[ _size[0] ] = akFormID
		_size[0] = _size[0] + 1
		
		return
	endif
	
	Debug.Trace( "ArrayUtil::Add: Ran out of array space when adding form!" )
endfunction

bool function _Remove( Form[] _array, int[] _size, Form akFormID ) global
{ Removes the first instance of the provided item from the list }
	
	int i = 0
	bool found = false
	
	while( i < _size[0] && !found )
		if( _array[ i ] == akFormID )
			found = true
		endif
		
		i += 1
	endwhile
	
	; Move the remaining poisons down the list
	if( found )
		while( i < _size[0] )
			_array[ i - 1 ] = _array[ i ]
			
			i += 1
		endwhile
		
		_size[0] = _size[0] - 1
		_array[ _size[0] ] = None
		
		return true
	endif
	
	return false
endfunction

function _Clear( Form[] _array, int[] _size ) global
{ Removes all items from the list }
	
	int i = 0
	
	while( i < _size[0] )
		_array[ i ] = None
		
		i += 1
	endwhile
	
	_size[0] = 0
	
	return
endfunction

;*****************************************************************************;
; Queries
;*****************************************************************************;
int function _Size( Form[] _array, int[] _size ) global
{ Returns the amount of items in the list }
	
	return _size[0]
endfunction

int function _Count( Form[] _array, int[] _size, Form akFormID ) global
{ Returns the amount of times the provided item is present in the list }
	
	int i = 0
	int count = 0
	
	while( i < _size[0] )
		if( _array[ i ] == akFormID )
			count += 1
		endif
		
		i += 1
	endwhile
	
	return count
endfunction

bool function _Contains( Form[] _array, int[] _size, Form akFormID ) global
{ Returns true if the provided item is present in the list, false otherwise }
	
	int i = 0
	
	while( i < _size[0] )
		if( _array[ i ] == akFormID )
			return true
		endif
		
		i += 1
	endwhile
	
	return false
endfunction

Form function _PeekFront( Form[] _array, int[] _size ) global
{ Returns the first item contained in the list }

	return _array[ 0 ]
endfunction

Form function _PeekLast( Form[] _array, int[] _size ) global
{ Returns the last item contained in the list }
	
	if( _size[0] == 0 )
		return None
	endif
	
	return _array[ _size[0] - 1 ]
endfunction

Form function _PopFront( Form[] _array, int[] _size ) global
{ Returns the first item contained in the list }

	if( _size[0] == 0 )
		Debug.Trace( "ArrayUtil::PopFront: Refusing to pop from an empty list" )
		return None
	endif
	
	Form ret = _array[ 0 ]
	
	int i = 1
	while( i < _size[0] )
		_array[ i - 1 ] = _array[ i ]
		i += 1
	endwhile
	
	_size[0] = _size[0] - 1
	_array[ _size[0] ] = None
	
	return ret
endfunction

Form function _PopLast( Form[] _array, int[] _size ) global
{ Returns the last item contained in the list }
	
	if( _size[0] == 0 )
		Debug.Trace( "ArrayUtil::PopLast: Refusing to pop from an empty list" )
		return None
	endif
	
	Form ret = _array[ _size[0] - 1 ]
	
	_size[0] = _size[0] - 1
	_array[ _size[0] ] = None
	
	return ret
endfunction

Form function _At( Form[] _array, int[] _size, int index ) global
{ Returns the item located at the specified index }
	
	if( index >= 0 && index < _size[0] )
		return _array[ index ]
	endif
	
	Debug.Trace( "ArrayUtil::At: index out of bounds" )
	return None
endfunction
