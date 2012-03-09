scriptName toggleLightFixture extends ObjectReference
{
arf arf
}

bool property StartsOff = false auto
{ Determines whether the light should start on or off. }

Activator property LitFixture auto
{ Light fixture that will be used when the light is lit. }

Activator property UnlitFixture auto
{ Light fixture that will be used when the light is unlit. }

toggleLightFixture property AlternateFixture = None auto hidden
{ Alternate fixture that this one will switch to. }

bool property IsSlave = false auto hidden
{ Determines whether the AlternateFixture is a slave. }

string property SelfType = "Master" auto hidden

toggleLightFixture function CreateSlave( Activator type )
	toggleLightFixture ret = Self.PlaceAtMe( type, 1, false, true ) as toggleLightFixture
	
	ret.StartsOff = !StartsOff
	ret.AlternateFixture = Self
	ret.IsSlave = true
	ret.SelfType = "Slave"
	
	return ret
endfunction

event OnInit()
	Debug.Trace( "OnInit: Registering for single update" )
	RegisterForSingleUpdate( 0.5 )
endevent

event OnUpdate()
	Debug.Trace( SelfType + "::OnUpdate: Constructing self" )
	
	Activator altActivator
	
	if( IsSlave == false )
		if( StartsOff )
			altActivator = LitFixture
		else
			altActivator = UnlitFixture
		endif
	
		Debug.Trace( SelfType + "::OnUpdate: Creating slave" )
		AlternateFixture = CreateSlave( altActivator )
	endif
endevent

event OnActivate( ObjectReference triggerRef )
	Debug.Trace( SelfType + "::OnActivate: Activated in zero state by " + triggerRef )
	toggleLightFixture master = Self
	if( IsSlave == true )
		master = AlternateFixture
	endif

	; Activate unlit sconce
	AlternateFixture.EnableNoWait()
	
	; Toggle light
	if( IsSlave )
		master.EnableLinkChain()
	else
		master.DisableLinkChain()
	endif
	
	; Disable lit sconce
	Self.Disable()
endevent
