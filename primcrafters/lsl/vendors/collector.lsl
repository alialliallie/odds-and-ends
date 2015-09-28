// Primcrafters Sales Collector (on-vend)
string email_addr = "primcrafters@foxbox.us";
string version = "2.0";

default
{
    link_message(integer sender, integer int, string cmd, key id)
    {
        if (cmd == "BUY")
        {
            list sale_data = llParseString2List((string)id, ["||"], []);
            string sim = llGetRegionName();
            string buyer = llList2String(sale_data, 0);
            string frame = llList2String(sale_data, 1);
            string type = llList2String(sale_data, 2);
            string price = (string)int;
            string body = "\nsim: " + sim + "\n" + 
                 "buyer: " + buyer + "\n" + 
                 "frame: " + frame + "\n" +  
                 "type: " + type + "\n" + 
                 "price: " + price + "\n" +
                 "version: " + version;
            llInstantMessage(llGetOwner(), "("+sim+")"+
                buyer+": "+frame+"("+type+")");
            llEmail(email_addr, "SALE", body);
        }
    }
}
