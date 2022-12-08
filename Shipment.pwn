/* SHIPMENT BY WANS#1874 
     DATE SCRIPT: November 17, 2022
     BASED FROM: Hyper Roleplay (Owned By Wans)
*/

new trailer;

enum
{
   DIALOG_SHIPMENT
}
enum
{
    JOB_SHIPMENT
}

enum
{
    CHECKPOINT_PACKAGES,
	CHECKPOINT_PACKAGES_PROGRESS,
	CHECKPOINT_PACKAGES_RETURN,
	CHECKPOINT_LOAD_PACKAGES,
	CHECKPOINT_PACKAGES_LV,
	CHECKPOINT_PACKAGES_PROGRESS1,
	CHECKPOINT_PACKAGES_RETURN1,
	CHECKPOINT_LOAD_PACKAGES1
}

enum penum
{
   pShipment
}

{"Shipment Job",     2751.804443, -2513.486328, 13.640232}

LocateMethod(playerid, params[])
{
     if(isnull(params))
	{
	    SendClientMessage(playerid, COLOR_SYNTAX, "Null Error - failed to locate properly - contact a developer.");
	    return 1;
	}
    else if(!strcmp(params, "shipment", true))
	{
	    PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
		SetPlayerCheckpoint(playerid, jobLocations[JOB_SHIPMENT][jobX], jobLocations[JOB_SHIPMENT][jobY], jobLocations[JOB_SHIPMENT][jobZ], 3.0);
	    SendClientMessage(playerid, COLOR_WHITE, "** Checkpoint marked at the location of the Shipment job.).");
	}
	return 1;
}

public OnGamemodeInit
{
    CreateDynamic3DTextLabel("'Shipment Pacakes' \nGet some packages here.\nType '/packages'", COLOR_YELLOW, 2765.641113, -2507.481689, 13.627556, 5.0);
	CreateDynamicPickup(1239, 1, 2765.641113, -2507.481689, 13.627556);

	CreateDynamic3DTextLabel("Shipment\nDrop the packages here "GREEN"[Legal]", COLOR_WHITE, 1063.695922, -902.499633, 43.057800, 5.0);
	CreateDynamicPickup(1239, 1, 1063.695922, -902.499633, 43.057800);
	
	CreateDynamic3DTextLabel("Shipment\nDrop the packages here "RED"[Illegal]", COLOR_WHITE, -1694.714721, -35.794784, 3.554687, 5.0);
	CreateDynamicPickup(1239, 1, -1694.714721, -35.794784, 3.554687);
	
	// Shipment Vehicles
	shipmentVehicles[0] = AddStaticVehicleEx(515, 2792.168212, -2523.449707, 13.630036, 90.0000, 3, 6, 300); // bike 1
	shipmentVehicles[1] = AddStaticVehicleEx(515, 2793.115966, -2512.906738, 13.629804, 90.0000, 3, 6, 300); // bike 2
	shipmentVehicles[1] = AddStaticVehicleEx(515, -1682.112548, 5.830327, 3.554687, 90.0000, 3, 6, 300); // bike 2
}

public OnDialogResponse
{
   if(dialogid == DIALOG_SHIPMENT)
	{
		if(response)
		{
			if(listitem == 0) 
			{
			    new veh = GetPlayerVehicleID(playerid);
			    trailer = CreateVehicle(584, 2768.225097, -2494.164794, 13.672930, 1, 1, -1, 0);
				PlayerInfo[playerid][pTrucker] = 1;
				PlayerInfo[playerid][pCP] = CHECKPOINT_PACKAGES;
				SetPlayerCheckpoint(playerid, 2080.664550, -1813.370727, 13.382812, 2.0); // LS
				SetPlayerSkin(playerid, 73);
				AttachTrailerToVehicle(trailer, veh);

				SendClientMessage(playerid, COLOR_WHITE, "You choosed Los Santos Gas Station. Drop it off at the marker");
				SendClientMessage(playerid, COLOR_WHITE, "Please pickup The Trailer before delivering");
			}
		    if(listitem == 1) 
			{
			    new veh = GetPlayerVehicleID(playerid);
			    trailer = CreateVehicle(584, 2768.225097, -2494.164794, 13.672930, 1, 1, -1, 0);
				PlayerInfo[playerid][pTrucker] = 2;
				PlayerInfo[playerid][pCP] = CHECKPOINT_PACKAGES_LV;
				SetPlayerCheckpoint(playerid, -44.226048, -1515.493286, 1.820312, 2.0); // LS
				SetPlayerSkin(playerid, 73);
				AttachTrailerToVehicle(trailer, veh);

				SendClientMessage(playerid, COLOR_WHITE, "You choosed San Fierro Easter Basin Area. Drop it off at the marker");
				SendClientMessage(playerid, COLOR_WHITE, "Please pickup The Trailer before delivering");
			}
		}
	}
	return 1;
}

CMD:packages(playerid, params[])
{
	if(!PlayerHasJob(playerid, JOB_SHIPMENT))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command as you are not a Trucker Man.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 2765.641113, -2507.481689, 13.627556))
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not at the packaging area");
	}
	if(PlayerInfo[playerid][pTruckerTiming] > 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You're already Shipment now!");
	}
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 514 && GetVehicleModel(GetPlayerVehicleID(playerid)) != 515)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not in a taxi type vehicle.");
	}

    new string[128*2];
    strcat(string, "Location\tCity\tPackages\tStatus");
    format(string, sizeof(string), "%s\n\
    {B564FD}Los Santos\t{FFFFFF}Mulholland\tBusiness Products\t"GREEN"Legal\n\
    {B564FD}San Fierro\t{FFFFFF}Eastern Basin\tDrugs & Weapons\t"RED"Illegal", string);
    ShowPlayerDialog(playerid, DIALOG_SHIPMENT, DIALOG_STYLE_TABLIST_HEADERS, "Choose Delivering Point.", string, "Choose", "Cancel");
	return 1;
}
