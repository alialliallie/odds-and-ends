// Primcrafters Glasses
// $Id: glasses.lsl 15 2005-03-12 15:02:59Z allison $
integer lHandle = -1;

string lastSim;
string gLensColor = "0,0,0";
string gFrameColor = "0,0,0";
integer gAlpha = 50;

string GESTURE_INV = "Primcrafters Glasses";
string MANUAL_INV = "Primcrafters Manual 2.0";
integer numPresets = 0;
integer numLensPieces = 2;
integer autoSun = FALSE;
integer autoSim = FALSE;
integer thePreset = -1;

key getPresetKey = NULL_KEY;
key usePresetKey = NULL_KEY;
key numPresetKey = NULL_KEY;

string PRESETS = "presets";

list COLORS = ["grey", "128,128,128", "gray", "128,128,128", "red", "255,0,0",
"green", "0,255,0", "blue", "0,0,255", "brown", "153,102,51", 
"cyan", "0,255,255", "magenta", "255,0,255", "orange", "255,127,0",
"purple", "127,0,127", "yellow", "255,255,0", "white", "255,255,255",
"chartreuse", "118,238,0", "crimson", "220,20,60", "indigo", "75,00,130",
"maroon", "128,0,64", "mauve", "203,78,97", "mocha", "128,64,0", 
"olive", "128,128,0", "slate", "112,128,144", "bisque", "255,228,196",
"aqua", "0,128,255", "lime", "128,255,0", "rose", "255,193,193",
"teal", "0,128,128", "plum", "128,0,128", "sage", "139,137,64",
"tan", "210,180,140"];

setup()
{
    if (lHandle != -1) llListenRemove(lHandle);
    lHandle = llListen(1980, "", llGetOwner(), "");
}

string colorName2Num(string name)
{
    integer loc = llListFindList(COLORS, [name]);
    if (loc != -1)
        return llList2String(COLORS, loc+1);
    else
        return "0,0,0";
}

sendFrameColor(string c)
{
    gFrameColor = c;
    llSetLinkColor(LINK_SET, color2Vector(c), ALL_SIDES);
    sendLensColor(gLensColor);
}

float convert(integer i)
{
    if (i >= 255) return 1.0;
    if (i <= 0) return 0.0;
    return (float)i/255;
}

vector color2Vector(string s)
{
    list foo = llCSV2List(s);
    vector v;
    v.x = convert(llList2Integer(foo,0));
    v.y = convert(llList2Integer(foo,1));
    v.z = convert(llList2Integer(foo,2));
    return v;
}

sendLensColor(string c)
{
    vector colorVec = color2Vector(c);
    integer i = 2;
    for (i = 2; i <= numLensPieces+1; i++)
    {
        llSetLinkColor(i, colorVec, ALL_SIDES);
    }
    gLensColor = c;
}

sendAlpha(integer a)
{
    integer i = 2;
    float a2 = 0;
    if (a != 0) a2 = (float)a/100;
    for (i = 2; i <= numLensPieces+1; i++)
    {
        llSetLinkAlpha(i, a2, ALL_SIDES);
    }
    gAlpha = a;
}

simColor()
{
    string curSim = llToLower(llGetRegionName());
    if ((curSim == lastSim) && autoSim) return;
    lastSim = curSim;
    sendLensColor(colorName2Num(curSim));
}

sunAlpha()
{
    vector sun = llGetSunDirection();
    if (sun.z > 0.1 && sun.z < 0.8)
        sendAlpha(llRound(sun.z * 100));
    else if (sun.z > 0 && sun.z >= 0.8)
        sendAlpha(80);
    else
        sendAlpha(10);
}

help()
{
    llInstantMessage(llGetOwner(), "Command Quick Ref "+
        "(type '/sg manual' for full manual):"+
        " alpha (0-100) | color (name) | /sg framecolor (name) |"+
        " colorvec (red,green,blue) | preset (number) |"+ 
        " getpreset (number) | setpreset | auto | colorsim | autosim |"+
        " colors | gesture");
}

gesture()
{
    llGiveInventory(llGetOwner(), GESTURE_INV);
}

notecard()
{
    llGiveInventory(llGetOwner(), MANUAL_INV);
}

colors()
{
    string colors;
    integer i; integer n = llGetListLength(COLORS);
    for (i = 0; i < n; i = i + 2)
    {
        if (i != 0) colors += ", ";
        colors += llList2String(COLORS,i);
    }
    llInstantMessage(llGetOwner(), "Colors: " + colors);
}

