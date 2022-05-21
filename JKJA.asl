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

init
{
	if (game.MainModule.ModuleMemorySize == 14618624 ||
	    game.MainModule.FileVersionInfo.ProductName == "Speed Academy")
	{
		if (game.MainModule.FileVersionInfo.FileMajorPart == 1 &&
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
	return (current.isLoaded && !old.isLoaded) && current.mapNumber == 24;
}

reset
{
    return current.mapNumber == 24 && old.mapNumber != 24;
}

isLoading
{
    return !current.isLoaded;
}

exit
{
    timer.IsGameTimePaused = true;
}
