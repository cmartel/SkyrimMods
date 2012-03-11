scriptname DPPPoisonTargetAlias extends ReferenceAlias

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

Faction property PreviousCrimeFaction auto hidden

; TODO: Add inventory event filtering for potions
event OnItemAdded( Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer )
	Potion itemPotion = akBaseItem as Potion
	if( itemPotion != None )
		if( itemPotion.IsHostile() )
			Debug.Trace( "DPP::PoisonTargetAlias::OnItemAdded: Alias " + GetActorRef() + " added " + akBaseItem + " to poison list" )
			
			AddPoisonItem( akBaseItem )
		endif
	endif
endevent

event OnItemRemoved( Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer )
	if( ContainsPoisonItem( akBaseItem ) )
		Debug.Trace( "DPP::PoisonTargetAlias::OnItemRemoved: Alias " + GetActorRef() + " removed " + akBaseItem + " from poison list" )
		
		RemovePoisonItem( akBaseItem )
	endif
endevent

event OnHit( ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, \
			 bool abBashAttack, bool abHitBlocked )
	
	Debug.Trace( "DPP::PoisonTargetAlias::OnHit: Alias " + GetActorRef() + " hit by " + akAggressor +"'s " + akSource )
	
	if( !ContainsPoisonItem( akSource ) )
		Debug.Trace( "DPP::PoisonTargetAlias::OnHit: akSource was not one of our poison items, removing self from poison targets" )
		( GetOwningQuest() as DPPQuestScript ).RemovePoisonedTarget( GetActorRef() )
	endif
endevent

event OnDying( Actor akKiller )
	if( akKiller == Game.GetPlayer() )		
		Faction noCrimeFaction = ( GetOwningQuest() as DPPQuestScript ).NoCrimeFaction
		
		PreviousCrimeFaction = GetActorRef().GetCrimeFaction()
		GetActorRef().SetCrimeFaction( noCrimeFaction )
		
		Debug.Trace( "DPP::PoisonTargetAlias::OnDying: Changing " + GetActorRef() + " faction from " + PreviousCrimeFaction + " to " + noCrimeFaction )
	endif
endevent

event OnDeath( Actor akKiller )
	if( akKiller == Game.GetPlayer() )		
		GetActorRef().SetCrimeFaction( PreviousCrimeFaction )
		
		( GetOwningQuest() as DPPQuestScript ).RemovePoisonedTarget( GetActorRef() )
		
		Debug.Trace( "DPP::PoisonTargetAlias::OnDeath: Changing " + GetActorRef() + " faction back to " + PreviousCrimeFaction )
	endif
endevent

; Poison item array template
Form[] _PoisonItem_array = None
int[] _PoisonItem_size = None
bool _PoisonItem_initialized = false

function InitPoisonItem()
	Debug.Trace( "DPP::InitPoisonItem" )
	if( _PoisonItem_initialized == false )
		_PoisonItem_array = new Form[ 8 ]
		_PoisonItem_size = new int[ 1 ]
		_PoisonItem_size[0] = 0
		_PoisonItem_initialized = true
		Debug.Trace( "DPP::InitPoisonItem: initialised with size " + _PoisonItem_array.Length )
	endif
endfunction

function AddPoisonItem( Form akFormID )
	ArrayUtil._Add( _PoisonItem_array, _PoisonItem_size, akFormID )
endfunction

bool function RemovePoisonItem( Form akFormID )
	return ArrayUtil._Remove( _PoisonItem_array, _PoisonItem_size, akFormID )
endfunction

function ClearPoisonItem()
	ArrayUtil._Clear( _PoisonItem_array, _PoisonItem_size )
endfunction

int function SizePoisonItem()
	return ArrayUtil._Size( _PoisonItem_array, _PoisonItem_size )
endfunction

int function CountPoisonItem( Form akFormID )
	return ArrayUtil._Count( _PoisonItem_array, _PoisonItem_size, akFormID )
endfunction

bool function ContainsPoisonItem( Form akFormID )
	return ArrayUtil._Contains( _PoisonItem_array, _PoisonItem_size, akFormID )
endfunction

Form function PeekFrontPoisonItem()
	return ArrayUtil._PeekFront( _PoisonItem_array, _PoisonItem_size )
endfunction

Form function PeekLastPoisonItem()
	return ArrayUtil._PeekLast( _PoisonItem_array, _PoisonItem_size )
endfunction

Form function PopFrontPoisonItem()
	return ArrayUtil._PopFront( _PoisonItem_array, _PoisonItem_size )
endfunction

Form function PopLastPoisonItem()
	return ArrayUtil._PopLast( _PoisonItem_array, _PoisonItem_size )
endfunction

Form function AtPoisonItem( int index )
	return ArrayUtil._At( _PoisonItem_array, _PoisonItem_size, index )
endfunction

; Poison effect array template
ActiveMagicEffect[] _PoisonEffect_array = None
int[] _PoisonEffect_size = None
bool _PoisonEffect_initialized = false

function InitPoisonEffect()
	if( _PoisonEffect_initialized == false )
		_PoisonEffect_array = new ActiveMagicEffect[ 16 ]
		_PoisonEffect_size = new int[ 1 ]
		_PoisonEffect_size[0] = 0
		_PoisonEffect_initialized = true
	endif
endfunction

function AddPoisonEffect( ActiveMagicEffect akFormID )
	ActiveMagicEffectArrayUtil._Add( _PoisonEffect_array, _PoisonEffect_size, akFormID )
endfunction

bool function RemovePoisonEffect( ActiveMagicEffect akFormID )
	return ActiveMagicEffectArrayUtil._Remove( _PoisonEffect_array, _PoisonEffect_size, akFormID )
endfunction

function ClearPoisonEffect()
	ActiveMagicEffectArrayUtil._Clear( _PoisonEffect_array, _PoisonEffect_size )
endfunction

int function SizePoisonEffect()
	return ActiveMagicEffectArrayUtil._Size( _PoisonEffect_array, _PoisonEffect_size )
endfunction

int function CountPoisonEffect( ActiveMagicEffect akFormID )
	return ActiveMagicEffectArrayUtil._Count( _PoisonEffect_array, _PoisonEffect_size, akFormID )
endfunction

bool function ContainsPoisonEffect( ActiveMagicEffect akFormID )
	return ActiveMagicEffectArrayUtil._Contains( _PoisonEffect_array, _PoisonEffect_size, akFormID )
endfunction

ActiveMagicEffect function PeekFrontPoisonEffect()
	return ActiveMagicEffectArrayUtil._PeekFront( _PoisonEffect_array, _PoisonEffect_size )
endfunction

ActiveMagicEffect function PeekLastPoisonEffect()
	return ActiveMagicEffectArrayUtil._PeekLast( _PoisonEffect_array, _PoisonEffect_size )
endfunction

ActiveMagicEffect function PopFrontPoisonEffect()
	return ActiveMagicEffectArrayUtil._PopFront( _PoisonEffect_array, _PoisonEffect_size )
endfunction

ActiveMagicEffect function PopLastPoisonEffect()
	return ActiveMagicEffectArrayUtil._PopLast( _PoisonEffect_array, _PoisonEffect_size )
endfunction

ActiveMagicEffect function AtPoisonEffect( int index )
	return ActiveMagicEffectArrayUtil._At( _PoisonEffect_array, _PoisonEffect_size, index )
endfunction
