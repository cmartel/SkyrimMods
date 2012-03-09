scriptname DPPPoisonTargetAlias extends ReferenceAlias

Faction property PreviousCrimeFaction auto hidden
MagicEffect property AppliedPoison auto hidden

event OnDying( Actor akKiller )
	if( akKiller == Game.GetPlayer() )		
		Faction noCrimeFaction = ( GetOwningQuest() as DPPQuestScript ).NoCrimeFaction
		
		PreviousCrimeFaction = GetActorRef().GetCrimeFaction()
		GetActorRef().SetCrimeFaction( noCrimeFaction )
		
		Debug.Trace( "DiscreetPoisonedPerk: Changing " + GetActorRef() + " faction from " + PreviousCrimeFaction + " to " + noCrimeFaction )
	endif
endevent

event OnDeath( Actor akKiller )
	if( akKiller == Game.GetPlayer() )		
		GetActorRef().SetCrimeFaction( PreviousCrimeFaction )
		
		( GetOwningQuest() as DPPQuestScript ).RemovePoisonedTarget( GetActorRef() )
		
		Debug.Trace( "DiscreetPoisonedPerk: Changing " + GetActorRef() + " faction back to " + PreviousCrimeFaction )
	endif
endevent

