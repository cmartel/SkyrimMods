This mod aims to enhance the Poisoned perk of the Pickpocket tree by making it possible to poison someone, if done correctly, without getting a murder bounty. Currently, this means if you manage to pickpocket a poison onto someone while they aren't seeing you, then no murder should be pinned on you if the poison kills them. If the mod turns out to work smoothly, and there are enough requests for it, I'll look into adding more complex checks, such as having not to be seen by anyone in order to get away with poisoning someone.

DISCLAIMER:
Note that due to the way the Poisoned perk is set up, it was nearly impossible to establish a link between the "cause" (player pickpockets a poison onto a victim) and the "effect" (victim dies from the poison). This mod therefore has to use very roundabout scripting logic to correctly prevent the murder by poison from being flagged, whilst allowing other crimes to go through. While I've written the scripts to be as conservative as possible and thus minimize side effects, it might be possible that some deaths won't get flagged when they should, or vice versa.

It's also possible that some HP poisons weren't properly identified in this mod, which would result in deaths by this poison triggering murder bounties no matter what. If this happens, let me know and I'll update the mod to factor in these poisons. This also means that any mods that add new poisons will not be covered by this mod. In order to be supported, these mods will have to create a new side-mod that depends on both this mod and theirs, and add the DPPActiveMagicEffect script to the new poison effects.

CONFLICTS:
This mod can potentially have conflicts with other mods that modify the Poisoned perk, or mods that modify the health damage, health duration damage and health ravage alchemy effects.

BUG REPORTS:
Until I can consider this mod stable, I have left a fair amount of debug trace instructions throughout the scripts. If you want to report a bug, please turn on logging and send the contents of the log to cmartel AT gmail DOT com .

Information on how to turn logs and traces on and find the logs is available on the Creation Kit wiki at the following URL: 
http://www.creationkit.com/FAQ:_My_Script_Doesn%27t_Work!

SOURCE:
The scripts used in this mod are open source and freely available on github under the simplified BSD license.

https://github.com/cmartel/SkyrimMods/tree/master/DPP

