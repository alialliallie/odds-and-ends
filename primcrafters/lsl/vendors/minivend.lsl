// Primcrafters MiniVend
// Sells two versions of one item.
// frame_name : Base name of glasses
// basic_cost : cost for the basic (no-script) version
// script_cost : cost for the scripted version

string frame_name = "Wireless";
integer basic_cost = 75;
integer script_cost = 125;

string MANUAL_INV = "Primcrafters Manual 2.0";
string GESTURE_INV = "Primcrafters Glasses";
string INV_CATEGORY = "Primcrafters ";

default
{
    state_entry()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
    }
    
    touch_start(integer num)
    {
        llWhisper(0, "Pay me $" + (string)script_cost + " for a scripted (color/tint changing) pair, or $" + (string)basic_cost + " for a basic, non-scripted pair.");
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
