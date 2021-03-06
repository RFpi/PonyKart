#ifndef KEYBINDINGMANAGER_H_INCLUDED
#define KEYBINDINGMANAGER_H_INCLUDED

#include <functional>
#include <vector>
#include <map>
#include <unordered_map>
#include <SDL.h>
#include <boost/signals2.hpp>
#include "Kernel/LKernelObject.h"
#include "Misc/sdl2Extensions.h"

namespace Ponykart
{
namespace Input
{

/// Our key commands - these are for things that need to be polled.
/** If you want to just respond to events, use the ones in InputMain. */
enum class GameInputID
{
	SteeringAxis,
	AccelerateAxis,
	BrakeAxis,

	Accelerate,
	Reverse,
	TurnLeft,
	TurnRight,
	Drift,
	Item
};

/// This class provides an interface between game commands (accelerate, etc) and key presses (WASD, etc).
/** This way we can change which keys do things at runtime
 *  NOTE: Press/Release events are not guaranteed to be perfectly paired in the event of things
 *  like lost focus or input swallowing. For this reason, make sure your event handlers verify
 *  that the event is meaningful for your current state, particularly with respect to Release.
 *  */
class KeyBindingManager : public LKernel::LKernelObject
{
public:
	KeyBindingManager();

	void setKeyboardPlayer (int playerID);
	void clearKeyboardPlayer ();
	void setMousePlayer (int playerID);
	void clearMousePlayer ();
	void setControllerPlayer (SDL_JoystickID controller, int playerID);
	void clearControllerPlayer (SDL_JoystickID controller);
	void clearPlayerController (int playerID);
	void clearControllerPlayers ();

	void setKeyBinding (Extensions::SDLInputID realInputID, GameInputID gameInputID);
	void clearKeyBinding (Extensions::SDLInputID realInputID);
	void clearKeyBinding (GameInputID gameInputID);
	void clearKeyBindings ();

	void setMouseSensetivity (float value);
	float getMouseSensetivity ();

	// Suppressing input well prevent the game logic from receiving game-input events.
	// Input can be suppressed recursively, and must be re-allowed the same number of times
	// before it will resume.
	void suppressInput ();
	void allowInput ();

	// Events
	// First argument is local player ID (0 based).
	boost::signals2::signal<void (int, GameInputID)> pressEvent;
	boost::signals2::signal<void (int, GameInputID)> releaseEvent;
	boost::signals2::signal<void (int, GameInputID, float)> axisMoveEvent;

	// Polling
	bool pollKey (int playerID, GameInputID gameInputID);
	float pollAxis (int playerID, GameInputID gameInputID);

private:
	int inputSuppressedSem;
	float mouseSens;

	// Mapping of controllers to players and vice-versa.
	// Keyboard and mouse are always associated with the main player.
	int keyboardPlayerID, mousePlayerID;
	std::unordered_map<SDL_JoystickID, int> playersMapByControllerID;
	std::map<int, SDL_JoystickID> controllerIDsMapByPlayer;

	// One-to-one mapping of real inputs to game inputs (any given button can only be bound to one action).
	std::unordered_map<Extensions::SDLInputID, GameInputID, typename Extensions::SDLInputID::Hash> gameInputsMapByReal;
	// One-to-many mapping of game inputs to real inputs (you can bind multiple buttons to the same action)
	std::multimap<GameInputID, Extensions::SDLInputID> realInputsMapByGame;

	void setDefaultBindings(); ///< Set up some initial key bindings
	void onKeyPress (const SDL_KeyboardEvent &ke);
	void onKeyRelease (const SDL_KeyboardEvent &ke);
	void onMouseMove (const SDL_MouseMotionEvent &mme);
	void onMouseWheelMove (const SDL_MouseWheelEvent &mwe);
	void onMouseButtonPress (const SDL_MouseButtonEvent &mbe);
	void onMouseButtonRelease (const SDL_MouseButtonEvent &mbe);
	void onControllerAxisMove (const SDL_ControllerAxisEvent &cae);
	void onControllerButtonPress (const SDL_ControllerButtonEvent &cbe);
	void onControllerButtonRelease (const SDL_ControllerButtonEvent &cbe);

public:
	// Accessors
	decltype(playersMapByControllerID) &getPlayersMapByController() { return playersMapByControllerID; }
	decltype(controllerIDsMapByPlayer) &getControllersMapByPlayer() { return controllerIDsMapByPlayer; }
	decltype(gameInputsMapByReal) &getGameInputMapByReal() { return gameInputsMapByReal; }
	decltype(realInputsMapByGame) &getRealInputMapByGame() { return realInputsMapByGame; }
};

} // Input
} // Ponykart

#endif // KEYBINDINGMANAGER_H_INCLUDED
