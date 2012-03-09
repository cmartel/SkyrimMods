scriptname DPPQuestScript extends Quest

Faction property NoCrimeFaction auto
DPPPickpocketTargetAlias property PickpocketTarget auto
FormList property PickpocketPoisons auto

DPPPoisonTargetAlias[] property PoisonTargets auto

MagicEffect[] property PoisonEffects auto

; Pickpocket Target management
function SetPickpocketTarget( ObjectReference akTarget )
	Debug.Trace( "DiscreetPoisonedPerk: setting PickpocketTarget ref to " + akTarget )
	PickpocketTarget.ForceRefTo( akTarget )
	PickpocketTarget.RegisterForSingleUpdate( 0.001 )
	
	Utility.Wait( 0.001 ) ; Wait until menu closes
	
	Debug.Trace( "DiscreetPoisonedPerk: Menu wait done"  )
	if( PickpocketPoisons.GetSize() > 0 )
		Debug.Trace( "DiscreetPoisonedPerk: Poison(s) were added, watching new effects"  )
		PickpocketPoisons.Revert()
		
		;PickpocketTarget.WasPoisoned = true
		;AddPoisonedTarget( akTarget )
	endif
endfunction

function ClearPickpocketTarget()
	Debug.Trace( "DiscreetPoisonedPerk: clearing PickpocketTarget ref " + PickpocketTarget.GetActorRef() )
	PickpocketTarget.Clear()
	PickpocketPoisons.Revert()
endfunction

; Poisoned Target management
DPPPoisonTargetAlias function AddPoisonedTarget( ObjectReference akTarget )
	int i = 0
	
	while( i < PoisonTargets.Length )
		if( PoisonTargets[i].GetRef() == akTarget )
			return PoisonTargets[i]
		endif
		
		if( PoisonTargets[i].GetRef() == None )
			PoisonTargets[i].ForceRefTo( akTarget )
			return PoisonTargets[i]
		endif
		
		i += 1
	endwhile
	
	Debug.Trace( "DiscreetPoisonedPerk: Ran out of PoisonTargets when trying to add " + akTarget )
	return None
endfunction

function RemovePoisonedTarget( ObjectReference akTarget )
	int i = 0
	
	while( i < PoisonTargets.Length )
		if( PoisonTargets[i].GetRef() == akTarget )
			PoisonTargets[i].Clear()
			return
		endif
		
		i += 1
	endwhile
	
	Debug.Trace( "DiscreetPoisonedPerk: Could not find " + akTarget + " in PoisonTargets for removal" )
endfunction

bool function IsPoisonedTarget( ObjectReference akTarget )
	int i = 0
	
	while( i < PoisonTargets.Length )
		if( PoisonTargets[i].GetRef() == akTarget )
			return true
		endif
		
		i += 1
	endwhile
	
	return false
endfunction

DPPPoisonTargetAlias function GetPoisonedTarget( ObjectReference akTarget )
	int i = 0
	
	while( i < PoisonTargets.Length )
		if( PoisonTargets[i].GetRef() == akTarget )
			return PoisonTargets[i]
		endif
		
		i += 1
	endwhile
	
	return None
endfunction
