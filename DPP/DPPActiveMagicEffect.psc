scriptname DPPActiveMagicEffect extends ActiveMagicEffect

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
