state("jasp")
{
	bool isLoaded   : 0x897C9C;
	bool finalSplit : 0x835AB4;
	int  mapNumber  : 0x480CD0;
	int  IL_counter : 0x48FEF0, 0x1648;
}

state("jasp", "Speed Academy v0.9")
{
	bool isLoaded   : 0x54B48C;
	bool finalSplit : 0x5E9058;
	int  mapNumber  : 0x53DAA8;
	int  IL_counter : 0x53F388, 0x1648;
}

state("jasp", "Speed Academy v1.1")
{
	bool isLoaded   : 0x54940C;
	bool finalSplit : 0x5E7008;
	int  mapNumber  : 0x53B9D8;
	int  IL_counter : 0x53D30C, 0x1648;
}

init
{
	version = "Vanilla";

	if (game.MainModule.FileVersionInfo.ProductName == "Speed Academy")
	{
		if (game.MainModule.FileVersionInfo.FileMajorPart == 1 &&
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
			version = "Unsupported";
		}
	}

	timer.IsGameTimePaused = false;
	game.Exited += (s, e) => timer.IsGameTimePaused = true;
}

startup
{
	settings.Add("ILT", false, "IL Timer");
	settings.Add("dumbstart", false, "Start time on end of loadscreen");
}

split
{
	return (old.mapNumber != current.mapNumber) && ((current.mapNumber > 2 && old.mapNumber == 0 && current.mapNumber != 24) || settings["ILT"])
	       || (current.mapNumber == 78 && current.finalSplit) || (settings["ILT"] && current.IL_counter > old.IL_counter);
}

start
{
	return ((current.isLoaded && !old.isLoaded) && (current.mapNumber == 24 || settings["dumbstart"]));
}

reset
{
	return current.mapNumber == 24 && old.mapNumber != 24;
}

isLoading
{
	return !current.isLoaded;
}
