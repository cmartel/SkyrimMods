scriptname DPPQuestScript extends Quest

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

Faction property NoCrimeFaction auto

DPPPoisonTargetAlias[] property PoisonTargets auto

event OnReset()
	Debug.Trace( "DPP::Quest::OnReset" )
endevent

event OnInit()
	Debug.Trace( "DPP::Quest::OnInit" )
	int i = 0
	
	while( i < PoisonTargets.Length )	
		PoisonTargets[i].InitPoisonItem()
		PoisonTargets[i].InitPoisonEffect()
		
		i += 1
	endwhile
endevent

; Initial target pickpocket window
; Only magic effects applied during this time will be counted
function SetPickpocketTarget( ObjectReference akTarget )
	Debug.Trace( "DPP::Quest::SetPickpocketTarget: setting PickpocketTarget ref to " + akTarget )
	DPPPoisonTargetAlias poisonTarget = AddPoisonedTarget( akTarget )
	; "wake up" detection, however the hell this junk works
	Game.GetPlayer().IsDetectedBy( akTarget as Actor )
	
	Utility.Wait( 0.2 ) ; Wait until menu closes and effects are applied
	Debug.Trace( "DPP::Quest::SetPickpocketTarget: Menu wait done, clearing poison items"  )
	
	; Clear poison items so any other new effects don't get discounted as valid
	; poisons
	poisonTarget.ClearPoisonItem()
	if( poisonTarget.SizePoisonEffect() == 0 )
		RemovePoisonedTarget( akTarget )
		Debug.Trace( "DPP::Quest::SetPickpocketTarget: Did not poison target, clearing it" )
	endif
endfunction

; Poisoned Target management
DPPPoisonTargetAlias function AddPoisonedTarget( ObjectReference akTarget )
	int i = 0
	
	while( i < PoisonTargets.Length )
		if( PoisonTargets[ i ].GetRef() == akTarget )
			Debug.Trace( "DPP::Quest::AddPoisonedTarget: reusing existing target index " + i )
			return PoisonTargets[ i ]
		endif
		
		if( PoisonTargets[ i ].GetRef() == None )
			PoisonTargets[ i ].ForceRefTo( akTarget )
			Debug.Trace( "DPP::Quest::AddPoisonedTarget: using free target index " + i )
			return PoisonTargets[ i ]
		endif
		
		i += 1
	endwhile
	
	Debug.Trace( "DPP::QuestAddPoisonedTarget: Ran out of PoisonTargets when trying to add " + akTarget )
	return None
endfunction

function RemovePoisonedTarget( ObjectReference akTarget )
	int i = 0
	
	while( i < PoisonTargets.Length )
		if( PoisonTargets[ i ].GetRef() == akTarget )
			PoisonTargets[ i ].Clear()
			PoisonTargets[ i ].ClearPoisonEffect()
			PoisonTargets[ i ].ClearPoisonItem() ; should not necessary, but just in case
			return
		endif
		
		i += 1
	endwhile
	
	Debug.Trace( "DPP::Quest::RemovePoisonedTarget: Could not find " + akTarget + " in PoisonTargets for removal" )
endfunction

bool function IsPoisonedTarget( ObjectReference akTarget )
	int i = 0
	
	while( i < PoisonTargets.Length )
		if( PoisonTargets[ i ].GetRef() == akTarget )
			return true
		endif
		
		i += 1
	endwhile
	
	return false
endfunction

DPPPoisonTargetAlias function GetPoisonedTarget( ObjectReference akTarget )
	int i = 0
	
	while( i < PoisonTargets.Length )
		if( PoisonTargets[ i ].GetRef() == akTarget )
			return PoisonTargets[ i ]
		endif
		
		i += 1
	endwhile
	
	return None
endfunction

