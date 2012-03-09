scriptname DPPActiveMagicEffect extends ActiveMagicEffect

DPPQuestScript property DPPQuest auto

event OnEffectStart( Actor akTarget, Actor akCaster )
	Debug.Trace( "DiscreetPoisonedPerk: " + Self + " started on " + akTarget )
endevent

event OnEffectFinish( Actor akTarget, Actor akCaster )
	Debug.Trace( "DiscreetPoisonedPerk: " + Self + " finished on " + akTarget )
	
	; See if we were a poisoned target
	DPPPoisonTargetAlias poisonedSelf = DPPQuest.GetPoisonedTarget( akTarget )
	if( poisonedSelf != None )
		Debug.Trace( "DiscreetPoisonedPerk: " + akTarget + " was on poisoned targets list " )
		; and if the effect that wore off matches our poison
		int i = 0
		
		while( i < DPPQuest.PoisonEffects.Length )
			if( DPPQuest.PoisonEffects[i] == GetBaseObject() )
				; TODO: I'm fairly certain this logic will fail if we pickpocket 
				; more than one different HP poisons and the last one wears off
				; before
				
				Debug.Trace( "DiscreetPoisonedPerk: effect matches poison effect " + GetBaseObject() )
				DPPQuest.RemovePoisonedTarget( akTarget )
				return
			endif
			
			i += 1
		endwhile
	endif
endevent
