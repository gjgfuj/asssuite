Engine Interface
=================
The ASSEngine has a good interface for making your own engine.

----------------------------------------------------------------------------------------------------------------------------

To create an engine, you must define:

Object#coordquery to query for coordinates.

Object#query to query for other information.

Object#drawmap to draw a map on the screen.

Object#gamelog to display text to the user.

ASSEngine::Engine#run is your main loop.

ASSEngine::Gamemode#commandquery to query for a command.


-----------------------------------------------------------------------------------------------------------------------------

With these methods implemented, your engine should play nice with the games written for the ASSEngine.