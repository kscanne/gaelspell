var err = initInstall("Litreoir GaelSpell do Mhozilla", "ga-IE@dictionaries.addons.mozilla.org", "4.5");
if (err != SUCCESS)
    cancelInstall();

var fProgram = getFolder("Program");
err = addDirectory("", "ga-IE@dictionaries.addons.mozilla.org",
		   "dictionaries", fProgram, "dictionaries", true);
if (err != SUCCESS)
    cancelInstall();

performInstall();
