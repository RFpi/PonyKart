﻿using System.Linq;
using Ponykart.Core;
using Ponykart.Levels;
using Ponykart.Properties;

namespace Ponykart.Players {
	public delegate void PlayerEvent();

	/// <summary>
	/// This class manages the players
	/// </summary>
	public class PlayerManager {
		public Player MainPlayer { get; private set; }
		public Player[] Players { get; private set; }
		public event PlayerEvent OnPostPlayerCreation;

		/// <summary>
		/// Hook up to the level load/unload events
		/// </summary>
		public PlayerManager() {
			Launch.Log("[Loading] Creating PlayerManager...");
			LevelManager.OnLevelLoad += new LevelEvent(OnLevelLoad);
			LevelManager.OnLevelUnload += new LevelEvent(OnLevelUnload);

			RaceCountdown.OnCountdown += new RaceCountdownEvent(RaceCountdown_OnCountdown);
		}

		void RaceCountdown_OnCountdown(RaceCountdownState state) {
			if (state == RaceCountdownState.Go) {
				foreach (var player in Players) {
					player.IsControlEnabled = true;
				}
			}
		}

		/// <summary>
		/// When a level loads, we create the players. For now, we just have one human player and 7 computer-controlled ones
		/// </summary>
		void OnLevelLoad(LevelChangedEventArgs eventArgs) {
			if (eventArgs.NewLevel.Type == LevelType.Race) {
				Players = new Player[Settings.Default.NumberOfPlayers];

				eventArgs.Request.CharacterNames = FillCharacterString(eventArgs.Request.CharacterNames);

				MainPlayer = new HumanPlayer(eventArgs, 0);
				Players[0] = MainPlayer;

				for (int a = 1; a < Settings.Default.NumberOfPlayers; a++) {
					Players[a] = new ComputerPlayer(eventArgs, a);
				}

				if (OnPostPlayerCreation != null)
					OnPostPlayerCreation.Invoke();
			}
		}

		/// <summary>
		/// Dispose of all of the players
		/// </summary>
		void OnLevelUnload(LevelChangedEventArgs eventArgs) {
			if (eventArgs.OldLevel.Type == LevelType.Race) {
				for (int a = 0; a < Players.Length; a++) {
					if (Players[a] != null) {
						Players[a].Detach();
						Players[a] = null;
					}
				}
				MainPlayer = null;
			}
		}


		readonly string[] _availableCharacters = new string[] { "Twilight Sparkle", "Rainbow Dash", "Applejack", "Fluttershy", "Rarity" };
		readonly string _defaultCharacter = "Twilight Sparkle";

		/// <summary>
		/// Makes a character string from scratch, filling it up with characters, trying to avoid duplicates where it can
		/// </summary>
		public string[] MakeCharacterString() {
			int numPlayers = Settings.Default.NumberOfPlayers;
			string[] newChars = new string[numPlayers];

			if (MainPlayer == null) {
				for (int a = 0; a < numPlayers; a++)
					newChars[a] = _availableCharacters.Where(s => !newChars.Contains(s)).DefaultIfEmpty(_defaultCharacter).First();
			}
			else {
				newChars[0] = MainPlayer.Character;
				for (int a = 1; a < numPlayers; a++)
					newChars[a] = _availableCharacters.Where(s => !newChars.Contains(s)).DefaultIfEmpty(_defaultCharacter).First();
			}

			return newChars;
		}

		/// <summary>
		/// Fills up the character input string with other characters, since for most of the quick keyboard commands and stuff,
		/// we only care about what the player character is, so that's all the array has.
		/// Obviously that's going to result in array out of bounds errors if we don't fill the rest of the array up
		/// </summary>
		string[] FillCharacterString(string[] characters) {
			int numPlayers = Settings.Default.NumberOfPlayers;
			if (numPlayers == 1)
				// don't need to fill it if we've only got one character
				return characters;

			string[] newChars = new string[numPlayers];

			// the first character must always be filled
			newChars[0] = characters[0];

			for (int a = 1; a < numPlayers; a++)
				newChars[a] = _availableCharacters.Where(s => !newChars.Contains(s)).DefaultIfEmpty(_defaultCharacter).First();

			return newChars;
		}
	}
}