default
{
    state_entry()
    {
        setup();
    }

    attach(key id)
    {
        setup();
    }
    
    on_rez(integer start)
    {
        setup();
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        string preamble = llGetSubString(msg, 0, 1);
        if (preamble == "sg")
        {
            list args = llParseString2List(llGetSubString(msg, 3, -1), 
                                           [" "], 
                                           []);
            string cmd = llList2String(args,0);
            if (cmd == "alpha") { // Set manual alpha, disable autoSun
                integer alpha = llList2Integer(args,1);
                autoSun = FALSE;
                if (!autoSim) { llSetTimerEvent(0.0); }
                sendAlpha(alpha);
            } 
            if (cmd == "auto") { // Enable autoSun alpha
                autoSun = TRUE;
                llSetTimerEvent(15.0);
                sunAlpha();
            }
            if (cmd == "color") { // Set manual lens color, disable auto
                string color = colorName2Num(llToLower(llList2String(args,1)));
                autoSim = FALSE; lastSim = "";
                if (!autoSun) { llSetTimerEvent(0.0); }
                sendLensColor(color);
            }
            if (cmd == "colorvec") {
                string color = llList2String(args,1);
                autoSim = FALSE; lastSim = "";
                if (!autoSun) { llSetTimerEvent(0.0); }
                sendLensColor(color);
            }
            if (cmd == "colorsim") {
                autoSim = FALSE; lastSim = "";
                if (!autoSun) { llSetTimerEvent(0.0); }
                simColor();
            }
            if (cmd == "autosim") {
                autoSim = TRUE;
                llSetTimerEvent(15.0);
                simColor();
            } 
            if (cmd == "framecolor") {
                string color = colorName2Num(llToLower(llList2String(args,1)));
                sendFrameColor(color);
            }
            if (cmd == "preset") {
                numPresetKey = llGetNumberOfNotecardLines(PRESETS);
                thePreset = llList2Integer(args,1);
                usePresetKey = llGetNotecardLine(PRESETS, thePreset - 1);
            }
            if (cmd == "getpreset") {
                numPresetKey = llGetNumberOfNotecardLines(PRESETS);
                thePreset = llList2Integer(args,1);
                getPresetKey = llGetNotecardLine(PRESETS, thePreset - 1);
            }
            if (cmd == "setpreset") {
                numPresetKey = llGetNumberOfNotecardLines(PRESETS);
                string presetStr = "preset" + (string)(numPresets + 1) + "#";
                presetStr += (string)gAlpha + ":";
                presetStr += gLensColor + ":";
                presetStr += gFrameColor;
                llInstantMessage(llGetOwner(),presetStr);
            }
            if (cmd == "help") {
                help();
            }
            if (cmd == "colors") {
                colors();
            }
            if (cmd == "manual") {
                notecard();
            }
            if (cmd == "gesture") {
                gesture();
            }        
        }
    }
    
    timer()
    {
        if(autoSim) { simColor(); }
        if(autoSun) { sunAlpha(); }
    }

    dataserver(key queryid, string data)
    {
        if (queryid == numPresetKey)
        {
            numPresets = (integer)data;
            return;
        }
        if (data == EOF || data == "")
        {
            llInstantMessage(llGetOwner(), "Invalid preset: " + (string)thePreset);
            return;
        }
        integer garbageLoc = llSubStringIndex(data, "#");
        string presetStr = data;
        if (garbageLoc > -1)
        {
            presetStr = llGetSubString(data, garbageLoc + 1, -1);
        }
        list settings = llParseString2List(presetStr,[":"],[]);
        integer alpha = llList2Integer(settings,0);
        string lensColor = llList2String(settings,1);
        string frameColor = llList2String(settings,2);
        if (queryid == getPresetKey)
        {
            llInstantMessage(llGetOwner(), "Preset " + (string)thePreset +
                " settings -- alpha: " + (string)alpha +
                " lens-color: " + lensColor + 
                " frame-color: " + frameColor);
        }
        if (queryid == usePresetKey)
        {
            llInstantMessage(llGetOwner(), "Applying preset " + 
                (string)thePreset + " settings -- alpha: " + 
                (string)alpha + " lens-color: " + lensColor + 
                " frame-color: " + frameColor);
            autoSim = FALSE; autoSun = FALSE;
            llSetTimerEvent(0.0);
            sendAlpha(alpha);
            sendLensColor(lensColor);
            sendFrameColor(frameColor);
        }
    }
}
