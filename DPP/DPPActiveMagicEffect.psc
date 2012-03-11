scriptname DPPActiveMagicEffect extends ActiveMagicEffect

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

DPPQuestScript property DPPQuest auto

event OnEffectStart( Actor akTarget, Actor akCaster )
	Debug.Trace( "DPP::ActiveMagicEffect::OnEffectStart: " + Self + " started on " + akTarget + ", caster: " + akCaster )
	
	if( akCaster == Game.GetPlayer() && akCaster.IsDetectedBy( akTarget ) )
		Debug.Trace( "DPP::ActiveMagicEffect::OnEffectFinish: target sees player, do nothing" )
		return
	endif
	
	DPPPoisonTargetAlias poisonTarget = DPPQuest.GetPoisonedTarget( akTarget )
	
	if( poisonTarget != None && poisonTarget.SizePoisonItem() > 0 )
		poisonTarget.AddPoisonEffect( Self )
		Debug.Trace( "DPP::ActiveMagicEffect::OnEffectStart: Added " + Self + " to poison effect tally" )
	endif
endevent

event OnEffectFinish( Actor akTarget, Actor akCaster )
	Debug.Trace( "DPP::ActiveMagicEffect::OnEffectFinish: " + Self + " finished on " + akTarget )
	
	int targetHP = akTarget.GetActorValue( "Health" ) as int
	if( targetHP <= 0 )
		Debug.Trace( "DPP::ActiveMagicEffect::OnEffectFinish: target is dead, do nothing" )
		return
	endif
	
	DPPPoisonTargetAlias poisonTarget = DPPQuest.GetPoisonedTarget( akTarget )
	
	if( poisonTarget != None )
		if( poisonTarget.RemovePoisonEffect( Self ) )
			Debug.Trace( "DPP::ActiveMagicEffect::OnEffectFinish: Removed " + Self + " from poison effect tally" )
			if( poisonTarget.SizePoisonEffect() == 0 )
				Debug.Trace( "DPP::ActiveMagicEffect::OnEffectFinish: Removed " + akTarget + " from poison targets" )
				DPPQuest.RemovePoisonedTarget( akTarget )
			endif
		endif
	endif
endevent
