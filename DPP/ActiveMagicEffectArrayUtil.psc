scriptname ActiveMagicEffectArrayUtil hidden

; Copyright (c) 2012, Camille Martel a.k.a. Seleste
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;     * Redistributions of source code must retain the above copyright
;       notice, this list of conditions and the following disclaimer.
;     * Redistributions in binary form must reproduce the above copyright
;       notice, this list of conditions and the following disclaimer in the
;       documentation and/or other materials provided with the distribution.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
; DISCLAIMED. IN NO EVENT SHALL CAMILLE MARTEL BE LIABLE FOR ANY
; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
; (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
; ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
ActiveMagicEffect[] _WOOF_array = None
int[] _WOOF_size = None

function AddWOOF( ActiveMagicEffect akFormID )
	ActiveMagicEffectArrayUtil._Add( _WOOF_array, _WOOF_size, akFormID )
endfunction

bool function RemoveWOOF( ActiveMagicEffect akFormID )
	return ActiveMagicEffectArrayUtil._Remove( _WOOF_array, _WOOF_size, akFormID )
endfunction

function ClearWOOF()
	ActiveMagicEffectArrayUtil._Clear( _WOOF_array, _WOOF_size )
endfunction

int function SizeWOOF()
	return ActiveMagicEffectArrayUtil._Size( _WOOF_array, _WOOF_size )
endfunction

int function CountWOOF( ActiveMagicEffect akFormID )
	return ActiveMagicEffectArrayUtil._Count( _WOOF_array, _WOOF_size, akFormID )
endfunction

bool function ContainsWOOF( ActiveMagicEffect akFormID )
	return ActiveMagicEffectArrayUtil._Contains( _WOOF_array, _WOOF_size, akFormID )
endfunction

ActiveMagicEffect function PeekFrontWOOF()
	return ActiveMagicEffectArrayUtil._PeekFront( _WOOF_array, _WOOF_size )
endfunction

ActiveMagicEffect function PeekLastWOOF()
	return ActiveMagicEffectArrayUtil._PeekLast( _WOOF_array, _WOOF_size )
endfunction

ActiveMagicEffect function PopFrontWOOF()
	return ActiveMagicEffectArrayUtil._PopFront( _WOOF_array, _WOOF_size )
endfunction

ActiveMagicEffect function PopLastWOOF()
	return ActiveMagicEffectArrayUtil._PopLast( _WOOF_array, _WOOF_size )
endfunction

ActiveMagicEffect function AtWOOF( int index )
	return ActiveMagicEffectArrayUtil._At( _WOOF_array, _WOOF_size, index )
endfunction

;*****************************************************************************;
; Initialization templates
;*****************************************************************************;

function InitWOOF()
	if( _WOOF_array == None )
		_WOOF_array = new ActiveMagicEffect[ 8 ]
		_WOOF_size = new int[ 1 ]
		_WOOF_size[0] = 0
	endif
endfunction

function InitWOOF()
	if( _WOOF_array == None )
		_WOOF_array = new ActiveMagicEffect[ 16 ]
		_WOOF_size = new int[ 1 ]
		_WOOF_size[0] = 0
	endif
endfunction

function InitWOOF()
	if( _WOOF_array == None )
		_WOOF_array = new ActiveMagicEffect[ 32 ]
		_WOOF_size = new int[ 1 ]
		_WOOF_size[0] = 0
	endif
endfunction

function InitWOOF()
	if( _WOOF_array == None )
		_WOOF_array = new ActiveMagicEffect[ 64 ]
		_WOOF_size = new int[ 1 ]
		_WOOF_size[0] = 0
	endif
endfunction

function InitWOOF()
	if( _WOOF_array == None )
		_WOOF_array = new ActiveMagicEffect[ 128 ]
		_WOOF_size = new int[ 1 ]
		_WOOF_size[0] = 0
	endif
endfunction
}

;*****************************************************************************;
; Modification
;*****************************************************************************;
function _Add( ActiveMagicEffect[] _array, int[] _size, ActiveMagicEffect akFormID ) global
{ Adds the provided item to the list }
	
	if( _size[0] < _array.Length )
		_array[ _size[0] ] = akFormID
		_size[0] = _size[0] + 1
		
		return
	endif
	
	Debug.Trace( "ArrayUtil::Add: Ran out of array space when adding ActiveMagicEffect!" )
endfunction

bool function _Remove( ActiveMagicEffect[] _array, int[] _size, ActiveMagicEffect akFormID ) global
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

function _Clear( ActiveMagicEffect[] _array, int[] _size ) global
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
int function _Size( ActiveMagicEffect[] _array, int[] _size ) global
{ Returns the amount of items in the list }
	
	return _size[0]
endfunction

int function _Count( ActiveMagicEffect[] _array, int[] _size, ActiveMagicEffect akFormID ) global
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

bool function _Contains( ActiveMagicEffect[] _array, int[] _size, ActiveMagicEffect akFormID ) global
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

ActiveMagicEffect function _PeekFront( ActiveMagicEffect[] _array, int[] _size ) global
{ Returns the first item contained in the list }

	return _array[ 0 ]
endfunction

ActiveMagicEffect function _PeekLast( ActiveMagicEffect[] _array, int[] _size ) global
{ Returns the last item contained in the list }
	
	if( _size[0] == 0 )
		return None
	endif
	
	return _array[ _size[0] - 1 ]
endfunction

ActiveMagicEffect function _PopFront( ActiveMagicEffect[] _array, int[] _size ) global
{ Returns the first item contained in the list }

	if( _size[0] == 0 )
		Debug.Trace( "ArrayUtil::PopFront: Refusing to pop from an empty list" )
		return None
	endif
	
	ActiveMagicEffect ret = _array[ 0 ]
	
	int i = 1
	while( i < _size[0] )
		_array[ i - 1 ] = _array[ i ]
		i += 1
	endwhile
	
	_size[0] = _size[0] - 1
	_array[ _size[0] ] = None
	
	return ret
endfunction

ActiveMagicEffect function _PopLast( ActiveMagicEffect[] _array, int[] _size ) global
{ Returns the last item contained in the list }
	
	if( _size[0] == 0 )
		Debug.Trace( "ArrayUtil::PopLast: Refusing to pop from an empty list" )
		return None
	endif
	
	ActiveMagicEffect ret = _array[ _size[0] - 1 ]
	
	_size[0] = _size[0] - 1
	_array[ _size[0] ] = None
	
	return ret
endfunction

ActiveMagicEffect function _At( ActiveMagicEffect[] _array, int[] _size, int index ) global
{ Returns the item located at the specified index }
	
	if( index >= 0 && index < _size[0] )
		return _array[ index ]
	endif
	
	Debug.Trace( "ArrayUtil::At: index out of bounds" )
	return None
endfunction
