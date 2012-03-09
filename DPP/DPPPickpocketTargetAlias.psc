scriptname DPPPickpocketTargetAlias extends ReferenceAlias

; TODO: Add inventory event filtering for potions
event OnItemAdded( Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer )
	FormList addedPoisons = ( GetOwningQuest() as DPPQuestScript ).PickpocketPoisons
	
	Potion itemPotion = akBaseItem as Potion
	if( itemPotion != None )
		if( itemPotion.IsHostile() )
			Debug.Trace( "DiscreetPoisonedPerk: Alias " + GetActorRef() + " added " + itemPotion + " to poison list" )
			
			; TODO: Test for what happens after adding 2 of the same poison and then removing one
			addedPoisons.AddForm( itemPotion )
		endif
	endif
endevent

event OnItemRemoved( Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer )
	FormList addedPoisons = ( GetOwningQuest() as DPPQuestScript ).PickpocketPoisons
	
	if( addedPoisons.HasForm( akBaseItem ) )
		Debug.Trace( "DiscreetPoisonedPerk: Alias " + GetActorRef() + " removed " + akBaseItem + " from poison list" )
		addedPoisons.RemoveAddedForm( akBaseItem )
	endif
endevent

event OnMagicEffectApply( ObjectReference akCaster, MagicEffect akEffect )
	Debug.Trace( "DiscreetPoisonedPerk: Spotted new effect on " + GetActorRef() )
	
	DPPQuestScript dppQuest = GetOwningQuest() as DPPQuestScript
	int i = 0
	
	; Only confirm effects if we added poisons on this guy
	if( dppQuest.PickpocketPoisons.GetSize() > 0 )
		; Go through the poison list...
		while( i < dppQuest.PoisonEffects.Length )
			; Check if this poison matches our applied effect
			if( akEffect == dppQuest.PoisonEffects[i] )
				Debug.Trace( "DiscreetPoisonedPerk: Effect was HP damage poison, watching " + GetActorRef() )
				; We are officially poisoned, change pickpocket target to 
				; poison target
				DPPPoisonTargetAlias poisonedSelf = dppQuest.AddPoisonedTarget( GetReference() )
				poisonedSelf.AppliedPoison = akEffect
				
				dppQuest.ClearPickpocketTarget()
				
				return
			endif
			
			i += 1
		endwhile
		
		; Nothing happened, looks like the player pickpocketed a non-HP poison
		; Clear us from the quest for now
		dppQuest.ClearPickpocketTarget()
	endif
endevent
