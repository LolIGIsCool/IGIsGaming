//server only
if not SERVER then return end
util.AddNetworkString("VANILLA_PATRON_CLIENT");

//if there is no list, create one.
if not file.Exists("patronlist.json","DATA") then
    //create a blank table and convert it to JSON
    local patronList = {};
    local jsonPatronList = util.TableToJSON(patronList,true);

    //save the JSON to a file
    file.Write("patronlist.json", jsonPatronList );
end

//every 5 mins, update the global patron list
timer.Create("VANILLA_PATRONUPDATE",300,0,function()
    //read the patron list file and convert it to a table from JSON
    local jsonPatronList = file.Read("patronlist.json","DATA");
    local patronList = util.JSONToTable(jsonPatronList);

    //get the timestamp
    local timeStamp = os.time();

    //compare date with values in table
    for k, v in pairs(patronList) do
        //if the day and month is the same as today
        if v.day >= tonumber(os.date("%d",timeStamp)) and v.month == tonumber(os.date("%m",timeStamp)) or v.month < tonumber(os.date("%m",timeStamp)) then
            //remove the patron from the list
            table.RemoveByValue(patronList,v);
        end
    end

    //send the patron list to the client
    net.Start("VANILLA_PATRON_CLIENT");
    net.WriteTable(patronList); //Yeah, I used write table. Cry about it.
    net.Broadcast();

    MsgN("[ ♡ | VANILLA PATRON LIST ] PATRON LIST UPDATED ");

    //save the modified table to disk
    jsonPatronList = util.TableToJSON(patronList,true);
    file.Write("patronlist.json", jsonPatronList );
end)

/*

Global Patron Variable (TABLE):
    * IGPatronList

Command to add patrons can be found:
    * addons/_ig_custom_ulx_cmds/lua/ulx/modules/sh/sh_lua.lua

References to patron file can be found:
    * addons/_a_pointshop/lua/pointshop_config.lua
    * addons/_lua_bleur_scoreboard/lua/autorun/bleur_scoreboard.lua
    * gamemodes/starwarsrp/gamemode/modules/jobs/sh_jobs.lua

*/
