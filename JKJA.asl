state("jasp", "Vanilla")
{
	bool isLoaded   : 0x897C9C;
	bool finalSplit : 0x835AB4;
	int  mapNumber  : 0x480CD0;
}

state("jasp", "Speed Academy")
{
	bool isLoaded   : 0x56050C;
	bool finalSplit : 0x6FED9C;
	int  mapNumber  : 0x552AD8;
}

state("jasp", "Speed Academy v0.9")
{
	bool isLoaded   : 0x54B48C;
	bool finalSplit : 0x5E9058;
	int  mapNumber  : 0x53DAA8;
}

state("jasp", "Speed Academy v1.1")
{
	bool isLoaded   : 0x54940C;
	bool finalSplit : 0x5E7008;
	int  mapNumber  : 0x53B9D8;
}

state("jasp", "Speed Academy v1.2")
{
	bool isLoaded   : 0x54C50C;
	bool finalSplit : 0xC1776C;
	int  mapNumber  : 0x53EAD8;
}

state("jasp", "Speed Academy v1.3")
{
	bool isLoaded   : 0x54D50C;
	bool finalSplit : 0xC1877C;
	int  mapNumber  : 0x53FAD8;
}

state("jasp", "Speed Academy v1.5")
{
	bool isLoaded   : 0x5504EC;
	bool finalSplit : 0xC1B83C;
	int  mapNumber  : 0x542AC8;
}

state("jasp", "Speed Academy v1.6 (IGT)")
{
	int  ingameTime : 0xC1C8B4;
	bool finalSplit : 0xC1C8BC;
	int  mapNumber  : 0x543B48;
}

state("jasp", "Speed Academy v1.7 (IGT)")
{
	int  ingameTime : 0xC22964;
	bool finalSplit : 0xC2296C;
	int  mapNumber  : 0x549AA8;
}

state("jasp", "Speed Academy v1.8 (IGT)")
{
	int  ingameTime : 0xC21654;
	bool finalSplit : 0xC2165C;
	int  mapNumber  : 0x548778;
}

state("jasp", "Speed Academy Automatic (IGT)")
{
}

update
{
	if (version == "Speed Academy Automatic (IGT)")
	{
		current.mapNumber = memory.ReadValue<int>((IntPtr)vars.mapNumberAddress);
		current.ingameTime = memory.ReadValue<int>((IntPtr)vars.ingameTimeAddress);
		current.finalSplit = memory.ReadValue<bool>((IntPtr)vars.finalSplitAddress);
	}
}

init
{
	if (game.MainModule.ModuleMemorySize == 14618624 ||
	    game.MainModule.FileVersionInfo.ProductName == "Speed Academy")
	{
		var scanner = new SignatureScanner(
			game, game.MainModule.BaseAddress, game.MainModule.ModuleMemorySize
		);
		var magic_id = new byte[] {
			0x6D, 0x61, 0x67, 0x69, 0x63, 0x20,                    // magic
			0x69, 0x64, 0x20,                                      // id
			0x66, 0x6F, 0x72, 0x20,                                // for
			0x73, 0x70, 0x65, 0x65, 0x64, 0x72, 0x75, 0x6E, 0x20,  // speedrun
			0x64, 0x61, 0x74, 0x61, 0x20,                          // data
			0x66, 0x6F, 0x72, 0x20,                                // for
			0x6C, 0x69, 0x76, 0x65, 0x73, 0x70, 0x6C, 0x69, 0x74   // livesplit
		};
		var ptr = scanner.Scan(new SigScanTarget(magic_id));

		if (ptr != IntPtr.Zero)
		{
			version = "Speed Academy Automatic (IGT)";
			ptr += magic_id.Length;
			vars.mapNumberAddress = ptr;
			vars.ingameTimeAddress = vars.mapNumberAddress + 4;
			vars.finalSplitAddress = vars.ingameTimeAddress + 4;
		}
		else if (game.MainModule.FileVersionInfo.FileMajorPart == 1 &&
		         game.MainModule.FileVersionInfo.FileMinorPart >= 8)
		{
			version = "Speed Academy v1.8 (IGT)";
		}
		else if (game.MainModule.FileVersionInfo.FileMajorPart == 1 &&
		         game.MainModule.FileVersionInfo.FileMinorPart >= 7)
		{
			version = "Speed Academy v1.7 (IGT)";
		}
		else if (game.MainModule.FileVersionInfo.FileMajorPart == 1 &&
		         game.MainModule.FileVersionInfo.FileMinorPart >= 6)
		{
			version = "Speed Academy v1.6 (IGT)";
		}
		else if (game.MainModule.FileVersionInfo.FileMajorPart == 1 &&
		         game.MainModule.FileVersionInfo.FileMinorPart >= 5)
		{
			version = "Speed Academy v1.5";
		}
		else if (game.MainModule.FileVersionInfo.FileMajorPart == 1 &&
		         game.MainModule.FileVersionInfo.FileMinorPart >= 3)
		{
			version = "Speed Academy v1.3";
		}
		else if (game.MainModule.FileVersionInfo.FileMajorPart == 1 &&
		         game.MainModule.FileVersionInfo.FileMinorPart >= 2)
		{
			version = "Speed Academy v1.2";
		}
		else if (game.MainModule.FileVersionInfo.FileMajorPart == 1 &&
		         game.MainModule.FileVersionInfo.FileMinorPart >= 1)
		{
			version = "Speed Academy v1.1";
		}
		else if (game.MainModule.FileVersionInfo.FileMajorPart > 0 ||
		         (game.MainModule.FileVersionInfo.FileMajorPart == 0 &&
		          game.MainModule.FileVersionInfo.FileMinorPart >= 9))
		{
			version = "Speed Academy v0.9";
		}
		else
		{
			version = "Speed Academy";
		}
	}
	else
	{
		version = "Vanilla";
	}

	timer.IsGameTimePaused = false;
}

split
{
	return (old.mapNumber != current.mapNumber && current.mapNumber > 2 && old.mapNumber == 0 && current.mapNumber != 24) ||
	       (current.mapNumber == 78 && current.finalSplit);
}

start
{
	if (version.EndsWith("(IGT)"))
	{
		return old.ingameTime == 0 && current.ingameTime != 0;
	}
	return (current.isLoaded && !old.isLoaded) && current.mapNumber == 24;
}

reset
{
	if (version.EndsWith("(IGT)"))
	{
		return current.ingameTime == 0;
	}
    return current.mapNumber == 24 && old.mapNumber != 24;
}

isLoading
{
	if (version.EndsWith("(IGT)"))
	{
		return true;
	}
	return !current.isLoaded;
}

exit
{
    timer.IsGameTimePaused = true;
}

gameTime
{
	if (version.EndsWith("(IGT)"))
	{
		return TimeSpan.FromMilliseconds(current.ingameTime);
	}
}
