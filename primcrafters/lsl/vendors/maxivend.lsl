// Primcrafters MaxiVend
// Sells two versions of multiple items.
// frame_name : Base name of glasses
// basic_cost : cost for the basic (no-script) version
// script_cost : cost for the scripted version

list all_frames = [
    "Wire Glasses:50:100",
    "Half Wire:75:125",
    "Aviators:75:125",
    "Cateyed:75:125",
    "Teardrops:75:125",
    "Geek Chic:75:125",
    "Rectech:75:125",
    "Wireless:75:125"
];

string frame_name = "Teardrops";
integer basic_cost = 75;
integer script_cost = 125;

integer index = 0;
integer max;

string MANUAL_INV = "Primcrafters Manual 2.0";
string GESTURE_INV = "Primcrafters Glasses";
string INV_CATEGORY = "Primcrafters ";

update(integer idx)
{
    list item = llParseString2List(llList2String(all_frames, index),
        [":"], []);
    frame_name = llList2String(item,0);
    basic_cost = (integer)llList2String(item,1);
    script_cost = (integer)llList2String(item,2);
    integer tmpIdx = index + 1;
    string priceStr = "Basic: $" + (string)basic_cost + " Scripted: $" + (string)script_cost;
    llSetText("[" + (string)tmpIdx + "/" + (string)max + "] - " + priceStr,
              <1,1,1>, 1);
    llSetTexture(frame_name + " Img", 4);
}

next()
{
    index++;
    if (index >= max) index = 0;
    update(index);
}

back()
{
    index--;
    if (index < 0) index = max - 1;
    update(index);
}

default
{
    state_entry()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
        max = llGetListLength(all_frames);
        update (index);
    }
    
    touch(integer num)
    {
        llWhisper(0, "Pay me $" + (string)script_cost + " for a scripted (color/tint changing) pair, or $" + (string)basic_cost + " for a basic, non-scripted pair.");
    }

    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "NEXT")
            next();
        if (str == "BACK")
            back();
    }
    
    money(key id, integer amt)
    {
        if (amt < basic_cost)
        {
            llWhisper(0, "You must pay at least $" + (string)basic_cost + " for the basic pair. Refunding $" + (string)amt);
            llGiveMoney(id, amt);
            return;
        }
        if (amt >= basic_cost && amt < script_cost)
        {
            if (amt > basic_cost)
            {
                integer refund = amt - basic_cost;
                llWhisper(0, frame_name + " basic costs $" + (string)basic_cost + ". Here if your change of $" + (string)refund);
                llGiveMoney(id, refund);
            }
            llGiveInventory(id, frame_name + " (b)");
            llMessageLinked(llGetLinkNumber(), basic_cost, "BUY",
                (key)(llKey2Name(id) + "||" +
                      frame_name + "||" +
                      "Basic"));
            return;
        }
        if (amt >= script_cost)
        {
            if (amt > script_cost)
            {
                integer refund = amt - script_cost;
                llWhisper(0, frame_name + " scripted costs $" + (string)script_cost + ". Here if your change of $" + (string)refund);
                llGiveMoney(id, refund);
            }
            list give_items = [frame_name + " (2.0)", MANUAL_INV, GESTURE_INV];
            llGiveInventoryList(id, INV_CATEGORY + frame_name, give_items);
            llMessageLinked(llGetLinkNumber(), script_cost, "BUY",
                (key)(llKey2Name(id) + "||" +
                      frame_name + "||" +
                      "Scripted"));
            return;
        }
    }
}
