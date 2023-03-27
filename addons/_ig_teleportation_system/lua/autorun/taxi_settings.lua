
/* ----------------------
  -- Script created by --
  ------- Jackool -------
  -- for CoderHire.com --
  -----------------------
  
  This product has lifetime support and updates.
  
  Having troubles? Contact Jackool at any time:
  http://steamcommunity.com/id/thejackool
*/

Taxi_SH = {}

Taxi_SH.AdminGroups = {"superadmin"} // Which ranks can use the taxi_admin command. Seperate by commas
Taxi_SH.NoPickup = true // If people aren't in the admin groups, they can't move the taxis with their physgun

Taxi_SH.Model = "models/kingpommes/starwars/patrol_transport/main.mdl" // Model for the taxis.
//models/kingpommes/starwars/patrol_transport/main.mdl

Taxi_SH.CanTaxi = "any" // Who can use taxis.
// If you wanted to make taxis admin only, remove the // from this line:
// Taxi_SH.CanTaxi = {"superadmin","admin"}

Taxi_SH.TeleTime = 5 // How long it takes after choosing a location to fade in/out and teleport

// Title for taxi menu
Taxi_SH.TitleText = "Imperial Transport"

// Width and height of taxi window. If less than one, it will multiply the number by your screen width and height (for proportions)
Taxi_SH.Width = 750
Taxi_SH.Height = 400

Taxi_SH.EntTitle = "Imperial Transport" // The text that appears in 3D2D above taxis
Taxi_SH.EntDesc = "(press use on this)" // The text that appears under the above title

Taxi_SH.CurLocation = "Current\nLocation" // The text on the button for current location. \n means next line.

Taxi_SH.PhysSave = true // Should taxi positions save when you move them with the physgun?

if CLIENT then include("jacktaxi/cl_jacktaxi.lua") end