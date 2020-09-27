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

init
{
	if (game.MainModule.ModuleMemorySize == 14618624 ||
	    game.MainModule.FileVersionInfo.ProductName == "Speed Academy")
	{
		if (game.MainModule.FileVersionInfo.FileMajorPart >= 0 &&
		    game.MainModule.FileVersionInfo.FileMinorPart >= 9)
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
