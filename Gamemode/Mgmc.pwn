#include <a_samp>
#include <a_mysql>
#include <core>
#include <float>
#include <zcmd>
#include <streamer>
#include <foreach>
#include <YSI\y_iterate>
#include	Bcolors
#include discord-connector
#define SSCANF_NO_NICE_FEATURES
#include <sscanf2>
#include <evi>
#include <mSelection>
#include <TSConnector>
#define RED 	"{FF0000}"
#define WHITE 	"{FFFFFF}"
#define function:%0(%1) forward %0(%1); public %0(%1)
#define ENTER(%0,%1) \
	(%0 & (%1))
#pragma unused GetName
#include "../include/gl_common.inc"
#undef MAX_PLAYERS
	#define MAX_PLAYERS  (40)
#define lime    0xFF00FFFF
#define white   0xFFFFFFFF
new DCC_Channel:g_Discord_Chat;

native WP_Hash(buffer[], len, const str[]);

native gpci(playerid, serial[], len);

//Database establistliher:
new ourConnection;

#define SQL_HOSTNAME "NILL"
#define SQL_USERNAME "NILL"
#define SQL_DATABASE "NILL"
#define SQL_PASSWORD "NIL"

//Teamspeak plugin

#define TSC_USERNAME "{fill in}"
#define TSC_PASSWORD "{fill in}"
#define TSC_IP "{fill in}"

new client_found;

//Database establisher end of.
main ()
	{ }

/*	z - minor bug fixes
	y - small updates/new features
	x - big new features
*/
#define BOTNAME "Moderator"
#define BOTCOLOR "{EEF110}"
#define AUTOMSGTIME 300000 
new RandomMessages[ ][ ] =
{
	"Just seen a Cheater? Use /Report.",
	"Need Help Use /help.",
	"Dont know all commands? use /help",
	"Update and fixes are added everyday use /updates to check them"
};
#define SCRIPT_REV "MGMC:RP v1.2.1"
//defines
#define MAX_SAFE 			50		// Maximum safe amount that can be create.
#define SAFE_COOLDOWN_TIME 	5		// How many minutes should be passed to rob a safe again.
#define ROB_MAX 			500 	// Maximum amount of money that can be robbed.
#define ROB_MIN 			100 	// Minimum amount of money that can be robbed.

enum safe_data
{
	safe_Obj,
	safe_BosObj,
	safe_Timer,
	safe_Sure,
	Text3D:safe_Label,
	Float:safe_Pos[4],

	safe_Progress,
	safe_Durum
}

new
	xSafe[MAX_SAFE][safe_data],
	Iterator:xSafes<MAX_SAFE>,

	PlayerText:xRob_TD[MAX_PLAYERS][8],
	Float:pTmpPos[MAX_PLAYERS][4]
;
//flashers
forward FlasherFunc();

new obj[MAX_VEHICLES] = { INVALID_OBJECT_ID, ... };
new obj2[MAX_VEHICLES] = { INVALID_OBJECT_ID, ... };
new LightPwr[MAX_VEHICLES];
new Flasher[MAX_VEHICLES] = 0;
new FlasherState[MAX_VEHICLES];
new FlashTimer;
//Max defines:
#define MAX_PROPERTY (200)
#define pinglimit 1000

#define MAX_BUSINESS (200)
#define MAX_BUSINESS_PRODUCTS (500)

#define MAX_FACTIONS (30)
#define MAX_FACTION_RANKS (21)

#define MAX_PLAYER_VEHICLES (6)

#define MAX_XMR_CATEGORY (40)
#define MAX_XMR_CATEGORY_STATIONS (60)

#define MAX_RECORD_SHOW (6)
#define MAX_ZONE_NAME (28)
#define SCM SendClientMessage
#define SCMex SendClientMessageEx

//Dialogs:
#define DIALOG_DEFAULT (0)
#define DIALOG_CONFIRM_SYS (1)

#define DIALOG_REGISTER (2)
#define DIALOG_LOGIN (3)
#define DIALOG_CHARS (4)

#define DIALOG_REPORT (5)

#define DIALOG_FACTION_CONFIG (6)
#define DIALOG_FACTION_NAME (7)
#define DIALOG_FACTION_ABBREV (8)
#define DIALOG_FACTION_ALTER_R (9)
#define DIALOG_FACTION_ALTER_J (10)
#define DIALOG_FACTION_ALTER_C (11)
#define DIALOG_FACTION_CHATCOLOR (12)
#define DIALOG_FACTION_RANKS (13)
#define DIALOG_FACTION_RANKEDIT (14)
#define DIALOG_FACTION_ALTER_T (15)
#define DIALOG_UNIFORM 2012
#define DIALOG_FDUNIFORM 2024

#define DIALOG_VEHICLE_WEAPONS (16)
#define DIALOG_HOUSE_WEAPONS (17)

#define DIALOG_XMR_CATEGORIES (18)
#define DIALOG_XMR_STATIONS (19)

#define DIALOG_POLICE_SKINS (20)

#define DIALOG_BUY_LIST (21)

#define DIALOG_DEALERSHIP (22)
#define DIALOG_DEALERSHIP_SELECT (23)
#define DIALOG_DEALERSHIP_APPEND (24)

#define DIALOG_DEALERSHIP_APPEND_ALARM (25)
#define DIALOG_DEALERSHIP_APPEND_LOCK (26)
#define DIALOG_DEALERSHIP_APPEND_IMMOB (27)

#define DIALOG_DEALERSHIP_APPEND_COLORMENU (28)
#define DIALOG_DEALERSHIP_APPEND_COLOR1 (29)
#define DIALOG_DEALERSHIP_APPEND_COLOR2 (30)
#define DIALOG_DEALERSHIP_PURCHASE (31)

#define DIALOG_SELECT_HOUSE (32)

#define DIALOG_MDC (33)
#define DIALOG_MDC_NAME (34)
#define DIALOG_MDC_NAME_QUEUE (35)

#define DIALOG_MDC_PLATE (36)
#define DIALOG_MDC_PLATE_QUEUE (37)
#define DIALOG_MDC_PLATE_LIST (38)
#define DIALOG_MDC_FINISH_QUEUE (39)

#define DIALOG_SECRETWORD_CREATE (40)
#define DIALOG_SECRETWORD_INPUT (41)
#define DIALOG_WHITELISTR (42)
#define DIALOG_WHITELIST (43)
#define DIALOG_FINE (44)
#define DIALOG_FUEL (45)
#define DIALOG_FISH_BUY (46)
#define DIALOG_SMUGGLE (48)
#define DIALOG_JIM (49)
#define DIALOG_LOGINUCP (50)
#define DIALOG_HELP (51)
#define DIALOG_GENRALCOMMANDS (52)
#define DIALOG_VEHCOMMANDS (53)
#define DIALOG_JOBCOMMANDS (54)
#define DIALOG_BIZCOMMANDS (55)
#define DIALOG_EMOCOMMANDS (56)
#define DIALOG_FACON (57)
#define DIALOG_MDC_PROPERTY (58)
#define DIALOG_MDC_PROPERTY_QUEUE (59)
#define DIALOG_MDC_PROPERTY_LIST (60)
#define DIALOG_MDC_TICKET (61)

#define FUEL_PRICE 1

new marker[15];
//Colors:
#define COLOR_TRUCK 0xB9B09100
#define COLOR_REDEX (0xF81414FF)
#define COLOR_LIGHTRED 0xFF6347AA
#define COLOR_CUBER 0xE11600FF
#define COLOR_CUBEB 0x005E9C00
#define COLOR_CUBEG 0x7D7D7DFF
#define COLOR_CUBEG2 0x646464FF
#define COLOR_PURPLE (0xD0AEEBFF)

//#define COLOR_GREEN (0x0D7304FF)
#define COLOR_DARKGREEN (0x33AA33FF)

//#define COLOR_YELLOW (0xFFE104FF)
#define COLOR_YELLOWEX (0xFFFF00FF)
//#define COLOR_LIGHTBLUE (0x33CCFFAA)

#define COLOR_GRAD1	(0xCCE6E6FF)
#define COLOR_GRAD2	(0xE2FFFFFF)

//#define COLOR_WHITE (0xFFFFFFFF)
//#define COLOR_GREY 	(0xAFAFAFFF)

#define COLOR_EMOTE	(0xC2A2DAFF)
#define COLOR_REPORT (0xFFFF91FF)

#define COLOR_FADE1 (0xE6E6E6E6)
#define COLOR_FADE2 (0xC8C8C8C8)
#define COLOR_FADE3 (0xAAAAAAAA)
#define COLOR_FADE4 (0x8C8C8C8C)
#define COLOR_FADE5 (0x6E6E6E6E)
#define COLOR_BSSD 0x33CCFFAA

#define COLOR_COP (0x8D8DFFFF)
#define COLOR_DEPT (0xF07A7AFF)

#define COLOR_ACTION (0xF8E687FF)
#define COLOR_SAMP	(0xADC3E7FF)

#define COLOR_RADIO	(0xFFEC8BFF)
#define COLOR_RADIOEX (0xB5AF8FFF)

#define COLOR_PMRECEIVED (0xFFDC18FF)
#define COLOR_PMSENT (0xEEE854FF)

#define COLOR_CYAN (0x00FFFFFF)
//#define COLOR_PINK	(0xFF8282FF)

//Client messages:
#define SendUsageMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_RED, "USAGE: "%1)

#define SendErrorMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_RED, "ERROR: "%1)

#define SendServerMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_RED, "SERVER: "%1)

//Faction types:
#define FACTION_TYPE_ILLEGAL (1)
#define FACTION_TYPE_POLICE (2)
#define FACTION_TYPE_MEDICAL (3)
#define FACTION_TYPE_DOC (4)

//Property types:
#define PROPERTY_TYPE_HOUSE (1)
#define PROPERTY_TYPE_APTCOMPLEX (2)
#define PROPERTY_TYPE_APTROOM (3)

//Business types:
#define BUSINESS_TYPE_RESTAURANT (1)
#define BUSINESS_TYPE_AMMUNATION (2)
#define BUSINESS_TYPE_CLUB (3)
#define BUSINESS_TYPE_BANK (4)
#define BUSINESS_TYPE_GENERAL (5)
#define BUSINESS_TYPE_DEALERSHIP (6)
#define BUSINESS_TYPE_DMV (7)
#define BUSINESS_TYPE_ILLIGAL (8)
#define BUSINESS_TYPE_DOOR (9)

//Player states:
#define PLAYER_STATE_ALIVE (1)
#define PLAYER_STATE_WOUNDED (2)
#define PLAYER_STATE_DEAD (3)

#define IsValidVehicle

//Body parts:
#define BODY_PART_CHEST	(3)
#define BODY_PART_GROIN (4)
#define BODY_PART_LEFT_ARM (5)
#define BODY_PART_RIGHT_ARM (6)
#define BODY_PART_LEFT_LEG (7)
#define BODY_PART_RIGHT_LEG (8)
#define BODY_PART_HEAD (9)

//Spawn points:
#define SPAWN_POINT_AIRPORT (0)
#define SPAWN_POINT_PROPERTY (1)
#define SPAWN_POINT_FACTION (2)
#define SPAWN_POINT_LASTPOS (3)
//gps
new
	ok[MAX_PLAYERS],
	pNavState[MAX_PLAYERS],
	pNavID[MAX_PLAYERS],
	pNavTimer[MAX_PLAYERS],
	PlayerText:NAVpTD[MAX_PLAYERS],
	Text:NAVTD[2]
;

enum NAV_DATA {
    NAV_NAME[32],
    Float:NAV_X,
    Float:NAV_Y,
    Float:NAV_Z
};
//events
new FalloutPlayer[MAX_PLAYERS], //Player Variable that let us know if the player is inside the event or not
FalloutStarted = 0, //Global Variable to know if the Event has started or not
FalloutPlayers = 0, //Global Variable to know how much players we have in the event, if < 1 the event will NOT start.
FalloutWaiting = 0; //Global variable to know if we're waiting for the event to start or not

//Do not edit this
#define PLATFORMS 63 //Number of platforms in the game (Don't change it)

//Editable settings
#define EVENT_START 1 //Calculated in minutes you have to change it (1 = 1 minute)
#define MONEY 10000 //The money that the player wins, change it from there if you want

//Forwards
forward FalloutStarting(playerid);
forward CheckPlayer();
forward FallingPlat();
forward RegenPlatforms();
new PetrolJob[256];
//Platforms
new PlatformObject[63];

new const NavData[][NAV_DATA] = { // Location list in navigation:
	{"Sbi Bank", 1466.6989,-1012.2218,26.8438},
	{"Sweeper Job", 1779.7603,-1697.6520,13.4824},
	{"Fuel Station", 1938.1671,-1771.0117,13.4752},
	{"Clothes Shop", 1412.5907,-1699.8003,13.5395},
	{"Kallu Shop",1837.0367,-1682.3685,13.3229},
	{"Ammunation",1367.1736,-1280.2219,13.5469},
	{"Dealership",556.1899,-1264.2535,17.2422},
	{"Taxi Job",2769.1221,-1611.0466,10.9219},
	{"Trucker Job",2099.6868,-2062.7520,13.5544},
	{"MGFD",1675.8707,-1635.4561,14.2266},
	{"MGMC Shop",1352.1154,-1756.2710,13.5078},
	{"Tow Job",2508.9768,-2116.1365,13.5469}
};

///JOS DEFINES//
#define COLOR_DARKGOLD 0x808000AA
//lotto
#define lottoadd 100  //<------Specifies the amount from which the lottery beguns when /startlotto
                        //or when a player wins and also the amount of money to add to lotto at every lotto
#define ticketprice 50  //<----Price of taking a ticket
#define numrange 150  //<-----For number range to specify the winning nuber should be between 0-numrange
#define lottogap 1   //<-----For the time gap between lottery [the valuse should be in minutes] [NO DECIMAL VALUES]
#define minlottoadd 10  //<----Specifies the minimum amount of money a player can add to lotto
new ticketnum[MAX_PLAYERS],takenticket[MAX_PLAYERS]=0;
new lotto_timer;
new bool:IsLottoStarted=false;
new totallotto=lottoadd;

forward draw();
// -----------------------------------------------------------------------------
// Forwarding the callbacks
// -----------------------------------------------------------------------------

forward MinuteSync();
forward ResetVariables(playerid);
forward LoadChar(playerid);
stock IsNumTaken(n)
{
new m;
foreach(m:Player)
{
if(takenticket[m]==1)
{
if(ticketnum[m]==n)return 1;
}}
return 0;
}


public draw()
{
new m,win,winname[MAX_PLAYER_NAME],wmes[300],iswin=0;
win=random(numrange);
SendClientMessageToAll(0xCCFF00,"LOTTERY DRAW-----------");
format(wmes,sizeof(wmes),"The winning number is %i",win);
SendClientMessageToAll(0xCCFF00,wmes);
foreach(m:Player)
{
if(takenticket[m]==1)
{
takenticket[m]=0;
if(ticketnum[m]==win)
{
GetPlayerName(m,winname,sizeof(winname));
format(wmes,sizeof(wmes),"%s(%i) has win the lottery and gets a total prize of %i $",winname,m,totallotto);
SendClientMessageToAll(0xCCFF00,wmes);
GivePlayerMoney(m,totallotto);
format(wmes,sizeof(wmes),"Congratulations!! You have won total prize of %i $ from lotto",totallotto);
SendClientMessage(m,0xCCFF00,wmes);
totallotto=lottoadd;
format(wmes,sizeof(wmes),"The lotto money has been reseted to %i $",totallotto);
SendClientMessageToAll(0xCCFF00,wmes);
iswin=1;
}
ticketnum[m]=20000;//resets the no. if ticket to value that cannot be taken in /ticket
}
}
if(iswin==0)
{
totallotto+=lottoadd;
format(wmes,sizeof(wmes),"No one has won the lottery and the total lotto prize now is %i $",totallotto);
SendClientMessageToAll(0xCCFF00,wmes);
}
return 1;}
new SweepingJob[256];
new RADIO;
forward SweeperJobFinish(playerid);
public SweeperJobFinish(playerid)
{
    if(SweepingJob[playerid] == 0){ return 1; }

    GivePlayerMoney(playerid,200);
    SetPlayerScore(playerid, GetPlayerScore(playerid) + 1);
    SendClientMessage(playerid,COLOR_YELLOW,"* You have been payed for your job! - $200.Continue for more or do /leavejob");
    return 1;
}
//Global variables:
new bool:isDead[MAX_PLAYERS];
new HospTimer[MAX_PLAYERS];
new Float:Deadx[MAX_PLAYERS], Float:Deady[MAX_PLAYERS], Float:Deadz[MAX_PLAYERS];
new deadvw[MAX_PLAYERS];
new deadint[MAX_PLAYERS];
new bool:oocEnabled = false, globalWeather = 2;
new dmv_vehicles[4];
new bool:Voip[MAX_PLAYERS];
new Deadtimer[MAX_PLAYERS];
new speedotimer;
new skins = mS_INVALID_LISTID;
new DMVcp[MAX_PLAYERS];
new Pickup[10];
new dragtimer[MAX_PLAYERS];

/*native FindModelFileNameFromCRC(crc, retstr[], retstr_size);
native FindTextureFileNameFromCRC(crc, retstr[], retstr_size);
native RedirectDownload(playerid, url[]);

new DOWNLOAD_REQUEST_TEXTURE_FILE;
new DOWNLOAD_REQUEST_MODEL_FILE;
new baseurl[] = "http://ce-rp.com/models";
forward OnPlayerRequestDownload(playerid, type, crc);
public OnPlayerRequestDownload(playerid, type, crc)
{
	new fullurl[256+1];
	new dlfilename[64+1];
	new foundfilename=0;

	if(!IsPlayerConnected(playerid)) return 0;

	if(type == DOWNLOAD_REQUEST_TEXTURE_FILE) {
		foundfilename = FindTextureFileNameFromCRC(crc,dlfilename,64);
	}
	else if(type == DOWNLOAD_REQUEST_MODEL_FILE) {
	    foundfilename = FindModelFileNameFromCRC(crc,dlfilename,64);
	}

	if(foundfilename) {
	    format(fullurl,256,"%s/%s",baseurl,dlfilename);
	    RedirectDownload(playerid,fullurl);
	}

	return 0;
}*/


// Pizza job
new pizza_vehicles[4];
new Float: pizza[10][3] =
{
	{-2552.1401,2266.4746,5.4755},
	{-2627.6399,2283.5200,8.3149},
	{-2627.5801,2318.6499,8.3144},
	{-2632.5500,2374.8799,9.0397},
	{-2479.7200,2449.9900,17.3230},
	{-2478.2900,2488.8999,18.2300},
	{-2463.7100,2490.5701,17.0025},
	{-2422.3799,2490.7000,13.2025},
	{-2348.3401,2423.5801,7.3295},
	{-2437.4600,2354.9399,5.4431}
};
new pizzacp[MAX_PLAYERS];

//Smuggle Job
new Float: smuggle[4][3] =
{
	{-2473.1389,1553.8724,33.2344},
	{-1394.6014,1480.8807,1.8672},
	{-1342.6853,491.2126,11.1953},
	{-1154.3422,-478.6216,1.9609}
};
new smugglecp[MAX_PLAYERS];

// Teamspeak
new TSClientID[MAX_PLAYERS];

/*new OneSeatVehicles[38] =
{
    425, 430, 432, 441, 446, 448, 452, 453,
	454, 464, 465, 472, 473, 476, 481, 484,
	485, 486, 493, 501, 509, 510, 519, 520,
	530, 531, 532, 539, 553, 564, 568, 571,
	572, 574, 583, 592, 594, 595
};*/

// Tow/Mechanic
new tow_vehicles[12];

// Fuel
new maintimer;
new RefuelTime[MAX_PLAYERS];

// Taxi
new taxi_vehicles[18];
new sweeper_car[2];
new courier_cars[5];
new fly_car[5];
//acotr
new actor[10];

new cop_car[28];

//Trucking
new trucking_vehicles[15];
new truckcp[MAX_PLAYERS];

new Float: ftruck[4][3] =
{
	{-1929.2186,2385.4419,50.0868},
	{-1270.6809,2707.8284,50.6552},
	{-1212.2183,1821.5236,42.3037},
	{-857.9355,1544.0211,23.5616}
};

new Float: ctruck[2][3] =
{
	{-2462.6641,2292.1482,5.4075},
	{-1493.4614,2645.6985,56.2315}
};

new Float: vtruck[3][3] =
{
	{-1954.0040,2550.0476,53.4073},
	{-2265.8462,2393.1060,5.5529},
	{-1467.2836,1864.0458,32.2006}
};

new Float: gtruck[3][3] =
{
	{-752.1705,1586.5596,27.5467},
	{-2483.3564,2326.5093,5.4910},
	{-1470.6377,1864.5514,33.2208}
};

new Float: ptruck[3][3] =
{
	{-1334.9492,2678.4771,50.6520},
	{-1468.6980,1864.3789,33.2183},
	{-2278.3916,2412.8806,5.5123}
};

//Fish
new sellfish = 5;
new bool:Fishing[MAX_PLAYERS];
new fish[MAX_PLAYERS];
new TimerFish[MAX_PLAYERS];
new AttachWorm[MAX_PLAYERS];
new TimerAttachWorm[MAX_PLAYERS];
new WormAttached[MAX_PLAYERS];
new wormattached2[MAX_PLAYERS];
new attachingw[MAX_PLAYERS];
new Equipped[MAX_PLAYERS];
new RodObject;

//Faction Dialoged
#define DIALOG_SDLOCKER 671
#define DIALOG_FDLOCKER 675

forward JailTimer();
//Enumerators:

enum P_MASTER_ACCOUNTS
{
	mDBID,
	mAccName[60],

	mForumName[60],
	mwhitelist,
	bool:mLoggedin
}

// Smuggle bag
new smugglebag[MAX_PLAYERS];

new e_pAccountData[MAX_PLAYERS][P_MASTER_ACCOUNTS];
new characterLister[MAX_PLAYERS][4][MAX_PLAYER_NAME + 1];
new Text3D:voiplabel[MAX_PLAYERS];
new PlayerText:SpeedoText[MAX_PLAYERS];
new fdgate1_status = 0;
new fdgate2_status = 0;
new fdgate3_status = 0;
new sdgate1_status = 0;
new cell0_status = 0;
new cell1_status = 0;
new door0_status = 0;
new door1_status = 0;
new scrapgate1, scrapgate2;
new scrapgate_status = 0;
new fdgate1, fdgate2, fdgate3;
new gate0;
new door0, door1;
new cell0, cell1;

new Float:IntArray[146][4] = {
{2003.12,1015.19,33.01,351.58},
{770.8,-0.7,1000.73,22.86},
{974.02,-9.59,1001.15,22.6},
{961.93,-51.91,1001.12,95.54},
{830.6,5.94,1004.18,125.81},
{1037.83,0.4,1001.28,353.93},
{1212.15,-28.54,1000.95,170.57},
{1290.41,1.95,1001.02,179.94},
{1412.15,-2.28,1000.92,114.66},
{1527.05,-12.02,1002.1,350.0},
{1523.51,-47.82,1002.27,262.7},
{612.22,-123.9,997.99,266.57},
{512.93,-11.69,1001.57,198.77},
{418.47,-80.46,1001.8,343.24},
{386.53,173.64,1008.38,63.74},
{288.47,170.06,1007.18,22.05},
{206.46,-137.71,1003.09,10.93},
{-100.27,-22.94,1000.72,17.29},
{-201.22,-43.25,1002.27,45.86},
{-202.94,-6.7,1002.27,204.27},
{-25.72,-187.82,1003.55,5.08},
{454.99,-107.25,999.44,309.02},
{372.56,-131.36,1001.49,354.23},
{378.03,-190.52,1000.63,141.02},
{315.24,-140.89,999.6,7.42},
{225.03,-9.18,1002.22,85.53},
{611.35,-77.56,998.0,320.93},
{246.07,108.97,1003.22,0.29},
{6.09,-28.9,1003.55,5.04},
{773.73,-74.7,1000.65,5.23},
{621.45,-23.73,1000.92,15.68},
{445.6,-6.98,1000.73,172.21},
{285.84,-39.02,1001.52,0.75},
{204.12,-46.8,1001.8,357.58},
{245.23,304.76,999.15,273.44},
{290.62,309.06,999.15,89.92},
{322.5,303.69,999.15,8.17},
{-2041.23,178.4,28.85,156.22},
{-1402.66,106.39,1032.27,105.14},
{-1403.01,-250.45,1043.53,355.86},
{1204.67,-13.54,1000.92,350.02},
{2016.12,1017.15,996.88,88.01},
{-741.85,493.0,1371.98,71.78},
{2447.87,-1704.45,1013.51,314.53},
{2527.02,-1679.21,1015.5,260.97},
{-1129.89,1057.54,1346.41,274.53},
{2496.05,-1695.17,1014.74,179.22},
{366.02,-73.35,1001.51,292.01},
{2233.94,1711.8,1011.63,184.39},
{269.64,305.95,999.15,215.66},
{414.3,-18.8,1001.8,41.43},
{1.19,-3.24,999.43,87.57},
{-30.99,-89.68,1003.55,359.84},
{161.4,-94.24,1001.8,0.79},
{-2638.82,1407.34,906.46,94.68},
{1267.84,-776.96,1091.91,231.34},
{2536.53,-1294.84,1044.13,254.95},
{2350.16,-1181.07,1027.98,99.19},
{-2158.67,642.09,1052.38,86.54},
{419.89,2537.12,10.0,67.65},
{256.9,-41.65,1002.02,85.88},
{204.17,-165.77,1000.52,181.76},
{1133.35,-7.85,1000.68,165.85},
{-1420.43,1616.92,1052.53,159.13},
{493.14,-24.26,1000.68,356.99},
{1727.29,-1642.95,20.23,172.42},
{-202.84,-24.03,1002.27,252.82},
{2233.69,-1112.81,1050.88,8.65},
{1211.25,1049.02,359.94,170.93},
{2319.13,-1023.96,1050.21,167.4},
{2261.1,-1137.88,1050.63,266.88},
{-944.24,1886.15,5.01,179.85},
{-26.19,-140.92,1003.55,2.91},
{2217.28,-1150.53,1025.8,273.73},
{1.55,23.32,1199.59,359.91},
{681.62,-451.89,-25.62,166.17},
{234.61,1187.82,1080.26,349.48},
{225.57,1240.06,1082.14,96.29},
{224.29,1289.19,1082.14,359.87},
{239.28,1114.2,1080.99,270.27},
{207.52,-109.74,1005.13,358.62},
{295.14,1473.37,1080.26,352.95},
{-1417.89,932.45,1041.53,0.7},
{446.32,509.97,1001.42,330.57},
{2306.38,-15.24,26.75,274.49},
{2331.9,6.78,26.5,100.24},
{663.06,-573.63,16.34,264.98},
{-227.57,1401.55,27.77,269.3},
{-688.15,942.08,13.63,177.66},
{-1916.13,714.86,46.56,152.28},
{818.77,-1102.87,25.79,91.14},
{255.21,-59.68,1.57,1.46},
{446.63,1397.74,1084.3,343.96},
{227.39,1114.66,1081.0,267.46},
{227.76,1114.38,1080.99,266.26},
{261.12,1287.22,1080.26,178.91},
{291.76,-80.13,1001.52,290.22},
{449.02,-88.99,999.55,89.66},
{-27.84,-26.67,1003.56,184.31},
{2135.2,-2276.28,20.67,318.59},
{306.2,307.82,1003.3,203.14},
{24.38,1341.18,1084.38,8.33},
{963.06,2159.76,1011.03,175.31},
{2548.48,2823.74,10.82,270.6},
{215.15,1874.06,13.14,177.55},
{221.68,1142.5,1082.61,184.96},
{2323.71,-1147.65,1050.71,206.54},
{345.0,307.18,999.16,193.64},
{411.97,-51.92,1001.9,173.34},
{-1421.56,-663.83,1059.56,170.93},
{773.89,-47.77,1000.59,10.72},
{246.67,65.8,1003.64,7.96},
{-1864.94,55.73,1055.53,85.85},
{-262.18,1456.62,1084.37,82.46},
{22.86,1404.92,1084.43,349.62},
{140.37,1367.88,1083.86,349.24},
{1494.86,1306.48,1093.3,196.07},
{-1813.21,-58.01,1058.96,335.32},
{-1401.07,1265.37,1039.87,178.65},
{234.28,1065.23,1084.21,4.39},
{-68.51,1353.85,1080.21,3.57},
{-2240.1,136.97,1035.41,269.1},
{297.14,-109.87,1001.52,20.23},
{316.5,-167.63,999.59,10.3},
{-285.25,1471.2,1084.38,85.65},
{-26.83,-55.58,1003.55,3.95},
{442.13,-52.48,999.72,177.94},
{2182.2,1628.58,1043.87,224.86},
{748.46,1438.24,1102.95,0.61},
{2807.36,-1171.7,1025.57,193.71},
{366.0,-9.43,1001.85,160.53},
{2216.13,-1076.31,1050.48,86.43},
{2268.52,1647.77,1084.23,99.73},
{2236.7,-1078.95,1049.02,2.57},
{-2031.12,-115.83,1035.17,190.19},
{2365.11,-1133.08,1050.88,177.39},
{1168.51,1360.11,10.93,196.59},
{315.45,976.6,1960.85,359.64},
{1893.07,1017.9,31.88,86.1},
{501.96,-70.56,998.76,171.57},
{-42.53,1408.23,1084.43,172.07},
{2283.31,1139.31,1050.9,19.7},
{84.92,1324.3,1083.86,159.56},
{260.74,1238.23,1084.26,84.31},
{-1658.17,1215.0,7.25,103.91},
{-1961.63,295.24,35.47,264.49}
};

new IntArray2[146][1] = {
{11},
{5},
{3},
{3},
{3},
{3},
{3},
{18},
{1},
{3},
{2},
{3},
{3},
{3},
{3},
{3},
{3},
{3},
{3},
{17},
{17},
{5},
{5},
{17},
{7},
{5},
{2},
{10},
{10},
{7},
{1},
{1},
{1},
{1},
{1},
{3},
{5},
{1},
{1},
{7},
{2},
{10},
{1},
{2},
{1},
{10},
{3},
{10},
{1},
{2},
{2},
{2},
{18},
{18},
{3},
{5},
{2},
{5},
{1},
{10},
{14},
{14},
{12},
{14},
{17},
{18},
{16},
{5},
{6},
{9},
{10},
{17},
{16},
{15},
{1},
{1},
{3},
{2},
{1},
{5},
{15},
{15},
{15},
{12},
{0},
{0},
{0},
{18},
{0},
{0},
{0},
{0},
{2},
{5},
{5},
{4},
{4},
{4},
{4},
{0},
{4},
{10},
{1},
{0},
{0},
{4},
{12},
{6},
{12},
{4},
{6},
{6},
{14},
{4},
{5},
{5},
{3},
{14},
{16},
{6},
{6},
{6},
{6},
{6},
{15},
{6},
{6},
{2},
{6},
{8},
{9},
{1},
{1},
{2},
{3},
{8},
{0},
{9},
{10},
{11},
{8},
{11},
{9},
{9},
{0},
{0}
};

new IntName[146][] = {
"Four Dragons Managerial Suite",
"Ganton Gym",
"Brothel",
"Brothel2",
"Inside Track Betting",
"Blastin  Fools Records",
"The Big Spread Ranch",
"Warehouse1 ",
"Warehouse2 ",
"B Dup s Apartment",
"B Dup s Crack Palace",
"Wheel Arch Angels",
"OG Loc s House",
"Barber Shop",
"Planning Department",
"Las Venturas Police Department",
"Pro-Laps",
"Sex Shop",
"Las Venturas Tattoo parlor",
"Lost San Fierro Tattoo",
"24/07/09 (version 1)",
"Diner1 ",
"Pizza Stack",
"Rusty Brown s Donuts",
"Ammu-nation",
"Victim",
"Loco Low Co",
"San Fierro Police Department",
"24/07/09 (version 2)",
"Below The Belt Gym",
"Transfenders",
"World of Coq",
"Ammu-nation (version 2)",
"SubUrban",
"Denise s Bedroom",
"Helena s Barn",
"Barbara s Love nest",
"San Fierro Garage",
"Oval Stadium",
"8-Track Stadium",
"The Pig Pen (strip",
"Four Dragons",
"Liberty City",
"Ryder s house",
"Sweet s House",
"RC Battlefield",
"The Johnson House",
"Burger shot",
"Caligula s Casino",
"Katie s Lovenest",
"Barber Shop2 (Reece s)",
"Angel Pine Trailer",
"24/07/09 (version 3)",
"Zip",
"The Pleasure Domes",
"Madd Dogg s Mansion",
"Big Smoke s Crack Palace",
"Burning Desire Building",
"Wu-Zi Mu s",
"Abandoned AC tower",
"Wardrobe/Changing room",
"Didier Sachs",
"Casino (Redsands West)",
"Kickstart Stadium",
"Club",
"Atrium",
"Los Santos Tattoo Parlor",
"Safe House group1 ",
"Safe House group2 ",
"Safe House group3 ",
"Safe House group4 ",
"Sherman Dam",
"24/07/09 (version 4)",
"Jefferson Motel",
"Jet Interior",
"The Welcome Pump",
"Burglary House X1",
"Burglary House X2",
"Burglary House X3",
"Burglary House X4",
"Binco",
"4 Burglary houses",
"Blood Bowl Stadium",
"Budget Inn Motel Room",
"Palamino Bank",
"Palamino Diner",
"Dillimore Gas Station",
"Lil  Probe Inn",
"Torreno s Ranch",
"Zombotech - lobby area",
"Crypt in LS cemetery",
"Blueberry Liquor Store",
"Pair of Burglary Houses",
"Crack Den",
"Burglary House X11",
"Burglary House X12",
"Ammu-nation (version 3)",
"Jay s Diner",
"24/07/09 (version 5)",
"Warehouse3 ",
"Michelle s Love Nest*",
"Burglary House X14",
"Sindacco Abatoir",
"K.A.C.C. Military Fuels Depot",
"Area69 ",
"Burglary House X13",
"Unused Safe House",
"Millie s Bedroom",
"Barber Shop",
"Dirtbike Stadium",
"Cobra Gym",
"Los Santos Police Department",
"Los Santos Airport",
"Burglary House X15",
"Burglary House X16",
"Burglary House X17",
"Bike School",
"Francis International Airport",
"Vice Stadium",
"Burglary House X18",
"Burglary House X19",
"Zero s RC Shop",
"Ammu-nation (version 4)",
"Ammu-nation (version 5)",
"Burglary House X20",
"24/07/09 (version 6)",
"Secret Valley Diner",
"Rosenberg s Office in Caligulas",
"Fanny Batter s Whore House",
"Colonel Furhberger s",
"Cluckin  Bell",
"The Camel s Toe Safehouse",
"Caligula s Roof",
"Old Venturas Strip Casino",
"Driving School",
"Verdant Bluffs Safehouse",
"Bike School",
"Andromada",
"Four Dragons  Janitor s Office",
"Bar",
"Burglary House X21",
"Willowfield Safehouse",
"Burglary House X22",
"Burglary House X23",
"Otto s Autos",
"Wang Cars"
};

enum P_ACCOUNT_DATA
{
	pDBID,
	bool:pLoggedin,

	pAdmin,
	bool:pAdminDuty,

	pLastSkin,

	pLevel,
	pEXP,

	Float: pLastPos[3],
	pLastInterior,
	pLastWorld,

	pAge[20],
	pOrigin[60],

	pStory[60],
	pStoryTwo[60],

	pMoney,
	pBank,
	pPaycheck,

	pPhone,
	bool:pPhoneOff,
	bool:pPhonespeaker,

	pPhoneline,
	pCalling,

//	pActiveIP[60],
	pLastOnline[90],
	pLastOnlineTime,

	bool:pAdminjailed,
	pAdminjailTime,

	bool:pOfflinejailed,
	pOfflinejailedReason[128],

	bool:pMuted,
	pSpectating,

	pFaction,
	pFactionRank,
	bool:pFactionChat,
	pFactionInvite,
	pFactionInvitedBy,

	pOwnedVehicles[MAX_PLAYER_VEHICLES],
	pDuplicateKey,

	bool:pWeaponsSpawned,
	pWeaponsImmune,
	pWeapons[12],
	pWeaponsAmmo[12],

	bool:pUnscrambling,
	pUnscramblerTime,
	pUnscrambleTimer,
	pUnscrambleID,
	pScrambleSuccess,
	pScrambleFailed,

	bool:pPoliceDuty,
	bool:pMedicDuty,

	pTimeplayed,

	pInsideProperty,
	pInsideBusiness,
	pAtDealership,

	pMaskID[2],
	bool:pMasked,

	pLastDamagetime,

	bool:pRelogging,
	pRelogCount,
	Text3D:pRelogTD,
	pRelogTimer,

	pPauseCheck,
	pPauseTime,

	pAddObject,
	pEditingObject,

	pHandcuffed,

	pGascan,
	bool:pHasMask,

	bool:pHasRadio,
	pRadio[3],
	pMainSlot,

	pRespawnTime,
	pDeathFix,

	pSpawnPoint,
	pSpawnPointHouse,

	bool:pTaser,

	pWeaponsLicense,
	pDriversLicense,
	pFishingRod,
	pWorms,
	pFishes,
	pIsAlive,
	pJob,
	Float:pHealth,
    Float:pArmour,

	pActiveListings,
	pInJail,
	pJailTime,
	pPrisonTimes,
	pJailTimes,
	pCheckpoints,
	pWorking,
	pSmuggling,
	pCarry,
	pCharPass,
	pExplosives,
	pRobbedCash,
	pTimeRobbed[90],
	pRobTime,
	pRobbing
}

new PlayerInfo[MAX_PLAYERS][P_ACCOUNT_DATA];


new registerTime[MAX_PLAYERS], loginTime[MAX_PLAYERS], characterPickTime[MAX_PLAYERS];
new playerLastpay[MAX_PLAYERS], playerTaserAmmo[MAX_PLAYERS];

new
	PlayerCheckpoint[MAX_PLAYERS],
	playerWeaponsSave[MAX_PLAYERS][4],
	playerWeaponsAmmoSave[MAX_PLAYERS][4];

new
	bool:playerTextdraw[MAX_PLAYERS],
	Text3D:playerVehicleTextdraw[MAX_PLAYERS];

enum G_REPORT_INFO
{
	bool:rReportExists,
	rReportDetails[90],
	rReportTime,
	rReportBy[32]
}

new ReportInfo[100][G_REPORT_INFO];
new playerReport[MAX_PLAYERS][128];

enum E_FACTION_INFO
{
	eFactionDBID,

	eFactionName[90],
	eFactionAbbrev[30],

	Float: eFactionSpawn[3],
	eFactionSpawnInt,
	eFactionSpawnWorld,

	eFactionJoinRank,
	eFactionAlterRank,
	eFactionChatRank,
	eFactionTowRank,

	bool:eFactionChatStatus,
	eFactionChatColor,

	eFactionType
}

new FactionInfo[MAX_FACTIONS][E_FACTION_INFO];
new FactionRanks[MAX_FACTIONS][MAX_FACTION_RANKS][60];
new playerEditingRank[MAX_PLAYERS];

enum E_VEHICLE_SYSTEM
{
	eVehicleDBID,
	bool:eVehicleExists,

	eVehicleOwnerDBID,
	eVehicleFaction,
	eVehicleStash, //Smuggle Stash

	eVehicleID,
	eVehicleModel,
	eVehicleColor1,
	eVehicleColor2,
	eVehiclePaintjob,

	Float:eVehicleParkPos[4],
	eVehicleParkInterior,
	eVehicleParkWorld,

	eVehiclePlates[32],
	bool:eVehicleLocked,

	bool:eVehicleImpounded,
	Float:eVehicleImpoundPos[4],

	eVehicleWeapons[6], //5;
	eVehicleWeaponsAmmo[6], //5;

	Float:eVehicleFuel,
	eVehicleSirens,

	eVehicleLastDrivers[5], //4;
	eVehicleLastPassengers[5], //4;

	bool:eVehicleLights,
	bool:eVehicleEngineStatus,

	bool:eVehicleAdminSpawn,

	Text3D:eVehicleTowDisplay,
	eVehicleTowCount,

	bool:eVehicleHasXMR,
	bool:eVehicleXMROn,
	eVehicleXMRURL[128],

	Float:eVehicleBattery,
	Float:eVehicleEngine,
	eVehicleTimesDestroyed,

	eVehicleLockLevel,
	eVehicleAlarmLevel,
	eVehicleImmobLevel,

	Text3D:eVehicleEnterTD,
	eVehicleEnterTimer,

	bool:eVehicleHasCarsign,
	Text3D:eVehicleCarsign,

	eVehicleRefillCount,
	Text3D:eVehicleRefillDisplay
}

new VehicleInfo[MAX_VEHICLES][E_VEHICLE_SYSTEM];

new
	lastVehicleSpawn[MAX_PLAYERS],
	bool:playerTowingVehicle[MAX_PLAYERS],
	playerTowTimer[MAX_PLAYERS]
;

new playerInsertID[MAX_PLAYERS];

new playerRefillingVehicle[MAX_PLAYERS], playerRefillTimer[MAX_PLAYERS];

enum E_UNSCRAMBLER_DATA
{
	eUnscrambleLevel,
	eScrambledWord[60],
	eUnscrambledWord[60]
}

new UnscrambleInfo[][E_UNSCRAMBLER_DATA] =
{
	{1, "Nwe", "New"},
  {2, "Relseea", "Release"},
  {3, "Scritp", "Script"}
  //The values are the immobiliser level the word will show for.
  //I recommend having them equally the same amount. Up to you.
  // /unscramble usage.
};

enum E_DROPPEDGUN_DATA
{
	bool:eWeaponDropped,
	eWeaponObject,
	eWeaponTimer,

	eWeaponWepID,
	eWeaponWepAmmo,

	Float:eWeaponPos[3],
	eWeaponInterior,
	eWeaponWorld,

	eWeaponDroppedBy
}

new WeaponDropInfo[200][E_DROPPEDGUN_DATA];

enum E_PROPERTY_DATA
{
	ePropertyDBID,
	ePropertyOwnerDBID,

	ePropertyType,
	ePropertyFaction,

	Float:ePropertyEntrance[3],
	ePropertyEntranceInterior,
	ePropertyEntranceWorld,

	Float:ePropertyInterior[3],
	ePropertyInteriorIntID,
	ePropertyInteriorWorld,

	ePropertyMarketPrice,
	ePropertyAdress[90],
	ePropertyLevel,
	ePropertyPickup,
	Text3D:ePropertyTag,

	bool:ePropertyLocked,

	ePropertyCashbox,
	ePropertyWeapons[21],
	ePropertyWeaponsAmmo[21],

	Float:ePropertyPlacePos[3],

	bool:ePropertyHasBoombox,
	ePropertyBoomboxObject,

	Float: ePropertyBoomboxPos[3],
	Float: ePropertyBoomboxRot[3],

	bool:ePropertyBoomboxOn,
	ePropertyBoomboxURL
}

new PropertyInfo[MAX_PROPERTY][E_PROPERTY_DATA];

enum E_XMR_CATEGORY_DATA
{
	eXMRID,
	eXMRCategoryName[90]
}

enum E_XMR_CATEGORY_STATIONS_DATA
{
	eXMRStationID,
	eXMRCategory,

	eXMRStationName[90],
	eXMRStationURL[128]
}

new XMRCategoryInfo[MAX_XMR_CATEGORY][E_XMR_CATEGORY_DATA];
new XMRStationInfo[MAX_XMR_CATEGORY_STATIONS][E_XMR_CATEGORY_STATIONS_DATA];

new CatXMRHolder[MAX_PLAYERS], SubXMRHolder[MAX_PLAYERS];
new SubXMRHolderArr[MAX_PLAYERS][MAX_XMR_CATEGORY];

enum E_BUSINESS_DATA
{
	eBusinessDBID,
	eBusinessOwnerDBID,

	Float:eBusinessInterior[3],
	eBusinessInteriorWorld,
	eBusinessInteriorIntID,
	eBusinessInteriorExtWorld,
	eBusinessInteriorExtIntID,

	Float:eBusinessEntrance[3],

	eBusinessName[90],

	eBusinessType,
	eBusinessPickup,

	bool:eBusinessLocked,
	eBusinessEntranceFee,

	eBusinessLevel,
	eBusinessMarketPrice,

	eBusinessCashbox,
	eBusinessProducts,

	eBusinessBankPickup,
	Float:eBusinessBankPickupLoc[3],
	eBusinessBankPickupWorld,
	eRobbed
}

new BusinessInfo[MAX_BUSINESS][E_BUSINESS_DATA];

enum E_DEALERSHIP_DATA
{
	eDealershipType,
	eDealershipCategory,

	eDealershipModel[128],
	eDealershipModelID,

	eDealershipPrice
}

new CatDealershipHolder[MAX_PLAYERS], SubDealershipHolder[MAX_PLAYERS];
new SubDealershipHolderArr[MAX_PLAYERS][200];

new DealershipPlayerCar[MAX_PLAYERS], DealershipTotalCost[MAX_PLAYERS];
new DealershipAlarmLevel[MAX_PLAYERS], DealershipImmobLevel[MAX_PLAYERS];
new DealershipLockLevel[MAX_PLAYERS], DealershipXMR[MAX_PLAYERS];
new DealershipCarColors[MAX_PLAYERS][2], bool:PlayerPurchasingVehicle[MAX_PLAYERS];

enum
{
	DEALERSHIP_CATEGORY_AIRCRAFTS,
	DEALERSHIP_CATEGORY_BOATS,
	DEALERSHIP_CATEGORY_BIKES,
	DEALERSHIP_CATEGORY_TWODOOR,
	DEALERSHIP_CATEGORY_FOURDOOR,
	DEALERSHIP_CATEGORY_CIVIL,
	DEALERSHIP_CATEGORY_HEAVY,
	DEALERSHIP_CATEGORY_VANS,
	DEALERSHIP_CATEGORY_SUV,
	DEALERSHIP_CATEGORY_MUSCLE,
	DEALERSHIP_CATEGORY_RACERS
}

new g_aDealershipData[][E_DEALERSHIP_DATA] = {
 {0, DEALERSHIP_CATEGORY_AIRCRAFTS, "Maverick", 487, 4000000},
	{1, DEALERSHIP_CATEGORY_BOATS, "Squallo", 446, 500000},
	{1, DEALERSHIP_CATEGORY_BOATS, "Reefer", 453, 500000},
	{1, DEALERSHIP_CATEGORY_BOATS, "Tropic", 454, 500000},
	{1, DEALERSHIP_CATEGORY_BOATS, "Dinghy", 473, 500000},
	{2, DEALERSHIP_CATEGORY_BIKES, "Bike", 509, 2000},
	{2, DEALERSHIP_CATEGORY_BIKES, "BMX", 481, 3000},
	{2, DEALERSHIP_CATEGORY_BIKES, "Mountain Bike", 510, 6000},
	{2, DEALERSHIP_CATEGORY_BIKES, "Faggio", 462, 25000},
	{2, DEALERSHIP_CATEGORY_BIKES, "FCR-900", 521, 75000},
	{2, DEALERSHIP_CATEGORY_BIKES, "Freeway", 463, 90000},
	{2, DEALERSHIP_CATEGORY_BIKES, "Sanchez", 468, 80000},
	{2, DEALERSHIP_CATEGORY_BIKES, "Wayfarer", 586, 300000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Alpha", 602, 4000000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Blista Compact", 496, 250000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Bravura", 401, 120000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Buccaneer", 518, 110000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Cadrona", 527, 110000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Club", 589, 1000000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Esperanto", 419, 110000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Euros", 587, 300000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Feltzer", 533, 150000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Fortune", 526, 110000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Hermes", 474, 150000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Hustler", 545, 300000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Majestic", 517, 100000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Manana", 410, 90000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Picador", 600, 120000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Previon", 436, 95000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Stallion", 439, 130000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Tampa", 549, 145000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Virgo", 491, 130000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Blade", 536, 140000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Broadway", 575, 200000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Remington", 534, 120000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Slamvan", 535, 210000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Tornado", 576, 160000},
	{3, DEALERSHIP_CATEGORY_TWODOOR, "Voodoo", 412, 140000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Admiral", 445, 115000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Glendale", 604, 125000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Elegant", 507, 100000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Greenwood", 492, 110000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Intruder", 546, 115000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Merit", 551, 110000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Nebula", 516, 112000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Oceanic", 467, 130000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Premier", 426, 130000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Primo", 547, 120000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Sentinel", 405, 118000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Stafford", 580, 275000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Stretch", 409, 800000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Sunrise", 550, 105000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Tahoma", 566, 115000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Vincent", 540, 125000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Washington", 421, 120000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Willard", 529, 130000},
	{4, DEALERSHIP_CATEGORY_FOURDOOR, "Savanna", 567, 180000},
	{5, DEALERSHIP_CATEGORY_CIVIL, "Bus", 431, 2000000},
	{5, DEALERSHIP_CATEGORY_CIVIL, "Cabbie", 438, 5000000},
	{5, DEALERSHIP_CATEGORY_CIVIL, "Taxi", 420, 5000000},
	{5, DEALERSHIP_CATEGORY_CIVIL, "Towtruck", 525, 5000000},
	{5, DEALERSHIP_CATEGORY_CIVIL, "Trashmaster", 408, 5000000},
	{6, DEALERSHIP_CATEGORY_HEAVY, "Benson", 499, 5000000},
	{6, DEALERSHIP_CATEGORY_HEAVY, "Boxville", 609, 5000000},
	{6, DEALERSHIP_CATEGORY_HEAVY, "Combine Harvester", 532, 5000000},
	{6, DEALERSHIP_CATEGORY_HEAVY, "DFT-30", 578, 5000000},
	{6, DEALERSHIP_CATEGORY_HEAVY, "Hotdog Truck", 588, 250000},
	{6, DEALERSHIP_CATEGORY_HEAVY, "Linerunner", 403, 5000000},
	{6, DEALERSHIP_CATEGORY_HEAVY, "Mr. Whoopee", 423, 5000000},
	{6, DEALERSHIP_CATEGORY_HEAVY, "Mule", 414, 5000000},
	{6, DEALERSHIP_CATEGORY_HEAVY, "Packer", 443, 5000000},
	{6, DEALERSHIP_CATEGORY_HEAVY, "Roadtrain", 515, 5000000},
	{6, DEALERSHIP_CATEGORY_HEAVY, "Tanker", 514, 5000000},
	{6, DEALERSHIP_CATEGORY_HEAVY, "Yankee", 456, 5000000},
	{7, DEALERSHIP_CATEGORY_VANS, "Berkley's RC Van", 459, 5000000},
	{7, DEALERSHIP_CATEGORY_VANS, "Bobcat", 422, 100000},
	{7, DEALERSHIP_CATEGORY_VANS, "Burrito", 482, 175000},
	{7, DEALERSHIP_CATEGORY_VANS, "Sadler", 605, 200000},
	{7, DEALERSHIP_CATEGORY_VANS, "Moonbeam", 418, 200000},
	{7, DEALERSHIP_CATEGORY_VANS, "Pony", 413, 150000},
	{7, DEALERSHIP_CATEGORY_VANS, "Rumpo", 440, 185000},
	{7, DEALERSHIP_CATEGORY_VANS, "Sadler", 543, 145000},
	{7, DEALERSHIP_CATEGORY_VANS, "Walton", 478, 150000},
	{7, DEALERSHIP_CATEGORY_VANS, "Yosemite", 554, 175000},
	{8, DEALERSHIP_CATEGORY_SUV, "Huntley", 579, 500000},
	{8, DEALERSHIP_CATEGORY_SUV, "Landstalker", 400, 400000},
	{8, DEALERSHIP_CATEGORY_SUV, "Perennial", 404, 300000},
	{8, DEALERSHIP_CATEGORY_SUV, "Rancher", 489, 500000},
	{8, DEALERSHIP_CATEGORY_SUV, "Regina", 479, 350000},
	{8, DEALERSHIP_CATEGORY_SUV, "Romero", 442, 500000},
	{8, DEALERSHIP_CATEGORY_SUV, "Solair", 458, 300000},
	{9, DEALERSHIP_CATEGORY_MUSCLE, "Buffalo", 402, 4000000},
	{9, DEALERSHIP_CATEGORY_MUSCLE, "Clover", 542, 200000},
	{9, DEALERSHIP_CATEGORY_MUSCLE, "Phoenix", 603, 4000000},
	{9, DEALERSHIP_CATEGORY_MUSCLE, "Sabre", 475, 500000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Banshee", 429, 4000000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Bullet", 541, 4000000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Cheetah", 415, 4000000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Comet", 480, 1500000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Elegy", 562, 4000000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Flash", 565, 4000000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Jester", 559, 4000000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Stratum", 561, 1500000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Sultan", 560, 4000000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Super GT", 506, 4000000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Uranus", 558, 1000000},
	{10, DEALERSHIP_CATEGORY_RACERS, "Windsor", 555, 1200000},
	{10, DEALERSHIP_CATEGORY_RACERS, "ZR-350", 477, 2500000}
};

enum E_DAMAGE_INFO
{
	eDamageTaken,
	eDamageTime,

	eDamageWeapon,

	eDamageBodypart,
	eDamageArmor,

	eDamageBy
}

new DamageInfo[MAX_PLAYERS][100][E_DAMAGE_INFO];
new TotalPlayerDamages[MAX_PLAYERS];

enum E_SAZONE_MAIN
{
    SAZONE_NAME[28],
    Float:SAZONE_AREA[6]
}

//
static const VehicleColoursTableRGBA[256] =
{
	0x000000FF, 0xF5F5F5FF, 0x2A77A1FF, 0x840410FF, 0x263739FF, 0x86446EFF, 0xD78E10FF, 0x4C75B7FF, 0xBDBEC6FF, 0x5E7072FF,
	0x46597AFF, 0x656A79FF, 0x5D7E8DFF, 0x58595AFF, 0xD6DAD6FF, 0x9CA1A3FF, 0x335F3FFF, 0x730E1AFF, 0x7B0A2AFF, 0x9F9D94FF,
	0x3B4E78FF, 0x732E3EFF, 0x691E3BFF, 0x96918CFF, 0x515459FF, 0x3F3E45FF, 0xA5A9A7FF, 0x635C5AFF, 0x3D4A68FF, 0x979592FF,
	0x421F21FF, 0x5F272BFF, 0x8494ABFF, 0x767B7CFF, 0x646464FF, 0x5A5752FF, 0x252527FF, 0x2D3A35FF, 0x93A396FF, 0x6D7A88FF,
	0x221918FF, 0x6F675FFF, 0x7C1C2AFF, 0x5F0A15FF, 0x193826FF, 0x5D1B20FF, 0x9D9872FF, 0x7A7560FF, 0x989586FF, 0xADB0B0FF,
	0x848988FF, 0x304F45FF, 0x4D6268FF, 0x162248FF, 0x272F4BFF, 0x7D6256FF, 0x9EA4ABFF, 0x9C8D71FF, 0x6D1822FF, 0x4E6881FF,
	0x9C9C98FF, 0x917347FF, 0x661C26FF, 0x949D9FFF, 0xA4A7A5FF, 0x8E8C46FF, 0x341A1EFF, 0x6A7A8CFF, 0xAAAD8EFF, 0xAB988FFF,
	0x851F2EFF, 0x6F8297FF, 0x585853FF, 0x9AA790FF, 0x601A23FF, 0x20202CFF, 0xA4A096FF, 0xAA9D84FF, 0x78222BFF, 0x0E316DFF,
	0x722A3FFF, 0x7B715EFF, 0x741D28FF, 0x1E2E32FF, 0x4D322FFF, 0x7C1B44FF, 0x2E5B20FF, 0x395A83FF, 0x6D2837FF, 0xA7A28FFF,
	0xAFB1B1FF, 0x364155FF, 0x6D6C6EFF, 0x0F6A89FF, 0x204B6BFF, 0x2B3E57FF, 0x9B9F9DFF, 0x6C8495FF, 0x4D8495FF, 0xAE9B7FFF,
	0x406C8FFF, 0x1F253BFF, 0xAB9276FF, 0x134573FF, 0x96816CFF, 0x64686AFF, 0x105082FF, 0xA19983FF, 0x385694FF, 0x525661FF,
	0x7F6956FF, 0x8C929AFF, 0x596E87FF, 0x473532FF, 0x44624FFF, 0x730A27FF, 0x223457FF, 0x640D1BFF, 0xA3ADC6FF, 0x695853FF,
	0x9B8B80FF, 0x620B1CFF, 0x5B5D5EFF, 0x624428FF, 0x731827FF, 0x1B376DFF, 0xEC6AAEFF, 0x000000FF,
	0x177517FF, 0x210606FF, 0x125478FF, 0x452A0DFF, 0x571E1EFF, 0x010701FF, 0x25225AFF, 0x2C89AAFF, 0x8A4DBDFF, 0x35963AFF,
	0xB7B7B7FF, 0x464C8DFF, 0x84888CFF, 0x817867FF, 0x817A26FF, 0x6A506FFF, 0x583E6FFF, 0x8CB972FF, 0x824F78FF, 0x6D276AFF,
	0x1E1D13FF, 0x1E1306FF, 0x1F2518FF, 0x2C4531FF, 0x1E4C99FF, 0x2E5F43FF, 0x1E9948FF, 0x1E9999FF, 0x999976FF, 0x7C8499FF,
	0x992E1EFF, 0x2C1E08FF, 0x142407FF, 0x993E4DFF, 0x1E4C99FF, 0x198181FF, 0x1A292AFF, 0x16616FFF, 0x1B6687FF, 0x6C3F99FF,
	0x481A0EFF, 0x7A7399FF, 0x746D99FF, 0x53387EFF, 0x222407FF, 0x3E190CFF, 0x46210EFF, 0x991E1EFF, 0x8D4C8DFF, 0x805B80FF,
	0x7B3E7EFF, 0x3C1737FF, 0x733517FF, 0x781818FF, 0x83341AFF, 0x8E2F1CFF, 0x7E3E53FF, 0x7C6D7CFF, 0x020C02FF, 0x072407FF,
	0x163012FF, 0x16301BFF, 0x642B4FFF, 0x368452FF, 0x999590FF, 0x818D96FF, 0x99991EFF, 0x7F994CFF, 0x839292FF, 0x788222FF,
	0x2B3C99FF, 0x3A3A0BFF, 0x8A794EFF, 0x0E1F49FF, 0x15371CFF, 0x15273AFF, 0x375775FF, 0x060820FF, 0x071326FF, 0x20394BFF,
	0x2C5089FF, 0x15426CFF, 0x103250FF, 0x241663FF, 0x692015FF, 0x8C8D94FF, 0x516013FF, 0x090F02FF, 0x8C573AFF, 0x52888EFF,
	0x995C52FF, 0x99581EFF, 0x993A63FF, 0x998F4EFF, 0x99311EFF, 0x0D1842FF, 0x521E1EFF, 0x42420DFF, 0x4C991EFF, 0x082A1DFF,
	0x96821DFF, 0x197F19FF, 0x3B141FFF, 0x745217FF, 0x893F8DFF, 0x7E1A6CFF, 0x0B370BFF, 0x27450DFF, 0x071F24FF, 0x784573FF,
	0x8A653AFF, 0x732617FF, 0x319490FF, 0x56941DFF, 0x59163DFF, 0x1B8A2FFF, 0x38160BFF, 0x041804FF, 0x355D8EFF, 0x2E3F5BFF,
	0x561A28FF, 0x4E0E27FF, 0x706C67FF, 0x3B3E42FF, 0x2E2D33FF, 0x7B7E7DFF, 0x4A4442FF, 0x28344EFF
};

static const g_aDealershipCategory[][] = {
	{"Aircrafts"},
	{"Boats"},
	{"Bikes"},
	{"2-Door & Compact cars"},
	{"4-Door & Luxury cars"},
	{"Civil Service"},
	{"Heavy & Utility Trucks"},
	{"Light trucks & Vans"},
	{"SUVs & Wagons"},
	{"Muscle Cars"},
	{"Street Racers"}
};

static const s_TopSpeed[212] = {
    157, 147, 186, 110, 133, 164, 110, 148, 100, 158, 129, 221, 168, 110, 105, 192, 154, 270,
    115, 149, 145, 154, 140, 99, 135, 270, 173, 165, 157, 201, 190, 130, 94, 110, 167, 0, 149,
    158, 142, 168, 136, 145, 139, 126, 110, 164, 270, 270, 111, 0, 0, 193, 270, 60, 135, 157,
    106, 95, 157, 136, 270, 160, 111, 142, 145, 145, 147, 140, 144, 270, 157, 110, 190, 190,
    149, 173, 270, 186, 117, 140, 184, 73, 156, 122, 190, 99, 64, 270, 270, 139, 157, 149, 140,
    270, 214, 176, 162, 270, 108, 123, 140, 145, 216, 216, 173, 140, 179, 166, 108, 79, 101, 270,
    270, 270, 120, 142, 157, 157, 164, 270, 270, 160, 176, 151, 130, 160, 158, 149, 176, 149, 60,
    70, 110, 167, 168, 158, 173, 0, 0, 270, 149, 203, 164, 151, 150, 147, 149, 142, 270, 153, 145,
    157, 121, 270, 144, 158, 113, 113, 156, 178, 169, 154, 178, 270, 145, 165, 160, 173, 146, 0, 0,
    93, 60, 110, 60, 158, 158, 270, 130, 158, 153, 151, 136, 85, 0, 153, 142, 165, 108, 162, 0, 0,
    270, 270, 130, 190, 175, 175, 175, 158, 151, 110, 169, 171, 148, 152, 0, 0, 0, 108, 0, 0
}; //Credits to Emmet (Extended Vehicle function)

new possibleVehiclePlates[][] =
	{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};

static const g_aPreloadLibs[][] =
{
	"AIRPORT",      "ATTRACTORS",   "BAR",          "BASEBALL",     "BD_FIRE",
	"BEACH",        "BENCHPRESS",   "BF_INJECTION", "BIKE_DBZ",     "BIKED",
	"BIKEH",        "BIKELEAP",     "BIKES",        "BIKEV",        "BLOWJOBZ",
	"BMX",          "BOMBER",       "BOX",          "BSKTBALL",     "BUDDY",
	"BUS",          "CAMERA",       "CAR",          "CAR_CHAT",     "CARRY",
	"CASINO",       "CHAINSAW",     "CHOPPA",       "CLOTHES",      "COACH",
	"COLT45",       "COP_AMBIENT",  "COP_DVBYZ",    "CRACK",        "CRIB",
	"DAM_JUMP",     "DANCING",      "DEALER",       "DILDO",        "DODGE",
	"DOZER",        "DRIVEBYS",     "FAT",          "FIGHT_B",      "FIGHT_C",
	"FIGHT_D",      "FIGHT_E",      "FINALE",       "FINALE2",      "FLAME",
	"FLOWERS",      "FOOD",         "FREEWEIGHTS",  "GANGS",        "GFUNK",
	"GHANDS",       "GHETTO_DB",    "GOGGLES",      "GRAFFITI",     "GRAVEYARD",
	"GRENADE",      "GYMNASIUM",    "HAIRCUTS",     "HEIST9",       "INT_HOUSE",
	"INT_OFFICE",   "INT_SHOP",     "JST_BUISNESS", "KART",         "KISSING",
	"KNIFE",        "LAPDAN1",      "LAPDAN2",      "LAPDAN3",      "LOWRIDER",
	"MD_CHASE",     "MD_END",       "MEDIC",        "MISC",         "MTB",
	"MUSCULAR",     "NEVADA",       "ON_LOOKERS",   "OTB",          "PARACHUTE",
	"PARK",         "PAULNMAC",     "PED",          "PLAYER_DVBYS", "PLAYIDLES",
	"POLICE",       "POOL",         "POOR",         "PYTHON",       "QUAD",
	"QUAD_DBZ",     "RAPPING",      "RIFLE",        "RIOT",         "ROB_BANK",
	"ROCKET",       "RUNNINGMAN",   "RUSTLER",      "RYDER",        "SCRATCHING",
	"SEX",          "SHAMAL",       "SHOP",         "SHOTGUN",      "SILENCED",
	"SKATE",        "SMOKING",      "SNIPER",       "SNM",          "SPRAYCAN",
	"STRIP",        "SUNBATHE",     "SWAT",         "SWEET",        "SWIM",
	"SWORD",        "TANK",         "TATTOOS",      "TEC",          "TRAIN",
	"TRUCK",        "UZI",          "VAN",          "VENDING",      "VORTEX",
	"WAYFARER",     "WEAPONS",      "WOP",          "WUZI"
};

static const gSAZones[][E_SAZONE_MAIN] = {  // Majority of names and area coordinates adopted from Mabako's 'Zones Script' v0.2
        //      NAME                            AREA (Xmin,Ymin,Zmin,Xmax,Ymax,Zmax)
        {"The Big Ear",                 {-410.00,1403.30,-3.00,-137.90,1681.20,200.00}},
        {"Aldea Malvada",               {-1372.10,2498.50,0.00,-1277.50,2615.30,200.00}},
        {"Angel Pine",                  {-2324.90,-2584.20,-6.10,-1964.20,-2212.10,200.00}},
        {"Arco del Oeste",              {-901.10,2221.80,0.00,-592.00,2571.90,200.00}},
        {"Avispa Country Club",         {-2646.40,-355.40,0.00,-2270.00,-222.50,200.00}},
        {"Avispa Country Club",         {-2831.80,-430.20,-6.10,-2646.40,-222.50,200.00}},
        {"Avispa Country Club",         {-2361.50,-417.10,0.00,-2270.00,-355.40,200.00}},
        {"Avispa Country Club",         {-2667.80,-302.10,-28.80,-2646.40,-262.30,71.10}},
        {"Avispa Country Club",         {-2470.00,-355.40,0.00,-2270.00,-318.40,46.10}},
        {"Avispa Country Club",         {-2550.00,-355.40,0.00,-2470.00,-318.40,39.70}},
        {"Back o Beyond",               {-1166.90,-2641.10,0.00,-321.70,-1856.00,200.00}},
        {"Battery Point",               {-2741.00,1268.40,-4.50,-2533.00,1490.40,200.00}},
        {"Bayside",                     {-2741.00,2175.10,0.00,-2353.10,2722.70,200.00}},
        {"Bayside Marina",              {-2353.10,2275.70,0.00,-2153.10,2475.70,200.00}},
        {"Beacon Hill",                 {-399.60,-1075.50,-1.40,-319.00,-977.50,198.50}},
        {"Blackfield",                  {964.30,1203.20,-89.00,1197.30,1403.20,110.90}},
        {"Blackfield",                  {964.30,1403.20,-89.00,1197.30,1726.20,110.90}},
        {"Blackfield Chapel",           {1375.60,596.30,-89.00,1558.00,823.20,110.90}},
        {"Blackfield Chapel",           {1325.60,596.30,-89.00,1375.60,795.00,110.90}},
        {"Blackfield Intersection",     {1197.30,1044.60,-89.00,1277.00,1163.30,110.90}},
        {"Blackfield Intersection",     {1166.50,795.00,-89.00,1375.60,1044.60,110.90}},
        {"Blackfield Intersection",     {1277.00,1044.60,-89.00,1315.30,1087.60,110.90}},
        {"Blackfield Intersection",     {1375.60,823.20,-89.00,1457.30,919.40,110.90}},
        {"Blueberry",                   {104.50,-220.10,2.30,349.60,152.20,200.00}},
        {"Blueberry",                   {19.60,-404.10,3.80,349.60,-220.10,200.00}},
        {"Blueberry Acres",             {-319.60,-220.10,0.00,104.50,293.30,200.00}},
        {"Caligula's Palace",           {2087.30,1543.20,-89.00,2437.30,1703.20,110.90}},
        {"Caligula's Palace",           {2137.40,1703.20,-89.00,2437.30,1783.20,110.90}},
        {"Calton Heights",              {-2274.10,744.10,-6.10,-1982.30,1358.90,200.00}},
        {"Chinatown",                   {-2274.10,578.30,-7.60,-2078.60,744.10,200.00}},
        {"City Hall",                   {-2867.80,277.40,-9.10,-2593.40,458.40,200.00}},
        {"Come-A-Lot",                  {2087.30,943.20,-89.00,2623.10,1203.20,110.90}},
        {"Commerce",                    {1323.90,-1842.20,-89.00,1701.90,-1722.20,110.90}},
        {"Commerce",                    {1323.90,-1722.20,-89.00,1440.90,-1577.50,110.90}},
        {"Commerce",                    {1370.80,-1577.50,-89.00,1463.90,-1384.90,110.90}},
        {"Commerce",                    {1463.90,-1577.50,-89.00,1667.90,-1430.80,110.90}},
        {"Commerce",                    {1583.50,-1722.20,-89.00,1758.90,-1577.50,110.90}},
        {"Commerce",                    {1667.90,-1577.50,-89.00,1812.60,-1430.80,110.90}},
        {"Conference Center",           {1046.10,-1804.20,-89.00,1323.90,-1722.20,110.90}},
        {"Conference Center",           {1073.20,-1842.20,-89.00,1323.90,-1804.20,110.90}},
        {"Cranberry Station",           {-2007.80,56.30,0.00,-1922.00,224.70,100.00}},
        {"Creek",                       {2749.90,1937.20,-89.00,2921.60,2669.70,110.90}},
        {"Dillimore",                   {580.70,-674.80,-9.50,861.00,-404.70,200.00}},
        {"Doherty",                     {-2270.00,-324.10,-0.00,-1794.90,-222.50,200.00}},
        {"Doherty",                     {-2173.00,-222.50,-0.00,-1794.90,265.20,200.00}},
        {"Downtown",                    {-1982.30,744.10,-6.10,-1871.70,1274.20,200.00}},
        {"Downtown",                    {-1871.70,1176.40,-4.50,-1620.30,1274.20,200.00}},
        {"Downtown",                    {-1700.00,744.20,-6.10,-1580.00,1176.50,200.00}},
        {"Downtown",                    {-1580.00,744.20,-6.10,-1499.80,1025.90,200.00}},
        {"Downtown",                    {-2078.60,578.30,-7.60,-1499.80,744.20,200.00}},
        {"Downtown",                    {-1993.20,265.20,-9.10,-1794.90,578.30,200.00}},
        {"Downtown Los Santos",         {1463.90,-1430.80,-89.00,1724.70,-1290.80,110.90}},
        {"Downtown Los Santos",         {1724.70,-1430.80,-89.00,1812.60,-1250.90,110.90}},
        {"Downtown Los Santos",         {1463.90,-1290.80,-89.00,1724.70,-1150.80,110.90}},
        {"Downtown Los Santos",         {1370.80,-1384.90,-89.00,1463.90,-1170.80,110.90}},
        {"Downtown Los Santos",         {1724.70,-1250.90,-89.00,1812.60,-1150.80,110.90}},
        {"Downtown Los Santos",         {1370.80,-1170.80,-89.00,1463.90,-1130.80,110.90}},
        {"Downtown Los Santos",         {1378.30,-1130.80,-89.00,1463.90,-1026.30,110.90}},
        {"Downtown Los Santos",         {1391.00,-1026.30,-89.00,1463.90,-926.90,110.90}},
        {"Downtown Los Santos",         {1507.50,-1385.20,110.90,1582.50,-1325.30,335.90}},
        {"East Beach",                  {2632.80,-1852.80,-89.00,2959.30,-1668.10,110.90}},
        {"East Beach",                  {2632.80,-1668.10,-89.00,2747.70,-1393.40,110.90}},
        {"East Beach",                  {2747.70,-1668.10,-89.00,2959.30,-1498.60,110.90}},
        {"East Beach",                  {2747.70,-1498.60,-89.00,2959.30,-1120.00,110.90}},
        {"East Los Santos",             {2421.00,-1628.50,-89.00,2632.80,-1454.30,110.90}},
        {"East Los Santos",             {2222.50,-1628.50,-89.00,2421.00,-1494.00,110.90}},
        {"East Los Santos",             {2266.20,-1494.00,-89.00,2381.60,-1372.00,110.90}},
        {"East Los Santos",             {2381.60,-1494.00,-89.00,2421.00,-1454.30,110.90}},
        {"East Los Santos",             {2281.40,-1372.00,-89.00,2381.60,-1135.00,110.90}},
        {"East Los Santos",             {2381.60,-1454.30,-89.00,2462.10,-1135.00,110.90}},
        {"East Los Santos",             {2462.10,-1454.30,-89.00,2581.70,-1135.00,110.90}},
        {"Easter Basin",                {-1794.90,249.90,-9.10,-1242.90,578.30,200.00}},
        {"Easter Basin",                {-1794.90,-50.00,-0.00,-1499.80,249.90,200.00}},
        {"Easter Bay Airport",          {-1499.80,-50.00,-0.00,-1242.90,249.90,200.00}},
        {"Easter Bay Airport",          {-1794.90,-730.10,-3.00,-1213.90,-50.00,200.00}},
        {"Easter Bay Airport",          {-1213.90,-730.10,0.00,-1132.80,-50.00,200.00}},
        {"Easter Bay Airport",          {-1242.90,-50.00,0.00,-1213.90,578.30,200.00}},
        {"Easter Bay Airport",          {-1213.90,-50.00,-4.50,-947.90,578.30,200.00}},
        {"Easter Bay Airport",          {-1315.40,-405.30,15.40,-1264.40,-209.50,25.40}},
        {"Easter Bay Airport",          {-1354.30,-287.30,15.40,-1315.40,-209.50,25.40}},
        {"Easter Bay Airport",          {-1490.30,-209.50,15.40,-1264.40,-148.30,25.40}},
        {"Easter Bay Chemicals",        {-1132.80,-768.00,0.00,-956.40,-578.10,200.00}},
        {"Easter Bay Chemicals",        {-1132.80,-787.30,0.00,-956.40,-768.00,200.00}},
        {"El Castillo del Diablo",      {-464.50,2217.60,0.00,-208.50,2580.30,200.00}},
        {"El Castillo del Diablo",      {-208.50,2123.00,-7.60,114.00,2337.10,200.00}},
        {"El Castillo del Diablo",      {-208.50,2337.10,0.00,8.40,2487.10,200.00}},
        {"El Corona",                   {1812.60,-2179.20,-89.00,1970.60,-1852.80,110.90}},
        {"El Corona",                   {1692.60,-2179.20,-89.00,1812.60,-1842.20,110.90}},
        {"El Quebrados",                {-1645.20,2498.50,0.00,-1372.10,2777.80,200.00}},
        {"Esplanade East",              {-1620.30,1176.50,-4.50,-1580.00,1274.20,200.00}},
        {"Esplanade East",              {-1580.00,1025.90,-6.10,-1499.80,1274.20,200.00}},
        {"Esplanade East",              {-1499.80,578.30,-79.60,-1339.80,1274.20,20.30}},
        {"Esplanade North",             {-2533.00,1358.90,-4.50,-1996.60,1501.20,200.00}},
        {"Esplanade North",             {-1996.60,1358.90,-4.50,-1524.20,1592.50,200.00}},
        {"Esplanade North",             {-1982.30,1274.20,-4.50,-1524.20,1358.90,200.00}},
        {"Fallen Tree",                 {-792.20,-698.50,-5.30,-452.40,-380.00,200.00}},
        {"Fallow Bridge",               {434.30,366.50,0.00,603.00,555.60,200.00}},
        {"Fern Ridge",                  {508.10,-139.20,0.00,1306.60,119.50,200.00}},
        {"Financial",                   {-1871.70,744.10,-6.10,-1701.30,1176.40,300.00}},
        {"Fisher's Lagoon",             {1916.90,-233.30,-100.00,2131.70,13.80,200.00}},
        {"Flint Intersection",          {-187.70,-1596.70,-89.00,17.00,-1276.60,110.90}},
        {"Flint Range",                 {-594.10,-1648.50,0.00,-187.70,-1276.60,200.00}},
        {"Fort Carson",                 {-376.20,826.30,-3.00,123.70,1220.40,200.00}},
        {"Foster Valley",               {-2270.00,-430.20,-0.00,-2178.60,-324.10,200.00}},
        {"Foster Valley",               {-2178.60,-599.80,-0.00,-1794.90,-324.10,200.00}},
        {"Foster Valley",               {-2178.60,-1115.50,0.00,-1794.90,-599.80,200.00}},
        {"Foster Valley",               {-2178.60,-1250.90,0.00,-1794.90,-1115.50,200.00}},
        {"Frederick Bridge",            {2759.20,296.50,0.00,2774.20,594.70,200.00}},
        {"Gant Bridge",                 {-2741.40,1659.60,-6.10,-2616.40,2175.10,200.00}},
        {"Gant Bridge",                 {-2741.00,1490.40,-6.10,-2616.40,1659.60,200.00}},
        {"Ganton",                      {2222.50,-1852.80,-89.00,2632.80,-1722.30,110.90}},
        {"Ganton",                      {2222.50,-1722.30,-89.00,2632.80,-1628.50,110.90}},
        {"Garcia",                      {-2411.20,-222.50,-0.00,-2173.00,265.20,200.00}},
        {"Garcia",                      {-2395.10,-222.50,-5.30,-2354.00,-204.70,200.00}},
        {"Garver Bridge",               {-1339.80,828.10,-89.00,-1213.90,1057.00,110.90}},
        {"Garver Bridge",               {-1213.90,950.00,-89.00,-1087.90,1178.90,110.90}},
        {"Garver Bridge",               {-1499.80,696.40,-179.60,-1339.80,925.30,20.30}},
        {"Glen Park",                   {1812.60,-1449.60,-89.00,1996.90,-1350.70,110.90}},
        {"Glen Park",                   {1812.60,-1100.80,-89.00,1994.30,-973.30,110.90}},
        {"Glen Park",                   {1812.60,-1350.70,-89.00,2056.80,-1100.80,110.90}},
        {"Green Palms",                 {176.50,1305.40,-3.00,338.60,1520.70,200.00}},
        {"Greenglass College",          {964.30,1044.60,-89.00,1197.30,1203.20,110.90}},
        {"Greenglass College",          {964.30,930.80,-89.00,1166.50,1044.60,110.90}},
        {"Hampton Barns",               {603.00,264.30,0.00,761.90,366.50,200.00}},
        {"Hankypanky Point",            {2576.90,62.10,0.00,2759.20,385.50,200.00}},
        {"Harry Gold Parkway",          {1777.30,863.20,-89.00,1817.30,2342.80,110.90}},
        {"Hashbury",                    {-2593.40,-222.50,-0.00,-2411.20,54.70,200.00}},
        {"Hilltop Farm",                {967.30,-450.30,-3.00,1176.70,-217.90,200.00}},
        {"Hunter Quarry",               {337.20,710.80,-115.20,860.50,1031.70,203.70}},
        {"Idlewood",                    {1812.60,-1852.80,-89.00,1971.60,-1742.30,110.90}},
        {"Idlewood",                    {1812.60,-1742.30,-89.00,1951.60,-1602.30,110.90}},
        {"Idlewood",                    {1951.60,-1742.30,-89.00,2124.60,-1602.30,110.90}},
        {"Idlewood",                    {1812.60,-1602.30,-89.00,2124.60,-1449.60,110.90}},
        {"Idlewood",                    {2124.60,-1742.30,-89.00,2222.50,-1494.00,110.90}},
        {"Idlewood",                    {1971.60,-1852.80,-89.00,2222.50,-1742.30,110.90}},
        {"Jefferson",                   {1996.90,-1449.60,-89.00,2056.80,-1350.70,110.90}},
        {"Jefferson",                   {2124.60,-1494.00,-89.00,2266.20,-1449.60,110.90}},
        {"Jefferson",                   {2056.80,-1372.00,-89.00,2281.40,-1210.70,110.90}},
        {"Jefferson",                   {2056.80,-1210.70,-89.00,2185.30,-1126.30,110.90}},
        {"Jefferson",                   {2185.30,-1210.70,-89.00,2281.40,-1154.50,110.90}},
        {"Jefferson",                   {2056.80,-1449.60,-89.00,2266.20,-1372.00,110.90}},
        {"Julius Thruway East",         {2623.10,943.20,-89.00,2749.90,1055.90,110.90}},
        {"Julius Thruway East",         {2685.10,1055.90,-89.00,2749.90,2626.50,110.90}},
        {"Julius Thruway East",         {2536.40,2442.50,-89.00,2685.10,2542.50,110.90}},
        {"Julius Thruway East",         {2625.10,2202.70,-89.00,2685.10,2442.50,110.90}},
        {"Julius Thruway North",        {2498.20,2542.50,-89.00,2685.10,2626.50,110.90}},
        {"Julius Thruway North",        {2237.40,2542.50,-89.00,2498.20,2663.10,110.90}},
        {"Julius Thruway North",        {2121.40,2508.20,-89.00,2237.40,2663.10,110.90}},
        {"Julius Thruway North",        {1938.80,2508.20,-89.00,2121.40,2624.20,110.90}},
        {"Julius Thruway North",        {1534.50,2433.20,-89.00,1848.40,2583.20,110.90}},
        {"Julius Thruway North",        {1848.40,2478.40,-89.00,1938.80,2553.40,110.90}},
        {"Julius Thruway North",        {1704.50,2342.80,-89.00,1848.40,2433.20,110.90}},
        {"Julius Thruway North",        {1377.30,2433.20,-89.00,1534.50,2507.20,110.90}},
        {"Julius Thruway South",        {1457.30,823.20,-89.00,2377.30,863.20,110.90}},
        {"Julius Thruway South",        {2377.30,788.80,-89.00,2537.30,897.90,110.90}},
        {"Julius Thruway West",         {1197.30,1163.30,-89.00,1236.60,2243.20,110.90}},
        {"Julius Thruway West",         {1236.60,2142.80,-89.00,1297.40,2243.20,110.90}},
        {"Juniper Hill",                {-2533.00,578.30,-7.60,-2274.10,968.30,200.00}},
        {"Juniper Hollow",              {-2533.00,968.30,-6.10,-2274.10,1358.90,200.00}},
        {"K.A.C.C. Military Fuels",     {2498.20,2626.50,-89.00,2749.90,2861.50,110.90}},
        {"Kincaid Bridge",              {-1339.80,599.20,-89.00,-1213.90,828.10,110.90}},
        {"Kincaid Bridge",              {-1213.90,721.10,-89.00,-1087.90,950.00,110.90}},
        {"Kincaid Bridge",              {-1087.90,855.30,-89.00,-961.90,986.20,110.90}},
        {"King's",                      {-2329.30,458.40,-7.60,-1993.20,578.30,200.00}},
        {"King's",                      {-2411.20,265.20,-9.10,-1993.20,373.50,200.00}},
        {"King's",                      {-2253.50,373.50,-9.10,-1993.20,458.40,200.00}},
        {"LVA Freight Depot",           {1457.30,863.20,-89.00,1777.40,1143.20,110.90}},
        {"LVA Freight Depot",           {1375.60,919.40,-89.00,1457.30,1203.20,110.90}},
        {"LVA Freight Depot",           {1277.00,1087.60,-89.00,1375.60,1203.20,110.90}},
        {"LVA Freight Depot",           {1315.30,1044.60,-89.00,1375.60,1087.60,110.90}},
        {"LVA Freight Depot",           {1236.60,1163.40,-89.00,1277.00,1203.20,110.90}},
        {"Las Barrancas",               {-926.10,1398.70,-3.00,-719.20,1634.60,200.00}},
        {"Las Brujas",                  {-365.10,2123.00,-3.00,-208.50,2217.60,200.00}},
        {"Las Colinas",                 {1994.30,-1100.80,-89.00,2056.80,-920.80,110.90}},
        {"Las Colinas",                 {2056.80,-1126.30,-89.00,2126.80,-920.80,110.90}},
        {"Las Colinas",                 {2185.30,-1154.50,-89.00,2281.40,-934.40,110.90}},
        {"Las Colinas",                 {2126.80,-1126.30,-89.00,2185.30,-934.40,110.90}},
        {"Las Colinas",                 {2747.70,-1120.00,-89.00,2959.30,-945.00,110.90}},
        {"Las Colinas",                 {2632.70,-1135.00,-89.00,2747.70,-945.00,110.90}},
        {"Las Colinas",                 {2281.40,-1135.00,-89.00,2632.70,-945.00,110.90}},
        {"Las Payasadas",               {-354.30,2580.30,2.00,-133.60,2816.80,200.00}},
        {"Las Venturas Airport",        {1236.60,1203.20,-89.00,1457.30,1883.10,110.90}},
        {"Las Venturas Airport",        {1457.30,1203.20,-89.00,1777.30,1883.10,110.90}},
        {"Las Venturas Airport",        {1457.30,1143.20,-89.00,1777.40,1203.20,110.90}},
        {"Las Venturas Airport",        {1515.80,1586.40,-12.50,1729.90,1714.50,87.50}},
        {"Last Dime Motel",             {1823.00,596.30,-89.00,1997.20,823.20,110.90}},
        {"Leafy Hollow",                {-1166.90,-1856.00,0.00,-815.60,-1602.00,200.00}},
        {"Liberty City",                {-1000.00,400.00,1300.00,-700.00,600.00,1400.00}},
        {"Lil' Probe Inn",              {-90.20,1286.80,-3.00,153.80,1554.10,200.00}},
        {"Linden Side",                 {2749.90,943.20,-89.00,2923.30,1198.90,110.90}},
        {"Linden Station",              {2749.90,1198.90,-89.00,2923.30,1548.90,110.90}},
        {"Linden Station",              {2811.20,1229.50,-39.50,2861.20,1407.50,60.40}},
        {"Little Mexico",               {1701.90,-1842.20,-89.00,1812.60,-1722.20,110.90}},
        {"Little Mexico",               {1758.90,-1722.20,-89.00,1812.60,-1577.50,110.90}},
        {"Los Flores",                  {2581.70,-1454.30,-89.00,2632.80,-1393.40,110.90}},
        {"Los Flores",                  {2581.70,-1393.40,-89.00,2747.70,-1135.00,110.90}},
        {"Los Santos International",    {1249.60,-2394.30,-89.00,1852.00,-2179.20,110.90}},
        {"Los Santos International",    {1852.00,-2394.30,-89.00,2089.00,-2179.20,110.90}},
        {"Los Santos International",    {1382.70,-2730.80,-89.00,2201.80,-2394.30,110.90}},
        {"Los Santos International",    {1974.60,-2394.30,-39.00,2089.00,-2256.50,60.90}},
        {"Los Santos International",    {1400.90,-2669.20,-39.00,2189.80,-2597.20,60.90}},
        {"Los Santos International",    {2051.60,-2597.20,-39.00,2152.40,-2394.30,60.90}},
        {"Marina",                      {647.70,-1804.20,-89.00,851.40,-1577.50,110.90}},
        {"Marina",                      {647.70,-1577.50,-89.00,807.90,-1416.20,110.90}},
        {"Marina",                      {807.90,-1577.50,-89.00,926.90,-1416.20,110.90}},
        {"Market",                      {787.40,-1416.20,-89.00,1072.60,-1310.20,110.90}},
        {"Market",                      {952.60,-1310.20,-89.00,1072.60,-1130.80,110.90}},
        {"Market",                      {1072.60,-1416.20,-89.00,1370.80,-1130.80,110.90}},
        {"Market",                      {926.90,-1577.50,-89.00,1370.80,-1416.20,110.90}},
        {"Market Station",              {787.40,-1410.90,-34.10,866.00,-1310.20,65.80}},
        {"Martin Bridge",               {-222.10,293.30,0.00,-122.10,476.40,200.00}},
        {"Missionary Hill",             {-2994.40,-811.20,0.00,-2178.60,-430.20,200.00}},
        {"Montgomery",                  {1119.50,119.50,-3.00,1451.40,493.30,200.00}},
        {"Montgomery",                  {1451.40,347.40,-6.10,1582.40,420.80,200.00}},
        {"Montgomery Intersection",     {1546.60,208.10,0.00,1745.80,347.40,200.00}},
        {"Montgomery Intersection",     {1582.40,347.40,0.00,1664.60,401.70,200.00}},
        {"Mulholland",                  {1414.00,-768.00,-89.00,1667.60,-452.40,110.90}},
        {"Mulholland",                  {1281.10,-452.40,-89.00,1641.10,-290.90,110.90}},
        {"Mulholland",                  {1269.10,-768.00,-89.00,1414.00,-452.40,110.90}},
        {"Mulholland",                  {1357.00,-926.90,-89.00,1463.90,-768.00,110.90}},
        {"Mulholland",                  {1318.10,-910.10,-89.00,1357.00,-768.00,110.90}},
        {"Mulholland",                  {1169.10,-910.10,-89.00,1318.10,-768.00,110.90}},
        {"Mulholland",                  {768.60,-954.60,-89.00,952.60,-860.60,110.90}},
        {"Mulholland",                  {687.80,-860.60,-89.00,911.80,-768.00,110.90}},
        {"Mulholland",                  {737.50,-768.00,-89.00,1142.20,-674.80,110.90}},
        {"Mulholland",                  {1096.40,-910.10,-89.00,1169.10,-768.00,110.90}},
        {"Mulholland",                  {952.60,-937.10,-89.00,1096.40,-860.60,110.90}},
        {"Mulholland",                  {911.80,-860.60,-89.00,1096.40,-768.00,110.90}},
        {"Mulholland",                  {861.00,-674.80,-89.00,1156.50,-600.80,110.90}},
        {"Mulholland Intersection",     {1463.90,-1150.80,-89.00,1812.60,-768.00,110.90}},
        {"North Rock",                  {2285.30,-768.00,0.00,2770.50,-269.70,200.00}},
        {"Ocean Docks",                 {2373.70,-2697.00,-89.00,2809.20,-2330.40,110.90}},
        {"Ocean Docks",                 {2201.80,-2418.30,-89.00,2324.00,-2095.00,110.90}},
        {"Ocean Docks",                 {2324.00,-2302.30,-89.00,2703.50,-2145.10,110.90}},
        {"Ocean Docks",                 {2089.00,-2394.30,-89.00,2201.80,-2235.80,110.90}},
        {"Ocean Docks",                 {2201.80,-2730.80,-89.00,2324.00,-2418.30,110.90}},
        {"Ocean Docks",                 {2703.50,-2302.30,-89.00,2959.30,-2126.90,110.90}},
        {"Ocean Docks",                 {2324.00,-2145.10,-89.00,2703.50,-2059.20,110.90}},
        {"Ocean Flats",                 {-2994.40,277.40,-9.10,-2867.80,458.40,200.00}},
        {"Ocean Flats",                 {-2994.40,-222.50,-0.00,-2593.40,277.40,200.00}},
        {"Ocean Flats",                 {-2994.40,-430.20,-0.00,-2831.80,-222.50,200.00}},
        {"Octane Springs",              {338.60,1228.50,0.00,664.30,1655.00,200.00}},
        {"Old Venturas Strip",          {2162.30,2012.10,-89.00,2685.10,2202.70,110.90}},
        {"Palisades",                   {-2994.40,458.40,-6.10,-2741.00,1339.60,200.00}},
        {"Palomino Creek",              {2160.20,-149.00,0.00,2576.90,228.30,200.00}},
        {"Paradiso",                    {-2741.00,793.40,-6.10,-2533.00,1268.40,200.00}},
        {"Pershing Square",             {1440.90,-1722.20,-89.00,1583.50,-1577.50,110.90}},
        {"Pilgrim",                     {2437.30,1383.20,-89.00,2624.40,1783.20,110.90}},
        {"Pilgrim",                     {2624.40,1383.20,-89.00,2685.10,1783.20,110.90}},
        {"Pilson Intersection",         {1098.30,2243.20,-89.00,1377.30,2507.20,110.90}},
        {"Pirates in Men's Pants",      {1817.30,1469.20,-89.00,2027.40,1703.20,110.90}},
        {"Playa del Seville",           {2703.50,-2126.90,-89.00,2959.30,-1852.80,110.90}},
        {"Prickle Pine",                {1534.50,2583.20,-89.00,1848.40,2863.20,110.90}},
        {"Prickle Pine",                {1117.40,2507.20,-89.00,1534.50,2723.20,110.90}},
        {"Prickle Pine",                {1848.40,2553.40,-89.00,1938.80,2863.20,110.90}},
        {"Prickle Pine",                {1938.80,2624.20,-89.00,2121.40,2861.50,110.90}},
        {"Queens",                      {-2533.00,458.40,0.00,-2329.30,578.30,200.00}},
        {"Queens",                      {-2593.40,54.70,0.00,-2411.20,458.40,200.00}},
        {"Queens",                      {-2411.20,373.50,0.00,-2253.50,458.40,200.00}},
        {"Randolph Industrial Estate",  {1558.00,596.30,-89.00,1823.00,823.20,110.90}},
        {"Redsands East",               {1817.30,2011.80,-89.00,2106.70,2202.70,110.90}},
        {"Redsands East",               {1817.30,2202.70,-89.00,2011.90,2342.80,110.90}},
        {"Redsands East",               {1848.40,2342.80,-89.00,2011.90,2478.40,110.90}},
        {"Redsands West",               {1236.60,1883.10,-89.00,1777.30,2142.80,110.90}},
        {"Redsands West",               {1297.40,2142.80,-89.00,1777.30,2243.20,110.90}},
        {"Redsands West",               {1377.30,2243.20,-89.00,1704.50,2433.20,110.90}},
        {"Redsands West",               {1704.50,2243.20,-89.00,1777.30,2342.80,110.90}},
        {"Regular Tom",                 {-405.70,1712.80,-3.00,-276.70,1892.70,200.00}},
        {"Richman",                     {647.50,-1118.20,-89.00,787.40,-954.60,110.90}},
        {"Richman",                     {647.50,-954.60,-89.00,768.60,-860.60,110.90}},
        {"Richman",                     {225.10,-1369.60,-89.00,334.50,-1292.00,110.90}},
        {"Richman",                     {225.10,-1292.00,-89.00,466.20,-1235.00,110.90}},
        {"Richman",                     {72.60,-1404.90,-89.00,225.10,-1235.00,110.90}},
        {"Richman",                     {72.60,-1235.00,-89.00,321.30,-1008.10,110.90}},
        {"Richman",                     {321.30,-1235.00,-89.00,647.50,-1044.00,110.90}},
        {"Richman",                     {321.30,-1044.00,-89.00,647.50,-860.60,110.90}},
        {"Richman",                     {321.30,-860.60,-89.00,687.80,-768.00,110.90}},
        {"Richman",                     {321.30,-768.00,-89.00,700.70,-674.80,110.90}},
        {"Robada Intersection",         {-1119.00,1178.90,-89.00,-862.00,1351.40,110.90}},
        {"Roca Escalante",              {2237.40,2202.70,-89.00,2536.40,2542.50,110.90}},
        {"Roca Escalante",              {2536.40,2202.70,-89.00,2625.10,2442.50,110.90}},
        {"Rockshore East",              {2537.30,676.50,-89.00,2902.30,943.20,110.90}},
        {"Rockshore West",              {1997.20,596.30,-89.00,2377.30,823.20,110.90}},
        {"Rockshore West",              {2377.30,596.30,-89.00,2537.30,788.80,110.90}},
        {"Rodeo",                       {72.60,-1684.60,-89.00,225.10,-1544.10,110.90}},
        {"Rodeo",                       {72.60,-1544.10,-89.00,225.10,-1404.90,110.90}},
        {"Rodeo",                       {225.10,-1684.60,-89.00,312.80,-1501.90,110.90}},
        {"Rodeo",                       {225.10,-1501.90,-89.00,334.50,-1369.60,110.90}},
        {"Rodeo",                       {334.50,-1501.90,-89.00,422.60,-1406.00,110.90}},
        {"Rodeo",                       {312.80,-1684.60,-89.00,422.60,-1501.90,110.90}},
        {"Rodeo",                       {422.60,-1684.60,-89.00,558.00,-1570.20,110.90}},
        {"Rodeo",                       {558.00,-1684.60,-89.00,647.50,-1384.90,110.90}},
        {"Rodeo",                       {466.20,-1570.20,-89.00,558.00,-1385.00,110.90}},
        {"Rodeo",                       {422.60,-1570.20,-89.00,466.20,-1406.00,110.90}},
        {"Rodeo",                       {466.20,-1385.00,-89.00,647.50,-1235.00,110.90}},
        {"Rodeo",                       {334.50,-1406.00,-89.00,466.20,-1292.00,110.90}},
        {"Royal Casino",                {2087.30,1383.20,-89.00,2437.30,1543.20,110.90}},
        {"San Andreas Sound",           {2450.30,385.50,-100.00,2759.20,562.30,200.00}},
        {"Santa Flora",                 {-2741.00,458.40,-7.60,-2533.00,793.40,200.00}},
        {"Santa Maria Beach",           {342.60,-2173.20,-89.00,647.70,-1684.60,110.90}},
        {"Santa Maria Beach",           {72.60,-2173.20,-89.00,342.60,-1684.60,110.90}},
        {"Shady Cabin",                 {-1632.80,-2263.40,-3.00,-1601.30,-2231.70,200.00}},
        {"Shady Creeks",                {-1820.60,-2643.60,-8.00,-1226.70,-1771.60,200.00}},
        {"Shady Creeks",                {-2030.10,-2174.80,-6.10,-1820.60,-1771.60,200.00}},
        {"Sobell Rail Yards",           {2749.90,1548.90,-89.00,2923.30,1937.20,110.90}},
        {"Spinybed",                    {2121.40,2663.10,-89.00,2498.20,2861.50,110.90}},
        {"Starfish Casino",             {2437.30,1783.20,-89.00,2685.10,2012.10,110.90}},
        {"Starfish Casino",             {2437.30,1858.10,-39.00,2495.00,1970.80,60.90}},
        {"Starfish Casino",             {2162.30,1883.20,-89.00,2437.30,2012.10,110.90}},
        {"Temple",                      {1252.30,-1130.80,-89.00,1378.30,-1026.30,110.90}},
        {"Temple",                      {1252.30,-1026.30,-89.00,1391.00,-926.90,110.90}},
        {"Temple",                      {1252.30,-926.90,-89.00,1357.00,-910.10,110.90}},
        {"Temple",                      {952.60,-1130.80,-89.00,1096.40,-937.10,110.90}},
        {"Temple",                      {1096.40,-1130.80,-89.00,1252.30,-1026.30,110.90}},
        {"Temple",                      {1096.40,-1026.30,-89.00,1252.30,-910.10,110.90}},
        {"The Camel's Toe",             {2087.30,1203.20,-89.00,2640.40,1383.20,110.90}},
        {"The Clown's Pocket",          {2162.30,1783.20,-89.00,2437.30,1883.20,110.90}},
        {"The Emerald Isle",            {2011.90,2202.70,-89.00,2237.40,2508.20,110.90}},
        {"The Farm",                    {-1209.60,-1317.10,114.90,-908.10,-787.30,251.90}},
        {"The Four Dragons Casino",     {1817.30,863.20,-89.00,2027.30,1083.20,110.90}},
        {"The High Roller",             {1817.30,1283.20,-89.00,2027.30,1469.20,110.90}},
        {"The Mako Span",               {1664.60,401.70,0.00,1785.10,567.20,200.00}},
        {"The Panopticon",              {-947.90,-304.30,-1.10,-319.60,327.00,200.00}},
        {"The Pink Swan",               {1817.30,1083.20,-89.00,2027.30,1283.20,110.90}},
        {"The Sherman Dam",             {-968.70,1929.40,-3.00,-481.10,2155.20,200.00}},
        {"The Strip",                   {2027.40,863.20,-89.00,2087.30,1703.20,110.90}},
        {"The Strip",                   {2106.70,1863.20,-89.00,2162.30,2202.70,110.90}},
        {"The Strip",                   {2027.40,1783.20,-89.00,2162.30,1863.20,110.90}},
        {"The Strip",                   {2027.40,1703.20,-89.00,2137.40,1783.20,110.90}},
        {"The Visage",                  {1817.30,1863.20,-89.00,2106.70,2011.80,110.90}},
        {"The Visage",                  {1817.30,1703.20,-89.00,2027.40,1863.20,110.90}},
        {"Unity Station",               {1692.60,-1971.80,-20.40,1812.60,-1932.80,79.50}},
        {"Valle Ocultado",              {-936.60,2611.40,2.00,-715.90,2847.90,200.00}},
        {"Verdant Bluffs",              {930.20,-2488.40,-89.00,1249.60,-2006.70,110.90}},
        {"Verdant Bluffs",              {1073.20,-2006.70,-89.00,1249.60,-1842.20,110.90}},
        {"Verdant Bluffs",              {1249.60,-2179.20,-89.00,1692.60,-1842.20,110.90}},
        {"Verdant Meadows",             {37.00,2337.10,-3.00,435.90,2677.90,200.00}},
        {"Verona Beach",                {647.70,-2173.20,-89.00,930.20,-1804.20,110.90}},
        {"Verona Beach",                {930.20,-2006.70,-89.00,1073.20,-1804.20,110.90}},
        {"Verona Beach",                {851.40,-1804.20,-89.00,1046.10,-1577.50,110.90}},
        {"Verona Beach",                {1161.50,-1722.20,-89.00,1323.90,-1577.50,110.90}},
        {"Verona Beach",                {1046.10,-1722.20,-89.00,1161.50,-1577.50,110.90}},
        {"Vinewood",                    {787.40,-1310.20,-89.00,952.60,-1130.80,110.90}},
        {"Vinewood",                    {787.40,-1130.80,-89.00,952.60,-954.60,110.90}},
        {"Vinewood",                    {647.50,-1227.20,-89.00,787.40,-1118.20,110.90}},
        {"Vinewood",                    {647.70,-1416.20,-89.00,787.40,-1227.20,110.90}},
        {"Whitewood Estates",           {883.30,1726.20,-89.00,1098.30,2507.20,110.90}},
        {"Whitewood Estates",           {1098.30,1726.20,-89.00,1197.30,2243.20,110.90}},
        {"Willowfield",                 {1970.60,-2179.20,-89.00,2089.00,-1852.80,110.90}},
        {"Willowfield",                 {2089.00,-2235.80,-89.00,2201.80,-1989.90,110.90}},
        {"Willowfield",                 {2089.00,-1989.90,-89.00,2324.00,-1852.80,110.90}},
        {"Willowfield",                 {2201.80,-2095.00,-89.00,2324.00,-1989.90,110.90}},
        {"Willowfield",                 {2541.70,-1941.40,-89.00,2703.50,-1852.80,110.90}},
        {"Willowfield",                 {2324.00,-2059.20,-89.00,2541.70,-1852.80,110.90}},
        {"Willowfield",                 {2541.70,-2059.20,-89.00,2703.50,-1941.40,110.90}},
        {"Yellow Bell Station",         {1377.40,2600.40,-21.90,1492.40,2687.30,78.00}},
        // Main Zones
        {"Los Santos",                  {44.60,-2892.90,-242.90,2997.00,-768.00,900.00}},
        {"Las Venturas",                {869.40,596.30,-242.90,2997.00,2993.80,900.00}},
        {"Bone County",                 {-480.50,596.30,-242.90,869.40,2993.80,900.00}},
        {"Tierra Robada",               {-2997.40,1659.60,-242.90,-480.50,2993.80,900.00}},
        {"Tierra Robada",               {-1213.90,596.30,-242.90,-480.50,1659.60,900.00}},
        {"San Fierro",                  {-2997.40,-1115.50,-242.90,-1213.90,1659.60,900.00}},
        {"Red County",                  {-1213.90,-768.00,-242.90,2997.00,596.30,900.00}},
        {"Flint County",                {-1213.90,-2892.90,-242.90,44.60,-768.00,900.00}},
        {"Whetstone",                   {-2997.40,-2892.90,-242.90,-1213.90,-1115.50,900.00}}
};

//Essential character variables:
new bool:playerMakingCharacter[MAX_PLAYERS], playerCharacterStep[MAX_PLAYERS];
new playerCharactersName[MAX_PLAYERS][MAX_PLAYER_NAME + 1];
new playerCharactersAge[MAX_PLAYERS][20], playerCharacterOrigin[MAX_PLAYERS][60];
new playerCharacterStory[MAX_PLAYERS][2][90];

//Player variables:
new playerLogin[MAX_PLAYERS] = 0, playerHouseSelect[MAX_PLAYERS][3];
new playerPhone[MAX_PLAYERS], playerText[MAX_PLAYERS];

new bool:PlayerTakingLicense[MAX_PLAYERS], PlayerLicenseTime[MAX_PLAYERS];
new PlayerLicensePoint[MAX_PLAYERS];
new PlayersLicenseVehicle[MAX_PLAYERS];

new Player911Type[MAX_PLAYERS], Player911Timer[2][MAX_PLAYERS];
new Player911Text[MAX_PLAYERS][3][128];

new PlayerMDCTimer[MAX_PLAYERS], PlayerMDCCount[MAX_PLAYERS];
new PlayerMDCName[MAX_PLAYERS][32], PlayerPlateSaver[MAX_PLAYERS][5][20];

new PlayerText:Unscrambler_PTD[MAX_PLAYERS][7];
new PlayerText:CarBought_PTD[MAX_PLAYERS][2];

new ActorIlligalDealer;

//Robbing
new RobAgainTime[MAX_BUSINESS];
new EmptyBizTimer[MAX_BUSINESS];
new EmptyIntTimer[MAX_BUSINESS];
new BizOpenAgainTimer[MAX_BUSINESS];
new policetape[MAX_BUSINESS];
new IntCheck[MAX_BUSINESS];
new ActorBizGuard[MAX_BUSINESS];
new ChanceRobbedTimer[MAX_PLAYERS];
new BellTimer[MAX_PLAYERS];
new BellTimerQuit[MAX_BUSINESS];
new InBellRegion[MAX_PLAYERS];
new FactionOnDuty[MAX_FACTIONS];

//Bayside Bank
new bankworker1;
new bankworker2;
new bankworker3;

new doorbomb1;
new doorbomb2;

new bankdoor;
new bankdoor2;
new bankdoor_status = 0;
new bankdoor2_status = 0;
new doorbombstats1 = 0;
new doorbombstats2 = 0;

new ArmedRobbery[MAX_PLAYERS];
new RobCheatTimer[MAX_PLAYERS];
new RobTimer[MAX_PLAYERS];
new BagTimer[MAX_PLAYERS];

new banksecdoor;
//Dynamic areas:
new ImpoundLotArea;

//Start of functions:

public OnGameModeInit()
{
    TSC_Connect("serveradmin", "1Fh1PXFn", "217.182.206.227", 9987);
	SetGameModeText(SCRIPT_REV);
	speedotimer = SetTimer("Speedometer", 555, true);
	ourConnection = mysql_connect(SQL_HOSTNAME, SQL_USERNAME, SQL_DATABASE, SQL_PASSWORD);
	skins = LoadModelSelectionMenu("skins.txt");
	AddPlayerClass(0,0,0,0,0,0,0,0,0,0,0);
	SetTimer("PingChecker",5000,1);

	if(mysql_errno() != 0)
		printf ("[DATABASE]: Connection failed to '%s'...", SQL_DATABASE);

	else printf ("[DATABASE]: Connection established to '%s'...", SQL_DATABASE);
	//Bayside Bank
	bankworker1 = CreateActor(240, -2483.0952,3476.2000,2004.6260,2.0164);
	SetActorVirtualWorld(bankworker1, 9583);
	bankworker2 = CreateActor(150, -2485.1477,3476.2000,2004.6260,2.0164);
	SetActorVirtualWorld(bankworker2, 9583);
	bankworker3 = CreateActor(141, -2479.1157,3476.2000,2004.6260,2.0164);
	SetActorVirtualWorld(bankworker3, 9583);
    ActorIlligalDealer = CreateActor(1, 300.2266,306.5119,999.1484,6.1841); // Illigal Dealer
    SetActorVirtualWorld(ActorIlligalDealer, 16144);

	CreatePickup(1247, 1, 1555.5010,-1675.9463,16.1953, -1);
	CreatePickup(1239, 1, -2648.2458, 2240.1338, 1009.0131, -1);
	CreatePickup(1239, 1, -2541.6909, 2346.4246, 5.2455, -1);
	CreatePickup(1239, 1, -2537.4355, 2356.0823, 5.2455, -1);
	mysql_log(LOG_ERROR | LOG_WARNING);
	SetTimer("JailTimer", 1000, 1);
	for (new i = 1; i < MAX_FACTIONS; i ++)
	{
		FactionOnDuty[i] = 0;
	}
	//Disabling single player entities:
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	SetNameTagDrawDistance(20.0);

 	//3D Text Labels

   	Create3DTextLabel("/deliver", 0xFF6347FF, -2504.4973, 2367.6221, 5.0401, 40.0, 0, 1);
   	Create3DTextLabel("Refuel Point - Use /refuel", 0x0D7304FF, -2278.7888, 2409.3823, 4.9141, 40.0, 0, 1);
   	Create3DTextLabel("Refuel Point - Use /refuel", 0x0D7304FF, 1939.9840,-1769.2646,13.3828, 40.0, 0, 1);
   	Create3DTextLabel("Lockers - Use /locker",0x0D7304FF,253.2740,77.0761,1003.6406,40.0,0,1);

	EnableStuntBonusForAll(0);

	ManualVehicleEngineAndLights();
	DisableInteriorEnterExits();

	//Bayside Bank
	bankdoor = CreateDynamicObject(19302, -2487.74023, 3477.03247, 2004.85376,   0.00000, 0.00000, 0.00000);//First door
	SetDynamicObjectMaterial(bankdoor,  0, 1649, "wglass", "carshowwin2", 0xFFFFFFFF);
	bankdoor2 = CreateDynamicObject(19302, -2481.31641, 3473.12598, 2004.85376,   0.00000, 0.00000, 90.00000); //Second door
	SetDynamicObjectMaterial(bankdoor2, 0, 1649, "wglass", "carshowwin2", 0xFFFFFFFF);
	banksecdoor = CreateDynamicObject(10671, -2480.67554, 3477.13062, 2008.99817,   0.00000, 0.00000, -90.00000);
	SetDynamicObjectMaterial(banksecdoor,  0, 5779, "garaged_lawn", "alleydoor8", 0xFFFFFFFF);


	// Gates and doors
	gate0 = CreateObject(968, -2611.69556, 2276.04761, 7.93240,   0.00000, -90.00000, 0.00000);
 	// Bayside FD gates
 	fdgate1 = CreateDynamicObject(11313, -2534.17944, 2347.45361, 5.94538,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdgate1, 0, 11008, "firehouse_sfse", "ws_rollerdoor_fire", 0);
    fdgate2 = CreateDynamicObject(11313, -2526.27173, 2347.45361, 5.94540,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdgate2, 0, 11008, "firehouse_sfse", "ws_rollerdoor_fire", 0);
    fdgate3 = CreateDynamicObject(11313, -2518.36084, 2347.45361, 5.94540,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdgate3, 0, 11008, "firehouse_sfse", "ws_rollerdoor_fire", 0);
   	//door0 = CreateObject(1495, -2652.49341, 2240.58130, 1007.97980,   0.00000, 0.00000, -90.00000);
   	door0 = CreateObject(1495, 245.63580, 72.39397, 1002.53650,  -0.20600, 0.00000,0.00000);
 	CreateObject(19383, 246.39067, 72.44534, 1004.17963,   0.00000, 0.00000, 90.00000);

	door1 = CreateObject(1569, -2597.09375, 4003.74438, 2000.24695,   0.00000, 0.00000, 0.00000);
	cell0 = CreateObject(19303, -2654.86865, 2241.96411, 1009.22820,0.00000, 0.00000, 90.00000);
	cell1 = CreateObject(19303, -2654.86865, 2246.01611, 1009.22820,0.00000, 0.00000, 90.00000);


	//scrapyard gates
	scrapgate1 = CreateDynamicObject(19870, -1485.95728, 1988.54309, 47.60990,   0.00000, 0.00000, 0.00000);
	scrapgate2 = CreateDynamicObject(19870, -1486.01306, 1988.55969, 47.60990,   0.00000, 0.00000, -180.00000);

    	// Bayside ammunition
	CreateDynamicObject(2959, -2455.98584, 2309.48535, 4.28097,   0.00000, 0.00000, -0.30000);
	CreateDynamicObject(2959, -2456.10327, 2312.50781, 4.28100,   0.00000, 0.00000, -178.67999);
	CreateDynamicObject(10631, -2446.94897, 2311.17798, 8.25113,   0.00000, 0.00000, -269.87991);
	CreateDynamicObject(2959, -2455.98584, 2309.48535, 4.28097,   0.00000, 0.00000, -0.30000);
	CreateDynamicObject(2959, -2456.10327, 2312.50781, 4.28100,   0.00000, 0.00000, -178.67999);
	new ammo1 = CreateDynamicObject(19454, -2456.15259, 2316.37964, 10.97787,   0.00000, 0.00000, 0.18000);
	SetDynamicObjectMaterial(ammo1, 0, 4552, "ammu_lan2", "sunsetammu2", 0xFFFFFFFF);
	new ammo2 = CreateDynamicObject(19454, -2456.19141, 2305.75415, 10.97790,   0.00000, 0.00000, -0.24000);
	SetDynamicObjectMaterial(ammo2, 0, 4552, "ammu_lan2", "sunsetammu2", 0xFFFFFFFF);
	new ammo3 = CreateDynamicObject(19435, -2456.17090, 2310.92554, 10.97790,   0.00000, 0.00000, 0.24000);
	SetDynamicObjectMaterial(ammo3, 0, 4552, "ammu_lan2", "sunsetammu2", 0xFFFFFFFF);

	//bayside DMV
	CreateDynamicObject(11015, -2478.04053, 2230.08691, 5.81360,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1262, -2468.96460, 2229.96021, 5.61012,   0.00000, 0.00000, -89.10003);
	CreateDynamicObject(1263, -2469.07275, 2227.21069, 5.93793,   0.00000, 0.00000, -179.57996);
	CreateDynamicObject(1238, -2468.42334, 2229.86108, 4.19255,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, -2468.68579, 2231.17993, 4.19255,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, -2468.66846, 2232.12158, 4.19255,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(638, -2468.92285, 2224.45703, 4.53295,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(638, -2468.84302, 2234.58032, 4.53295,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(640, -2473.48315, 2239.34082, 4.54130,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(640, -2482.60083, 2239.32056, 4.54130,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1537, -2469.21704, 2229.28931, 4.00560,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2949, -2486.84790, 2232.45361, 3.90250,   0.00000, 0.00000, 0.00000);

	//Bayside clothing
	new clothing1 = CreateDynamicObject(19906, -2515.17139, 2280.22876, 7.11905,   0.00000, 0.00000, -24.54000);
	SetDynamicObjectMaterial(clothing1, 0, 17517, "templae2land", "bincowin", 0xFFFFFFFF);
	new clothing2 = CreateDynamicObject(19906, -2505.77832, 2276.00879, 7.11905,   0.00000, 0.00000, -24.54000);
	SetDynamicObjectMaterial(clothing2, 0, 17517, "templae2land", "bincowin", 0xFFFFFFFF);
	new clothing3 = CreateDynamicObject(19172, -2510.44214, 2277.73828, 7.81259,   0.00000, 0.00000, -24.30000);
	SetDynamicObjectMaterial(clothing3, 0, 9524, "blokmodb", "bincosf_1", 0xFFFFFFFF);

	//bayside 24/7
	CreateDynamicObject(1361, -2476.77490, 2320.60498, 4.68916,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, -2481.14063, 2321.10547, 4.50998,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, -2476.23242, 2316.36816, 4.51000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2714, -2480.73389, 2318.76318, 6.21482,   0.00000, 0.00000, 134.64009);
	CreateDynamicObject(3802, -2478.33521, 2317.45020, 6.14866,   0.00000, 0.00000, 48.89997);
	new shop = CreateDynamicObject(19454, -2479.65674, 2317.48315, 5.67625,   0.00000, 0.00000, 44.10000);
	SetDynamicObjectMaterial(shop, 0, 18233, "cuntwshopscs_t", "snpdwhit3", 0xFFFFFFFF);
	new shop2 = CreateDynamicObject(19454, -2487.64917, 2320.70850, 5.67625,   0.00000, 0.00000, 90.36000);
	SetDynamicObjectMaterial(shop2, 0, 18233, "cuntwshopscs_t", "snpdwhit3", 0xFFFFFFFF);
	new shop3 = CreateDynamicObject(19438, -2479.59155, 2317.52808, 5.27000,   0.00000, 0.00000, 44.51998);
	SetDynamicObjectMaterial(shop3, 0, 5180, "lashops93_las2", "lastat1", 0xFFFFFFFF);
	new shop4 = CreateDynamicObject(19172, -2479.26709, 2317.81885, 9.18773,   0.00000, 0.00000, 134.88014);
	SetDynamicObjectMaterial(shop4, 0, 12964, "sw_block09", "sw_genstore", 0xFFFFFFFF);

	//bayside Eshop
	CreateDynamicObject(2229, -2539.05347, 2318.60767, 3.97835,   0.00000, 0.00000, 145.92014);
	CreateDynamicObject(2229, -2536.45264, 2318.20801, 3.97835,   0.00000, 0.00000, 215.64006);
	CreateDynamicObject(1216, -2536.43286, 2321.24268, 4.60304,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1216, -2538.29810, 2321.17920, 4.60304,   0.00000, 0.00000, 180.00000);
	new eshop = CreateDynamicObject(19454, -2527.00757, 2320.73291, 5.67625,   0.00000, 0.00000, 90.06002);
	SetDynamicObjectMaterial(eshop, 0, 5180, "lashops93_las2", "snpdwhit3", 0xFFFFFFFF);
	new eshop1 = CreateDynamicObject(19910, -2546.64697, 2320.86865, 5.71739,   0.00000, 0.00000, -0.96000);
	SetDynamicObjectMaterial(eshop1, 0, 5180, "lashops93_las2", "snpdwhit3", 0xFFFFFFFF);
	new eshop3 = CreateDynamicObject(19910, -2545.76611, 2320.82300, 5.71739,   0.00000, 0.00000, -0.96000);
	SetDynamicObjectMaterial(eshop3, 0, 5180, "lashops93_las2", "snpdwhit3", 0xFFFFFFFF);
	new eshop4 = CreateDynamicObject(19454, -2539.40112, 2318.32495, 5.67625,   0.00000, 0.00000, 60.66002);
	SetDynamicObjectMaterial(eshop4, 0, 5180, "lashops93_las2", "snpdwhit3", 0xFFFFFFFF);
	new eshop5 = CreateDynamicObject(19454, -2535.29248, 2318.52002, 5.67625,   0.00000, 0.00000, 120.78004);
	SetDynamicObjectMaterial(eshop5, 0, 5180, "lashops93_las2", "snpdwhit3", 0xFFFFFFFF);

	//bayside clucking
	CreateDynamicObject(2770, -2515.56226, 2321.23706, 4.59730,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2770, -2522.19116, 2321.29102, 4.59730,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1281, -2513.08569, 2322.45703, 4.78280,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1281, -2524.38647, 2322.45703, 4.78280,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1522, -2517.85767, 2318.28003, 3.98020,   0.00000, 0.00000, 180.00000);
	new food = CreateDynamicObject(19910, -2521.10913, 2319.44678, 5.72773,   0.00000, 0.00000, -50.94001);
	SetDynamicObjectMaterial(food, 0, 10606, "cluckbell_sfs", "vgnburgwal3_256", 0xFFFFFFFF);
	new food1 = CreateDynamicObject(19910, -2516.46606, 2319.47607, 5.72773,   0.00000, 0.00000, 54.66000);
	SetDynamicObjectMaterial(food1, 0, 10606, "cluckbell_sfs", "vgnburgwal5_256", 0xFFFFFFFF);
	new food2 = CreateDynamicObject(19910, -2513.24292, 2320.80054, 5.72773,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(food2, 0, 10606, "cluckbell_sfs", "vgnburgwal5_256", 0xFFFFFFFF);
	new food3 = CreateDynamicObject(19910, -2524.44604, 2320.81836, 5.72773,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(food3, 0, 10606, "cluckbell_sfs", "vgnburgwal5_256", 0xFFFFFFFF);
	new food4 = CreateDynamicObject(19172, -2518.52710, 2321.52979, 8.88120,   0.00000, 0.00000, -180.00000);
	SetDynamicObjectMaterial(food4, 0, 8639, "chinatownmall", "cluckbell02_law", 0xFFFFFFFF);
	new food5 = CreateDynamicObject(19435, -2518.52246, 2321.43579, 8.88650,   90.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(food5, 0, 5716, "sunrise02_lawn", "duskyred_64", 0xFFFFFFFF);
	new food6 = CreateDynamicObject(19172, -2521.56274, 2295.66821, 7.34791,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(food6, 0, 5168, "lashops6_las2", "cluckbell02_law", 0xFFFFFFFF);


	//bayside bank
	CreateDynamicObject(19859, -2501.98413, 2318.31250, 5.22254,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1364, -2501.31909, 2321.69873, 4.75405,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1215, -2504.92700, 2321.23267, 4.49850,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -2497.98315, 2321.23267, 4.49850,   0.00000, 0.00000, 0.00000);
	new bank = CreateDynamicObject(19355, -2501.51172, 2322.37109, 14.79930,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(bank, 0, 11471, "des_wtownmain", "des_banksign", 0xFFFFFFFF);
	new bankwindow1 = CreateDynamicObject(19355, -2493.81006, 2320.82910, 5.74040,   90.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(bankwindow1, 0, 3979, "civic01_lan", "sl_laglasswall1", 0xFFFFFFFF);
    new bankwindow2 = CreateDynamicObject(19355, -2508.90918, 2320.73682, 5.74040,   90.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(bankwindow2, 0, 3979, "civic01_lan", "sl_laglasswall1", 0xFFFFFFFF);
    new bankwindow3 = CreateDynamicObject(19454, -2502.42358, 2318.01855, 5.72508,   0.00000, 0.00000, 58.14001);
    SetDynamicObjectMaterial(bankwindow3, 0, 3979, "civic01_lan", "sl_laglasswall1", 0xFFFFFFFF);
    new bankwindow4 = CreateDynamicObject(19454, -2500.15527, 2317.99951, 5.72508,   0.00000, 0.00000, 123.24001);
    SetDynamicObjectMaterial(bankwindow4, 0, 3979, "civic01_lan", "sl_laglasswall1", 0xFFFFFFFF);

	//Bayside fish shack
	CreateDynamicObject(11497, -2255.46289, 2561.48145, 2.80195,   -5.40000, 3.42000, -94.01994);

	// Bayside Police Station
	CreateDynamicObject(16563, -2613.95923, 2260.13989, 5.84491,   0.00000, 0.00000, 89.40011);
	CreateDynamicObject(966, -2611.63647, 2276.04639, 7.19769,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, -2608.64893, 2276.03662, 7.91204,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, -2606.21338, 2278.55591, 7.91200,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(11453, -2588.34375, 2243.00488, 4.20160,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3030, -2611.30859, 2252.76636, 9.39225,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2921, -2610.03198, 2256.30615, 13.01168,   0.00000, 0.00000, 162.95999);
	CreateDynamicObject(14881, -2653.26221, 2240.68237, 1009.99487,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19303, -2654.92676, 2243.70313, 1009.22821,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19304, -2654.88208, 2242.84644, 1011.10742,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19304, -2654.88208, 2242.84644, 1012.30762,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19304, -2654.88208, 2246.85840, 1011.10742,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19304, -2654.88208, 2246.85840, 1012.30762,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19303, -2654.92676, 2247.72656, 1009.22821,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(14881, -2653.28003, 2240.67334, 1014.98358,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11729, -2656.38330, 2241.20483, 1012.95782,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(11729, -2656.38330, 2241.99878, 1012.95782,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(11729, -2656.36475, 2242.78101, 1012.95782,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(11730, -2656.38330, 2243.54077, 1012.95782,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(11729, -2656.38330, 2244.30884, 1012.95782,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2400, -2655.48511, 2248.19946, 1012.98389,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2400, -2659.20703, 2248.19946, 1012.98389,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2395, -2655.48511, 2248.19946, 1015.72351,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2395, -2659.20703, 2248.19946, 1015.72351,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2607, -2656.34253, 2246.38525, 1013.37988,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2356, -2655.49756, 2246.30835, 1012.98370,   0.00000, 0.00000, 59.04000);
	CreateDynamicObject(19142, -2653.84961, 2248.00610, 1013.68182,   -6.48000, -97.56000, 90.00000);
	CreateDynamicObject(19142, -2652.62964, 2247.99512, 1013.68182,   -6.48000, -97.56000, 90.00000);
	CreateDynamicObject(19141, -2652.60400, 2247.73511, 1014.63739,   -52.92000, -90.78000, 192.06010);
	CreateDynamicObject(19141, -2653.79590, 2247.70630, 1014.63739,   -52.92000, -90.78000, 192.06010);
	CreateDynamicObject(19142, -2654.36670, 2247.98022, 1013.67188,   -7.20000, -83.64000, 272.82001);
	CreateDynamicObject(19141, -2654.35938, 2247.68140, 1014.63739,   -65.94000, -89.16000, 209.46001);
	CreateDynamicObject(19142, -2656.34521, 2247.94727, 1013.68182,   -6.48000, -97.56000, 90.00000);
	CreateDynamicObject(19141, -2656.31348, 2247.72754, 1014.63739,   -65.94000, -89.16000, 168.06020);
	CreateDynamicObject(2358, -2653.29688, 2248.00781, 1015.04950,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2358, -2655.21606, 2247.98657, 1015.04950,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2042, -2654.22729, 2247.95825, 1015.02600,   0.00000, 0.00000, -10.86000);
	CreateDynamicObject(2040, -2652.76392, 2247.96509, 1015.03198,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2040, -2652.42505, 2248.00049, 1015.03198,   0.00000, 0.00000, -23.16000);
	CreateDynamicObject(356, -2654.66968, 2248.04956, 1013.62170,   9.96000, 66.78000, -86.82000);
	CreateDynamicObject(356, -2652.82788, 2248.15503, 1013.62170,   9.96000, 66.78000, -118.56000);
	CreateDynamicObject(358, -2653.57935, 2248.21167, 1013.71350,   16.08000, 89.10010, -91.08000);
	CreateDynamicObject(353, -2656.04761, 2248.26318, 1013.46082,   16.08000, 89.10010, -150.06000);
	CreateDynamicObject(349, -2655.32227, 2248.16968, 1013.71350,   19.56000, 84.54010, -150.06000);
	CreateDynamicObject(349, -2652.36255, 2248.13037, 1013.71350,   19.56000, 84.54010, -127.02000);
	CreateDynamicObject(1533, -2652.72363, 2232.58667, 1007.98767,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1533, -2649.00171, 2240.60669, 1012.98322,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1533, -2649.00171, 2240.60669, 1007.97717,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2604, -2652.08521, 2237.19873, 1008.79248,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2604, -2652.14282, 2233.49707, 1008.79248,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19304, -2652.45996, 2238.88696, 1011.10742,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19304, -2652.45996, 2238.88696, 1012.31152,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19304, -2652.45996, 2235.38745, 1011.10742,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19304, -2652.45996, 2235.38745, 1012.31152,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19304, -2652.45996, 2231.90845, 1011.10742,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19304, -2652.45996, 2231.90845, 1012.31152,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19304, -2653.49170, 2244.85132, 1015.12671,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19304, -2653.49170, 2244.85132, 1016.37488,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1722, -2655.43359, 2234.81519, 1007.99481,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1722, -2655.45557, 2235.95264, 1007.99481,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1722, -2655.43481, 2237.05591, 1007.99481,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1722, -2655.44287, 2238.17725, 1007.99481,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(630, -2655.06055, 2237.57666, 1009.01453,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1808, -2655.34521, 2234.09692, 1007.99500,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1775, -2654.86426, 2240.20923, 1009.08752,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1722, -2652.30493, 2242.78857, 1007.99481,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1722, -2652.30420, 2245.96753, 1007.99481,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2356, -2648.48340, 2233.12158, 1007.97852,   0.00000, 0.00000, 41.88000);
	CreateDynamicObject(2356, -2647.99243, 2238.20703, 1007.97852,   0.00000, 0.00000, 141.17999);
	CreateDynamicObject(2611, -2647.51880, 2238.71558, 1009.82129,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2612, -2647.52441, 2236.62720, 1009.82129,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2606, -2647.36963, 2237.54761, 1010.95612,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2605, -2648.48755, 2234.33960, 1008.38507,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2607, -2648.48950, 2237.22705, 1008.39612,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1808, -2647.61743, 2235.70459, 1007.99469,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2614, -2649.59204, 2232.68140, 1010.64838,   0.00000, 15.00000, 180.00000);
	CreateDynamicObject(18092, -2652.49585, 2245.25000, 1013.47198,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2190, -2654.89307, 2245.42700, 1013.94208,   0.00000, 0.00000, 128.16000);
	CreateDynamicObject(19808, -2654.25806, 2245.67847, 1013.98547,   0.00000, 0.00000, 135.24010);
	CreateDynamicObject(1723, -2647.98682, 2236.12402, 1012.98291,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1723, -2649.55786, 2233.07690, 1012.98291,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2011, -2647.98926, 2233.03516, 1012.96930,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1817, -2650.52002, 2234.55176, 1012.94592,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2132, -2650.93213, 2240.23145, 1012.98279,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19916, -2651.82690, 2240.33301, 1012.98309,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19787, -2655.58643, 2237.54419, 1014.91669,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1775, -2655.06982, 2234.48315, 1014.08978,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2500, -2650.81323, 2240.56299, 1014.02258,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2637, -2654.48633, 2237.51270, 1013.38269,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2310, -2654.96191, 2236.39917, 1013.44269,   0.00000, 0.00000, -106.92000);
	CreateDynamicObject(2310, -2653.91919, 2236.41626, 1013.44269,   0.00000, 0.00000, -81.66000);
	CreateDynamicObject(2310, -2654.99316, 2238.63916, 1013.44269,   0.00000, 0.00000, 118.92000);
	CreateDynamicObject(2310, -2653.84766, 2238.81152, 1013.44269,   0.00000, 0.00000, 78.36000);
	CreateDynamicObject(19377, -2656.70532, 2244.14795, 1018.63641,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19377, -2656.70898, 2244.14795, 1018.08051,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2614, -2656.56274, 2242.77026, 1016.00031,   0.00000, 0.00000, 90.00000);



	// Bayside Medical

	CreateDynamicObject(11455, -2490.05151, 2341.74365, 7.05598,   2.00000, 0.00000, 0.00000);
	CreateDynamicObject(639, -2497.59692, 2341.56714, 5.29764,   0.00000, 0.00000, 90.77998);
	CreateDynamicObject(640, -2497.65576, 2341.28857, 4.66711,   -0.50000, 0.00000, -88.32000);
	CreateDynamicObject(640, -2490.60840, 2341.27466, 4.66711,   -0.50000, 0.00000, -88.32000);
	CreateDynamicObject(970, -2483.76953, 2341.13354, 4.54300,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, -2478.13721, 2341.14478, 4.54300,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, -2483.30371, 2348.65674, 7.44424,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, -2479.37061, 2347.09668, 7.44424,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18766, -2499.25952, 2367.20068, 3.49646,   90.00000, 0.00000, 90.00000);
	new medic1 = CreateDynamicObject(19454, -2493.29541, 2341.65381, 10.7273,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(medic1, 0, 10052, "lomall", "sf_hospitaldr2", 0xFFFFFFFF);
	new medic2 = CreateDynamicObject(19454, -2497.25513, 2341.65259, 10.7273,   0.00000, 0.00000, 90.36002);
	SetDynamicObjectMaterial(medic2, 0, 10052, "lomall", "sf_hospitaldr2", 0xFFFFFFFF);
	new medic3 = CreateDynamicObject(19454, -2501.99902, 2346.45996, 10.7273,   0.00000, 0.00000, 0.12000);
	SetDynamicObjectMaterial(medic3, 0, 10052, "lomall", "sf_hospitaldr2", 0xFFFFFFFF);
	new medic4 = CreateDynamicObject(19454, -2502.02295, 2356.05884, 10.7273,   0.00000, 0.00000, 0.12000);
    SetDynamicObjectMaterial(medic4, 0, 10052, "lomall", "sf_hospitaldr2", 0xFFFFFFFF);
    new medic5 = CreateDynamicObject(19454, -2488.53125, 2346.39819, 10.7273,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(medic5, 0, 10052, "lomall", "sf_hospitaldr2", 0xFFFFFFFF);
    new medic6 = CreateDynamicObject(19454, -2488.52026, 2350.99146, 10.7273,   0.00000, 0.00000, -0.18000);
    SetDynamicObjectMaterial(medic6, 0, 10052, "lomall", "sf_hospitaldr2", 0xFFFFFFFF);
    new medic7 = CreateDynamicObject(19454, -2493.24780, 2355.74365, 10.7273,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(medic7, 0, 10052, "lomall", "sf_hospitaldr2", 0xFFFFFFFF);
    CreateDynamicObject(3037, -2502.30249, 2355.731, 5.45939,   0.00000, 0.00000, 0.00000);
    new medic9 = CreateDynamicObject(3037, -2504.55908, 2365.80444, 3.99340,   -0.10000, 90.00000, 180.00000);
    SetDynamicObjectMaterial(medic9, 0, 4032, "lanpolicecp", "ws_carpark3", 0xFFFFFFFF);

	// Bayside Car Co.
	CreateDynamicObject(11504, -2239.83130, 2289.72974, 3.92830,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2714, -2244.05103, 2292.87451, 6.35599,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1238, -2244.42822, 2291.49902, 4.23310,   0.00000, 0.00000, 27.36000);
	CreateDynamicObject(1238, -2244.21680, 2290.76636, 4.23310,   0.00000, 0.00000, 27.36000);
	CreateDynamicObject(1238, -2244.84277, 2290.89404, 4.23310,   0.00000, 0.00000, 27.36000);
	CreateDynamicObject(1238, -2244.13623, 2290.15479, 4.23310,   0.00000, 0.00000, 27.36000);
	CreateDynamicObject(2614, -2244.00439, 2290.67432, 6.02650,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2921, -2244.16528, 2278.70093, 7.48697,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3594, -2241.41602, 2298.34668, 8.41581,   -5.40000, 0.54000, -136.56001);

	// Bayside gas
	CreateDynamicObject(12853, -2286.50903, 2401.48828, 5.80955,   0.00000, 0.00000, 223.80006);
	CreateDynamicObject(1686, -2281.37183, 2412.16577, 3.93802,   0.00000, 0.00000, 223.80009);
	CreateDynamicObject(1686, -2282.46289, 2413.29517, 3.93802,   0.00000, 0.00000, 223.80009);
	CreateDynamicObject(1686, -2275.49023, 2405.98853, 3.93802,   0.00000, 0.00000, 223.80009);
	CreateDynamicObject(1686, -2274.47705, 2404.80591, 3.93802,   0.00000, 0.00000, 223.80009);
	new gas = CreateDynamicObject(19906, -2286.32104, 2408.06055, 7.33867,   0.00000, 0.00000, 313.91989);
    SetDynamicObjectMaterial(gas, 0, 13296, "sw_roadgas", "sw_wind16", 0xFFFFFFFF);


	// Bayside FD

	CreateDynamicObject(1227, -2513.27563, 2349.98169, 4.75781,   356.85840, 0.00000, 90.04922);
	CreateDynamicObject(1227, -2513.25415, 2354.03247, 4.75781,   356.85840, 0.00000, 90.04922);
	CreateDynamicObject(1440, -2512.93896, 2366.24219, 4.39063,   356.85840, 0.00000, 108.56161);
	CreateDynamicObject(1635, -2513.34229, 2360.58911, 10.23850,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(11245, -2514.29639, 2347.46167, 10.77203,   0.00000, 0.00000, -84.59999);
	CreateDynamicObject(11245, -2538.15063, 2347.43701, 10.77203,   0.00000, 0.00000, -84.59999);
	CreateDynamicObject(2614, -2526.25781, 2346.94702, 10.57649,   0.00000, 0.00000, 0.00000);
	new fdground = CreateDynamicObject(19545, -2550.78882, 2372.33154, 4.03144,   0.10000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdground, 0, 8401, "vgshpground", "ap_tarmac", 0xFFFFFFFF);
	new fdground1 = CreateDynamicObject(19545, -2540.07886, 2372.34253, 4.04180,   0.10000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdground1, 0, 8401, "vgshpground", "ap_tarmac", 0xFFFFFFFF);
	new fdground2 = CreateDynamicObject(19545, -2525.12158, 2372.33496, 4.04184,   0.10000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdground2, 0, 8401, "vgshpground", "ap_tarmac", 0xFFFFFFFF);
	new fdground3 = CreateDynamicObject(19545, -2510.13379, 2372.29517, 4.04180,   0.10000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdground3, 0, 8401, "vgshpground", "ap_tarmac", 0xFFFFFFFF);
	new fdwall1 = CreateDynamicObject(18980, -2538.12817, 2347.45264, -0.46595,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall1, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
	new fdwall2 = CreateDynamicObject(18980, -2530.21216, 2347.47266, -4.57590,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall2, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
	new fdwall3 = CreateDynamicObject(18980, -2522.30176, 2347.47266, -4.57590,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall3, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
	new fdwall4 = CreateDynamicObject(18980, -2514.3953, 2347.4700, -0.4662,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall4, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
	new fdwall5 = CreateDynamicObject(19454, -2525.75708, 2347.0815, 10.2909,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(fdwall5, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
	new fdwall6 = CreateDynamicObject(19454, -2533.79077, 2347.06201, 10.2909,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(fdwall6, 0, 8839, "vgsecarshow", "marinawindow1_256", 0xFFFFFFFF);
	new fdwall7 = CreateDynamicObject(19454, -2518.7729, 2347.06201, 10.2909,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(fdwall7, 0, 8839, "vgsecarshow", "marinawindow1_256", 0xFFFFFFFF);
	new fdwall8 = CreateDynamicObject(18980, -2545.12915, 2347.47266, -4.57590,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall8, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
	new fdwall9 = CreateDynamicObject(19362, -2543.09619, 2347.06348, 5.67380,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(fdwall9, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
	new fdwall10 = CreateDynamicObject(19362, -2540.14990, 2347.06299, 5.67380,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(fdwall10, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
	new fdwall11 = CreateDynamicObject(19362, -2540.09009, 2347.08374, 6.44672,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(fdwall11, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
	new fdwall12 = CreateDynamicObject(19362, -2541.99146, 2347.06738, 6.07217,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(fdwall12, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
	new fdwall13 = CreateDynamicObject(18980, -2526.12354, 2347.25391, 8.41080,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall13, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
	new fdwall14 = CreateDynamicObject(18762, -2543.0161, 2347.4732, 7.7962,   0.00000, 82.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall14, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
	new fdwall15 = CreateDynamicObject(18762, -2540.80103, 2347.47266, 8.10700,   0.00000, 82.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall15, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
	new fdwall16 = CreateDynamicObject(19454, -2538.52612, 2351.81323, 10.29090,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall16, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
	new fdwall18 = CreateDynamicObject(18980, -2545.12915, 2356.13989, -4.57590,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall18, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
	new fdwall19 = CreateDynamicObject(19377, -2545.5313, 2351.8079, 2.6740,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall19, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
	new fdwall20 = CreateDynamicObject(18762, -2543.05859, 2356.14038, 7.79620,   0.00000, 82.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall20, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
	new fdwall21 = CreateDynamicObject(18762, -2540.84058, 2356.14063, 8.10700,   0.00000, 82.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall21, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
	new fdwall22 = CreateDynamicObject(18980, -2545.1292, 2356.1399, -4.5759,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdwall22, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
    new fdwall23 = CreateDynamicObject(19362, -2543.09619, 2356.54858, 5.67380,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdwall23, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
    new fdwall24 = CreateDynamicObject(19362, -2541.99146, 2356.54761, 6.07220,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdwall24, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
    new fdwall25 = CreateDynamicObject(19362, -2540.14990, 2356.54810, 5.67380,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdwall25, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
    new fdwall26 = CreateDynamicObject(19362, -2540.07031, 2356.54712, 6.44670,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdwall26, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
    new fdwall27 = CreateDynamicObject(19377, -2538.52612, 2361.44604, 6.79100,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdwall27, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
    new fdwall28 = CreateDynamicObject(18980, -2538.10815, 2367.82275, -0.36310,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdwall28, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
	new fdwall29 = CreateDynamicObject(19377, -2538.52563, 2362.50610, 6.79100,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdwall29, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
    new fdwall30 = CreateDynamicObject(19377, -2513.99878, 2351.96582, 6.79100,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdwall30, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
    new fdwall31 = CreateDynamicObject(18762, -2538.33765, 2358.96753, 8.41080,   0.00000, 90.00000, 90.00000);
    SetDynamicObjectMaterial(fdwall31, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
    new fdwall32 = CreateDynamicObject(18762, -2538.33789, 2363.90869, 8.41080,   0.00000, 90.00000, 90.00000);
    SetDynamicObjectMaterial(fdwall32, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
    new fdwall33 = CreateDynamicObject(18762, -2538.33765, 2365.80371, 8.41080,   0.00000, 90.00000, 90.00000);
    SetDynamicObjectMaterial(fdwall33, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
    new fdwall34 = CreateDynamicObject(18980, -2514.39526, 2367.82275, -0.36310,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdwall34, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
    new fdwall35 = CreateDynamicObject(19377, -2513.9995, 2362.6445, 6.7910,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdwall35,  0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
    new fdwall36 = CreateDynamicObject(19377, -2513.9988, 2361.5884, 6.7910,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdwall36,  0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
    new fdwall37 = CreateDynamicObject(18762, -2514.11890, 2350.25562, 8.41080,   0.00000, 90.00000, 90.00000);
    SetDynamicObjectMaterial(fdwall37, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
    new fdwall38 = CreateDynamicObject(18762, -2514.11890, 2355.24683, 8.41080,   0.00000, 90.00000, 90.00000);
    SetDynamicObjectMaterial(fdwall38, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
    new fdwall39 = CreateDynamicObject(18762, -2514.11890, 2360.21753, 8.41080,   0.00000, 90.00000, 90.00000);
    SetDynamicObjectMaterial(fdwall39, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
    new fdwall40 = CreateDynamicObject(18762, -2514.11890, 2365.17749, 8.41080,   0.00000, 90.00000, 90.00000);
    SetDynamicObjectMaterial(fdwall40, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
    new fdwall41 = CreateDynamicObject(18762, -2514.11841, 2365.81470, 8.41080,   0.00000, 90.00000, 90.00000);
    SetDynamicObjectMaterial(fdwall41, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
    new fdwall42 = CreateDynamicObject(19377, -2519.66284, 2368.23193, 6.79100,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdwall42, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
    new fdwall43 = CreateDynamicObject(19377, -2529.28223, 2368.23193, 6.79100,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdwall43, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
    new fdwall44 = CreateDynamicObject(19377, -2532.87061, 2368.23169, 6.79100,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdwall44, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
	new fdwall45 = CreateDynamicObject(18762, -2545.14673, 2350.44946, 7.37300,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(fdwall45, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
	new fdwall46 = CreateDynamicObject(18762, -2545.14624, 2353.54517, 7.37300,   0.00000, 90.00000, 90.00000);
	SetDynamicObjectMaterial(fdwall46, 0, 5717, "sunrise11_lawn", "whiteconc01", 0xFFFFFFFF);
	new fdwall47 = CreateDynamicObject(19454, -2514.00000, 2352.54175, 11.01010,   9.10000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall47, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
	new fdwall48 = CreateDynamicObject(19454, -2514.00000, 2363.26611, 11.00380,   -9.10000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall48, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
	new fdwall49 = CreateDynamicObject(19369, -2514.00342, 2358.04248, 11.63008,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall49, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
	new fdwall50 = CreateDynamicObject(19454, -2538.51001, 2363.26611, 11.00380,   -9.10000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall50, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
	new fdwall51 = CreateDynamicObject(19454, -2538.51001, 2352.54175, 11.01010,   9.10000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall51, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);
	new fdwall52 = CreateDynamicObject(19369, -2538.50952, 2358.04248, 11.63010,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdwall52, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xFFFFFFFF);

	// FD Doors
	CreateDynamicObject(1569, -2537.69019, 2354.53345, 4.00550,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1569, -2537.69336, 2357.49878, 4.00550,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(11710, -2537.59790, 2356.00659, 6.66467,   0.00000, 0.00000, 90.00000);
	new fddoor4 = CreateDynamicObject(19860, -2542.41846, 2346.97388, 5.22742,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fddoor4, 0, 12923, "sw_block05", "sw_waredoor", 0xFFFFFFFF);

	//FD Do not
	new park1 = CreateDynamicObject(11313, -2518.35596, 2345.42700, 3.95793,   0.10000, 89.88000, 90.00000);
	SetDynamicObjectMaterial(park1, 0, 10778, "airportcpark_sfse", "ws_carpark3", 0xFFFFFFFF);
	new park2 = CreateDynamicObject(11313, -2526.27783, 2345.44409, 3.95793,   0.10000, 89.88000, 90.00000);
	SetDynamicObjectMaterial(park2, 0, 10778, "airportcpark_sfse", "ws_carpark3", 0xFFFFFFFF);
	new park3 = CreateDynamicObject(11313, -2534.17090, 2345.45044, 3.95793,   0.10000, 89.88000, 90.00000);
    SetDynamicObjectMaterial(park3, 0, 10778, "airportcpark_sfse", "ws_carpark3", 0xFFFFFFFF);

	// FD Roof
	new fdroof1 = CreateDynamicObject(19380, -2534.54443, 2351.45459, 12.6710,   9.10000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(fdroof1, 0, 11631, "mp_ranchcut", "mpCJ_Black_metal", 0xFFFFFFFF);
	new fdroof2 = CreateDynamicObject(19380, -2524.08813, 2351.45459, 12.6710,   9.10000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(fdroof2, 0, 11631, "mp_ranchcut", "mpCJ_Black_metal", 0xFFFFFFFF);
	new fdroof3 = CreateDynamicObject(19380, -2517.99951, 2351.45459, 12.6710,   9.10000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(fdroof3, 0, 11631, "mp_ranchcut", "mpCJ_Black_metal", 0xFFFFFFFF);
	new fdroof4 = CreateDynamicObject(19380, -2541.84570, 2351.77271, 8.50391,   8.00000, 90.00000, -90.00000);
	SetDynamicObjectMaterial(fdroof4, 0, 11631, "mp_ranchcut", "mpCJ_Black_metal", 0xFFFFFFFF);
	new fdroof5 = CreateDynamicObject(19447, -2517.56714, 2357.94775, 13.43050,   0.00000, 90.00000, 90.00000);
    SetDynamicObjectMaterial(fdroof5, 0, 11631, "mp_ranchcut", "mpCJ_Black_metal", 0xFFFFFFFF);
    new fdroof6 = CreateDynamicObject(19447, -2525.37549, 2357.94775, 13.43000,   0.00000, 90.00000, 90.00000);
    SetDynamicObjectMaterial(fdroof6, 0, 11631, "mp_ranchcut", "mpCJ_Black_metal", 0xFFFFFFFF);
    new fdroof7 = CreateDynamicObject(19447, -2534.97803, 2357.94775, 13.43000,   0.00000, 90.00000, 90.00000);
    SetDynamicObjectMaterial(fdroof7, 0, 11631, "mp_ranchcut", "mpCJ_Black_metal", 0xFFFFFFFF);
    new fdroof8 = CreateDynamicObject(19380, -2534.54443, 2364.43774, 12.67100,   9.10000, 90.00000, 180.00000);
    SetDynamicObjectMaterial(fdroof8, 0, 11631, "mp_ranchcut", "mpCJ_Black_metal", 0xFFFFFFFF);
    new fdroof9 = CreateDynamicObject(19380, -2524.08813, 2364.43774, 12.67100,   9.10000, 90.00000, 180.00000);
    SetDynamicObjectMaterial(fdroof9, 0, 11631, "mp_ranchcut", "mpCJ_Black_metal", 0xFFFFFFFF);
    new fdroof10 = CreateDynamicObject(19380, -2517.99951, 2364.43774, 12.67140,   9.10000, 90.00000, 180.00000);
    SetDynamicObjectMaterial(fdroof10, 0, 11631, "mp_ranchcut", "mpCJ_Black_metal", 0xFFFFFFFF);

	// FD ceiling
	new ceiling1 = CreateDynamicObject(19379, -2532.76855, 2352.38916, 8.96930,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(ceiling1, 0, 3975, "lanbloke", "ceiling_256", 0xFFFFFFFF);
	new ceiling2 = CreateDynamicObject(19379, -2532.76855, 2361.99243, 8.96930,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(ceiling2, 0, 3975, "lanbloke", "ceiling_256", 0xFFFFFFFF);
    new ceiling4 = CreateDynamicObject(19379, -2522.30103, 2352.38916, 8.96960,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(ceiling4, 0, 3975, "lanbloke", "ceiling_256", 0xFFFFFFFF);
    new ceiling5 = CreateDynamicObject(19379, -2522.30103, 2361.99243, 8.96700,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(ceiling5, 0, 3975, "lanbloke", "ceiling_256", 0xFFFFFFFF);
    new ceiling7 = CreateDynamicObject(19379, -2519.34302, 2352.38916, 8.97000,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(ceiling7, 0, 3975, "lanbloke", "ceiling_256", 0xFFFFFFFF);
    new ceiling8 = CreateDynamicObject(19379, -2519.3430, 2361.9924, 8.9693,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(ceiling8, 0, 3975, "lanbloke", "ceiling_256", 0xFFFFFFFF);

    //FD int
    CreateDynamicObject(19815, -2525.67651, 2366.78931, 5.91142,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19899, -2522.43042, 2366.33545, 4.00941,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(19900, -2529.60254, 2351.99731, 3.99076,   0.00000, 0.00000, 38.81999);
    CreateDynamicObject(18608, -2526.79395, 2361.59253, 9.70760,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(18608, -2526.79395, 2352.80469, 9.70760,   0.00000, 0.00000, 90.00000);
    CreateDynamicObject(941, -2526.02368, 2366.12744, 4.49975,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(1211, -2513.60498, 2346.62109, 4.35012,   0.00000, 0.00000, 26.70000);
    new fdint1 = CreateDynamicObject(19908, -2537.69922, 2350.63965, 6.43240,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdint1, 0, 4032, "lanpolicecp", "poundwall1_sfe", 0xFFFFFFFF);
    new fdint2 = CreateDynamicObject(19908, -2537.69922, 2356.01807, 6.43240,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdint2, 0, 4032, "lanpolicecp", "poundwall1_sfe", 0xFFFFFFFF);
	new fdint3 = CreateDynamicObject(19908, -2537.69922, 2361.41992, 6.43240,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdint3, 0, 4032, "lanpolicecp", "poundwall1_sfe", 0xFFFFFFFF);
	new fdint4 = CreateDynamicObject(19908, -2537.69971, 2365.31836, 6.43240,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdint4, 0, 4032, "lanpolicecp", "poundwall1_sfe", 0xFFFFFFFF);
	new fdint5 = CreateDynamicObject(19908, -2535.15576, 2366.83740, 6.43240,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(fdint5, 0, 4032, "lanpolicecp", "poundwall1_sfe", 0xFFFFFFFF);
	new fdint6 = CreateDynamicObject(19908, -2529.75952, 2366.83740, 6.43240,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(fdint6, 0, 4032, "lanpolicecp", "poundwall1_sfe", 0xFFFFFFFF);
	new fdint7 = CreateDynamicObject(19908, -2524.35889, 2366.83740, 6.43240,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(fdint7, 0, 4032, "lanpolicecp", "poundwall1_sfe", 0xFFFFFFFF);
	new fdint8 = CreateDynamicObject(19908, -2518.95996, 2366.83740, 6.43240,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(fdint8, 0, 4032, "lanpolicecp", "poundwall1_sfe", 0xFFFFFFFF);
	new fdint9 = CreateDynamicObject(19908, -2514.83496, 2350.66016, 6.43240,   0.00000, 0.00000, 180.00000);
	SetDynamicObjectMaterial(fdint9, 0, 4032, "lanpolicecp", "poundwall1_sfe", 0xFFFFFFFF);
	new fdint10 = CreateDynamicObject(19908, -2514.83496, 2356.06006, 6.43240,   0.00000, 0.00000, 180.00000);
    SetDynamicObjectMaterial(fdint10, 0, 4032, "lanpolicecp", "poundwall1_sfe", 0xFFFFFFFF);
    new fdint11 = CreateDynamicObject(19908, -2514.83496, 2361.41992, 6.43240,   0.00000, 0.00000, 180.00000);
    SetDynamicObjectMaterial(fdint11, 0, 4032, "lanpolicecp", "poundwall1_sfe", 0xFFFFFFFF);
    new fdint12 = CreateDynamicObject(19908, -2514.8345, 2365.31836, 6.43240,   0.00000, 0.00000, 180.00000);
    SetDynamicObjectMaterial(fdint12, 0, 4032, "lanpolicecp", "poundwall1_sfe", 0xFFFFFFFF);
    new fdint13 = CreateDynamicObject(19908, -2516.89404, 2366.83789, 6.43240,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdint13, 0, 4032, "lanpolicecp", "poundwall1_sfe", 0xFFFFFFFF);

    // Bayside Fire Interior
	CreateDynamicObject(1569, -2587.64551, 4006.66724, 2000.26172,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1569, -2587.65039, 4009.65723, 2000.26172,   0.00000, 0.00000, -90.00000);
    CreateDynamicObject(8614, -2596.42822, 4008.71680, 2002.48303,   0.00000, 0.00000, 0.00000);
    // Floor //
    new fdfloor1 = CreateDynamicObject(19379, -2602.33691, 4012.62061, 2003.63428,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(fdfloor1, 0, 3975, "lanbloke", "p_floor3", 0xFFFFFFFF);
    new fdfloor2 = CreateDynamicObject(19379, -2582.27441, 4004.83325, 2003.63391,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(fdfloor2, 0, 3975, "lanbloke", "p_floor3", 0xFFFFFFFF);
    new fdfloor3 = CreateDynamicObject(19379, -2592.76147, 4014.43970, 2003.63391,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(fdfloor3, 0, 3975, "lanbloke", "p_floor3", 0xFFFFFFFF);
    new fdfloor4 = CreateDynamicObject(19379, -2582.27441, 4014.43970, 2003.63391,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(fdfloor4, 0, 3975, "lanbloke", "p_floor3", 0xFFFFFFFF);
    new fdfloor5 = CreateDynamicObject(19379, -2571.78491, 4004.83325, 2003.63391,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(fdfloor5, 0, 3975, "lanbloke", "p_floor3", 0xFFFFFFFF);
    new fdfloor6 = CreateDynamicObject(19379, -2571.78491, 4014.43970, 2003.63391,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(fdfloor6, 0, 3975, "lanbloke", "p_floor3", 0xFFFFFFFF);
    new fdfloor7 = CreateDynamicObject(19379, -2592.73291, 4004.97803, 2000.17200,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(fdfloor7, 0, 10789, "xenon_sfse", "newgrnd1brn_128", 0xFFFFFFFF);
    // Ceiling //
    new fdintceiling1 = CreateDynamicObject(19378, -2592.58105, 4002.99634, 2003.63306,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(fdintceiling1, 0, 11301, "carshow_sfse", "ws_officy_ceiling", 0xFFFFFFFF);
    new fdintceiling2 = CreateDynamicObject(19378, -2592.76733, 4012.50635, 2007.13452,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(fdintceiling2, 0, 11301, "carshow_sfse", "ws_officy_ceiling", 0xFFFFFFFF);
    new fdintceiling3 = CreateDynamicObject(19378, -2603.26270, 4012.50635, 2007.13452,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(fdintceiling3, 0, 11301, "carshow_sfse", "ws_officy_ceiling", 0xFFFFFFFF);
    new fdintceiling4 = CreateDynamicObject(19378, -2582.27441, 4004.83325, 2007.13452,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(fdintceiling4, 0, 11301, "carshow_sfse", "ws_officy_ceiling", 0xFFFFFFFF);
    new fdintceiling5 = CreateDynamicObject(19378, -2582.27441, 4014.43970, 2007.13452,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(fdintceiling5, 0, 11301, "carshow_sfse", "ws_officy_ceiling", 0xFFFFFFFF);
    new fdintceiling6 = CreateDynamicObject(19378, -2571.78491, 4014.43970, 2007.13452,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(fdintceiling6, 0, 11301, "carshow_sfse", "ws_officy_ceiling", 0xFFFFFFFF);
    new fdintceiling7 = CreateDynamicObject(19378, -2571.78491, 4004.83325, 2007.13452,   0.00000, 90.00000, 0.00000);
    SetDynamicObjectMaterial(fdintceiling7, 0, 11301, "carshow_sfse", "ws_officy_ceiling", 0xFFFFFFFF);
    // Walls //
    new fdintwall = CreateDynamicObject(19377, -2587.58545, 4004.97632, 2005.28381,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdintwall, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
    new fdintwall1 = CreateDynamicObject(19377, -2592.44507, 4009.70581, 2005.27271,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdintwall1, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
    new fdintwall2 = CreateDynamicObject(19454, -2597.19067, 4004.97485, 2001.80542,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdintwall2, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
    new fdintwall3 = CreateDynamicObject(19454, -2592.31030, 4000.24292, 2001.80542,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(fdintwall3, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	new fdintwall4 = CreateDynamicObject(19454, -2592.33130, 4007.73364, 2005.29565,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(fdintwall4, 0, 9361, "sfn_office", "law_gazwhite1", 0xFFFFFFFF);
    new fdintwall5 = CreateDynamicObject(19454, -2601.95605, 4007.73364, 2005.29565,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdintwall5, 0, 9361, "sfn_office", "law_gazwhite1", 0xFFFFFFFF);
    new fdintwall6 = CreateDynamicObject(19454, -2600.50269, 4012.62964, 2005.29565,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdintwall6, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
    new fdintwall7 = CreateDynamicObject(19454, -2595.67212, 4017.35352, 2005.29565,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdintwall7, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
    new fdintwall8 = CreateDynamicObject(19454, -2586.04517, 4017.35352, 2005.29565,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdintwall8, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
    new fdintwall9 = CreateDynamicObject(19454, -2576.41650, 4017.35352, 2005.29565,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdintwall9, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
    new fdintwall10 = CreateDynamicObject(19454, -2566.79248, 4017.35352, 2005.29565,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdintwall10, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
    new fdintwall11 = CreateDynamicObject(19454, -2582.69849, 4000.25757, 2005.29565,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdintwall11, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
    new fdintwall12 = CreateDynamicObject(19454, -2573.08032, 4000.25757, 2005.29565,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdintwall12, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
    new fdintwall13 = CreateDynamicObject(19454, -2563.45288, 4000.25757, 2005.29565,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdintwall13, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
    new fdintwall14 = CreateDynamicObject(19454, -2566.46411, 4005.14453, 2005.29565,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdintwall14, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
    new fdintwall15 = CreateDynamicObject(19454, -2566.46411, 4014.77856, 2005.29565,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdintwall15, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
    new fdintwall16 = CreateDynamicObject(19391, -2587.58667, 4013.44971, 2005.46118,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdintwall16, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
    new fdintwall17 = CreateDynamicObject(19362, -2587.58618, 4016.65308, 2005.46973,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdintwall17, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
    new fdintwall18 = CreateDynamicObject(19362, -2587.58618, 4010.34424, 2005.46973,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdintwall18, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
    new fdintwall19 = CreateDynamicObject(19362, -2600.20239, 4017.33179, 2005.29480,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdintwall19, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
    new fdintwall20 = CreateDynamicObject(19383, -2596.37793, 4003.74438, 2001.99512,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdintwall20, 0, 9361, "sfn_office", "law_gazwhite1", 0xFFFFFFFF);
    new fdintwall21 = CreateDynamicObject(19454, -2592.31030, 4000.26294, 2001.80542,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdintwall21, 0, 9361, "sfn_office", "law_gazwhite1", 0xFFFFFFFF);
    new fdintwall22 = CreateDynamicObject(19377, -2587.60547, 4004.97632, 2005.28381,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdintwall22, 0, 9361, "sfn_office", "law_gazwhite1", 0xFFFFFFFF);
	new fdintwall23 = CreateDynamicObject(19453, -2592.44507, 4009.68579, 2001.80542,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(fdintwall23, 0, 9361, "sfn_office", "law_gazwhite1", 0xFFFFFFFF);
	new fdintwall24 = CreateDynamicObject(19453, -2597.17065, 4004.97485, 2001.80542,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(fdintwall24, 0, 9361, "sfn_office", "law_gazwhite1", 0xFFFFFFFF);
	new fdintwall25 = CreateDynamicObject(19453, -2592.43994, 4009.68579, 2005.29163,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(fdintwall25, 0, 9361, "sfn_office", "law_gazwhite1", 0xFFFFFFFF);
    new fdintwindow1 = CreateDynamicObject(19455, -2570.13916, 4000.26880, 2005.29565,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdintwindow1, 0, 8839, "vgsecarshow", "marinawindow1_256", 0xFFFFFFFF);
    new fdintwindow2 = CreateDynamicObject(19455, -2584.27954, 4000.27637, 2005.29565,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdintwindow2, 0, 8839, "vgsecarshow", "marinawindow1_256", 0xFFFFFFFF);

    // Objects //
    CreateDynamicObject(14720, -2566.99634, 4015.76904, 2003.72620,   0.00000, 0.00000, 180.00000);
    CreateDynamicObject(19466, -2571.57251, 4015.18384, 2004.45154,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19466, -2571.57251, 4017.42480, 2004.45154,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2637, -2567.66333, 4010.11670, 2004.11926,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2637, -2571.52588, 4010.11670, 2004.11926,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2637, -2567.66333, 4006.81665, 2004.11926,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2637, -2571.52588, 4006.81665, 2004.11926,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1811, -2567.02563, 4007.40381, 2004.24866,   0.00000, 0.00000, 83.81999);
	CreateDynamicObject(1811, -2568.03687, 4007.64722, 2004.24866,   0.00000, 0.00000, 106.74000);
	CreateDynamicObject(1811, -2566.99316, 4005.83276, 2004.24866,   0.00000, 0.00000, 275.28021);
	CreateDynamicObject(1811, -2568.13623, 4005.87500, 2004.24866,   0.00000, 0.00000, 261.42007);
	CreateDynamicObject(1811, -2572.04395, 4006.38745, 2004.24866,   0.00000, 0.00000, 270.83972);
	CreateDynamicObject(1811, -2570.91333, 4006.39453, 2004.24866,   0.00000, 0.00000, 273.60019);
	CreateDynamicObject(1811, -2570.68188, 4007.76660, 2004.24866,   0.00000, 0.00000, 69.30000);
	CreateDynamicObject(1811, -2572.10840, 4007.88892, 2004.24866,   0.00000, 0.00000, 105.54002);
	CreateDynamicObject(1811, -2570.57617, 4009.25024, 2004.24866,   0.00000, 0.00000, -79.20000);
	CreateDynamicObject(1811, -2572.03442, 4009.68140, 2004.24866,   0.00000, 0.00000, -97.07999);
	CreateDynamicObject(1811, -2572.15405, 4011.16357, 2004.24866,   0.00000, 0.00000, -235.08003);
	CreateDynamicObject(1811, -2570.86304, 4011.23804, 2004.24866,   0.00000, 0.00000, -306.41998);
	CreateDynamicObject(1811, -2568.23315, 4010.60913, 2004.24866,   0.00000, 0.00000, -267.78003);
	CreateDynamicObject(1811, -2567.05322, 4011.18042, 2004.24866,   0.00000, 0.00000, -246.12001);
	CreateDynamicObject(1811, -2566.94922, 4009.20215, 2004.24866,   0.00000, 0.00000, -83.69999);
	CreateDynamicObject(1811, -2567.95679, 4009.35034, 2004.24866,   0.00000, 0.00000, -102.17997);
	CreateDynamicObject(1723, -2578.27734, 4014.79736, 2003.71924,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1723, -2572.12134, 4016.80957, 2003.71924,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1723, -2574.18774, 4012.71558, 2003.71924,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19786, -2575.13672, 4017.34009, 2005.71350,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2319, -2575.87524, 4015.58838, 2003.65674,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(950, -2587.82593, 4011.29858, 2004.20715,   0.00000, 0.00000, 90.06000);
	CreateDynamicObject(1796, -2585.86401, 4000.72314, 2003.69836,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1796, -2583.52637, 4000.72314, 2003.69836,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1796, -2583.32642, 4007.86572, 2003.69836,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2346, -2585.03223, 4003.76147, 2003.72168,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2346, -2584.03027, 4004.88550, 2003.72168,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1796, -2585.63403, 4007.86572, 2003.69836,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1796, -2579.96411, 4007.86572, 2003.69836,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2346, -2578.37085, 4004.88550, 2003.72168,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1796, -2577.70288, 4007.86572, 2003.69836,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1796, -2577.90259, 4000.72314, 2003.69836,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1796, -2580.20898, 4000.72314, 2003.69836,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2346, -2579.51929, 4003.70923, 2003.72168,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -2580.85889, 4009.71680, 2005.56970,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19325, -2575.06665, 4003.55981, 2005.56970,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19325, -2587.50195, 4009.71680, 2005.56970,   0.00000, 0.00000, 90.00000);
	new bed1 = CreateDynamicObject(19362, -2582.76025, 4003.14868, 2003.22119,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bed1, 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF);
	new bed2 = CreateDynamicObject(19362, -2582.76074, 4005.42139, 2003.22058,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bed2, 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF);
	new bed3 = CreateDynamicObject(19362, -2584.43994, 4004.29419, 2003.22119,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(bed3, 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF);
	new bed4 = CreateDynamicObject(19362, -2577.11450, 4005.42139, 2003.22058,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bed4, 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF);
	new bed5 = CreateDynamicObject(19362, -2577.11401, 4003.14868, 2003.22156,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bed5, 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF);
	new bed6 = CreateDynamicObject(19362, -2578.70190, 4004.29419, 2003.21997,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(bed6, 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF);
	new bed7 = CreateDynamicObject(19362, -2579.12231, 4004.29468, 2003.22083,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(bed7, 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF);
	new bed8 = CreateDynamicObject(19362, -2586.44507, 4005.42139, 2003.22058,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bed8, 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF);
	new bed9 = CreateDynamicObject(19362, -2586.44507, 4003.14868, 2003.22119,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bed9, 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF);
	new bed10 = CreateDynamicObject(19362, -2584.88159, 4004.29468, 2003.22083,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(bed10, 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF);
	new bed11 = CreateDynamicObject(19362, -2580.79492, 4005.42139, 2003.22058,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bed11, 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF);
	new bed12 = CreateDynamicObject(19362, -2580.79443, 4003.14868, 2003.22156,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bed12, 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF);
	new bed13 = CreateDynamicObject(19454, -2582.7253, 4009.6384, 2003.2208,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(bed13, 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF);
	new bed14 = CreateDynamicObject(19454, -2575.10547, 4001.81079, 2003.22083,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bed14, 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF);
	new pilar1 = CreateDynamicObject(18980, -2575.51245, 4007.10010, 2003.72046,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(pilar1, 0, 9241, "sfn_helipad", "helipad_grey1", 0xFFFFFFFF);
	new pilar2 = CreateDynamicObject(18980, -2577.64722, 4009.22949, 2003.72046,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(pilar2, 0, 9241, "sfn_helipad", "helipad_grey1", 0xFFFFFFFF);
    new beddoor = CreateDynamicObject(19391, -2576.51733, 4008.21460, 2005.46118,   0.00000, 0.00000, 45.78000);
    SetDynamicObjectMaterial(beddoor, 0, 3267, "milbase", "midgrey64", 0xFFFFFFFF);
    new fdkitchen = CreateDynamicObject(19362, -2571.54517, 4015.66479, 2002.99646,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdkitchen, 0, 8399, "vgs_shops", "vgsclubwall05_128", 0xFFFFFFFF);
    CreateDynamicObject(1502, -2577.10229, 4008.73145, 2003.71997,   0.00000, 0.00000, -44.57998);
    CreateDynamicObject(1537, -2593.06885, 4000.36768, 2000.26001,   0.00000, 0.00000, 180.00000);
   	CreateDynamicObject(11729, -2596.21484, 4016.94775, 2003.72070,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(11729, -2596.72241, 4016.94775, 2003.72070,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(11729, -2596.21484, 4016.26538, 2003.72070,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(11729, -2596.21484, 4013.19849, 2003.72070,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2319, -2596.47339, 4013.95117, 2003.56030,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(11729, -2596.21484, 4012.51587, 2003.72070,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(11729, -2596.72241, 4016.26538, 2003.72070,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(11729, -2596.72241, 4013.19849, 2003.72070,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(11729, -2596.72241, 4012.51587, 2003.72070,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(11729, -2593.33252, 4016.26538, 2003.72070,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(11729, -2593.83960, 4016.26538, 2003.72070,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(11729, -2593.83960, 4016.94775, 2003.72070,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(11729, -2593.83960, 4013.19849, 2003.72070,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(11729, -2593.83960, 4012.51587, 2003.72070,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(11729, -2593.33252, 4016.94775, 2003.72070,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(11729, -2593.33252, 4013.19849, 2003.72070,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(11729, -2593.33252, 4012.51587, 2003.72070,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2319, -2593.55249, 4013.95117, 2003.56030,   0.00000, 0.00000, 90.00000);

	// Lokcer walls//
	CreateDynamicObject(19438, -2593.57153, 4012.07129, 2005.43347,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19438, -2596.43677, 4012.10474, 2005.43347,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19457, -2591.04443, 4016.84009, 2005.44287,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19457, -2598.54980, 4016.84619, 2005.44287,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(19457, -2595.93262, 4017.34668, 2005.44287,   0.00000, 0.00000, 90.00000);

    CreateDynamicObject(1998, -2583.36841, 4016.81494, 2003.72192,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2008, -2587.02417, 4014.75659, 2003.70471,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2356, -2586.40039, 4015.56006, 2003.70105,   0.00000, 0.00000, 57.42001);
	CreateDynamicObject(2356, -2584.33423, 4016.88354, 2003.70105,   0.00000, 0.00000, 177.84007);
	CreateDynamicObject(2008, -2582.38965, 4015.80542, 2003.70471,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2356, -2581.41284, 4016.77295, 2003.70105,   0.00000, 0.00000, 105.36030);
    CreateDynamicObject(1775, -2589.19604, 4016.83813, 2004.82104,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1721, -2587.79443, 4015.74683, 2003.70313,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1721, -2587.79858, 4014.96826, 2003.70313,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2186, -2590.48901, 4014.47461, 2003.72156,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(11706, -2566.84766, 4013.80957, 2003.72180,   0.00000, 0.00000, -52.97999);
	CreateDynamicObject(11706, -2587.18652, 4012.26880, 2003.70593,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1808, -2590.81274, 4013.07056, 2003.72034,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1742, -2566.40894, 4003.13232, 2003.69202,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1723, -2569.87207, 4000.86792, 2003.71887,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1723, -2574.53174, 4002.35327, 2003.71887,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2961, -2577.64014, 4009.72632, 2005.22021,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2961, -2593.65454, 4011.95972, 2005.25684,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11713, -2596.43555, 4012.00952, 2005.08704,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(11713, -2566.57227, 4004.37646, 2004.91675,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2614, -2566.59277, 4008.35474, 2006.01062,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2604, -2592.91699, 4004.11133, 2000.70483,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2604, -2589.25830, 4004.11133, 2000.70483,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19466, -2593.70923, 4003.75586, 2002.75293,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19466, -2591.46802, 4003.75586, 2002.75293,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19466, -2589.22754, 4003.75586, 2002.75293,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19466, -2586.98706, 4003.75586, 2002.75293,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1721, -2590.19360, 4000.45044, 2000.25928,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1721, -2588.82104, 4000.44116, 2000.25928,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1721, -2593.97852, 4000.46094, 2000.25928,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1775, -2596.63745, 4001.57886, 2001.33142,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1721, -2595.14453, 4000.43359, 2000.25928,   0.00000, 0.00000, 0.00000);
    CreateDynamicObject(2614, -2590.5498,  4009.5530,  2002.3672,    0.00000, 6.00000, 0.00000);
    CreateDynamicObject(2011, -2588.08765, 4000.75830, 2000.26050,   0.00000, 0.00000, 36.54000);
    CreateDynamicObject(1892, -2592.8188,  4000.6873,  2000.2605,    0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2202, -2596.63647, 4006.22705, 2000.25903,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2356, -2593.78955, 4006.94995, 2000.25977,   0.00000, 0.00000, -135.59998);
	CreateDynamicObject(2008, -2592.83228, 4007.31958, 2000.27332,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2186, -2582.17920, 4010.22192, 2003.72070,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19172, -2591.78638, 4009.78345, 2005.58752,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1808, -2580.63354, 4009.91992, 2003.72021,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2258, -2582.92456, 4017.24390, 2005.73291,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2257, -2600.37793, 4009.90527, 2005.53943,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2614, -2587.44360, 4004.83130, 2006.01062,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2261, -2589.54932, 4000.84473, 2001.76489,   0.00000, 0.00000, 180.00000);
	CreateObject(2690, -2594.67163, 4000.36890, 2001.46350,   0.00000, 0.00000, 0.00000);
	CreateObject(2690, -2587.75293, 4005.54980, 2001.57947,   0.00000, 0.00000, -90.00000);
	CreateObject(2690, -2587.40771, 4011.08008, 2004.75012,   0.00000, 0.00000, 90.00000);
	CreateObject(2690, -2566.62842, 4012.99707, 2004.93481,   0.00000, 0.00000, -90.00000);
	CreateObject(11710, -2592.32397, 4000.37085, 2002.91980,   0.00000, 0.00000, 0.00000);
	new fdbathroom = CreateDynamicObject(19453, -2600.39160, 4016.85889, 2003.64124,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(fdbathroom, 0, 8390, "vegasemulticar", "Bow_sub_walltiles", 0xFFFFFFFF);
    CreateDynamicObject(1502, -2600.15112, 4012.07837, 2003.71997,   0.00000, 0.00000, 0.00000);
	new fdbathroom1 = CreateDynamicObject(19435, -2600.93506, 4012.12354, 2004.45361,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(fdbathroom1, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	new fdbathroom2 = CreateDynamicObject(19362, -2600.22461, 4012.12354, 2007.94910,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(fdbathroom2, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	new fdbathroom3 = CreateDynamicObject(19457, -2598.56982, 4016.86621, 2005.44287,   0.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(fdbathroom3, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
    new fdbathroom4 = CreateDynamicObject(2255, -2599.91895, 4015.13477, 2005.01953,   0.00000, 0.00000, 90.00000);
    SetDynamicObjectMaterial(fdbathroom4, 0, 1649, "wglass", "carshowwin2", 0xFFFFFFFF);
    CreateDynamicObject(2517, -2599.30127, 4015.78320, 2003.69409,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2528, -2599.13525, 4014.54468, 2003.72949,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2515, -2600.12158, 4015.13403, 2004.69580,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19873, -2598.82129, 4014.17749, 2003.77307,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19873, -2598.74341, 4014.07520, 2003.77307,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19873, -2598.87012, 4014.06519, 2003.77307,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19873, -2598.81152, 4014.13354, 2003.89221,   0.00000, 0.00000, 0.00000);

    // Green Screen
    new gs1 = CreateDynamicObject(19377, -2456.34692, -712.40552, 3000.00000,   0.00000, 90.00000, 90.00000);
    SetDynamicObjectMaterial(gs1, 0, 8839, "vgsecarshow", "lightgreen2_32", 0xFFFFFFFF);
    new gs2 = CreateDynamicObject(19377, -2456.34692, -722.90131, 3000.00000,   0.00000, 90.00000, 90.00000);
    SetDynamicObjectMaterial(gs2, 0, 8839, "vgsecarshow", "lightgreen2_32", 0xFFFFFFFF);
    new gs3 = CreateDynamicObject(19377, -2451.46777, -712.41119, 3004.73413,   90.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(gs3, 0, 8839, "vgsecarshow", "lightgreen2_32", 0xFFFFFFFF);
    new gs4 = CreateDynamicObject(19377, -2451.46777, -722.90131, 3004.73413,   90.00000, 0.00000, 0.00000);
    SetDynamicObjectMaterial(gs4, 0, 8839, "vgsecarshow", "lightgreen2_32", 0xFFFFFFFF);
    new gs5 = CreateDynamicObject(19377, -2465.94580, -712.39441, 3000.00000,   0.00000, 90.00000, 90.00000);
    SetDynamicObjectMaterial(gs5, 0, 8839, "vgsecarshow", "lightgreen2_32", 0xFFFFFFFF);
    new gs6 = CreateDynamicObject(19377, -2465.96631, -722.88171, 3000.00000,   0.00000, 90.00000, 90.00000);
    SetDynamicObjectMaterial(gs6, 0, 8839, "vgsecarshow", "lightgreen2_32", 0xFFFFFFFF);

    // Bayside Construction
	CreateDynamicObject(19975, -1959.08105, 2552.97314, 51.54745,   0.00000, 0.00000, -5.76000);
	CreateDynamicObject(19974, -1921.27527, 2448.21094, 52.87942,   0.00000, 0.00000, 16.20000);
	CreateDynamicObject(19974, -1905.64966, 2453.58081, 52.87942,   0.00000, 0.00000, 16.20000);
	CreateDynamicObject(19987, -1912.72510, 2473.54126, 53.30853,   0.00000, 0.00000, 2.40000);
	CreateDynamicObject(19987, -1928.20410, 2469.00903, 53.30853,   0.00000, 0.00000, 38.40000);
	CreateDynamicObject(19425, -1922.33411, 2483.09619, 53.49012,   0.00000, 0.00000, 21.66001);
	CreateDynamicObject(19951, -1933.27222, 2517.82007, 52.80876,   0.00000, 0.00000, -16.14000);
	CreateDynamicObject(19951, -1938.32703, 2519.55127, 52.68485,   0.00000, 0.00000, -16.14000);
	CreateDynamicObject(19951, -1942.98376, 2522.39111, 52.68615,   0.00000, 0.00000, -16.14000);
	CreateDynamicObject(1422, -1958.31067, 2550.71460, 52.04272,   0.00000, -1.48000, -59.28000);
	CreateDynamicObject(1238, -1959.47253, 2552.36646, 51.93347,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8873, -1947.60718, 2546.40088, 57.92385,   0.00000, 0.00000, -29.27999);
	CreateDynamicObject(8873, -1965.82751, 2568.37280, 56.87931,   0.00000, 0.00000, -159.29993);
	CreateDynamicObject(3865, -1995.46533, 2602.53784, 51.84875,   -2.04000, 0.06000, 33.90000);
	CreateDynamicObject(1422, -2011.05945, 2619.09863, 50.54159,   0.00000, 0.00000, -24.90001);
	CreateDynamicObject(1422, -2014.39404, 2620.30420, 50.54159,   0.00000, 0.00000, -13.32000);
	CreateDynamicObject(1422, -2017.80029, 2620.84668, 50.54159,   0.00000, 0.00000, -3.84000);
	CreateDynamicObject(1422, -2021.32007, 2620.71338, 50.54159,   0.00000, 0.00000, 7.50000);
	CreateDynamicObject(1238, -1959.76843, 2553.21338, 51.89450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, -1959.09192, 2553.07617, 51.93790,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, -2006.88306, 2608.47974, 50.31852,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, -2006.08911, 2608.54126, 50.31852,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, -2005.36328, 2608.20874, 50.31852,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, -2022.49231, 2619.97607, 50.46303,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, -2019.60120, 2620.96826, 50.46303,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, -2016.07715, 2620.62061, 50.36406,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, -2012.62488, 2619.79297, 50.28404,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, -2023.01855, 2620.41235, 50.45218,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3567, -1973.88416, 2578.88599, 51.51495,   -1.00000, 0.00000, 46.68000);
	CreateDynamicObject(3626, -1959.12830, 2567.08374, 52.65109,   0.00000, 0.00000, -54.48000);
	CreateDynamicObject(2921, -1957.72803, 2562.59326, 54.06515,   0.00000, 0.00000, 116.57999);
	CreateDynamicObject(19326, -1959.84338, 2565.29321, 53.12354,   0.00000, 25.00000, -54.59999);
	CreateDynamicObject(2714, -1962.56982, 2570.04199, 52.92214,   0.00000, 0.00000, 35.76001);
	CreateDynamicObject(1422, -1956.84473, 2548.12915, 52.13210,   0.00000, -1.48000, -59.28000);
	CreateDynamicObject(1237, -1955.90808, 2546.39331, 51.80181,   0.00000, 0.00000, 27.60000);
	CreateDynamicObject(1422, -1954.87354, 2544.77344, 52.30698,   0.00000, -1.48000, -60.23998);
	CreateDynamicObject(1422, -1932.19202, 2516.46777, 53.32320,   0.00000, -0.50000, -15.24000);
	CreateDynamicObject(1422, -1935.55762, 2517.47144, 53.32320,   0.00000, -0.80000, -18.48000);
	CreateDynamicObject(1422, -1938.79187, 2518.96899, 53.20590,   0.00000, -1.00000, -30.42000);
	CreateDynamicObject(1422, -1941.70325, 2521.14893, 53.12810,   0.00000, -1.00000, -42.41998);
	CreateDynamicObject(1237, -1952.51160, 2540.55688, 52.06968,   0.00000, 0.00000, -55.37999);
	CreateDynamicObject(1237, -1949.23853, 2534.89893, 52.24734,   0.00000, 0.00000, -30.06000);
	CreateDynamicObject(1237, -1946.16492, 2529.24048, 52.43829,   0.00000, 0.00000, 78.84001);
	CreateDynamicObject(1422, -1953.44421, 2542.26709, 52.37189,   0.00000, -1.48000, -60.23998);
	CreateDynamicObject(1422, -1951.54993, 2538.96484, 52.54185,   0.00000, -1.48000, -59.99999);
	CreateDynamicObject(1422, -1950.12622, 2536.53247, 52.62469,   0.00000, -1.48000, -59.63998);
	CreateDynamicObject(1422, -1948.30457, 2533.37524, 52.75134,   0.00000, -1.48000, -60.11998);
	CreateDynamicObject(1422, -1946.95386, 2530.90991, 52.82078,   0.00000, -1.48000, -62.81997);
	CreateDynamicObject(1422, -1945.28125, 2527.65479, 52.99315,   0.00000, -1.48000, -63.89996);
	CreateDynamicObject(1422, -1944.06787, 2525.04639, 53.07312,   0.00000, -1.48000, -67.07998);
	CreateDynamicObject(1237, -1943.25293, 2523.15845, 52.63821,   0.00000, 0.00000, 151.98000);
	CreateDynamicObject(1238, -1933.85535, 2516.90503, 53.33523,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, -1937.28040, 2518.01563, 53.25624,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, -1940.32654, 2519.93530, 53.18075,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, -1920.90027, 2479.25903, 53.49012,   0.00000, 0.00000, 20.22002);
	CreateDynamicObject(19425, -1919.45142, 2475.01440, 53.49012,   0.00000, 0.00000, 18.78002);
	CreateDynamicObject(1422, -1964.63989, 2560.79321, 51.58439,   0.00000, -1.48000, -55.62000);
	CreateDynamicObject(1238, -1963.81177, 2559.29053, 51.69618,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, -1963.63879, 2560.36987, 51.65806,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, -1963.28015, 2559.79077, 51.68203,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1422, -1966.30310, 2563.18433, 51.48876,   0.00000, -1.48000, -56.46001);
	CreateDynamicObject(1237, -1967.42273, 2564.63232, 51.06543,   0.00000, 0.00000, 59.87999);
	CreateDynamicObject(19321, -1977.27612, 2582.16382, 53.82055,   -1.00000, 0.00000, 44.87998);
	CreateDynamicObject(3577, -1969.08679, 2574.37939, 53.20070,   -1.00000, 0.00000, 46.32000);
	CreateDynamicObject(3576, -1972.49036, 2577.46069, 53.92094,   0.00000, -1.00000, -43.56001);
	CreateDynamicObject(1422, -1968.44458, 2566.19556, 51.42699,   0.00000, -1.48000, -54.66000);
	CreateDynamicObject(1422, -1970.08203, 2568.53442, 51.34285,   0.00000, -1.48000, -56.16000);
	CreateDynamicObject(1237, -1971.16357, 2570.02637, 50.72935,   0.00000, 0.00000, 118.37997);
	CreateDynamicObject(1422, -1972.10168, 2571.60229, 51.24918,   0.00000, -2.00000, -58.02000);
	CreateDynamicObject(1422, -1973.63745, 2573.92651, 51.15414,   0.00000, -1.48000, -55.32000);
	CreateDynamicObject(1237, -1974.67383, 2575.38477, 50.67242,   0.00000, 0.00000, 160.55992);
	CreateDynamicObject(1422, -1975.84961, 2576.84595, 51.01981,   0.00000, -1.48000, -51.41999);
	CreateDynamicObject(1422, -1977.67053, 2579.05664, 50.94910,   0.00000, -1.48000, -48.54005);
	CreateDynamicObject(1237, -1978.86401, 2580.36304, 50.46399,   0.00000, 0.00000, 178.13989);
	CreateDynamicObject(1422, -1980.04553, 2581.74707, 50.89096,   0.00000, -1.48000, -49.32005);
	CreateDynamicObject(1422, -1981.88184, 2583.84766, 50.81514,   0.00000, -1.48000, -48.36005);
	CreateDynamicObject(1237, -1983.11780, 2585.20239, 50.31562,   0.00000, 0.00000, 261.35986);
	CreateDynamicObject(1422, -1984.38074, 2586.65186, 50.75111,   0.00000, -1.48000, -48.78005);
	CreateDynamicObject(1422, -1986.23413, 2588.79370, 50.68407,   0.00000, -1.48000, -48.36005);
	CreateDynamicObject(1237, -1987.46826, 2590.17017, 50.19211,   0.00000, 0.00000, 380.69992);
	CreateDynamicObject(1422, -1988.68250, 2591.64038, 50.64865,   0.00000, -1.48000, -49.02005);
	CreateDynamicObject(1422, -1990.59204, 2593.73926, 50.57800,   0.00000, -1.48000, -46.32006);
	CreateDynamicObject(1237, -1991.94800, 2595.22070, 50.06221,   0.00000, 0.00000, 346.14008);
	CreateDynamicObject(1422, -1993.23059, 2596.58423, 50.46469,   0.00000, -0.50000, -43.08010);
	CreateDynamicObject(1422, -1995.32874, 2598.50146, 50.43620,   0.00000, -0.50000, -41.34010);
	CreateDynamicObject(1237, -1996.68909, 2599.70093, 50.05378,   0.00000, 0.00000, 406.55997);
	CreateDynamicObject(1422, -1998.04663, 2600.92578, 50.41747,   0.00000, -0.50000, -40.44010);
	CreateDynamicObject(1422, -2000.18237, 2602.73364, 50.39873,   0.00000, -0.50000, -39.96009);
	CreateDynamicObject(1237, -2001.56079, 2603.88843, 50.05378,   0.00000, 0.00000, 328.38000);
	CreateDynamicObject(1422, -2002.92395, 2605.07471, 50.41979,   0.00000, -0.50000, -40.38010);
	CreateDynamicObject(1422, -2005.12476, 2606.99634, 50.41193,   0.00000, -0.50000, -39.96009);
	CreateDynamicObject(19992, -2015.45898, 2607.41187, 50.03230,   0.00000, 0.00000, 50.87999);
	CreateDynamicObject(19992, -2006.57227, 2617.08911, 50.03230,   0.00000, 0.00000, 85.26000);

	//Scarpyard
	CreateDynamicObject(17064, -1475.33594, 1999.80017, 46.74432,   0.00000, 0.00000, -86.22000);
	CreateDynamicObject(8674, -1498.37415, 1988.48059, 47.90982,   0.00000, 0.00000, 3.30000);
	CreateDynamicObject(8674, -1508.46143, 1986.58118, 48.09431,   0.00000, 2.00000, 17.76000);
	CreateDynamicObject(8674, -1516.07263, 1980.61084, 48.26649,   0.00000, 0.00000, 58.26001);
	CreateDynamicObject(8674, -1500.18213, 1938.54919, 48.44383,   0.00000, 2.00000, 151.20000);
	CreateDynamicObject(8674, -1490.88611, 1934.17566, 49.05597,   0.00000, 5.00000, 158.28008);
	CreateDynamicObject(8674, -1481.02783, 1931.23352, 49.93782,   0.00000, 5.00000, 168.17995);
	CreateDynamicObject(8674, -1470.94727, 1929.67603, 50.55429,   0.00000, 2.00000, 174.24001);
	CreateDynamicObject(10252, -1482.38257, 1989.37280, 47.47441,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10252, -1489.58691, 1987.99756, 47.47438,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(8674, -1518.55212, 1971.04993, 48.26649,   0.00000, 0.00000, 92.70000);
	CreateDynamicObject(8674, -1518.05688, 1960.69849, 48.26649,   0.00000, 0.00000, 92.70000);
	CreateDynamicObject(8674, -1515.84924, 1950.74841, 48.26649,   0.00000, 0.00000, 112.25999);
	CreateDynamicObject(8674, -1509.30408, 1943.49707, 48.26649,   0.00000, 0.00000, 151.98007);
	CreateDynamicObject(8674, -1460.66309, 1928.64722, 50.81940,   0.00000, 1.00000, 174.24001);
	CreateDynamicObject(8674, -1450.34705, 1927.60803, 51.17730,   0.00000, 3.00000, 174.24001);
	CreateDynamicObject(8674, -1440.11145, 1926.56384, 51.54014,   0.00000, 1.00000, 174.24001);
	CreateDynamicObject(8674, -1430.42126, 1928.59485, 51.64193,   0.00000, 0.00000, 209.82008);
	CreateDynamicObject(8674, -1422.90173, 1935.36816, 51.64193,   0.00000, 0.00000, 234.12013);
	CreateDynamicObject(8674, -1418.88794, 1944.64392, 51.55828,   0.00000, -1.00000, 259.32031);
	CreateDynamicObject(8674, -1418.68408, 1954.84827, 51.19878,   0.00000, -3.00000, 278.10019);
	CreateDynamicObject(8674, -1420.49048, 1964.96936, 50.91847,   0.00000, 0.00000, 282.12012);
	CreateDynamicObject(8674, -1424.92627, 1973.93445, 50.65236,   0.00000, -3.00000, 310.14020);
	CreateDynamicObject(8674, -1432.11121, 1981.21606, 49.92135,   0.00000, -5.00000, 319.08020);
	CreateDynamicObject(8674, -1440.05273, 1987.82263, 49.21189,   0.00000, -3.00000, 321.96011);
	CreateDynamicObject(8674, -1449.00732, 1992.67969, 48.66590,   0.00000, -3.00000, 341.16000);
	CreateDynamicObject(8674, -1458.93896, 1996.13794, 48.39355,   0.00000, 0.00000, 341.10013);
	CreateDynamicObject(8674, -1468.95105, 1997.92383, 48.32809,   0.00000, 0.00000, 357.71991);
	CreateDynamicObject(3722, -1468.99353, 1977.26550, 51.28577,   0.00000, 0.00000, 140.15996);
	CreateDynamicObject(1358, -1476.89307, 1985.92041, 48.20649,   0.00000, 0.00000, 54.36000);
	CreateDynamicObject(12957, -1489.66577, 1943.51257, 48.79741,   4.50000, -7.86000, -57.96002);
	CreateDynamicObject(3270, -1460.15051, 1966.50842, 46.47489,   4.02000, 4.02000, 121.98007);
	CreateDynamicObject(3286, -1426.38147, 1946.86841, 54.88078,   0.00000, 0.00000, 4.50000);
	CreateDynamicObject(3286, -1425.72595, 1940.09766, 54.88078,   0.00000, 0.00000, 7.20000);
	CreateDynamicObject(3287, -1438.52368, 1933.15002, 55.25223,   6.24000, -1.56000, -90.59999);
	CreateDynamicObject(3364, -1495.96924, 2003.33362, 46.20383,   0.00000, 0.00000, 43.02000);
	CreateDynamicObject(3363, -1494.77393, 1983.82275, 46.63250,   0.00000, 0.00000, 84.54000);
	CreateDynamicObject(3268, -1502.53699, 1962.78516, 44.90564,   0.00000, 0.00000, 181.74007);

	//Taxi
	CreateDynamicObject(1360, -1413.68091, 2631.83691, 55.59880,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(1360, -1413.68091, 2625.64380, 55.59880,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(1360, -1413.68091, 2650.09668, 55.57260,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(1360, -1413.68091, 2659.53394, 55.57260,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(19308, -1414.14502, 2632.15308, 55.14765,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2921, -1385.61951, 2627.23096, 58.49242,   0.00000, 0.00000, 67.14000);
	CreateDynamicObject(2921, -1388.73914, 2639.40698, 57.76547,   0.00000, 0.00000, 53.10001);
	CreateDynamicObject(2921, -1388.02661, 2654.35791, 58.09864,   0.00000, 0.00000, -93.72004);

	//Mod/Pay'n spray

	CreateDynamicObject(971, 720.06940, -462.57724, 15.39299,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(971, 1042.84998, -1026.01123, 31.09643,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(971, 1025.36536, -1029.33276, 31.63884,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(971, -1420.50977, 2591.11279, 56.94583,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(971, 2386.68213, 1043.31189, 9.92575,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8167, 2645.81055, -2039.32849, 12.56419,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(8167, 2645.81055, -2039.32849, 15.00648,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(971, -1935.82751, 238.56221, 33.64063,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(971, -1904.62756, 277.66324, 42.39743,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(971, -2716.14404, 216.72392, 3.81582,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(971, 1843.31055, -1855.03943, 12.37510,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(971, 2005.17334, 2303.33716, 9.81711,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(971, 1968.37793, 2162.65747, 12.66515,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(971, 2393.19873, 1483.32202, 12.39729,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(971, -99.80347, 1111.46582, 20.85815,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(971, -2425.07886, 1027.89941, 51.84350,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(971, 2071.52344, -1831.55835, 13.00516,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(971, 488.63022, -1735.32129, 10.59052,   0.00000, 0.00000, -8.46000);

	// Smuggle job
	CreateDynamicObject(1497, 311.45816, 312.90430, 1002.30042,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18092, 304.14590, 307.21701, 998.63501,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8674, 301.15399, 307.26700, 1000.81042,   180.00000, 0.00000, 0.00000);
	CreateDynamicObject(18092, 300.13461, 307.21741, 998.63641,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2959, 306.32956, 299.97623, 998.14783,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(964, 305.34415, 309.72601, 998.11060,   0.00000, 0.00000, -58.19998);
	CreateDynamicObject(3015, 301.68668, 311.74286, 998.24066,   0.00000, 0.00000, -39.00002);
	CreateDynamicObject(3014, 302.36957, 311.58673, 998.35187,   0.00000, 0.00000, 108.24005);
	CreateDynamicObject(3015, 302.87653, 311.65097, 998.24066,   0.00000, 0.00000, -10.44002);
	CreateDynamicObject(1271, 298.73758, 309.97989, 998.48761,   0.00000, 0.00000, 52.38000);
	CreateDynamicObject(18885, 298.62814, 308.66806, 999.25751,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2063, 300.73990, 301.33539, 999.05353,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2063, 300.18079, 301.33539, 999.05353,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2063, 303.96561, 301.33539, 999.05353,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2063, 303.40311, 301.33539, 999.05353,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2047, 304.85727, 300.03665, 1001.11951,   0.00000, 0.00000, 180.06000);
	CreateDynamicObject(2048, 299.27844, 300.00842, 1001.19031,   0.00000, 0.00000, -180.00006);
	CreateDynamicObject(2614, 302.10770, 300.06534, 1001.10376,   0.00000, 0.00000, 179.63991);
	CreateDynamicObject(1242, 303.66589, 302.76941, 998.28314,   37.20004, -12.95998, 0.00000);
	CreateDynamicObject(3014, 303.51593, 301.73666, 998.67169,   0.00000, 0.00000, 111.06000);
	CreateDynamicObject(2040, 303.42319, 302.12366, 999.08289,   0.00000, 0.00000, 95.76002);
	CreateDynamicObject(2040, 303.36316, 301.47354, 999.08289,   0.00000, 0.00000, 70.62001);
	CreateDynamicObject(2041, 303.35510, 300.71890, 999.14099,   0.00000, 0.00000, 214.31996);
	CreateDynamicObject(348, 303.29456, 302.17712, 999.44702,   -85.80007, 46.92012, 0.00000);
	CreateDynamicObject(348, 303.32288, 301.41522, 999.44702,   -85.80007, 46.92012, 120.54003);
	CreateDynamicObject(348, 303.60599, 301.48352, 999.44702,   -85.80007, 46.92012, 263.52005);
	CreateDynamicObject(349, 303.85739, 301.77460, 999.45898,   -76.98010, 40.50010, 310.13980);
	CreateDynamicObject(346, 303.85739, 301.77460, 999.01184,   -86.58025, -47.27998, 310.13980);
	CreateDynamicObject(346, 303.87976, 300.76596, 999.01184,   -86.58025, -47.27998, 382.79977);
	CreateDynamicObject(346, 300.25601, 301.75156, 999.01184,   -86.58025, -47.27998, 382.79977);
	CreateDynamicObject(2040, 300.69525, 302.23312, 999.07068,   0.00000, 0.00000, 55.68002);
	CreateDynamicObject(2040, 300.77353, 300.83182, 999.07068,   0.00000, 0.00000, 135.54001);
	CreateDynamicObject(2041, 300.81091, 301.69919, 999.16772,   0.00000, 0.00000, 77.76000);
	CreateDynamicObject(355, 300.76053, 301.72549, 998.50330,   84.66022, -33.90010, -76.86002);
	CreateDynamicObject(358, 300.59677, 302.82324, 998.42505,   8.40000, -84.59991, 0.00000);
	CreateDynamicObject(2042, 300.76465, 301.58115, 999.50580,   0.00000, 0.00000, 80.46004);

	//Bayside Bank

	new bankfloor = CreateDynamicObject(19379, -2472.51392, 3478.80981, 2003.54053,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(bankfloor, 0, 3975, "lanbloke", "p_floor3", 0xFFFFFFFF);
	new bankfloor1 = CreateDynamicObject(19379, -2483.15430, 3478.81714, 2003.54004,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(bankfloor1, 0, 3975, "lanbloke", "p_floor3", 0xFFFFFFFF);
	new bankfloor2 = CreateDynamicObject(19379, -2483.15430, 3488.44995, 2003.54004,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(bankfloor2, 0, 3975, "lanbloke", "p_floor3", 0xFFFFFFFF);
	new bankfloor3 = CreateDynamicObject(19379, -2476.05054, 3469.20313, 2003.54004,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(bankfloor3, 0, 3975, "lanbloke", "p_floor3", 0xFFFFFFFF);
	CreateDynamicObject(1569, -2483.80664, 3483.64966, 2003.62561,   0.00000, 0.00000, 0.00000);
	new bankdoor1 = CreateDynamicObject(19304, -2488.53784, 3477.03247, 2006.72107,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bankdoor1,  0, 1649, "wglass", "carshowwin2", 0xFFFFFFFF);
	CreateDynamicObject(19325, -2483.41040, 3477.10498, 2007.18469,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19325, -2476.76733, 3477.10498, 2007.18469,   0.00000, 0.00000, 90.00000);

	CreateDynamicObject(1703, -2487.85791, 3483.32275, 2003.56824,   0.00000, 0.00000, 90.00000);//Couch
	CreateDynamicObject(1703, -2478.42896, 3483.54175, 2003.56824,   0.00000, 0.00000, -90.00000);//Couch2
	CreateDynamicObject(638, -2480.95996, 3484.35425, 2004.29419,   0.00000, 0.00000, -47.04000);//Plant
	CreateDynamicObject(638, -2485.17896, 3484.35864, 2004.29419,   0.00000, 0.00000, 47.04000);//Plant
	CreateDynamicObject(2190, -2486.22754, 3477.14844, 2004.88538,   0.00000, 0.00000, 19.01998);//pc
	CreateDynamicObject(2190, -2481.90283, 3476.71338, 2004.88538,   0.00000, 0.00000, -76.37995);//pc
	CreateDynamicObject(2190, -2477.93433, 3476.74976, 2004.88538,   0.00000, 0.00000, -70.79998);//pc
	CreateDynamicObject(19808, -2478.74048, 3476.80835, 2004.89685,   0.00000, 0.00000, -43.20002);//keyboard
	CreateDynamicObject(19808, -2482.78491, 3476.83838, 2004.89685,   0.00000, 0.00000, -52.74004);//keyboard
	CreateDynamicObject(19808, -2485.84253, 3476.82373, 2004.89685,   0.00000, 0.00000, 57.17996);//keyboard
	CreateDynamicObject(19273, -2486.86182, 3477.49121, 2004.99121,   0.00000, 0.00000, -90.00000);//Keypad
	CreateDynamicObject(19273, -2486.87402, 3476.65015, 2004.99121,   0.00000, 0.00000, -90.00000);//Keypad
	CreateDynamicObject(19324, -2488.03931, 3480.22583, 2004.24280,   0.00000, 0.00000, 90.00000);//ATM
	CreateDynamicObject(19324, -2488.03809, 3481.71826, 2004.24280,   0.00000, 0.00000, 90.00000);//ATM
	CreateDynamicObject(11711, -2483.06226, 3483.63354, 2006.46008,   0.00000, 0.00000, 0.00000);//Exit sign
	CreateDynamicObject(19172, -2484.63550, 3474.01880, 2005.62463,   0.00000, 0.00000, 180.00000);//City poster
	CreateDynamicObject(1892, -2483.54761, 3483.17969, 2003.60815,   0.00000, 0.00000, 0.00000);//Security gate
	CreateDynamicObject(1886, -2478.27710, 3485.35059, 2007.31604,   10.32000, -0.48000, -39.48000);//Security cam
	CreateDynamicObject(1886, -2478.20508, 3472.78931, 2007.31604,   10.32000, -0.48000, -160.73993);//Security cam
	CreateDynamicObject(1886, -2490.52490, 3473.12012, 2004.87854,   0.00000, 0.00000, -269.81998);//Security cam
	CreateDynamicObject(1886, -2488.12891, 3477.61914, 2007.30640,   3.17999, -2.64000, 125.64001);//Security cam
	CreateDynamicObject(1886, -2483.65771, 3471.93164, 2004.03149,   11.39999, -5.82000, -57.05998);//Security cam
	CreateDynamicObject(1808, -2478.11743, 3480.98120, 2003.62744,   0.00000, 0.00000, -90.00000);//Water thing
	CreateDynamicObject(2267, -2477.93115, 3479.16821, 2005.77136,   0.00000, 0.00000, -90.00000);//Boat poster
	CreateDynamicObject(2614, -2479.88721, 3472.50122, 2005.85950,   0.00000, 5.00000, 180.64030);//Americca
	CreateDynamicObject(948, -2488.02686, 3482.71094, 2003.57080,   0.00000, 0.00000, 0.00000);//plant
	CreateDynamicObject(948, -2478.27295, 3485.28418, 2003.57080,   0.00000, 0.00000, 47.10004);//plant
	CreateDynamicObject(19273, -2481.00464, 3472.42944, 2004.99121,   0.00000, 0.00000, 180.00000);//keypad2
	CreateDynamicObject(19273, -2481.71338, 3472.42017, 2004.99121,   0.00000, 0.00000, 180.00000);//keypad2
	CreateDynamicObject(1775, -2472.32764, 3473.09814, 2004.71338,   0.00000, 0.00000, -90.00000);//sprunk
	CreateDynamicObject(2637, -2474.38330, 3475.29736, 2004.04407,   0.00000, 0.00000, 90.00000);//table
	CreateDynamicObject(1811, -2473.42041, 3475.93677, 2004.14319,   0.00000, 0.00000, 12.00000);//chair
	CreateDynamicObject(1811, -2473.96045, 3474.89063, 2004.14319,   0.00000, 0.00000, -8.70000);//chair
	CreateDynamicObject(1811, -2474.81274, 3475.95483, 2004.14319,   0.00000, 0.00000, -182.51982);//chair
	CreateDynamicObject(1811, -2475.40356, 3474.95337, 2004.14319,   0.00000, 0.00000, -182.51982);//chair
	CreateDynamicObject(2202, -2477.28027, 3474.53931, 2003.62708,   0.00000, 0.00000, 90.00000);//copymachine
	CreateDynamicObject(2257, -2474.54443, 3476.33252, 2005.77722,   0.00000, 0.00000, 0.00000);//canteen pic
    CreateDynamicObject(1808, -2471.99243, 3474.53516, 2003.62744,   0.00000, 0.00000, -90.00000);//Wather thing




	new bankpilar = CreateDynamicObject(18762, -2488.88184, 3480.97412, 2004.75964,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bankpilar, 0, 17547, "eastbeach4a_lae2", "bluestucco1", 0xFFFFFFFF);
	new bankpilar1 = CreateDynamicObject(18762, -2477.42700, 3480.97412, 2004.75964,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bankpilar1, 0, 17547, "eastbeach4a_lae2", "bluestucco1", 0xFFFFFFFF);


	new safedoor1 = CreateDynamicObject(19304, -2481.31641, 3472.13159, 2006.72107,   0.00000, 0.00000, 90.00000); //Thing above door
	SetDynamicObjectMaterial(safedoor1, 0, 1649, "wglass", "carshowwin2", 0xFFFFFFFF);

	new bankceiling = CreateDynamicObject(19378, -2483.16162, 3477.26367, 2007.20764,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(bankceiling, 0, 11301, "carshow_sfse", "ws_officy_ceiling", 0xFFFFFFFF);
	new bankceiling1 = CreateDynamicObject(19378, -2483.16162, 3486.89844, 2007.20764,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(bankceiling1, 0, 11301, "carshow_sfse", "ws_officy_ceiling", 0xFFFFFFFF);
	new bankceiling2 = CreateDynamicObject(19378, -2472.67017, 3477.26367, 2007.20764,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(bankceiling2, 0, 11301, "carshow_sfse", "ws_officy_ceiling", 0xFFFFFFFF);

	new safefloor = CreateDynamicObject(19379, -2488.76880, 3469.07031, 2000.73901,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(safefloor, 0, 4821, "union_las", "tarmacplain_bank", 0xFFFFFFFF);

	new safewall1 = CreateDynamicObject(19454, -2486.10034, 3473.92456, 2001.87195,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(safewall1, 0, 3899, "hospital2", "cutscenebank128", 0xFFFFFFFF);
	new safewall2 = CreateDynamicObject(19454, -2482.09644, 3472.36548, 2001.87195,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(safewall2, 0, 3899, "hospital2", "cutscenebank128", 0xFFFFFFFF);
	new safewall3 = CreateDynamicObject(19454, -2486.10498, 3473.91992, 2005.37280,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(safewall3, 0, 3899, "hospital2", "cutscenebank128", 0xFFFFFFFF);
	new safewall4 = CreateDynamicObject(19454, -2486.12158, 3472.36548, 2005.37280,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(safewall4, 0, 3899, "hospital2", "cutscenebank128", 0xFFFFFFFF);
	new safewall5 = CreateDynamicObject(19454, -2490.85620, 3469.07813, 2001.87195,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(safewall5, 0, 3899, "hospital2", "cutscenebank128", 0xFFFFFFFF);
	new safewall6 = CreateDynamicObject(19454, -2490.85620, 3469.07813, 2005.36682,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(safewall6, 0, 3899, "hospital2", "cutscenebank128", 0xFFFFFFFF);
	new safewall7 = CreateDynamicObject(19454, -2483.52100, 3467.49707, 2001.87195,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(safewall7, 0, 3899, "hospital2", "cutscenebank128", 0xFFFFFFFF);
	new safewall8 = CreateDynamicObject(19454, -2487.50659, 3464.18286, 2001.87195,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(safewall8, 0, 3899, "hospital2", "cutscenebank128", 0xFFFFFFFF);

	new saferoof = CreateDynamicObject(19378, -2488.75049, 3467.61133, 2003.70618,   0.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(saferoof, 0, 11301, "carshow_sfse", "ws_officy_ceiling", 0xFFFFFFFF);
	new saferoof1 = CreateDynamicObject(19378, -2486.43921, 3469.19580, 2005.87524,   0.00000, 75.00000, 0.00000);
	SetDynamicObjectMaterial(saferoof1, 0, 11301, "carshow_sfse", "ws_officy_ceiling", 0xFFFFFFFF);

	new bankstairs1 = CreateDynamicObject(18767, -2486.57910, 3476.35571, 1998.72766,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(bankstairs1, 0, 3673, "xrf_refineryla", "Metal1_128", 0xFFFFFFFF);
	new bankstairs2 = CreateDynamicObject(18767, -2486.57007, 3475.93579, 1998.72595,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(bankstairs2, 0, 3673, "xrf_refineryla", "Metal1_128", 0xFFFFFFFF);

	new banksafepilar1 = CreateDynamicObject(18980, -2490.83765, 3458.89478, 2000.96655,   90.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(banksafepilar1, 0, 3267, "milbase", "ws_metalpanel1", 0xFFFFFFFF);
	new banksafepilar2 = CreateDynamicObject(18762, -2490.83838, 3470.89404, 2002.66565,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(banksafepilar2, 0, 3267, "milbase", "ws_metalpanel1", 0xFFFFFFFF);
	new banksafepilar3 = CreateDynamicObject(18980, -2490.83765, 3458.89478, 2003.63220,   90.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(banksafepilar3, 0, 3267, "milbase", "ws_metalpanel1", 0xFFFFFFFF);
	new banksafepilar4 = CreateDynamicObject(18762, -2490.73022, 3464.49121, 2002.66565,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(banksafepilar4, 0, 3267, "milbase", "ws_metalpanel1", 0xFFFFFFFF);
	new banksafepilar5 = CreateDynamicObject(18980, -2479.49072, 3464.32129, 2000.96655,   90.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(banksafepilar5, 0, 3267, "milbase", "ws_metalpanel1", 0xFFFFFFFF);
	new banksafepilar6 = CreateDynamicObject(18980, -2479.49072, 3464.32129, 2003.63416,   90.00000, 90.00000, 0.00000);
	SetDynamicObjectMaterial(banksafepilar6, 0, 3267, "milbase", "ws_metalpanel1", 0xFFFFFFFF);
	new banksafepilar7 = CreateDynamicObject(18762, -2483.80981, 3464.49121, 2002.66565,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(banksafepilar7, 0, 3267, "milbase", "ws_metalpanel1", 0xFFFFFFFF);
	new banksafepilar8 = CreateDynamicObject(18980, -2483.69702, 3458.89478, 2000.96655,   90.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(banksafepilar8, 0, 3267, "milbase", "ws_metalpanel1", 0xFFFFFFFF);
	new banksafepilar9 = CreateDynamicObject(18762, -2483.69604, 3470.89404, 2002.66565,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(banksafepilar9, 0, 3267, "milbase", "ws_metalpanel1", 0xFFFFFFFF);
	new banksafepilar10 = CreateDynamicObject(18980, -2483.69702, 3458.89478, 2003.63220,   90.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(banksafepilar10, 0, 3267, "milbase", "ws_metalpanel1", 0xFFFFFFFF);

	CreateDynamicObject(2007, -2490.37964, 3464.97192, 2001.76428,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2007, -2490.37915, 3469.91821, 2000.45935,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2007, -2490.37964, 3469.91870, 2001.76428,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2007, -2490.37964, 3468.94116, 2001.76428,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2007, -2490.37964, 3467.95459, 2001.76428,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2007, -2490.37964, 3466.96411, 2001.76428,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2007, -2490.37964, 3465.98389, 2001.76428,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2007, -2490.37915, 3468.94116, 2000.45935,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2007, -2490.37915, 3467.95459, 2000.45935,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2007, -2490.37915, 3466.96411, 2000.45935,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2007, -2490.37915, 3465.98389, 2000.45935,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2007, -2490.37915, 3464.97192, 2000.45935,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2007, -2489.76392, 3464.77075, 2000.45935,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2007, -2489.76392, 3464.77002, 2001.76428,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2007, -2488.78467, 3464.77075, 2000.45935,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2007, -2487.78198, 3464.77075, 2000.45935,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2007, -2486.79663, 3464.77075, 2000.45935,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2007, -2485.79614, 3464.77075, 2000.45935,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2007, -2484.79712, 3464.77075, 2000.45935,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2007, -2484.11255, 3464.97192, 2000.45935,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2007, -2488.78467, 3464.77002, 2001.76428,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2007, -2487.78198, 3464.77002, 2001.76428,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2007, -2486.79663, 3464.77002, 2001.76428,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2007, -2485.79614, 3464.77002, 2001.76428,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2007, -2484.79712, 3464.77002, 2001.76428,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(2007, -2484.11255, 3465.98389, 2000.45935,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2007, -2484.11255, 3467.95459, 2000.45935,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2007, -2484.11255, 3468.94116, 2000.45935,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2007, -2484.11255, 3469.91821, 2000.45935,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2007, -2484.11157, 3464.97192, 2001.76428,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2007, -2484.11157, 3465.98389, 2001.76428,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2007, -2484.11255, 3466.96411, 2000.45935,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2007, -2484.11157, 3466.96411, 2001.76428,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2007, -2484.11157, 3467.95459, 2001.76428,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2007, -2484.11157, 3468.94116, 2001.76428,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(2007, -2484.11157, 3469.91821, 2001.76428,   0.00000, 0.00000, -90.00000);

	new safedesk = CreateDynamicObject(2115, -2487.89673, 3468.77100, 2000.81641,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(safedesk, 0, 8572, "vgssstairs1", "metalic_64", 0xFFFFFFFF);
	new safedesk1 = CreateDynamicObject(2115, -2487.89673, 3467.80273, 2000.81641,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(safedesk1, 0, 8572, "vgssstairs1", "metalic_64", 0xFFFFFFFF);

	new bank1 = CreateDynamicObject(1569, -2483.80664, 3483.64966, 2006.12000,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bank1, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	new bank3 = CreateDynamicObject(19454, -2488.48730, 3478.80859, 2005.37280,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bank3, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	new bank4 = CreateDynamicObject(19454, -2477.82153, 3478.81348, 2005.37280,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bank4, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	new bank5 = CreateDynamicObject(19454, -2486.10034, 3473.92456, 2005.37280,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(bank5, 0, 17547, "eastbeach4a_lae2", "bluestucco1", 0xFFFFFFFF);//
	new bank6 = CreateDynamicObject(19362, -2481.19507, 3484.74219, 2005.37280,   0.00000, 0.00000, -47.04002);
	SetDynamicObjectMaterial(bank6, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	new bank7 = CreateDynamicObject(19454, -2476.49585, 3472.36548, 2005.37280,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(bank7, 0, 17547, "eastbeach4a_lae2", "bluestucco1", 0xFFFFFFFF);
	new bank8 = CreateDynamicObject(19362, -2488.48730, 3485.23096, 2005.37280,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bank8, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	new bank9 = CreateDynamicObject(19362, -2487.01831, 3485.81226, 2005.37280,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(bank9, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	new bank10 = CreateDynamicObject(19362, -2478.54102, 3485.81226, 2005.37280,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(bank10, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	new bank11 = CreateDynamicObject(19362, -2477.82153, 3485.23730, 2005.37280,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bank11, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	new bank12 = CreateDynamicObject(19362, -2484.91577, 3484.74023, 2005.37280,   0.00000, 0.00000, 47.04000);
	SetDynamicObjectMaterial(bank12, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	new bank13 = CreateDynamicObject(19466, -2479.03809, 3485.71265, 2005.43958,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(bank13, 0, 3979, "civic01_lan", "sl_laglasswall1", 0xFFFFFFFF);
	new bank14 = CreateDynamicObject(19466, -2481.17871, 3484.62524, 2005.43958,   0.00000, 0.00000, -47.04000);
	SetDynamicObjectMaterial(bank14, 0, 3979, "civic01_lan", "sl_laglasswall1", 0xFFFFFFFF);
	new bank15 = CreateDynamicObject(19466, -2484.96655, 3484.65332, 2005.43958,   0.00000, 0.00000, 47.04000);
	SetDynamicObjectMaterial(bank15, 0, 3979, "civic01_lan", "sl_laglasswall1", 0xFFFFFFFF);
	new bank16 = CreateDynamicObject(19466, -2487.24365, 3485.70386, 2005.43958,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(bank16, 0, 3979, "civic01_lan", "sl_laglasswall1", 0xFFFFFFFF);
	new bank17 = CreateDynamicObject(19454, -2472.94116, 3476.42969, 2005.37280,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(bank17, 0, 8460, "vgseland03_lvs", "ceaserwall06_128", 0xFFFFFFFF);
	new bank18 = CreateDynamicObject(19454, -2471.76147, 3477.15649, 2005.37280,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bank18, 0, 8460, "vgseland03_lvs", "ceaserwall06_128", 0xFFFFFFFF);
	new bank19 = CreateDynamicObject(19454, -2477.80151, 3478.81494, 2005.37280,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bank19, 0, 8460, "vgseland03_lvs", "ceaserwall06_128", 0xFFFFFFFF);



	new bankcounter1 = CreateDynamicObject(19455, -2481.90405, 3476.63599, 2003.12512,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(bankcounter1, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	new bankcounter2 = CreateDynamicObject(19815, -2482.23608, 3477.04883, 2004.88623,   90.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bankcounter2, 0, 10388, "scum2_sfs", "black32", 0xFFFFFFFF);
	new bankcounter3 = CreateDynamicObject(19815, -2479.23608, 3477.04883, 2004.88623,   90.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bankcounter3, 0, 10388, "scum2_sfs", "black32", 0xFFFFFFFF);
	new bankcounter4 = CreateDynamicObject(9131, -2486.33545, 3477.25903, 2003.74121,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bankcounter4, 0, 17547, "eastbeach4a_lae2", "bluestucco1", 0xFFFFFFFF);
	new bankcounter5 = CreateDynamicObject(9131, -2482.20752, 3477.25903, 2003.74121,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bankcounter5, 0, 17547, "eastbeach4a_lae2", "bluestucco1", 0xFFFFFFFF);
	new bankcounter6 = CreateDynamicObject(19442, -2486.80444, 3477.01270, 2005.37585,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bankcounter6, 0, 10388, "scum2_sfs", "black32", 0xFFFFFFFF);//
	new bankcounter7 = CreateDynamicObject(19815, -2485.23657, 3477.04883, 2004.88623,   90.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bankcounter7, 0, 10388, "scum2_sfs", "black32", 0xFFFFFFFF);
	new bankcounter8 = CreateDynamicObject(9131, -2478.30151, 3477.25903, 2003.74121,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bankcounter8, 0, 17547, "eastbeach4a_lae2", "bluestucco1", 0xFFFFFFFF);
	new bankcounter9 = CreateDynamicObject(19455, -2481.90405, 3477.45996, 2003.12512,   0.00000, 0.00000, 90.00000);
	SetDynamicObjectMaterial(bankcounter9, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	new bankcounter10 = CreateDynamicObject(19442, -2477.82544, 3477.01270, 2005.37585,   0.00000, 0.00000, 0.00000);
	SetDynamicObjectMaterial(bankcounter10, 0, 10388, "scum2_sfs", "black32", 0xFFFFFFFF);
	//Configure world:
	SetWeather(globalWeather);

	new
		hour, seconds, minute;

	gettime(hour, seconds, minute);
	SetWorldTime(hour);

	//Global timers:
	maintimer = SetTimer("MainTimer", 1000, true);
	SetTimer("FunctionPlayers", 1000, true);
	SetTimer("OnWeaponsUpdate", 1000, true);
	SetTimer("FunctionPaychecks", 1000, true);
	SetTimer("OnPlayerNearBusiness", 3000, true);
	SetTimer("OnVehicleUpdate", 1000, true);

	//Loading systems:
	mysql_tquery(ourConnection, "SELECT * FROM factions ORDER BY dbid ASC", "Query_LoadFactions");
	mysql_tquery(ourConnection, "SELECT * FROM vehicles", "Query_LoadVehicles");
	mysql_tquery(ourConnection, "SELECT * FROM properties ORDER BY PropertyDBID", "Query_LoadProperties");
	mysql_tquery(ourConnection, "SELECT * FROM xmr_categories ORDER BY XMRDBID ASC", "Query_LoadXMRCategories");
	mysql_tquery(ourConnection, "SELECT * FROM xmr_stations ORDER BY XMRStationDBID ASC", "Query_LoadXMRStations");
	mysql_tquery(ourConnection, "SELECT * FROM businesses ORDER BY BusinessDBID ASC", "Query_LoadBusinesses");
	mysql_tquery(ourConnection, "SELECT * FROM `xRob_Safes`", "LoadxSafes");

	//DMV vehicles:
	dmv_vehicles[0] = AddStaticVehicle(405, -2464.7371, 2224.4255, 4.7225, 0.0000, 1, 1); SetVehicleNumberPlate(dmv_vehicles[0], "DMV"); VehicleInfo[dmv_vehicles[0]][eVehicleFuel] = 100;
	dmv_vehicles[1] = AddStaticVehicle(405, -2461.7500, 2224.4255, 4.7225, 0.0000, 1, 1); SetVehicleNumberPlate(dmv_vehicles[1], "DMV"); VehicleInfo[dmv_vehicles[1]][eVehicleFuel] = 100;
	dmv_vehicles[2] = AddStaticVehicle(405, -2458.7500, 2224.4255, 4.7225, 0.0000, 1, 1); SetVehicleNumberPlate(dmv_vehicles[2], "DMV"); VehicleInfo[dmv_vehicles[2]][eVehicleFuel] = 100;
	dmv_vehicles[3] = AddStaticVehicle(405, -2455.7500, 2224.4255, 4.7225, 0.0000, 1, 1); SetVehicleNumberPlate(dmv_vehicles[3], "DMV"); VehicleInfo[dmv_vehicles[3]][eVehicleFuel] = 100;

	//Pizza vehicles:
	pizza_vehicles[0] = AddStaticVehicle(448, -2523.0552, 2289.7368, 4.5122, 119.8800, -1, -1); SetVehicleNumberPlate(pizza_vehicles[0], "Pizza"); VehicleInfo[pizza_vehicles[0]][eVehicleFuel] = 100;
	pizza_vehicles[1] = AddStaticVehicle(448, -2522.9087, 2287.8762, 4.5122, 119.8800, -1, -1); SetVehicleNumberPlate(pizza_vehicles[1], "Pizza"); VehicleInfo[pizza_vehicles[1]][eVehicleFuel] = 100;
	pizza_vehicles[2] = AddStaticVehicle(448, -2522.8164, 2286.0698, 4.5122, 119.8800, -1, -1); SetVehicleNumberPlate(pizza_vehicles[2], "Pizza"); VehicleInfo[pizza_vehicles[2]][eVehicleFuel] = 100;
	pizza_vehicles[3] = AddStaticVehicle(448, -2522.7920, 2284.1465, 4.5122, 119.8800, -1, -1); SetVehicleNumberPlate(pizza_vehicles[3], "Pizza"); VehicleInfo[pizza_vehicles[3]][eVehicleFuel] = 100;

	//Tow vehicles:
	tow_vehicles[0] = AddStaticVehicle(525,2493.1372,-2117.1191,13.4227,358.1326,6,6); SetVehicleNumberPlate(tow_vehicles[0], "Tow"); VehicleInfo[tow_vehicles[0]][eVehicleFuel] = 100;
	tow_vehicles[1] = AddStaticVehicle(525,2493.1348,-2109.4692,13.4264,358.8593,6,6); SetVehicleNumberPlate(tow_vehicles[1], "Tow"); VehicleInfo[tow_vehicles[1]][eVehicleFuel] = 100;
	tow_vehicles[2] = AddStaticVehicle(525,2493.2646,-2101.5745,13.4217,358.7511,6,6); SetVehicleNumberPlate(tow_vehicles[2], "Tow"); VehicleInfo[tow_vehicles[2]][eVehicleFuel] = 100;
	tow_vehicles[3] = AddStaticVehicle(525,2487.6504,-2101.5881,13.4242,0.2882,6,6); SetVehicleNumberPlate(tow_vehicles[3], "Tow"); VehicleInfo[tow_vehicles[3]][eVehicleFuel] = 100;
	tow_vehicles[4] = AddStaticVehicle(525,2487.2476,-2109.6904,13.4262,359.6253,6,6); SetVehicleNumberPlate(tow_vehicles[4], "Tow"); VehicleInfo[tow_vehicles[4]][eVehicleFuel] = 100;
	tow_vehicles[5] = AddStaticVehicle(525,2487.5378,-2116.8811,13.4245,1.9617,6,6); SetVehicleNumberPlate(tow_vehicles[5], "Tow"); VehicleInfo[tow_vehicles[5]][eVehicleFuel] = 100;
	tow_vehicles[6] = AddStaticVehicle(525,2481.8379,-2116.8975,13.4262,2.1045,6,6);  SetVehicleNumberPlate(tow_vehicles[6], "Tow"); VehicleInfo[tow_vehicles[6]][eVehicleFuel] = 100;
	tow_vehicles[7] = AddStaticVehicle(525,2481.5813,-2109.4021,13.4235,0.6541,6,6); SetVehicleNumberPlate(tow_vehicles[7], "Tow"); VehicleInfo[tow_vehicles[7]][eVehicleFuel] = 100;
	tow_vehicles[8] = AddStaticVehicle(525,2481.5286,-2101.5986,13.4220,1.6298,6,6); SetVehicleNumberPlate(tow_vehicles[8], "Tow"); VehicleInfo[tow_vehicles[8]][eVehicleFuel] = 100;
	tow_vehicles[9] = AddStaticVehicle(525,2476.1777,-2117.1182,13.4239,1.5101,6,6); SetVehicleNumberPlate(tow_vehicles[9], "Tow"); VehicleInfo[tow_vehicles[9]][eVehicleFuel] = 100;
	tow_vehicles[10] = AddStaticVehicle(525,2475.5464,-2109.4827,13.4231,1.8074,6,6); SetVehicleNumberPlate(tow_vehicles[10], "Tow"); VehicleInfo[tow_vehicles[10]][eVehicleFuel] = 100;
	tow_vehicles[11] = AddStaticVehicle(525,2475.1292,-2101.6868,13.4208,359.8720,6,6); SetVehicleNumberPlate(tow_vehicles[11], "Tow"); VehicleInfo[tow_vehicles[11]][eVehicleFuel] = 100;
	//Taxi vehicles:
	taxi_vehicles[0] = AddStaticVehicle(420,2795.6726,-1589.0366,10.7057,268.1007,6,6); SetVehicleNumberPlate(taxi_vehicles[0], "Taxi"); VehicleInfo[taxi_vehicles[0]][eVehicleFuel] = 100;
	taxi_vehicles[1] = AddStaticVehicle(420,2795.8171,-1584.5497,10.7126,269.5834,6,6); SetVehicleNumberPlate(taxi_vehicles[1], "Taxi"); VehicleInfo[taxi_vehicles[1]][eVehicleFuel] = 100;
	taxi_vehicles[2] = AddStaticVehicle(420,2796.2854,-1579.7928,10.7192,272.5696,6,6); SetVehicleNumberPlate(taxi_vehicles[2], "Taxi"); VehicleInfo[taxi_vehicles[2]][eVehicleFuel] = 100;
	taxi_vehicles[3] = AddStaticVehicle(420,2796.0684,-1575.9014,10.7035,268.5702,6,6); SetVehicleNumberPlate(taxi_vehicles[3], "Taxi"); VehicleInfo[taxi_vehicles[3]][eVehicleFuel] = 100;
	taxi_vehicles[4] = AddStaticVehicle(420,2795.9885,-1571.5065,10.7041,270.1759,6,6); SetVehicleNumberPlate(taxi_vehicles[4], "Taxi"); VehicleInfo[taxi_vehicles[4]][eVehicleFuel] = 100;
	taxi_vehicles[5] = AddStaticVehicle(420,2796.0278,-1567.2273,10.7055,269.5443,6,6); SetVehicleNumberPlate(taxi_vehicles[5], "Taxi"); VehicleInfo[taxi_vehicles[5]][eVehicleFuel] = 100;
	taxi_vehicles[6] = AddStaticVehicle(420,2796.0366,-1562.6913,10.7034,269.3265,6,6); SetVehicleNumberPlate(taxi_vehicles[6], "Taxi"); VehicleInfo[taxi_vehicles[6]][eVehicleFuel] = 100;
	taxi_vehicles[7] = AddStaticVehicle(420,2795.9971,-1558.3529,10.7263,270.5491,6,6); SetVehicleNumberPlate(taxi_vehicles[7], "Taxi"); VehicleInfo[taxi_vehicles[7]][eVehicleFuel] = 100;
	taxi_vehicles[8] = AddStaticVehicle(420,2796.0557,-1554.0323,10.7265,270.0567,6,6); SetVehicleNumberPlate(taxi_vehicles[8], "Taxi"); VehicleInfo[taxi_vehicles[8]][eVehicleFuel] = 100;
	taxi_vehicles[9] = AddStaticVehicle(420,2795.9900,-1549.6019,10.7130,270.2973,6,6); SetVehicleNumberPlate(taxi_vehicles[9], "Taxi"); VehicleInfo[taxi_vehicles[9]][eVehicleFuel] = 100;
	taxi_vehicles[10] = AddStaticVehicle(420,2803.0486,-1539.8341,10.7266,179.8898,6,6); SetVehicleNumberPlate(taxi_vehicles[10], "Taxi"); VehicleInfo[taxi_vehicles[10]][eVehicleFuel] = 100;
	taxi_vehicles[11] = AddStaticVehicle(420,2807.3813,-1539.8275,10.7024,180.7380,6,6); SetVehicleNumberPlate(taxi_vehicles[11], "Taxi"); VehicleInfo[taxi_vehicles[11]][eVehicleFuel] = 100;
	taxi_vehicles[12] = AddStaticVehicle(420,2811.8289,-1539.8129,10.7009,181.6745,6,6); SetVehicleNumberPlate(taxi_vehicles[12], "Taxi"); VehicleInfo[taxi_vehicles[12]][eVehicleFuel] = 100;
	taxi_vehicles[13] = AddStaticVehicle(420,2815.9705,-1539.8243,10.7024,181.4528,6,6); SetVehicleNumberPlate(taxi_vehicles[13], "Taxi"); VehicleInfo[taxi_vehicles[13]][eVehicleFuel] = 100;
	taxi_vehicles[14] = AddStaticVehicle(420,2822.3511,-1548.8326,10.7037,90.1196,6,6); SetVehicleNumberPlate(taxi_vehicles[14], "Taxi"); VehicleInfo[taxi_vehicles[14]][eVehicleFuel] = 100;
	taxi_vehicles[15] = AddStaticVehicle(420,2822.4839,-1553.2687,10.7051,89.1810,6,6); SetVehicleNumberPlate(taxi_vehicles[15], "Taxi"); VehicleInfo[taxi_vehicles[15]][eVehicleFuel] = 100;
	taxi_vehicles[16] = AddStaticVehicle(420,2822.3921,-1557.8652,10.7092,89.7269,6,6); SetVehicleNumberPlate(taxi_vehicles[16], "Taxi"); VehicleInfo[taxi_vehicles[16]][eVehicleFuel] = 100;
	taxi_vehicles[17] = AddStaticVehicle(420,2822.3369,-1562.3948,10.7148,88.8637,6,6); SetVehicleNumberPlate(taxi_vehicles[17], "Taxi"); VehicleInfo[taxi_vehicles[17]][eVehicleFuel] = 100;



	//Trucking Vehicles
 	trucking_vehicles[0] = AddStaticVehicle(450,2119.8965,-2155.6709,14.1945,359.9704,0,0); SetVehicleNumberPlate(trucking_vehicles[0], "TB-Trucking"); VehicleInfo[trucking_vehicles[0]][eVehicleFuel] = 100;
	trucking_vehicles[1] = AddStaticVehicle(450,2129.7781,-2157.1658,14.1810,359.9950,0,0); SetVehicleNumberPlate(trucking_vehicles[1], "TB-Trucking"); VehicleInfo[trucking_vehicles[1]][eVehicleFuel] = 100;
	trucking_vehicles[2] = AddStaticVehicle(450,2134.2314,-2158.8523,14.1892,0.0081,0,0);   SetVehicleNumberPlate(trucking_vehicles[2], "TB-Trucking"); VehicleInfo[trucking_vehicles[2]][eVehicleFuel] = 100;
	trucking_vehicles[3] = AddStaticVehicle(450,2139.3853,-2159.7505,14.1857,359.9966,0,0); SetVehicleNumberPlate(trucking_vehicles[3], "TB-Trucking"); VehicleInfo[trucking_vehicles[3]][eVehicleFuel] = 100;
	trucking_vehicles[4] = AddStaticVehicle(450,2141.8020,-2142.8154,14.1783,359.9999,0,0); SetVehicleNumberPlate(trucking_vehicles[4], "TB-Trucking"); VehicleInfo[trucking_vehicles[4]][eVehicleFuel] = 100;
	trucking_vehicles[5] = AddStaticVehicle(450,2135.1687,-2143.7832,14.1767,359.9999,0,0); SetVehicleNumberPlate(trucking_vehicles[5], "TB-Trucking"); VehicleInfo[trucking_vehicles[5]][eVehicleFuel] = 100;
	trucking_vehicles[6] = AddStaticVehicle(450,2129.3628,-2143.2322,14.1731,0.0181,0,0);   SetVehicleNumberPlate(trucking_vehicles[6], "TB-Trucking"); VehicleInfo[trucking_vehicles[6]][eVehicleFuel] = 100;
	trucking_vehicles[7] = AddStaticVehicle(403,2139.5337,-2099.3645,14.1448,130.4769,8,8); SetVehicleNumberPlate(trucking_vehicles[7], "TB-Trucking"); VehicleInfo[trucking_vehicles[7]][eVehicleFuel] = 100;
	trucking_vehicles[8] = AddStaticVehicle(403,2132.8635,-2093.0601,14.1554,134.4286,8,8); SetVehicleNumberPlate(trucking_vehicles[8], "TB-Trucking"); VehicleInfo[trucking_vehicles[8]][eVehicleFuel] = 100;
	trucking_vehicles[9] =  AddStaticVehicle(450,2122.8718,-2143.6616,14.1940,0.0596,0,0);  SetVehicleNumberPlate(trucking_vehicles[9], "TB-Trucking"); VehicleInfo[trucking_vehicles[9]][eVehicleFuel] = 100;
	trucking_vehicles[10] = AddStaticVehicle(450,2113.5139,-2141.7305,14.2705,359.9955,0,0);SetVehicleNumberPlate(trucking_vehicles[10], "TB-Trucking"); VehicleInfo[trucking_vehicles[10]][eVehicleFuel] = 100;
	trucking_vehicles[11] = AddStaticVehicle(450,2118.2256,-2142.9692,14.2636,0.0287,0,0);  SetVehicleNumberPlate(trucking_vehicles[11], "TB-Trucking"); VehicleInfo[trucking_vehicles[11]][eVehicleFuel] = 100;
	trucking_vehicles[12] = AddStaticVehicle(403,2125.6458,-2085.5327,14.1552,133.9575,8,8);  SetVehicleNumberPlate(trucking_vehicles[12], "TB-Trucking"); VehicleInfo[trucking_vehicles[12]][eVehicleFuel] = 100;
	trucking_vehicles[13] = AddStaticVehicle(403,2118.3823,-2078.2065,14.1591,134.6337,8,8);  SetVehicleNumberPlate(trucking_vehicles[13], "TB-Trucking"); VehicleInfo[trucking_vehicles[13]][eVehicleFuel] = 100;
	trucking_vehicles[14] = AddStaticVehicle(403,2112.2700,-2071.9343,14.1399,134.8408,8,8);  SetVehicleNumberPlate(trucking_vehicles[14], "TB-Trucking"); VehicleInfo[trucking_vehicles[14]][eVehicleFuel] = 100;
	
	//sweeper cars
//	sweeper_car[0] = AddStaticVehicle(596,1602.6511,-1687.9220,5.5768,89.4184,0,1); SetVehicleNumberPlate(sweeper_car[0], "MGMC"); VehicleInfo[sweeper_car[0]][eVehicleFuel] = 100;
	sweeper_car[1] = AddStaticVehicle(574,1779.0814,-1700.7439,13.2178,38.1126,0,0); SetVehicleNumberPlate(sweeper_car[1], "MGMC"); VehicleInfo[sweeper_car[1]][eVehicleFuel] = 100;
	//courier cars
	courier_cars[0] = AddStaticVehicle(609,2451.8613,-2116.4766,13.6174,356.6445,5,5); SetVehicleNumberPlate(courier_cars[0], "Courier"); VehicleInfo[courier_cars[0]][eVehicleFuel] = 100;
	courier_cars[1] = AddStaticVehicle(609,2458.9507,-2116.8682,13.6202,356.2124,5,5); SetVehicleNumberPlate(courier_cars[1], "Courier"); VehicleInfo[courier_cars[1]][eVehicleFuel] = 100;
	courier_cars[2] = AddStaticVehicle(609,2463.9580,-2117.1655,13.6170,355.7413,5,5); SetVehicleNumberPlate(courier_cars[2], "Courier"); VehicleInfo[courier_cars[2]][eVehicleFuel] = 100;
	courier_cars[3] = AddStaticVehicle(609,2469.4768,-2117.2451,13.6149,0.7656,5,5); SetVehicleNumberPlate(courier_cars[4], "Courier"); VehicleInfo[courier_cars[3]][eVehicleFuel] = 100;
	//cop_cars
	cop_car[0] = AddStaticVehicle(596,1602.6511,-1687.9220,5.5768,89.4184,0,1); SetVehicleNumberPlate(cop_car[0], "MGPD"); VehicleInfo[cop_car[0]][eVehicleFuel] = 100;
	cop_car[1] = AddStaticVehicle(596,1602.6709,-1691.9506,5.6059,90.0388,0,1); SetVehicleNumberPlate(cop_car[1], "MGPD"); VehicleInfo[cop_car[1]][eVehicleFuel] = 100;
	cop_car[2] = AddStaticVehicle(596,1602.6267,-1696.0240,5.5881,89.6226,0,1); SetVehicleNumberPlate(cop_car[2], "MGPD"); VehicleInfo[cop_car[2]][eVehicleFuel] = 100;
	cop_car[3] = AddStaticVehicle(596,1602.6172,-1700.2623,5.5909,89.9282,0,1); SetVehicleNumberPlate(cop_car[3], "MGPD"); VehicleInfo[cop_car[3]][eVehicleFuel] = 100;
	cop_car[4] = AddStaticVehicle(596,1602.5941,-1704.2720,5.5911,90.1604,0,1); SetVehicleNumberPlate(cop_car[4], "MGPD"); VehicleInfo[cop_car[4]][eVehicleFuel] = 100;
	cop_car[5] = AddStaticVehicle(523,1595.5186,-1711.9583,5.4555,1.3981,0,1); SetVehicleNumberPlate(cop_car[5], "MGPD"); VehicleInfo[cop_car[5]][eVehicleFuel] = 100;
	cop_car[6] = AddStaticVehicle(523,1591.4841,-1712.0117,5.4527,0.9265,0,1); SetVehicleNumberPlate(cop_car[6], "MGPD"); VehicleInfo[cop_car[6]][eVehicleFuel] = 100;
	cop_car[7] = AddStaticVehicle(523,1587.5160,-1712.1523,5.4552,0.2728,0,1); SetVehicleNumberPlate(cop_car[7], "MGPD"); VehicleInfo[cop_car[7]][eVehicleFuel] = 100;
	cop_car[8] = AddStaticVehicle(523,1583.5355,-1712.1545,5.4525,359.8253,0,1); SetVehicleNumberPlate(cop_car[8], "MGPD"); VehicleInfo[cop_car[8]][eVehicleFuel] = 100;
	cop_car[9] = AddStaticVehicle(523,1578.2419,-1712.1168,5.4552,0.0000,0,1); SetVehicleNumberPlate(cop_car[9], "MGPD"); VehicleInfo[cop_car[9]][eVehicleFuel] = 100;
	cop_car[10] = AddStaticVehicle(523,1574.4537,-1712.2284,5.4567,1.5799,0,1); SetVehicleNumberPlate(cop_car[10], "MGPD"); VehicleInfo[cop_car[10]][eVehicleFuel] = 100;
	cop_car[11] = AddStaticVehicle(599,1545.9976,-1684.2834,6.1179,91.9359,0,1); SetVehicleNumberPlate(cop_car[11], "MGPD"); VehicleInfo[cop_car[11]][eVehicleFuel] = 100;
	cop_car[12] = AddStaticVehicle(523,1570.3501,-1712.1678,5.4575,360.0000,0,1); SetVehicleNumberPlate(cop_car[12], "MGPD"); VehicleInfo[cop_car[12]][eVehicleFuel] = 100;
	cop_car[13] = AddStaticVehicle(599,1545.9786,-1680.2338,6.1268,90.2101,0,1); SetVehicleNumberPlate(cop_car[13], "MGPD"); VehicleInfo[cop_car[13]][eVehicleFuel] = 100;
	cop_car[14] = AddStaticVehicle(599,1545.9445,-1676.0919,6.1000,89.8338,0,1); SetVehicleNumberPlate(cop_car[14], "MGPD"); VehicleInfo[cop_car[14]][eVehicleFuel] = 100;
	cop_car[15] = AddStaticVehicle(599,1546.1074,-1672.0894,6.1142,89.3375,0,1); SetVehicleNumberPlate(cop_car[15], "MGPD"); VehicleInfo[cop_car[15]][eVehicleFuel] = 100;
	cop_car[16] = AddStaticVehicle(599,1545.9634,-1667.8961,6.1244,88.4452,0,1); SetVehicleNumberPlate(cop_car[16], "MGPD"); VehicleInfo[cop_car[16]][eVehicleFuel] = 100;
	cop_car[17] = AddStaticVehicle(601,1545.4690,-1663.1696,5.6020,90.1131,7,7); SetVehicleNumberPlate(cop_car[17], "MGPD"); VehicleInfo[cop_car[17]][eVehicleFuel] = 100;
	cop_car[18] = AddStaticVehicle(601,1545.4995,-1654.9988,5.6051,88.7236,7,7); SetVehicleNumberPlate(cop_car[18], "MGPD"); VehicleInfo[cop_car[18]][eVehicleFuel] = 100;
	cop_car[19] = AddStaticVehicle(601,1545.5576,-1658.9700,5.6048,89.4250,7,7); SetVehicleNumberPlate(cop_car[19], "MGPD"); VehicleInfo[cop_car[19]][eVehicleFuel] = 100;
	cop_car[20] = AddStaticVehicle(416,1538.8551,-1645.0861,6.0857,177.3820,0,1); SetVehicleNumberPlate(cop_car[20], "MGPD"); VehicleInfo[cop_car[20]][eVehicleFuel] = 100;
	cop_car[21] = AddStaticVehicle(416,1534.8918,-1645.1417,6.0810,180.0054,0,1); SetVehicleNumberPlate(cop_car[21], "MGPD"); VehicleInfo[cop_car[21]][eVehicleFuel] = 100;
	cop_car[22] = AddStaticVehicle(407,1530.4792,-1644.6544,6.1345,180.8549,0,1); SetVehicleNumberPlate(cop_car[22], "MGPD"); VehicleInfo[cop_car[22]][eVehicleFuel] = 100;
	cop_car[23] = AddStaticVehicle(407,1526.7023,-1644.7039,6.1366,179.9612,0,1); SetVehicleNumberPlate(cop_car[23], "MGPD"); VehicleInfo[cop_car[23]][eVehicleFuel] = 100;
	cop_car[24] = AddStaticVehicle(427,1528.9758,-1683.5134,6.0246,269.4950,0,1); SetVehicleNumberPlate(cop_car[24], "MGPD"); VehicleInfo[cop_car[24]][eVehicleFuel] = 100;
	cop_car[25] = AddStaticVehicle(427,1529.0842,-1687.7620,6.0238,269.2132,0,1); SetVehicleNumberPlate(cop_car[25], "MGPD"); VehicleInfo[cop_car[25]][eVehicleFuel] = 100;
	cop_car[26] = AddStaticVehicle(490,1563.3248,-1710.0870,6.0206,355.3986,0,0); SetVehicleNumberPlate(cop_car[26], "MGPD"); VehicleInfo[cop_car[26]][eVehicleFuel] = 100;
	cop_car[27] = AddStaticVehicle(490,1558.8051,-1710.0776,6.0188,0.0559,0,0); SetVehicleNumberPlate(cop_car[27], "MGPD"); VehicleInfo[cop_car[27]][eVehicleFuel] = 100;
	//flycar
	fly_car[0] = AddStaticVehicle(519,1729.8932,-2415.7798,14.4727,149.2040,1,1);VehicleInfo[fly_car[0]][eVehicleFuel] = 100;
	//Pickups
 	Pickup[0] = CreatePickup(1239, 1, 207.8300,-102.2150,1005.2578, -1);
 	Pickup[1] = CreatePickup(1239, 1, -2254.9001,2557.4597,3.9948, -1);
    Pickup[2] = CreatePickup(1239, 1, -2375.7422,2216.0190,4.9844, -1);
    Pickup[3] = CreatePickup(1239, 1, 365.0197,-5.3500,1001.8516, -1);
    Pickup[4] = CreatePickup(1239, 1, 2508.8284,-2119.4658,13.5469, -1);
    Pickup[5] = CreatePickup(1239, 1, 2767.9299,-1611.6864,10.9219, -1);
    Pickup[6] = CreatePickup(1239, 1, -2329.0156, 1528.7533, 0.7219, -1);
    Pickup[7] = CreatePickup(1239, 1, 2099.6868,-2062.7520,13.5544, -1);
    Pickup[8] = CreatePickup(1239,1,1748.7014,-2421.0500,13.5547,-1);

	//Areas:
	ImpoundLotArea = CreateDynamicCircle(-1459.5227, 1962.9796, 47.9479, 0, 0);
	//fenecs
	CreateDynamicObject(970,2472.233,-2103.432,13.145,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(970,2472.226,-2107.573,13.145,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(970,2472.218,-2111.744,13.145,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(970,2472.213,-2115.857,13.145,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(970,2472.207,-2119.989,13.145,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(970,2496.409,-2103.667,13.145,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(970,2496.401,-2107.827,13.145,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
 	CreateDynamicObject(970,2496.394,-2111.967,13.145,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(970,2496.386,-2116.087,13.145,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(970,2496.380,-2120.238,13.145,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(970,2520.231,-2103.632,13.145,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(970,2520.225,-2107.724,13.145,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(970,2520.217,-2111.855,13.145,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(970,2520.210,-2115.976,13.145,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(970,2520.203,-2120.086,13.145,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(970,2449.052,-2103.572,13.145,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(970,2449.046,-2107.683,13.155,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(970,2449.038,-2111.812,13.155,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(970,2449.031,-2115.944,13.155,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(970,2449.023,-2120.065,13.155,0.000,0.000,-90.099,-1,-1,-1,300.000,300.000);
	//acotrs
	actor[0] = CreateActor(17,2508.9541,-2120.5811,13.5469,0.5654);//2508.8284,-2119.4658,13.5469
	//chirstmas mapping
	CreateDynamicObject(9482,1426.577,-1885.795,16.305,0.000,0.000,-91.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1423,1440.141,-1869.499,13.087,0.000,0.000,-93.700,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1423,1462.543,-1874.985,13.087,0.000,0.000,-93.700,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19062,1430.647,-1883.802,19.627,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19062,1429.026,-1883.802,19.627,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19062,1427.466,-1883.802,19.627,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19062,1425.386,-1883.802,19.627,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19062,1423.186,-1883.802,19.627,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19062,1423.186,-1887.781,19.627,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19062,1425.906,-1887.781,19.627,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19062,1427.636,-1887.781,19.627,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19062,1429.516,-1887.781,19.627,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19062,1430.977,-1887.781,19.627,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19076,1432.981,-1882.719,12.252,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19076,1419.241,-1882.719,12.252,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19076,1419.241,-1882.719,12.252,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1226,1381.017,-1922.409,21.332,0.000,0.000,79.800,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1226,1308.145,-1907.396,27.072,0.000,0.000,79.800,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19062,1379.790,-1929.020,24.637,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19062,1380.570,-1923.880,24.567,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19062,1307.700,-1908.885,30.314,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19062,1306.959,-1913.895,30.184,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1342,1275.129,-2011.367,59.002,-1.400,0.000,-93.300,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1342,1271.955,-2011.184,59.080,-1.400,0.000,-93.300,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1342,1268.760,-2011.000,59.158,-1.400,0.000,-93.300,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1342,1265.816,-2010.830,59.230,-1.400,0.000,-93.300,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19066,1175.093,-2037.036,76.181,0.900,35.900,-0.700,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19076,1174.904,-2036.681,68.192,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19076,1174.904,-2037.721,68.192,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19076,1174.195,-2037.329,68.192,0.000,0.000,-86.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19076,1175.292,-2037.254,68.192,0.000,0.000,-86.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19061,1174.943,-2037.136,80.449,0.000,-175.000,-150.300,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1723,1143.710,-2061.449,68.013,0.000,0.000,178.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1723,1146.689,-2061.547,68.013,0.000,0.000,178.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1723,1149.637,-2061.644,68.013,0.000,0.000,178.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1723,1152.576,-2061.742,68.013,0.000,0.000,178.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1723,1155.504,-2061.840,68.013,0.000,0.000,178.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1723,1140.963,-2060.314,68.013,0.000,0.000,86.400,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1723,1141.147,-2057.391,68.013,0.000,0.000,86.400,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1723,1141.332,-2054.456,68.013,0.000,0.000,86.400,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1723,1141.516,-2051.533,68.013,0.000,0.000,86.400,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1723,1141.700,-2048.609,68.013,0.000,0.000,86.400,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1723,1158.432,-2061.937,68.013,0.000,0.000,178.099,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1723,1141.883,-2045.694,68.013,0.000,0.000,86.400,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19129,1197.667,-2056.586,68.003,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1188.111,-2066.894,68.680,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1188.111,-2066.894,69.820,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1188.111,-2066.894,71.020,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1188.111,-2066.894,71.020,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1188.821,-2066.879,68.680,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1188.821,-2066.879,69.870,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1188.821,-2066.879,71.010,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1189.491,-2066.864,68.680,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1189.491,-2066.864,69.860,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1189.491,-2066.864,71.010,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1190.191,-2066.850,68.680,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1190.191,-2066.850,69.810,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1190.191,-2066.850,71.020,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1190.790,-2066.838,68.680,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1190.790,-2066.838,69.830,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1190.790,-2066.838,71.020,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1191.369,-2066.827,68.680,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1191.380,-2066.826,69.840,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1191.380,-2066.826,71.020,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1191.920,-2066.815,68.680,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1191.920,-2066.815,69.840,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1191.920,-2066.815,71.010,0.000,0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1192.530,-2066.800,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1192.530,-2066.800,69.830,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1192.530,-2066.800,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1193.190,-2066.786,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1193.190,-2066.786,69.800,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1193.190,-2066.786,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1193.900,-2066.800,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1193.900,-2066.800,69.830,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1193.900,-2066.800,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1194.560,-2066.786,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1194.560,-2066.786,69.800,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1194.560,-2066.786,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1195.250,-2066.800,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1195.250,-2066.800,69.830,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1195.250,-2066.800,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1195.911,-2066.786,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1195.911,-2066.786,69.800,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1195.911,-2066.786,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1196.620,-2066.800,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1196.620,-2066.800,69.830,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1196.620,-2066.800,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1197.281,-2066.786,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1197.281,-2066.786,69.800,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1197.281,-2066.786,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1197.931,-2066.800,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1197.931,-2066.800,69.830,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1197.931,-2066.800,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1198.591,-2066.786,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1198.591,-2066.786,69.800,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1198.591,-2066.786,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1199.301,-2066.800,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1199.301,-2066.800,69.830,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1199.301,-2066.800,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1199.961,-2066.786,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1199.961,-2066.786,69.800,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1199.961,-2066.786,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1200.641,-2066.800,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1200.641,-2066.800,69.830,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1200.641,-2066.800,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1201.302,-2066.786,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1201.302,-2066.786,69.800,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1201.302,-2066.786,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1202.011,-2066.800,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1202.011,-2066.800,69.830,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1202.011,-2066.800,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1202.672,-2066.786,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1202.672,-2066.786,69.800,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1202.672,-2066.786,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1203.242,-2066.800,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1203.242,-2066.800,69.830,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1203.242,-2066.800,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1203.902,-2066.786,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1203.902,-2066.786,69.800,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1203.902,-2066.786,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1204.612,-2066.800,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1204.612,-2066.800,69.830,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1204.612,-2066.800,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1205.311,-2066.786,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1205.311,-2066.786,69.800,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1205.311,-2066.786,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1205.311,-2066.786,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1205.311,-2066.786,69.800,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1205.311,-2066.786,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1205.951,-2066.786,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1205.951,-2066.786,69.800,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1205.951,-2066.786,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1206.622,-2066.786,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1206.622,-2066.786,69.800,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1206.622,-2066.786,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1207.332,-2066.786,68.680,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1207.332,-2066.786,69.800,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2232,1207.332,-2066.786,71.010,-0.000,-0.000,-178.799,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(11686,1199.140,-2008.031,67.970,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(11686,1194.510,-2008.031,67.970,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(11686,1189.959,-2008.031,67.970,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19831,1205.539,-2029.781,67.782,0.000,0.000,-94.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19831,1205.663,-2028.015,67.782,0.000,0.000,-94.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19831,1205.790,-2026.190,67.782,0.000,0.000,-94.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19831,1205.937,-2024.095,67.782,0.000,0.000,-94.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19831,1206.059,-2022.349,67.782,0.000,0.000,-94.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19831,1206.188,-2020.504,67.782,0.000,0.000,-94.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(3040,1244.984,-2015.389,60.798,0.000,0.000,-1.199,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(3039,1254.891,-2011.475,58.438,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2635,1256.646,-2011.447,58.934,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2453,1256.632,-2011.462,59.687,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(2646,1254.049,-2012.290,59.206,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(10838,1264.910,-2048.096,74.300,0.000,0.000,-92.700,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(18728,1270.390,-2054.285,60.805,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(18728,1254.940,-2052.104,60.805,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(18728,1271.265,-1899.624,25.841,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(18728,1271.265,-1913.605,25.841,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(9241,1268.049,-2081.502,60.001,0.000,0.000,-90.500,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(1270,1309.446,-2062.440,57.976,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(9623,1379.503,-2050.063,57.350,0.000,0.000,-75.100,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19315,1331.225,-1927.393,21.930,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19315,1320.355,-1927.393,23.270,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19315,1320.355,-1938.173,26.080,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19060,1240.013,-2035.429,61.160,0.000,-177.299,-1.399,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19060,1239.934,-2038.678,61.160,0.000,-177.299,-1.399,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19056,1178.084,-2036.385,68.741,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19056,1178.084,-2034.745,68.741,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(19056,1178.084,-2038.365,68.741,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(18864,1287.448,-2006.431,86.230,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(18864,1174.894,-1994.749,94.648,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(18864,1146.094,-2020.145,77.385,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	CreateDynamicObject(18864,1261.871,-2039.828,70.178,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);


	
	NAVTD[0] = TextDrawCreate(404.319183, 409.916809, "box");
	TextDrawLetterSize(NAVTD[0], 0.000000, 1.941436);
	TextDrawTextSize(NAVTD[0], 498.000000, 0.000000);
	TextDrawAlignment(NAVTD[0], 1);
	TextDrawColor(NAVTD[0], -1);
	TextDrawUseBox(NAVTD[0], 1);
	TextDrawBoxColor(NAVTD[0], 100);
	TextDrawSetShadow(NAVTD[0], 0);
	TextDrawSetOutline(NAVTD[0], 0);
	TextDrawBackgroundColor(NAVTD[0], 255);
	TextDrawFont(NAVTD[0], 1);
	TextDrawSetProportional(NAVTD[0], 1);
	TextDrawSetShadow(NAVTD[0], 0);

	NAVTD[1] = TextDrawCreate(404.787597, 399.999847, "Gps Info");
	TextDrawLetterSize(NAVTD[1], 0.299736, 1.115833);
	TextDrawAlignment(NAVTD[1], 1);
	TextDrawColor(NAVTD[1], -5963521);
	TextDrawSetShadow(NAVTD[1], 1);
	TextDrawSetOutline(NAVTD[1], 0);
	TextDrawBackgroundColor(NAVTD[1], 255);
	TextDrawFont(NAVTD[1], 0);
	TextDrawSetProportional(NAVTD[1], 1);
	TextDrawSetShadow(NAVTD[1], 1);
	
	g_Discord_Chat = DCC_FindChannelById("786587529872408617"); // Discord channel ID
	new string[128];
    format(string, sizeof string, "Server Sucessfully restarted(May Be New Updates)");
    DCC_SendChannelMessage(g_Discord_Chat, string);
    SetTimer("MinuteSync", 60000, 1);
    for (new x=0; x<MAX_VEHICLES; x++)
        {
                LightPwr[x]=1;
                Flasher[x]=0;
                FlasherState[x]=0;
        }
	FlashTimer = SetTimer("FlasherFunc",200,1); // "200" is the speed from the flashing headlights
	SetTimer( "rMSG",AUTOMSGTIME, true );
	return 1;
}

public OnGameModeExit()
{
	foreach (new i : Player)
	{
		SetPlayerName(i, e_pAccountData[i][mAccName]);
		SaveCharacter(i); SaveCharacterPos(i);
	}
	KillTimer(maintimer);
	KillTimer(speedotimer);
	//Saving systems:
	SaveFactions();
	SaveProperties();
	SaveBusinesses();

	//Closing database:
	mysql_close(ourConnection);
 	KillTimer(FlashTimer);
	for (new i = 0; i < MAX_VEHICLES; i++)
        	{
                DestroyObject(obj[i]);
                DestroyObject(obj2[i]);
        	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	Query_FillAcountWhitelist(playerid);
	ResetPlayer(playerid);
	PreloadAnimations(playerid);
	Voip[playerid] = false;
	SetPVarInt(playerid, "Speedo", 1);
	FalloutPlayer[playerid] = 0;

	SetPlayerColor(playerid, 0xAFAFAFFF);
	SetPlayerTeam(playerid, PLAYER_STATE_ALIVE);
	SetPVarInt(playerid, "DraggingPlayer", INVALID_PLAYER_ID);
	DeletePVar(playerid, "BeingDragged");

	//Dualies;
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 899);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 0);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 0);
	
	voiplabel[playerid] = Create3DTextLabel("Channel: Lobby", 0xE91616FF, 0,0,0,12,0,1);

	new
		existCheck[60]
	;

	mysql_format(ourConnection, existCheck, sizeof(existCheck), "SELECT * FROM bannedlist WHERE IpAddress = '%e'", ReturnIP(playerid));
	mysql_tquery(ourConnection, existCheck, "CheckBanList", "i", playerid);
	// We'll check if their IP is linked to any players on the bannedlist.
	// A master account DBID ban will be checked once they login.

	SetPlayerCamera(playerid);
	PlayAudioStreamForPlayer(playerid,"https://res.cloudinary.com/bossofficial1/video/upload/v1606998877/Justin_Bieber_-_Mistletoe_Official_Music_Video_erhudk.mp3");

	//Speedometer
	SpeedoText[playerid] = CreatePlayerTextDraw(playerid, 540.000000, 400.000000, " ");
 	PlayerTextDrawAlignment(playerid, SpeedoText[playerid], 1);
	PlayerTextDrawFont(playerid, SpeedoText[playerid],2);
	PlayerTextDrawLetterSize(playerid, SpeedoText[playerid], 0.310, 1.400);
	PlayerTextDrawSetShadow(playerid, SpeedoText[playerid],0);
	PlayerTextDrawUseBox(playerid, SpeedoText[playerid], 0);
	PlayerTextDrawBoxColor(playerid, SpeedoText[playerid], 0x00);

	//Unscrambler Textdraws:
	Unscrambler_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 199.873275, 273.593383, "<UNSCRAMBLED_WORD>");
	PlayerTextDrawLetterSize(playerid, Unscrambler_PTD[playerid][0], 0.206330, 1.118813);
	PlayerTextDrawAlignment(playerid, Unscrambler_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, Unscrambler_PTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, Unscrambler_PTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, Unscrambler_PTD[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, Unscrambler_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, Unscrambler_PTD[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, Unscrambler_PTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, Unscrambler_PTD[playerid][0], 0);


	Unscrambler_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 137.369461, 273.593383, "/unscramble");
	PlayerTextDrawLetterSize(playerid, Unscrambler_PTD[playerid][1], 0.206330, 1.118813);
	PlayerTextDrawAlignment(playerid, Unscrambler_PTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, Unscrambler_PTD[playerid][1], -490707969);
	PlayerTextDrawSetShadow(playerid, Unscrambler_PTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, Unscrambler_PTD[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, Unscrambler_PTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, Unscrambler_PTD[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, Unscrambler_PTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, Unscrambler_PTD[playerid][1], 0);

	Unscrambler_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 305.179687, 273.593383, "TO_UNSCRAMBLE_THE_WORD");
	PlayerTextDrawLetterSize(playerid, Unscrambler_PTD[playerid][2], 0.206330, 1.118813);
	PlayerTextDrawAlignment(playerid, Unscrambler_PTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, Unscrambler_PTD[playerid][2], -2147483393);
	PlayerTextDrawSetShadow(playerid, Unscrambler_PTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, Unscrambler_PTD[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, Unscrambler_PTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, Unscrambler_PTD[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, Unscrambler_PTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, Unscrambler_PTD[playerid][2], 0);

	Unscrambler_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 141.369705, 285.194091, "scrambledword");
	PlayerTextDrawLetterSize(playerid, Unscrambler_PTD[playerid][3], 0.206330, 1.118813);
	PlayerTextDrawAlignment(playerid, Unscrambler_PTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, Unscrambler_PTD[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, Unscrambler_PTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, Unscrambler_PTD[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, Unscrambler_PTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, Unscrambler_PTD[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, Unscrambler_PTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, Unscrambler_PTD[playerid][3], 0);

	Unscrambler_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 137.902801, 296.924377, "YOU_HAVE");
	PlayerTextDrawLetterSize(playerid, Unscrambler_PTD[playerid][4], 0.206330, 1.118813);
	PlayerTextDrawAlignment(playerid, Unscrambler_PTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, Unscrambler_PTD[playerid][4], -2147483393);
	PlayerTextDrawSetShadow(playerid, Unscrambler_PTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, Unscrambler_PTD[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, Unscrambler_PTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, Unscrambler_PTD[playerid][4], 2);
	PlayerTextDrawSetProportional(playerid, Unscrambler_PTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, Unscrambler_PTD[playerid][4], 0);

	Unscrambler_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 184.539016, 297.024383, "001");
	PlayerTextDrawLetterSize(playerid, Unscrambler_PTD[playerid][5], 0.206330, 1.118813);
	PlayerTextDrawAlignment(playerid, Unscrambler_PTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, Unscrambler_PTD[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, Unscrambler_PTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, Unscrambler_PTD[playerid][5], 1);
	PlayerTextDrawBackgroundColor(playerid, Unscrambler_PTD[playerid][5], 255);
	PlayerTextDrawFont(playerid, Unscrambler_PTD[playerid][5], 2);
	PlayerTextDrawSetProportional(playerid, Unscrambler_PTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, Unscrambler_PTD[playerid][5], 0);

	Unscrambler_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 202.540191, 297.124389, "SECONDS_LEFT_TO_FINISh.");
	PlayerTextDrawLetterSize(playerid, Unscrambler_PTD[playerid][6], 0.206330, 1.118813);
	PlayerTextDrawAlignment(playerid, Unscrambler_PTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, Unscrambler_PTD[playerid][6], -2147483393);
	PlayerTextDrawSetShadow(playerid, Unscrambler_PTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, Unscrambler_PTD[playerid][6], 1);
	PlayerTextDrawBackgroundColor(playerid, Unscrambler_PTD[playerid][6], 255);
	PlayerTextDrawFont(playerid, Unscrambler_PTD[playerid][6], 2);
	PlayerTextDrawSetProportional(playerid, Unscrambler_PTD[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, Unscrambler_PTD[playerid][6], 0);

	//Plate Textdraw:
	CarBought_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 97.333351, 291.629669, "YOUR_NEW_PLATE_HAS_BEEN_SET");
	PlayerTextDrawLetterSize(playerid, CarBought_PTD[playerid][0], 0.248666, 1.259851);
	PlayerTextDrawAlignment(playerid, CarBought_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, CarBought_PTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, CarBought_PTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, CarBought_PTD[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, CarBought_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, CarBought_PTD[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, CarBought_PTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, CarBought_PTD[playerid][0], 0);


	CarBought_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 97.533348, 302.630340, "PLATEHERE");
	PlayerTextDrawLetterSize(playerid, CarBought_PTD[playerid][1], 0.248666, 1.259851);
	PlayerTextDrawAlignment(playerid, CarBought_PTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, CarBought_PTD[playerid][1], -490707969);
	PlayerTextDrawSetShadow(playerid, CarBought_PTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, CarBought_PTD[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, CarBought_PTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, CarBought_PTD[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, CarBought_PTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, CarBought_PTD[playerid][1], 0);
	
	RemoveBuildingForPlayer(playerid, 9301, -2530.3516, 2346.2031, 7.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 9373, -2530.3516, 2346.2031, 7.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1617, -2548.9922, 2352.3359, 11.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 1689, -2544.5547, 2348.0156, 13.2422, 0.25);
	RemoveBuildingForPlayer(playerid, 1617, -2539.6172, 2352.3359, 11.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, -2527.2422, 2353.1250, 4.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, -2520.7188, 2353.1250, 4.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, -2524.0625, 2353.1250, 4.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 9314, -2493.8594, 2363.4297, 14.8750, 0.25);
	RemoveBuildingForPlayer(playerid, 9379, -2445.1719, 2311.6328, 9.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, -2503.0703, 2364.2188, 4.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1346, -2451.4063, 2321.0234, 5.3203, 0.25);
	RemoveBuildingForPlayer(playerid, 9244, -2445.1719, 2311.6328, 9.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, -2503.0469, 2368.0469, 4.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, -2506.6953, 2369.6641, 4.3906, 0.25);
	RemoveBuildingForPlayer(playerid, 1223, -2480.5781, 2220.3359, 3.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 3425, -1513.5625, 1953.1563, 58.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 11501, -1499.2578, 1956.2344, 47.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 11502, -1508.5859, 1975.4063, 47.4141, 0.25);

	//Taxi
	RemoveBuildingForPlayer(playerid, 11611, -1383.5547, 2616.5234, 56.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 11453, -1414.5078, 2650.4844, 57.5625, 0.25);

	//Mod/Pay 'n spray
	RemoveBuildingForPlayer(playerid, 5043, 1843.3672, -1856.3203, 13.8750, 0.25);
	RemoveBuildingForPlayer(playerid, 5340, 2644.8594, -2039.2344, 14.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 5422, 2071.4766, -1831.4219, 14.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 5856, 1024.9844, -1029.3516, 33.1953, 0.25);
	RemoveBuildingForPlayer(playerid, 5779, 1041.3516, -1025.9297, 32.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 6400, 488.2813, -1734.6953, 12.3906, 0.25);
	RemoveBuildingForPlayer(playerid, 10575, -2716.3516, 217.4766, 5.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 11313, -1935.8594, 239.5313, 35.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 11319, -1904.5313, 277.8984, 42.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 9625, -2425.7266, 1027.9922, 52.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 9093, 2386.6563, 1043.6016, 11.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 8957, 2393.7656, 1483.6875, 12.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 7709, 2006.0000, 2303.7266, 11.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 7891, 1968.7422, 2162.4922, 12.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3294, -1420.5469, 2591.1563, 57.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 3294, -100.0000, 1111.4141, 21.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 13028, 720.0156, -462.5234, 16.8594, 0.25);
	
	//Map Markers//
	marker[0] = SetPlayerMapIcon(playerid, 1, -2510.7236,2277.1428,4.9844, 45, 0, MAPICON_LOCAL);
	marker[1] = SetPlayerMapIcon(playerid, 2, -2256.1145,2554.6113,3.4629, 9, 0, MAPICON_LOCAL);
	marker[2] = SetPlayerMapIcon(playerid, 3, -2501.7581,2339.9995,4.9844, 22, 0, MAPICON_LOCAL);
	marker[3] = SetPlayerMapIcon(playerid, 4, -2457.4702,2311.5356,4.9844, 18, 0, MAPICON_LOCAL);
	marker[4] = SetPlayerMapIcon(playerid, 5, 1466.6989,-1012.2218,26.8438, 52, 0, MAPICON_LOCAL);
	marker[5] = SetPlayerMapIcon(playerid, 6,  2468.4824,2228.1550,4.8438, 53, 0, MAPICON_LOCAL);
	marker[6] = SetPlayerMapIcon(playerid, 7,  2245.3838,2292.9392,4.9699, 55, 0, MAPICON_LOCAL);
	marker[7] = SetPlayerMapIcon(playerid, 8,  1481.2655,-1769.7819,18.7958, 52, 0, MAPICON_LOCAL);
	marker[8] = SetPlayerMapIcon(playerid, 9,  1939.9840,-1769.2646,13.3828, 63, 0, MAPICON_LOCAL);
	marker[9] = SetPlayerMapIcon(playerid, 10, 1412.5907,-1699.8003,13.5395, 45, 0, MAPICON_LOCAL);
	marker[10] = SetPlayerMapIcon(playerid,11, 1837.0367,-1682.3685,13.3229, 48, 0, MAPICON_LOCAL);
	marker[11] = SetPlayerMapIcon(playerid,12, 1367.1736,-1280.2219,13.5469, 6 , 0, MAPICON_LOCAL);
	marker[12] = SetPlayerMapIcon(playerid,13, 556.1899,-1264.2535,17.2422, 55,0,MAPICON_LOCAL);
	marker[13] = SetPlayerMapIcon(playerid,14, 2111.5747,-2093.4019,13.5469,51,0,MAPICON_LOCAL);
	marker[14] = SetPlayerMapIcon(playerid,15, 1352.1154,-1756.2710,13.5078,17,0,MAPICON_LOCAL);
	
	NAVpTD[playerid] = CreatePlayerTextDraw(playerid, 405.724487, 415.166564, "Distance Left: ~y~0000.00m");
	PlayerTextDrawLetterSize(playerid, NAVpTD[playerid], 0.179326, 1.109999);
	PlayerTextDrawAlignment(playerid, NAVpTD[playerid], 1);
	PlayerTextDrawColor(playerid, NAVpTD[playerid], -1);
	PlayerTextDrawSetShadow(playerid, NAVpTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, NAVpTD[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, NAVpTD[playerid], 255);
	PlayerTextDrawFont(playerid, NAVpTD[playerid], 2);
	PlayerTextDrawSetProportional(playerid, NAVpTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, NAVpTD[playerid], 0);
	
	new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof name);
    
    ApplyAnimation(playerid, "BOMBER", "null", 0.0, false, false, false, false, 0, false); // I used these lines to prevent animation bugs.
	ApplyAnimation(playerid, "ROB_BANK", "null", 0.0, false, false, false, false, 0, false);

	SetPVarInt(playerid, "pSafeID", -1);

	xRob_TD[playerid][0] = CreatePlayerTextDraw(playerid, 191.141998, 212.749984, "box");
	PlayerTextDrawLetterSize(playerid, xRob_TD[playerid][0], 0.000000, 10.983894);
	PlayerTextDrawTextSize(playerid, xRob_TD[playerid][0], 438.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, xRob_TD[playerid][0], 1);
	PlayerTextDrawColor(playerid, xRob_TD[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, xRob_TD[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, xRob_TD[playerid][0], 50);
	PlayerTextDrawSetShadow(playerid, xRob_TD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, xRob_TD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, xRob_TD[playerid][0], 255);
	PlayerTextDrawFont(playerid, xRob_TD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, xRob_TD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, xRob_TD[playerid][0], 0);

	xRob_TD[playerid][1] = CreatePlayerTextDraw(playerid, 193.953109, 198.750030, "Safe Robbery");
	PlayerTextDrawLetterSize(playerid, xRob_TD[playerid][1], 0.457159, 1.903331);
	PlayerTextDrawAlignment(playerid, xRob_TD[playerid][1], 1);
	PlayerTextDrawColor(playerid, xRob_TD[playerid][1], -1378294017);
	PlayerTextDrawSetShadow(playerid, xRob_TD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, xRob_TD[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, xRob_TD[playerid][1], 255);
	PlayerTextDrawFont(playerid, xRob_TD[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, xRob_TD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, xRob_TD[playerid][1], 0);

	xRob_TD[playerid][2] = CreatePlayerTextDraw(playerid, 202.386459, 230.833358, "Safe is cracking...");
	PlayerTextDrawLetterSize(playerid, xRob_TD[playerid][2], 0.288491, 1.378332);
	PlayerTextDrawAlignment(playerid, xRob_TD[playerid][2], 1);
	PlayerTextDrawColor(playerid, xRob_TD[playerid][2], -5963521);
	PlayerTextDrawSetShadow(playerid, xRob_TD[playerid][2], 1);
	PlayerTextDrawSetOutline(playerid, xRob_TD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, xRob_TD[playerid][2], 255);
	PlayerTextDrawFont(playerid, xRob_TD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, xRob_TD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, xRob_TD[playerid][2], 1);

	xRob_TD[playerid][3] = CreatePlayerTextDraw(playerid, 202.386520, 253.000000, "box");
	PlayerTextDrawLetterSize(playerid, xRob_TD[playerid][3], 0.000000, 0.676428);
	PlayerTextDrawTextSize(playerid, xRob_TD[playerid][3], 427.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, xRob_TD[playerid][3], 1);
	PlayerTextDrawColor(playerid, xRob_TD[playerid][3], -1);
	PlayerTextDrawUseBox(playerid, xRob_TD[playerid][3], 1);
	PlayerTextDrawBoxColor(playerid, xRob_TD[playerid][3], 100);
	PlayerTextDrawSetShadow(playerid, xRob_TD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, xRob_TD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, xRob_TD[playerid][3], 255);
	PlayerTextDrawFont(playerid, xRob_TD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, xRob_TD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, xRob_TD[playerid][3], 0);

	xRob_TD[playerid][4] = CreatePlayerTextDraw(playerid, 201.449447, 250.666656, "IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII");
	PlayerTextDrawLetterSize(playerid, xRob_TD[playerid][4], 0.410775, 1.098333);
	PlayerTextDrawAlignment(playerid, xRob_TD[playerid][4], 1);
	PlayerTextDrawColor(playerid, xRob_TD[playerid][4], -5963521);
	PlayerTextDrawSetShadow(playerid, xRob_TD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, xRob_TD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, xRob_TD[playerid][4], 255);
	PlayerTextDrawFont(playerid, xRob_TD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, xRob_TD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, xRob_TD[playerid][4], 0);

	xRob_TD[playerid][5] = CreatePlayerTextDraw(playerid, 202.386489, 274.583312, "box");
	PlayerTextDrawLetterSize(playerid, xRob_TD[playerid][5], 0.000000, 2.925331);
	PlayerTextDrawTextSize(playerid, xRob_TD[playerid][5], 429.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, xRob_TD[playerid][5], 1);
	PlayerTextDrawColor(playerid, xRob_TD[playerid][5], 150);
	PlayerTextDrawUseBox(playerid, xRob_TD[playerid][5], 1);
	PlayerTextDrawBoxColor(playerid, xRob_TD[playerid][5], 100);
	PlayerTextDrawSetShadow(playerid, xRob_TD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, xRob_TD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, xRob_TD[playerid][5], 255);
	PlayerTextDrawFont(playerid, xRob_TD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, xRob_TD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, xRob_TD[playerid][5], 0);

	xRob_TD[playerid][6] = CreatePlayerTextDraw(playerid, 205.666137, 275.749877, " ");
	PlayerTextDrawLetterSize(playerid, xRob_TD[playerid][6], 0.227115, 1.162497);
	PlayerTextDrawAlignment(playerid, xRob_TD[playerid][6], 1);
	PlayerTextDrawColor(playerid, xRob_TD[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, xRob_TD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, xRob_TD[playerid][6], 1);
	PlayerTextDrawBackgroundColor(playerid, xRob_TD[playerid][6], 255);
	PlayerTextDrawFont(playerid, xRob_TD[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, xRob_TD[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, xRob_TD[playerid][6], 0);

	xRob_TD[playerid][7] = CreatePlayerTextDraw(playerid, 302.650115, 303.750061, "Press LSHIFT to cancel robbery.");
	PlayerTextDrawLetterSize(playerid, xRob_TD[playerid][7], 0.178388, 0.946666);
	PlayerTextDrawAlignment(playerid, xRob_TD[playerid][7], 1);
	PlayerTextDrawColor(playerid, xRob_TD[playerid][7], -2139062017);
	PlayerTextDrawSetShadow(playerid, xRob_TD[playerid][7], 1);
	PlayerTextDrawSetOutline(playerid, xRob_TD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, xRob_TD[playerid][7], 255);
	PlayerTextDrawFont(playerid, xRob_TD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, xRob_TD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, xRob_TD[playerid][7], 1);
	//chirstmas
	RemoveBuildingForPlayer(playerid, 691, 1258.170, -2081.929, 55.789, 0.250);
	RemoveBuildingForPlayer(playerid, 691, 1248.199, -2089.949, 56.250, 0.250);
	RemoveBuildingForPlayer(playerid, 691, 1268.400, -2092.800, 55.789, 0.250);
	RemoveBuildingForPlayer(playerid, 618, 1258.199, -2095.280, 56.242, 0.250);
	RemoveBuildingForPlayer(playerid, 618, 1278.020, -2098.949, 53.929, 0.250);
	RemoveBuildingForPlayer(playerid, 762, 1288.219, -2093.459, 56.960, 0.250);
	RemoveBuildingForPlayer(playerid, 691, 1419.270, -2004.550, 48.304, 0.250);

	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new sid = GetPVarInt(playerid, "pSafeID");
	if(sid != -1) safeCooldown(playerid, sid);
	for (new i = 0; i < sizeof(ReportInfo); i ++)
	{
		if(ReportInfo[i][rReportBy] == playerid)
		{
			ReportInfo[i][rReportExists] = false;
			ReportInfo[i][rReportBy] = INVALID_PLAYER_ID;
		}
	}
	KillTimer(Deadtimer[playerid]);
	foreach(new i : Player)
	{
		if(PlayerInfo[i][pFactionInvitedBy] == playerid)
		{
			PlayerInfo[i][pFactionInvite] = 0;
			PlayerInfo[i][pFactionInvitedBy] = INVALID_PLAYER_ID;
			SendClientMessage(i, COLOR_YELLOW, "Your faction invitation was disregarded. Your inviter disconnected.");
		}
	}
    Delete3DTextLabel(voiplabel[playerid]);
    
    new factionid = PlayerInfo[playerid][pFaction];
    if(PlayerInfo[playerid][pPoliceDuty])
    {FactionOnDuty[factionid] -= 1;}
    
	new playerTime = NetStats_GetConnectedTime(playerid);
	new secondsConnection = (playerTime % (1000*60*60)) / (1000*60);
	// Converting their connection time into minutes;
	if(reason == 0)
	{
	SendNearbyMessage(playerid, 20.0, COLOR_YELLOW, "%s has disconnected from the server (Crashed)", ReturnName(playerid));
	}
	else
	{
	SendNearbyMessage(playerid, 20.0, COLOR_YELLOW, "%s has disconnected from the server (Quit)", ReturnName(playerid));
	}

	PlayerInfo[playerid][pLastOnlineTime] = secondsConnection;
	SaveCharacter(playerid); SaveCharacterPos(playerid);
	
	if(pNavState[playerid])
	{
		KillTimer(pNavTimer[playerid]);
		DestroyObject(ok[playerid]);
		DisablePlayerCheckpoint(playerid);
		pNavState[playerid] = 0;
	}
 	new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof name);

    if (_:g_Discord_Chat == 0)
    g_Discord_Chat = DCC_FindChannelById("786587529872408617"); // Discord channel ID

    new string[128];
    format(string, sizeof string, " ```Am sad to say this but %s left the server```:cry~1:", name);
    DCC_SendChannelMessage(g_Discord_Chat, string);
    if(FalloutPlayer[playerid] == 1)
	{
	   FalloutPlayers--;

	   new pstring[100];
	   new pname[22];

	   GetPlayerName(playerid,pname,22);

	   format(pstring,sizeof(string),"%s has been eliminated from the Fallout Event (Disconnect)",pname);
	   SendClientMessageToAll(COLOR_RED,pstring);

	}
	return 1;
}

function:SetPlayerCamera(playerid)
{
	new rand = random(3);

	switch(rand)
	{
		case 0:
		{
		    SetPlayerCameraPos(playerid, -2565.6477, 2223.3730, 35.5751);
			SetPlayerCameraLookAt(playerid, -2566.0691, 2222.4512, 35.8001);
		}
		case 1:
		{
   			SetPlayerCameraPos(playerid, -2203.0139, 2099.1338, 65.2236);
			SetPlayerCameraLookAt(playerid, -2203.5967, 2099.9641, 65.1436);
		}
		case 2:
		{
   			SetPlayerCameraPos(playerid, -2261.1272, 2635.6914, 96.0276);
			SetPlayerCameraLookAt(playerid, -2261.7207, 2634.8728, 95.8276);
		}
	}
	return 1;
}

function:CheckBanList(playerid)
{
	if(!cache_num_rows())
	{
		new existCheck[129];

		mysql_format(ourConnection, existCheck, sizeof(existCheck), "SELECT acc_dbid FROM masters WHERE acc_name = '%e'", ReturnName(playerid));
		mysql_tquery(ourConnection, existCheck, "LogPlayerIn", "i", playerid);
	}
	else
	{
		SendServerMessage(playerid, "Your IP \"%s\" is banned from our servers.", ReturnIP(playerid));
		SendServerMessage(playerid, "You may appeal your ban on our forums.");
		return KickEx(playerid);
	}
	return 1;
}

function:Query_FillAcountWhitelist(playerid)
{
    new query[131];

    mysql_format(ourConnection, query, sizeof(query), "SELECT mwhitelist FROM masters WHERE acc_name = '%e'", ReturnName(playerid));
    mysql_tquery(ourConnection, query, "FillAcountWhitelist", "i", playerid);
}

function:FillAcountWhitelist(playerid) {
         e_pAccountData[playerid][mwhitelist] = cache_get_field_content_int(1, "mwhitelist", ourConnection);
}

function:LogPlayerIn(playerid)
{
	if(!cache_num_rows())
	{
		for(new i = 0; i < 3; i ++) { SendClientMessage(playerid, -1, " "); }

		SendClientMessageEx(playerid, COLOR_YELLOWEX, "The user (%s) you're connected with is not a registered master account.", ReturnName(playerid));
		SendClientMessage(playerid, -1, "You need to register this user to continue.");

		registerTime[playerid] = 1;

		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Welcome to MGMC Roleplay", "SERVER: You have 60 seconds to register!\nTIP: Please report all bugs that you\nmay have found to development.\n\n           Enter Your Password:", "Register", "Cancel");
		return 1;
	}

	loginTime[playerid] = 1;
	SendClientMessageEx(playerid, COLOR_YELLOW, "Welcome to MGMC Roleplay, %s {FFFFFF}["SCRIPT_REV"]", ReturnName(playerid));
	return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Welcome to MGMC Roleplay", "SERVER: You have 500 seconds to login!\nTIP: Please report all bugs that you\nmay have found to development.\n\n           Enter Your Password:", "Login", "Cancel");
}

function:OnSecretWordInput(playerid)
{
	/*
	if(!cache_num_rows())
	{
		SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You entered a bad security word. This was logged for security reasons.");
		KickEx(playerid);
		return 1;
	}
*/
	new logquery[128];
	mysql_format(ourConnection, logquery, sizeof(logquery), "SELECT * FROM bannedlist WHERE MasterDBID = %i", e_pAccountData[playerid][mDBID]);
	mysql_tquery(ourConnection, logquery, "Query_CheckBannedAccount", "i", playerid);
	return 1;
}
public OnPlayerEnterCheckpoint(playerid)
{
    if(truckcp[playerid] == 1)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
		new trailerid = GetVehicleModel(GetVehicleTrailer(vehicleid));
        new rand = random(sizeof(ftruck));
        if(IsTrailerAttachedToVehicle(vehicleid))
		{
			if(trailerid == 450)
			{
			    TogglePlayerControllable(playerid, 0);
                SetTimerEx("Freeze", 5000, false, "i", playerid);
    			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* The trucks PDA would show a location along with a new message *");
    			SendClientMessage(playerid, COLOR_CUBER, "_________________Tierra Robada Trucking Co._________________");
				SendClientMessage(playerid, COLOR_WHITE, "Description: Deliver the good to the designated area on your PDA.");
				SendClientMessage(playerid, COLOR_WHITE, "Goods: Fish");
				SetPlayerCheckpoint(playerid,ftruck[rand][0],ftruck[rand][1],ftruck[rand][2],1);
				truckcp[playerid] = 11;
			}
		}
		else return SendErrorMessage(playerid, "Your trailer is not attached to the truck");
		return 1;
	}
	if(truckcp[playerid] == 2)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
		new trailerid = GetVehicleModel(GetVehicleTrailer(vehicleid));
        new rand = random(sizeof(ctruck));
        if(IsTrailerAttachedToVehicle(vehicleid))
		{
			if(trailerid == 450)
			{
			    TogglePlayerControllable(playerid, 0);
                SetTimerEx("Freeze", 5000, false, "i", playerid);
    			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* The trucks PDA would show a location along with a new message *");
    			SendClientMessage(playerid, COLOR_TRUCK, "_________________Tierra Robada Trucking Co._________________");
				SendClientMessage(playerid, COLOR_WHITE, "Description: Deliver the clothes to the designated cleaner on your PDA.");
				SendClientMessage(playerid, COLOR_WHITE, "Goods: Ditry clothes");
				SetPlayerCheckpoint(playerid,ctruck[rand][0],ctruck[rand][1],ctruck[rand][2],1);
				truckcp[playerid] = 11;
			}
		}
		else return SendErrorMessage(playerid, "Your trailer is not attached to the truck");
		return 1;
	}
	if(truckcp[playerid] == 3)
	{
        new vehicleid = GetPlayerVehicleID(playerid);
		new trailerid = GetVehicleModel(GetVehicleTrailer(vehicleid));
        new rand = random(sizeof(vtruck));
        if(IsTrailerAttachedToVehicle(vehicleid))
		{
			if(trailerid == 450)
			{
			    TogglePlayerControllable(playerid, 0);
                SetTimerEx("Freeze", 5000, false, "i", playerid);
    			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* The trucks PDA would show a location along with a new message *");
    			SendClientMessage(playerid, COLOR_TRUCK, "_________________Tierra Robada Trucking Co._________________");
				SendClientMessage(playerid, COLOR_WHITE, "Description: Deliver the parts to the designated cleaner on your PDA.");
				SendClientMessage(playerid, COLOR_WHITE, "Goods: Scrap parts");
				SetPlayerCheckpoint(playerid,vtruck[rand][0],vtruck[rand][1],vtruck[rand][2],1);
				truckcp[playerid] = 11;
			}
		}
		else return SendErrorMessage(playerid, "Your trailer is not attached to the truck");
		return 1;
	}
	if(truckcp[playerid] == 4)
	{
        new vehicleid = GetPlayerVehicleID(playerid);
		new trailerid = GetVehicleModel(GetVehicleTrailer(vehicleid));
        new rand = random(sizeof(gtruck));
        if(IsTrailerAttachedToVehicle(vehicleid))
		{
			if(trailerid == 450)
			{
			    TogglePlayerControllable(playerid, 0);
                SetTimerEx("Freeze", 5000, false, "i", playerid);
    			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* The trucks PDA would show a location along with a new message *");
    			SendClientMessage(playerid, COLOR_TRUCK, "_________________Tierra Robada Trucking Co._________________");
				SendClientMessage(playerid, COLOR_WHITE, "Description: Deliver the parts to the designated cleaner on your PDA.");
				SendClientMessage(playerid, COLOR_WHITE, "Goods: Scrap parts");
				SetPlayerCheckpoint(playerid,gtruck[rand][0],gtruck[rand][1],gtruck[rand][2],1);
				truckcp[playerid] = 11;
			}
		}
		else return SendErrorMessage(playerid, "Your trailer is not attached to the truck");
		return 1;
	}
	if(truckcp[playerid] == 5)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
		new trailerid = GetVehicleModel(GetVehicleTrailer(vehicleid));
        new rand = random(sizeof(ptruck));
        if(IsTrailerAttachedToVehicle(vehicleid))
		{
			if(trailerid == 450)
			{
			    TogglePlayerControllable(playerid, 0);
                SetTimerEx("Freeze", 5000, false, "i", playerid);
    			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* The trucks PDA would show a location along with a new message *");
    			SendClientMessage(playerid, COLOR_TRUCK, "_________________Tierra Robada Trucking Co._________________");
				SendClientMessage(playerid, COLOR_WHITE, "Description: Deliver the fuel station marked on your PDA.");
				SendClientMessage(playerid, COLOR_WHITE, "Goods: Fuel");
				SetPlayerCheckpoint(playerid,ptruck[rand][0],ptruck[rand][1],ptruck[rand][2],1);
				truckcp[playerid] = 51;
			}
		}
		else return SendErrorMessage(playerid, "Your trailer is not attached to the truck");
		return 1;
	}
    if(truckcp[playerid] == 11)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
		new trailerid = GetVehicleModel(GetVehicleTrailer(vehicleid));
        if(IsTrailerAttachedToVehicle(vehicleid))
		{
			if(trailerid == 450)
			{
				TogglePlayerControllable(playerid, 0);
			    SetTimerEx("Freeze", 5000, false, "i", playerid);
				SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* The trucks PDA would show a location along with a new message *");
	    		SendClientMessage(playerid, COLOR_TRUCK, "_________________Tierra Robada Trucking Co._________________");
				SendClientMessage(playerid, COLOR_WHITE, "Description: Goods have been delivered, return the trailer.");
				SendClientMessage(playerid, COLOR_WHITE, "Goods: None");
				SetPlayerCheckpoint(playerid, -1296.2112,2688.9602,49.6332, 5.0);
				truckcp[playerid] = 12;
			}
		}
		else return SendErrorMessage(playerid, "Your trailer is not attached to the truck");
		return 1;
	}
	if(truckcp[playerid] == 12)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
		new trailerid = GetVehicleModel(GetVehicleTrailer(vehicleid));
		new traileridd = GetVehicleTrailer(vehicleid);
		new pay, str[128];

		if(IsTrailerAttachedToVehicle(vehicleid))
		{
			if(trailerid == 450)
			{
			    SetVehicleToRespawn(traileridd);
	    		pay = 1000 + randomEx(100,200);
	    		format(str, sizeof(str), "Payment: $%d", pay);
	    		GiveMoney(playerid, pay);
			    SendClientMessage(playerid, COLOR_TRUCK, "_________________Tierra Robada Trucking Co._________________");
				SendClientMessage(playerid, COLOR_WHITE, "Description: Goods have been delivred and the trailer has been returned.");
				SendClientMessage(playerid, COLOR_WHITE, str);
				PlayerInfo[playerid][pWorking] = 0;
				DisablePlayerCheckpoint(playerid);
			}
			truckcp[playerid] = 0;
		}
		else return SendErrorMessage(playerid, "Your trailer is not attached to the truck");
		return 1;
	}
    if(truckcp[playerid] == 51)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
		new trailerid = GetVehicleModel(GetVehicleTrailer(vehicleid));
        if(IsTrailerAttachedToVehicle(vehicleid))
		{
			if(trailerid == 584)
			{
				TogglePlayerControllable(playerid, 0);
			    SetTimerEx("Freeze", 5000, false, "i", playerid);
				SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* The trucks PDA would show a location along with a new message *");
	    		SendClientMessage(playerid, COLOR_TRUCK, "_________________Tierra Robada Trucking Co._________________");
				SendClientMessage(playerid, COLOR_WHITE, "Description: Goods have been delivered, return the trailer.");
				SendClientMessage(playerid, COLOR_WHITE, "Goods: None");
				SetPlayerCheckpoint(playerid, -1296.2112,2688.9602,49.6332, 5.0);
				truckcp[playerid] = 52;
			}
		}
		else return SendErrorMessage(playerid, "Your trailer is not attached to the truck");
		return 1;
	}
	if(truckcp[playerid] == 52)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
		new trailerid = GetVehicleModel(GetVehicleTrailer(vehicleid));
		new traileridd = GetVehicleTrailer(vehicleid);
		new pay, str[128];

		if(IsTrailerAttachedToVehicle(vehicleid))
		{
			if(trailerid == 584)
			{
			    SetVehicleToRespawn(traileridd);
	    		pay = 5000 + randomEx(100,200);
	    		format(str, sizeof(str), "Payment: $%d", pay);
	    		GiveMoney(playerid, pay);
			    SendClientMessage(playerid, COLOR_TRUCK, "_________________Tierra Robada Trucking Co._________________");
				SendClientMessage(playerid, COLOR_WHITE, "Description: Goods have been delivred and the trailer has been returned.");
				SendClientMessage(playerid, COLOR_WHITE, str);
				PlayerInfo[playerid][pWorking] = 0;
				DisablePlayerCheckpoint(playerid);
			}
			truckcp[playerid] = 0;
		}
		else return SendErrorMessage(playerid, "Your trailer is not attached to the truck");
		return 1;
	}
	if(smugglecp[playerid] == 1)
	{
	    ClearAnimations(playerid);
	    PlayerInfo[playerid][pCarry] = 1;
		ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0,1);
		SetPlayerCheckpoint(playerid, -830.9731,1985.0918,9.4007, 1.0);
   		SetPlayerAttachedObject(playerid, 9, 11745, 6, 0.1619, -0.0190, 0.0000, 0.0000, -79.3999, 97.4999, 1.0000, 1.0000, 1.0000, 0, 0);
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s's phone would beep, displaying a message.", ReturnName(playerid, 0));
		SCM(playerid, COLOR_WHITE,"Private Number: Good, now bring it to the designated area.");
		PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
		smugglecp[playerid] = 2;
		return 1;
	}
	if(smugglecp[playerid] == 2)
	{
	    new
		str[500];

 		if(PlayerInfo[playerid][pCarry] == 0)
	    {
	    	SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s's phone would beep, displaying a message.", ReturnName(playerid, 0));
	    	SCM(playerid, COLOR_WHITE, "Private Number: You know that I can see that you're not carrying one of my bags right?");
	    	return 1;
	    }
	    else
	    {
	        format(str, sizeof(str), "Alright good, you now have two options partner:\n\nOption 1: Continue the smuggle at higher risk with possibly more of a reward.\n(The cops will be alerted and you might even get payd less if I dont like the product)\n\nOption 2: You leave the bag here and I'll pay you.\n(I wont like you any less if you choose to leave it behind)\n\nIts up to you partner.\n- Jim");
	    	ShowPlayerDialog(playerid, DIALOG_SMUGGLE, DIALOG_STYLE_MSGBOX, "Private Number", str , "Continue", "Leave");
	    	return 1;
		}
	}
	if(smugglecp[playerid] == 3)
	{
	    new check = randomEx(4,6);
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* Shouting would be heard from inside the building.", ReturnName(playerid, 0));
		SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: Get in here partner. Lets see what you got!");
 		SetPlayerCheckpoint(playerid, 299.9676,308.2690,999.1484, 1.0);
 		smugglecp[playerid] = check;
  		return 1;
	}
	if(smugglecp[playerid] == 4)
	{
	    new pay, str[142];
	    pay = 200 + randomEx(50,100);
		ClearAnimations(playerid);
    	ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0,1);
    	format(str, sizeof(str), "Jim: You really thing I want anything like this? Here is $%d bucks for the effort.", pay);
	    SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* Jim would start laughing as he tosses the bag over the counter.", ReturnName(playerid, 0));
	    ApplyActorAnimation(ActorIlligalDealer, "RAPPING", "Laugh_01", 4.1, 0, 0, 0, 1, 0);
	    SendNearbyMessage(playerid, 20.0, COLOR_WHITE, str);
	   	PlayerInfo[playerid][pCarry] = 0;
	   	PlayerInfo[playerid][pSmuggling] = 0;
		RemovePlayerAttachedObject(playerid, 9);
		GiveMoney(playerid, 200);
		smugglecp[playerid] = 0;
		DisablePlayerCheckpoint(playerid);
		BusinessInfo[8][eBusinessProducts] += 1;
		SaveBusiness(8);
		return 1;
	}
	if(smugglecp[playerid] == 5)
	{
	    new pay, str[142];
	    pay = 500 + randomEx(100,200);
	    SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* Jim would start smiling as he faces %s.", ReturnName(playerid, 0));
	    format(str, sizeof(str), "Jim: Nice, really nice and the cops did not catch you with this? You deserve this. Here is: $%d.", pay);
	    SendNearbyMessage(playerid, 20.0, COLOR_WHITE, str);
	   	PlayerInfo[playerid][pCarry] = 0;
	   	PlayerInfo[playerid][pSmuggling] = 0;
		RemovePlayerAttachedObject(playerid, 9);
		GiveMoney(playerid, pay);
		smugglecp[playerid] = 0;
		BusinessInfo[8][eBusinessProducts] += 2;
		SaveBusiness(8);
		DisablePlayerCheckpoint(playerid);
	}
	if(pizzacp[playerid] == 1)
	{
	    if(IsPlayerInAnyVehicle(playerid))
	    {
   	 	SendErrorMessage(playerid, "Who delivers pizza's on their moped? Your progress has been reset.");
   	 	PlayerInfo[playerid][pCheckpoints] = 0;
   	 	PlayerInfo[playerid][pWorking] = 0;
   	 	return 1;
   	 	}
	    if(PlayerInfo[playerid][pCheckpoints] < 10)
	    {
	    PlayerInfo[playerid][pCheckpoints] += 1;
	    new rand = (1+pizzacp[playerid]+random(sizeof(pizza)-1))%sizeof(pizza);
		pizzacp[playerid] = 1;
		SetPlayerCheckpoint(playerid,pizza[rand][0],pizza[rand][1],pizza[rand][2],2);
		}
		else
		{
		SetPlayerCheckpoint(playerid, -2527.7644,2288.0918,4.5828, 1.0);
		pizzacp[playerid] = 2;
		}
		return 1;
	}
	if(pizzacp[playerid] == 2)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		SetVehicleToRespawn(vehicleid);
		DisablePlayerCheckpoint(playerid);
		PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
		PlayerInfo[playerid][pCheckpoints] = 0;
		PlayerInfo[playerid][pWorking] = 0;
		GiveMoney(playerid, 100);
		pizzacp[playerid] = 0;
		VehicleInfo[vehicleid][eVehicleFuel] = 100;
		SCM(playerid, COLOR_GREEN, "There you go here is $100!");
		DisablePlayerCheckpoint(playerid);
		SaveCharacter(playerid);
	}
	if(PlayerCheckpoint[playerid] == 1)
	{
		PlayerCheckpoint[playerid] = 0; DisablePlayerCheckpoint(playerid);
	}
	if(DMVcp[playerid] == 1)
	{
		SetPlayerCheckpoint(playerid, -2515.1328,2333.7400,4.2862, 3.0);
		PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
		DMVcp[playerid] = 2;
		return 1;
	}
	else if(DMVcp[playerid] == 2)
	{
	    SetPlayerCheckpoint(playerid, -2613.6426,2353.4683,7.9343, 3.0);
	    PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
		DMVcp[playerid] = 3;
		return 1;
	}
	else if(DMVcp[playerid] == 3)
	{
	    SetPlayerCheckpoint(playerid, -2554.6057,2403.2976,14.1692, 3.0);
	    PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
		DMVcp[playerid] = 4;
		return 1;
	}
	else if(DMVcp[playerid] == 4)
	{
	    SetPlayerCheckpoint(playerid, -2474.6069,2429.6021,15.1731, 3.0);
	    PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
		DMVcp[playerid] = 5;
		return 1;
	}
	else if(DMVcp[playerid] == 5)
	{
	    SetPlayerCheckpoint(playerid, -2435.2419,2460.8127,13.2388, 3.0);
	    PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
		DMVcp[playerid] = 6;
		return 1;
	}
	else if(DMVcp[playerid] == 6)
	{
	    SetPlayerCheckpoint(playerid, -2484.5864,2476.9229,17.4960, 3.0);
	    PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
		DMVcp[playerid] = 7;
		return 1;
	}
	else if(DMVcp[playerid] == 7)
	{
	    SetPlayerCheckpoint(playerid, -2465.2073,2525.0134,16.4999, 3.0);
	    PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
		DMVcp[playerid] = 8;
		return 1;
	}
	else if(DMVcp[playerid] == 8)
	{
	    SetPlayerCheckpoint(playerid, -2436.2249,2513.8616,13.5029, 3.0);
	    PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
		DMVcp[playerid] = 9;
		return 1;
	}
	else if(DMVcp[playerid] == 9)
	{
	    SetPlayerCheckpoint(playerid, -2418.2065,2475.8259,12.2325, 3.0);
	    PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
		DMVcp[playerid] = 10;
		return 1;
	}
	else if(DMVcp[playerid] == 10)
	{
	    SetPlayerCheckpoint(playerid, -2262.0657,2377.5652,4.5017, 3.0);
	    PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
		DMVcp[playerid] = 11;
		return 1;
	}
	else if(DMVcp[playerid] == 11)
	{
	    SetPlayerCheckpoint(playerid, -2345.5132,2405.6443,5.6795, 3.0);
	    PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
		DMVcp[playerid] = 12;
		return 1;
	}
	else if(DMVcp[playerid] == 12)
	{
	    SetPlayerCheckpoint(playerid, -2522.7236,2446.7732,17.0838, 3.0);
	    PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
		DMVcp[playerid] = 13;
		return 1;
	}
	else if(DMVcp[playerid] == 13)
	{
 		SetPlayerCheckpoint(playerid, -2712.3755,2367.8599,70.4668, 3.0);
 		PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
	    DMVcp[playerid] = 14;
	    return 1;
	}
	else if(DMVcp[playerid] == 14)
	{
 		SetPlayerCheckpoint(playerid, -2725.1042,2494.5933,76.1546, 3.0);
 		PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
	    DMVcp[playerid] = 15;
	    return 1;
	}
	else if(DMVcp[playerid] == 15)
	{
 		SetPlayerCheckpoint(playerid, -2135.4316,2625.5806,55.1755, 3.0);
 		PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
	    DMVcp[playerid] = 16;
	    return 1;
	}
	else if(DMVcp[playerid] == 16)
	{
 		SetPlayerCheckpoint(playerid, -1761.7670,2176.1162,15.8663, 3.0);
 		PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
	    DMVcp[playerid] = 17;
	    return 1;
	}
	else if(DMVcp[playerid] == 17)
	{
 		SetPlayerCheckpoint(playerid, -1688.5448,1913.2008,21.0508, 3.0);
 		PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
	    DMVcp[playerid] = 18;
	    return 1;
	}
	else if(DMVcp[playerid] == 18)
	{
 		SetPlayerCheckpoint(playerid, -1618.8381,1831.0037,25.2938, 3.0);
 		PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
	    DMVcp[playerid] = 19;
	    return 1;
	}
	else if(DMVcp[playerid] == 19)
	{
 		SetPlayerCheckpoint(playerid, -1576.8036,1932.7283,21.5961, 3.0);
 		PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
	    DMVcp[playerid] = 20;
	    return 1;
	}
	else if(DMVcp[playerid] == 20)
	{
 		SetPlayerCheckpoint(playerid, -1783.0490,2250.7134,23.1936, 3.0);
 		PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
	    DMVcp[playerid] = 21;
	    return 1;
	}
	else if(DMVcp[playerid] == 21)
	{
 		SetPlayerCheckpoint(playerid, -1964.0608,2554.7485,51.9878, 3.0);
 		PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
	    DMVcp[playerid] = 22;
	    return 1;
	}
	else if(DMVcp[playerid] == 22)
	{
 		SetPlayerCheckpoint(playerid, -2346.0205,2675.5637,57.4319, 3.0);
 		PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
	    DMVcp[playerid] = 23;
	    return 1;
	}
	else if(DMVcp[playerid] == 23)
	{
 		SetPlayerCheckpoint(playerid, -2750.4910,2347.4517,72.4504, 3.0);
 		PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
	    DMVcp[playerid] = 24;
	    return 1;
	}
	else if(DMVcp[playerid] == 24)
	{
 		SetPlayerCheckpoint(playerid, -2560.8140,2471.2170,18.6958, 3.0);
 		PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
	    DMVcp[playerid] = 25;
	    return 1;
	}
	else if(DMVcp[playerid] == 25)
	{
 		SetPlayerCheckpoint(playerid, -2482.1558,2243.6072,4.2950, 3.0);
 		PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
	    DMVcp[playerid] = 26;
	    return 1;
	}
	else if(DMVcp[playerid] == 26)
	{
		new vehicle;
		vehicle = GetPlayerVehicleID(playerid);
		SetVehicleToRespawn(vehicle);
		DisablePlayerCheckpoint(playerid);
		PlayerPlaySound(playerid, 1085,0.0,0.0,0.0);
		PlayerInfo[playerid][pDriversLicense] = 1;
		DMVcp[playerid] = 0;
		PlayerTakingLicense[playerid] = false;
		SCM(playerid, COLOR_GREEN, "Congratulations, you have passed the test and you now have a drivers license!");
		SaveCharacter(playerid);
		return 1;
	}
    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 609)
    {
        GivePlayerMoney(playerid,500);
        SendClientMessage(playerid,COLOR_YELLOW,"* You have earned $500!");
        DisablePlayerCheckpoint(playerid);
    }
	return 1;
}

forward MYSQL_Update_String(sqlid, table[], column[], str[]);
public MYSQL_Update_String(sqlid, table[], column[], str[])
{
	new query[280];
    mysql_format(ourConnection, query, sizeof(query), "UPDATE `%e` SET `%e` = '%e' WHERE SQLID = %d LIMIT 1", table, column, str, sqlid);
	mysql_tquery(ourConnection, query);
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch (dialogid)
	{
		case DIALOG_CONFIRM_SYS:
		{
			ConfirmDialog_Response(playerid, response);
			return 1;
		}
		case DIALOG_REGISTER:
		{
			if(!response)
			{
				SendClientMessage(playerid, COLOR_REDEX, "You were kicked for not registering.");
				return KickEx(playerid);
			}

			new insert[256];

			if(strlen(inputtext) > 128 || strlen(inputtext) < 3)
				return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Welcome to MGMC Roleplay", "SERVER: You have 60 seconds to register!\n\nYour password needs to be greater than 3 and less than 128 characters.\nTIP: Please report all bugs that you\nmay have found to development.\n\n           Enter Your Password:", "Select", "Cancel");

			mysql_format(ourConnection, insert, sizeof(insert), "INSERT INTO masters (acc_name, acc_pass, register_date, register_ip) VALUES('%e', sha1('%e'), '%e', '%e')", ReturnName(playerid), inputtext, ReturnDate(), ReturnIP(playerid));
			mysql_tquery(ourConnection, insert, "OnPlayerRegister", "i", playerid);
		}
		case DIALOG_HELP:
		{
			if(!response)
			{
				return 1;
			}
           	switch(listitem)
        	{
          	  	case 0:
        	    {
					ShowPlayerDialog(playerid, DIALOG_GENRALCOMMANDS, DIALOG_STYLE_MSGBOX, "General Commands:",
					"/stats,  /admins,  /report,  /o(oc)  /relog,  /pay,  /isafk,  /license,  /licenseexam,  /unimpound,  /fixr,  /phonebook,\n\
					/time,  /rcp,  /weapons,  /leavegun,  /grabgun,  /enter,  /exit,  /mask  /buy,  /setchannel,  /setslot,  /radio,  /b,  /pm,\n\
					/radiolow  /setspawn,  /levelup,  /bank,  /withdraw,  /balance,  /ammuhelp,  /buyclothes,  /gps, /gpsclose  /call,  /hangup,  /pickup,\n\
					/sms,  /loudspeaker, /factions", "Close", "");
					return 1;
        	    }
        	    case 1:
        	    {
					ShowPlayerDialog(playerid, DIALOG_VEHCOMMANDS, DIALOG_STYLE_MSGBOX, "Vehicle Commands:",
					"/engine,  /lights,  /vget,  /engine,  /unscramble,  /check,  /place,  /setstation,  /park,  /buyvehicle,  /refill,\n\
					/givecarkey,  /destroycar,  /vlock,  /trunk  /trackcar,  /carstats,  /hood,  /vlist,\n\
			  		/droplicense,  /hotwire,  /detach", "Close", "");
			  		return 1;
        	    }
        	    case 2:
        	    {
        	    	ShowPlayerDialog(playerid, DIALOG_JOBCOMMANDS, DIALOG_STYLE_MSGBOX, "Job Commands:",
        	    	"/jobhelp,  /getjob,  /quitjob,  /fishhelp,  /smugglehelp", "Close", "");
        	    	return 1;
        	    }
        	    case 3:
        	    {
        	        ShowPlayerDialog(playerid, DIALOG_BIZCOMMANDS, DIALOG_STYLE_MSGBOX, "Propery/Business Commands:",
        	        "/buyproperty, /sellproperty,  /lock,  /check,  /place,  /placepos,  /setstation,  /property,\n\
        	        /buybiz,  /bizinfo,  /bizfee,  /bizcash,  /sellbiz", "Close", "");
        	        return 1;
        	    }
        	    case 4:
        	    {
        	        new dialog[724];
        	        strcat(dialog, "/me,  /do,  /ame,  /my,  /amy,  /(s)hout,  /(l)ow,\n");
           	        strcat(dialog, "/crack,  /chat,  /hike,  /caract  /give,  /liftup,  /putdown, /cry,  /mourn,  /endchat,  /show,  /shoutanim,  /look,\n");
        	        strcat(dialog, "/drunk,  /play,  /pee,  /wank,  /sit,  /bball,  /scratch,  /reload,  /injured,  /gsign,  /chill,  /tag,  /camera,\n");
        	        strcat(dialog, "/rap,  /think,  /box,  /tired,  /bar,  /bat,  /lean,  /dance,  /searchfiles,  /kiss,  /handsup,  /bomb,  /getarrested,\n");
        	        strcat(dialog, "/laugh,  /lookout,  /aim,  /crossarms,  /car,  /lay,  /what,  /hide,  /vomit,  /eat,  /wave,  /strip,  /chant,  /slapass,\n");
        	        strcat(dialog, "/deal,  /fucku,  /taichi,  /stopanim\n");
        	        ShowPlayerDialog(playerid, DIALOG_EMOCOMMANDS, DIALOG_STYLE_MSGBOX, "Emotes/Animations:",dialog, "Close", "");
        	        return 1;
				}
			}
			return 1;
		}
		case DIALOG_LOGINUCP:
		{
	    	new buffer[129], query[512];
			if(!response)
			{
				SendErrorMessage(playerid, "Please be aware that you wont be able to login to the UCP.");
				return 1;
			}
			else
			{
			WP_Hash(buffer, sizeof(buffer), inputtext);
			inputtext[0] = '\0';

			mysql_format(ourConnection, query, sizeof(query), "UPDATE `characters` SET `pCharPass` = '%e' WHERE `char_name` = '%e'", buffer, ReturnName(playerid));
            mysql_tquery(ourConnection, query);
            SendClientMessage(playerid, COLOR_REDEX, "You have successfully registered your UCP's password.");
			}
		}
		case DIALOG_JIM:
		{
		    if(!response)
			{
				SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: Well you have a good one I guess");
				return 1;
			}
			switch(listitem)
			{
				case 0:
				{
			    	if(25000 > PlayerInfo[playerid][pMoney]) return SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: That ain't enough partner.");
			    	GivePlayerGun(playerid, 24, 50);
			    	SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: The good old Deagle, here you go partner. Enjoy it!");
			    	GiveMoney(playerid, -25000);
			    	BusinessInfo[8][eBusinessProducts] -= 1;
			    	SaveBusiness(8);
			    	SaveCharacter(playerid);
			    	return 1;
				}
				case 1:
				{
			    	if(25000 > PlayerInfo[playerid][pMoney]) return SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: That ain't enough partner.");
			   	 	GivePlayerGun(playerid, 25, 25);
			   	 	SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: Ahh, a shotgun I see, here you go partner. Enjoy it!");
			    	GiveMoney(playerid, -25000);
			    	BusinessInfo[8][eBusinessProducts] -= 1;
			    	SaveBusiness(8);
			    	SaveCharacter(playerid);
			    	return 1;
				}
				case 2:
				{
				    if(BusinessInfo[8][eBusinessProducts] <= 1) return SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: I dont have enough supplies to sell you that partner.");
			    	if(17500 > PlayerInfo[playerid][pMoney]) return SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: That ain't enough partner.");
			    	GivePlayerGun(playerid, 33, 75);
			    	SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: A rifle? Good luck partner. Enjoy it tough.");
			    	GiveMoney(playerid, -17500);
			    	BusinessInfo[8][eBusinessProducts] -= 2;
			    	SaveBusiness(8);
			    	SaveCharacter(playerid);
			    	return 1;
				}
				case 3:
				{
				    if(BusinessInfo[8][eBusinessProducts] <= 1) return SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: I dont have enough supplies to sell you that partner.");
			    	if(60000 > PlayerInfo[playerid][pMoney]) return SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: That ain't enough partner.");
			    	GivePlayerGun(playerid, 30, 150);
			    	SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: Now the AK47 That is a gun!. Go get 'm.");
			    	GiveMoney(playerid, -60000);
			    	BusinessInfo[8][eBusinessProducts] -= 2;
			    	SaveBusiness(8);
			    	SaveCharacter(playerid);
			    	return 1;
				}
				case 4:
				{
			    	if(75 > PlayerInfo[playerid][pMoney]) return SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: That ain't enough partner.");
			    	GivePlayerGun(playerid, 4, 1);
			    	SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: It's sharp its cheap it does the job. Have fun.");
			    	GiveMoney(playerid, -75);
			    	BusinessInfo[8][eBusinessProducts] -= 1;
			    	SaveBusiness(8);
			    	SaveCharacter(playerid);
			    	return 1;
			    }
				case 5:
				{
			    	if(100 > PlayerInfo[playerid][pMoney]) return SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: That ain't enough partner.");
			    	GivePlayerGun(playerid, 5, 1);
			    	SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: Do you play baseball?");
			    	GiveMoney(playerid, -100);
			    	BusinessInfo[8][eBusinessProducts] -= 1;
			    	SaveBusiness(8);
			    	SaveCharacter(playerid);
			    	return 1;
				}
				case 6:
				{
					if(BusinessInfo[8][eBusinessProducts] <= 4) return SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: I dont have enough supplies to sell you that partner.");
				    if(10000 > PlayerInfo[playerid][pMoney]) return SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: That ain't enough partner.");
				    SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: What are you going to do, rob a bank?");
				    PlayerInfo[playerid][pExplosives] += 1;
				    BusinessInfo[8][eBusinessProducts] -= 5;
				    GiveMoney(playerid, -10000);
				    SaveBusiness(8);
				    SaveCharacter(playerid);
				    return 1;
				}
			}
			return 1;
		}
		case DIALOG_SMUGGLE:
		{
		    if(!response)
			{
				new pay, str[142];
	   			PlayerInfo[playerid][pCarry] = 0;
	   			PlayerInfo[playerid][pSmuggling] = 0;
    			pay = 100 + randomEx(200,400);
    			ClearAnimations(playerid);
    			ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0,1);
				SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s's phone would beep, displaying a message.", ReturnName(playerid, 0));
				format(str, sizeof(str), "Private Number: Alright thats fine here is $%d. Now get out of here.", pay);
				SCM(playerid, COLOR_WHITE, str);
				RemovePlayerAttachedObject(playerid, 9);
				GiveMoney(playerid, pay);
				smugglecp[playerid] = 0;
				DisablePlayerCheckpoint(playerid);
				return 1;
			}
			else
			{
			    SendPoliceMessage(COLOR_COP, "** Sherman Dam: A suspicious person with a bag has been spotted at the Sherman dam, all units be advised! **");
				SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s's phone would beep, displaying a message.", ReturnName(playerid, 0));
                SCM(playerid, COLOR_WHITE, "Private Number: Cool, get my stuff to my place and we'll talk. The cops have been alerted by the way.");
                SetPlayerCheckpoint(playerid, -796.0307,2259.3723,59.4689, 1);
                smugglecp[playerid] = 3;
                return 1;
			}
		}
		case DIALOG_FINE:
		{
		    new amount = GetPVarInt(playerid, "amount");
			if(!response)
			{
				SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s refused to sign the ticket.", ReturnName(playerid, 0));
				DeletePVar(playerid, "amount");
				return 1;
			}
			else
			{
				GiveMoney(playerid, -amount);
				SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s signs the ticket.", ReturnName(playerid, 0));
				DeletePVar(playerid, "amount");
				return 1;
			}
		}
  		case DIALOG_FISH_BUY:
  		{
  			if(!response)
			{
				return 1;
			}
           	switch(listitem)
        	{
          	  	case 0:
        	    {
					if(GetPlayerMoney(playerid) <= 15) return SendErrorMessage(playerid, "You do not have enough money.");
					if(PlayerInfo[playerid][pFishingRod] >= 1) return SendErrorMessage(playerid, "You already have a fishingrod.");
					PlayerInfo[playerid][pFishingRod] = 1;
					SCM(playerid, COLOR_WHITE, "You have bought a simple fishing rod, /fish.");
					GiveMoney(playerid, -15);
					return 1;
        	    }
        	    case 1:
        	    {
					if(GetPlayerMoney(playerid) <= 50) return SCM(playerid, COLOR_LIGHTRED, "You do not have enough money.");
					PlayerInfo[playerid][pWorms] += 10;
					SCM(playerid, COLOR_WHITE, "You have bought a box of worms.");
					GiveMoney(playerid, -50);
					return 1;
        	    }
			}
			return 1;
		}
		case DIALOG_LOGIN:
		{
    		if(e_pAccountData[playerid][mwhitelist] == 0)
    		{
    		//ShowPlayerDialog(playerid, DIALOG_WHITELIST, DIALOG_STYLE_MSGBOX, "Notice", "Your whitelist application has not been approved yet please visit: discord", "Close", "");
    		//SetTimerEx("WhitelistTimer", 10, false, "i", playerid);
			}

			if (!response)
			{
				SendClientMessage(playerid, COLOR_REDEX, "You were kicked for not logging in.");
				return KickEx(playerid);
			}
			new continueCheck[211];

			mysql_format(ourConnection, continueCheck, sizeof(continueCheck), "SELECT acc_dbid, forum_name, secret_word, active_ip FROM masters WHERE acc_name = '%e' AND acc_pass = sha1('%e') LIMIT 1",
				ReturnName(playerid), inputtext);

			mysql_tquery(ourConnection, continueCheck, "LoggingIn", "i", playerid);
			return 1;
		}
		case DIALOG_FUEL:
		  {
			if(!response)
     		{
        		return 1;
        	}
           	switch(listitem)
        	{
				case 0:
				{
				if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
				{
					SendErrorMessage(playerid, "You are not driving a vehicle.");
					return 1;
				}
				new vehicleid = GetPlayerVehicleID(playerid);
				if(VehicleInfo[vehicleid][eVehicleFuel] >= 100.0)
				{
					SendErrorMessage(playerid, "Your vehicle fuel tank is full.");
					return 1;
				}
				if(FUEL_PRICE > PlayerInfo[playerid][pMoney])
				{
					SendErrorMessage(playerid, "You don't have enough money.");
					return 1;
				}
				RefuelTime[playerid] = 1;
    			SetPVarFloat(playerid, "Fuel", VehicleInfo[vehicleid][eVehicleFuel]);
				GameTextForPlayer(playerid, "~g~refueling...", 2000, 3);
				}
        	}
		}
		case DIALOG_FDLOCKER:
  	   	  {
			if(!response)
     		{
        		return 1;
        	}
           	switch(listitem)
        	{
        	    case 0:
        	    {
					SetPlayerArmour(playerid, 50);
					ShowPlayerDialog(playerid, DIALOG_FDLOCKER, DIALOG_STYLE_LIST, "Bayside Fire Locker", "Armour\nFirst Aid\nShovel\nChainsaw\nUniform", "Choose", "Cancel");
        	    }
        	    case 1:
        	    {
					SetPlayerHealth(playerid, 100);
					ShowPlayerDialog(playerid, DIALOG_FDLOCKER, DIALOG_STYLE_LIST, "Bayside Fire Locker", "Armour\nFirst Aid\nShovel\nChainsaw\nUniform", "Choose", "Cancel");
        	    }
        	    case 2:
        	    {
					GivePlayerWeapon(playerid, 6, 1);
					ShowPlayerDialog(playerid, DIALOG_FDLOCKER, DIALOG_STYLE_LIST, "Bayside Fire Locker", "Armour\nFirst Aid\nShovel\nChainsaw\nUniform", "Choose", "Cancel");
        	    }
        	    case 3:
        	    {
					GivePlayerWeapon(playerid, 9, 1);
					ShowPlayerDialog(playerid, DIALOG_FDLOCKER, DIALOG_STYLE_LIST, "Bayside Fire Locker", "Armour\nFirst Aid\nShovel\nChainsaw\nUniform", "Choose", "Cancel");
        	    }
        	    case 4:
        	    {
					ShowPlayerDialog(playerid, DIALOG_FDUNIFORM, DIALOG_STYLE_LIST, "BSFD Locker", "Male Medic 1\nMale Medic 2\nMale Medic 3\nFemale Medic\nTurnout 1\nTurnout 2\nTurnout 3", "Choose", "Cancel");
        	    }
			}
			return 1;
		}
		case DIALOG_SDLOCKER:
  	   	  {
    		if(!response)
     		{
        		return 1;
        	}
           	switch(listitem)
        	{
        	    case 0:
        	    {
					SetPlayerArmour(playerid, 100);
					ShowPlayerDialog(playerid, DIALOG_SDLOCKER, DIALOG_STYLE_LIST, "MgMc-PD Locker", "Armour\nNightstick\nPepper-Spray\nDeagle\nShotgun\nMP5\nM4\nUniform", "Choose", "Cancel");
        	    }
        	    case 1:
        	    {
					GivePlayerWeapon(playerid, 3, 1);
					ShowPlayerDialog(playerid, DIALOG_SDLOCKER, DIALOG_STYLE_LIST, "MgMc-PD Locker", "Armour\nNightstick\nPepper-Spray\nDeagle\nShotgun\nMP5\nM4\nUniform", "Choose", "Cancel");
        	    }
        	    case 2:
        	    {
					GivePlayerWeapon(playerid, 41, 1000);
					ShowPlayerDialog(playerid, DIALOG_SDLOCKER, DIALOG_STYLE_LIST, "MgMc-PD Locker", "Armour\nNightstick\nPepper-Spray\nDeagle\nShotgun\nMP5\nM4\nUniform", "Choose", "Cancel");
        	    }
        	    case 3:
        	    {
					GivePlayerWeapon(playerid, 24, 100);
					ShowPlayerDialog(playerid, DIALOG_SDLOCKER, DIALOG_STYLE_LIST, "MgMc-PD Locker", "Armour\nNightstick\nPepper-Spray\nDeagle\nShotgun\nMP5\nM4\nUniform", "Choose", "Cancel");
        	    }
        	    case 4:
        	    {
					GivePlayerWeapon(playerid, 25, 25);
					ShowPlayerDialog(playerid, DIALOG_SDLOCKER, DIALOG_STYLE_LIST, "MgMc-PD Locker", "Armour\nNightstick\nPepper-Spray\nDeagle\nShotgun\nMP5\nM4\nUniform", "Choose", "Cancel");
        	    }
         	   	case 5:
        	    {
					GivePlayerWeapon(playerid, 29, 500);
					ShowPlayerDialog(playerid, DIALOG_SDLOCKER, DIALOG_STYLE_LIST, "MgMc-PD Locker", "Armour\nNightstick\nPepper-Spray\nDeagle\nShotgun\nMP5\nM4\nUniform", "Choose", "Cancel");
        	    }
        	   	case 6:
        	    {
					GivePlayerWeapon(playerid, 31, 500);
					ShowPlayerDialog(playerid, DIALOG_SDLOCKER, DIALOG_STYLE_LIST, "MgMc-PD Locker", "Armour\nNightstick\nPepper-Spray\nDeagle\nShotgun\nMP5\nM4\nUniform", "Choose", "Cancel");
        	    }
        	   	case 7:
        	    {
					ShowPlayerDialog(playerid, DIALOG_UNIFORM, DIALOG_STYLE_LIST, "MgMc-PD Locker", "Male Uniform 1\nMale Uniform 2\nMale Uniform 3\nMale Uniform 4\nFemale Uniform 1\nBiker Uniform", "Choose", "Cancel");
        	    }
			}
			return 1;
		}
		case DIALOG_UNIFORM:
  	   	  {
    		if(!response)
     		{
        		return 1;
        	}
           	switch(listitem)
        	{
        	    case 0:
        	    {
					SetPlayerSkin(playerid, 280);
					PlayerInfo[playerid][pLastSkin] = 280;
        	    }
        	    case 1:
        	    {
					SetPlayerSkin(playerid, 281);
					PlayerInfo[playerid][pLastSkin] = 281;
        	    }
        	    case 2:
        	    {
					SetPlayerSkin(playerid, 310);
					PlayerInfo[playerid][pLastSkin] = 310;
        	    }
        	    case 3:
        	    {
					SetPlayerSkin(playerid, 282);
					PlayerInfo[playerid][pLastSkin] = 282;
        	    }
        	    case 4:
        	    {
					SetPlayerSkin(playerid, 309);
					PlayerInfo[playerid][pLastSkin] = 309;
        	    }
         	   	case 5:
        	    {
					SetPlayerSkin(playerid, 284);
					PlayerInfo[playerid][pLastSkin] = 284;
        	    }
			}
			return 1;
		}
  		case DIALOG_FDUNIFORM:
  	   	  {
    		if(!response)
     		{
        		return 1;
        	}
           	switch(listitem)
        	{
        	    case 0:
        	    {
					SetPlayerSkin(playerid, 274);
					PlayerInfo[playerid][pLastSkin] = 274;
        	    }
        	    case 1:
        	    {
					SetPlayerSkin(playerid, 275);
					PlayerInfo[playerid][pLastSkin] = 275;
        	    }
        	    case 2:
        	    {
					SetPlayerSkin(playerid, 276);
					PlayerInfo[playerid][pLastSkin] = 276;
        	    }
        	    case 3:
        	    {
					SetPlayerSkin(playerid, 308);
					PlayerInfo[playerid][pLastSkin] = 308;
        	    }
        	    case 4:
        	    {
					SetPlayerSkin(playerid, 277);
					PlayerInfo[playerid][pLastSkin] = 277;
        	    }
         	   	case 5:
        	    {
					SetPlayerSkin(playerid, 278);
					PlayerInfo[playerid][pLastSkin] = 278;
        	    }
        	    case 6:
        	    {
        	        SetPlayerSkin(playerid, 279);
        	        PlayerInfo[playerid][pLastSkin] = 279;
				}
			}
			return 1;
		}
		case DIALOG_CHARS:
		{
			if (!response)
			{
				SendClientMessage(playerid, COLOR_REDEX, "You were kicked for not selecting a character.");
				return KickEx(playerid);
			}

			if(strfind(characterLister[playerid][listitem], "[", false) != -1)
			{
				for(new i =0 ; i < 4; i++){ SendClientMessage(playerid, -1, " "); }
				SendClientMessage(playerid, COLOR_GREEN, "You selected an empty character slot.");

				SendClientMessage(playerid, -1, "This process will guide you through creating your character.");
				SendClientMessage(playerid, -1, "Please begin by typing your characters first and last name. i.e: {145F0B}Luke_Tang");
				SendClientMessage(playerid, -1, "Your characters name must be in Firstname_Lastname format with no numbers or special characters.");

				playerMakingCharacter[playerid] = true;
				playerCharacterStep[playerid] = 1;
				return 1;
			}
			else
			{
				new
					string[128], thread[128]
				;

				characterPickTime[playerid] = 0;

				playerMakingCharacter[playerid] = false;
				playerCharacterStep[playerid] = 0;

				format(string, sizeof(string), "You selected the character {145F0B}%s{FFFFFF}.", characterLister[playerid][listitem]);
				SendClientMessage(playerid, -1, string);

				SetPlayerName(playerid, characterLister[playerid][listitem]);

				mysql_format(ourConnection, thread, sizeof(thread), "SELECT * FROM characters WHERE char_name = '%e' LIMIT 1", characterLister[playerid][listitem]);
				mysql_tquery(ourConnection, thread, "Query_SelectCharacter", "i", playerid);
			}
			return 1;
		}
		case DIALOG_REPORT:
		{
			if (!response)
			{
				return SendServerMessage(playerid, "You cancelled your report.");
			}

			new idx;

			for (new i = 1; i < sizeof(ReportInfo); i ++)
			{
				if (ReportInfo[i][rReportExists] == false)
				{
					idx = i;
					break;
				}
			}

			OnPlayerReport(playerid, idx, playerReport[playerid]);
		}
		case DIALOG_FACTION_CONFIG:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: return ShowPlayerDialog(playerid, DIALOG_FACTION_NAME, DIALOG_STYLE_INPUT, "Faction Configuration", "Enter your factions new name:", "Select", "Back");
					case 1: return ShowPlayerDialog(playerid, DIALOG_FACTION_ABBREV, DIALOG_STYLE_INPUT, "Faction Configuration", "Enter your factions new abbreviation:", "Select", "Back");
					case 2:
					{
						if(PlayerInfo[playerid][pFactionRank] != 1)
						{
							SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} This configuration is restricted to rank 1 only.");
							return ShowFactionConfig(playerid);
						}

						return ShowPlayerDialog(playerid, DIALOG_FACTION_ALTER_R, DIALOG_STYLE_INPUT, "Faction Configuration", "Enter your factions new alter rank:", "Select", "Back");
					}
					case 3: return ShowPlayerDialog(playerid, DIALOG_FACTION_ALTER_J, DIALOG_STYLE_INPUT, "Faction Configuration", "Enter your factions new join rank:", "Select", "Back");
					case 4: return ShowPlayerDialog(playerid, DIALOG_FACTION_ALTER_C, DIALOG_STYLE_INPUT, "Faction Configuration", "Enter your factions new chat rank:", "Select", "Back");
					case 5: return ShowPlayerDialog(playerid, DIALOG_FACTION_CHATCOLOR, DIALOG_STYLE_INPUT, "Faction Configuration", "Enter your factions new chat color: (Example: 0x8D8DFFFF)", "Select", "Back");
					case 6: return ShowPlayerDialog(playerid, DIALOG_FACTION_RANKS, DIALOG_STYLE_INPUT, "Faction Configuration", "Enter the factions rank ID you want to alter. (1-20)", "Select", "Back");
					case 7:
					{
						if(PlayerInfo[playerid][pFactionRank] != 1)
							return SendErrorMessage(playerid, "The factions spawn may only be changed by rank 1.");

						new factionid = PlayerInfo[playerid][pFaction];

						GetPlayerPos(playerid, FactionInfo[factionid][eFactionSpawn][0], FactionInfo[factionid][eFactionSpawn][1], FactionInfo[factionid][eFactionSpawn][2]);

						FactionInfo[factionid][eFactionSpawnInt] = GetPlayerInterior(playerid);

						if(GetPlayerInterior(playerid) != 0)
							FactionInfo[factionid][eFactionSpawnWorld] = random(50000)+playerid+5;

						else FactionInfo[factionid][eFactionSpawnWorld] = GetPlayerVirtualWorld(playerid);

						SendServerMessage(playerid, "Your factions spawn has been altered.");
						return ShowFactionConfig(playerid);
					}
					case 8: return ShowPlayerDialog(playerid, DIALOG_FACTION_ALTER_T, DIALOG_STYLE_INPUT, "Faction Configuration", "Enter the factions new tow rank:", "Select", "Back");
				}
			}
		}
		case DIALOG_FACTION_NAME:
		{
			if(!response)
				return ShowFactionConfig(playerid);

			if(strlen(inputtext) > 90 || strlen(inputtext) < 3)
				return ShowPlayerDialog(playerid, DIALOG_FACTION_NAME, DIALOG_STYLE_INPUT, "Faction Configuration", "Your factions name must be less than 90 characters.\n\nEnter your factions new name:", "Select", "Back");

			format(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionName], 90, "%s", inputtext);
			SendServerMessage(playerid, "Your factions name is now: \"%s\".", inputtext);

			return ShowFactionConfig(playerid);
		}
		case DIALOG_FACTION_ABBREV:
		{
			if(!response)
				return ShowFactionConfig(playerid);

			if(strlen(inputtext) > 30 || strlen(inputtext) < 1)
				return ShowPlayerDialog(playerid, DIALOG_FACTION_NAME, DIALOG_STYLE_INPUT, "Faction Configuration", "Your factions name must be less than 30 characters and more than 1.\n\nEnter your factions new name:", "Select", "Back");

			format(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAbbrev], 30, "%s", inputtext);
			SendServerMessage(playerid, "Your factions abbreviation is now: \"%s\".", inputtext);

			return ShowFactionConfig(playerid);
		}
		case DIALOG_FACTION_ALTER_R:
		{
			if(!response)
				return ShowFactionConfig(playerid);

			if(strlen(inputtext) < 1 || strlen(inputtext) > 2)
				return ShowPlayerDialog(playerid, DIALOG_FACTION_ALTER_R, DIALOG_STYLE_INPUT, "Faction Configuration", "Enter your factions new alter rank:", "Select", "Back");

			new rankid = strval(inputtext);

			if(rankid > 20 || rankid < 1)
				return ShowPlayerDialog(playerid, DIALOG_FACTION_ALTER_R, DIALOG_STYLE_INPUT, "Faction Configuration", "Your factions alter rank must be between 1-20.\n\nEnter your factions new alter rank:", "Select", "Back");

			FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank] = rankid;
			SendServerMessage(playerid, "Your factions alter rank is now: %i.", rankid);

			return ShowFactionConfig(playerid);
		}
		case DIALOG_FACTION_ALTER_J:
		{
			if(!response)
				return ShowFactionConfig(playerid);

			if(strlen(inputtext) < 1 || strlen(inputtext) > 2)
				return ShowPlayerDialog(playerid, DIALOG_FACTION_ALTER_J, DIALOG_STYLE_INPUT, "Faction Configuration", "Enter your factions new join rank:", "Select", "Back");

			new rankid = strval(inputtext);

			if(rankid > 20 || rankid < 1)
				return ShowPlayerDialog(playerid, DIALOG_FACTION_ALTER_J, DIALOG_STYLE_INPUT, "Faction Configuration", "Your factions join rank must be between 1-20.\n\nEnter your factions new join rank:", "Select", "Back");

			FactionInfo[PlayerInfo[playerid][pFaction]][eFactionJoinRank] = rankid;
			SendServerMessage(playerid, "Your factions join rank is now: %i.", rankid);

			return ShowFactionConfig(playerid);
		}
		case DIALOG_FACTION_ALTER_C:
		{
			if(!response)
				return ShowFactionConfig(playerid);

			if(strlen(inputtext) < 1 || strlen(inputtext) > 2)
				return ShowPlayerDialog(playerid, DIALOG_FACTION_ALTER_C, DIALOG_STYLE_INPUT, "Faction Configuration", "Enter your factions new chat rank:", "Select", "Back");

			new rankid = strval(inputtext);

			if(rankid > 20 || rankid < 1)
				return ShowPlayerDialog(playerid, DIALOG_FACTION_ALTER_C, DIALOG_STYLE_INPUT, "Faction Configuration", "Your factions chat rank must be between 1-20.\n\nEnter your factions new chat rank:", "Select", "Back");

			FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatRank] = rankid;
			SendServerMessage(playerid, "Your factions chat rank is now: %i.", rankid);

			return ShowFactionConfig(playerid);
		}
		case DIALOG_FACTION_ALTER_T:
		{
			if(!response)
				return ShowFactionConfig(playerid);

			if(strlen(inputtext) < 1 || strlen(inputtext) > 2)
				return ShowPlayerDialog(playerid, DIALOG_FACTION_ALTER_T, DIALOG_STYLE_INPUT, "Faction Configuration", "Enter your factions new tow rank:", "Select", "Back");

			new rankid = strval(inputtext);

			if(rankid > 20 || rankid < 1)
				return ShowPlayerDialog(playerid, DIALOG_FACTION_ALTER_T, DIALOG_STYLE_INPUT, "Faction Configuration", "Your factions chat rank must be between 1-20.\n\nEnter your factions new tow rank:", "Select", "Back");

			FactionInfo[PlayerInfo[playerid][pFaction]][eFactionTowRank] = rankid;
			SendServerMessage(playerid, "Your factions tow rank is now: %i.", rankid);

			return ShowFactionConfig(playerid);
		}
		case DIALOG_FACTION_CHATCOLOR:
		{
			if(!response)
				return ShowFactionConfig(playerid);

			FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatColor] = HexToInt(inputtext);
			SendServerMessage(playerid, "Your factions chat color was altered.");

			return ShowFactionConfig(playerid);
		}
		case DIALOG_FACTION_RANKS:
		{
			if(!response)
				return ShowFactionConfig(playerid);

			new rankid = strval(inputtext), str[128];

			if(rankid > 20 || rankid < 1)
				return ShowPlayerDialog(playerid, DIALOG_FACTION_RANKS, DIALOG_STYLE_INPUT, "Faction Configuration", "Enter the factions rank ID you want to alter. (1-20)", "Select", "Back");

			playerEditingRank[playerid] = rankid;

			format(str, sizeof(str), "You're editing your factions rank ID %i ('%s').\n\n{F81414}To remove this rank, set the name to \"NotSet\". Case sensitive.", rankid, FactionRanks[PlayerInfo[playerid][pFaction]][rankid]);
			return ShowPlayerDialog(playerid, DIALOG_FACTION_RANKEDIT, DIALOG_STYLE_INPUT, "Faction Configuration", str, "Select", "Back");
		}
		case DIALOG_FACTION_RANKEDIT:
		{
			if(!response)
				return ShowFactionConfig(playerid);

			new str[128];

			if(strlen(inputtext) > 60 || strlen(inputtext) < 1)
			{
				format(str, sizeof(str), "Your rank should be less than 60 characters.\n\nYou're editing your factions rank ID %i ('%s').\n{F81414}To remove this rank, set the name to \"NotSet\". Case sensitive.", FactionRanks[PlayerInfo[playerid][pFaction]][playerEditingRank[playerid]], playerEditingRank[playerid]);
				return ShowPlayerDialog(playerid, DIALOG_FACTION_RANKEDIT, DIALOG_STYLE_INPUT, "Faction Configuration", str, "Select", "Back");
			}

			SendServerMessage(playerid, "You edited faction rank %i (%s) to: \"%s\". ", playerEditingRank[playerid], FactionRanks[PlayerInfo[playerid][pFaction]][playerEditingRank[playerid]], inputtext);
			format(FactionRanks[PlayerInfo[playerid][pFaction]][playerEditingRank[playerid]], 60, "%s", inputtext);

			return ShowFactionConfig(playerid);
		}
		case DIALOG_VEHICLE_WEAPONS:
		{
			if(response)
			{
				new vehicleid = INVALID_VEHICLE_ID, str[128];

				if(!IsPlayerInAnyVehicle(playerid))
					vehicleid = GetNearestVehicle(playerid);

				else
					vehicleid = GetPlayerVehicleID(playerid);

				if(vehicleid == INVALID_VEHICLE_ID)
					return SendErrorMessage(playerid, "You're no longer in or near a vehicle.");

				if(!VehicleInfo[vehicleid][eVehicleWeapons][listitem+1])
					return SendErrorMessage(playerid, "The weapon slot you selected is empty.");

				GivePlayerGun(playerid, VehicleInfo[vehicleid][eVehicleWeapons][listitem+1], VehicleInfo[vehicleid][eVehicleWeaponsAmmo][listitem+1]);

				format(str, sizeof(str), "* %s takes a %s from the %s.", ReturnName(playerid, 0), ReturnWeaponName(VehicleInfo[vehicleid][eVehicleWeapons][listitem+1]),
					ReturnVehicleName(vehicleid));

				SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4500);
				SendClientMessage(playerid, COLOR_EMOTE, str);

				VehicleInfo[vehicleid][eVehicleWeapons][listitem+1] = 0;
				VehicleInfo[vehicleid][eVehicleWeaponsAmmo][listitem+1] = 0;

				SaveVehicle(vehicleid); SaveCharacter(playerid);
				return 1;
			}
		}
		case DIALOG_HOUSE_WEAPONS:
		{
			if(response)
			{
				new
					id = IsPlayerInProperty(playerid),
					str[128]
				;

				if(!PropertyInfo[id][ePropertyWeapons][listitem+1])
					return SendErrorMessage(playerid, "The weapon slot you selected is empty.");

				GivePlayerGun(playerid, PropertyInfo[id][ePropertyWeapons][listitem+1], PropertyInfo[id][ePropertyWeaponsAmmo][listitem+1]);

				format(str, sizeof(str), "* %s takes a %s from the house.", ReturnName(playerid, 0), ReturnWeaponName(PropertyInfo[id][ePropertyWeapons][listitem+1]));
				SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4500);
				SendClientMessage(playerid, COLOR_EMOTE, str);

				PropertyInfo[id][ePropertyWeapons][listitem+1] = 0;
				PropertyInfo[id][ePropertyWeaponsAmmo][listitem+1] = 0;

				SaveCharacter(playerid); SaveProperty(id);
				return 1;
			}
		}
		case DIALOG_XMR_CATEGORIES:
		{
			if(response)
			{
				new
					liststr[500],
					counter = 0
				;

				CatXMRHolder[playerid] = listitem+1;

				for(new i = 1; i < MAX_XMR_CATEGORY_STATIONS; i++)
				{
					if(CatXMRHolder[playerid] == XMRStationInfo[i][eXMRCategory])
					{
						format(liststr, sizeof(liststr), "%sID:%d - %s\n", liststr, XMRStationInfo[i][eXMRStationID], XMRStationInfo[i][eXMRStationName]);

						SubXMRHolderArr[playerid][counter] = i;
						counter ++;
					}
				}

				strcat(liststr, "{FFE104}OFF - Click to turn off.\n");
				ShowPlayerDialog(playerid, DIALOG_XMR_STATIONS, DIALOG_STYLE_LIST, "Stations:", liststr, "Select", "Back");
				return 1;
			}
		}
		case DIALOG_XMR_STATIONS:
		{
			if(response)
			{
				new
					vehicleid = INVALID_VEHICLE_ID;

				if(IsPlayerInAnyVehicle(playerid))
					vehicleid = GetPlayerVehicleID(playerid);

				if(!strcmp(inputtext, "OFF - Click to turn off."))
				{
					PlayXMRStation(playerid, vehicleid, IsPlayerInProperty(playerid), true);
					return 1;
				}

				SubXMRHolder[playerid] = SubXMRHolderArr[playerid][listitem];

				PlayXMRStation(playerid, vehicleid, IsPlayerInProperty(playerid));
			}
			return 1;
		}
		case DIALOG_POLICE_SKINS:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: SetPlayerSkin(playerid, 280);
					case 1: SetPlayerSkin(playerid, 300);
					case 2: SetPlayerSkin(playerid, 281);
					case 3: SetPlayerSkin(playerid, 301);
					case 4: SetPlayerSkin(playerid, 306);
					case 5: SetPlayerSkin(playerid, 307);
					case 6: SetPlayerSkin(playerid, 265);
					case 7: SetPlayerSkin(playerid, 267);
					case 8: SetPlayerSkin(playerid, 266);
					case 9: SetPlayerSkin(playerid, 284);
					case 10: SetPlayerSkin(playerid, 61);
					case 11: SetPlayerSkin(playerid, 93);
				}
			}
			return 1;
		}
		case DIALOG_BUY_LIST:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						if(PlayerInfo[playerid][pHasRadio])
						{
							SendClientMessage(playerid, COLOR_ACTION, "You already own a radio.");
							ShowBuylist(playerid);
							return 1;
						}

						if(1000 > PlayerInfo[playerid][pMoney])
						{
							SendClientMessage(playerid, COLOR_ACTION, "You can't afford a radio.");
							ShowBuylist(playerid);
							return 1;
						}

						SendClientMessage(playerid, COLOR_ACTION, "You bought a radio for $1,000.");
						GiveMoney(playerid, -500);

						PlayerInfo[playerid][pHasRadio] = true;
						ShowBuylist(playerid);
					}
					case 1:
					{
						if(500 > PlayerInfo[playerid][pMoney])
						{
							SendClientMessage(playerid, COLOR_ACTION, "You can't afford a gasoline can.");
							ShowBuylist(playerid);
							return 1;
						}

						if(PlayerInfo[playerid][pGascan] >= 5)
						{
							SendClientMessage(playerid, COLOR_ACTION, "You may only hold up to 5 gasoline cans.");
							ShowBuylist(playerid);
							return 1;
						}

						SendClientMessage(playerid, COLOR_ACTION, "You bought a gasoline can for $500.");
						GiveMoney(playerid, -500);

						PlayerInfo[playerid][pGascan]++;
						ShowBuylist(playerid);
					}
					case 2:
					{
						if(2000 > PlayerInfo[playerid][pMoney])
						{
							SendClientMessage(playerid, COLOR_ACTION, "You can't afford a mask.");
							ShowBuylist(playerid);
							return 1;
						}

						if(PlayerInfo[playerid][pHasMask])
						{
							SendClientMessage(playerid, COLOR_ACTION, "You already own a mask.");
							ShowBuylist(playerid);
							return 1;
						}

						SendClientMessage(playerid, COLOR_ACTION, "You bought a Mask for $2,000.");
						GiveMoney(playerid, -2000);

						PlayerInfo[playerid][pHasMask] = true;
						ShowBuylist(playerid);
					}
				}
			}
			return 1;
		}
		case DIALOG_DEALERSHIP:
		{
			if(response)
			{
				new larstr[600],
					counter = 0
				;

				CatDealershipHolder[playerid] = listitem;

				for(new i = 0; i < sizeof(g_aDealershipData); i++)
				{
					if(listitem == g_aDealershipData[i][eDealershipCategory])
					{
						format(larstr, sizeof(larstr), "%s%s\t\t\t$%s\n", larstr, g_aDealershipData[i][eDealershipModel], MoneyFormat(g_aDealershipData[i][eDealershipPrice]));

						SubDealershipHolderArr[playerid][counter] = i;
						counter++;
					}
				}

				ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_SELECT, DIALOG_STYLE_LIST, "Available Models:", larstr, "Select", "Back");
			}
			return 1;
		}
		case DIALOG_DEALERSHIP_SELECT:
		{
			if(!response)
			{
				new catstr[190];

				for(new i = 0; i < sizeof(g_aDealershipCategory); i++)
				{
					format(catstr, sizeof(catstr), "%s%s\n", catstr, g_aDealershipCategory[i]);
				}

				return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP, DIALOG_STYLE_LIST, "Categories:", catstr, "Select", "Cancel");
			}

			SubDealershipHolder[playerid] = SubDealershipHolderArr[playerid][listitem];

			new
				i,
				d,
				str[128],
				caption[60]
			;

			i = SubDealershipHolder[playerid];
			d = PlayerInfo[playerid][pAtDealership];

			if(g_aDealershipData[i][eDealershipPrice] > PlayerInfo[playerid][pMoney])
				return SendServerMessage(playerid, "You need $%s to buy this. (Total: $%s)", MoneyFormat(g_aDealershipData[i][eDealershipPrice]), MoneyFormat(PlayerInfo[playerid][pMoney]));

			DealershipTotalCost[playerid] = g_aDealershipData[i][eDealershipPrice];

			format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[i][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

			strcat(str, "Alarm\n");
			strcat(str, "Lock\n");
			strcat(str, "Immobiliser\n");
			strcat(str, "Colors\n");
			strcat(str, "No XM Installed\n");
			strcat(str, "{FFFF00}Purchase Vehicle\n");

			TogglePlayerControllable(playerid, 0);

			DealershipPlayerCar[playerid] =
				CreateVehicle(g_aDealershipData[i][eDealershipModelID], BusinessInfo[d][eBusinessInterior][0], BusinessInfo[d][eBusinessInterior][1], BusinessInfo[d][eBusinessInterior][2], 90.0, 0, 0, -1);

    		if(IsABoat(DealershipPlayerCar[playerid]))
    		{
				SetVehiclePos(DealershipPlayerCar[playerid], -2202.5156,2421.8928,-0.5458);
				SetVehicleZAngle(DealershipPlayerCar[playerid], 47.0053);
			}

			PutPlayerInVehicle(playerid, DealershipPlayerCar[playerid], 0);

			printf("[DEBUG]: Player %s (ID : %i) was spawned in a Dealership vehicle. (Vehicle ID: %d)", ReturnName(playerid), playerid, DealershipPlayerCar[playerid]);
			ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND, DIALOG_STYLE_LIST, caption, str, "Append", "Back");
			return 1;
		}
		case DIALOG_DEALERSHIP_APPEND:
		{
			new
				caption[60],
				str[400]
			;

			format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

			if(response)
			{
				switch(listitem)
				{
					case 0: //Alarms;
					{
						if(DealershipAlarmLevel[playerid] == 1)
							strcat(str, "{FFFF00}>>{FFFFFF}Alarm Level 1 - $2,000\n");

						else strcat(str, "Alarm Level 1 - $2,000\n");

						if(DealershipAlarmLevel[playerid] == 2)
							strcat(str, "{FFFF00}>>{FFFFFF}Alarm Level 2 - $4,000\n");

						else strcat(str, "Alarm Level 2 - $4,000\n");

						if(DealershipAlarmLevel[playerid] == 3)
							strcat(str, "{FFFF00}>>{FFFFFF}Alarm Level 3 - $6,000\n");

						else strcat(str, "Alarm Level 3 - $6,000\n");

						if(DealershipAlarmLevel[playerid] == 4)
							strcat(str, "{FFFF00}>>{FFFFFF}Alarm Level 4 - $10,000\n");

						else strcat(str, "Alarm Level 4 - $10,000\n");

						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_ALARM, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
					}
					case 1: //Locks;
					{
						if(DealershipLockLevel[playerid] == 1)
							strcat(str, "{FFFF00}>>{FFFFFF}Lock Level 1 - $1,000\n");

						else strcat(str, "Lock Level 1 - $1,000\n");

						if(DealershipLockLevel[playerid] == 2)
							strcat(str, "{FFFF00}>>{FFFFFF}Lock Level 2 - $3,000\n");

						else strcat(str, "Lock Level 2 - $3,000\n");

						if(DealershipLockLevel[playerid] == 3)
							strcat(str, "{FFFF00}>>{FFFFFF}Lock Level 3 - $5,000\n");

						else strcat(str, "Lock Level 3 - $5,000\n");

						if(DealershipLockLevel[playerid] == 4)
							strcat(str, "{FFFF00}>>{FFFFFF}Lock Level 4 - $ 8,000\n");

						else strcat(str, "Lock Level 4 - $8,000\n");

						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_LOCK, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
					}
					case 2: //Immob;
					{
						if(DealershipImmobLevel[playerid] == 1)
							strcat(str, "{FFFF00}>>{FFFFFF}Immobiliser Level 1 - $0\n");

						else strcat(str, "Immobiliser Level 1 - $0\n");

						if(DealershipImmobLevel[playerid] == 2)
							strcat(str, "{FFFF00}>>{FFFFFF}Immobiliser Level 2 - $3,000\n");

						else strcat(str, "Immobiliser Level 2 - $3,000\n");

						if(DealershipImmobLevel[playerid] == 3)
							strcat(str, "{FFFF00}>>{FFFFFF}Immobiliser Level 3 - $5,000\n");

						else strcat(str, "Immobiliser Level 3 - $5,000\n");

						if(DealershipImmobLevel[playerid] == 4)
							strcat(str, "{FFFF00}>>{FFFFFF}Immobiliser Level 4 - $7,000\n");

						else strcat(str, "Immobiliser Level 4 - $7,000\n");

						if(DealershipImmobLevel[playerid] == 5)
							strcat(str, "{FFFF00}>>{FFFFFF}Immobiliser Level 5 - $11,000\n");

						else strcat(str, "Immobiliser Level 5 - $11,000\n");

						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_IMMOB, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
					}
					case 3: //Colors
					{
						new
							dstr[128]
						;

						format(dstr, sizeof(dstr), "{FFFFFF}Color 1 ({%06x}%d{FFFFFF})\n", VehicleColoursTableRGBA[DealershipCarColors[playerid][0]] >>> 8, DealershipCarColors[playerid][0]);
						strcat(str, dstr);

						format(dstr, sizeof(dstr), "{FFFFFF}Color 2 ({%06x}%d{FFFFFF})\n", VehicleColoursTableRGBA[DealershipCarColors[playerid][1]] >>> 8, DealershipCarColors[playerid][1]);
						strcat(str, dstr);

						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_COLORMENU, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
					}
					case 4: //XM-Radio
					{
						if(!DealershipXMR[playerid])
						{
							DealershipXMR[playerid] = 1;
							DealershipTotalCost[playerid]+= 1500;
						}
						else
						{
							DealershipXMR[playerid] = 0;
							DealershipTotalCost[playerid]-= 1500;
						}

						return ShowDealerAppend(playerid);
					}
					case 5: //Purchase
					{
						new
							dstr[128],
							Float:vehMass,
							Float:vehVelo,
							vehDrive[60],
							vehFuel[60]
						;

						vehMass = GetVehicleModelInfoAsFloat(GetVehicleModel(DealershipPlayerCar[playerid]), "fMass");
						vehVelo = GetVehicleModelInfoAsFloat(GetVehicleModel(DealershipPlayerCar[playerid]), "TransmissionData_fMaxVelocity");


						if(GetVehicleModelInfoAsInt(GetVehicleModel(DealershipPlayerCar[playerid]), "TransmissionData_nDriveType") == 'F')
							vehDrive = "Front-Wheel Drive";

						else if(GetVehicleModelInfoAsInt(GetVehicleModel(DealershipPlayerCar[playerid]), "TransmissionData_nDriveType") == 'R')
							vehDrive = "Rear-Wheel Drive";

						else if(GetVehicleModelInfoAsInt(GetVehicleModel(DealershipPlayerCar[playerid]), "TransmissionData_nDriveType") == '4')
							vehDrive = "4-Wheel Drive";


						if(GetVehicleModelInfoAsInt(GetVehicleModel(DealershipPlayerCar[playerid]), "TransmissionData_nEngineType") == 'P')
							vehFuel = "Petrol";

						else if(GetVehicleModelInfoAsInt(GetVehicleModel(DealershipPlayerCar[playerid]), "TransmissionData_nEngineType") == 'D')
							vehFuel = "Diesel";

						else if(GetVehicleModelInfoAsInt(GetVehicleModel(DealershipPlayerCar[playerid]), "TransmissionData_nEngineType") == 'E')
							vehFuel = "Electric";

						format(dstr, sizeof(dstr), "{FFFF00}Value:\t\t{FFFFFF}$%s \n", MoneyFormat(g_aDealershipData[SubDealershipHolder[playerid]][eDealershipPrice]));
						strcat(str, dstr);

						format(dstr, sizeof(dstr), "{FFFF00}Max Speed:\t\t{FFFFFF}%.1f \n", GetVehicleTopSpeed(DealershipPlayerCar[playerid]));
						strcat(str, dstr);

						format(dstr, sizeof(dstr), "{FFFF00}Max Velocity:\t\t{FFFFFF}%.2f \n", vehVelo);
						strcat(str, dstr);

						format(dstr, sizeof(dstr), "{FFFF00}Mass:\t\t{FFFFFF}%.2f \n\n", vehMass);
						strcat(str, dstr);

						format(dstr, sizeof(dstr), "{FFFF00}Engine Drive:\t\t{FFFFFF}%s \n", vehDrive);
						strcat(str, dstr);

						format(dstr, sizeof(dstr), "{FFFF00}Engine Fuel:\t\t{FFFFFF}%s \n\n", vehFuel);
						strcat(str, dstr);

						switch(DealershipAlarmLevel[playerid])
						{
							case 1: strcat(str, "{FFFF00}Alarm:\t\t{FFFFFF}Level 1 $2,000\n");
							case 2: strcat(str, "{FFFF00}Alarm:\t\t{FFFFFF}Level 2 $4,000\n");
							case 3: strcat(str, "{FFFF00}Alarm:\t\t{FFFFFF}Level 3 $6,000\n");
							case 4: strcat(str, "{FFFF00}Alarm:\t\t{FFFFFF}Level 4 $10,000\n");
						}

						switch(DealershipLockLevel[playerid])
						{
							case 1: strcat(str, "{FFFF00}Lock:\t\t{FFFFFF}Level 1 $1,000\n");
							case 2: strcat(str, "{FFFF00}Lock:\t\t{FFFFFF}Level 2 $3,000\n");
							case 3: strcat(str, "{FFFF00}Lock:\t\t{FFFFFF}Level 3 $5,000\n");
							case 4: strcat(str, "{FFFF00}Lock:\t\t{FFFFFF}Level 4 $8,000\n");
						}

						switch(DealershipImmobLevel[playerid])
						{
							case 2: strcat(str, "{FFFF00}Immobiliser:\t\t{FFFFFF}Level 2 $3,000\n");
							case 3: strcat(str, "{FFFF00}Immobiliser:\t\t{FFFFFF}Level 3 $5,000\n");
							case 4: strcat(str, "{FFFF00}Immobiliser:\t\t{FFFFFF}Level 4 $7,000\n");
							case 5: strcat(str, "{FFFF00}Immobiliser:\t\t{FFFFFF}Level 5 $11,000\n");
						}

						if(DealershipXMR[playerid])
							strcat(str, "{FFFF00}XM-Radio:\t\t{FFFFFF}$1,500\n");

						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_PURCHASE, DIALOG_STYLE_MSGBOX, caption, str, "Edit", "Checkout");
						return 1;
					}
				}
			}
			else ConfirmDialog(playerid, "Confirmation", "Are you sure you want to exit?", "OnPlayerExitDealership");
			return 1;
		}
		case DIALOG_DEALERSHIP_PURCHASE:
		{
			if(response)
			{
				return ShowDealerAppend(playerid);
			}
			else
			{
				if(DealershipTotalCost[playerid] > PlayerInfo[playerid][pMoney])
				{
					SendServerMessage(playerid, "You can't afford the total price. (Price: $%s, Total:$%s)", MoneyFormat(DealershipTotalCost[playerid]), MoneyFormat(PlayerInfo[playerid][pMoney]));

					DestroyVehicle(DealershipPlayerCar[playerid]);
					TogglePlayerControllable(playerid, 1);

					return ResetDealershipVars(playerid);
				}

				new
					idx,
					plates[32],
					randset[3],
					insert[1024],
					Float:x,
					Float:y,
					Float:z,
					Float:a;

				for(new i = 1; i < MAX_PLAYER_VEHICLES; i++)
				{
					if(!PlayerInfo[playerid][pOwnedVehicles][i])
					{
						idx = i;
						break;
					}
				}

				GetVehiclePos(DealershipPlayerCar[playerid], x, y, z);
				GetVehicleZAngle(DealershipPlayerCar[playerid], a);

				randset[0] = random(sizeof(possibleVehiclePlates));
				randset[1] = random(sizeof(possibleVehiclePlates));
				randset[2] = random(sizeof(possibleVehiclePlates));

				format(plates, 32, "%d%s%s%s%d%d%d", random(9), possibleVehiclePlates[randset[0]], possibleVehiclePlates[randset[1]], possibleVehiclePlates[randset[2]], random(9), random(9));
				GiveMoney(playerid, -DealershipTotalCost[playerid]);

				SendClientMessage(playerid, 0xB9E35EFF, "PROCESSING: Your vehicles being setup.");
				ShowPlayerPlates(playerid, plates);

				mysql_format(ourConnection, insert, sizeof(insert), "INSERT INTO vehicles (VehicleOwnerDBID, VehicleModel, VehicleParkPosX, VehicleParkPosY, VehicleParkPosZ, VehicleParkPosA) VALUES(%i, %i, %f, %f, %f, %f)",
					PlayerInfo[playerid][pDBID], g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModelID], x, y, z, a);

				mysql_tquery(ourConnection, insert, "OnPlayerVehiclePurchase", "iisffff", playerid, idx, plates, x, y, z, a);

				PlayerPurchasingVehicle[playerid] = true;
				TogglePlayerControllable(playerid, 1);
			}
			return 1;
		}
		case DIALOG_DEALERSHIP_APPEND_ALARM:
		{
			new
				str[400],
				caption[60]
			;

			if(response)
			{
				 switch(listitem)
				 {
					case 0:
					{
						if(DealershipAlarmLevel[playerid] != 1)
							DealershipTotalCost[playerid]+= 2000;

						if(DealershipAlarmLevel[playerid] == 2)
							DealershipTotalCost[playerid]-= 4000;

						else if(DealershipAlarmLevel[playerid] == 3)
							DealershipTotalCost[playerid]-= 6000;

						else if(DealershipAlarmLevel[playerid] == 4)
							DealershipTotalCost[playerid]-= 10000;

						DealershipAlarmLevel[playerid] = 1;

						format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

						strcat(str, "{FFFF00}>>{FFFFFF}Alarm Level 1 - $2,000\n");
						strcat(str, "Alarm Level 2 - $4,000\n");
						strcat(str, "Alarm Level 3 - $6,000\n");
						strcat(str, "Alarm Level 4 - $10,000\n");

						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_ALARM, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
					}
					case 1:
					{
						if(DealershipAlarmLevel[playerid] != 2)
							DealershipTotalCost[playerid]+= 4000;

						if(DealershipAlarmLevel[playerid] == 1)
							DealershipTotalCost[playerid]-= 2000;

						else if(DealershipAlarmLevel[playerid] == 3)
							DealershipTotalCost[playerid] -= 6000;

						else if(DealershipAlarmLevel[playerid] == 4)
							DealershipTotalCost[playerid] -= 10000;

						DealershipAlarmLevel[playerid] = 2;

						format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

						strcat(str, "Alarm Level 1 - $2,000\n");
						strcat(str, "{FFFF00}>>{FFFFFF}Alarm Level 2 - $4,000\n");
						strcat(str, "Alarm Level 3 - $6,000\n");
						strcat(str, "Alarm Level 4 - $10,000\n");

						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_ALARM, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
					}
					case 2:
					{
						if(DealershipAlarmLevel[playerid] != 3)
							DealershipTotalCost[playerid]+= 6000;

						if(DealershipAlarmLevel[playerid] == 1)
							DealershipTotalCost[playerid]-= 2000;

						else if(DealershipAlarmLevel[playerid] == 2)
							DealershipTotalCost[playerid]-= 4000;

						else if(DealershipTotalCost[playerid] == 4)
							DealershipTotalCost[playerid]-= 10000;

						DealershipAlarmLevel[playerid] = 3;

						format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

						strcat(str, "Alarm Level 1 - $2,000\n");
						strcat(str, "Alarm Level 2 - $4,000\n");
						strcat(str, "{FFFF00}>>{FFFFFF}Alarm Level 3 - $6,000\n");
						strcat(str, "Alarm Level 4 - $10,000\n");

						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_ALARM, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
					}
					case 3:
					{
						if(DealershipAlarmLevel[playerid] != 4)
							DealershipTotalCost[playerid]+= 10000;

						if(DealershipAlarmLevel[playerid] == 1)
							DealershipTotalCost[playerid]-= 2000;

						else if(DealershipAlarmLevel[playerid] == 2)
							DealershipTotalCost[playerid]-= 4000;

						else if(DealershipAlarmLevel[playerid] == 3)
							DealershipTotalCost[playerid]-= 6000;

						DealershipAlarmLevel[playerid] = 4;

						format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

						strcat(str, "Alarm Level 1 - $2,000\n");
						strcat(str, "Alarm Level 2 - $4,000\n");
						strcat(str, "Alarm Level 3 - $6,000\n");
						strcat(str, "{FFFF00}>>{FFFFFF}Alarm Level 4 - $10,000\n");

						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_ALARM, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
					}
				 }
			}
			else return ShowDealerAppend(playerid);
			return 1;
		}
		case DIALOG_DEALERSHIP_APPEND_LOCK:
		{
			new
				str[400],
				caption[60]
			;

			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						if(DealershipLockLevel[playerid] != 1)
							DealershipTotalCost[playerid]+= 1000;

						if(DealershipLockLevel[playerid] == 2)
							DealershipTotalCost[playerid]-= 3000;

						else if(DealershipLockLevel[playerid] == 3)
							DealershipTotalCost[playerid]-= 5000;

						else if(DealershipLockLevel[playerid] == 4)
							DealershipTotalCost[playerid]-= 8000;

						DealershipLockLevel[playerid] = 1;

						format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

						strcat(str, "{FFFF00}>>{FFFFFF}Lock Level 1 - $1,000\n");
						strcat(str, "Lock Level 2 - $3,000\n");
						strcat(str, "Lock Level 3 - $5,000\n");
						strcat(str, "Lock Level 4 - $8,000\n");

						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_LOCK, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
					}
					case 1:
					{
						if(DealershipLockLevel[playerid] != 2)
							DealershipTotalCost[playerid]+= 3000;

						if(DealershipLockLevel[playerid] == 1)
							DealershipTotalCost[playerid]-= 1000;

						else if(DealershipLockLevel[playerid] == 3)
							DealershipTotalCost[playerid]-= 5000;

						else if(DealershipLockLevel[playerid] == 4)
							DealershipTotalCost[playerid]-= 8000;

						DealershipLockLevel[playerid] = 2;

						format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

						strcat(str, "Lock Level 1 - $1,000\n");
						strcat(str, "{FFFF00}>>{FFFFFF}Lock Level 2 - $3,000\n");
						strcat(str, "Lock Level 3 - $5,000\n");
						strcat(str, "Lock Level 4 - $8,000\n");

						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_LOCK, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
					}
					case 2:
					{
						if(DealershipLockLevel[playerid] != 3)
							DealershipTotalCost[playerid]+= 5000;

						if(DealershipLockLevel[playerid] == 1)
							DealershipTotalCost[playerid]-= 1000;

						else if(DealershipLockLevel[playerid] == 2)
							DealershipTotalCost[playerid]-= 3000;

						else if(DealershipLockLevel[playerid] == 4)
							DealershipTotalCost[playerid]-= 8000;

						DealershipLockLevel[playerid] = 3;

						format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

						strcat(str, "Lock Level 1 - $1,000\n");
						strcat(str, "Lock Level 2 - $3,000\n");
						strcat(str, "{FFFF00}>>{FFFFFF}Lock Level 3 - $5,000\n");
						strcat(str, "Lock Level 4 - $8,000\n");

						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_LOCK, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
					}
					case 3:
					{
						if(DealershipLockLevel[playerid] != 4)
							DealershipTotalCost[playerid]+= 8000;

						if(DealershipLockLevel[playerid] == 1)
							DealershipTotalCost[playerid]-= 1000;

						else if(DealershipLockLevel[playerid] == 2)
							DealershipTotalCost[playerid]-= 3000;

						else if(DealershipLockLevel[playerid] == 3)
							DealershipTotalCost[playerid]-= 5000;

						DealershipLockLevel[playerid] = 4;

						format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

						strcat(str, "Lock Level 1 - $1,000\n");
						strcat(str, "Lock Level 2 - $3,000\n");
						strcat(str, "Lock Level 3 - $5,000\n");
						strcat(str, "{FFFF00}>>{FFFFFF}Lock Level 4 - $8,000\n");

						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_LOCK, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
					}
				}
			}
			else return ShowDealerAppend(playerid);
			return 1;
		}
		case DIALOG_DEALERSHIP_APPEND_IMMOB:
		{
			new
				str[400],
				caption[60]
			;

			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						if(DealershipImmobLevel[playerid] == 2)
							DealershipTotalCost[playerid]-= 3000;

						else if(DealershipImmobLevel[playerid] == 3)
							DealershipTotalCost[playerid]-= 5000;

						else if(DealershipImmobLevel[playerid] == 4)
							DealershipTotalCost[playerid]-= 7000;

						else if(DealershipImmobLevel[playerid] == 5)
							DealershipTotalCost[playerid]-= 11000;

						DealershipImmobLevel[playerid] = 1;

						format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

						strcat(str, "{FFFF00}>>{FFFFFF}Immobiliser Level 1 - $0\n");
						strcat(str, "Immobiliser Level 2 - $3,000\n");
						strcat(str, "Immobiliser Level 3 - $5,000\n");
						strcat(str, "Immobiliser Level 4 - $7,000\n");
						strcat(str, "Immobiliser Level 5 - $11,000\n");

						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_IMMOB, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
					}
					case 1:
					{
						if(DealershipImmobLevel[playerid] != 2)
							DealershipTotalCost[playerid]+= 3000;

						if(DealershipImmobLevel[playerid] == 3)
							DealershipTotalCost[playerid]-= 5000;

						else if(DealershipImmobLevel[playerid] == 4)
							DealershipTotalCost[playerid]-= 7000;

						else if(DealershipImmobLevel[playerid] == 5)
							DealershipTotalCost[playerid]-= 11000;

						DealershipImmobLevel[playerid] = 2;

						format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

						strcat(str, "Immobiliser Level 1 - $0\n");
						strcat(str, "{FFFF00}>>{FFFFFF}Immobiliser Level 2 - $3,000\n");
						strcat(str, "Immobiliser Level 3 - $5,000\n");
						strcat(str, "Immobiliser Level 4 - $7,000\n");
						strcat(str, "Immobiliser Level 5 - $11,000\n");

						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_IMMOB, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
					}
					case 2:
					{
						if(DealershipImmobLevel[playerid] != 3)
							DealershipTotalCost[playerid]+= 5000;

						if(DealershipImmobLevel[playerid] == 2)
							DealershipTotalCost[playerid]-= 3000;

						else if(DealershipImmobLevel[playerid] == 4)
							DealershipTotalCost[playerid]-= 7000;

						else if(DealershipImmobLevel[playerid] == 5)
							DealershipTotalCost[playerid]-= 11000;

						DealershipImmobLevel[playerid] = 3;

						format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

						strcat(str, "Immobiliser Level 1 - $0\n");
						strcat(str, "Immobiliser Level 2 - $3,000\n");
						strcat(str, "{FFFF00}>>{FFFFFF}Immobiliser Level 3 - $5,000\n");
						strcat(str, "Immobiliser Level 4 - $7,000\n");
						strcat(str, "Immobiliser Level 5 - $11,000\n");

						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_IMMOB, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
					}
					case 3:
					{
						if(DealershipImmobLevel[playerid] != 4)
							DealershipTotalCost[playerid]+= 7000;

						if(DealershipImmobLevel[playerid] == 2)
							DealershipTotalCost[playerid]-= 3000;

						else if(DealershipImmobLevel[playerid] == 3)
							DealershipTotalCost[playerid]-= 5000;

						else if(DealershipImmobLevel[playerid] == 5)
							DealershipTotalCost[playerid]-= 11000;

						DealershipImmobLevel[playerid] = 4;

						format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

						strcat(str, "Immobiliser Level 1 - $0\n");
						strcat(str, "Immobiliser Level 2 - $3,000\n");
						strcat(str, "Immobiliser Level 3 - $5,000\n");
						strcat(str, "{FFFF00}>>{FFFFFF}Immobiliser Level 4 - $7,000\n");
						strcat(str, "Immobiliser Level 5 - $11,000\n");

						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_IMMOB, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
					}
					case 4:
					{
						if(DealershipImmobLevel[playerid] != 5)
							DealershipTotalCost[playerid]-= 11000;

						if(DealershipImmobLevel[playerid] == 2)
							DealershipTotalCost[playerid]-= 3000;

						else if(DealershipImmobLevel[playerid] == 3)
							DealershipTotalCost[playerid]-= 5000;

						else if(DealershipImmobLevel[playerid] == 4)
							DealershipTotalCost[playerid]-= 7000;

						DealershipImmobLevel[playerid] = 5;

						format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

						strcat(str, "Immobiliser Level 1 - $0\n");
						strcat(str, "Immobiliser Level 2 - $3,000\n");
						strcat(str, "Immobiliser Level 3 - $5,000\n");
						strcat(str, "Immobiliser Level 4 - $7,000\n");
						strcat(str, "{FFFF00}>>{FFFFFF}Immobiliser Level 5 - $11,000\n");

						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_IMMOB, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
					}
				}
			}
			else return ShowDealerAppend(playerid);
			return 1;
		}
		case DIALOG_DEALERSHIP_APPEND_COLORMENU:
		{
			new
				str[128],
				caption[60]
			;

			format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

			if(response)
			{
				switch(listitem)
				{
					case 0:
					{
						format(str, sizeof(str), "{FFFFFF}You're selecting your vehicles first color. ({%06x}%d{FFFFFF})\n Please select a Color ID. (0-255)", VehicleColoursTableRGBA[DealershipCarColors[playerid][0]] >>> 8, DealershipCarColors[playerid][0]);
						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_COLOR1, DIALOG_STYLE_INPUT, caption, str, "Select", "Back");
					}
					case 1:
					{
						format(str, sizeof(str), "{FFFFFF}You're selecting your vehicles second color. ({%06x}%d{FFFFFF})\n Please select a Color ID. (0-255)", VehicleColoursTableRGBA[DealershipCarColors[playerid][1]] >>> 8, DealershipCarColors[playerid][1]);
						ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_COLOR2, DIALOG_STYLE_INPUT, caption, str, "Select", "Back");
					}
				}
			}
			else return ShowDealerAppend(playerid);
			return 1;
		}
		case DIALOG_DEALERSHIP_APPEND_COLOR1:
		{
			new
				caption[60],
				str[128],
				color1
			;

			format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

			if(response)
			{
				if(!IsNumeric(inputtext))
				{
					format(str, sizeof(str), "{FFFFFF}You're selecting your vehicles first color. ({%06x}%d{FFFFFF})\n Please select a Color ID. (0-255)", VehicleColoursTableRGBA[DealershipCarColors[playerid][0]] >>> 8, DealershipCarColors[playerid][0]);
					return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_COLOR1, DIALOG_STYLE_INPUT, caption, str, "Select", "Back");
				}

				color1 = strval(inputtext);

				if(color1 > 255 || color1 < 0)
				{
					format(str, sizeof(str), "{FFFFFF}You're selecting your vehicles first color. ({%06x}%d{FFFFFF})\n Please select a Color ID. (0-255)", VehicleColoursTableRGBA[DealershipCarColors[playerid][0]] >>> 8, DealershipCarColors[playerid][0]);
					return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_COLOR1, DIALOG_STYLE_INPUT, caption, str, "Select", "Back");
				}

				ChangeVehicleColor(DealershipPlayerCar[playerid], color1, DealershipCarColors[playerid][1]);

				DealershipCarColors[playerid][0] = color1;
				return ShowDealerAppend(playerid);
			}
			else
			{
				new
					dstr[128]
				;

				format(dstr, sizeof(dstr), "{FFFFFF}Color 1 ({%06x}%d{FFFFFF})\n", VehicleColoursTableRGBA[DealershipCarColors[playerid][0]] >>> 8, DealershipCarColors[playerid][0]);
				strcat(str, dstr);

				format(dstr, sizeof(dstr), "{FFFFFF}Color 2 ({%06x}%d{FFFFFF})\n", VehicleColoursTableRGBA[DealershipCarColors[playerid][1]] >>> 8, DealershipCarColors[playerid][1]);
				strcat(str, dstr);

				ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_COLORMENU, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
			}
			return 1;
		}
		case DIALOG_DEALERSHIP_APPEND_COLOR2:
		{
			new
				caption[60],
				str[128],
				color2
			;

			format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

			if(response)
			{
				if(!IsNumeric(inputtext))
				{
					format(str, sizeof(str), "{FFFFFF}You're selecting your vehicles second color. ({%06x}%d{FFFFFF})\n Please select a Color ID. (0-255)", VehicleColoursTableRGBA[DealershipCarColors[playerid][1]] >>> 8, DealershipCarColors[playerid][1]);
					return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_COLOR1, DIALOG_STYLE_INPUT, caption, str, "Select", "Back");
				}

				color2 = strval(inputtext);

				if(color2 > 255 || color2 < 0)
				{
					format(str, sizeof(str), "{FFFFFF}You're selecting your vehicles second color. ({%06x}%d{FFFFFF})\n Please select a Color ID. (0-255)", VehicleColoursTableRGBA[DealershipCarColors[playerid][1]] >>> 8, DealershipCarColors[playerid][1]);
					return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_COLOR1, DIALOG_STYLE_INPUT, caption, str, "Select", "Back");
				}

				ChangeVehicleColor(DealershipPlayerCar[playerid], DealershipCarColors[playerid][0], color2);

				DealershipCarColors[playerid][1] = color2;
				return ShowDealerAppend(playerid);
			}
			else
			{
				new
					dstr[128]
				;

				format(dstr, sizeof(dstr), "{FFFFFF}Color 1 ({%06x}%d{FFFFFF})\n", VehicleColoursTableRGBA[DealershipCarColors[playerid][0]] >>> 8, DealershipCarColors[playerid][0]);
				strcat(str, dstr);

				format(dstr, sizeof(dstr), "{FFFFFF}Color 2 ({%06x}%d{FFFFFF})\n", VehicleColoursTableRGBA[DealershipCarColors[playerid][1]] >>> 8, DealershipCarColors[playerid][1]);
				strcat(str, dstr);

				ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND_COLORMENU, DIALOG_STYLE_LIST, caption, str, "Select", "Back");
			}
			return 1;
		}
		case DIALOG_SELECT_HOUSE:
		{
			if(response)
			{
				new
					id
				;

				id = playerHouseSelect[playerid][listitem];

				PlayerInfo[playerid][pSpawnPoint] = SPAWN_POINT_PROPERTY;
				PlayerInfo[playerid][pSpawnPointHouse] = id;

				SendServerMessage(playerid, "You selected Property %i and will now spawn there.", listitem);
			}
			return 1;
		}
		case DIALOG_MDC:
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: return ShowPlayerDialog(playerid, DIALOG_MDC_NAME, DIALOG_STYLE_INPUT, "Name Search - MDC", "Enter the persons full name to search below:", "Search", "Back");
					case 1: return ShowPlayerDialog(playerid, DIALOG_MDC_PLATE, DIALOG_STYLE_INPUT, "Plate Search - MDC", "Enter the vehicles full or partial plate to search below:", "Search", "Back");
					case 2: return ShowPlayerDialog(playerid, DIALOG_MDC_PROPERTY, DIALOG_STYLE_INPUT, "Property Search - MDC", "Enter the property's full or partial name to search below:", "Search", "Back");
					case 3: return ShowPlayerDialog(playerid, DIALOG_MDC_TICKET, DIALOG_STYLE_INPUT, "Issue Ticket - MDC", "Enter the persons full name below:", "Continue", "Back");
				}
				return 1;
			}
		}
		case DIALOG_MDC_NAME:
		{
			if(response)
			{
				if(strlen(inputtext) < 3 || strlen(inputtext) > 32)
					return ShowPlayerDialog(playerid, DIALOG_MDC_NAME, DIALOG_STYLE_INPUT, "Name Search - MDC", "Enter the persons full name to search below:", "Search", "Back");

				for(new i = 0; i < strlen(inputtext); i++)
				{
					if(inputtext[i] == '_')
					{
						return ShowPlayerDialog(playerid, DIALOG_MDC_NAME, DIALOG_STYLE_INPUT, "Name Search - MDC", "Enter the persons full name to search below:", "Search", "Back");
					}
					else
					{
						if(inputtext[i] == ' ')
						{
							inputtext[i] = '_';
						}
					}
				}

				PlayerMDCCount[playerid] = 0;
				PlayerMDCTimer[playerid] = SetTimerEx("OnMDCSearch", 1000, true, "ii", playerid, 1);

				format(PlayerMDCName[playerid], 32, "%s", inputtext);
				ShowPlayerDialog(playerid, DIALOG_MDC_NAME_QUEUE, DIALOG_STYLE_MSGBOX, "Name Search - MDC", "Searching.", "Cancel", "");
				return 1;
			}
			else return ShowPlayerMDC(playerid);
		}
  		case DIALOG_MDC_TICKET:
		{
			if(response)
			{
				if(strlen(inputtext) < 3 || strlen(inputtext) > 32)
					return ShowPlayerDialog(playerid, DIALOG_MDC_NAME, DIALOG_STYLE_INPUT, "Issue Ticket - MDC", "Enter the persons full name below:", "Continue", "Back");

				for(new i = 0; i < strlen(inputtext); i++)
				{
					if(inputtext[i] == '_')
					{
						return ShowPlayerDialog(playerid, DIALOG_MDC_NAME, DIALOG_STYLE_INPUT, "Issue Ticket - MDC", "Enter the persons full name below:", "Continue", "Back");
					}
					else
					{
						if(inputtext[i] == ' ')
						{
							inputtext[i] = '_';
						}
					}
				}

				SendErrorMessage(playerid, "Out of Service");
				return 1;
			}
			else return ShowPlayerMDC(playerid);
		}
		case DIALOG_MDC_PROPERTY:
		{
			if(response)
			{
				if(strlen(inputtext) > 20 || strlen(inputtext) < 3)
					return ShowPlayerDialog(playerid, DIALOG_MDC_PROPERTY, DIALOG_STYLE_INPUT, "Property Search - MDC", "Enter the property's full or partial name to search below:", "Search", "Back");

				PlayerMDCCount[playerid] = 0;
				PlayerMDCTimer[playerid] = SetTimerEx("OnMDCSearch", 1000, true, "ii", playerid, 3);

				format(PlayerMDCName[playerid], 32, "%s", inputtext);
				ShowPlayerDialog(playerid, DIALOG_MDC_PROPERTY_QUEUE, DIALOG_STYLE_MSGBOX, "Property Search - MDC", "Searching.", "Cancel", "");
			}
			else return ShowPlayerMDC(playerid);
		}
		case DIALOG_MDC_PLATE:
		{
			if(response)
			{
				if(strlen(inputtext) > 6 || strlen(inputtext) < 3)
					return ShowPlayerDialog(playerid, DIALOG_MDC_PLATE, DIALOG_STYLE_INPUT, "Plate Search - MDC", "Enter the vehicles full or partial plate to search below:\n\nYou need at least 3 characters for a plate search.", "Search", "Back");

				PlayerMDCCount[playerid] = 0;
				PlayerMDCTimer[playerid] = SetTimerEx("OnMDCSearch", 1000, true, "ii", playerid, 2);

				format(PlayerMDCName[playerid], 32, "%s", inputtext);
				ShowPlayerDialog(playerid, DIALOG_MDC_PLATE_QUEUE, DIALOG_STYLE_MSGBOX, "Plate Search - MDC", "Searching.", "Cancel", "");
			}
			else return ShowPlayerMDC(playerid);
		}
		case DIALOG_MDC_NAME_QUEUE:
		{
			if(response)
			{
				new
					str[120];

				format(str, sizeof(str), "{FFFFFF}Name search cancelled for: \"%s\"", PlayerMDCName[playerid]);
				ShowPlayerDialog(playerid, DIALOG_DEFAULT, DIALOG_STYLE_MSGBOX, "Name Search - MDC", str, "Okay", "");

				KillTimer(PlayerMDCTimer[playerid]);
				PlayerMDCCount[playerid] = 0;
				return 1;
			}
		}
		case DIALOG_MDC_PLATE_QUEUE:
		{
			if(response)
			{
				new
					str[120];

				format(str, sizeof(str), "{FFFFFF}Plate search cancelled for: \"%s\"", PlayerMDCName[playerid]);
				ShowPlayerDialog(playerid, DIALOG_DEFAULT, DIALOG_STYLE_MSGBOX, "Plate Search - MDC", str, "Okay", "");

				KillTimer(PlayerMDCTimer[playerid]);

				for(new i = 0; i < 5; i++) PlayerPlateSaver[playerid][i] = "";
				PlayerMDCName[playerid] = "";
				PlayerMDCCount[playerid] = 0;
			}
		}
		case DIALOG_MDC_PROPERTY_QUEUE:
		{
			if(response)
			{
				new
					str[120];

				format(str, sizeof(str), "{FFFFFF}Property search cancelled for: \"%s\"", PlayerMDCName[playerid]);
				ShowPlayerDialog(playerid, DIALOG_DEFAULT, DIALOG_STYLE_MSGBOX, "Property Search - MDC", str, "Okay", "");

				KillTimer(PlayerMDCTimer[playerid]);

				for(new i = 0; i < 5; i++) PlayerPlateSaver[playerid][i] = "";
				PlayerMDCName[playerid] = "";
				PlayerMDCCount[playerid] = 0;
			}
		}
		case DIALOG_MDC_PROPERTY_LIST:
		{
			if(response)
			{
				new query[220];

				mysql_format(ourConnection, query, sizeof(query), "SELECT PropertyOwnerDBID FROM properties WHERE PropertyAdress = '%e'", PlayerPlateSaver[playerid][listitem]);
				mysql_tquery(ourConnection, query, "OnPropertySelect", "ii", playerid, listitem);
				return 1;
			}
		}
		case DIALOG_MDC_PLATE_LIST:
		{
			if(response)
			{
				new query[220];

				mysql_format(ourConnection, query, sizeof(query), "SELECT VehicleOwnerDBID, VehicleModel, VehicleImpounded FROM vehicles WHERE VehiclePlates = '%e'", PlayerPlateSaver[playerid][listitem]);
				mysql_tquery(ourConnection, query, "OnPlateSelect", "ii", playerid, listitem);
				return 1;
			}
		}
		case DIALOG_MDC_FINISH_QUEUE:
		{
			if(response)
			{
				ShowPlayerMDC(playerid);
				return 1;
			}
		}
		case DIALOG_SECRETWORD_CREATE:
		{
			if(response)
			{
				new
					insert[128];

				mysql_format(ourConnection, insert, sizeof(insert), "UPDATE masters SET secret_word = sha1('%e') WHERE acc_dbid = %i", inputtext, e_pAccountData[playerid][mDBID]);
				mysql_tquery(ourConnection, insert);

				mysql_format(ourConnection, insert, sizeof(insert), "SELECT acc_dbid FROM masters WHERE acc_name = '%e'", ReturnName(playerid));
				mysql_tquery(ourConnection, insert, "LogPlayerIn", "i", playerid);
				return 1;
			}
			else
			{
				return KickEx(playerid);
			}
		}
		case DIALOG_SECRETWORD_INPUT:
		{
			if(response)
			{
				new
					query[128];

				mysql_format(ourConnection, query, sizeof(query), "SELECT secret_word FROM masters WHERE acc_name = '%e' AND secret_word = sha1('%e')", ReturnName(playerid), inputtext);
				mysql_tquery(ourConnection, query, "OnSecretWordInput", "i", playerid);
				return 1;
			}

			else
			{
				return KickEx(playerid);
			}

		}
	}
	if(dialogid == 112)
	{
		if(response)
		{
			if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{FF0000}<!> You must be in a vehicle to use navigation!");
			pNavID[playerid] = listitem;
			new str[128];
			SetPlayerCheckpoint(playerid, NavData[pNavID[playerid]][NAV_X], NavData[pNavID[playerid]][NAV_Y], NavData[pNavID[playerid]][NAV_Z], 3.0);
			format(str, 128, "{00FF00}<!> Destination is set to {FFA500}%s", NavData[pNavID[playerid]][NAV_NAME]);
			SendClientMessage(playerid, -1, str);
			SendClientMessage(playerid, -1, "{00FF00}<!> You can type {FF7D0A}/navclose {00FF00}to cancel the navigation.");
			if(IsValidObject(ok[playerid])) DestroyObject(ok[playerid]);
			ok[playerid] = CreateObject(19134, 0, 0, 0, 0, 0, 0);
			Refresh(playerid);
			KillTimer(pNavTimer[playerid]);
			pNavTimer[playerid] = SetTimerEx("Refresh", 100, true, "d", playerid);
			for(new i; i<sizeof(NAVTD); i++) TextDrawShowForPlayer(playerid, NAVTD[i]);
			PlayerTextDrawShow(playerid, NAVpTD[playerid]);
			PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
			pNavState[playerid] = 1;
		}
	}
	if(dialogid == RADIO)
   		{
            if(listitem == 0)
			{
			StopAudioStreamForPlayer(playerid);
    		GameTextForPlayer(playerid, "Radio Stopped.",2500,1);
 			}
 			if(listitem == 1)
  			{
 			PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1283896");
     		GameTextForPlayer(playerid, "Playing 181.FM - POWER 181...",2500,1);
  			}
  			if(listitem == 2)
  			{
 			PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=35402");
     		GameTextForPlayer(playerid, "Playing 181.FM - Chilled...",2500,1);
  			}
  			if(listitem == 3)
  			{
 			PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=508962");
     		GameTextForPlayer(playerid, "Playing 181.FM - Party...",2500,1);
  			}
  			if(listitem == 4)
  			{
 			PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=297243");
     		GameTextForPlayer(playerid, "Playing 181.FM - Highway 181...",2500,1);
  			}
            if(listitem == 5)
  			{
 			PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1283687");
     		GameTextForPlayer(playerid, "Playing 181.FM - Kickin' Country...",2500,1);
  			}
			if(listitem == 6)
  			{
 			PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=248370");
     		GameTextForPlayer(playerid, "Playing COUNTRY 108...",2500,1);
  			}
  			if(listitem == 7)
			{
			PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=520036");
     		GameTextForPlayer(playerid, "Playing DEFJAY.COM - 100% R&B...",2500,1);
 			}
  			if(listitem == 8)
			{
			PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=203280");
     		GameTextForPlayer(playerid, "Playing Antena1 SP 94,7 FM...",2500,1);
 			}
  			if(listitem == 9)
  			{
 			PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=914897");
     		GameTextForPlayer(playerid, "Playing idobi Radio...",2500,1);
  			}
  			if(listitem == 10)
  			{
 			PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=210158");
     		GameTextForPlayer(playerid, "Playing America Country Radio...",2500,1);
  			}
			if(listitem == 11)
			{
			PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=86433");
        	GameTextForPlayer(playerid, "Playing Absolutely Smooth Jazz - SKY.FM...",2500,1);
 			}
 			if(listitem == 12)
  			{
 			PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=467000");
     		GameTextForPlayer(playerid, "Playing SmoothJazz.com Global Radio...",2500,1);
  			}
  			if(listitem == 13)
  			{
 			PlayAudioStreamForPlayer(playerid, "http://cnr-radio.com/listen.m3u");
      		GameTextForPlayer(playerid, "Playing CnR Radio...",2500,1);
  			}
  			if(listitem == 14)
  			{
 			PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=721890");
      		GameTextForPlayer(playerid, "Playing ))) POLSKASTACJA .PL )))...",2500,1);
  			}
  			if(listitem == 15)
  			{
 			PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=31903");
      		GameTextForPlayer(playerid, "Playing NOISEfm.pl - Niezalezne Radio Rock...",2500,1);
  			}
  			if(listitem == 16)
  			{
 			PlayAudioStreamForPlayer(playerid, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=35899");
     		GameTextForPlayer(playerid, "Playing RadioTeenTal Indian and Bollywood...",2500,1);
  			}
  			if(listitem == 17)
  			{
 			PlayAudioStreamForPlayer(playerid, "http://www.dubstep.fm/listen.pls");
      		GameTextForPlayer(playerid, "Playing DUBSTEP.FM...",2500,1);
  			}
  			if(listitem == 18)
  			{
 			PlayAudioStreamForPlayer(playerid, "http://servers.internet-radio.com/tools/playlistgenerator/?u=http://www.partyvibe.com:8006/listen.pls&t=.pls");
      		GameTextForPlayer(playerid, "Playing PARTY VIBE RADIO...",2500,1);
  			}
  			if(listitem == 19)
  			{
 			PlayAudioStreamForPlayer(playerid, "http://servers.internet-radio.com/tools/playlistgenerator/?u=http://92.48.107.35:8004/listen.pls&t=.pls");
      		GameTextForPlayer(playerid, "Playing RADIO ORO MARBELLA EN DIRECTO...",2500,1);
  			}
  			if(listitem == 20)
  			{
 			PlayAudioStreamForPlayer(playerid, "http://servers.internet-radio.com/tools/playlistgenerator/?u=http://sc1.christiannetcast.com:9138/listen.pls&t=.pls");
      		GameTextForPlayer(playerid, "Playing Radio Nueva Vida...",2500,1);
  			}
     	}
	return 0;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    return 1;
}
function:OnMDCSearch(playerid, type)
{
	new
		caption[32],
		dialog_id,
		str[60]
	;

	if(type == 1)
	{
		caption = "Name Search - MDC";
		dialog_id = DIALOG_MDC_NAME_QUEUE;
	}
	if(type == 2)
	{
		caption = "Plate Search - MDC";
		dialog_id = DIALOG_MDC_PLATE_QUEUE;
	}
	if(type == 3)
	{
		caption = "Property Search - MDC";
		dialog_id = DIALOG_MDC_PROPERTY_QUEUE;
	}

	PlayerMDCCount[playerid]++;

	switch(PlayerMDCCount[playerid])
	{
		case 1: str = "Searching..";
		case 2: str = "Searching...";
		case 3: str = "Searching....";
		case 4: str = "Search completed. Please wait.";
		case 5:
		{
			KillTimer(PlayerMDCTimer[playerid]);
			PlayerMDCCount[playerid] = 0;

			OnMDCRecordSearch(playerid, type);
			return 1;
		}
	}

	ShowPlayerDialog(playerid, dialog_id, DIALOG_STYLE_MSGBOX, caption, str, "Cancel", "");
	return 1;
}

function:OnMDCRecordSearch(playerid, type)
{
	new
		query[255];

	switch(type)
	{
		case 1: //Name search;
		{
			if(!ReturnDBIDFromName(PlayerMDCName[playerid]))
			{
				return ShowPlayerDialog(playerid, DIALOG_DEFAULT, DIALOG_STYLE_MSGBOX, "Name Search - MDC", "{FFFFFF}The name you inputted was not found.", "Back", "");
			}

			mysql_format(ourConnection, query, sizeof(query), "SELECT pPhone, pAge, pOrigin, pActiveListings, pPrisonTimes, pJailTimes FROM characters WHERE char_dbid = %i", ReturnDBIDFromName(PlayerMDCName[playerid]));
			mysql_tquery(ourConnection, query, "OnMDCNameFound", "i", playerid);
			
		}
		case 2: //Plate search;
		{
			mysql_format(ourConnection, query, sizeof(query), "SELECT VehiclePlates FROM vehicles WHERE VehiclePlates LIKE '%%%e%%' LIMIT 5", PlayerMDCName[playerid]);
			mysql_tquery(ourConnection, query, "OnMDCPlate", "i", playerid);

			return 1;
		}
		case 3: //Property search;
		{
		    mysql_format(ourConnection, query, sizeof(query), "SELECT PropertyAdress FROM properties WHERE PropertyAdress LIKE '%%%e%%' LIMIT 5", PlayerMDCName[playerid]);
            mysql_tquery(ourConnection, query, "OnMDCProperty", "i", playerid);
		}
	}

	return 1;
}
function:OnMDCProperty(playerid)
{
	if(!cache_num_rows())
	{
		for(new i = 0; i < 5; i++) PlayerPlateSaver[playerid][i] = "";
		PlayerMDCName[playerid] = "";

		return ShowPlayerDialog(playerid, DIALOG_DEFAULT, DIALOG_STYLE_MSGBOX, "Property Search - MDC", "{FFFFFF}The adress you inputted was not found.", "Back", "");
	}

	new rows, fields, str[128];
	cache_get_data(rows, fields, ourConnection);

	for(new i = 0; i < rows; i++)
	{
		cache_get_field_content(i, "PropertyAdress", PlayerPlateSaver[playerid][i], ourConnection, 25);
	}

	for(new i = 0; i < 5; i++)
	{
		if(!isnull(PlayerPlateSaver[playerid][i]))
		{
			format(str, sizeof(str), "%s%s\n", str, PlayerPlateSaver[playerid][i]);
		}
	}

	ShowPlayerDialog(playerid, DIALOG_MDC_PROPERTY_LIST, DIALOG_STYLE_LIST, "Property Search - MDC", str, "Select", "Back");
	return 1;
}

function:OnMDCPlate(playerid)
{
	if(!cache_num_rows())
	{
		for(new i = 0; i < 5; i++) PlayerPlateSaver[playerid][i] = "";
		PlayerMDCName[playerid] = "";

		return ShowPlayerDialog(playerid, DIALOG_DEFAULT, DIALOG_STYLE_MSGBOX, "Plate Search - MDC", "{FFFFFF}The plate you inputted was not found.", "Back", "");
	}

	new rows, fields, str[128];
	cache_get_data(rows, fields, ourConnection);

	for(new i = 0; i < rows; i++)
	{
		cache_get_field_content(i, "VehiclePlates", PlayerPlateSaver[playerid][i], ourConnection, 20);
	}

	for(new i = 0; i < 5; i++)
	{
		if(!isnull(PlayerPlateSaver[playerid][i]))
		{
			format(str, sizeof(str), "%s%s\n", str, PlayerPlateSaver[playerid][i]);
		}
	}

	ShowPlayerDialog(playerid, DIALOG_MDC_PLATE_LIST, DIALOG_STYLE_LIST, "Plate Search - MDC", str, "Select", "Back");
	return 1;
}

function:OnPropertySelect(playerid, listitem)
{
	new rows, fields;
	cache_get_data(rows, fields, ourConnection);

	new
		primary_str[200],
		owner,
		sub_str[128]
	;
	
	owner = cache_get_field_content_int(0, "PropertyOwnerDBID", owner);

	format(sub_str, sizeof(sub_str), "Adress: %s\n", PlayerPlateSaver[playerid][listitem]);
	strcat(primary_str, sub_str);

	format(sub_str, sizeof(sub_str), "Registered owner: %s\n", ReturnDBIDName(owner));
	strcat(primary_str, sub_str);

	for(new i = 0; i < 5; i++) PlayerPlateSaver[playerid][i] = "";
	PlayerMDCName[playerid] = "";

	ShowPlayerDialog(playerid, DIALOG_MDC_FINISH_QUEUE, DIALOG_STYLE_MSGBOX, "Mobile Database Computer", primary_str, "Back", "");
	return 1;
}

function:OnPlateSelect(playerid, listitem)
{
	new rows, fields;
	cache_get_data(rows, fields, ourConnection);

	new
		model,
		owner,
		impounded,

		primary_str[200],
		sub_str[128]
	;

	model = cache_get_field_content_int(0, "VehicleModel", model);
	owner = cache_get_field_content_int(0, "VehicleOwnerDBID", owner);
	impounded = bool:cache_get_field_content_int(0, "VehicleImpounded", impounded);

	format(sub_str, sizeof(sub_str), "Plate: %s\n", PlayerPlateSaver[playerid][listitem]);
	strcat(primary_str, sub_str);

	format(sub_str, sizeof(sub_str), "Registered owner: %s\n", ReturnDBIDName(owner));
	strcat(primary_str, sub_str);

	if(impounded)
		strcat(primary_str, "Impounded: Yes\n");

	else strcat(primary_str, "Impounded: No\n");

	for(new i = 0; i < 5; i++) PlayerPlateSaver[playerid][i] = "";
	PlayerMDCName[playerid] = "";

	ShowPlayerDialog(playerid, DIALOG_MDC_FINISH_QUEUE, DIALOG_STYLE_MSGBOX, "Mobile Database Computer", primary_str, "Back", "");
	return 1;
}

function:OnMDCNameFound(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields, ourConnection);

	new
		primary_str[300],
		sub_str[128],

		age_str[20],
		origin_str[60],
		phone_number,

		active_listing,
		jail_times,
		prison_times,

		query[128]
	;
	phone_number = cache_get_field_content_int(0, "pPhone", phone_number);
	cache_get_field_content(0, "pAge", age_str);
	cache_get_field_content(0, "pOrigin", origin_str);
	
	active_listing = cache_get_field_content_int(0, "pActiveListings");
	jail_times = cache_get_field_content_int(0, "pJailTimes");
	prison_times = cache_get_field_content_int(0, "pPrisonTimes");

	format(sub_str, sizeof(sub_str), "Full Name: %s\n", PlayerMDCName[playerid]);
	strcat(primary_str, sub_str);

	format(sub_str, sizeof(sub_str), "Phone Number: %i\n\n", phone_number);
	strcat(primary_str, sub_str);

	format(sub_str, sizeof(sub_str), "Date of Birth: %s\n", age_str);
	strcat(primary_str, sub_str);

	format(sub_str, sizeof(sub_str), "Place of Birth: %s\n\n", origin_str);
	strcat(primary_str, sub_str);

	strcat(primary_str, "CRIMINAL RECORD:\n");

	format(sub_str, sizeof(sub_str), "Jail Sentences: %i\n", jail_times);
	strcat(primary_str, sub_str);

	format(sub_str, sizeof(sub_str), "Prison Sentences: %i\n\n", prison_times);
	strcat(primary_str, sub_str);
	
	mysql_format(ourConnection, query, sizeof(query), "SELECT PropertyAdress FROM properties WHERE PropertyOwnerDBID = %i", ReturnDBIDFromName(PlayerMDCName[playerid]));
	new Cache:hcache = mysql_query(ourConnection, query);
	new houses[128];
	
	strcat(primary_str, "PROPERTY'S:\n");
	
	if(!cache_num_rows())
		strcat(primary_str, "No Owned Houses.\n\n");

	else
	{
		for(new h = 0; h < cache_num_rows(); h++)
		{
			cache_get_field_content(h, "PropertyAdress", houses);

			format(sub_str, sizeof(sub_str), "* %s\n", houses);
			strcat(primary_str, sub_str);
		}
	}
	cache_delete(hcache);

	if(!active_listing)
		strcat(primary_str, "\nPrevious arrest reason(s): (NOT WANTED)\n");

	else strcat(primary_str, "\nOUTSTANDING CHARGES:\n");

	mysql_format(ourConnection, query, sizeof(query), "SELECT charge_reason FROM criminal_record WHERE player_name = '%e' ORDER BY idx DESC", PlayerMDCName[playerid]);
	new Cache:cache = mysql_query(ourConnection, query);
	new record[128];

	if(!cache_num_rows())
		strcat(primary_str, "No previous charges.\n");

	else
	{
		for(new i = 0; i < cache_num_rows(); i++)
		{
			cache_get_field_content(i, "charge_reason", record);

			format(sub_str, sizeof(sub_str), "* %s\n", record);
			strcat(primary_str, sub_str);
		}
	}

	cache_delete(cache);

	ShowPlayerDialog(playerid, DIALOG_MDC_FINISH_QUEUE, DIALOG_STYLE_MSGBOX, "Mobile Database Computer", primary_str, "Back", "");
	return 1;
}

function:OnPlayerRegister(playerid)
{
	e_pAccountData[playerid][mDBID] = cache_insert_id();
	format(e_pAccountData[playerid][mAccName], 32, "%s", ReturnName(playerid));

	registerTime[playerid] = 0;
	loginTime[playerid] = 1;

	SendClientMessageEx(playerid, COLOR_YELLOW, "You successfully registered as %s.", ReturnName(playerid));
	SetTimerEx("WhitelistTimer", 100, false, "i", playerid);
	return ShowPlayerDialog(playerid, DIALOG_WHITELISTR, DIALOG_STYLE_MSGBOX, "Notice", "Your account has been registered but you have not been whitelisted. Please apply at: discord.", "Close", "");
}

function:LoggingIn(playerid)
{
	if(!cache_num_rows())
	{
		playerLogin[playerid]++;
		if(playerLogin[playerid] == 3)
		{
			SendClientMessage(playerid, COLOR_REDEX, "[SERVER]: You were kicked for bad password attempts.");
			return KickEx(playerid);
		}

		return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Welcome to MGMC Roleplay", "You entered the wrong password!\n\nSERVER: You have 60 seconds to login!\nTIP: Please report all bugs that you\nmay have found to development.\n\n           Enter Your Password:", "Select", "Cancel");
	}

	new rows, fields, fetchChars[128];
	cache_get_data(rows, fields, ourConnection);

	new secret_word[128], ActiveIP[60];

	e_pAccountData[playerid][mDBID] = cache_get_field_content_int(0, "acc_dbid", ourConnection);
	cache_get_field_content(0, "forum_name", e_pAccountData[playerid][mForumName], ourConnection, 60);

	cache_get_field_content(0, "secret_word", secret_word);
	cache_get_field_content(0, "active_ip", ActiveIP);

	format(e_pAccountData[playerid][mAccName], 32, "%s", ReturnName(playerid));
/*
	if(isnull(secret_word))
	{
		ShowPlayerDialog(playerid, DIALOG_SECRETWORD_CREATE, DIALOG_STYLE_PASSWORD, "Welcome to MGMC Roleplay",
		"SECURITY PRECAUTION:\n\nWe have introduced a SECRET CONFIRMATION CODE system to help protect user accounts. This is basically a word that will be presented if any connection conditions change.\n\nYou will have to remember this.\n\n{F81414}IT IS ADVISED THIS ISN'T YOUR PASSWORD.", "Enter", "Cancel");
		return 1;
	}

	if(strcmp(ReturnIP(playerid), ActiveIP))
	{
		ShowPlayerDialog(playerid, DIALOG_SECRETWORD_INPUT, DIALOG_STYLE_PASSWORD, "Welcome to MGMC Roleplay",
		"{F81414}SECURITY PRECAUTION:{FFFFFF}\n\nOur system has flagged changes to your accounts connection conditions. To ensure there is no breach of security,\n\nPlease enter your {F81414}SECURITY CONFIRMATION CODE{FFFFFF} you selected during registration to login.", "Enter", "Cancel");
		return 1;
	}
*/
	mysql_format(ourConnection, fetchChars, sizeof(fetchChars), "SELECT * FROM bannedlist WHERE MasterDBID = %i", e_pAccountData[playerid][mDBID]);
	mysql_tquery(ourConnection, fetchChars, "Query_CheckBannedAccount", "i", playerid);
	return 1;
}

function:Query_CheckBannedAccount(playerid)
{
	if(!cache_num_rows())
	{
		new fetchChars[128];

		loginTime[playerid] = 0;
		characterPickTime[playerid] = 1;

		mysql_format(ourConnection, fetchChars, sizeof(fetchChars), "SELECT char_name, char_dbid FROM characters WHERE master_dbid = %i LIMIT 4", e_pAccountData[playerid][mDBID]);
		mysql_pquery(ourConnection, fetchChars, "DB_ListCharacters", "i", playerid);
	}
	else
	{
		new rows, fields;
		cache_get_data(rows, fields, ourConnection);

		new banDate[90], banner[32];

		cache_get_field_content(0, "Date", banDate, ourConnection, 90);
		cache_get_field_content(0, "BannedBy", banner, ourConnection, 32);

		SendServerMessage(playerid, "Your account \"%s\" is banned from our server.", ReturnName(playerid));
		SendServerMessage(playerid, "You were banned on %s by %s.", banDate, banner);
		return KickEx(playerid);
	}
	return 1;
}

function:DB_ListCharacters(playerid)
{
	if(!cache_num_rows())
	{
		SendClientMessage(playerid, COLOR_YELLOW, "You don't have any existing characters.");

		new listStrings[128];

		for (new i = 0; i < 1; i++)
		{
			characterLister[playerid][i] = "[Empty Character]";
			format(listStrings, sizeof(listStrings), "%s%s\n", listStrings, characterLister[playerid][i]);
		}

		return ShowPlayerDialog(playerid, DIALOG_CHARS, DIALOG_STYLE_LIST, "Characters:", listStrings, "Select", "Back");
	}

	if (e_pAccountData[playerid][mLoggedin] == false)
	{
		new string[128];

		format(string, sizeof(string), "You have successfully logged in as {145F0B}%s{FFFFFF}.", ReturnName(playerid));
		SendClientMessage(playerid, -1, string);

		e_pAccountData[playerid][mLoggedin] = true;
		SetPlayerCamera(playerid);
	}

	new rows, fields;
	cache_get_data(rows, fields, ourConnection);

	if(rows)
	{
		new listString[128];

		for (new i = 0; i < rows; i ++)
		{
			cache_get_field_content(i, "char_name", characterLister[playerid][i], ourConnection, 128);
		}

		for (new i = 0; i < 4; i++)
		{
			if (isnull(characterLister[playerid][i]))
			{
				characterLister[playerid][i] = "[Empty Character]";
			}

			format(listString, sizeof(listString), "%s%s\n", listString, characterLister[playerid][i]);
		}

		ShowPlayerDialog(playerid, DIALOG_CHARS, DIALOG_STYLE_LIST, "Characters:", listString, "Select", "Back");
	}
	return 1;
}

function:Query_SelectCharacter(playerid)
{
	if (!cache_num_rows())
	{
		SendClientMessage(playerid, -1, "[ERROR]: An error occurred processing your character. Returning you to your character list...");

		new
			listString[128]
		;

		for (new i = 0; i < 4; i ++) {
			format(listString, sizeof(listString), "%s%s\n", listString, characterLister[playerid][i]); }

		return ShowPlayerDialog(playerid, DIALOG_CHARS, DIALOG_STYLE_LIST, "Characters:", listString, "Select", "Back");
	}

	new rows, fields, thread[128];
	cache_get_data(rows, fields, ourConnection);

	if(rows)
	{
		mysql_format(ourConnection, thread, sizeof(thread), "SELECT * FROM characters WHERE char_name = '%e'", ReturnName(playerid));
		mysql_tquery(ourConnection, thread, "Query_LoadCharacter", "i", playerid);
	}

	return 1;
}

function:Query_LoadCharacter(playerid)
{
	PlayerInfo[playerid][pDBID] = cache_get_field_content_int(0, "char_dbid", ourConnection);

	PlayerInfo[playerid][pAdmin] = cache_get_field_content_int(0, "pAdmin", ourConnection);
	PlayerInfo[playerid][pLastSkin] = cache_get_field_content_int(0, "pLastSkin", ourConnection);

	PlayerInfo[playerid][pLastPos][0] = cache_get_field_content_float(0, "pLastPosX", ourConnection);
	PlayerInfo[playerid][pLastPos][1] = cache_get_field_content_float(0, "pLastPosY", ourConnection);
	PlayerInfo[playerid][pLastPos][2] = cache_get_field_content_float(0, "pLastPosZ", ourConnection);

	PlayerInfo[playerid][pLastInterior] = cache_get_field_content_int(0, "pLastInterior", ourConnection);
	PlayerInfo[playerid][pLastWorld] = cache_get_field_content_int(0, "pLastWorld", ourConnection);

	PlayerInfo[playerid][pLevel] = cache_get_field_content_int(0, "pLevel", ourConnection);
	PlayerInfo[playerid][pEXP] = cache_get_field_content_int(0, "pEXP", ourConnection);

	cache_get_field_content(0, "pAge", PlayerInfo[playerid][pAge], ourConnection, 20);

	cache_get_field_content(0, "pStory", PlayerInfo[playerid][pStory], ourConnection, 90);
	cache_get_field_content(0, "pStoryTwo", PlayerInfo[playerid][pStoryTwo], ourConnection, 90);

	PlayerInfo[playerid][pMoney] = cache_get_field_content_int(0, "pMoney", ourConnection);
	PlayerInfo[playerid][pBank] = cache_get_field_content_int(0, "pBank", ourConnection);
	PlayerInfo[playerid][pPaycheck] = cache_get_field_content_int(0, "pPaycheck", ourConnection);

	PlayerInfo[playerid][pPhone] = cache_get_field_content_int(0, "pPhone", ourConnection);

	cache_get_field_content(0, "pLastOnline", PlayerInfo[playerid][pLastOnline], ourConnection, 90);
	PlayerInfo[playerid][pLastOnlineTime] = cache_get_field_content_int(0, "pLastOnlineTime", ourConnection);

	PlayerInfo[playerid][pAdminjailed] = bool:cache_get_field_content_int(0, "pAdminjailed", ourConnection);
	PlayerInfo[playerid][pAdminjailTime] = cache_get_field_content_int(0, "pAdminjailTime", ourConnection);

	PlayerInfo[playerid][pOfflinejailed] = bool:cache_get_field_content_int(0, "pOfflinejailed", ourConnection);
	cache_get_field_content(0, "pOfflinejailedReason", PlayerInfo[playerid][pOfflinejailedReason], ourConnection, 128);

	PlayerInfo[playerid][pFaction] = cache_get_field_content_int(0, "pFaction", ourConnection);
	PlayerInfo[playerid][pFactionRank] = cache_get_field_content_int(0, "pFactionRank", ourConnection);

	PlayerInfo[playerid][pTimeplayed] = cache_get_field_content_int(0, "pTimeplayed", ourConnection);

	PlayerInfo[playerid][pMaskID][0] = cache_get_field_content_int(0, "pMaskID", ourConnection);
	PlayerInfo[playerid][pMaskID][1] = cache_get_field_content_int(0, "pMaskIDEx", ourConnection);

	PlayerInfo[playerid][pInsideProperty] = cache_get_field_content_int(0, "pInProperty", ourConnection);
	PlayerInfo[playerid][pInsideBusiness] = cache_get_field_content_int(0, "pInBusiness", ourConnection);

	PlayerInfo[playerid][pHasRadio] = bool:cache_get_field_content_int(0, "pHasRadio", ourConnection);
	PlayerInfo[playerid][pMainSlot] = cache_get_field_content_int(0, "pMainSlot", ourConnection);

	PlayerInfo[playerid][pGascan] = cache_get_field_content_int(0, "pGascan", ourConnection);

	PlayerInfo[playerid][pSpawnPoint] = cache_get_field_content_int(0, "pSpawnPoint", ourConnection);
	PlayerInfo[playerid][pSpawnPointHouse] = cache_get_field_content_int(0, "pSpawnPointHouse", ourConnection);

	PlayerInfo[playerid][pWeaponsLicense] = cache_get_field_content_int(0, "pWeaponsLicense", ourConnection);
	PlayerInfo[playerid][pDriversLicense] = cache_get_field_content_int(0, "pDriversLicense", ourConnection);
	PlayerInfo[playerid][pIsAlive] = cache_get_field_content_int(0, "pIsAlive", ourConnection);
	PlayerInfo[playerid][pJob] = cache_get_field_content_int(0, "pJob", ourConnection);
	PlayerInfo[playerid][pFishingRod] = cache_get_field_content_int(0, "pFishingRod", ourConnection);
	PlayerInfo[playerid][pWorms] = cache_get_field_content_int(0, "pWorms", ourConnection);
	PlayerInfo[playerid][pFishes] = cache_get_field_content_int(0, "pFishes", ourConnection);

	PlayerInfo[playerid][pHealth] = cache_get_field_content_float(0, "pHealth", ourConnection);
	PlayerInfo[playerid][pArmour] = cache_get_field_content_float(0, "pArmour", ourConnection);
	PlayerInfo[playerid][pActiveListings] = cache_get_field_content_int(0, "pActiveListings", ourConnection);
	PlayerInfo[playerid][pJailTimes] = cache_get_field_content_int(0, "pJailTimes", ourConnection);
	PlayerInfo[playerid][pPrisonTimes] = cache_get_field_content_int(0, "pPrisonTimes", ourConnection);
	PlayerInfo[playerid][pInJail] = cache_get_field_content_int(0, "pInJail", ourConnection);
	PlayerInfo[playerid][pJailTime] = cache_get_field_content_int(0, "pJailTime", ourConnection);
	cache_get_field_content(0, "pCharPass", PlayerInfo[playerid][pCharPass], ourConnection, 1500);
	PlayerInfo[playerid][pExplosives] = cache_get_field_content_int(0, "pExplosives", ourConnection);
	cache_get_field_content(0, "pTimeRobbed", PlayerInfo[playerid][pTimeRobbed], ourConnection, 90);
	PlayerInfo[playerid][pRobbedCash] = cache_get_field_content_int(0, "pRobbedCash", ourConnection);
	new str[128];

	for(new i = 1; i < 3; i++)
	{
		format(str, sizeof(str), "pRadio%i", i);
		PlayerInfo[playerid][pRadio][i] = cache_get_field_content_int(0, str, ourConnection);
	}

	for(new i = 0; i < 12; i++)
	{
		format(str, sizeof(str), "pWeapons%d", i);
		PlayerInfo[playerid][pWeapons][i] = cache_get_field_content_int(0, str, ourConnection);

		format(str, sizeof(str), "pWeaponsAmmo%d", i);
		PlayerInfo[playerid][pWeaponsAmmo][i] = cache_get_field_content_int(0, str, ourConnection);
	}

	for(new i = 1; i < MAX_PLAYER_VEHICLES; i++)
	{
		format(str, sizeof(str), "pOwnedVehicles%d", i);
		PlayerInfo[playerid][pOwnedVehicles][i] = cache_get_field_content_int(0, str, ourConnection);
	}

	if(!PlayerInfo[playerid][pMaskID])
	{
		PlayerInfo[playerid][pMaskID][0] = 200000+random(199991);
		PlayerInfo[playerid][pMaskID][1] = 40+random(59);
	}

	TogglePlayerSpectating(playerid, false);
	return LoadCharacter(playerid);
}

function:LoadCharacter(playerid)
{
	new
		string[128]
	;

	PlayerInfo[playerid][pLoggedin] = true;

	SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);
	SetPlayerColor(playerid, 0xFFFFFFFF);
	SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
	SetPlayerArmour(playerid, PlayerInfo[playerid][pArmour]);
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);

	SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pLastSkin], PlayerInfo[playerid][pLastPos][0], PlayerInfo[playerid][pLastPos][1], PlayerInfo[playerid][pLastPos][2], 0, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);

	format(string, sizeof(string), "~w~Welcome~n~~y~ %s", ReturnName(playerid));
	GameTextForPlayer(playerid, string, 1000, 1);

	if (PlayerInfo[playerid][pAdmin])
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "SERVER: You logged in as a level %i admin.", PlayerInfo[playerid][pAdmin]);

		if(!strcmp(e_pAccountData[playerid][mForumName], "Null"))
		{
			ShowPlayerDialog(playerid, 99, DIALOG_STYLE_MSGBOX, "Notification", "This message notifies all admins on login if their forum name hasn't been set.\nYour forum name is NULL and requires a change.\n\n{F81414}Please ensure it's changed ASAP using /forumname.", "Understood", "");
		}
	}
	SetPlayerSkin(playerid, PlayerInfo[playerid][pLastSkin]);
	SetPlayerPos(playerid, PlayerInfo[playerid][pLastPos][0], PlayerInfo[playerid][pLastPos][1], PlayerInfo[playerid][pLastPos][2]);

	if(PlayerInfo[playerid][pOfflinejailed])
	{
		if(strlen(PlayerInfo[playerid][pOfflinejailedReason]) > 56)
		{
			SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s was admin jailed by % for %d minutes, Reason: %.56s", ReturnName(playerid), PlayerInfo[playerid][pAdminjailTime] / 60, PlayerInfo[playerid][pOfflinejailedReason]);
			SendClientMessageToAllEx(COLOR_RED, "AdmCmd: ...%s", PlayerInfo[playerid][pOfflinejailedReason][56]);
		}
		else SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s was admin jailed by %s for %d minutes, Reason: %s", ReturnName(playerid), PlayerInfo[playerid][pAdminjailTime] / 60, PlayerInfo[playerid][pOfflinejailedReason]);

		ClearAnimations(playerid);

		SetPlayerPos(playerid, 2687.3630, 2705.2537, 22.9472);
		SetPlayerInterior(playerid, 0); SetPlayerVirtualWorld(playerid, 1338);

		PlayerInfo[playerid][pOfflinejailed] = false;
		PlayerInfo[playerid][pAdminjailed] = true;
	}

//	format(PlayerInfo[playerid][pActiveIP], 60, "%s", ReturnIP(playerid));
	if(PlayerInfo[playerid][pHealth] > 100)
	{
 	SetPlayerHealth(playerid, 100);
 	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if (e_pAccountData[playerid][mLoggedin] == false)
	{
		TogglePlayerSpectating(playerid, true);
		return 0;
	}
	else if(e_pAccountData[playerid][mLoggedin] == true)
	{
		SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pLastSkin], PlayerInfo[playerid][pLastPos][0], PlayerInfo[playerid][pLastPos][1], PlayerInfo[playerid][pLastPos][2], 0, 0, 0, 0, 0, 0, 0);
		SpawnPlayer(playerid);
		return 0;
	}
	else return 0;
}

function:KickTimer(playerid) { return Kick(playerid); }

function:ResetPlayer(playerid)
{
	//Master accounts:
	e_pAccountData[playerid][mDBID] = 0;
	e_pAccountData[playerid][mLoggedin] = false;

	playerLogin[playerid] = 0;
	playerMakingCharacter[playerid] = false;
	playerCharacterStep[playerid] = 0;

	for(new i = 0; i < 2 ; i++)
	{
		format(playerCharacterStory[playerid][i], 90, "");
	}

	//Prevents;
	loginTime[playerid] = 0;
	registerTime[playerid] = 0;
	characterPickTime[playerid] = 0;

	ResetDealershipVars(playerid);
	ClearDamages(playerid);

	playerPhone[playerid] = 0;

	for(new i = 0; i < 5; i++) PlayerPlateSaver[playerid][i] = "";
	PlayerMDCName[playerid] = "";

	//Player characters:
	PlayerInfo[playerid][pDBID] = 0;
	PlayerInfo[playerid][pLoggedin] = false;

	PlayerInfo[playerid][pAdmin] = 0;
	PlayerInfo[playerid][pAdminDuty] = false;
	PlayerInfo[playerid][pLastSkin] = 20003;

	PlayerInfo[playerid][pLastPos][0] = 1642.02;
	PlayerInfo[playerid][pLastPos][1] = -2334.05;
	PlayerInfo[playerid][pLastPos][2] = 13.5469;

	PlayerInfo[playerid][pLastInterior] = 0;
	PlayerInfo[playerid][pLastWorld] = 0;

	PlayerInfo[playerid][pLevel] = 1;
	PlayerInfo[playerid][pAge] = 20;

	PlayerInfo[playerid][pMoney] = 5000;
	PlayerInfo[playerid][pBank] = 15000;
	PlayerInfo[playerid][pPaycheck] = 5000;

	PlayerInfo[playerid][pPhone] = 94000+random(6999);
	PlayerInfo[playerid][pPhoneOff] = false;
	PlayerInfo[playerid][pPhonespeaker] = false;

	PlayerInfo[playerid][pCalling] = 0;
	PlayerInfo[playerid][pPhoneline] = INVALID_PLAYER_ID;

	PlayerInfo[playerid][pMuted] = false;

	PlayerInfo[playerid][pSpectating] = INVALID_PLAYER_ID;

	PlayerInfo[playerid][pFaction] = 0;
	PlayerInfo[playerid][pFactionRank] = 0;
	PlayerInfo[playerid][pFactionInvite] = 0;
	PlayerInfo[playerid][pFactionInvitedBy] = INVALID_PLAYER_ID;

	for(new i = 1; i < MAX_PLAYER_VEHICLES; i++) {
		PlayerInfo[playerid][pOwnedVehicles][i] = 0;
	}

	PlayerInfo[playerid][pDuplicateKey] = INVALID_VEHICLE_ID;

	PlayerInfo[playerid][pWeaponsSpawned] = false;

	for(new i = 0; i < 12; i++){
		PlayerInfo[playerid][pWeapons][i] = 0;
		PlayerInfo[playerid][pWeaponsAmmo][i] = 0;
	}

	PlayerInfo[playerid][pUnscrambling] = false;
	PlayerInfo[playerid][pUnscramblerTime] = 0;
	PlayerInfo[playerid][pScrambleFailed] = 0;
	PlayerInfo[playerid][pScrambleSuccess] = 0;
	PlayerInfo[playerid][pUnscrambleID] = 0;

	PlayerInfo[playerid][pPoliceDuty] = false;
	PlayerInfo[playerid][pMedicDuty] = false;

	PlayerInfo[playerid][pTimeplayed] = 0;

	PlayerInfo[playerid][pInsideProperty] = 0;
	PlayerInfo[playerid][pInsideBusiness] = 0;
	PlayerInfo[playerid][pAtDealership] = 0;

	PlayerInfo[playerid][pMaskID][0] = 200000+random(199991);
	PlayerInfo[playerid][pMaskID][1] = 40+random(59);
	PlayerInfo[playerid][pMasked] = false;
	PlayerInfo[playerid][pHasMask] = false;

	PlayerInfo[playerid][pOfflinejailed] = false;

	PlayerInfo[playerid][pLastDamagetime] = 0;

	PlayerInfo[playerid][pRelogCount] = 0;
	PlayerInfo[playerid][pRelogging] = false;

	PlayerInfo[playerid][pAddObject] = INVALID_OBJECT_ID;
	PlayerInfo[playerid][pEditingObject] = 0;

	PlayerInfo[playerid][pHasRadio] = false;
	PlayerInfo[playerid][pMainSlot] = 1;

	for(new i = 1; i < 3; i++){
		PlayerInfo[playerid][pRadio][i] = 0;
	}

	PlayerInfo[playerid][pRespawnTime] = 0;

	PlayerInfo[playerid][pSpawnPoint] = 0;
	PlayerInfo[playerid][pSpawnPointHouse] = 0;

	PlayerInfo[playerid][pTaser] = false;

	PlayerInfo[playerid][pWeaponsLicense] = 0;
	PlayerInfo[playerid][pDriversLicense] = 0;
	PlayerInfo[playerid][pIsAlive] = 1;
	PlayerInfo[playerid][pJob] = 0;
	PlayerInfo[playerid][pFishingRod] = 0;
	PlayerInfo[playerid][pWorms] = 0;
	PlayerInfo[playerid][pFishes] = 0;

	PlayerInfo[playerid][pHealth] = 100;
	PlayerInfo[playerid][pArmour] = 0;
	PlayerInfo[playerid][pActiveListings] = 0;
	PlayerInfo[playerid][pJailTimes] = 0;
	PlayerInfo[playerid][pPrisonTimes] = 0;
	PlayerInfo[playerid][pInJail] = 0;
	PlayerInfo[playerid][pJailTime] = 0;
	PlayerInfo[playerid][pExplosives] = 0;
	PlayerInfo[playerid][pRobbedCash] = 0;
	PlayerInfo[playerid][pTimeRobbed] = 0;
	return 1;
}

function:FunctionPlayers()
{
	foreach (new i : Player)
	{
		if(GetTickCount() > (PlayerInfo[i][pPauseCheck]+2000))
			PlayerInfo[i][pPauseTime] ++;

		else PlayerInfo[i][pPauseTime] = 0;

		if(e_pAccountData[i][mLoggedin] == false)
		{
			if(loginTime[i] > 0)
			{
				loginTime[i]++;

				if(loginTime[i] >= 500)
				{
					SendServerMessage(i, "You were kicked for not logging in.");
					KickEx(i);
				}
			}

			if(registerTime[i] > 0)
			{
				registerTime[i]++;

				if(registerTime[i] >= 500)
				{
					SendServerMessage(i, "You were kicked for not registering.");
					KickEx(i);
				}
			}
		}

		if(characterPickTime[i] > 0)
		{
			characterPickTime[i]++;

			if(characterPickTime[i] >= 500)
			{
				SendServerMessage(i, "You were kicked for not selecting a character.");
				KickEx(i);
			}
		}

		if (PlayerInfo[i][pAdminjailed] == true)
		{
			PlayerInfo[i][pAdminjailTime]--;

			if(PlayerInfo[i][pAdminjailTime] < 1)
			{
				PlayerInfo[i][pAdminjailed] = false;
				PlayerInfo[i][pAdminjailTime] = 0;

				SendServerMessage(i, "You served your admin jail time.");

				new str[128];
				format(str, sizeof(str), "%s was released from admin jail.", ReturnName(i));
				SendAdminMessage(1, str);

				SetPlayerVirtualWorld(i, 0); SetPlayerInterior(i, 0);
				SetPlayerPos(i, -2614.5542, 2270.2622, 8.1);
			}
		}

		if(PlayerInfo[i][pDeathFix])
		{
			PlayerInfo[i][pDeathFix]++;
			if(PlayerInfo[i][pDeathFix] == 5)
			{
				PlayerInfo[i][pDeathFix] = 0;
			}
		}

		if(PlayerTakingLicense[i] && PlayerLicenseTime[i] <= 400)
		{
			PlayerLicenseTime[i]--;

			new
				str[128]
			;

			format(str, sizeof(str), "~w~%d", PlayerLicenseTime[i]);
			GameTextForPlayer(i, str, 2000, 3);

			if(PlayerLicenseTime[i] < 1)
			{
				StopDriverstest(i);
				SendClientMessage(i, COLOR_DARKGREEN, "You took too long and failed.");
			}
		}
	}
	return 1;
}

function:OnWeaponsUpdate()
{
	foreach(new i : Player)
	{
		if(e_pAccountData[i][mLoggedin] == false)
			continue;

		if(!PlayerHasWeapons(i))
			continue;

		for (new w = 0; w < 12; w++)
		{
			new idx = WeaponDataSlot(PlayerInfo[i][pWeapons][w]);

			if(PlayerInfo[i][pWeapons][w] != 0 && PlayerInfo[i][pWeaponsAmmo][w] > 0)
			{
				GetPlayerWeaponData(i, idx, PlayerInfo[i][pWeapons][w], PlayerInfo[i][pWeaponsAmmo][w]);
			}

			if(PlayerInfo[i][pWeapons][w] != 0 && PlayerInfo[i][pWeaponsAmmo][w] == 0)
			{
				PlayerInfo[i][pWeapons][w] = 0;
				//Removing 0 ammo weapons;
			}
		}

		return 1;
	}
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	new
		Float: vehicle_health
	;

	GetVehicleHealth(vehicleid, vehicle_health);
	printf("[DEBUG] Vehicle ID: %i (%s) (Health: %.2f) destroyed by %s", ReturnVehicleName(vehicleid), vehicle_health, ReturnName(killerid));

	if(VehicleInfo[vehicleid][eVehicleFaction])
		SetVehicleToRespawn(vehicleid);

	else
	{
		foreach(new i : Player) if(PlayerInfo[i][pDBID] == VehicleInfo[i][eVehicleOwnerDBID])
		{
			SendClientMessageEx(i, COLOR_RED, "Your %s was destroyed.", ReturnVehicleName(vehicleid));
		}
	}
    SetVehicleToRespawn(vehicleid);
   	DestroyObject(obj[vehicleid]);
    DestroyObject(obj2[vehicleid]);
    Flasher[vehicleid] = 0;
	return 1;
}

function:OnVehicleUpdate()
{
	new
		Float:vehicle_health
	;
	for (new i = 1, j = GetVehiclePoolSize(); i <= j; i++)
{
    GetVehicleHealth(i, vehicle_health);

    if(vehicle_health <= 300)
    {
        SetVehicleHealth(i, 300);
        ToggleVehicleEngine(i, false); VehicleInfo[i][eVehicleEngineStatus] = false;
    }
    if(VehicleInfo[i][eVehicleFuel] <= 0)
    {
        ToggleVehicleEngine(i, false); VehicleInfo[i][eVehicleEngineStatus] = false;
    }

    for (new q = 0; q < sizeof dmv_vehicles; q++)
    {
        if(i == dmv_vehicles[q])
        {
            if(vehicle_health <= 850)
            {
                new playerid = CheckDriver(i);
                StopDriverstest(playerid);
                SCM(playerid, -1, "You're too reckless! You failed your driversexam.");
            }

            break;
        }
    }
}
	return 1;
}

function:FunctionPaychecks()
{
	new
		hour,
		minute,
		seconds
	;

	gettime(hour, minute, seconds);

	if(minute == 00 && seconds == 59)
	{
		CallPaycheck();
		SetWorldTime(hour + 1);
	}

	return 1;
}

function:CallPaycheck()
{
	foreach(new i : Player)
	{
		if(!PlayerInfo[i][pLoggedin])
			continue;

		new
			str[128],
			total_paycheck = 0
		;

		new
			Float: interest,
			interest_convert,
			total_tax
		;

		PlayerInfo[i][pTimeplayed]++;
		PlayerInfo[i][pEXP]++;

		if(PlayerInfo[i][pLevel] == 1)
			total_paycheck+= 2000;

		else if(PlayerInfo[i][pLevel] == 2)
			total_paycheck+= 1500;

		//Add an auto-level up on paycheck for level 1 and 2 to prevent paycheck farming.

		interest = (PlayerInfo[i][pBank] / 100) * 0.1;
		interest_convert = floatround(interest, floatround_round);

		total_tax = total_paycheck / 10;

		SendClientMessageEx(i, COLOR_WHITE, "SERVER TIME:[ %s ]", ReturnHour());

		SendClientMessage(i, COLOR_WHITE, "|___ BANK STATEMENT ___|");
		SendClientMessageEx(i, COLOR_GREY, "   Balance: $%s", MoneyFormat(PlayerInfo[i][pBank]));
		SendClientMessage(i, COLOR_GREY, "   Interest rate: 0.1");
		SendClientMessageEx(i, COLOR_GREY, "   Interest Gained: $%s", MoneyFormat(interest_convert));
		SendClientMessageEx(i, COLOR_GREY, "   Tax paid: $%s", MoneyFormat(total_tax));
		SendClientMessage(i, COLOR_WHITE, "|________________________|");

		PlayerInfo[i][pPaycheck]+= total_paycheck;
		PlayerInfo[i][pBank]+= interest_convert;
		PlayerInfo[i][pBank]-= total_tax;

		SendClientMessageEx(i, COLOR_WHITE, "   New Balance: $%s", MoneyFormat(PlayerInfo[i][pBank]));

		if(PlayerInfo[i][pLevel] == 1)
			SendClientMessage(i, COLOR_WHITE, "(( You have received $2,000 for being level 1. ))");

		else if(PlayerInfo[i][pLevel] == 2)
			SendClientMessage(i, COLOR_WHITE, "(( You have received $1,500 for being level 2. ))");

		format(str, sizeof(str), "~y~Payday~n~~w~Paycheck~n~~g~$%d", total_paycheck);
		GameTextForPlayer(i, str, 3000, 1);

		SaveCharacter(i);
	}
	return 1;
}

function:OnPlayerNearBusiness()
{
	foreach(new i : Player)
	{
		if(PlayerInfo[i][pLoggedin] == false)
			continue;

		new
			id,
			str[128]
		;

		if((id = IsPlayerNearBusiness(i)) != 0)
		{
			if(!BusinessInfo[id][eBusinessOwnerDBID])
			{
				if(BusinessInfo[id][eBusinessType] > 5)
					format(str, sizeof(str), "%s~n~~w~Entrance Fee : ~g~$%d~n~~p~To use /enter", BusinessInfo[id][eBusinessName], BusinessInfo[id][eBusinessEntranceFee]);

				else format(str, sizeof(str), "%s~n~~w~This business is for sale~n~Price : ~g~$%d~w~ Level : %d~n~~p~To buy use /buybiz", BusinessInfo[id][eBusinessName], BusinessInfo[id][eBusinessMarketPrice], BusinessInfo[id][eBusinessLevel]);
			}
			if(BusinessInfo[id][eBusinessType] == 6)
				format(str, sizeof(str), "%s~n~~w~Entrance Fee : ~g~$%d~n~~p~To use /buyvehicle", BusinessInfo[id][eBusinessName], BusinessInfo[id][eBusinessEntranceFee]);

			else format(str, sizeof(str), "%s~n~~w~Owned By : %s~n~Entrance Fee : ~g~$%d~n~~p~To use /enter", BusinessInfo[id][eBusinessName], ReturnDBIDName(BusinessInfo[id][eBusinessOwnerDBID]), BusinessInfo[id][eBusinessEntranceFee]);

			GameTextForPlayer(i, str, 3500, 3);
		}
	}
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if(issuerid != INVALID_PLAYER_ID)
	{
	new
	Float:playerHealth, Float:playerArmor, Float:amoun
	;

	PlayerInfo[playerid][pLastDamagetime] = gettime();
	GetPlayerHealth(playerid, playerHealth);
	GetPlayerArmour(playerid, playerArmor);

	if(GetPlayerTeam(playerid) == PLAYER_STATE_ALIVE)
	{
    	if(playerArmor > 0) // if their armor is greater than 0
    	{
        	amoun = playerArmor - amount; // player's armor - amount of damage taken

        	if(amoun <= 0) // if armor - amount taken is less than or equal to 0
            SetPlayerHealth(playerid, playerHealth - amount); // health is set

        	else
        	{
            	if(bodypart != BODY_PART_HEAD && bodypart != BODY_PART_RIGHT_LEG && bodypart != BODY_PART_LEFT_LEG)
                SetPlayerArmour(playerid, amoun); // if the bodypart doesn't equal head, left/right leg, we'll set their armor down

            	else SetPlayerHealth(playerid, playerHealth - amount); // else their armor is taken down
        	}
    	}
    	else SetPlayerHealth(playerid, playerHealth - amount);
	}
	}
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(hittype == BULLET_HIT_TYPE_PLAYER) //Death system;
	{
		if(GetPlayerTeam(hitid) == PLAYER_STATE_WOUNDED && !PlayerInfo[hitid][pDeathFix])
		{
			CallLocalFunction("OnPlayerDead", "iii", hitid, playerid, weaponid);
			return 0;
		}
		else if(GetPlayerTeam(hitid) != PLAYER_STATE_ALIVE)
			return 0;

	}

	if(PlayerInfo[playerid][pTaser] && weaponid == 23)
	{
		SetPlayerArmedWeapon(playerid, 0);

		ApplyAnimation(playerid, "SILENCED", "Silence_reload", 4.1, 0, 1, 1, 1, 1, 1);
		ApplyAnimation(playerid, "SILENCED", "Silence_reload", 4.1, 0, 1, 1, 1, 1, 1);

		SetTimerEx("OnTaserShoot", 1100, false, "i", playerid);
	}

	if(hittype == BULLET_HIT_TYPE_PLAYER) //Taser system;
	{
		if(PlayerInfo[playerid][pTaser] && weaponid == 23)
		{
			if(!IsPlayerNearPlayer(playerid, hitid, 15.0))
			{
				SendClientMessageEx(playerid, COLOR_YELLOWEX, "-> You aren't close enough to hit %s with your taser.", ReturnName(hitid, 0));
				return 0;
			}

			SetPlayerDrunkLevel(hitid, 4000);
			TogglePlayerControllable(playerid, 1);

			SendNearbyMessage(hitid, 20.0, COLOR_EMOTE, "* %s falls on the ground after being hit by %s's taser.", ReturnName(hitid, 0), ReturnName(playerid, 0));
			GameTextForPlayer(hitid, "~b~You Are Tasered", 2500, 3);

			SendClientMessage(hitid, COLOR_YELLOWEX, "-> You were just hit by a taser. 10,000 volts go through your body.");
			SendClientMessageEx(playerid, COLOR_YELLOWEX, "-> You hit %s with your taser!", ReturnName(hitid, 0));

			ClearAnimations(playerid, 1);
			SetTimerEx("OnPlayerTasered", 1200, false, "i", hitid);
			return 0;
		}
	}
	
	return 1;
}

public OnPlayerSpawn(playerid)
{
	StopAudioStreamForPlayer(playerid);
    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
	AddPlayerClass(0,0,0,0,0,0,0,0,0,0,0);
	Streamer_Update(playerid);
	SetPlayerTeam(playerid, PLAYER_STATE_ALIVE);
	SetPlayerWeather(playerid, globalWeather);
	if(PlayerInfo[playerid][pAdminjailed] == true)
	{
		ClearAnimations(playerid);

		SetPlayerPos(playerid, 2687.3630, 2705.2537, 22.9472);
		SetPlayerInterior(playerid, 0); SetPlayerVirtualWorld(playerid, 1338);

		SendServerMessage(playerid, "You're currently admin jailed. You have %i minutes left.", PlayerInfo[playerid][pAdminjailTime] / 60);
	}
	if(!strcmp(PlayerInfo[playerid][pCharPass], "Null"))
	{
		ShowPlayerDialog(playerid,DIALOG_LOGINUCP, DIALOG_STYLE_PASSWORD, "UCP password", "It looks like this character does not have a registred password for our UCP\nPlease enter the password you'd like to use:", "Register", "Cancel");
	}
	if(PlayerInfo[playerid][pInJail] == 1)
	{
		ClearAnimations(playerid);
        TogglePlayerControllable(playerid, 0);
        SetTimerEx("Freeze", 1000, false, "i", playerid);
		SetPlayerInterior(playerid, 6);
	 	SetPlayerVirtualWorld(playerid, 10);
	  	SetPlayerFacingAngle(playerid, 360.0);
	   	SetPlayerPos(playerid, 264.5485,77.8464,1001.3657);
	    SetPlayerHealth(playerid, 9999999999.0);
	    ResetPlayerWeapons(playerid);
	    SetPlayerWantedLevel(playerid,0);
	}
	else
	{
		if(PlayerInfo[playerid][pWeaponsSpawned] == false)
		{
			for(new i = 0; i < 12; i ++)
			{
				if(PlayerInfo[playerid][pWeapons][i] != 0)
				{
					GivePlayerGun(playerid, PlayerInfo[playerid][pWeapons][i], PlayerInfo[playerid][pWeaponsAmmo][i]);
				}
			}

			SetPlayerArmedWeapon(playerid, 0);
			PlayerInfo[playerid][pWeaponsSpawned] = true;
		}
		if(PlayerInfo[playerid][pIsAlive] == 0)
		{
		    GivePlayerMoney(playerid, 100);
			SetPlayerPos(playerid, Deadx[playerid], Deady[playerid], Deadz[playerid]);
			SetPlayerInterior(playerid, deadint[playerid]);
			SetPlayerVirtualWorld(playerid, deadvw[playerid]);
			SCM(playerid, COLOR_LIGHTRED, "You're currently wounded. If no-one helps you, you will die.");
			SetTimerEx("LoadDeathAnim", 1000, false, "i", playerid);
			Deadtimer[playerid] = SetTimerEx("deadtimer",2000,1,"i",playerid);
			SetPlayerArmedWeapon(playerid,0);
			return 1;
		}
		if(isDead[playerid] == true)
		{
		    GivePlayerMoney(playerid, 100);
			SCM(playerid, COLOR_LIGHTRED, "You have been rushed to the hospital and are undergoing an operation.");
			SetPlayerPos(playerid, -2499.1338, 2366.9407, 5.0282);
  			KillTimer(Deadtimer[playerid]);
  			SetPlayerVirtualWorld(playerid, 6);
			SetPlayerCameraPos(playerid, -2447.5227, 2309.7695, 29.6994);
			SetPlayerCameraLookAt(playerid, -2448.2188, 2310.5005, 29.3393);
			HospTimer[playerid] = SetTimerEx("hospitaltimer", 15000, false, "i", playerid);
			ClearAnimations(playerid);
			return 1;
		}
		if(PlayerInfo[playerid][pSpectating] != INVALID_PLAYER_ID)
		{
			SetPlayerPos(playerid, PlayerInfo[playerid][pLastPos][0], PlayerInfo[playerid][pLastPos][1], PlayerInfo[playerid][pLastPos][2]);
			PlayerInfo[playerid][pSpectating] = INVALID_PLAYER_ID;
		}
		else SetPlayersSpawn(playerid);
		}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(killerid != INVALID_PLAYER_ID)
		SendAdminMessageEx(COLOR_RED, 4, "[DEBUG DEBUG] %s was killed by %s. (%s)", ReturnName(playerid), ReturnName(killerid), ReturnWeaponName(reason));

	if(PlayerInfo[playerid][pIsAlive] == 1)
    {
   		PlayerInfo[playerid][pIsAlive] = 0;
	}
	else if(PlayerInfo[playerid][pIsAlive] == 0)
	{
     	PlayerInfo[playerid][pIsAlive] = 1;
     	isDead[playerid] = true;
	}
	GetPlayerPos(playerid, Deadx[playerid], Deady[playerid], Deadz[playerid]);
	printf("Callback OnPlayerDeath called for player %s (ID: %i)", ReturnName(playerid), playerid);
	if(GetPVarInt(playerid, "pSafeID") != -1)
		{
			new sid = GetPVarInt(playerid, "pSafeID");
			KillTimer(xSafe[sid][safe_Timer]);
			new str[128];
			PlayerTextDrawSetString(playerid, xRob_TD[playerid][2], "~r~~h~Safe can't be robbed!");
			PlayerTextDrawShow(playerid, xRob_TD[playerid][2]);
			format(str, sizeof(str), "~g~~h~Robbery has been cancelled because of you died!~n~~y~~h~Stolen money: ~g~$%d", GetPVarInt(playerid, "robbedMoney"));
			PlayerTextDrawSetString(playerid, xRob_TD[playerid][6], str);
			PlayerTextDrawShow(playerid, xRob_TD[playerid][6]);
			PlayerTextDrawHide(playerid, xRob_TD[playerid][7]);
			GivePlayerMoney(playerid, GetPVarInt(playerid, "robbedMoney"));
			xSafe[sid][safe_Timer] = SetTimerEx("safeCooldown", 3000, false, "ud", playerid, sid);
			SetPVarInt(playerid, "pSafeID", -1);
			DeletePVar(playerid, "rob_Money");
			DeletePVar(playerid, "robbedMoney");
			ClearAnimations(playerid);
			TogglePlayerControllable(playerid, 1);
		}
	return 1;
}
public OnPlayerText(playerid, text[])
{
	if(PlayerInfo[playerid][pSpectating] != INVALID_PLAYER_ID)
	{
		SendServerMessage(playerid, "You can't type while you're spectating.");
		return 0;
	}
/*
	if(PlayerInfo[playerid][pLoggedin] && GetPlayerTeam(playerid) != PLAYER_STATE_ALIVE)
	{
		SendServerMessage(playerid, "You can't talk when you aren't alive.");
		return 0;
	}
*/
	if(PlayerInfo[playerid][pRelogging])
	{
		SendServerMessage(playerid, "You can't talk when relogging.");
		return 0;
	}

	if (playerMakingCharacter[playerid] == true)
	{
		switch (playerCharacterStep[playerid])
		{
			case 1:
			{
				if(strlen(text) > MAX_PLAYER_NAME + 1 || strlen(text) < 3)
				{
					SendErrorMessage(playerid, "Your characters name must be at least 3 characters and no more than "#MAX_PLAYER_NAME" characters.");
					return 0;
				}

				if(!IsValidRoleplayName(text))
				{
					SendErrorMessage(playerid, "Please follow the Firstname_Lastname format to make your character.");
					return 0;
				}

				foreach (new i : Player)
				{
					if(!strcmp(text, ReturnName(i)))
					{
						SendErrorMessage(playerid, "That character already exists. Please try again.");
						return 0;
					}
				}

				new
					threadSearch[128]
				;

				format(playerCharactersName[playerid], 128, "%s", text);

				mysql_format(ourConnection, threadSearch, sizeof(threadSearch), "SELECT char_dbid FROM characters WHERE char_name = '%e'", text);
				mysql_tquery(ourConnection, threadSearch, "Query_CreateCharacter", "i", playerid);

				return 0;
			}
			case 2:
			{
				if(strlen(text) > 10)
				{
					SendErrorMessage(playerid, "Please follow the correct date format: 08/12/2017");
					return 0;
				}

				new bool:keyFound = false;

				for(new i = 0; i < strlen(text); i++)
				{
					if(text[2] == '/' && text[5] == '/')
						continue;

					if(text[i] < '0' || text[i] > '9')
						keyFound = true;
				}

				if(keyFound)
				{
					SendErrorMessage(playerid, "Please follow the correct date format: 08/12/2017");
					return 0;
				}

				format(playerCharactersAge[playerid], 20, "%s", text);
				playerCharacterStep[playerid] = 3;

				for (new i = 0; i < 16; i++){SendClientMessage(playerid, -1, " "); }

				new
					string[128]
				;

				format (string, sizeof(string), "Your new characters date of birth will be: {145F0B}%s", playerCharactersAge[playerid]);
				SendClientMessage(playerid, -1, string);

				SendClientMessage(playerid, -1, " ");
				SendClientMessage(playerid, -1, "This next step will require your characters origin details. ");
				SendClientMessage(playerid, -1, "Please provide your characters origin. Example: {145F0B}United States of America");

				return 0;
			}
			case 3:
			{
				if(strlen(text) < 3)
				{
					SendErrorMessage(playerid, "Your characters origin must be longer than 3 characters.");
					return 0;
				}

				format(playerCharacterOrigin[playerid], 60, "%s", text);
				playerCharacterStep[playerid] = 4;

				new
					string[128]
				;

				for (new i = 0; i < 16; i++){SendClientMessage(playerid, -1, " "); }

				format (string, sizeof(string), "Your new characters origin will be: {145F0B}%s", playerCharacterOrigin[playerid]);
				SendClientMessage(playerid, -1, string);

				SendClientMessage(playerid, -1, " ");
				SendClientMessage(playerid, -1, "This next step will allow you the opportunity of writing a background story.");
				SendClientMessage(playerid, -1, "In no more than three (3) paragraphs, introduce your characters story.");
				SendClientMessage(playerid, -1, "This step is {145F0B}optional{FFFFFF} and not required. Type {145F0B}\"skip\" {FFFFFF}to continue.");

				ClearLines(playerid, 2);

				return 0;
			}
			case 4:
			{
				if(!strcmp(text, "skip"))
				{
					ClearLines(playerid, 3);
					playerCharacterStep[playerid] = 5;

					SendClientMessage(playerid, -1, "You have chosen to skip your characters background story.");
					SendClientMessage(playerid, -1, "This concludes your characters creation.");

					ClearLines(playerid, 1);

					new
						string[128]
					;

					format(string, sizeof(string), "Your new characters name is: {145F0B}%s", playerCharactersName[playerid]);
					SendClientMessage(playerid, -1, string);

					format(string, sizeof(string), "Your characters date of birth: {145F0B}%s", playerCharactersAge[playerid]);
					SendClientMessage(playerid, -1, string);

					format(string, sizeof(string), "Your characters origin: {145F0B}%s", playerCharacterOrigin[playerid]);
					SendClientMessage(playerid, -1, string);

					ClearLines(playerid, 2);

					SendClientMessage(playerid, -1, "To finish, either type {145F0B}\"done\" {FFFFFF}or {145F0B}\"cancel\"{FFFFFF}.");
					return 0;
				}

				new string[128], bool:foundSpace = false, idx = 0;

				for (new i = 0; i < 2; i ++)
				{
					if(isnull(playerCharacterStory[playerid][i]))
					{
						foundSpace = true;
						idx = i;
						break;
					}
				}

				if (foundSpace)
				{
					SendClientMessage(playerid, COLOR_YELLOW, "[Background Story]");
					format(playerCharacterStory[playerid][idx], 90, "%s", text);
					SendClientMessage(playerid, -1, playerCharacterStory[playerid][idx]);
				}
				else
				{
					ClearLines(playerid, 2);
					SendClientMessage(playerid, -1, "You have exceeded the amount of space provided for your background story.");
					SendClientMessage(playerid, -1, "This concludes your characters creation.");

					SendClientMessage(playerid, -1, " ");

					format(string, sizeof(string), "Your new characters name is: {145F0B}%s", playerCharactersName[playerid]);
					SendClientMessage(playerid, -1, string);

					format(string, sizeof(string), "Your characters date of birth: {145F0B}%s", playerCharactersAge[playerid]);
					SendClientMessage(playerid, -1, string);

					format(string, sizeof(string), "Your characters origin: {145F0B}%s", playerCharacterOrigin[playerid]);
					SendClientMessage(playerid, -1, string);

					ClearLines(playerid, 2);

					SendClientMessage(playerid, -1, "To finish, either type {145F0B}\"done\" {FFFFFF}or {145F0B}\"cancel\"{FFFFFF}.");
					playerCharacterStep[playerid] = 5;
				}
				return 0;
			}
			case 5:
			{
				if(!strcmp(text, "done"))
				{
					ClearLines(playerid, 17);

					SendClientMessage(playerid, COLOR_YELLOW, "You successfully created a new character. Please wait while your list is rebuilt.");

					new
						query[355]
					;

					mysql_format(ourConnection, query, sizeof(query), "INSERT INTO characters (`master_dbid`, `char_name`, `pAge`, `pOrigin`, `pStory`, `pStoryTwo`, `create_date`, `create_ip`, `pPhone`) VALUES(%i, '%e', '%e', '%e', '%e', '%e', '%e', '%e', %i)", e_pAccountData[playerid][mDBID], playerCharactersName[playerid], playerCharactersAge[playerid],
						playerCharacterOrigin[playerid], playerCharacterStory[playerid][0], playerCharacterStory[playerid][1], ReturnDate(), ReturnIP(playerid), 94000+random(6999));

					mysql_tquery(ourConnection, query);

					SetTimerEx("RefreshCharacters", 3000, false, "i", playerid);
					return 0;

				}
				else if(!strcmp(text, "cancel"))
				{
					ClearLines(playerid, 16);

					SendClientMessage(playerid, -1, "You cancelled your character creation. You'll return to the character menu:");

					new fetchChars[128];

					mysql_format(ourConnection, fetchChars, sizeof(fetchChars), "SELECT char_name, char_dbid FROM characters WHERE master_dbid = %i LIMIT 4", e_pAccountData[playerid][mDBID]);
					mysql_pquery(ourConnection, fetchChars, "DB_ListCharacters", "i", playerid);

					return 0;
				}
				else
				{
					SendClientMessage(playerid, -1, "To finish, either type {145F0B}\"done\" {FFFFFF}or {145F0B}\"cancel\"{FFFFFF}.");
					return 0;
				}
			}
		}
		return 0;
	}

	if(!playerMakingCharacter[playerid] && !e_pAccountData[playerid][mLoggedin] && !PlayerInfo[playerid][pLoggedin])
	{
		SendServerMessage(playerid, "You can't type during login.");
		return 0;
	}

	new
		string[128];

	if(PlayerInfo[playerid][pPhoneline] != INVALID_PLAYER_ID && !PlayerInfo[playerid][pCalling])
	{
	    if(PlayerInfo[playerid][pPhoneline] == 686) // Taxi
	    {
			if(strlen(text) < 3)
			return SendErrorMessage(playerid, "Please input actual text.");

			format(Player911Text[playerid][2], 128, "%s", text);
			SendClientMessage(playerid, COLOR_YELLOWEX, "Operator says: We've contacted all of the Taxi Staff, please be patient for one of them to arrive.");

			SendTaxiMessage(playerid);
		}
  		if(PlayerInfo[playerid][pPhoneline] == 457) // Tow
	    {
			if(strlen(text) < 3)
			return SendErrorMessage(playerid, "Please input actual text.");

			format(Player911Text[playerid][2], 128, "%s", text);
			SendClientMessage(playerid, COLOR_YELLOWEX, "Operator says: We've contacted all of the Mechanics, please be patient for one of them to arrive.");

			SendTowMessage(playerid);
		}
		if(PlayerInfo[playerid][pPhoneline] == 911)
		{
			format(string, sizeof(string), "%s says (phone): %s", ReturnName(playerid, 0), text);
			LocalChat(playerid, 20.0, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4);

			switch(Player911Type[playerid])
			{
				case 0: // 0 service, 1 - emergency, 2 - location
				{
					if(strfind(text, "Police", true) != -1 || strfind(text, "Cops", true) != -1 || strfind(text, "Law enforcement", true) != -1)
					{
						format(Player911Text[playerid][0], 128, "%s", text);

						SendClientMessage(playerid, COLOR_YELLOWEX, "911 Operator says: You're being transferred to the police. What's your emergency?");
						Player911Type[playerid] = 1;
					}
					else if(strfind(text, "Medics", true) != -1 || strfind(text, "Paramedics", true) != -1 || strfind(text, "Ambulance", true) != -1 || strfind(text, "Fire", true) != -1)
					{
						format(Player911Text[playerid][0], 128, "%s", text);

						SendClientMessage(playerid, COLOR_YELLOWEX, "911 Operator says: You're being transferred to the fire department. What's your emergency?");
						Player911Type[playerid] = 2;
					}
					else SendClientMessage(playerid, COLOR_YELLOWEX, "911 Operator says: Repeat that, please.");
				}
				case 1: //Police input;
				{
					if(strlen(text) < 3)
						return SendErrorMessage(playerid, "Please input actual text.");

					format(Player911Text[playerid][1], 128, "%s", text);

					SendClientMessage(playerid, COLOR_YELLOWEX, "911 Operator says: What's your location?");
					Player911Type[playerid] = 911;
				}
				case 911: //Police;
				{
					if(strlen(text) < 3)
						return SendErrorMessage(playerid, "Please input actual text.");

					format(Player911Text[playerid][2], 128, "%s", text);
					SendClientMessage(playerid, COLOR_YELLOWEX, "911 Operator says: Police units were dispatched.");

					Send911Message(playerid, 911);
				}
				case 2: //Medic input;
				{
					if(strlen(text) < 3)
						return SendErrorMessage(playerid, "Please input actual text.");

					format(Player911Text[playerid][1], 128, "%s", text);

					SendClientMessage(playerid, COLOR_YELLOWEX, "911 Operator says: What's your location?");
					Player911Type[playerid] = 811;
				}
				case 811: // Medic;
				{
					if(strlen(text) < 3)
						return SendErrorMessage(playerid, "Please input actual text.");

					format(Player911Text[playerid][2], 128, "%s", text);
					SendClientMessage(playerid, COLOR_YELLOWEX, "911 Operator says: Medical units were dispatched.");

					Send911Message(playerid, 811);
				}
			}
		}
		else
		{
			if(strlen(text) > 87)
			{
				format(string, sizeof(string), "%s says (phone): %.87s...", ReturnName(playerid, 0), text);
				LocalChat(playerid, 20.0, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4);

				if(!PlayerInfo[ PlayerInfo[playerid][pPhoneline] ][pPhonespeaker])
					SendClientMessage(PlayerInfo[playerid][pPhoneline], COLOR_YELLOWEX, string);

				else LocalChat(PlayerInfo[playerid][pPhoneline], 6.0, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4);

				format(string, sizeof(string), "%s says (phone): ... %s", ReturnName(playerid, 0), text[87]);
				LocalChat(playerid, 20.0, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4);

				if(!PlayerInfo[ PlayerInfo[playerid][pPhoneline] ][pPhonespeaker])
					SendClientMessage(PlayerInfo[playerid][pPhoneline], COLOR_YELLOWEX, string);

				else LocalChat(PlayerInfo[playerid][pPhoneline], 6.0, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4);
			}
			else
			{
				format(string, sizeof(string), "%s says (phone): %s", ReturnName(playerid, 0), text);
				LocalChat(playerid, 20.0, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4);

				if(!PlayerInfo[ PlayerInfo[playerid][pPhoneline] ][pPhonespeaker])
					SendClientMessage(PlayerInfo[playerid][pPhoneline], COLOR_YELLOWEX, string);

				else LocalChat(PlayerInfo[playerid][pPhoneline], 6.0, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4);
			}
		}
		return 0;
	}

	if (strlen(text) > 99)
	{
		format (string, sizeof(string), "%s says: %.99s...", ReturnName(playerid, 0), text);
		LocalChat(playerid, 20.0, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4);

		format (string, sizeof(string), "%s says: ... %s", ReturnName(playerid, 0), text[99]);
		LocalChat(playerid, 20.0, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4);

	}
	else
	{
		format (string, sizeof(string), "%s says: %s", ReturnName(playerid, 0), text);
		LocalChat(playerid, 20.0, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4);
	}
	return 0;
}

public OnPlayerUpdate(playerid)
{
	if(PlayerInfo[playerid][pAdminDuty])
		SetPlayerHealth(playerid, 250);

	PlayerInfo[playerid][pPauseCheck] = GetTickCount();

	new
		string[128];

	if(GetPlayerTeam(playerid) == PLAYER_STATE_WOUNDED)
	{
		format(string, sizeof(string), "(( Has been injured %d times, /damages %d for more information. ))", TotalPlayerDamages[playerid], playerid);
		SetPlayerChatBubble(playerid, string, COLOR_RED, 30.0, 2500);

		ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 0, 1, 1, 1, 0, 1);
	}
	else if(GetPlayerTeam(playerid) == PLAYER_STATE_DEAD)
	{
		SetPlayerChatBubble(playerid, "(( THIS PLAYER IS DEAD ))", COLOR_RED, 30.0, 2500);
	}
 	if(GetPlayerWantedLevel(playerid) == 0) return SetPlayerColor(playerid, -1);
    if(GetPlayerWantedLevel(playerid) == 1) return SetPlayerColor(playerid, COLOR_YELLOW);
    if(GetPlayerWantedLevel(playerid) == 2) return SetPlayerColor(playerid, COLOR_YELLOW);
    if(GetPlayerWantedLevel(playerid) == 3) return SetPlayerColor(playerid, COLOR_YELLOW);
    if(GetPlayerWantedLevel(playerid) == 4) return SetPlayerColor(playerid, COLOR_ORANGE);
    if(GetPlayerWantedLevel(playerid) == 5) return SetPlayerColor(playerid, COLOR_RED);
    if(GetPlayerWantedLevel(playerid) == 6) return SetPlayerColor(playerid, COLOR_RED);
	return 1;
}

public OnPlayerCommandReceived(playerid, cmdtext[])
{
	if(PlayerInfo[playerid][pLoggedin] == true)
	{
		printf("Player [%s] sent command: %s", ReturnName(playerid), cmdtext);
		return 1;
	}
	else
	{
		SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You need to be logged in to use commands.");
		printf("Player [%s] tried to send command: %s (During login, denied access)", ReturnName(playerid), cmdtext);
		return 0;
	}
	/*
	if(IsKTP[playerid] != 0 && strfind(cmdtext,"exitktp",true) == -1)
	{
		SendClientMessage(playerid,0xFF0000FF, "ERROR: {FFFFFF}You can not use any command here, type /exitktp to unblock them.");
		return 0;
	}
	*/
}
public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp(cmdtext, "/radio", true))
 	{
 	    new string[3000];
    	strcat(string,"{FF0000}Stop Radio\n");
 		strcat(string,"{0000FF}181.FM - POWER 181\n");
 		strcat(string,"{006400}181.FM - Chilled\n");
 		strcat(string,"{FF8C00}181.FM - Party\n");
 		strcat(string,"{008000}181.FM - Highway 181\n");
		strcat(string,"{4B00B0}181.FM - Kickin' Country\n");
		strcat(string,"{00FF00}COUNTRY 108\n");
		strcat(string,"{FFC0CB}DEFJAY.COM - 100% R&B\n");
		strcat(string,"{A52A2A}Antena1 SP 94,7 FM\n");
		strcat(string,"{808080}idobi Radio\n");
		strcat(string,"{FF0000}America Country Radio\n");
		strcat(string,"{0000FF}Absolutely Smooth Jazz - SKY.FM\n");
		strcat(string,"{006400}SmoothJazz.com Global Radio\n");
		strcat(string,"{FF8C00}CnR Radio\n");
		strcat(string,"{008000}))) POLSKASTACJA .PL )))\n");
		strcat(string,"{4B00B0}NOISEfm.pl - Niezalezne Radio Rock\n");
		strcat(string,"{00FF00}RadioTeenTal Indian and Bollywood\n");
		strcat(string,"{FFC0CB}DUBSTEP.FM\n");
		strcat(string,"{A52A2A}PARTY VIBE RADIO\n");
		strcat(string,"{808080}RADIO ORO MARBELLA EN DIRECTO\n");
		strcat(string,"{FF0000}Radio Nueva Vida\n");
		ShowPlayerDialog(playerid, RADIO, DIALOG_STYLE_LIST,"{ADD8E6}mmtech {90EE90}Radio",string,"Select","Cancel");
		return 1;
  	}
	return 0;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	if(!success)
	{
		if(strlen(cmdtext) > 28) // Preventing long bad commands from returning default message;
			SendServerMessage(playerid, "Sorry, that command doesn't exist. Use /help if you need assistance.");

		else
			SendServerMessage(playerid, "Sorry, the command \"%s\" doesn't exist. Use /help if you need assistance.", cmdtext);
	}
	else return 1;
	return 1;
}

/*public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
{
    // Check if it moved far
    if(GetVehicleDistanceFromPoint(vehicleid, new_x, new_y, new_z) > 50)
    {
        // Reject the update
		SendClientMessageToAllEx(COLOR_RED, "OnUnoccupiedVehicleUpdate called for Vehicle ID %i.", vehicleid);
        return 0;
    }

    return 1;
}*/

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (ENTER( newkeys, KEY_SECONDARY_ATTACK ))
    {
   	if(GetPVarInt(playerid, "DraggingPlayer") != INVALID_PLAYER_ID)
	{
		new Float:dX, Float:dY, Float:dZ, criminal;
		criminal = GetPVarInt(playerid, "DraggingPlayer");
		GetPlayerPos(playerid, dX, dY, dZ);
		floatsub(dX, 0.4);
		floatsub(dY, 0.4);

		SetPVarFloat(GetPVarInt(playerid, "DraggingPlayer"), "DragX", dX);
		SetPVarFloat(GetPVarInt(playerid, "DraggingPlayer"), "DragY", dY);
		SetPVarFloat(GetPVarInt(playerid, "DraggingPlayer"), "DragZ", dZ);
		SetPVarInt(GetPVarInt(playerid, "DraggingPlayer"), "DragWorld", GetPlayerVirtualWorld(playerid));
		SetPVarInt(GetPVarInt(playerid, "DraggingPlayer"), "DragInt", GetPlayerInterior(playerid));
		Streamer_UpdateEx(GetPVarInt(playerid, "DraggingPlayer"), dX, dY, dZ);
		SetPlayerPos(GetPVarInt(playerid, "DraggingPlayer"), dX, dY, dZ);
		SetPlayerInterior(GetPVarInt(playerid, "DraggingPlayer"), GetPlayerInterior(playerid));
		SetPlayerVirtualWorld(GetPVarInt(playerid, "DraggingPlayer"), GetPlayerVirtualWorld(playerid));
   		DeletePVar(GetPVarInt(playerid, "DraggingPlayer"), "BeingDragged");
   		SetPVarInt(playerid, "DraggingPlayer", INVALID_PLAYER_ID);
   		SCMex(playerid, COLOR_YELLOW, "You have stopped dragging: %s", ReturnName(criminal));
   		SCMex(criminal, COLOR_YELLOW, "You're no longer being dragged by: %s", ReturnName(playerid));
   		KillTimer(dragtimer[playerid]);
	}
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 1555.5010,-1675.9463,16.1953)) // PD Door Entrance
 	{
  		TogglePlayerControllable(playerid, 0);
   		SetTimerEx("Freeze", 1000, false, "i", playerid);
   		SetPlayerInterior(playerid,6);
     	SetPlayerPos(playerid, 246.6760,62.8185,1003.6406);
      	SetPlayerVirtualWorld(playerid, 5);
      	return 1;
	}
 	if(IsPlayerInRangeOfPoint(playerid, 3.0, 246.6760,62.8185,1003.6406)) // PD Door Exit
  	{
   		TogglePlayerControllable(playerid, 0);
    	SetTimerEx("Freeze", 1000, false, "i", playerid);
    	SetPlayerInterior(playerid,0);
     	SetPlayerPos(playerid, 1553.1344,-1675.6215,16.1953);
      	SetPlayerVirtualWorld(playerid, 0);
      	return 1;
	}
 	if(IsPlayerInRangeOfPoint(playerid, 3.0, -2648.2256,2240.2087,1008.9949)) // PD Stair locker up
	{
 		TogglePlayerControllable(playerid, 0);
		SetTimerEx("Freeze", 1000, false, "i", playerid);
 		SetPlayerPos(playerid, -2648.3049,2240.0605,1013.9836);
 		SetPlayerVirtualWorld(playerid, 5);
 		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 3.0, -2648.3049,2240.0605,1013.9836)) // PD Stair locker down
	{
 		TogglePlayerControllable(playerid, 0);
		SetTimerEx("Freeze", 1000, false, "i", playerid);
 		SetPlayerPos(playerid, -2648.2256,2240.2087,1008.9949);
		SetPlayerVirtualWorld(playerid, 5);
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 1675.8707,-1635.4561,14.2266)) // FD Front door
	{
 		TogglePlayerControllable(playerid, 0);
		SetTimerEx("Freeze", 1000, false, "i", playerid);
		SetPlayerPos(playerid, 390.7417,173.6430,1008.3828);
		SetPlayerVirtualWorld(playerid, 5);
		SetPlayerInterior(playerid,3);
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 390.7417,173.6430,1008.3828)) // FD front door itn
	{
 		TogglePlayerControllable(playerid, 0);
		SetTimerEx("Freeze", 1000, false, "i", playerid);
 		SetPlayerPos(playerid, 1675.8707,-1635.4561,14.2266);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid,0);
		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 3.0, -2588.3545,4008.3154,2001.2579)) // FD back door INT
	{
		TogglePlayerControllable(playerid, 0);
 		SetTimerEx("Freeze", 1000, false, "i", playerid);
   		SetPlayerPos(playerid, -2537.2803,2356.0618,5.0134);
     	SetPlayerVirtualWorld(playerid, 0);
     	return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 3.0, -2537.2803,2356.0618,5.0134)) // FD back door back
 	{
  		TogglePlayerControllable(playerid, 0);
   		SetTimerEx("Freeze", 1000, false, "i", playerid);
     	SetPlayerPos(playerid, -2588.3545,4008.3154,2001.2579);
      	SetPlayerVirtualWorld(playerid, 5);
      	return 1;
	}
	new
		id,
		str[128]
	;
	if(IsPlayerInRangeOfPoint(playerid, 3.0, -2613.7473, 2264.5320, 7.8690)) // PD Door Entrance
 	{
  		TogglePlayerControllable(playerid, 0);
   		SetTimerEx("Freeze", 1000, false, "i", playerid);
     	SetPlayerPos(playerid, -2653.4204,2232.9939,1009);
      	SetPlayerVirtualWorld(playerid, 5);
      	return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 3.0, -2648.2256,2240.2087,1008.9949)) // PD Stair locker up
 	{
  		TogglePlayerControllable(playerid, 0);
   		SetTimerEx("Freeze", 1000, false, "i", playerid);
     	SetPlayerPos(playerid, -2648.3049,2240.0605,1013.9836);
   	 	SetPlayerVirtualWorld(playerid, 5);
   	 	return 1;
	}
   	if(IsPlayerInRangeOfPoint(playerid, 3.0,1675.8707,-1635.4561,14.2266)) // FD Front door
    {
    	TogglePlayerControllable(playerid, 0);
    	SetTimerEx("Freeze", 1000, false, "i", playerid);
     	SetPlayerPos(playerid, -2592.4727,4000.8035,2001.2579);
      	SetPlayerVirtualWorld(playerid, 5);
      	return 1;
	}
 	if(IsPlayerInRangeOfPoint(playerid, 3.0, -2537.2803,2356.0618,5.0134)) // FD back door back
  	{
   		TogglePlayerControllable(playerid, 0);
    	SetTimerEx("Freeze", 1000, false, "i", playerid);
     	SetPlayerPos(playerid, -2588.3545,4008.3154,2001.2579);
      	SetPlayerVirtualWorld(playerid, 5);
      	return 1;
	}
	for(new p = 1; p < MAX_PROPERTY; p++)
	{
		if(!PropertyInfo[p][ePropertyDBID])
			continue;

		if(IsPlayerInRangeOfPoint(playerid, 3.0, PropertyInfo[p][ePropertyEntrance][0], PropertyInfo[p][ePropertyEntrance][1], PropertyInfo[p][ePropertyEntrance][2]))
		{
			if(GetPlayerInterior(playerid) != PropertyInfo[p][ePropertyEntranceInterior])
				continue;

			if(GetPlayerVirtualWorld(playerid) != PropertyInfo[p][ePropertyEntranceWorld])
				continue;

			if(PropertyInfo[p][ePropertyLocked])
				return GameTextForPlayer(playerid, "~r~Locked", 3000, 1);

			PlayerInfo[playerid][pInsideProperty] = p;

			if(PropertyInfo[p][ePropertyBoomboxOn])
			{
				PlayAudioStreamForPlayer(playerid, PropertyInfo[p][ePropertyBoomboxURL]);
			}

			SetPlayerPos(playerid, PropertyInfo[p][ePropertyInterior][0], PropertyInfo[p][ePropertyInterior][1], PropertyInfo[p][ePropertyInterior][2]);

			SetPlayerVirtualWorld(playerid, PropertyInfo[p][ePropertyInteriorWorld]);
			SetPlayerInterior(playerid, PropertyInfo[p][ePropertyInteriorIntID]);

			TogglePlayerControllable(playerid, 0);
			SetTimerEx("OnPlayerEnterProperty", 2000, false, "ii", playerid, p);

		}
	}

	if((id = IsPlayerNearBusiness(playerid)) != 0)
	{
		if(BusinessInfo[id][eBusinessLocked])
			return GameTextForPlayer(playerid, "~r~Locked", 3000, 1);

		if(BusinessInfo[id][eBusinessType] == BUSINESS_TYPE_DEALERSHIP || BusinessInfo[id][eBusinessType] == BUSINESS_TYPE_DMV)
			return GameTextForPlayer(playerid, "~r~Closed", 3000, 1);

		if(BusinessInfo[id][eBusinessEntranceFee] > PlayerInfo[playerid][pMoney])
			return GameTextForPlayer(playerid, "~r~You can't afford this.", 3000, 1);

		if(PlayerInfo[playerid][pDBID] != BusinessInfo[id][eBusinessOwnerDBID] && BusinessInfo[id][eBusinessType] != BUSINESS_TYPE_BANK)
		{
			GiveMoney(playerid, -BusinessInfo[id][eBusinessEntranceFee]);
			BusinessInfo[id][eBusinessCashbox]+= BusinessInfo[id][eBusinessEntranceFee];
		}

		format(str, sizeof(str), "%s", BusinessInfo[id][eBusinessName]);
		GameTextForPlayer(playerid, str, 500, 1);

		SetPlayerPos(playerid, BusinessInfo[id][eBusinessInterior][0], BusinessInfo[id][eBusinessInterior][1], BusinessInfo[id][eBusinessInterior][2]);

		SetPlayerInterior(playerid, BusinessInfo[id][eBusinessInteriorIntID]);
		SetPlayerVirtualWorld(playerid, BusinessInfo[id][eBusinessInteriorWorld]);
		TogglePlayerControllable(playerid, 0);
    	SetTimerEx("Freeze", 1000, false, "i", playerid);

		PlayerInfo[playerid][pInsideBusiness] = id;

		SendBusinessType(playerid, id);
		return 1;
	}
	if(PlayerInfo[playerid][pEditingObject])
		return 1;

	if((id = IsPlayerInProperty(playerid)) != 0)
	{
		if(!IsPlayerInRangeOfPoint(playerid, 3.0, PropertyInfo[id][ePropertyInterior][0], PropertyInfo[id][ePropertyInterior][1], PropertyInfo[id][ePropertyInterior][2]))
			return 1;

		SetPlayerPos(playerid, PropertyInfo[id][ePropertyEntrance][0], PropertyInfo[id][ePropertyEntrance][1], PropertyInfo[id][ePropertyEntrance][2]);

		SetPlayerVirtualWorld(playerid, PropertyInfo[id][ePropertyEntranceWorld]);
		SetPlayerInterior(playerid, PropertyInfo[id][ePropertyEntranceInterior]);
		TogglePlayerControllable(playerid, 0);
    	SetTimerEx("Freeze", 1000, false, "i", playerid);

		if(PropertyInfo[id][ePropertyBoomboxOn])
			StopAudioStreamForPlayer(playerid);

		PlayerInfo[playerid][pInsideProperty] = 0;
		return 1;
	}
	for(new i = 1; i < MAX_BUSINESS; i++)
	if(IsPlayerInRangeOfPoint(playerid, 3.0, BusinessInfo[i][eBusinessInterior][0], BusinessInfo[i][eBusinessInterior][1], BusinessInfo[i][eBusinessInterior][2]))
	{
		SetPlayerPos(playerid, BusinessInfo[i][eBusinessEntrance][0], BusinessInfo[i][eBusinessEntrance][1], BusinessInfo[i][eBusinessEntrance][2]);

		SetPlayerInterior(playerid, BusinessInfo[i][eBusinessInteriorExtIntID]);
		SetPlayerVirtualWorld(playerid, BusinessInfo[i][eBusinessInteriorExtWorld]);
		TogglePlayerControllable(playerid, 0);
	    SetTimerEx("Freeze", 1000, false, "i", playerid);

		PlayerInfo[playerid][pInsideBusiness] = 0;
	}
	return 1;
	}
	if (newkeys == KEY_YES)
	 {
	    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendErrorMessage(playerid, "You aren't in the driver's seat of a vehicle.");

		new vehicleid = GetPlayerVehicleID(playerid);

		if(!VehicleInfo[vehicleid][eVehicleDBID] && !VehicleInfo[vehicleid][eVehicleAdminSpawn])
		{
		for(new i = 0; i < sizeof dmv_vehicles; i++)
	 	if(GetPlayerVehicleID(playerid) == dmv_vehicles[i])
			return SendServerMessage(playerid, "This command can only be used for private vehicles. You are in a public static vehicle.");

		if(!VehicleInfo[vehicleid][eVehicleEngineStatus])
		{
			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s started the engine of the %s.", ReturnName(playerid, 0), ReturnVehicleName(vehicleid));
			ToggleVehicleEngine(vehicleid, true); VehicleInfo[vehicleid][eVehicleEngineStatus] = true;
		}
		else
		{
			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s stopped the engine of the %s.", ReturnName(playerid, 0), ReturnVehicleName(vehicleid));
			ToggleVehicleEngine(vehicleid, false); VehicleInfo[vehicleid][eVehicleEngineStatus] = false;
		}
		return 1;
		}

		if(HasNoEngine(vehicleid))
			return SendErrorMessage(playerid, "This vehicle doesn't have a engine.");

		if(VehicleInfo[vehicleid][eVehicleFuel] < 1 && !VehicleInfo[vehicleid][eVehicleAdminSpawn])
			return SendClientMessage(playerid, COLOR_RED, "Vehicle is out of fuel.");

		if(VehicleInfo[vehicleid][eVehicleFaction] > 0)
		{
			if(PlayerInfo[playerid][pFaction] != VehicleInfo[vehicleid][eVehicleFaction] && !PlayerInfo[playerid][pAdminDuty])
			{
				return SendErrorMessage(playerid, "You don't have the keys to this vehicle.");
			}
		}

		for(new i = 0; i < sizeof dmv_vehicles; i++)
	 	if(GetPlayerVehicleID(playerid) == dmv_vehicles[i])
			return SendServerMessage(playerid, "This command can only be used for private vehicles. You are in a public static vehicle.");

	 	if(!VehicleInfo[vehicleid][eVehicleFaction] && VehicleInfo[vehicleid][eVehicleOwnerDBID] != PlayerInfo[playerid][pDBID] && PlayerInfo[playerid][pDuplicateKey] != vehicleid && !PlayerInfo[playerid][pAdminDuty])
	        return SendClientMessage(playerid, COLOR_RED, "You don't have the keys to this vehicle.");

		if(!VehicleInfo[vehicleid][eVehicleEngineStatus])
		{
			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s started the engine of the %s.", ReturnName(playerid, 0), ReturnVehicleName(vehicleid));
			ToggleVehicleEngine(vehicleid, true); VehicleInfo[vehicleid][eVehicleEngineStatus] = true;
		}
		else
		{
			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s stopped the engine of the %s.", ReturnName(playerid, 0), ReturnVehicleName(vehicleid));
			ToggleVehicleEngine(vehicleid, false); VehicleInfo[vehicleid][eVehicleEngineStatus] = false;
		}
	}
	if(newkeys == KEY_JUMP)
	{
		if(GetPVarInt(playerid, "pSafeID") != -1)
		{
			new sid = GetPVarInt(playerid, "pSafeID");
			KillTimer(xSafe[sid][safe_Timer]);
			new str[128];
			PlayerTextDrawSetString(playerid, xRob_TD[playerid][2], "~r~~h~Robbery has been cancelled!");
			PlayerTextDrawShow(playerid, xRob_TD[playerid][2]);
			format(str, sizeof(str), "~g~~h~You cancelled the robbery!~n~~y~~h~Stolen money: ~g~$%d", GetPVarInt(playerid, "robbedMoney"));
			PlayerTextDrawSetString(playerid, xRob_TD[playerid][6], str);
			PlayerTextDrawShow(playerid, xRob_TD[playerid][6]);
			PlayerTextDrawHide(playerid, xRob_TD[playerid][7]);
			GivePlayerMoney(playerid, GetPVarInt(playerid, "robbedMoney"));
			xSafe[sid][safe_Timer] = SetTimerEx("safeCooldown", 3000, false, "ud", playerid, sid);
			SetPVarInt(playerid, "pSafeID", -1);
			DeletePVar(playerid, "rob_Money");
			DeletePVar(playerid, "robbedMoney");
			ClearAnimations(playerid);
			TogglePlayerControllable(playerid, 1);
		}
	}
	return 1;
}
CMD:gps(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, -1, "{FF0000}<!> You must be in a vehicle to use Gps!");
	static string[sizeof(NavData) * 64];

	if (string[0] == EOS)
	{
		for (new i; i < sizeof(NavData); i++)
		{
			format(string, sizeof string, "%s{f4a442}� {f7f5bb}%s\n", string, NavData[i][NAV_NAME]);
		}
	}
	ShowPlayerDialog(playerid, 112, DIALOG_STYLE_LIST, "[GPS] Locations", string, "Select", "Close");
	return 1;
}

CMD:gpsclose(playerid, params[])
{
	if(pNavState[playerid])
	{
		KillTimer(pNavTimer[playerid]);
		DestroyObject(ok[playerid]);
		for(new i; i<sizeof(NAVTD); i++) TextDrawHideForPlayer(playerid, NAVTD[i]);
		PlayerTextDrawHide(playerid, NAVpTD[playerid]);
		PlayerPlaySound(playerid,1137,0.0,0.0,0.0);
		DisablePlayerCheckpoint(playerid);
		pNavState[playerid] = 0;
		SendClientMessage(playerid, -1, "{FF0000}<!> Gps cancelled!");
	} else SendClientMessage(playerid, -1, "{FF0000}<!> Gps is already off!");
	return 1;
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
  	if(newstate == PLAYER_STATE_DRIVER && !HasNoEngine(GetPlayerVehicleID(playerid)))
	{
		if(!VehicleInfo[GetPlayerVehicleID(playerid)][eVehicleEngineStatus])
			SendClientMessage(playerid, COLOR_DARKGREEN, "The engine is off. (/engine)");

		if(VehicleInfo[GetPlayerVehicleID(playerid)][eVehicleOwnerDBID] == PlayerInfo[playerid][pDBID])
			SendClientMessageEx(playerid, COLOR_WHITE, "Welcome to your %s.", ReturnVehicleName(GetPlayerVehicleID(playerid)));

		for(new i = 0; i < sizeof dmv_vehicles; i++) if(GetPlayerVehicleID(playerid) == dmv_vehicles[i])
			SendServerMessage(playerid, "You're inside a DMV vehicle. Use /licenseexam to start taking your test.");

		PlayerTextDrawShow(playerid, SpeedoText[playerid]);
	}
 	else
    {
        PlayerTextDrawHide(playerid, SpeedoText[playerid]);
    }

	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
		if(VehicleInfo[GetPlayerVehicleID(playerid)][eVehicleXMROn])
		{
			PlayAudioStreamForPlayer(playerid, VehicleInfo[GetPlayerVehicleID(playerid)][eVehicleXMRURL]);
		}
	}

	if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER && newstate == PLAYER_STATE_ONFOOT)
	{
		StopAudioStreamForPlayer(playerid);
	}

	if(oldstate == PLAYER_STATE_DRIVER)
	{
		if(DealershipPlayerCar[playerid] != INVALID_VEHICLE_ID)
		{
			if(IsValidVehicle(DealershipPlayerCar[playerid]) && !VehicleInfo[DealershipPlayerCar[playerid]][eVehicleDBID])
			{
				DestroyVehicle(DealershipPlayerCar[playerid]);
			}

			if(!PlayerPurchasingVehicle[playerid])
				ResetDealershipVars(playerid);
		}

		if(PlayerTakingLicense[playerid])
			StopDriverstest(playerid);
	}
    if(pNavState[playerid])
	{
		KillTimer(pNavTimer[playerid]);
		DestroyObject(ok[playerid]);
		for(new i; i<sizeof(NAVTD); i++) TextDrawHideForPlayer(playerid, NAVTD[i]);
		PlayerTextDrawHide(playerid, NAVpTD[playerid]);
		PlayerPlaySound(playerid,1150,0.0,0.0,0.0);
		DisablePlayerCheckpoint(playerid);
		pNavState[playerid] = 0;
		SendClientMessage(playerid, -1, "{FF0000}<!> GPS is cancelled because you are off the vehicle!");
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 574)
     {
     	SendClientMessage(playerid, COLOR_RED, "* You can start the sweepingjob by using /sweeper");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendErrorMessage(playerid, "You aren't in the driver's seat of a vehicle.");

		new vehicleids = GetPlayerVehicleID(playerid);

        if(HasNoEngine(vehicleids))
			return SendErrorMessage(playerid, "This vehicle doesn't have a engine.");

        if(VehicleInfo[vehicleids][eVehicleFuel] < 1 && !VehicleInfo[vehicleids][eVehicleAdminSpawn])
			return SendClientMessage(playerid, COLOR_RED, "Vehicle is out of fuel!");

		if(!VehicleInfo[vehicleids][eVehicleEngineStatus])
		{
			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s started the engine of the %s.", ReturnName(playerid, 0), ReturnVehicleName(vehicleid));
			ToggleVehicleEngine(vehicleids, true); VehicleInfo[vehicleids][eVehicleEngineStatus] = true;
		}
		else
		{
			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s stopped the engine of the %s.", ReturnName(playerid, 0), ReturnVehicleName(vehicleid));
			ToggleVehicleEngine(vehicleids, false); VehicleInfo[vehicleids][eVehicleEngineStatus] = false;
		}
		return 0;
     }
	if(!ispassenger && VehicleInfo[vehicleid][eVehicleFaction] && PlayerInfo[playerid][pFaction] != VehicleInfo[vehicleid][eVehicleFaction])
	{
 		ClearAnimations(playerid);
	}
	if(!ispassenger)
	{
	    if(PlayerInfo[playerid][pHandcuffed])
	    {
	        SendErrorMessage(playerid, "You're not going to tell me you tought driving a car while handcuffed was posible right?");
	        return ClearAnimations(playerid);
		}
		if(PlayerInfo[playerid][pCarry] == 1)
		{
		    SendErrorMessage(playerid, "You're holding a bag and you're trying to drive a vehicle? Nope.");
			return ClearAnimations(playerid);
		}
		for(new i = 0; i < sizeof dmv_vehicles; i++) if(vehicleid == dmv_vehicles[i])
		{
			if(PlayerInfo[playerid][pDriversLicense])
			{
				SendErrorMessage(playerid, "You already have a driver's license.");
				return ClearAnimations(playerid);
			}
		}
		for(new q = 0; q < sizeof pizza_vehicles; q++) if(vehicleid == pizza_vehicles[q])
		{
		    if(PlayerInfo[playerid][pJob] != 1)
		    {
		        SendErrorMessage(playerid, "You are not a pizza boy.");
				ClearAnimations(playerid);
			}
		}
		for(new t = 0; t < sizeof tow_vehicles; t++) if(vehicleid == tow_vehicles[t])
		{
  			if(PlayerInfo[playerid][pJob] != 2)
    		{
		        SendErrorMessage(playerid, "You are not a mechanic.");
				ClearAnimations(playerid);
			}
			if(PlayerInfo[playerid][pJob] == 2 && PlayerInfo[playerid][pWorking] == 0)
  			{
  			    SendErrorMessage(playerid, "You are not a working.");
  			    ClearAnimations(playerid);
			}
		}
		for(new tt = 0; tt < sizeof taxi_vehicles; tt++) if(vehicleid == taxi_vehicles[tt])
		{
  			if(PlayerInfo[playerid][pJob] != 3)
    		{
		        SendErrorMessage(playerid, "You are not a taxi driver.");
				ClearAnimations(playerid);
			}
			if(PlayerInfo[playerid][pJob] == 3 && PlayerInfo[playerid][pWorking] == 0)
  			{
  			    SendErrorMessage(playerid, "You are not a working.");
  			    ClearAnimations(playerid);
			}
		}
		for(new tt = 0; tt < sizeof trucking_vehicles; tt++) if(vehicleid == trucking_vehicles[tt])
		{
			if(PlayerInfo[playerid][pJob] != 4)
			{
				SendErrorMessage(playerid, "You're not a truck driver.");
				return ClearAnimations(playerid);
			}
		}
	}
    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 403)
    {
    	SendClientMessage(playerid, COLOR_RED, "* You can start the Petrol Trucking by typing /petrol");
    }
	return 1;
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(PlayerInfo[playerid][pEditingObject])
	{
		switch(PlayerInfo[playerid][pEditingObject])
		{
			case 1:
			{
				if(response == EDIT_RESPONSE_CANCEL)
				{
					DestroyDynamicObject(PlayerInfo[playerid][pAddObject]);
					PlayerInfo[playerid][pEditingObject] = 0;

					SendServerMessage(playerid, "You're no longer buying a boombox.");
					return 1;
				}

				if(response == EDIT_RESPONSE_FINAL)
				{
					ConfirmDialog(playerid, "Confirmation", "Are you sure you want to buy this?\nPrice: $1,000", "OnPropertyBoombox", IsPlayerInProperty(playerid), x, y, z, rx, ry, rz);
					return 1;
				}
			}

			case 2:
			{
				new
					id = IsPlayerInProperty(playerid)
				;

				if(response == EDIT_RESPONSE_CANCEL)
				{
					PlayerInfo[playerid][pEditingObject] = 0;

					SetDynamicObjectPos(PropertyInfo[id][ePropertyBoomboxObject], PropertyInfo[id][ePropertyBoomboxPos][0], PropertyInfo[id][ePropertyBoomboxPos][1], PropertyInfo[id][ePropertyBoomboxPos][2]);
					SetDynamicObjectRot(PropertyInfo[id][ePropertyBoomboxObject], PropertyInfo[id][ePropertyBoomboxRot][0], PropertyInfo[id][ePropertyBoomboxRot][1], PropertyInfo[id][ePropertyBoomboxRot][2]);

					SendServerMessage(playerid, "You cancelled.");
					return 1;
				}

				if(response == EDIT_RESPONSE_FINAL)
				{
					PlayerInfo[playerid][pEditingObject] = 0;

					SetDynamicObjectPos(PropertyInfo[id][ePropertyBoomboxObject], x, y, z);
					SetDynamicObjectRot(PropertyInfo[id][ePropertyBoomboxObject], rx, ry, rz);

					PropertyInfo[id][ePropertyBoomboxPos][0] = x;
					PropertyInfo[id][ePropertyBoomboxPos][1] = y;
					PropertyInfo[id][ePropertyBoomboxPos][2] = z;

					PropertyInfo[id][ePropertyBoomboxRot][0] = rx;
					PropertyInfo[id][ePropertyBoomboxRot][1] = ry;
					PropertyInfo[id][ePropertyBoomboxRot][2] = rz;

					SaveProperty(id);
					SendServerMessage(playerid, "You edited your properties' boombox position.");
					return 1;
				}
			}
		}
	}
	return 1;
}

public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	switch(GetPVarInt(playerid, "safeMode"))
	{
		case 1:
		{
			if(response == EDIT_RESPONSE_FINAL)
			{
				DestroyObject(GetPVarInt(playerid, "tmp_safe"));
				DeletePVar(playerid, "tmp_safe");
				DeletePVar(playerid, "safeMode");
				new sid = CreatexSafe(fX, fY, fZ, fRotZ);
				new str[128];
				format(str, sizeof(str), "{00FF00}[!] {FFFB93}Safe {ECB021}#%d {FFFB93}has succesfully created!", sid);
				SendClientMessage(playerid, -1, str);
			}
			else if(response == EDIT_RESPONSE_CANCEL)
			{
				DestroyObject(GetPVarInt(playerid, "tmp_safe"));
				DeletePVar(playerid, "tmp_safe");
				DeletePVar(playerid, "safeMode");
				SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Safe creation cancelled.");
			}
		}
		case 2:
		{
			new sid = GetPVarInt(playerid, "tmp_safe");
			if(response == EDIT_RESPONSE_FINAL)
			{
				xSafe[sid][safe_Pos][0] = fX;
				xSafe[sid][safe_Pos][1] = fY;
				xSafe[sid][safe_Pos][2] = fZ;
				xSafe[sid][safe_Pos][3] = fRotZ;
				if(xSafe[sid][safe_Durum] == 3)
				{
					Delete3DTextLabel(xSafe[sid][safe_Label]);
					xSafe[sid][safe_Label] = Create3DTextLabel(" ", -1, xSafe[sid][safe_Pos][0], xSafe[sid][safe_Pos][1], xSafe[sid][safe_Pos][2]+1, 100, 0);
				}
				DeletePVar(playerid, "tmp_safe");
				DeletePVar(playerid, "safeMode");
				SavexSafe(sid);
				new str[128];
				format(str, sizeof(str), "{00FF00}[!] {FFFB93} Safe {ECB021}#%d {FFFB93}has been succesfully edited!", sid);
				SendClientMessage(playerid, -1, str);
			}
			else if(response == EDIT_RESPONSE_CANCEL)
			{
				DeletePVar(playerid, "tmp_safe");
				DeletePVar(playerid, "safeMode");
				SetObjectPos(xSafe[sid][safe_Obj], xSafe[sid][safe_Pos][0], xSafe[sid][safe_Pos][1], xSafe[sid][safe_Pos][2]);
				SetObjectRot(xSafe[sid][safe_Obj], 0.0, 0.0, xSafe[sid][safe_Pos][3]);
				SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}You cancelled the edition.");
			}
		}
	}
	return 1;
}
CMD:rob(playerid, params[])
{
	new sid = GetNearestSafeID(playerid);
	if(sid == -1) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Safe can't be found!");
	if(xSafe[sid][safe_Durum] == 3) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}This safe was recently robbed! You should wait for a while to rob again.");
	if(xSafe[sid][safe_Durum] != 0) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}This safe is already being robbed!");

	SetPlayerLookAt(playerid, xSafe[sid][safe_Pos][0], xSafe[sid][safe_Pos][1]);
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, 0);
	xSafe[sid][safe_Progress] = 0;
	xSafe[sid][safe_Timer] = SetTimerEx("safeCrackProgress", 100, true, "ud", playerid, sid);
	xSafe[sid][safe_Durum] = 1;
	SetPVarInt(playerid, "pSafeID", sid);
	PlayerTextDrawSetString(playerid, xRob_TD[playerid][2], "Safe is cracking...");
	PlayerTextDrawSetString(playerid, xRob_TD[playerid][6], "You are trying to crack the safe...");
	PlayerTextDrawSetString(playerid, xRob_TD[playerid][4], " ");
	for(new i; i<8; i++) PlayerTextDrawShow(playerid, xRob_TD[playerid][i]);
	ApplyAnimation(playerid, "BOMBER", "BOM_PLANT_LOOP", 4.1, true, false, false, false, 0, false);
	SetPlayerWantedLevel(playerid,2);
	return 1;
}

CMD:createsafe(playerid, params[])
{
	if(GetPVarInt(playerid, "safeMode") != 0) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}You are already editing a safe!");
	new Float:pos[3];
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	GetXYInFrontOfPlayer(playerid, pos[0], pos[1], 1);
	SetPVarInt(playerid, "tmp_safe", CreateObject(2332, pos[0], pos[1], pos[2], 0.0, 0.0, 0, 100));
	SetPVarInt(playerid, "safeMode", 1); // 1: create 2: edit
	EditObject(playerid, GetPVarInt(playerid, "tmp_safe"));
	return 1;
}

CMD:editsafe(playerid, params[])
{
	if(GetPVarInt(playerid, "safeMode") != 0) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}You are already editing a safe!");
	new sid;
	if(sscanf(params, "d", sid)) return SendClientMessage(playerid, -1, "{F0AE0F}KULLANIM: {FFFB93}/editsafe {ECB021}[Safe ID]");
	if(!Iter_Contains(xSafes, sid)) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Safe can't be found!");
	SetPVarInt(playerid, "tmp_safe", sid);
	SetPVarInt(playerid, "safeMode", 2);
	pTmpPos[playerid][0] = xSafe[sid][safe_Pos][0];
	pTmpPos[playerid][1] = xSafe[sid][safe_Pos][1];
	pTmpPos[playerid][2] = xSafe[sid][safe_Pos][2];
	pTmpPos[playerid][3] = xSafe[sid][safe_Pos][3];
	EditObject(playerid, xSafe[sid][safe_Obj]);
	SendClientMessage(playerid, -1, "{00FF00}[!] {FFFB93}You are editing a safe!");
	return 1;
}

CMD:deletesafe(playerid, params[])
{
	new sid;
	if(sscanf(params, "d", sid)) return SendClientMessage(playerid, -1, "{F0AE0F}KULLANIM: {FFFB93}/deletesafe {ECB021}[Safe ID]");
	if(!Iter_Contains(xSafes, sid)) return SendClientMessage(playerid, -1, "{FF0000}[!] {F0AE0F}Safe can't be found!");
	Iter_Remove(xSafes, sid);
	if(xSafe[sid][safe_Durum] == 3) Delete3DTextLabel(xSafe[sid][safe_Label]);
	DestroyObject(xSafe[sid][safe_Obj]);
	KillTimer(xSafe[sid][safe_Timer]);
	new str[128];
	format(str, sizeof(str), "DELETE FROM `xrob_safes` WHERE `ID`=%d", sid);
	mysql_query(ourConnection, str);
	format(str, sizeof(str), "{00FF00}[!] {FFFB93}You have succesfully deleted Safe {ECB021}#%d", sid);
	SendClientMessage(playerid, -1, str);
	return 1;
}

forward safeCrackProgress(playerid, safeid);
public safeCrackProgress(playerid, safeid)
{
	xSafe[safeid][safe_Progress]++;
	new str[56];
	for(new i; i<xSafe[safeid][safe_Progress] / 2; i++) format(str, sizeof(str), "%sI", str);
	PlayerTextDrawSetString(playerid, xRob_TD[playerid][4], str);
	PlayerTextDrawShow(playerid, xRob_TD[playerid][4]);

	if(xSafe[safeid][safe_Progress] >= 100)
	{
		KillTimer(xSafe[safeid][safe_Timer]);
		DestroyObject(xSafe[safeid][safe_Obj]);
		xSafe[safeid][safe_BosObj] = CreateObject(1829, xSafe[safeid][safe_Pos][0], xSafe[safeid][safe_Pos][1], xSafe[safeid][safe_Pos][2], 0.0, 0.0, xSafe[safeid][safe_Pos][3]);
		PlayerTextDrawSetString(playerid, xRob_TD[playerid][2], "Safe cracked! Robbing the safe...");
		PlayerTextDrawShow(playerid, xRob_TD[playerid][2]);
		PlayerTextDrawSetString(playerid, xRob_TD[playerid][6], "~g~~h~You have succesfully cracked the safe!~n~~y~~h~Stolen money: ~g~$0");
		PlayerTextDrawShow(playerid, xRob_TD[playerid][6]);
		PlayerTextDrawSetString(playerid, xRob_TD[playerid][4], " ");
		PlayerTextDrawShow(playerid, xRob_TD[playerid][4]);
		SetPVarInt(playerid, "rob_Money", random((ROB_MAX - ROB_MIN)) + ROB_MIN);
		ApplyAnimation(playerid, "ROB_BANK", "CAT_SAFE_ROB", 4.1, true, false, false, false, 0, false);
		xSafe[safeid][safe_Durum] = 2;
		xSafe[safeid][safe_Progress] = 0;
		xSafe[safeid][safe_Timer] = SetTimerEx("safeRobProgress", 100, true, "ud", playerid, safeid);
	}
	return 1;
}

forward safeRobProgress(playerid, safeid);
public safeRobProgress(playerid, safeid)
{
	xSafe[safeid][safe_Progress]++;
	new str[128];
	for(new i; i<xSafe[safeid][safe_Progress] / 2; i++) format(str, sizeof(str), "%sI", str);
	PlayerTextDrawSetString(playerid, xRob_TD[playerid][4], str);
	PlayerTextDrawShow(playerid, xRob_TD[playerid][4]);

	format(str, sizeof(str), "~g~~h~You have succesfully cracked the safe!~n~~y~~h~Stolen money: ~g~$%d", (GetPVarInt(playerid, "rob_Money") * xSafe[safeid][safe_Progress]) / 100);
	PlayerTextDrawSetString(playerid, xRob_TD[playerid][6], str);
	PlayerTextDrawShow(playerid, xRob_TD[playerid][6]);
	SetPVarInt(playerid, "robbedMoney", (GetPVarInt(playerid, "rob_Money") * xSafe[safeid][safe_Progress]) / 100);

	if(xSafe[safeid][safe_Progress] >= 100)
	{
		KillTimer(xSafe[safeid][safe_Timer]);
		PlayerTextDrawSetString(playerid, xRob_TD[playerid][2], "Safe Robbed!");
		PlayerTextDrawShow(playerid, xRob_TD[playerid][2]);
		format(str, sizeof(str), "~g~~h~You have succesfully robbed the safe!~n~~y~~h~Stolen Money: ~g~$%d", GetPVarInt(playerid, "rob_Money"));
		PlayerTextDrawSetString(playerid, xRob_TD[playerid][6], str);
		PlayerTextDrawShow(playerid, xRob_TD[playerid][6]);
		PlayerTextDrawHide(playerid, xRob_TD[playerid][7]);
		GivePlayerMoney(playerid, GetPVarInt(playerid, "rob_Money"));
		xSafe[safeid][safe_Timer] = SetTimerEx("safeCooldown", 3000, false, "ud", playerid, safeid);
		SetPVarInt(playerid, "pSafeID", -1);
		DeletePVar(playerid, "rob_Money");
		DeletePVar(playerid, "robbedMoney");
		ClearAnimations(playerid);
		TogglePlayerControllable(playerid, 1);
	}
	return 1;
}

forward safeCooldown(playerid, safeid);
public safeCooldown(playerid, safeid)
{
	if(IsPlayerConnected(playerid)) for(new i; i<8; i++) PlayerTextDrawHide(playerid, xRob_TD[playerid][i]);
	if(xSafe[safeid][safe_Durum] == 1) return xSafe[safeid][safe_Durum] = 0;
	new str[128];
	xSafe[safeid][safe_Sure] = SAFE_COOLDOWN_TIME * 60;
	xSafe[safeid][safe_Durum] = 3;
	format(str, sizeof(str), "This safe has been robbed!\nYou should wait {F0AE0F}%s {FFFFFF}to rob again.", TimeConvert(xSafe[safeid][safe_Sure]));
	xSafe[safeid][safe_Label] = Create3DTextLabel(str, -1, xSafe[safeid][safe_Pos][0], xSafe[safeid][safe_Pos][1], xSafe[safeid][safe_Pos][2]+1, 100, 0);
	xSafe[safeid][safe_Timer] = SetTimerEx("safe_SureAzalt", 1000, true, "d", safeid);
	return 1;
}

forward safe_SureAzalt(safeid);
public safe_SureAzalt(safeid)
{
	xSafe[safeid][safe_Sure]--;
	new str[128];
	format(str, sizeof(str), "This safe has been robbed!\nYou should wait {F0AE0F}%s {FFFFFF}to rob again.", TimeConvert(xSafe[safeid][safe_Sure]));
	Update3DTextLabelText(xSafe[safeid][safe_Label], -1, str);

	if(xSafe[safeid][safe_Sure] <= 0)
	{
		Delete3DTextLabel(xSafe[safeid][safe_Label]);
		DestroyObject(xSafe[safeid][safe_BosObj]);
		xSafe[safeid][safe_Obj] = CreateObject(2332, xSafe[safeid][safe_Pos][0], xSafe[safeid][safe_Pos][1], xSafe[safeid][safe_Pos][2], 0.0, 0.0, xSafe[safeid][safe_Pos][3]);
		xSafe[safeid][safe_Durum] = 0;
	}
	return 1;
}

SavexSafe(safeid)
{
	new query[128];

	mysql_format(ourConnection, query, sizeof(query), "UPDATE `xRob_Safes` SET X=%f, Y=%f, Z=%f, A=%f WHERE ID=%d",
	xSafe[safeid][safe_Pos][0], xSafe[safeid][safe_Pos][1], xSafe[safeid][safe_Pos][2], xSafe[safeid][safe_Pos][3], safeid);
	mysql_query(ourConnection, query);
	return 1;
}
/*
forward LoadxSafes();
public LoadxSafes()
{
	new rows = cache_num_rows();
	new id, loaded;
 	if(rows)
  	{
		while(loaded < rows)
		{
  			cache_get_field_content_int(loaded, "ID", id);
		    cache_get_field_content_float(loaded, "X", xSafe[id][safe_Pos][0]);
		    cache_get_field_content_float(loaded, "Y", xSafe[id][safe_Pos][1]);
		    cache_get_field_content_float(loaded, "Z", xSafe[id][safe_Pos][2]);
		    cache_get_field_content_float(loaded, "A", xSafe[id][safe_Pos][3]);

			xSafe[id][safe_Obj] = CreateObject(2332, xSafe[id][safe_Pos][0], xSafe[id][safe_Pos][1], xSafe[id][safe_Pos][2], 0.0, 0.0, xSafe[id][safe_Pos][3]);

			Iter_Add(xSafes, id);
			loaded++;
		}
	}
	printf("[xRobbery] %d kasa yuklendi.", loaded);
	return 1;
}
*/
stock CreatexSafe(Float:x, Float:y, Float:z, Float:a)
{
	new id = Iter_Free(xSafes);
	xSafe[id][safe_Obj] = CreateObject(2332, x, y, z, 0.0, 0.0, a);
	xSafe[id][safe_Pos][0] = x;
	xSafe[id][safe_Pos][1] = y;
	xSafe[id][safe_Pos][2] = z;
	xSafe[id][safe_Pos][3] = a;

	new query[256];
	format(query, sizeof(query),"INSERT INTO `xRob_Safes` (`ID`,`X`,`Y`,`Z`,`A`) VALUES ('%d','%f','%f','%f','%f')",
	id, x, y, z, a);
	mysql_query(ourConnection, query);
	Iter_Add(xSafes, id);
	return id;
}

stock GetNearestSafeID(playerid)
{
	new Float:pos[2];
	foreach(new i : xSafes)
	{
		GetXYInFrontOfSafe(i, pos[0], pos[1], 0.7);
		if(IsPlayerInRangeOfPoint(playerid, 1, pos[0], pos[1], xSafe[i][safe_Pos][2])) return i;
	}
	return -1;
}

stock GetXYInFrontOfSafe(safeid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;

	x = xSafe[safeid][safe_Pos][0];
	y = xSafe[safeid][safe_Pos][1];
	a = xSafe[safeid][safe_Pos][3];
	a += 180;

	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}

stock GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	// Created by Y_Less

	new Float:a;

	GetPlayerPos(playerid, x, y, a);
	GetPlayerFacingAngle(playerid, a);

	if (GetPlayerVehicleID(playerid)) {
	    GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}

	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}

TimeConvert(time) { // Forum.sa-mp 'The_Gangstas'tan al�nt�d�r.
    new minutes;
    new seconds;
    new string[128];
    if(time > 59){
        minutes = floatround(time/60);
        seconds = floatround(time - minutes*60);
        if(seconds>9)format(string,sizeof(string),"%d:%d",minutes,seconds);
        else format(string,sizeof(string),"%d:0%d",minutes,seconds);
    }
    else{
        seconds = floatround(time);
        if(seconds>9)format(string,sizeof(string),"0:%d",seconds);
        else format(string,sizeof(string),"0:0%d",seconds);
    }
    return string;
}

stock SetPlayerLookAt(playerid, Float:X, Float:Y) // Forum.sa-mp 'Write'dan a�nt�d�r.
{
	new Float:Px, Float:Py, Float: Pa;
	GetPlayerPos(playerid, Px, Py, Pa);
	Pa = floatabs(atan((Y-Py)/(X-Px)));
	if (X <= Px && Y >= Py) Pa = floatsub(180, Pa);
	else if (X < Px && Y < Py) Pa = floatadd(Pa, 180);
	else if (X >= Px && Y <= Py) Pa = floatsub(360.0, Pa);
	Pa = floatsub(Pa, 90.0);
	if (Pa >= 360.0) Pa = floatsub(Pa, 360.0);
	SetPlayerFacingAngle(playerid, Pa);
}

public OnVehicleSpawn(vehicleid)
{
	if(HasNoEngine(vehicleid))
		ToggleVehicleEngine(vehicleid, true);

	printf("[DEBUG] Vehicle ID %i was respawned.", vehicleid);
 	DestroyObject(obj[vehicleid]);
  	DestroyObject(obj2[vehicleid]);
   	Flasher[vehicleid] = 0;
	return 1;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
    if(listid == skins)
    {
        if(response)
        {
            SendClientMessage(playerid, COLOR_WHITE, "New clothes bought. ($50)");
            SetPlayerSkin(playerid, modelid);
            GiveMoney(playerid, -50);
            PlayerInfo[playerid][pLastSkin] = modelid;
            SaveCharacter(playerid);
        }
    }
    return 1;
}

public TSC_OnClientConnect(clientid, nickname[])
{
    new client_ip[22];
    TSC_GetClientIpAddress(clientid, client_ip, sizeof client_ip);

    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(!strcmp(ReturnIP(i), client_ip))
        {
            TSClientID[i] = clientid;
            client_found = 1;
        }
    }

    if(!client_found)
        TSC_SendClientMessage(clientid, "We didn't find you ingame. Connect to the server and reconnect on TS.");

    return 1;
}

// Forwards //

forward timerAttachWorm(playerid);
public timerAttachWorm(playerid)
{
    if(AttachWorm[playerid] > 0)
    {
        new string[128];
        format(string,50,"~w~Attaching...", AttachWorm[playerid]);
        GameTextForPlayer(playerid,string,800,1);
        AttachWorm[playerid] = AttachWorm[playerid] - 1;
	    format(string, sizeof(string), "* %s is trying to attach a worm to his fishing hook.", ReturnName(playerid));
	    SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 100.0, 10000);
    }
    else
    {
		TogglePlayerControllable(playerid,1);
		KillTimer(TimerAttachWorm[playerid]);
		WormAttached[playerid] = 1;
		attachingw[playerid] = 0;
		SendClientMessage(playerid, COLOR_WHITE, "You have attached the worm to the hook.");
	}
	return 1;
}

forward FishChance(playerid);
public FishChance(playerid)
{
	new
	fishchance = 0 + random(30);
	if(fishchance == 0)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You have caught a Salmon. (5g)");
		PlayerInfo[playerid][pFishes] += 5;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 1)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You have caught a Lobster. (20g)");
		PlayerInfo[playerid][pFishes] += 20;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 2)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You have caught a Salmon. (5g)");
		PlayerInfo[playerid][pFishes] += 5;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 3)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You have caught an Angelfish. (1g)");
		PlayerInfo[playerid][pFishes] += 1;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 4)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "You reel the line in and notice that the worm is gone.");
	}
	else if(fishchance == 5)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You have caught an Angelfish. (1g)");
		PlayerInfo[playerid][pFishes] += 1;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 6)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "You reel the line in and notice that the worm is gone.");
	}
	else if(fishchance == 7)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You have caught an Angelfish. (1g)");
		PlayerInfo[playerid][pFishes] += 1;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 8)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You have caught an Angelfish. (1g)");
		PlayerInfo[playerid][pFishes] += 1;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 9)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You have caught a Salmon. (5g)");
		PlayerInfo[playerid][pFishes] += 5;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 10)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "You reel the line in and notice that the worm is gone.");
	}
	else if(fishchance == 11)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You have caught a Lobster. (20g)");
		PlayerInfo[playerid][pFishes] += 20;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 12)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "You reel the line in and notice that the worm is gone.");
	}
	else if(fishchance == 13)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You have caught a Lobster! (20g)");
		PlayerInfo[playerid][pFishes] += 20;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 14)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You have caught an Angelfish. (1g)");
		PlayerInfo[playerid][pFishes] += 1;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 15)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You have caught a Shark! (100g)");
		PlayerInfo[playerid][pFishes] += 100;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 16)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "You reel the line in and notice that the worm is gone.");
	}
	else if(fishchance == 17)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You have caught an Angelfish. (1g)");
		PlayerInfo[playerid][pFishes] += 1;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 18)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You have caught a Salmon. (5g)");
		PlayerInfo[playerid][pFishes] += 5;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 19)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "You reel the line in and notice that the worm is gone.");
	}
	else if(fishchance == 20)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You have caught an Angelfish. (1g)");
		PlayerInfo[playerid][pFishes] += 1;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 21)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You have caught an Angelfish. (1g)");
		PlayerInfo[playerid][pFishes] += 1;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 22)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "You reel the line in and notice that the worm is gone.");
	}
	else if(fishchance == 23)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You have caught a Salmon. (5g)");
		PlayerInfo[playerid][pFishes] += 5;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 24)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "You reel the line in and notice that the worm is gone.");
	}
	else if(fishchance == 25)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You have caught an Angelfish. (1g)");
		PlayerInfo[playerid][pFishes] += 1;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 26)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You have caught a Salmon. (5g)");
		PlayerInfo[playerid][pFishes] += 5;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 27)
	{
		SendClientMessage(playerid, COLOR_LIGHTRED, "You reel the line in and notice that the worm is gone.");
	}
	else if(fishchance == 28)
	{
		SendClientMessage(playerid, COLOR_WHITE, "You have caught an Angelfish. (1g)");
		PlayerInfo[playerid][pFishes] += 1;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 29)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You have caught a Lobster. (20g)");
		PlayerInfo[playerid][pFishes] += 20;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	else if(fishchance == 30)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You have caught a Shark! (100g)");
		PlayerInfo[playerid][pFishes] += 100;
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	}
	return 1;
}

forward timerFish(playerid);
public timerFish(playerid)
{
    if(fish[playerid] > 0)
    {
        new string[128];
        format(string,50,"~w~FISHING...", fish[playerid]);
        GameTextForPlayer(playerid,string,1300,1);
        fish[playerid] = fish[playerid] - 1;
	    format(string, sizeof(string), "* %s is fishing.", ReturnName(playerid));
	    SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 100.0, 10000);
    }
    else
    {
		TogglePlayerControllable(playerid,1);
		KillTimer(TimerFish[playerid]);
		FishChance(playerid);
		ClearAnimations(playerid);
		Fishing[playerid] = false;
	}
	return 1;
}

forward ServerRestart(playerid);
public ServerRestart(playerid)
{
    SendClientMessageToAll(COLOR_LIGHTRED, "[SERVER:] The server is restarting.");
    SetTimer("restartmsg", 100, false);
    return 1;
}

forward restartmsg(playerid);
public restartmsg(playerid)
{
    foreach (new i : Player)
    Kick(i);
    SetTimer("GmX", 1000, false);
    return 1;
}

forward GmX(playerid);
public GmX(playerid)
{
    foreach (new i : Player)
    Kick(i);
    SendRconCommand("gmx");
    return 1;
}

forward DragPlayer(dragger, dragee);
public DragPlayer(dragger, dragee)
{
	if(!IsPlayerConnected(dragee))
	{
		SetPVarInt(dragger, "DraggingPlayer", INVALID_PLAYER_ID);
		SendErrorMessage(dragger, "The player (%s) you were dragging has disconnected.", ReturnName(dragee));
	}
	if(GetPVarInt(dragger, "DraggingPlayer") != INVALID_PLAYER_ID)
	{
		new Float:dX, Float:dY, Float:dZ;
		GetPlayerPos(dragger, dX, dY, dZ);
		floatsub(dX, 0.4);
		floatsub(dY, 0.4);

		SetPVarFloat(dragee, "DragX", dX);
		SetPVarFloat(dragee, "DragY", dY);
		SetPVarFloat(dragee, "DragZ", dZ);
		SetPVarInt(dragee, "DragWorld", GetPlayerVirtualWorld(dragger));
		SetPVarInt(dragee, "DragInt", GetPlayerInterior(dragger));
		Streamer_UpdateEx(dragee, dX, dY, dZ);
		SetPlayerPos(dragee, dX, dY, dZ);
		SetPlayerInterior(dragee, GetPlayerInterior(dragger));
		SetPlayerVirtualWorld(dragee, GetPlayerVirtualWorld(dragger));
	}
	return 1;
}

forward WhitelistTimer(playerid);
public WhitelistTimer(playerid)
{
	Kick(playerid);
	return 1;
}

public JailTimer()
{
	new string[128], string2[128];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(PlayerInfo[i][pInJail] == 1)
	    {
	    	if(PlayerInfo[i][pJailTime] != 0)
	    	{
				PlayerInfo[i][pJailTime]--;
				format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Time Left: ~g~%d seconds.",PlayerInfo[i][pJailTime]);
   				GameTextForPlayer(i, string, 999, 3);
			}
			if(PlayerInfo[i][pJailTime] == 0)
			{
			    PlayerInfo[i][pJailTime] = 0;
				SendClientMessage(i, COLOR_BSSD,"[INFO:] You have served your sentence, you are now free to go.");
				TogglePlayerControllable(i, 0);
                SetTimerEx("Freeze", 5000, false, "i", i);
	  			SetPlayerPos(i, -2654.1282,2242.8782,1008.9949);
				PlayerInfo[i][pInJail] = 0;
			}
		}
        if(PlayerInfo[i][pRobbing] == 1)
	    {
	    	if(PlayerInfo[i][pRobTime] != 0)
	    	{
				PlayerInfo[i][pRobTime]--;
				format(string2, sizeof(string2), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Time Left: ~g~%d seconds.",PlayerInfo[i][pRobTime]);
   				GameTextForPlayer(i, string2, 999, 3);
			}
			if(PlayerInfo[i][pRobTime] == 0)
			{
			    PlayerInfo[i][pRobTime] = 0;
				PlayerInfo[i][pRobbing] = 0;
			}
		}
	}
	return 1;
}

forward Speedometer();
public Speedometer()
{
	new vehicleid, Float:health;
	new fstring[32], string[512];

    foreach (new i : Player)
	{
		if(IsPlayerConnected(i) && IsPlayerInAnyVehicle(i))
		{
			vehicleid = GetPlayerVehicleID(i);
			GetVehicleHealth(vehicleid, health);

			string = "~w~";
			strcat(string, "~w~~h~fuel: ~g~", sizeof(string));
			fstring = "iiiiiiiiii";
			if(VehicleInfo[vehicleid][eVehicleFuel] > 100.0) strins(fstring, "~r~", 10, sizeof(fstring));
			else if(VehicleInfo[vehicleid][eVehicleFuel] < 0.0) strins(fstring, "~r~", 0, sizeof(fstring));
			else strins(fstring, "~r~", floatround(VehicleInfo[vehicleid][eVehicleFuel]/10.0), sizeof(fstring));
			strcat(string, fstring, sizeof(string));

			strcat(string, "~n~~w~~h~", sizeof(string));
			if(GetPVarInt(i, "Speedo")) format(fstring,sizeof(fstring),"mph: ~w~%d", GetPlayerSpeed(i, false));
			else format(fstring,sizeof(fstring),"kph: ~w~%d", GetPlayerSpeed(i, true));
			strcat(string, fstring, sizeof(string));

			PlayerTextDrawSetString(i, SpeedoText[i], string);
		}
	}
}

forward BankCheatRobTimer(playerid, bid);
public BankCheatRobTimer(playerid, bid) {
    new i = PlayerInfo[playerid][pInsideBusiness];
	if(ArmedRobbery[playerid] == 1)
	{
	    if(PlayerInfo[playerid][pInsideBusiness] != bid)
	 	{
	    	SendErrorMessage(playerid, "You've left the bank and failed to robbery");
			KillTimer(RobCheatTimer[playerid]);
			KillTimer(RobTimer[playerid]);
			KillTimer(ChanceRobbedTimer[playerid]);
			PlayerInfo[playerid][pRobTime] = 0;
			PlayerInfo[playerid][pRobbing] = 0;
		}
		return 1;
	}
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, BusinessInfo[i][eBusinessBankPickupLoc][0], BusinessInfo[i][eBusinessBankPickupLoc][1], BusinessInfo[i][eBusinessBankPickupLoc][2]))
	{
		SendErrorMessage(playerid, "You've left the vault and failed the robbery");
		KillTimer(RobCheatTimer[playerid]);
		KillTimer(RobTimer[playerid]);
		PlayerInfo[playerid][pRobTime] = 0;
		PlayerInfo[playerid][pRobbing] = 0;
	}
    return 1;
}

forward emptyinttimer(playerid, bid);
public emptyinttimer(playerid, bid) {

    foreach (new i : Player)
	if(PlayerInfo[i][pInsideBusiness] == bid)
	{
	    IntCheck[bid] = 0;
	    KillTimer(EmptyBizTimer[bid]);
	}
   	if(IntCheck[bid] <= 1)
  	{
  		EmptyBizTimer[bid] = SetTimerEx("emptybiztimer", 5000, true, "ii", playerid, bid);
	}
	IntCheck[bid] += 1;
    return 1;
}

forward emptybiztimer(playerid, bid);
public emptybiztimer(playerid, bid) {
	if(IntCheck[bid] >= 30)
	{
	    foreach (new i : Player)
	    if(InBellRegion[i] == 1){PlayerPlaySound(i, 0,0,0,0);}
		KillTimer(BellTimer[bid]);
		BellTimerQuit[bid] = 0;
		BusinessInfo[bid][eBusinessLocked] = true;
 		KillTimer(EmptyIntTimer[bid]);
 		KillTimer(EmptyBizTimer[bid]);
  		policetape[bid] = CreateDynamicObject(19834, -2501.28809, 2318.34619, 5.21966, -0.12000, -2.00000, 0.00000);
  		ActorBizGuard[bid] = CreateActor(71, -2501.5012,2319.5063,4.9844,30.1659);
   		BizOpenAgainTimer[bid] = SetTimerEx("bizopenagaintimer", 600000, false, "ii", playerid, bid);
   		IntCheck[bid] = 0;
   		ApplyActorAnimation(ActorBizGuard[bid], "DEALER", "DEALER_IDLE", 4.0, 0, 1, 1, 1, -1);
   	}
    return 1;
}

forward chancerobbedtimer(playerid, rand, bid);
public chancerobbedtimer(playerid, rand, bid)
{
    foreach (new i : Player)
	switch(rand)
	{
	case 0:
	{
 		BellTimer[bid] = SetTimerEx("belltimer", 2000, true, "i", bid);
		MoveDynamicObject(bankdoor, -2489.2602, 3477.0325, 2004.8538, 0.5,  0.00000, 0.00000, 0.00000);
		MoveDynamicObject(bankdoor2, -2481.3164, 3471.6060, 2004.8538, 0.5,  0.00000, 0.00000, 90.00000);
		SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Clerk: Okey okey! Dont shoot, we'll open the doors for you.");
		ApplyActorAnimation(bankworker1,"ped","handsup",4.1,0,0,0,1,5000);
		ApplyActorAnimation(bankworker2,"ped","handsup",4.1,0,0,0,1,5000);
		ApplyActorAnimation(bankworker3,"ped","handsup",4.1,0,0,0,1,5000);
		bankdoor_status = 1;
		bankdoor2_status = 1;
	}
	case 1 .. 3:
	{
 		BellTimer[bid] = SetTimerEx("belltimer", 2000, true, "i", bid);
		SendErrorMessage(playerid, "You failed to rob the the bank.");
		MoveDynamicObject(banksecdoor, -2480.6755, 3477.1306, 2006.7416, 0.5, 0.00000, 0.00000, -90.00000);
		ArmedRobbery[playerid] = 0;
		KillTimer(RobCheatTimer[playerid]);
	}
	}
	return 1;
}

forward belltimer(bid);
public belltimer(bid)
{
    BellTimerQuit[bid] += 1;
	foreach (new i : Player)
	if(BellTimerQuit[bid] <= 30)
	{
    	if(PlayerInfo[i][pInsideBusiness] == 7 || IsPlayerInRangeOfPoint(i, 20.0, BusinessInfo[bid][eBusinessEntrance][0], BusinessInfo[bid][eBusinessEntrance][1], BusinessInfo[bid][eBusinessEntrance][2])){PlayerPlaySound(i, 3401, 0, 0, 0);InBellRegion[i] = 1;}
    	else if(InBellRegion[i] == 1){PlayerPlaySound(i, 0,0,0,0);}
    }
    else
    {
        if(InBellRegion[i] == 1){PlayerPlaySound(i, 0,0,0,0);}
		KillTimer(BellTimer[bid]);
		BellTimerQuit[bid] = 0;
	}
    return 1;
}


forward bizopenagaintimer(playerid, bid);
public bizopenagaintimer(playerid, bid) {
	DestroyActor(ActorBizGuard[bid]);
	BusinessInfo[bid][eBusinessLocked] = false;
 	DestroyDynamicObject(policetape[bid]);
 	DestroyDynamicObject(banksecdoor);
 	DestroyDynamicObject(bankdoor);
 	DestroyDynamicObject(bankdoor2);
 	ClearActorAnimations(bankworker1);
 	ClearActorAnimations(bankworker2);
 	ClearActorAnimations(bankworker3);
 	bankdoor = CreateDynamicObject(19302, -2487.74023, 3477.03247, 2004.85376,   0.00000, 0.00000, 0.00000);//First door
	SetDynamicObjectMaterial(bankdoor,  0, 1649, "wglass", "carshowwin2", 0xFFFFFFFF);
	bankdoor2 = CreateDynamicObject(19302, -2481.31641, 3473.12598, 2004.85376,   0.00000, 0.00000, 90.00000); //Second door
	SetDynamicObjectMaterial(bankdoor2, 0, 1649, "wglass", "carshowwin2", 0xFFFFFFFF);
	banksecdoor = CreateDynamicObject(10671, -2480.67554, 3477.13062, 2008.99817,   0.00000, 0.00000, -90.00000);//Security gate
	SetDynamicObjectMaterial(banksecdoor,  0, 5779, "garaged_lawn", "alleydoor8", 0xFFFFFFFF);
	bankdoor_status = 0;
	bankdoor2_status = 0;
	doorbombstats1 = 0;
	doorbombstats2 = 0;
    return 1;
}

forward BankRobTimer(playerid);
public BankRobTimer(playerid) {
	new bid = PlayerInfo[playerid][pInsideBusiness];
	BagTimer[playerid] = SetTimerEx("bagtimer", 120000, false, "i", playerid);
	SetPlayerAttachedObject(playerid, 9, 1550, 1, 0.1399, -0.1710, 0.0000, 19.7000, 61.9000, -12.7999, 0.7219, 0.7529, 0.8559, 0, 0);
	new amount = 30000 + randomEx(20000,40000);
	PlayerInfo[playerid][pRobbedCash] = amount;
	PlayerInfo[playerid][pTimeRobbed] = ReturnDate();
	GiveMoney(playerid, amount);
    KillTimer(RobCheatTimer[playerid]);
    RobAgainTime[bid] = SetTimerEx("robagaintime", 3600000, false, "ii", playerid, bid);
    return 1;
}

forward bagtimer(playerid);
public bagtimer(playerid) {
	RemovePlayerAttachedObject(playerid, 9);
	KillTimer(BagTimer[playerid]);
    return 1;
}

forward robagaintime(playerid, bid);
public robagaintime(playerid, bid) {
	BusinessInfo[bid][eRobbed] = 0;
    return 1;
}

forward BombTimer(playerid, bid);
public BombTimer(playerid, bid)
{
    foreach (new i : Player)
	if(doorbombstats1 == 1)
	{
    	DestroyDynamicObject(doorbomb1);
    	DestroyDynamicObject(bankdoor);
    	bankdoor_status = 1;
    	doorbombstats1 = 0;
    	SendPoliceMessage(COLOR_COP, "** Bayside Bank: Bayside Bank: The Bayside bank's security door has been blown open. All units respond! **");
    	CreateExplosion(-2486.84351, 3477.07324, 2004.93872,0,3);
    	if(PlayerInfo[i][pInsideBusiness] == 7 || IsPlayerInRangeOfPoint(playerid, 20.0, BusinessInfo[bid][eBusinessEntrance][0], BusinessInfo[bid][eBusinessEntrance][1], BusinessInfo[bid][eBusinessEntrance][2])){PlayerPlaySound(i, 3401, 0, 0, 0);}
	    BellTimer[bid] = SetTimerEx("belltimer", 2000, true, "i", bid);
	}
	foreach (new i : Player)
	if(doorbombstats2 == 1)
	{
	    DestroyDynamicObject(doorbomb2);
	    DestroyDynamicObject(bankdoor2);
	    bankdoor2_status = 1;
	    doorbombstats2 = 0;
	    SendPoliceMessage(COLOR_COP, "** Bayside Bank: The Bayside bank's vault door has been blown open. All units respond! **");
	    CreateExplosion(-2481.24463, 3473.52148, 2004.93872,0,3);
		if(PlayerInfo[i][pInsideBusiness] == 7 || IsPlayerInRangeOfPoint(playerid, 20.0, BusinessInfo[bid][eBusinessEntrance][0], BusinessInfo[bid][eBusinessEntrance][1], BusinessInfo[bid][eBusinessEntrance][2]) && bankdoor_status != 1)
		{
			BellTimer[bid] = SetTimerEx("belltimer", 2000, true, "i", bid);
		}
	}
    return 1;
}

forward Freeze(playerid);
public Freeze(playerid) {
    TogglePlayerControllable(playerid, 1);
    return 1;
}

forward deadtimer(playerid);
public deadtimer(playerid)
{
	new Float:health;
	GetPlayerHealth(playerid,health);
	SetPlayerHealth(playerid,health-1);
	ApplyPlayerAnimation(playerid, "CRACK", "CRCKIDLE2", 4.0, 1, 0, 0, 0, 0, 1);
	SetPlayerArmedWeapon(playerid,0);
	return 1;
}

forward hospitaltimer(playerid);
public hospitaltimer(playerid)
{
	SCM(playerid, COLOR_WHITE, "You have been treated at the hospital. The hospital bill is $500.");
	GiveMoney(playerid, -500);
	SetPlayerHealth(playerid, 50.0);
	ClearAnimations(playerid);
	SetPlayerPos(playerid, -2491.6150, 2362.9348, 10.3187);
 	SetPlayerInterior(playerid, 0);
 	SetPlayerVirtualWorld(playerid, 0);
 	SetCameraBehindPlayer(playerid);
 	isDead[playerid] = false;
 	ClearAnimations(playerid);
	return 1;
}

forward MainTimer();
public MainTimer()
{
	new string[128];

    foreach (new i : Player)
	{
		if(IsPlayerConnected(i))
		{
		    if(GetPlayerState(i) == PLAYER_STATE_DRIVER && !HasNoEngine(GetPlayerVehicleID(i)))
			{
				new vehicleid = GetPlayerVehicleID(i);
    			if(VehicleInfo[vehicleid][eVehicleFuel] > 0)
				{
					VehicleInfo[vehicleid][eVehicleFuel] -= GetPlayerSpeed(i)/2000.0;
					if(VehicleInfo[vehicleid][eVehicleFuel] < 0)
					{
						ToggleVehicleEngine(vehicleid, false); VehicleInfo[vehicleid][eVehicleEngineStatus] = false;
						GameTextForPlayer(i, "~r~out of fuel", 3000, 3);
						SendClientMessage(i, COLOR_LIGHTRED, "This vehicle is out of fuel!");
					}
				}
			}
			if(RefuelTime[i] > 0)
			{
				new vehicleid = GetPlayerVehicleID(i);
				VehicleInfo[vehicleid][eVehicleFuel] += 2.0;
				RefuelTime[i]--;
				if(RefuelTime[i] == 0)
				{
					if(VehicleInfo[vehicleid][eVehicleFuel] > 100) (VehicleInfo[vehicleid][eVehicleFuel] = 100);
					new cost = floatround(VehicleInfo[vehicleid][eVehicleFuel]-GetPVarFloat(i, "Fuel"))*FUEL_PRICE;
					if(GetPlayerState(i) != PLAYER_STATE_DRIVER || VehicleInfo[vehicleid][eVehicleFuel] >= 100.0 || PlayerInfo[i][pMoney] < cost)
					{
						GiveMoney(i, -cost);
						format(string, sizeof(string), "~r~-$%d", cost);
						GameTextForPlayer(i, string, 2000, 3);
						format(string, sizeof(string), "You have paid $%d for the fuel.", cost);
						SendClientMessage(i, COLOR_WHITE, string);
						SetPVarInt(i, "FuelStation", 0);
						SetPVarFloat(i, "Fuel", 0.0);
					}
					else
					{
						RefuelTime[i] = 1;
						format(string, sizeof(string), "~w~refueling...~n~~r~-$%d", cost);
						GameTextForPlayer(i, string, 2000, 3);
					}
				}
			}
		}
	}
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    if(pickupid == Pickup[0])
    {
        GameTextForPlayer(playerid, "/Buyclothes", 5000, 5);
    }
    if(pickupid == Pickup[1])
    {
        GameTextForPlayer(playerid, "/Fshop", 5000, 5);
    }
    if(pickupid == Pickup[2])
	{
	    GameTextForPlayer(playerid, "/Fish", 5000, 5);
	}
 	if(pickupid == Pickup[3])
	{
	    GameTextForPlayer(playerid, "/Getjob", 5000, 5);
	}
 	if(pickupid == Pickup[4])
	{
	    GameTextForPlayer(playerid, "/Getjob", 5000, 5);
	}
 	if(pickupid == Pickup[5])
	{
	    GameTextForPlayer(playerid, "/Getjob", 5000, 5);
	}
	if(pickupid == Pickup[6])
	{
	    GameTextForPlayer(playerid, "/Climb", 5000, 5);
	}
	if(pickupid == Pickup[7])
	{
	    GameTextForPlayer(playerid, "/Getjob", 5000, 5);
	}
 	if(pickupid == Pickup[8])
  	{
        GameTextForPlayer(playerid, "~g~Welcome at the Fly job, use /flyinfo to know more", 3000, 3);
   	}
    return 1;
}

// END OF FUNCTIONS //

function:RefreshCharacters(playerid)
{
	SendClientMessage(playerid, COLOR_YELLOW, "Your character list has been refreshed.");

	new
		fetchChars[140];

	mysql_format(ourConnection, fetchChars, sizeof(fetchChars), "SELECT char_name, char_dbid FROM characters WHERE master_dbid = %i LIMIT 4", e_pAccountData[playerid][mDBID]);
	mysql_pquery(ourConnection, fetchChars, "DB_ListCharacters", "i", playerid);

	return 1;
}

function:Query_CreateCharacter(playerid)
{
	if(cache_num_rows())
	{
		return SendClientMessage(playerid, COLOR_RED, "[ERROR]: That character already exists. Please try again.");
	}
	else
	{
		new
			string[128]
		;

		for (new i = 0; i < 16; i++){SendClientMessage(playerid, -1, " "); }

		format (string, sizeof(string), "Your new characters name will be: {145F0B}%s", playerCharactersName[playerid]);
		SendClientMessage(playerid, -1, string);

		SendClientMessage(playerid, -1, " ");
		SendClientMessage(playerid, -1, "The next steps will require a background for your new character.");
		SendClientMessage(playerid, -1, "Please provide your characters date of birth. The format: {145F0B}08/12/2017");

		playerCharacterStep[playerid] = 2;
	}
	return 1;
}

function:SaveCharacterPos(playerid)
{
	new thread[256];

	GetPlayerPos(playerid, PlayerInfo[playerid][pLastPos][0], PlayerInfo[playerid][pLastPos][1], PlayerInfo[playerid][pLastPos][2]);
	GetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
	GetPlayerArmour(playerid, PlayerInfo[playerid][pArmour]);

	mysql_format(ourConnection, thread, sizeof(thread), "UPDATE characters SET pLastPosX = %f, pLastPosY = %f, pLastPosZ = %f, pHealth = %f, pArmour = %f, pLastInterior = %i, pLastWorld = %i, pInProperty = %i, pInBusiness = %i WHERE char_dbid = %i",

		PlayerInfo[playerid][pLastPos][0],
		PlayerInfo[playerid][pLastPos][1],
		PlayerInfo[playerid][pLastPos][2],
		PlayerInfo[playerid][pHealth],
		PlayerInfo[playerid][pArmour],
		GetPlayerInterior(playerid),
		GetPlayerVirtualWorld(playerid),
		PlayerInfo[playerid][pInsideProperty],
		PlayerInfo[playerid][pInsideBusiness],
		PlayerInfo[playerid][pDBID]);

	return mysql_tquery(ourConnection, thread);
}

function:SaveCharacter(playerid)
{
	GetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
	GetPlayerArmour(playerid, PlayerInfo[playerid][pArmour]);
	new query[500];

	mysql_format(ourConnection, query, sizeof(query), "UPDATE characters SET pHealth = %f, pArmour = %f WHERE acc_dbid = %i",
		PlayerInfo[playerid][pHealth],
		PlayerInfo[playerid][pArmour],
		PlayerInfo[playerid][pDBID]);
    mysql_tquery(ourConnection, query);

//	mysql_format(ourConnection, query, sizeof(query), "UPDATE masters SET forum_name = '%e', active_ip = '%e' WHERE acc_dbid = %i",
//		e_pAccountData[playerid][mForumName],
///		PlayerInfo[playerid][pActiveIP],
//		e_pAccountData[playerid][mDBID]);
//	mysql_tquery(ourConnection, query);

	mysql_format(ourConnection, query, sizeof(query), "UPDATE characters SET pAdmin = %i, pLastSkin = %i, pLevel = %i, pEXP = %i, pMoney = %i, pBank = %i, pPaycheck = %i, pPhone = %i, pLastOnline = '%e', pLastOnlineTime = %i, pAdminjailed = %i, pAdminjailTime = %i WHERE char_dbid = %i",
		PlayerInfo[playerid][pAdmin],
		PlayerInfo[playerid][pLastSkin],
		PlayerInfo[playerid][pLevel],
		PlayerInfo[playerid][pEXP],
		PlayerInfo[playerid][pMoney],
		PlayerInfo[playerid][pBank],
		PlayerInfo[playerid][pPaycheck],
		PlayerInfo[playerid][pPhone],
		ReturnDate(),
		PlayerInfo[playerid][pLastOnlineTime],
		PlayerInfo[playerid][pAdminjailed],
		PlayerInfo[playerid][pAdminjailTime],
		PlayerInfo[playerid][pDBID]);
	mysql_tquery(ourConnection, query);

	mysql_format(ourConnection, query, sizeof(query), "UPDATE characters SET pFaction = %i, pFactionRank = %i, pTimeplayed = %i, pMaskID = %i, pMaskIDEx = %i, pOfflinejailed = 0, pInJail = %i, pJailTime = %i, pJob = %i WHERE char_dbid = %i",
		PlayerInfo[playerid][pFaction],
		PlayerInfo[playerid][pFactionRank],
		PlayerInfo[playerid][pTimeplayed],
		PlayerInfo[playerid][pMaskID][0],
		PlayerInfo[playerid][pMaskID][1],
		PlayerInfo[playerid][pInJail],
		PlayerInfo[playerid][pJailTime],
		PlayerInfo[playerid][pJob],
		PlayerInfo[playerid][pDBID]);
	mysql_tquery(ourConnection, query);

	mysql_format(ourConnection, query, sizeof(query), "UPDATE characters SET pHasRadio = %i, pMainSlot = %i, pGascan = %i, pSpawnPoint = %i, pSpawnPointHouse = %i, pWeaponsLicense = %i, pDriversLicense = %i, pPrisonTimes = %i, pJailtimes = %i, pIsAlive = %i, pFishingRod = %i, pWorms = %i, pFishes = %i WHERE char_dbid = %i",
		PlayerInfo[playerid][pHasRadio],
		PlayerInfo[playerid][pMainSlot],
		PlayerInfo[playerid][pGascan],
		PlayerInfo[playerid][pSpawnPoint],
		PlayerInfo[playerid][pSpawnPointHouse],
		PlayerInfo[playerid][pWeaponsLicense],
		PlayerInfo[playerid][pDriversLicense],
		PlayerInfo[playerid][pPrisonTimes],
		PlayerInfo[playerid][pJailTimes],
		PlayerInfo[playerid][pIsAlive],
		PlayerInfo[playerid][pFishingRod],
		PlayerInfo[playerid][pWorms],
		PlayerInfo[playerid][pFishes],
		PlayerInfo[playerid][pDBID]);
	mysql_tquery(ourConnection, query);
	
    mysql_format(ourConnection, query, sizeof(query), "UPDATE characters SET pExplosives = %i, pTimeRobbed = '%e', pRobbedCash = %i, pActiveListings = %i WHERE char_dbid = %i",
		PlayerInfo[playerid][pExplosives],
		PlayerInfo[playerid][pTimeRobbed],
		PlayerInfo[playerid][pRobbedCash],
		PlayerInfo[playerid][pActiveListings],
		PlayerInfo[playerid][pDBID]);
	mysql_tquery(ourConnection, query);

	for(new i = 1; i < 3; i++)
	{
		mysql_format(ourConnection, query, sizeof(query), "UPDATE characters SET pRadio%i = %i WHERE char_dbid = %i",
			i,
			PlayerInfo[playerid][pRadio][i],
			PlayerInfo[playerid][pDBID]);
		mysql_tquery(ourConnection, query);
	}

	for(new i = 0; i < 12; i++)
	{
		mysql_format(ourConnection, query, sizeof(query), "UPDATE characters SET pWeapons%d = %i, pWeaponsAmmo%d = %i WHERE char_dbid = %i",
			i,
			PlayerInfo[playerid][pWeapons][i],
			i,
			PlayerInfo[playerid][pWeaponsAmmo][i],
			PlayerInfo[playerid][pDBID]);
		mysql_tquery(ourConnection, query);
	}

	for(new i = 1; i < MAX_PLAYER_VEHICLES; i++)
	{
		mysql_format(ourConnection, query, sizeof(query), "UPDATE characters SET pOwnedVehicles%d = %i WHERE char_dbid = %i", i, PlayerInfo[playerid][pOwnedVehicles][i], PlayerInfo[playerid][pDBID]);
		mysql_tquery(ourConnection, query);
	}
	return 1;
}

//General commands:
CMD:help(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_LIST, "Help:",
	"General Commands\n\
	Vehicle Commands\n\
	Job Commands\n\
	Property/Business Commands\n\
	Emotes/Animations\n",
 	"Select", "Close");
	return 1;
}

CMD:smugglehelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_CUBER, "_________________Smuggle Help:_________________");

	SendClientMessage(playerid, COLOR_CUBEG, "[HELP] Smugglig is Illigal. If caught by the police you will be arrested.");
	SendClientMessage(playerid, COLOR_CUBEG2, "[HELP] You need to use a boat in order to start smuggling.");
	SendClientMessage(playerid, COLOR_CUBEG, "[COMMANDS] /smuggle, /stopsmuggle");
	return 1;
}

CMD:stats(playerid, params[])
{
	new playerb;

	if(PlayerInfo[playerid][pAdmin])
	{
		if (sscanf(params, "I(-1)", playerb))
			return 1;

		if(playerb == -1)
		{
			return ShowCharacterStats(playerid, playerid);
		}
		else
		{
			if(!IsPlayerConnected(playerb))
				return SendErrorMessage(playerid, "The player you specified isn't connected.");

			if(e_pAccountData[playerid][mLoggedin] == false)
				return SendErrorMessage(playerid, "The player you specified isn't logged in.");

			ShowCharacterStats(playerb, playerid);
		}
	}
	else return ShowCharacterStats(playerid, playerid);
	return 1;
}

CMD:admins(playerid, params[])
{
	new bool:adminOn = false;

	foreach (new i : Player)
	{
		if (PlayerInfo[playerid][pAdmin]) adminOn = true;
	}

	if(adminOn == true)
	{
		SendClientMessage(playerid, COLOR_GREY, "Admins Online:");

		foreach(new i : Player)
		{
			if(PlayerInfo[i][pAdmin])
			{
				if(PlayerInfo[i][pAdminDuty])
				{
					SendClientMessageEx(playerid, COLOR_DARKGREEN, "(Administrative Level: %d) %s (%s) - Administrating", PlayerInfo[i][pAdmin], ReturnName(i), e_pAccountData[i][mForumName]);
				}
				else SendClientMessageEx(playerid, COLOR_WHITE, "(Administrative Level: %d) %s (%s)", PlayerInfo[i][pAdmin], ReturnName(i), e_pAccountData[i][mForumName]);
			}
		}
	}
	else
	{
		return SendClientMessage(playerid, COLOR_GREY, "There are no administrators' online.");
	}

	return 1;
}

CMD:re(playerid, params[])return cmd_report(playerid, params);
CMD:report(playerid, params[])
{
	if(isnull(params) || strlen(params) < 3)
		return SendUsageMessage(playerid, "/re(port) [text]");

	new
		showString[350]
	;

	format(showString, sizeof(showString), "{FFFFFF}Are you sure you want to send this report?\n\n{F81414}Remember that, reporting actions which do not happen at the moment is extremely difficult for online admins to handle on the spot, since no proof is presented to them.\n{FFFFFF}Report: %s", params);
	ShowPlayerDialog(playerid, DIALOG_REPORT, DIALOG_STYLE_MSGBOX, "Confirmation", showString, "Yes", "No");

	format(playerReport[playerid], 128, "%s", params);
	return 1;
}

CMD:o(playerid, params[]) return cmd_ooc(playerid, params);
CMD:ooc(playerid, params[])
{
	if(isnull(params))
		return SendUsageMessage(playerid, "/ooc [text]");

	if(!oocEnabled && !PlayerInfo[playerid][pAdmin])
		return SendErrorMessage(playerid, "OOC chat was disabled by an admin.");

	if(PlayerInfo[playerid][pAdmin] && strcmp(e_pAccountData[playerid][mForumName], "Null"))
		SendClientMessageToAllEx(COLOR_SAMP, "[OOC] %s (%s): %s", ReturnName(playerid), e_pAccountData[playerid][mForumName], params);

	else SendClientMessageToAllEx(COLOR_SAMP, "[OOC] %s: %s", ReturnName(playerid), params);
	return 1;
}

CMD:relog(playerid, params[])
{
	if(gettime() - PlayerInfo[playerid][pLastDamagetime] < 120)
		return SendServerMessage(playerid, "You took damage recently and can't relog yet.");

	if(PlayerInfo[playerid][pRelogging])
		return SendErrorMessage(playerid, "You're in the middle of relogging.");

	new
		str[128],
		Float:x,
		Float:y,
		Float:z
	;

	GetPlayerPos(playerid, x, y, z);

	format(str, sizeof(str), "%s initiated a relog.", ReturnName(playerid));
	SendAdminMessage(1, str);

	PlayerInfo[playerid][pRelogging] = true;
	PlayerInfo[playerid][pRelogCount] = 1;

	PlayerInfo[playerid][pRelogTD] = Create3DTextLabel("(( |------ ))\nRELOGGING", COLOR_DARKGREEN, x, y, z, 20.0, GetPlayerVirtualWorld(playerid), 1);
	Attach3DTextLabelToPlayer(PlayerInfo[playerid][pRelogTD], playerid, 0.0, 0.0, 0.1);

	PlayerInfo[playerid][pRelogTimer] = SetTimerEx("OnPlayerRelog", 3000, true, "i", playerid);

	TogglePlayerControllable(playerid, 0);
	SendServerMessage(playerid, "To circumvent abuse, you will be relogged shortly.");
	return 1;
}

CMD:pay(playerid, params[])
{
	new playerb, amount, emote[90], str[128];

	if(sscanf(params, "uiS('None')[90]", playerb, amount, emote))
		return SendUsageMessage(playerid, "/pay [playerid OR name] [amount] [emote (Optional)]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(!PlayerInfo[playerb][pLoggedin])
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	if(!IsPlayerNearPlayer(playerid, playerb, 5.0))
		return SendErrorMessage(playerid, "You aren't near that player.");

	if(amount > PlayerInfo[playerid][pMoney])
		return SendErrorMessage(playerid, "You don't have that amount of money.");

	if(gettime() - playerLastpay[playerid] < 3)
		return SendServerMessage(playerid, "Please wait before paying again.");

	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0); PlayerPlaySound(playerb, 1052, 0.0, 0.0, 0.0);
	playerLastpay[playerid] = gettime();

	SendClientMessageEx(playerid, COLOR_GREY, " You have sent %s, $%s.", ReturnName(playerb, 0), MoneyFormat(amount));
	SendClientMessageEx(playerb, COLOR_GREY, " You have received $%s from %s.", MoneyFormat(amount), ReturnName(playerid, 0));

	if(!strcmp(emote, "None"))
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s takes out some cash, and hands it to %s.", ReturnName(playerid, 0), ReturnName(playerb, 0));

	else SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s %s %s (( Cash exchange ))", ReturnName(playerid, 0), emote, ReturnName(playerb, 0));

	if(PlayerInfo[playerid][pLevel] <= 3 && PlayerInfo[playerb][pLevel] <= 3 || amount >= 50000)
	{
		format(str, sizeof(str), "%s has paid $%s to %s.", ReturnName(playerid), MoneyFormat(amount), ReturnName(playerb));
		SendAdminMessage(1, str);
	}

	GiveMoney(playerid, -amount); GiveMoney(playerb, amount);
	return 1;
}

CMD:isafk(playerid, params[])
{
	new
		playerb;

	if(sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/isafk [playerid OR name]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	if(GetTickCount() > (PlayerInfo[playerb][pPauseCheck]+2000))
		SendClientMessageEx(playerid, COLOR_GREY, "Player %s has been paused for %i seconds!", ReturnName(playerb), PlayerInfo[playerb][pPauseTime]);

	else SendClientMessageEx(playerid, COLOR_GREY, "Player %s is not paused.", ReturnName(playerb));

	return 1;
}

CMD:id(playerid, params[]) // This command was a hefty test. Can be commented out if need be.
{
	if(isnull(params))
		return SendUsageMessage(playerid, "/id [playerid OR name]");

	new
		bool:inputID = false,
		playerb
	;

	for(new ix = 0, j = strlen(params); ix < j; ix++)
	{
		if (params[ix] > '9' || params[ix] < '0')
		{
			inputID = false;
		}
		else inputID = true;
	}

	if(inputID)
	{
		playerb = strval(params);

		if(!IsPlayerConnected(playerb))
			return SendClientMessage(playerid, COLOR_RED, "Player not found.");

		SendClientMessageEx(playerid, COLOR_GREY, "(ID: %i) %s | Level: %i", playerb, ReturnName(playerb), PlayerInfo[playerb][pLevel]);
	}
	else
	{
		new
			bool:matchFound = false,
			bool:fullName = false,
			countMatches = 0,
			matchesFound[6],
			string[128]
		;

		for(new cc = 0; cc < 5; cc++) { matchesFound[cc] = INVALID_PLAYER_ID; }

		for(new i = 0, j = strlen(params); i < j; i++)
		{
			if (params[i] != '_')
			{
				fullName = false;
			}
			else
			{
				fullName = true;
			}
		}

		if(fullName)
		{
			foreach(new b : Player)
			{
				if(strfind(ReturnName(b), params, true) != -1)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "(ID: %i) %s | Level: %i", b, ReturnName(b), PlayerInfo[b][pLevel]);
				}
				else return SendClientMessage(playerid, COLOR_RED, "Player not found.");
			}
		}
		else
		{
			for(new a = 0; a < MAX_PLAYERS; a++)
			{
				if(IsPlayerConnected(a))
				{
					if(strfind(ReturnName(a, 0), params, true) != -1)
					{
						matchFound = true;
						countMatches ++;
					}
				}
			}

			if(matchFound)
			{
				for(new f = 0, g = GetPlayerPoolSize(), t = 0; f <= g; f++)
				{
					if(IsPlayerConnected(f) && strfind(ReturnName(f, 0), params, true) != -1)
					{
						matchesFound[t] = f;
						t++;

						if(t >= 5) break;
					}
				}

				if(countMatches != 0 && countMatches > 1)
				{
					for(new l = 0; l < sizeof(matchesFound); l++)
					{
						if(matchesFound[l] == INVALID_PLAYER_ID)
							continue;

						format(string, sizeof(string), "%s(ID: %i) %s, ", string, matchesFound[l], ReturnName(matchesFound[l]));

						if(l % 3 == 0 && l != 0 || l == 5-1)
						{
							SendClientMessage(playerid, COLOR_GREY, string);
							string[0] = 0;
						}
					}
				}
				else if(countMatches == 1)
				{
					SendClientMessageEx(playerid, COLOR_GREY, "(ID: %i) %s | Level: %i", matchesFound[0], ReturnName(matchesFound[0]), PlayerInfo[matchesFound[0]][pLevel]);
				}
			}
			else return SendClientMessage(playerid, COLOR_RED, "Player not found.");
		}
	}
	return 1;
}

CMD:mask(playerid, params[])
{
	if(PlayerInfo[playerid][pLevel] < 3 && !PlayerInfo[playerid][pAdmin])
		return SendErrorMessage(playerid, "You aren't level 3 or higher.");

	if(!PlayerInfo[playerid][pHasMask] && !PlayerInfo[playerid][pAdmin])
		return SendErrorMessage(playerid, "You don't have a mask.");

	if(!PlayerInfo[playerid][pMasked])
	{
		foreach(new i : Player)
		{
			if(!PlayerInfo[i][pAdminDuty])
				ShowPlayerNameTagForPlayer(i, playerid, 0);
		}

		PlayerInfo[playerid][pMasked] = true;
		GameTextForPlayer(playerid, "~p~YOUR MASK IS NOW ON", 3000, 5);
	}
	else
	{
		foreach(new i : Player)
		{
			ShowPlayerNameTagForPlayer(i, playerid, 1);
		}

		PlayerInfo[playerid][pMasked] = false;
		GameTextForPlayer(playerid, "~p~YOUR MASK IS NOW OFF", 3000, 5);
	}

	return 1;
}

CMD:buy(playerid, params[])
{
	new
		id = IsPlayerInBusiness(playerid)
	;

	if(!IsPlayerInBusiness(playerid))
		return SendErrorMessage(playerid, "You aren't in a business.");

	if(BusinessInfo[id][eBusinessType] != BUSINESS_TYPE_GENERAL)
		return SendErrorMessage(playerid, "You aren't in a store.");

	ShowBuylist(playerid);
	return 1;
}

/*CMD:setchannel(playerid, params[])
{
	new
		slot,
		channel
	;

	if(sscanf(params, "ii", channel, slot))
		return SendUsageMessage(playerid, "/setchannel [channel] [slot]");

	if(!PlayerInfo[playerid][pHasRadio])
		return SendErrorMessage(playerid, "You don't have a radio.");

	if(slot > 2 || slot < 1)
		return SendErrorMessage(playerid, "You specified an invalid slot. (1-2)");

	if(channel < 1 || channel > 1000000)
		return SendErrorMessage(playerid, "You specified an invalid channel. (1-1000000)");

	for(new i = 1; i < 3; i++)
	{
		if(PlayerInfo[i][pRadio][i] == channel)
		{
			SendErrorMessage(playerid, "Your radio slot %i already supports channel %i.", i, channel);
			return 1;
		}
	}

	if(channel == 911)
	{
		if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE)
			return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You're not authorized to use this channel.");
	}

	PlayerInfo[playerid][pRadio][slot] = channel;

	SendClientMessageEx(playerid, COLOR_YELLOWEX, "You're now listening to channel %i under slot %i.", channel, slot);
	SaveCharacter(playerid);
	return 1;
}*/

CMD:setslot(playerid, params[])
{
	new
		slot
	;

	if(sscanf(params, "i", slot))
		return SendUsageMessage(playerid, "/setslot [slot id]");

	if(!PlayerInfo[playerid][pHasRadio])
		return SendUsageMessage(playerid, "You don't own a radio.");

	if(slot > 2 || slot < 1)
		return SendErrorMessage(playerid, "You specified an invalid slot. (1-2)");

	PlayerInfo[playerid][pMainSlot] = slot;

	SendClientMessageEx(playerid, COLOR_YELLOWEX, "Your local radio slot is now %i.", slot);
	SaveCharacter(playerid);
	return 1;
}

CMD:makeadmin(playerid, params[])
{
   	new str[128], playerb, value;

    if(PlayerInfo[playerid][pAdmin] < 5 && !IsPlayerAdmin(playerid))
		return SCM( playerid, COLOR_GREY, "You're not authorized to use this command.");
    
    if(sscanf(params, "ui", playerb, value))
		return SCM(playerid, COLOR_GREY, "[Usage:] /makeadmin [playerid/partofname] [level 1-5].");
		
    if(value < 0 || value > 5)
		return SCM(playerid, COLOR_LIGHTRED, "Invalid administrator level, 0-5.");
    
    if(value == 0)
    {
        PlayerInfo[playerb][pAdmin] = value;
        format(str, sizeof(str), "%s has kicked %s from the Administration Team.", ReturnName(playerid), ReturnName(playerb));
        SendAdminMessage(1, str);
        SCMex(playerb, COLOR_RED, "You've been kicked from the Administration Team by: %s", ReturnName(playerid));
        return 1;
	}
	SCMex(playerb, COLOR_RED, "You've been made a level %i Administrator by: %s", value, ReturnName(playerid));
	format(str, sizeof(str), "%s has made %s a level %i Administrator.", ReturnName(playerid), ReturnName(playerb), value);
	SendAdminMessage(1, str);
	PlayerInfo[playerb][pAdmin] = value;
    return 1;
}

CMD:pr(playerid, params[]) return cmd_radio(playerid, params);
CMD:radio(playerid, params[])
{
	if(!PlayerInfo[playerid][pHasRadio])
		return SendUsageMessage(playerid, "You don't own a radio.");

	new
		local,
		channel
	;

	local = PlayerInfo[playerid][pMainSlot];
	channel = PlayerInfo[playerid][pRadio][local];

	if(!PlayerInfo[playerid][pRadio][local])
		return SendErrorMessage(playerid, "Your local radio slot isn't set to a channel.");

	if(isnull(params))
		return SendUsageMessage(playerid, "/r [text], /rlow [text], /r[ch] [text], /r[ch]low [text]");

	foreach(new i : Player)
	{
		for(new r = 1; r < 3; r ++)
		{
			if(PlayerInfo[i][pRadio][r] == channel)
			{
				if(r != PlayerInfo[i][pMainSlot])
					SendClientMessageEx(i, COLOR_RADIOEX, "**[CH: %d, S: %d] %s says: %s", PlayerInfo[i][pRadio][r], GetChannelSlot(i, channel), ReturnName(playerid, 0), params);

				else SendClientMessageEx(i, COLOR_RADIO, "**[CH: %d, S: %d] %s says: %s", PlayerInfo[i][pRadio][r], GetChannelSlot(i, channel), ReturnName(playerid, 0), params);
			}
		}
	}

	new Float:posx, Float:posy, Float:posz;
	GetPlayerPos(playerid, posx,posy,posz);

	foreach(new i : Player)
	{
	   	if(i == playerid)
	       continue;

		else if(IsPlayerInRangeOfPoint(i, 20.0, posx,posy,posz))
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "(Radio) %s says: %s", ReturnName(playerid, 0), params);
		}
	}
	return 1;
}

CMD:rlow(playerid, params[])
{
	if(!PlayerInfo[playerid][pHasRadio])
		return SendUsageMessage(playerid, "You don't own a radio.");

	new
		local,
		channel
	;

	local = PlayerInfo[playerid][pMainSlot];
	channel = PlayerInfo[playerid][pRadio][local];

	if(!PlayerInfo[playerid][pRadio][local])
		return SendErrorMessage(playerid, "Your local radio slot isn't set to a channel.");

	if(isnull(params))
		return SendUsageMessage(playerid, "/rlow [text]");

	foreach(new i : Player)
	{
		for(new r = 1; r < 3; r ++)
		{
			if(PlayerInfo[i][pRadio][r] == channel)
			{
				if(r != PlayerInfo[i][pMainSlot])
					SendClientMessageEx(i, COLOR_RADIOEX, "**[CH: %d, S: %d] %s says: %s", PlayerInfo[i][pRadio][r], GetChannelSlot(i, channel), ReturnName(playerid, 0), params);

				else SendClientMessageEx(i, COLOR_RADIO, "**[CH: %d, S: %d] %s says: %s", PlayerInfo[i][pRadio][r], GetChannelSlot(i, channel), ReturnName(playerid, 0), params);
			}
		}
	}

	new Float:posx, Float:posy, Float:posz;
	GetPlayerPos(playerid, posx,posy,posz);

	foreach(new i : Player)
	{
	   	if(i == playerid)
	       continue;

		else if(IsPlayerInRangeOfPoint(i, 5.0, posx,posy,posz))
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "(Radio) %s says[low]: %s", ReturnName(playerid, 0), params);
		}
	}
	return 1;
}

CMD:r2(playerid, params[])
{
	if(!PlayerInfo[playerid][pHasRadio])
		return SendUsageMessage(playerid, "You don't own a radio.");

	new
		channel
	;

	channel = PlayerInfo[playerid][pRadio][2];

	if(!PlayerInfo[playerid][pRadio][2])
		return SendErrorMessage(playerid, "Your local radio slot isn't set to a channel.");

	if(isnull(params))
		return SendUsageMessage(playerid, "/r2 [text]");

	foreach(new i : Player)
	{
		for(new r = 1; r < 3; r ++)
		{
			if(PlayerInfo[i][pRadio][r] == channel)
			{
				if(r != PlayerInfo[i][pMainSlot])
					SendClientMessageEx(i, COLOR_RADIOEX, "**[CH: %d, S: %d] %s says: %s", PlayerInfo[i][pRadio][r], GetChannelSlot(i, channel), ReturnName(playerid, 0), params);

				else SendClientMessageEx(i, COLOR_RADIO, "**[CH: %d, S: %d] %s says: %s", PlayerInfo[i][pRadio][r], GetChannelSlot(i, channel), ReturnName(playerid, 0), params);
			}
		}
	}

	new Float:posx, Float:posy, Float:posz;
	GetPlayerPos(playerid, posx,posy,posz);

	foreach(new i : Player)
	{
	   	if(i == playerid)
	       continue;

		else if(IsPlayerInRangeOfPoint(i, 20.0, posx,posy,posz))
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "(Radio) %s says: %s", ReturnName(playerid, 0), params);
		}
	}
	return 1;
}

CMD:r2low(playerid, params[])
{
	if(!PlayerInfo[playerid][pHasRadio])
		return SendUsageMessage(playerid, "You don't own a radio.");

	new
		channel
	;

	channel = PlayerInfo[playerid][pRadio][2];

	if(!PlayerInfo[playerid][pRadio][2])
		return SendErrorMessage(playerid, "Your local radio slot isn't set to a channel.");

	if(isnull(params))
		return SendUsageMessage(playerid, "/r2low [text]");

	foreach(new i : Player)
	{
		for(new r = 1; r < 3; r ++)
		{
			if(PlayerInfo[i][pRadio][r] == channel)
			{
				if(r != PlayerInfo[i][pMainSlot])
					SendClientMessageEx(i, COLOR_RADIOEX, "**[CH: %d, S: %d] %s says: %s", PlayerInfo[i][pRadio][r], GetChannelSlot(i, channel), ReturnName(playerid, 0), params);

				else SendClientMessageEx(i, COLOR_RADIO, "**[CH: %d, S: %d] %s says: %s", PlayerInfo[i][pRadio][r], GetChannelSlot(i, channel), ReturnName(playerid, 0), params);
			}
		}
	}

	new Float:posx, Float:posy, Float:posz;
	GetPlayerPos(playerid, posx,posy,posz);

	foreach(new i : Player)
	{
	   	if(i == playerid)
	       continue;

		else if(IsPlayerInRangeOfPoint(i, 6.0, posx,posy,posz))
		{
			SendClientMessageEx(playerid, COLOR_GRAD1, "(Radio) %s says[low]: %s", ReturnName(playerid, 0), params);
		}
	}
	return 1;
}

CMD:refill(playerid, params[])
{
	if(!PlayerInfo[playerid][pGascan])
		return SendErrorMessage(playerid, "You don't have any gascans.");

	if(IsPlayerInAnyVehicle(playerid))
		return SendErrorMessage(playerid, "You can't be in a vehicle.");

	if(GetNearestVehicle(playerid) == INVALID_VEHICLE_ID)
		return SendErrorMessage(playerid, "You aren't near a vehicle.");

	if(playerRefillingVehicle[playerid])
		return SendErrorMessage(playerid, "You're already refilling a vehicle.");

	new
		vehicleid = GetNearestVehicle(playerid),
		Float:x,
		Float:y,
		Float:z,
		Float:vx,
		Float:vy,
		Float:vz
	;

	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_PETROLCAP, x, y, z);
	GetVehiclePos(vehicleid, vx, vy, vz);

	GetPlayerPos(playerid, PlayerInfo[playerid][pLastPos][0], PlayerInfo[playerid][pLastPos][1], PlayerInfo[playerid][pLastPos][2]);

	if(!IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z))
		return SendErrorMessage(playerid, "You aren't near the vehicles gas cap.");

	if(VehicleInfo[vehicleid][eVehicleFuel] > 50)
		return SendErrorMessage(playerid, "This vehicle doesn't need fuel.");

	SendClientMessage(playerid, COLOR_ACTION, "You're starting to refill the vehicle.");
	SendClientMessage(playerid, COLOR_ACTION, "If you, or the vehicle moves then this process will be interrupted.");

	VehicleInfo[vehicleid][eVehicleRefillDisplay] = Create3DTextLabel("(( |------ ))\nREFILLING VEHICLE", COLOR_DARKGREEN, x, y, z, 25.0, 0, 1);
	Attach3DTextLabelToVehicle(VehicleInfo[vehicleid][eVehicleRefillDisplay], vehicleid, -0.0, -0.0, -0.0);

	PlayerInfo[playerid][pGascan]--;
	VehicleInfo[vehicleid][eVehicleRefillCount] = 1;

	playerRefillingVehicle[playerid] = true;
	playerRefillTimer[playerid] = SetTimerEx("OnGascanRefill", 4500, true, "iifff", playerid, vehicleid, vx, vy, vz);
	return 1;
}

CMD:damages(playerid, params[])
{
	new playerb;

	if(sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/damages [playerid OR name]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(!PlayerInfo[playerb][pLoggedin])
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	if(PlayerInfo[playerid][pAdminDuty])
	{
		ShowPlayerDamages(playerb, playerid, 1);
	}
	else
	{
		if(!IsPlayerNearPlayer(playerid, playerb, 5.0))
			return SendErrorMessage(playerid, "You aren't near that player.");

		if(GetPlayerTeam(playerb) == PLAYER_STATE_ALIVE)
			return SendErrorMessage(playerid, "That player isn't brutally wounded.");

		ShowPlayerDamages(playerb, playerid, 0);
	}
	return 1;
}

CMD:acceptdeath(playerid, params[])
{
	if(GetPlayerTeam(playerid) != PLAYER_STATE_WOUNDED)
		return SendErrorMessage(playerid, "You aren't brutally wounded.");

	CallLocalFunction("OnPlayerDead", "iii", playerid, INVALID_PLAYER_ID, -1, 0);
	return 1;
}

CMD:respawnme(playerid, params[])
{
	if(GetPlayerTeam(playerid) != PLAYER_STATE_DEAD)
		return SendErrorMessage(playerid, "You aren't dead right now.");

	if(gettime() - PlayerInfo[playerid][pRespawnTime] < 60)
		return SendClientMessageEx(playerid, COLOR_YELLOWEX, "-> You've only been dead for %i seconds. You need to wait at least 60 sec to respawn.", gettime() - PlayerInfo[playerid][pRespawnTime]);

	PlayerInfo[playerid][pRespawnTime] = 0;
	SetPlayerChatBubble(playerid, "Respawned", COLOR_WHITE, 20.0, 1500);

	TogglePlayerControllable(playerid, 1);
	SetPlayerHealth(playerid, 0);

	return 1;
}

CMD:setspawn(playerid, params[])
{
	new
		id;

	if(sscanf(params, "i", id))
	{
		SendUsageMessage(playerid, "/setspawn [spawn id]");
		SendClientMessage(playerid, COLOR_WHITE, "1. Los Santos, 2. Property, 3. Faction, 4, Last Location");
		return 1;
	}

	if(id > 4 || id < 1)
		return SendErrorMessage(playerid, "You specified an invalid ID.");

	switch(id)
	{
		case 1:
		{
			if(PlayerInfo[playerid][pSpawnPoint] == 0)
				return SendErrorMessage(playerid, "This is already your spawn point.");

			PlayerInfo[playerid][pSpawnPoint] = 0;
			SendServerMessage(playerid, "You will now spawn at the Bayside port.");
		}
		case 2:
		{
			if(!CountPlayerProperties(playerid))
				return SendErrorMessage(playerid, "You don't own any properties.");

			new
				str[128]
			;

			for(new i = 1, j = 0; i < MAX_PROPERTY; i++)
			{
				if(PropertyInfo[i][ePropertyOwnerDBID] != PlayerInfo[playerid][pDBID])
					continue;

				playerHouseSelect[playerid][j] = i;
				j++;

				if(j >= 3)
					break;
			}

			for(new c = 0; c < 3; c++)
			{
				if(playerHouseSelect[playerid][c])
				{
					format(str, sizeof(str), "%sHouse %i\n", str, c);
				}
			}

			ShowPlayerDialog(playerid, DIALOG_SELECT_HOUSE, DIALOG_STYLE_LIST, "Select A Property:", str, "Select", "Back");
		}
		case 3:
		{
			if(PlayerInfo[playerid][pSpawnPoint] == 2)
				return SendErrorMessage(playerid, "This is already your spawn point.");

			if(!PlayerInfo[playerid][pFaction])
				return SendErrorMessage(playerid, "You aren't in any faction.");

			PlayerInfo[playerid][pSpawnPoint] = 2;
			SendServerMessage(playerid, "You will now spawn at your faction.");
		}
		case 4:
		{
		    if(PlayerInfo[playerid][pSpawnPoint] == 3)
				return SendErrorMessage(playerid, "This is already your spawn point.");
				
            PlayerInfo[playerid][pSpawnPoint] = 3;
			SendServerMessage(playerid, "You will now spawn at your last location.");
		}
	}

	return 1;
}

CMD:levelup(playerid, params[])
{
	new
		exp_count,
		str[128]
	;

	exp_count = ((PlayerInfo[playerid][pLevel]) * 4 + 2);

	if(PlayerInfo[playerid][pEXP] < exp_count)
	{
		SendServerMessage(playerid, "You don't have enough EXP (%i) to level up.", exp_count);
		return 1;
	}

	PlayerInfo[playerid][pLevel]++;
	PlayerInfo[playerid][pEXP] = 0;

	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);

	format(str, sizeof(str), "~g~Leveled Up~n~~w~You leveled up to level %i", PlayerInfo[playerid][pLevel]);
	GameTextForPlayer(playerid, str, 5000, 1);

	SaveCharacter(playerid);
	return 1;
}

CMD:bank(playerid, params[])
{
	new
		id = IsPlayerInBusiness(playerid),
		amount
	;

	if(!id)
		return SendErrorMessage(playerid, "You aren't in a business.");

	if(BusinessInfo[id][eBusinessType] != BUSINESS_TYPE_BANK)
		return SendErrorMessage(playerid, "You aren't inside a bank.");

	if(sscanf(params, "d", amount))
		return SendUsageMessage(playerid, "/bank [deposit amount]");

	if(amount < 1 || amount > PlayerInfo[playerid][pMoney])
		return SendErrorMessage(playerid, "You can't deposit that amount.");

	PlayerInfo[playerid][pBank]+= amount;
	GiveMoney(playerid, -amount);

	SendClientMessageEx(playerid, COLOR_ACTION, "You have deposited $%s into your account, Total:$%s", MoneyFormat(amount), MoneyFormat(PlayerInfo[playerid][pBank]));
	SaveCharacter(playerid);
	return 1;
}

CMD:withdraw(playerid, params[])
{
	new
		id = IsPlayerInBusiness(playerid),
		amount
	;

	if(!id)
		return SendErrorMessage(playerid, "You aren't in a business.");

	if(BusinessInfo[id][eBusinessType] != BUSINESS_TYPE_BANK && BusinessInfo[id][eBusinessType] != BUSINESS_TYPE_GENERAL)
		return SendErrorMessage(playerid, "You can't do this inside this business.");

	if(sscanf(params, "i", amount))
		return SendUsageMessage(playerid, "/withdraw [amount]");

	if(amount < 1 || amount > PlayerInfo[playerid][pBank])
		return SendErrorMessage(playerid, "You can't withdraw that amount.");

	PlayerInfo[playerid][pBank]-= amount;
	GiveMoney(playerid, amount);

	SendClientMessageEx(playerid, COLOR_ACTION, "You have withdrawn $%s from your account, Total:$%s", MoneyFormat(amount), MoneyFormat(PlayerInfo[playerid][pBank]));
	SaveCharacter(playerid);
	return 1;
}

CMD:balance(playerid, params[])
{
	new
		id = IsPlayerInBusiness(playerid)
	;

	if(!id)
		return SendErrorMessage(playerid, "You aren't in a business.");

	if(BusinessInfo[id][eBusinessType] != BUSINESS_TYPE_BANK && BusinessInfo[id][eBusinessType] != BUSINESS_TYPE_GENERAL)
		return SendErrorMessage(playerid, "You can't do this inside this business.");

	SendClientMessageEx(playerid, COLOR_ACTION, "You have $%s in your bank and $%s in your paycheck. (%s)", MoneyFormat(PlayerInfo[playerid][pBank]), MoneyFormat(PlayerInfo[playerid][pPaycheck]), ReturnDate());
	return 1;
}

CMD:h(playerid, params[]) return cmd_hangup(playerid, params);
CMD:hangup(playerid, params[])
{
	if(PlayerInfo[playerid][pPhoneOff])
		return SendErrorMessage(playerid, "Your cellphone is turned off.");

	if(PlayerInfo[playerid][pHandcuffed])
		return SendErrorMessage(playerid, "You can't use your phone right now.");

	new
		str[128]
	;

	if(playerPhone[playerid])
	{
		KillTimer(playerPhone[playerid]);

		SendClientMessage(playerid, COLOR_GREY, "[ ! ] You hung up.");
		return 1;
	}

	if(PlayerInfo[playerid][pPhoneline] == 999 || PlayerInfo[playerid][pPhoneline] == 911 || PlayerInfo[playerid][pPhoneline] == 457 || PlayerInfo[playerid][pPhoneline] == 686)
	{
		for(new i = 0; i < 2; i++) KillTimer(Player911Timer[i][playerid]);
		SendClientMessage(playerid, COLOR_GREY, "[ ! ] You hung up.");

		PlayerInfo[playerid][pPhoneline] = INVALID_PLAYER_ID;
		PlayerInfo[playerid][pCalling] = 0;

		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE){
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
		}
		return 1;
	}

	if(PlayerInfo[playerid][pPhoneline] == INVALID_PLAYER_ID)
		return SendErrorMessage(playerid, "You aren't in a call or being called.");

	if(PlayerInfo[playerid][pCalling] && PlayerInfo[playerid][pPhoneline] != INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COLOR_GREY, "[ ! ] You hung up.");
		SendClientMessage(PlayerInfo[playerid][pPhoneline], COLOR_GREY, "[ ! ] The call was disconnected.");

		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE){
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
		}

		PlayerInfo[ PlayerInfo[playerid][pPhoneline] ][pPhoneline] = INVALID_PLAYER_ID;
		PlayerInfo[ PlayerInfo[playerid][pPhoneline] ][pCalling] = 0;

		PlayerInfo[playerid][pCalling] = 0;
		PlayerInfo[playerid][pPhoneline] = INVALID_PLAYER_ID;
		printf("call 0");
		return 1;
	}

	if(!PlayerInfo[playerid][pCalling] && PlayerInfo[playerid][pPhoneline] != INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COLOR_GREY, "[ ! ] You hung up.");
		SendClientMessage(PlayerInfo[playerid][pPhoneline], COLOR_GREY, "[ ! ] They hung up.");

		printf("pPhoneline = %i", PlayerInfo[playerid][pPhoneline]);

		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE){
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			printf("call 1");
		}

		if(GetPlayerSpecialAction(PlayerInfo[playerid][pPhoneline]) == SPECIAL_ACTION_USECELLPHONE){
			SetPlayerSpecialAction(PlayerInfo[playerid][pPhoneline], SPECIAL_ACTION_STOPUSECELLPHONE);
			printf("call 2");
		}

		format(str, sizeof(str), "* %s puts their phone away.", ReturnName(playerid, 0));
		SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 3000);

		format(str, sizeof(str), "* %s puts their phone away.", ReturnName(PlayerInfo[playerid][pPhoneline], 0));
		SetPlayerChatBubble(PlayerInfo[playerid][pPhoneline], str, COLOR_EMOTE, 20.0, 3000);

		PlayerInfo[playerid][pCalling] = 0;
		PlayerInfo[ PlayerInfo[playerid][pPhoneline] ][pCalling] = 0;

		PlayerInfo[ PlayerInfo[playerid][pPhoneline] ][pPhoneline] = INVALID_PLAYER_ID;
		PlayerInfo[playerid][pPhoneline] = INVALID_PLAYER_ID;
		printf("call 3");
		return 1;
	}

	return 1;
}

CMD:p(playerid, params[]) return cmd_pickup(playerid, params);
CMD:pickup(playerid, params[])
{
	if(PlayerInfo[playerid][pPhoneOff])
		return SendErrorMessage(playerid, "Your cellphone is turned off.");

	if(PlayerInfo[playerid][pHandcuffed])
		return SendErrorMessage(playerid, "You can't use your phone right now.");

	if(PlayerInfo[playerid][pPhoneline] == INVALID_PLAYER_ID)
		return SendErrorMessage(playerid, "You aren't being called.");

	if(PlayerInfo[playerid][pPhoneline] != INVALID_PLAYER_ID && !PlayerInfo[playerid][pCalling])
		return SendErrorMessage(playerid, "You're already in a phone call.");

	SendClientMessage(PlayerInfo[playerid][pPhoneline], COLOR_GREY, "[ ! ] They picked up. You can talk now by using the chat box.");
	SendClientMessage(playerid, COLOR_WHITE, "HINT: You can talk now by using the chatbox.");

	PlayerInfo[playerid][pCalling] = 0;
	PlayerInfo[ PlayerInfo[playerid][pPhoneline] ][pCalling] = 0;

	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
	KillTimer(playerPhone[playerid]);

	playerPhone[playerid] = 0; playerPhone[ PlayerInfo[playerid][pPhoneline] ] = 0;
	return 1;
}

CMD:call(playerid, params[])
{
	new
		str[128],
		phone_number,
		playerb = INVALID_PLAYER_ID
	;

	if(GetPlayerTeam(playerid) != PLAYER_STATE_ALIVE)
		return SendErrorMessage(playerid, "You aren't alive.");

	if(PlayerInfo[playerid][pPhoneOff])
		return SendErrorMessage(playerid, "Your cellphone is turned off.");

	if(PlayerInfo[playerid][pHandcuffed])
		return SendErrorMessage(playerid, "You can't use your phone right now.");

	if(playerPhone[playerid])
		return SendErrorMessage(playerid, "You can't make a call right now.");

	if(sscanf(params, "i", phone_number))
		return SendUsageMessage(playerid, "/call [phone number]");

	foreach(new i : Player) if(PlayerInfo[i][pPhone] == phone_number){
			playerb = i;
	}

	format(str, sizeof(str), "* %s dials a number on their phone.", ReturnName(playerid, 0));
	SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 3000);
	SendClientMessage(playerid, COLOR_EMOTE, str);

	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
	PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);

	if(phone_number == 911)
	{
		PlayerInfo[playerid][pPhoneline] = 999;
		PlayerInfo[playerid][pCalling] = 1;

		Player911Timer[0][playerid] = SetTimerEx("On911Call", 2000, false, "i", playerid);
		return 1;
	}

	if(phone_number == 686)
	{
		PlayerInfo[playerid][pPhoneline] = 999;
		PlayerInfo[playerid][pCalling] = 1;

		Player911Timer[0][playerid] = SetTimerEx("OnTaxiCall", 2000, false, "i", playerid);
		return 1;
	}
	if(phone_number == 457)
	{
		PlayerInfo[playerid][pPhoneline] = 999;
		PlayerInfo[playerid][pCalling] = 1;

		Player911Timer[0][playerid] = SetTimerEx("OnTowCall", 2000, false, "i", playerid);
		return 1;
	}


	if(playerb == INVALID_PLAYER_ID)
	{
		playerPhone[playerid] = SetTimerEx("OnPhoneCall", 4500, false, "ii", playerid, 1);
		return 1;
	}

	if(PlayerInfo[playerb][pPhoneOff])
	{
		playerPhone[playerid] = SetTimerEx("OnPhoneCall", 3000, false, "ii", playerid, 2);
		return 1;
	}

	if(PlayerInfo[playerb][pCalling])
	{
		playerPhone[playerid] = SetTimerEx("OnPhoneCall", 3000, false, "ii", playerid, 3);
		return 1;
	}

	if(PlayerInfo[playerb][pPhoneline] != INVALID_PLAYER_ID)
	{
		playerPhone[playerid] = SetTimerEx("OnPhoneCall", 3300, false, "ii", playerid, 4);
		return 1;
	}

	SendNearbyMessage(playerb, 20.0, COLOR_EMOTE, "* %s's phone begins to ring.", ReturnName(playerid, 0));
	SendClientMessageEx(playerb, COLOR_GREY, "[ ! ] To pickup the call, use /pickup. Incoming call from %i.", PlayerInfo[playerid][pPhone]);

	PlayerInfo[playerid][pCalling] = 1; PlayerInfo[playerb][pCalling] = 1;

	PlayerInfo[playerid][pPhoneline] = playerb;
	PlayerInfo[playerb][pPhoneline] = playerid;

	playerPhone[playerb] = SetTimerEx("OnSuccessCall", 3000, true, "i", playerid);
	return 1;
}

CMD:sms(playerid, params[])
{
	new
		text[128],
		str[128],
		phone_number,
		playerb = INVALID_PLAYER_ID
	;

	if(PlayerInfo[playerid][pPhoneOff])
		return SendErrorMessage(playerid, "Your cellphone is turned off.");

	if(PlayerInfo[playerid][pHandcuffed])
		return SendErrorMessage(playerid, "You can't use your phone right now.");

	if(playerText[playerid])
		return SendClientMessage(playerid, COLOR_WHITE, "Please Wait.");

	if(sscanf(params, "is[128]", phone_number, text))
		return SendUsageMessage(playerid, "/sms [phone number] [text]");

	foreach(new i : Player) if(PlayerInfo[i][pPhone] == phone_number){
		playerb = i;
	}

	SendClientMessage(playerid, COLOR_GREY, "[ ! ] Your text message is being sent.");

	format(str, sizeof(str), "* %s takes out their cellphone.", ReturnName(playerid, 0));
	SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 3000);

	if(playerb == INVALID_PLAYER_ID)
	{
		playerText[playerid] = SetTimerEx("OnPhoneSMS", 3000, false, "ii", playerid, 1);
		return 1;
	}

	if(PlayerInfo[playerb][pPhoneOff])
	{
		playerText[playerid] = SetTimerEx("OnPhoneSMS", 3000, false, "ii", playerid, 2);
		return 1;
	}

	playerText[playerid] = SetTimerEx("OnPhoneSMS", 1500, false, "iiis", playerid, 3, playerb, text);
	return 1;
}

CMD:loudspeaker(playerid, params[])
{
	if(PlayerInfo[playerid][pPhoneOff])
		return SendErrorMessage(playerid, "Your cellphone is turned off.");

	if(PlayerInfo[playerid][pHandcuffed])
		return SendErrorMessage(playerid, "You can't use your phone right now.");

	if(PlayerInfo[playerid][pPhonespeaker])
	{
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s turns their phones loudspeaker off.", ReturnName(playerid, 0));
		PlayerInfo[playerid][pPhonespeaker] = false;
	}
	else
	{
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s turns their phones loudspeaker on.", ReturnName(playerid, 0));
		PlayerInfo[playerid][pPhonespeaker] = true;
	}

	return 1;
}

CMD:ammuhelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_DARKGREEN, "______________** AMMUNATION HELP **______________");
	SendClientMessage(playerid, COLOR_WHITE, "/buygun, /buyammo");
	return 1;
}

CMD:buygun(playerid, params[])
{
	new id = IsPlayerInBusiness(playerid), a_str[60], b_str[60];
	new totalPrice, ammo, str[128];

	if(!IsPlayerInBusiness(playerid))
		return SendErrorMessage(playerid, "You aren't in a business.");

 	if(BusinessInfo[id][eBusinessType] != BUSINESS_TYPE_AMMUNATION)
		return SendErrorMessage(playerid, "You aren't in an ammunation.");

	if(!PlayerInfo[playerid][pWeaponsLicense])
		return SendErrorMessage(playerid, "You dont have a weapons license.");

	if(sscanf(params, "s[60]S()[60]", a_str, b_str))
	{
		SendUsageMessage(playerid, "/buygun [weapon] [ammo]");
		SendClientMessage(playerid, COLOR_GRAD2, "[ colt: $12,500; ammo: $25 ] [ deagle: $17,500; ammo: $38 ] [ shotgun: $17,500; ammo: $38 ]");
		SendClientMessage(playerid, COLOR_GRAD2, "[ rifle: $25,000; ammo: $100 ] [ parachute: $1,250; ammo: $1,250 ] [ armor: $2,000; ammo: $2,000 ]");
		return 1;
	}

	if(!strcmp(a_str, "colt"))
	{
		if(sscanf(b_str, "i", ammo))
			return SendUsageMessage(playerid, "/buygun colt [ammo]");

		if(ammo < 1 || ammo > 32767)
			return SendErrorMessage(playerid, "Invalid Ammo.");

		totalPrice = ammo * 25 + 12500;

		format(str, sizeof(str), "Are you sure you want to purchase a Colt 45 for $%s?", MoneyFormat(totalPrice));
		ConfirmDialog(playerid, "Confirmation", str, "OnPlayerPurchaseWeapon", WEAPON_COLT45, ammo, totalPrice);
	}
	else if(!strcmp(a_str, "deagle"))
	{
		if(sscanf(b_str, "i", ammo))
			return SendUsageMessage(playerid, "/buygun deagle [ammo]");

		if(ammo < 1 || ammo > 32767)
			return SendErrorMessage(playerid, "Invalid Ammo.");

		totalPrice = ammo * 38 + 17500;

		format(str, sizeof(str), "Are you sure you want to purchase a Desert Eagle for $%s?", MoneyFormat(totalPrice));
		ConfirmDialog(playerid, "Confirmation", str, "OnPlayerPurchaseWeapon", WEAPON_DEAGLE, ammo, totalPrice);
	}
	else if(!strcmp(a_str, "shotgun"))
	{
		if(sscanf(b_str, "i", ammo))
			return SendUsageMessage(playerid, "/buygun shotgun [ammo]");

		if(ammo < 1 || ammo > 32767)
			return SendErrorMessage(playerid, "Invalid Ammo.");

		totalPrice = ammo * 38 + 17500;

		format(str, sizeof(str), "Are you sure you want to purchase a Shotgun for $%s?", MoneyFormat(totalPrice));
		ConfirmDialog(playerid, "Confirmation", str, "OnPlayerPurchaseWeapon", WEAPON_SHOTGUN, ammo, totalPrice);
	}
	else if(!strcmp(a_str, "rifle"))
	{
		if(sscanf(b_str, "i", ammo))
			return SendUsageMessage(playerid, "/buygun rifle [ammo]");

		if(ammo < 1 || ammo > 32767)
			return SendErrorMessage(playerid, "Invalid Ammo.");

		totalPrice = ammo * 100 + 25000;

		format(str, sizeof(str), "Are you sure you want to purchase a Rifle for $%s?", MoneyFormat(totalPrice));
		ConfirmDialog(playerid, "Confirmation", str, "OnPlayerPurchaseWeapon", WEAPON_RIFLE, ammo, totalPrice);
	}
	else if(!strcmp(a_str, "parachute"))
	{
		totalPrice = 1250;
		ammo = 1;

		format(str, sizeof(str), "Are you sure you want to purchase a Parachute for $%s?", MoneyFormat(totalPrice));
		ConfirmDialog(playerid, "Confirmation", str, "OnPlayerPurchaseWeapon", WEAPON_PARACHUTE, ammo, totalPrice);
	}
	else if(!strcmp(a_str, "armor"))
	{
		totalPrice = 2000;

		format(str, sizeof(str), "Are you sure you want to purchase Armor for $%s?", MoneyFormat(totalPrice));
		ConfirmDialog(playerid, "Confirmation", str, "OnPlayerPurchaseArmor");
	}

	return 1;
}

CMD:buyammo(playerid, params[])
{
	new id = IsPlayerInBusiness(playerid);
	new weapon[30], ammo, totalPrice, str[128];

	if(!IsPlayerInBusiness(playerid))
		return SendErrorMessage(playerid, "You aren't in a business.");

	if(BusinessInfo[id][eBusinessType] != BUSINESS_TYPE_AMMUNATION)
		return SendErrorMessage(playerid, "You aren't in an ammunation.");

	if(!PlayerInfo[playerid][pWeaponsLicense])
		return SendUnauthMessage(playerid);

	if(sscanf(params, "s[30]i", weapon, ammo))
	{
		SendUsageMessage(playerid, "/buyammo [weapon] [ammo]");
		SendClientMessage(playerid, COLOR_GRAD2, "[ colt: $25 ] [ deagle: $38 ] [ shotgun: $38 ] [ rifle: $100 ]");
		return 1;
	}

	if(ammo < 1 || ammo > 32767)
			return SendErrorMessage(playerid, "Invalid Ammo.");

	if(!strcmp(weapon, "colt"))
	{
		if(!PlayerHasWeapon(playerid, 22))
			return SendErrorMessage(playerid, "You don't have this weapon.");

		totalPrice = 25 * ammo;

		format(str, sizeof(str), "Are you sure you want to buy ammo for $%s?", MoneyFormat(totalPrice));
		ConfirmDialog(playerid, "Confirmation", str, "OnPlayerPurchaseAmmo", WEAPON_COLT45, ammo, totalPrice);
	}
	else if(!strcmp(weapon, "deagle"))
	{
		if(!PlayerHasWeapon(playerid, 24))
			return SendErrorMessage(playerid, "You don't have this weapon.");

		totalPrice = 38 * ammo;

		format(str, sizeof(str), "Are you sure you want to buy ammo for $%s?", MoneyFormat(totalPrice));
		ConfirmDialog(playerid, "Confirmation", str, "OnPlayerPurchaseAmmo", WEAPON_DEAGLE, ammo, totalPrice);
	}
	else if(!strcmp(weapon, "shotgun"))
	{
		if(!PlayerHasWeapon(playerid, 25))
			return SendErrorMessage(playerid, "You don't have this weapon.");

		totalPrice = 38 * ammo;

		format(str, sizeof(str), "Are you sure you want to buy ammo for $%s?", MoneyFormat(totalPrice));
		ConfirmDialog(playerid, "Confirmation", str, "OnPlayerPurchaseAmmo", WEAPON_SHOTGUN, ammo, totalPrice);
	}
	else if(!strcmp(weapon, "rifle"))
	{
		if(!PlayerHasWeapon(playerid, 33))
			return SendErrorMessage(playerid, "You don't have this weapon.");

		totalPrice = 100 * ammo;

		format(str, sizeof(str), "Are you sure you want to buy ammo for $%s?", MoneyFormat(totalPrice));
		ConfirmDialog(playerid, "Confirmation", str, "OnPlayerPurchaseAmmo", WEAPON_RIFLE, ammo, totalPrice);
	}

	return 1;
}

CMD:license(playerid, params[])
{
	new
		playerb;

	if(sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/license [playerid OR name]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "You specified an invalid player.");

	if(!PlayerInfo[playerb][pLoggedin])
		return SendErrorMessage(playerid, "You specified a player that isn't logged in.");

	if(!IsPlayerNearPlayer(playerid, playerb, 5.0))
		return SendErrorMessage(playerid, "You aren't near that player.");

	if(playerb != playerid)
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s shows %s their identification card.", ReturnName(playerid, 0), ReturnName(playerb, 0));

	else SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s looks at their identification card.", ReturnName(playerid, 0));

	ReturnLicenses(playerid, playerb);
	return 1;
}

CMD:licenseexam(playerid, params[])
{
	if(!IsPlayerInDMVVehicle(playerid))
		return SendErrorMessage(playerid, "You aren't in a license exam vehicle.");

	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendErrorMessage(playerid, "You aren't in the driver's seat.");

	if(PlayerTakingLicense[playerid])
		return SendErrorMessage(playerid, "You're already in middle of a test.");

	new
		vehicleid = GetPlayerVehicleID(playerid);

	PlayerTakingLicense[playerid] = true;
	PlayerLicenseTime[playerid] = 400;

	PlayersLicenseVehicle[playerid] = vehicleid;
	PlayerLicensePoint[playerid] = 0;

	ToggleVehicleEngine(vehicleid, true);
	VehicleInfo[vehicleid][eVehicleEngineStatus] = true;

	SetPlayerCheckpoint(playerid, -2463.5115,2295.8362,4.2803, 3.0);
	DMVcp[playerid] = 1;
 	SCM(playerid, COLOR_WHITE, "* Drive through all of the checkpoints slowly to pass the test. Check your mini-map if you can't see the checkpoints.");
 	SCM(playerid, COLOR_WHITE, "* If you leave the vehicle it will respawn.");
	return 1;
}

CMD:unimpound(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendErrorMessage(playerid, "You aren't in the driver's seat of a vehicle.");

	new vehicleid = GetPlayerVehicleID(playerid);

	if(VehicleInfo[vehicleid][eVehicleOwnerDBID] != PlayerInfo[playerid][pDBID])
		return SendErrorMessage(playerid, "You don't own this vehicle.");

	if(!VehicleInfo[vehicleid][eVehicleImpounded])
		return SendErrorMessage(playerid, "Your vehicle isn't impounded.");

	if(1500 > PlayerInfo[playerid][pMoney])
		return SendErrorMessage(playerid, "You don't have $1,500 to pay the fee.");

	VehicleInfo[vehicleid][eVehicleImpounded] = false;
	GiveMoney(playerid, -1500);

	SendServerMessage(playerid, "You have unimpounded your %s.", ReturnVehicleName(vehicleid));
	SaveVehicle(vehicleid);
	SaveVehicle(vehicleid);
	return 1;
}

CMD:fixr(playerid, params[])
{
	StopAudioStreamForPlayer(playerid);
	return 1;
}

CMD:setstation(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid) && !IsPlayerInProperty(playerid))
		return SendErrorMessage(playerid, "You are not near a radio.");

	new
		vehicleid = INVALID_VEHICLE_ID,
		id
	;

	if(IsPlayerInAnyVehicle(playerid))
	{
		vehicleid = GetPlayerVehicleID(playerid);

		if(GetPlayerVehicleSeat(playerid) > 1)
			return SendErrorMessage(playerid, "You aren't in the driver or front passenger seat.");

		if(!VehicleInfo[vehicleid][eVehicleHasXMR])
			return SendClientMessage(playerid, COLOR_YELLOW, "This vehicle does not have an XM-Radio.");
	}

	if(!strcmp(params, "off"))
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			if(!VehicleInfo[vehicleid][eVehicleXMROn])
				return SendErrorMessage(playerid, "The XM-Radio is not on.");

			PlayXMRStation(playerid, vehicleid, 0, true);
			return 1;
		}

		if(IsPlayerInProperty(playerid) != 0)
		{
			PlayXMRStation(playerid, INVALID_VEHICLE_ID, IsPlayerInProperty(playerid), true);
			return 1;
		}

		return 1;
	}

	if(sscanf(params, "i", id))
	{
		return ReturnXMRCategories(playerid);
	}

	if(!XMRStationInfo[id][eXMRStationID])
		return SendErrorMessage(playerid, "You specified an invalid Station ID.");

	SubXMRHolder[playerid] = id;
	PlayXMRStation(playerid, vehicleid, IsPlayerInProperty(playerid));
	return 1;
}

CMD:time(playerid, params[])
{
	cmd_ame(playerid, "checks the time.");

	new string[128], hour, minute, seconds;

	gettime(hour, minute, seconds);

	if(PlayerInfo[playerid][pAdminjailed] == true)
		format(string, sizeof(string), "~g~|~w~%02d:%02d~g~|~n~~w~Jail Time left: %d SEC", hour, minute, PlayerInfo[playerid][pAdminjailTime]);

	else
		format(string, sizeof(string), "~g~|~w~%02d:%02d~g~|", hour, minute);

	GameTextForPlayer(playerid, string, 2000, 1);

	return 1;
}

CMD:rcp(playerid, params[])
{
	DisablePlayerCheckpoint(playerid);

	//Disabling checkpoint referring variables:
	PlayerCheckpoint[playerid] = 0;
	return 1;
}

CMD:weapons(playerid, params[])
{
	SendClientMessage(playerid, COLOR_RED, "To throw away a weapon, type /leavegun [weapon ID]");

	for(new i = 0; i < 12; i++)
	{
		if(PlayerInfo[playerid][pWeaponsAmmo][i] > 0)
			SendClientMessageEx(playerid, COLOR_GREY, "[ID: %d] Weapon: [%s] - Ammo: [%d]", PlayerInfo[playerid][pWeapons][i], ReturnWeaponName(PlayerInfo[playerid][pWeapons][i]), PlayerInfo[playerid][pWeaponsAmmo][i]);
	}

	return 1;
}

CMD:lg(playerid, params[])return cmd_leavegun(playerid, params);
CMD:leavegun(playerid, params[])
{
	new
		weaponid,
		idx,
		id,
		Float:x,
		Float:y,
		Float:z
	;

	if(sscanf(params, "i", weaponid))
	{
		SendUsageMessage(playerid, "/leavegun [weapon id]");
		SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} To pick up the weapon, use /grabgun.");
		return 1;
	}

	if(weaponid < 1 || weaponid > 46 || weaponid == 35 || weaponid == 36 || weaponid == 37 || weaponid == 38 || weaponid == 39)
	    return SendErrorMessage(playerid, "You have specified an invalid weaponid.");

	if(!PlayerHasWeapon(playerid, weaponid))
		return SendErrorMessage(playerid, "You don't have that weapon.");

	for(new i = 0; i < sizeof(WeaponDropInfo); i++)
	{
		if(!WeaponDropInfo[i][eWeaponDropped])
		{
			idx = i;
			break;
		}
	}

	id = ReturnWeaponIDSlot(weaponid);
	GetPlayerPos(playerid, x, y, z);

	WeaponDropInfo[idx][eWeaponDropped] = true;
	WeaponDropInfo[idx][eWeaponDroppedBy] = PlayerInfo[playerid][pDBID];

	WeaponDropInfo[idx][eWeaponWepID] = weaponid;
	WeaponDropInfo[idx][eWeaponWepAmmo] = PlayerInfo[playerid][pWeaponsAmmo][id];

	WeaponDropInfo[idx][eWeaponPos][0] = x;
	WeaponDropInfo[idx][eWeaponPos][1] = y;
	WeaponDropInfo[idx][eWeaponPos][2] = z;

	WeaponDropInfo[idx][eWeaponInterior] = GetPlayerInterior(playerid);
	WeaponDropInfo[idx][eWeaponWorld] = GetPlayerVirtualWorld(playerid);

	RemovePlayerWeapon(playerid, weaponid);
	PlayerInfo[playerid][pWeapons][id] = 0;
	PlayerInfo[playerid][pWeaponsAmmo][id] = 0;

	WeaponDropInfo[idx][eWeaponObject] = CreateDynamicObject(
		ReturnWeaponsModel(weaponid),
		x,
		y,
		z - 1,
		80.0,
		0.0,
		0.0,
		GetPlayerVirtualWorld(playerid),
		GetPlayerInterior(playerid));

	WeaponDropInfo[idx][eWeaponTimer] = SetTimerEx("OnPlayerLeaveWeapon", 600000, false, "i", idx);
	SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} Your weapon will disappear in 10 minutes if it isn't picked up.");
	return 1;
}

CMD:gg(playerid, params[]) return cmd_grabgun(playerid, params);
CMD:grabgun(playerid, params[])
{
	new
		bool:foundWeapon = false,
		id,
		str[128]
	;

	for(new i = 0; i < sizeof(WeaponDropInfo); i++)
	{
		if(!WeaponDropInfo[i][eWeaponDropped])
			continue;

		if(IsPlayerInRangeOfPoint(playerid, 3.0, WeaponDropInfo[i][eWeaponPos][0], WeaponDropInfo[i][eWeaponPos][1], WeaponDropInfo[i][eWeaponPos][2]))
		{
			if(GetPlayerVirtualWorld(playerid) == WeaponDropInfo[i][eWeaponWorld])
			{
				foundWeapon = true;
				id = i;
			}
		}
	}

	if(foundWeapon)
	{
		GivePlayerGun(playerid, WeaponDropInfo[id][eWeaponWepID], WeaponDropInfo[id][eWeaponWepAmmo]);

		format(str, sizeof(str), "* %s picks up a %s.", ReturnName(playerid, 0), ReturnWeaponName(WeaponDropInfo[id][eWeaponWepID]));
		SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 3000);
		SendClientMessage(playerid, COLOR_EMOTE, str);

		WeaponDropInfo[id][eWeaponDropped] = false;
		WeaponDropInfo[id][eWeaponDroppedBy] = 0;

		WeaponDropInfo[id][eWeaponWepID] = 0; WeaponDropInfo[id][eWeaponWepAmmo] = 0;

		KillTimer(WeaponDropInfo[id][eWeaponTimer]);
		DestroyDynamicObject(WeaponDropInfo[id][eWeaponObject]);
	}
	else return SendServerMessage(playerid, "You aren't near a dropped weapon.");
	return 1;
}

CMD:enter(playerid, params[])
{
	new
		id,
		str[128]
	;
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 1555.5010,-1675.9463,16.1953)) // PD Door Entrance
 	{
  		TogglePlayerControllable(playerid, 0);
   		SetTimerEx("Freeze", 1000, false, "i", playerid);
   		SetPlayerInterior(playerid,6);
     	SetPlayerPos(playerid, 246.6760,62.8185,1003.6406);
      	SetPlayerVirtualWorld(playerid, 5);
      	return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 3.0, -2648.2256,2240.2087,1008.9949)) // PD Stair locker up
 	{
  		TogglePlayerControllable(playerid, 0);
   		SetTimerEx("Freeze", 1000, false, "i", playerid);
     	SetPlayerPos(playerid, -2648.3049,2240.0605,1013.9836);
   	 	SetPlayerVirtualWorld(playerid, 5);
   	 	return 1;
	}
   	if(IsPlayerInRangeOfPoint(playerid, 3.0, 1675.8707,-1635.4561,14.2266)) // FD Front door
    {
    	TogglePlayerControllable(playerid, 0);
    	SetTimerEx("Freeze", 1000, false, "i", playerid);
     	SetPlayerPos(playerid, 390.7417,173.6430,1008.3828);
      	SetPlayerVirtualWorld(playerid, 5);
      	SetPlayerInterior(playerid,3);
      	return 1;
	}
 	if(IsPlayerInRangeOfPoint(playerid, 3.0, -2537.2803,2356.0618,5.0134)) // FD back door back
  	{
   		TogglePlayerControllable(playerid, 0);
    	SetTimerEx("Freeze", 1000, false, "i", playerid);
     	SetPlayerPos(playerid, -2588.3545,4008.3154,2001.2579);
      	SetPlayerVirtualWorld(playerid, 5);
      	return 1;
	}
	for(new p = 1; p < MAX_PROPERTY; p++)
	{
		if(!PropertyInfo[p][ePropertyDBID])
			continue;

		if(IsPlayerInRangeOfPoint(playerid, 3.0, PropertyInfo[p][ePropertyEntrance][0], PropertyInfo[p][ePropertyEntrance][1], PropertyInfo[p][ePropertyEntrance][2]))
		{
			if(GetPlayerInterior(playerid) != PropertyInfo[p][ePropertyEntranceInterior])
				continue;

			if(GetPlayerVirtualWorld(playerid) != PropertyInfo[p][ePropertyEntranceWorld])
				continue;

			if(PropertyInfo[p][ePropertyLocked])
				return GameTextForPlayer(playerid, "~r~Locked", 3000, 1);

			PlayerInfo[playerid][pInsideProperty] = p;

			if(PropertyInfo[p][ePropertyBoomboxOn])
			{
				PlayAudioStreamForPlayer(playerid, PropertyInfo[p][ePropertyBoomboxURL]);
			}

			SetPlayerPos(playerid, PropertyInfo[p][ePropertyInterior][0], PropertyInfo[p][ePropertyInterior][1], PropertyInfo[p][ePropertyInterior][2]);

			SetPlayerVirtualWorld(playerid, PropertyInfo[p][ePropertyInteriorWorld]);
			SetPlayerInterior(playerid, PropertyInfo[p][ePropertyInteriorIntID]);

			TogglePlayerControllable(playerid, 0);
			SetTimerEx("OnPlayerEnterProperty", 2000, false, "ii", playerid, p);

		}
	}

	if((id = IsPlayerNearBusiness(playerid)) != 0)
	{
		if(BusinessInfo[id][eBusinessLocked])
			return GameTextForPlayer(playerid, "~r~Locked", 3000, 1);

		if(BusinessInfo[id][eBusinessType] == BUSINESS_TYPE_DEALERSHIP || BusinessInfo[id][eBusinessType] == BUSINESS_TYPE_DMV)
			return GameTextForPlayer(playerid, "~r~Closed", 3000, 1);

		if(BusinessInfo[id][eBusinessEntranceFee] > PlayerInfo[playerid][pMoney])
			return GameTextForPlayer(playerid, "~r~You can't afford this.", 3000, 1);

		if(PlayerInfo[playerid][pDBID] != BusinessInfo[id][eBusinessOwnerDBID] && BusinessInfo[id][eBusinessType] != BUSINESS_TYPE_BANK)
		{
			GiveMoney(playerid, -BusinessInfo[id][eBusinessEntranceFee]);
			BusinessInfo[id][eBusinessCashbox]+= BusinessInfo[id][eBusinessEntranceFee];
		}

		format(str, sizeof(str), "%s", BusinessInfo[id][eBusinessName]);
		GameTextForPlayer(playerid, str, 500, 1);

		SetPlayerPos(playerid, BusinessInfo[id][eBusinessInterior][0], BusinessInfo[id][eBusinessInterior][1], BusinessInfo[id][eBusinessInterior][2]);

		SetPlayerInterior(playerid, BusinessInfo[id][eBusinessInteriorIntID]);
		SetPlayerVirtualWorld(playerid, BusinessInfo[id][eBusinessInteriorWorld]);
		TogglePlayerControllable(playerid, 0);
    	SetTimerEx("Freeze", 1000, false, "i", playerid);

		PlayerInfo[playerid][pInsideBusiness] = id;

		SendBusinessType(playerid, id);
		return 1;
	}

	SendServerMessage(playerid, "You aren't near an entrance.");
	return 1;
}

CMD:exit(playerid, params[])
{
	new
		id
	;
 	if(IsPlayerInRangeOfPoint(playerid, 3.0, 246.6760,62.8185,1003.6406)) // PD Door Exit
  	{
   		TogglePlayerControllable(playerid, 0);
    	SetTimerEx("Freeze", 1000, false, "i", playerid);
    	SetPlayerInterior(playerid,0);
     	SetPlayerPos(playerid, 1553.1344,-1675.6215,16.1953);
      	SetPlayerVirtualWorld(playerid, 0);
      	return 1;
	}
  	if(IsPlayerInRangeOfPoint(playerid, 3.0, -2648.3049,2240.0605,1013.9836)) // PD Stair locker down
   	{
    	TogglePlayerControllable(playerid, 0);
    	SetTimerEx("Freeze", 1000, false, "i", playerid);
     	SetPlayerPos(playerid, -2648.2256,2240.2087,1008.9949);
      	SetPlayerVirtualWorld(playerid, 5);
      	return 1;
	}
 	if(IsPlayerInRangeOfPoint(playerid, 3.0, -2592.4727,4000.8035,2001.2579)) // FD front door itn
  	{
   		TogglePlayerControllable(playerid, 0);
    	SetTimerEx("Freeze", 1000, false, "i", playerid);
     	SetPlayerPos(playerid, 1675.8707,-1635.4561,14.2266);
      	SetPlayerVirtualWorld(playerid, 0);
      	SetPlayerInterior(playerid,0);
      	return 1;
	}
 	if(IsPlayerInRangeOfPoint(playerid, 3.0, -2588.3545,4008.3154,2001.2579)) // FD back door INT
  	{
   		TogglePlayerControllable(playerid, 0);
    	SetTimerEx("Freeze", 1000, false, "i", playerid);
     	SetPlayerPos(playerid, -2537.2803,2356.0618,5.0134);
      	SetPlayerVirtualWorld(playerid, 0);
      	return 1;
	}
	if(PlayerInfo[playerid][pEditingObject])
		return SendErrorMessage(playerid, "You can't leave while editing an object.");

	if((id = IsPlayerInProperty(playerid)) != 0)
	{
		if(!IsPlayerInRangeOfPoint(playerid, 3.0, PropertyInfo[id][ePropertyInterior][0], PropertyInfo[id][ePropertyInterior][1], PropertyInfo[id][ePropertyInterior][2]))
			return SendErrorMessage(playerid, "You aren't near the door.");

		SetPlayerPos(playerid, PropertyInfo[id][ePropertyEntrance][0], PropertyInfo[id][ePropertyEntrance][1], PropertyInfo[id][ePropertyEntrance][2]);

		SetPlayerVirtualWorld(playerid, PropertyInfo[id][ePropertyEntranceWorld]);
		SetPlayerInterior(playerid, PropertyInfo[id][ePropertyEntranceInterior]);
		TogglePlayerControllable(playerid, 0);
    	SetTimerEx("Freeze", 1000, false, "i", playerid);

		if(PropertyInfo[id][ePropertyBoomboxOn])
			StopAudioStreamForPlayer(playerid);

		PlayerInfo[playerid][pInsideProperty] = 0;
		return 1;
	}

	for(new i = 1; i < MAX_BUSINESS; i++)
	if(IsPlayerInRangeOfPoint(playerid, 3.0, BusinessInfo[i][eBusinessInterior][0], BusinessInfo[i][eBusinessInterior][1], BusinessInfo[i][eBusinessInterior][2]))
	{
		SetPlayerPos(playerid, BusinessInfo[i][eBusinessEntrance][0], BusinessInfo[i][eBusinessEntrance][1], BusinessInfo[i][eBusinessEntrance][2]);

		SetPlayerInterior(playerid, BusinessInfo[i][eBusinessInteriorExtIntID]);
		SetPlayerVirtualWorld(playerid, BusinessInfo[i][eBusinessInteriorExtWorld]);
		TogglePlayerControllable(playerid, 0);
	    SetTimerEx("Freeze", 1000, false, "i", playerid);

		PlayerInfo[playerid][pInsideBusiness] = 0;
		return 1;
	}
	SendErrorMessage(playerid, "You're not near any door");
	return 1;
}

//Vehicle commands:
CMD:vget(playerid, params[])
{
	new slotid;

	if(sscanf(params, "d", slotid))
	return SendUsageMessage(playerid, "/vehicle get [vehicle slot]");

	if(slotid < 1 || slotid > 5)
	return SendErrorMessage(playerid, "You specified an invalid slot.");

	if(!PlayerInfo[playerid][pOwnedVehicles][slotid])
	return SendErrorMessage(playerid, "You don't have a vehicle in that slot.");

	new threadLoad[128];

	for(new i = 0; i < MAX_VEHICLES; i++)
	{
	if(VehicleInfo[i][eVehicleDBID] == PlayerInfo[playerid][pOwnedVehicles][slotid])
	return SendErrorMessage(playerid, "That vehicle's already spawned.");
	}

	mysql_format(ourConnection, threadLoad, sizeof(threadLoad), "SELECT * FROM vehicles WHERE VehicleDBID = %i", PlayerInfo[playerid][pOwnedVehicles][slotid]);
	mysql_tquery(ourConnection, threadLoad, "Query_LoadPrivateVehicle", "id", playerid, slotid);
	return 1;
}

CMD:park(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
	return SendErrorMessage(playerid, "You aren't in any vehicle.");

	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)return SendErrorMessage(playerid, "You need to be driving your vehicle.");

	new
	oldcar = GetPlayerVehicleID(playerid);

	if(VehicleInfo[oldcar][eVehicleOwnerDBID] != PlayerInfo[playerid][pDBID])
	return SendErrorMessage(playerid, "You don't own this vehicle.");
	GetVehiclePos(oldcar, VehicleInfo[oldcar][eVehicleParkPos][0], VehicleInfo[oldcar][eVehicleParkPos][1], VehicleInfo[oldcar][eVehicleParkPos][2]);
	GetVehicleZAngle(oldcar, VehicleInfo[oldcar][eVehicleParkPos][3]);

	VehicleInfo[oldcar][eVehicleParkInterior] = GetPlayerInterior(playerid);
	VehicleInfo[oldcar][eVehicleParkWorld] = GetPlayerVirtualWorld(playerid);
	DestroyVehicle(oldcar);

	new newcar = CreateVehicle(VehicleInfo[oldcar][eVehicleModel], VehicleInfo[oldcar][eVehicleParkPos][0], VehicleInfo[oldcar][eVehicleParkPos][1], VehicleInfo[oldcar][eVehicleParkPos][2], VehicleInfo[oldcar][eVehicleParkPos][3], VehicleInfo[oldcar][eVehicleColor1], VehicleInfo[oldcar][eVehicleColor2], -1, VehicleInfo[oldcar][eVehicleSirens]);
	SetVehicleNumberPlate(newcar, VehicleInfo[oldcar][eVehiclePlates]);
	PutPlayerInVehicle(playerid, newcar, 0);
	VehicleInfo[newcar][eVehicleEngineStatus] = false;
	VehicleInfo[newcar][eVehicleExists] = true;
	VehicleInfo[newcar][eVehicleID] = newcar;
	VehicleInfo[newcar][eVehicleDBID] = VehicleInfo[oldcar][eVehicleDBID];
	VehicleInfo[newcar][eVehicleOwnerDBID] = VehicleInfo[oldcar][eVehicleOwnerDBID];
	VehicleInfo[newcar][eVehicleFaction] = VehicleInfo[oldcar][eVehicleFaction];
	VehicleInfo[newcar][eVehicleFuel] = VehicleInfo[oldcar][eVehicleFuel];
	VehicleInfo[newcar][eVehicleSirens] = VehicleInfo[oldcar][eVehicleSirens];
	VehicleInfo[newcar][eVehicleHasXMR] = VehicleInfo[oldcar][eVehicleHasXMR];
	VehicleInfo[newcar][eVehicleAlarmLevel] = VehicleInfo[oldcar][eVehicleAlarmLevel];
	VehicleInfo[newcar][eVehicleLockLevel] = VehicleInfo[oldcar][eVehicleLockLevel];
	VehicleInfo[newcar][eVehicleImmobLevel] = VehicleInfo[oldcar][eVehicleImmobLevel];
	SendClientMessageEx(playerid, COLOR_DARKGREEN, "You parked your %s.", ReturnVehicleName(oldcar));
	SaveVehicle(newcar);
	return 1;
}

CMD:buyvehicle(playerid, params[])
{
		new
			id,
			larstr[190],
			idx
		;

		for(new i = 1; i < MAX_PLAYER_VEHICLES; i++)
		{
			if(!PlayerInfo[playerid][pOwnedVehicles][i])
			{
				idx = i;
				break;
			}
		}

		if(!idx)
		{
			SendServerMessage(playerid, "You own the maximum amount of vehicles.");
			return 1;
		}

		if(!(id = IsPlayerNearBusiness(playerid)))
			return SendErrorMessage(playerid, "You aren't near a business.");

		if((id = IsPlayerNearBusiness(playerid)))
		{
			if(BusinessInfo[id][eBusinessType] != BUSINESS_TYPE_DEALERSHIP)
				return SendErrorMessage(playerid, "You aren't at a dealership.");

			for(new i = 0; i < sizeof(g_aDealershipCategory); i++)
			{
				format(larstr, sizeof(larstr), "%s%s\n", larstr, g_aDealershipCategory[i]);
			}

			PlayerInfo[playerid][pAtDealership] = id;
			ShowPlayerDialog(playerid, DIALOG_DEALERSHIP, DIALOG_STYLE_LIST, "Categories:", larstr, "Select", "Cancel");
		}
		return 1;
}
CMD:givecarkey(playerid, params[])
{
		if(!IsPlayerInAnyVehicle(playerid))
			return SendErrorMessage(playerid, "You aren't in any vehicle.");

		new
			playerb, vehicleid = GetPlayerVehicleID(playerid);

		if(VehicleInfo[vehicleid][eVehicleOwnerDBID] != PlayerInfo[playerid][pDBID])
			return SendErrorMessage(playerid, "You don't own this vehicle.");

		if(sscanf(params, "u", playerb))
			return SendUsageMessage(playerid, "/vehicle duplicatekey [playerid OR name]");

		if(playerb == playerid)return SendErrorMessage(playerid, "You can't give yourself a duplicate key.");

		if(!IsPlayerConnected(playerb))
			return SendErrorMessage(playerid, "The player you specified isn't connected.");

		if(e_pAccountData[playerb][mLoggedin] == false)
			return SendErrorMessage(playerid, "The player you specified isn't logged in.");

		if(!IsPlayerNearPlayer(playerid, playerb, 5.0))
			return SendErrorMessage(playerid, "You aren't near that player.");

		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s gives %s a key to their vehicle.", ReturnName(playerid, 0), ReturnName(playerb, 0));
		SendServerMessage(playerb, "%s gave you a key to their vehicle.", ReturnName(playerid, 0));

		GiveMoney(playerid, -500);
		SendServerMessage(playerid, "You gave %s a duplicatekey for $500.", ReturnName(playerb, 0));

		PlayerInfo[playerb][pDuplicateKey] = vehicleid;
		return 1;
}

CMD:destroycar(playerid, params[])
{
		if(!IsPlayerInAnyVehicle(playerid))
			return SendErrorMessage(playerid, "You aren't in any vehicle.");

		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)return SendErrorMessage(playerid, "You need to be driving your vehicle.");

		new
			str[160],
			vehicleid = GetPlayerVehicleID(playerid),
			cash_back
		;

		if(VehicleInfo[vehicleid][eVehicleOwnerDBID] != PlayerInfo[playerid][pDBID])
			return SendErrorMessage(playerid, "You don't own this vehicle.");

		for(new i = 0; i < sizeof(g_aDealershipData); i++)
		{
			if(g_aDealershipData[i][eDealershipModelID] == VehicleInfo[vehicleid][eVehicleModel])
			{
				cash_back = g_aDealershipData[i][eDealershipPrice] / 2;
			}
		}

		format(str, sizeof(str), "Are you sure you want to scrap your %s?\nYou'll receive a cashback of: $%s\n\n{FF6347}This action is permanent and cannot be undone.", ReturnVehicleName(vehicleid), MoneyFormat(cash_back));
		ConfirmDialog(playerid, "Confirmation", str, "OnVehicleScrap", VehicleInfo[vehicleid][eVehicleDBID], cash_back, vehicleid);
		return 1;
}

CMD:vlock(playerid, params[])
{
		new bool:foundCar = false, vehicleid, Float:fetchPos[3];

		for (new i = 0; i < MAX_VEHICLES; i++)
		{
			GetVehiclePos(i, fetchPos[0], fetchPos[1], fetchPos[2]);
			if(IsPlayerInRangeOfPoint(playerid, 4.0, fetchPos[0], fetchPos[1], fetchPos[2]))
			{
				foundCar = true;
				vehicleid = i;
				break;
			}
		}
		if(foundCar == true)
		{
			if(VehicleInfo[vehicleid][eVehicleOwnerDBID] != PlayerInfo[playerid][pDBID] && PlayerInfo[playerid][pDuplicateKey] != vehicleid)
				return SendErrorMessage(playerid, "You don't have the keys to this vehicle.");

			new statusString[90];
			new engine, lights, alarm, doors, bonnet, boot, objective;

			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

			if(VehicleInfo[vehicleid][eVehicleLocked])
			{
				format(statusString, sizeof(statusString), "~g~%s UNLOCKED", ReturnVehicleName(vehicleid));

				SetVehicleParamsEx(vehicleid, engine, lights, alarm, false, bonnet, boot, objective);
				VehicleInfo[vehicleid][eVehicleLocked] = false;
			}
			else
			{
				format(statusString, sizeof(statusString), "~r~%s LOCKED", ReturnVehicleName(vehicleid));

				SetVehicleParamsEx(vehicleid, engine, lights, alarm, true, bonnet, boot, objective);
				VehicleInfo[vehicleid][eVehicleLocked] = true;
			}
			GameTextForPlayer(playerid, statusString, 3000, 3);
		}
		else SendServerMessage(playerid, "You aren't near a vehicle OR the vehicle isn't synced.");
		return 1;
}

CMD:lights(playerid, params[])
{
		new vehicleid = GetPlayerVehicleID(playerid);

		if(!IsPlayerInAnyVehicle(playerid))
			return SendErrorMessage(playerid, "You aren't in any vehicle.");

		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendErrorMessage(playerid, "You aren't driving a vehicle.");

		if(VehicleInfo[vehicleid][eVehicleLights] == false)
			ToggleVehicleLights(vehicleid, true);

		else ToggleVehicleLights(vehicleid, false);
		return 1;
}

CMD:trackcar(playerid, params[])
{
	new vid, Float:fetchPos[3];
	if(sscanf(params, "i", vid)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /trackcar [vehicle ID].");
	foreach(new i : Player)
	{
		if(PlayerInfo[playerid][pDBID] == VehicleInfo[i][eVehicleOwnerDBID])
		return SCM(playerid, COLOR_GRAD1, "You dont own any vehicles");

		if(PlayerInfo[playerid][pDBID] == VehicleInfo[vid][eVehicleOwnerDBID])
			{
				GetVehiclePos(vid, fetchPos[0], fetchPos[1], fetchPos[2]);
				SetPlayerCheckpoint(playerid, fetchPos[0], fetchPos[1], fetchPos[2], 3.0);
			}
			else SCM(playerid, COLOR_GRAD1, "You don't own this vehicle");
	}
	return 1;
}

CMD:carstats(playerid, params[])
{
		new vehicleid = GetPlayerVehicleID(playerid);

		if(VehicleInfo[vehicleid][eVehicleOwnerDBID] != PlayerInfo[playerid][pDBID])
			return SendErrorMessage(playerid, "You don't own this vehicle.");

		SendClientMessageEx(playerid, COLOR_WHITE, "Life Span: Engine Life[%.2f], Battery Life[%.2f], Times Destroyed[%i]", VehicleInfo[vehicleid][eVehicleEngine], VehicleInfo[vehicleid][eVehicleBattery], VehicleInfo[vehicleid][eVehicleTimesDestroyed]);
		SendClientMessageEx(playerid, COLOR_WHITE, "Security: Lock Level[%i], Alarm Level[%i], Immobilizer[%i]", VehicleInfo[vehicleid][eVehicleLockLevel], VehicleInfo[vehicleid][eVehicleAlarmLevel], VehicleInfo[vehicleid][eVehicleImmobLevel]);
		SendClientMessageEx(playerid, COLOR_WHITE, "Misc: Primary Color[{%06x}%d{FFFFFF}], Secondary Color[{%06x}%d{FFFFFF}], License Plate[%s]", VehicleColoursTableRGBA[VehicleInfo[vehicleid][eVehicleColor1]] >>> 8, VehicleInfo[vehicleid][eVehicleColor1], VehicleColoursTableRGBA[VehicleInfo[vehicleid][eVehicleColor2]] >>> 8, VehicleInfo[vehicleid][eVehicleColor2], VehicleInfo[vehicleid][eVehiclePlates]);
		return 1;
}

CMD:makefveh(playerid, params[])
{
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			return SendErrorMessage(playerid, "You aren't in a vehicle.");

		if(!PlayerInfo[playerid][pFaction]) return SendErrorMessage(playerid, "You aren't in any faction.");

		if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank])
			return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You don't have permission in your faction to add faction vehicles.");

		new vehicleid = GetPlayerVehicleID(playerid);

		if(VehicleInfo[vehicleid][eVehicleOwnerDBID] != PlayerInfo[playerid][pDBID])
			return SendErrorMessage(playerid, "You don't own this vehicle.");

		if(VehicleInfo[vehicleid][eVehicleFaction] != 0)
			return SendErrorMessage(playerid, "This vehicle is already factionized to the %s.", ReturnFactionNameEx(VehicleInfo[vehicleid][eVehicleFaction]));

		VehicleInfo[vehicleid][eVehicleFaction] = PlayerInfo[playerid][pFaction];
		SendServerMessage(playerid, "Your vehicle now belongs to the %s.", ReturnFactionName(playerid));

		SaveVehicle(vehicleid);
		return 1;
}

CMD:unfveh(playerid, params[])
{
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			return SendErrorMessage(playerid, "You aren't driving a vehicle.");

		new vehicleid = GetPlayerVehicleID(playerid);

		if(VehicleInfo[vehicleid][eVehicleOwnerDBID] != PlayerInfo[playerid][pDBID])
			return SendErrorMessage(playerid, "You don't own this vehicle.");

		SendServerMessage(playerid, "You unfactionized your %s from the %s.", ReturnVehicleName(vehicleid), ReturnFactionNameEx(VehicleInfo[vehicleid][eVehicleFaction]));
		VehicleInfo[vehicleid][eVehicleFaction] = 0;

		SaveVehicle(vehicleid);
		return 1;
}

CMD:trunk(playerid, params[])
{
		new
			Float:x,
			Float:y,
			Float:z
		;

		new engine, lights, alarm, doors, bonnet, boot, objective;

		if(!IsPlayerInAnyVehicle(playerid) && GetNearestVehicle(playerid) != INVALID_VEHICLE_ID)
		{
			GetVehicleBoot(GetNearestVehicle(playerid), x, y, z);

			new
				vehicleid = GetNearestVehicle(playerid)
			;

			if(VehicleInfo[vehicleid][eVehicleLocked])
				return SendServerMessage(playerid, "This vehicle is locked.");

			if(!IsPlayerInRangeOfPoint(playerid, 2.5, x, y, z))
				return SendErrorMessage(playerid, "You aren't near the vehicles trunk.");

			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

			if(!boot)
			{
				SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, 1, objective);

				SendClientMessage(playerid, COLOR_YELLOWEX, "You have opened the trunk.");
				SendClientMessage(playerid, COLOR_WHITE, "You can use /check to take a gun or /place to put one in.");
			}
			else
			{
				SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, 0, objective);

				SendClientMessage(playerid, COLOR_YELLOWEX, "You have closed the trunk.");
			}
		}
		else if(IsPlayerInAnyVehicle(playerid))
		{
			new
				vehicleid = GetPlayerVehicleID(playerid)
			;

			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
				return SendErrorMessage(playerid, "You aren't in the driver's seat.");

			if(PlayerInfo[playerid][pDBID] != VehicleInfo[vehicleid][eVehicleOwnerDBID] && PlayerInfo[playerid][pDuplicateKey] != vehicleid)
				return SendErrorMessage(playerid, "You don't have the keys to this vehicle.");

			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

			if(!boot)
			{
				SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, 1, objective);

				SendClientMessage(playerid, COLOR_YELLOWEX, "You have opened the trunk.");
				SendClientMessage(playerid, COLOR_WHITE, "You can use /check to take a gun or /place to put one in.");
			}
			else
			{
				SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, 0, objective);
				SendClientMessage(playerid, COLOR_YELLOWEX, "You have closed the trunk.");
			}
		}
		else return SendServerMessage(playerid, "You aren't in or near a vehicle.");
		return 1;
}

CMD:hood(playerid, params[])
{
		new
			Float:x,
			Float:y,
			Float:z
		;

		new engine, lights, alarm, doors, bonnet, boot, objective;

		if(!IsPlayerInAnyVehicle(playerid) && GetNearestVehicle(playerid) != INVALID_VEHICLE_ID)
		{
			GetVehicleHood(GetNearestVehicle(playerid), x, y, z);

			new
				vehicleid = GetNearestVehicle(playerid)
			;

			if(VehicleInfo[vehicleid][eVehicleLocked])
				return SendServerMessage(playerid, "This vehicle is locked.");

			if(!IsPlayerInRangeOfPoint(playerid, 2.5, x, y, z))
				return SendErrorMessage(playerid, "You aren't near the vehicles hood.");

			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

			if(!bonnet)
			{
				SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, 1, boot, objective);
				SendClientMessage(playerid, COLOR_YELLOWEX, "You have opened the hood.");
			}
			else
			{
				SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, 0, boot, objective);
				SendClientMessage(playerid, COLOR_YELLOWEX, "You have closed the hood.");
			}
		}
		else if(IsPlayerInAnyVehicle(playerid))
		{
			new
				vehicleid = GetPlayerVehicleID(playerid)
			;

			if(PlayerInfo[playerid][pDBID] != VehicleInfo[vehicleid][eVehicleOwnerDBID] && PlayerInfo[playerid][pDuplicateKey] != vehicleid)
				return SendErrorMessage(playerid, "You don't have the keys to this vehicle.");

			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
				return SendErrorMessage(playerid, "You aren't in the driver's seat.");

			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

			if(!bonnet)
			{
				SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, 1, boot, objective);
				SendClientMessage(playerid, COLOR_YELLOWEX, "You have opened the hood.");
			}
			else
			{
				SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, 0, boot, objective);
				SendClientMessage(playerid, COLOR_YELLOWEX, "You have closed the hood.");
			}
		}
		else return SendServerMessage(playerid, "You aren't in or near a vehicle.");
		return 1;
}

CMD:vlist(playerid, params[])
{
	if(CountPlayerVehicles(playerid) == 0)
	return SendServerMessage(playerid, "You don't own any vehicles.");
	ShowVehicleList(playerid);
	return 1;
}

CMD:engine(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendErrorMessage(playerid, "You aren't in the driver's seat of a vehicle.");

	new vehicleid = GetPlayerVehicleID(playerid);

	if(!VehicleInfo[vehicleid][eVehicleDBID] && !VehicleInfo[vehicleid][eVehicleAdminSpawn])
	{
	for(new i = 0; i < sizeof dmv_vehicles; i++)
 	if(GetPlayerVehicleID(playerid) == dmv_vehicles[i])
		return SendServerMessage(playerid, "This command can only be used for private vehicles. You are in a public static vehicle.");

	if(!VehicleInfo[vehicleid][eVehicleEngineStatus])
	{
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s started the engine of the %s.", ReturnName(playerid, 0), ReturnVehicleName(vehicleid));
		ToggleVehicleEngine(vehicleid, true); VehicleInfo[vehicleid][eVehicleEngineStatus] = true;
	}
	else
	{
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s stopped the engine of the %s.", ReturnName(playerid, 0), ReturnVehicleName(vehicleid));
		ToggleVehicleEngine(vehicleid, false); VehicleInfo[vehicleid][eVehicleEngineStatus] = false;
	}
	return 1;
	}

	if(HasNoEngine(vehicleid))
		return SendErrorMessage(playerid, "This vehicle doesn't have a engine.");

	if(VehicleInfo[vehicleid][eVehicleFuel] < 1 && !VehicleInfo[vehicleid][eVehicleAdminSpawn])
		return SendClientMessage(playerid, COLOR_RED, "Vehicle is out of fuel.");

	if(VehicleInfo[vehicleid][eVehicleFaction] > 0)
	{
		if(PlayerInfo[playerid][pFaction] != VehicleInfo[vehicleid][eVehicleFaction] && !PlayerInfo[playerid][pAdminDuty])
		{
			return SendErrorMessage(playerid, "You don't have the keys to this vehicle.");
		}
	}

	for(new i = 0; i < sizeof dmv_vehicles; i++)
 	if(GetPlayerVehicleID(playerid) == dmv_vehicles[i])
		return SendServerMessage(playerid, "This command can only be used for private vehicles. You are in a public static vehicle.");

 	if(!VehicleInfo[vehicleid][eVehicleFaction] && VehicleInfo[vehicleid][eVehicleOwnerDBID] != PlayerInfo[playerid][pDBID] && PlayerInfo[playerid][pDuplicateKey] != vehicleid && !PlayerInfo[playerid][pAdminDuty])
        return SendClientMessage(playerid, COLOR_RED, "You don't have the keys to this vehicle.");

	if(!VehicleInfo[vehicleid][eVehicleEngineStatus])
	{
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s started the engine of the %s.", ReturnName(playerid, 0), ReturnVehicleName(vehicleid));
		ToggleVehicleEngine(vehicleid, true); VehicleInfo[vehicleid][eVehicleEngineStatus] = true;
	}
	else
	{
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s stopped the engine of the %s.", ReturnName(playerid, 0), ReturnVehicleName(vehicleid));
		ToggleVehicleEngine(vehicleid, false); VehicleInfo[vehicleid][eVehicleEngineStatus] = false;
	}
	return 1;
}

CMD:hotwire(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
	if(!VehicleInfo[vehicleid][eVehicleFaction] && VehicleInfo[vehicleid][eVehicleOwnerDBID] != PlayerInfo[playerid][pDBID] && PlayerInfo[playerid][pDuplicateKey] != vehicleid && !PlayerInfo[playerid][pAdminDuty] && !VehicleInfo[vehicleid][eVehicleAdminSpawn])
	{
		new idx, str[128];

		if(VehicleInfo[vehicleid][eVehicleEngineStatus] && !PlayerInfo[playerid][pAdminDuty])
			return GameTextForPlayer(playerid, "~g~ENGINE IS ALREADY ON", 3000, 3);

		PlayerInfo[playerid][pUnscrambling] = true;

		for(new i = 0; i < sizeof(UnscrambleInfo); i++)
		{
			idx = random(sizeof(UnscrambleInfo));
		}

		PlayerInfo[playerid][pUnscrambleID] = idx;

		switch(VehicleInfo[vehicleid][eVehicleImmobLevel])
		{
			case 1: PlayerInfo[playerid][pUnscramblerTime] = 125;
			case 2: PlayerInfo[playerid][pUnscramblerTime] = 100;
			case 3: PlayerInfo[playerid][pUnscramblerTime] = 75;
			case 4: PlayerInfo[playerid][pUnscramblerTime] = 50;
			case 5: PlayerInfo[playerid][pUnscramblerTime] = 25;
		}

		PlayerInfo[playerid][pUnscrambleTimer] = SetTimerEx("OnPlayerUnscramble", 1000, true, "i", playerid);

		format(str, sizeof(str), "%s", UnscrambleInfo[idx][eScrambledWord]);
		PlayerTextDrawSetString(playerid, Unscrambler_PTD[playerid][3], str);

		format(str, sizeof(str), "%d", PlayerInfo[playerid][pUnscramblerTime]);
		PlayerTextDrawSetString(playerid, Unscrambler_PTD[playerid][5], str);

		ShowUnscrambleTextdraw(playerid);
	}
	return 1;
}

CMD:uns(playerid, params[])	return cmd_unscramble(playerid, params);
CMD:unscramble(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendErrorMessage(playerid, "You aren't driving a vehicle.");

	if(!PlayerInfo[playerid][pUnscrambling])
		return SendErrorMessage(playerid, "You aren't hotwiring a vehicle.");

	if(isnull(params)) return SendUsageMessage(playerid, "/(uns)cramble [unscrambled word]");

	if(!strcmp(UnscrambleInfo[PlayerInfo[playerid][pUnscrambleID]][eUnscrambledWord], params))
	{ // This occurrs if they wrote the correct word:

		PlayerInfo[playerid][pUnscrambleID] = random(sizeof(UnscrambleInfo));

		new displayString[60];

		format(displayString, 60, "%s", UnscrambleInfo[PlayerInfo[playerid][pUnscrambleID]][eScrambledWord]);
		PlayerTextDrawSetString(playerid, Unscrambler_PTD[playerid][3], displayString);

		//Timer increases depending on alarm level:
		PlayerInfo[playerid][pUnscramblerTime] += 9;
		PlayerInfo[playerid][pScrambleSuccess]++;

		PlayerPlaySound(playerid, 1052, 0, 0, 0);
		//Depending on alarm levels, success time would change:
		if(PlayerInfo[playerid][pScrambleSuccess] >= 7)
		{
			KillTimer(PlayerInfo[playerid][pUnscrambleTimer]);
			PlayerInfo[playerid][pScrambleSuccess] = 0;
			PlayerInfo[playerid][pUnscrambling] = false;

			PlayerInfo[playerid][pUnscrambleID] = 0;
			PlayerInfo[playerid][pUnscramblerTime] = 0;

			PlayerInfo[playerid][pScrambleFailed] = 0;

			GameTextForPlayer(playerid, "~g~ENGINE TURNED ON", 2000, 3);
			ShowUnscrambleTextdraw(playerid, false);

			new vehicleid = GetPlayerVehicleID(playerid);

			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s started the engine of the %s.", ReturnName(playerid, 0), ReturnVehicleName(vehicleid));
			ToggleVehicleEngine(vehicleid, true); VehicleInfo[vehicleid][eVehicleEngineStatus] = true;
		}
	}
	else
	{
		PlayerPlaySound(playerid, 1055, 0, 0, 0);

		PlayerInfo[playerid][pUnscrambleID] = random(sizeof(UnscrambleInfo));

		new displayString[60];

		format(displayString, 60, "%s", UnscrambleInfo[PlayerInfo[playerid][pUnscrambleID]][eScrambledWord]);
		PlayerTextDrawSetString(playerid, Unscrambler_PTD[playerid][3], displayString);

		PlayerInfo[playerid][pScrambleFailed]++;
		PlayerInfo[playerid][pUnscramblerTime] -= random(6)+1;

		if(PlayerInfo[playerid][pScrambleFailed] >= 5)
		{
			KillTimer(PlayerInfo[playerid][pUnscrambleTimer]);
			PlayerInfo[playerid][pScrambleSuccess] = 0;
			PlayerInfo[playerid][pUnscrambling] = false;

			PlayerInfo[playerid][pUnscrambleID] = 0;
			PlayerInfo[playerid][pUnscramblerTime] = 0;

			PlayerInfo[playerid][pScrambleFailed] = 0;

			new
				vehicleid = GetPlayerVehicleID(playerid)
			;

			ToggleVehicleAlarms(vehicleid, true);
			NotifyVehicleOwner(vehicleid);

			ClearAnimations(playerid);
			ShowUnscrambleTextdraw(playerid, false);
		}
	}

	return 1;
}

CMD:check(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid) && GetNearestVehicle(playerid) == INVALID_VEHICLE_ID && !IsPlayerInProperty(playerid))
		return SendErrorMessage(playerid, "You can't do this right now.");

	new
		Float: x,
		Float: y,
		Float: z,
		principal_str[256]
	;

	if(!IsPlayerInAnyVehicle(playerid) && GetNearestVehicle(playerid) != INVALID_VEHICLE_ID)
	{
		GetVehicleBoot(GetNearestVehicle(playerid), x, y, z);

		new
			vehicleid = GetNearestVehicle(playerid)
		;

		if(!VehicleInfo[vehicleid][eVehicleDBID] && !VehicleInfo[vehicleid][eVehicleAdminSpawn])
			return SendServerMessage(playerid, "This command can only be used for private vehicles. You are in a public static vehicle.");

		if(VehicleInfo[vehicleid][eVehicleFaction] && FactionInfo[VehicleInfo[vehicleid][eVehicleFaction]][eFactionType] != FACTION_TYPE_ILLEGAL && PlayerInfo[playerid][pFaction] != VehicleInfo[vehicleid][eVehicleFaction])
			return SendClientMessage(playerid, COLOR_YELLOW, "You don't have access to this vehicle.");

		if(!IsPlayerInRangeOfPoint(playerid, 2.5, x, y, z))
			return SendErrorMessage(playerid, "You aren't near the vehicles trunk.");

		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

		if(!bonnet)
			return SendClientMessage(playerid, COLOR_YELLOWEX, "You need to open the trunk first.");

		for(new i = 1; i < 6; i++)
		{
			if(VehicleInfo[vehicleid][eVehicleWeapons][i])
				format(principal_str, sizeof(principal_str), "%s%i. %s[Ammo: %i]\n", principal_str, i, ReturnWeaponName(VehicleInfo[vehicleid][eVehicleWeapons][i]), VehicleInfo[vehicleid][eVehicleWeaponsAmmo][i]);

			else
				format(principal_str, sizeof(principal_str), "%s%i. [Empty]\n", principal_str, i);
		}

		ShowPlayerDialog(playerid, DIALOG_VEHICLE_WEAPONS, DIALOG_STYLE_LIST, "Trunk:", principal_str, "Select", "Back");
	}
	else if(IsPlayerInAnyVehicle(playerid))
	{
		new
			vehicleid = GetPlayerVehicleID(playerid)
		;

		if(!VehicleInfo[vehicleid][eVehicleDBID] && !VehicleInfo[vehicleid][eVehicleAdminSpawn])
			return SendServerMessage(playerid, "This command can only be used for private vehicles. You are in a public static vehicle.");

		if(VehicleInfo[vehicleid][eVehicleFaction] && FactionInfo[VehicleInfo[vehicleid][eVehicleFaction]][eFactionType] != FACTION_TYPE_ILLEGAL && PlayerInfo[playerid][pFaction] != VehicleInfo[vehicleid][eVehicleFaction])
			return SendClientMessage(playerid, COLOR_YELLOW, "You don't have access to this vehicle.");

		for(new i = 1; i < 6; i++)
		{
			if(VehicleInfo[vehicleid][eVehicleWeapons][i])
				format(principal_str, sizeof(principal_str), "%s%i. %s[Ammo: %i]\n", principal_str, i, ReturnWeaponName(VehicleInfo[vehicleid][eVehicleWeapons][i]), VehicleInfo[vehicleid][eVehicleWeaponsAmmo][i]);

			else
				format(principal_str, sizeof(principal_str), "%s%i. [Empty]\n", principal_str, i);
		}

		ShowPlayerDialog(playerid, DIALOG_VEHICLE_WEAPONS, DIALOG_STYLE_LIST, "Trunk:", principal_str, "Select", "Back");
	}
	else if(IsPlayerInProperty(playerid))
	{
		new
			id = IsPlayerInProperty(playerid),
			longstr[600]
		;

		if(!IsPlayerInRangeOfPoint(playerid, 3.0, PropertyInfo[id][ePropertyPlacePos][0], PropertyInfo[id][ePropertyPlacePos][1], PropertyInfo[id][ePropertyPlacePos][2]))
			return SendErrorMessage(playerid, "You aren't near this properties place position.");

		for(new i = 1; i < 21; i++)
		{
			if(!PropertyInfo[id][ePropertyWeapons][i])
				format(longstr, sizeof(longstr), "%s%d. [Empty]\n", longstr, i);

			else format(longstr, sizeof(longstr), "%s%d. %s[Ammo: %d]\n", longstr, i, ReturnWeaponName(PropertyInfo[id][ePropertyWeapons][i]), PropertyInfo[id][ePropertyWeaponsAmmo][i]);
		}

		ShowPlayerDialog(playerid, DIALOG_HOUSE_WEAPONS, DIALOG_STYLE_LIST, "Weapons:", longstr, "Select", "Cancel");
	}
	return 1;
}

CMD:place(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid) && GetNearestVehicle(playerid) == INVALID_VEHICLE_ID && !IsPlayerInProperty(playerid))
		return SendErrorMessage(playerid, "You can't do this right now.");

	new
		Float: x,
		Float: y,
		Float: z,
		str[128],
		weaponid,
		idx
	;

	if(sscanf(params, "i", weaponid))
		return SendUsageMessage(playerid, "/place [weapon id]");

	if(!PlayerHasWeapon(playerid, weaponid))
		return SendErrorMessage(playerid, "You don't have that weapon.");

	if(!IsPlayerInAnyVehicle(playerid) && GetNearestVehicle(playerid) != INVALID_VEHICLE_ID)
	{
		GetVehicleBoot(GetNearestVehicle(playerid), x, y, z);

		new
			vehicleid = GetNearestVehicle(playerid)
		;

		if(VehicleInfo[vehicleid][eVehicleFaction] && FactionInfo[VehicleInfo[vehicleid][eVehicleFaction]][eFactionType] != FACTION_TYPE_ILLEGAL)
			return SendClientMessage(playerid, COLOR_YELLOW, "You don't have access to this vehicle.");

		if(!IsPlayerInRangeOfPoint(playerid, 2.5, x, y, z))
			return SendErrorMessage(playerid, "You aren't near the vehicles trunk.");

		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

		if(!bonnet)
			return SendClientMessage(playerid, COLOR_YELLOWEX, "You need to open the trunk first.");

		for(new i = 1; i < 6; i++)
		{
			if(!VehicleInfo[vehicleid][eVehicleWeapons][i])
			{
				idx = i;
				break;
			}
		}

		VehicleInfo[vehicleid][eVehicleWeapons][idx] = weaponid;
		VehicleInfo[vehicleid][eVehicleWeaponsAmmo][idx] = PlayerInfo[playerid][pWeaponsAmmo][ReturnWeaponIDSlot(weaponid)];

		PlayerInfo[playerid][pWeaponsAmmo][ReturnWeaponIDSlot(weaponid)] = 0;
		PlayerInfo[playerid][pWeapons][ReturnWeaponIDSlot(weaponid)] = 0;

		RemovePlayerWeapon(playerid, weaponid);

		format(str, sizeof(str), "* %s placed a %s in the %s.", ReturnName(playerid, 0), ReturnWeaponName(weaponid), ReturnVehicleName(vehicleid));
		SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4000);
	}
	else if(IsPlayerInAnyVehicle(playerid))
	{
		new
			vehicleid = GetPlayerVehicleID(playerid)
		;

		if(VehicleInfo[vehicleid][eVehicleFaction] && FactionInfo[VehicleInfo[vehicleid][eVehicleFaction]][eFactionType] != FACTION_TYPE_ILLEGAL)
			return SendClientMessage(playerid, COLOR_YELLOW, "You don't have access to this vehicle.");

		for(new i = 1; i < 6; i++)
		{
			if(!VehicleInfo[vehicleid][eVehicleWeapons][i])
			{
				idx = i;
				break;
			}
		}

		VehicleInfo[vehicleid][eVehicleWeapons][idx] = weaponid;
		VehicleInfo[vehicleid][eVehicleWeaponsAmmo][idx] = PlayerInfo[playerid][pWeaponsAmmo][ReturnWeaponIDSlot(weaponid)];

		PlayerInfo[playerid][pWeaponsAmmo][ReturnWeaponIDSlot(weaponid)] = 0;
		PlayerInfo[playerid][pWeapons][ReturnWeaponIDSlot(weaponid)] = 0;

		RemovePlayerWeapon(playerid, weaponid);

		format(str, sizeof(str), "* %s placed a %s in the %s.", ReturnName(playerid, 0), ReturnWeaponName(weaponid), ReturnVehicleName(vehicleid));
		SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4000);
		SendClientMessage(playerid, COLOR_EMOTE, str);
	}
	else if(IsPlayerInProperty(playerid))
	{
		new
			id = IsPlayerInProperty(playerid),
			pid
		;

		if(!IsPlayerInRangeOfPoint(playerid, 3.0, PropertyInfo[id][ePropertyPlacePos][0], PropertyInfo[id][ePropertyPlacePos][1], PropertyInfo[id][ePropertyPlacePos][2]))
			return SendErrorMessage(playerid, "You aren't near this properties place position.");

		for(new i = 1; i < 21; i++)
		{
			if(!PropertyInfo[id][ePropertyWeapons][i])
			{
				pid = i;
				break;
			}
		}

		PropertyInfo[id][ePropertyWeapons][pid] = weaponid;
		PropertyInfo[id][ePropertyWeaponsAmmo][pid] = PlayerInfo[playerid][pWeaponsAmmo][ReturnWeaponIDSlot(weaponid)];

		PlayerInfo[playerid][pWeaponsAmmo][ReturnWeaponIDSlot(weaponid)] = 0;
		PlayerInfo[playerid][pWeapons][ReturnWeaponIDSlot(weaponid)] = 0;

		RemovePlayerWeapon(playerid, weaponid);

		format(str, sizeof(str), "* %s placed a %s in the house.", ReturnName(playerid, 0), ReturnWeaponName(weaponid));
		SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4000);
		SendClientMessage(playerid, COLOR_EMOTE, str);
	}
	return 1;
}

//Property commands:
CMD:buyproperty(playerid, params[])
{
	new
		bool:nearProperty = false,
		id,
		str[128],
		hstring[90]
	;

	for(new i = 1; i < MAX_PROPERTY; i++)
	{
		if(!PropertyInfo[i][ePropertyDBID])
			continue;

		if(IsPlayerInRangeOfPoint(playerid, 3.0, PropertyInfo[i][ePropertyEntrance][0], PropertyInfo[i][ePropertyEntrance][1], PropertyInfo[i][ePropertyEntrance][2]))
		{
			nearProperty = true;
			id = i;
			break;
		}
	}

	if(nearProperty)
	{
		if(PropertyInfo[id][ePropertyOwnerDBID])
			return SendErrorMessage(playerid, "This property isn't for sale.");

		if(PropertyInfo[id][ePropertyMarketPrice] > PlayerInfo[playerid][pMoney])
			return SendErrorMessage(playerid, "You can't afford to buy this property.");

		if(CountPlayerProperties(playerid) >= 3)
			return SendErrorMessage(playerid, "You already own 3 properties.");

		GiveMoney(playerid, -PropertyInfo[id][ePropertyMarketPrice]);
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

		format(str, sizeof(str), "Congratulations!~n~You're now the owner of this property! $%d", PropertyInfo[id][ePropertyMarketPrice]);
		GameTextForPlayer(playerid, str, 4000, 5);
		
		format(hstring, sizeof(hstring), "Adress: %s", PropertyInfo[id][ePropertyAdress]);
        Update3DTextLabelText(PropertyInfo[id][ePropertyTag], COLOR_WHITE, hstring);
        DestroyDynamicPickup(PropertyInfo[id][ePropertyPickup]);
        PropertyInfo[id][ePropertyPickup] = CreateDynamicPickup(1272, 1, PropertyInfo[id][ePropertyEntrance][0], PropertyInfo[id][ePropertyEntrance][1], PropertyInfo[id][ePropertyEntrance][2], 0);
        
		PropertyInfo[id][ePropertyOwnerDBID] = PlayerInfo[playerid][pDBID];
		SaveCharacter(playerid); SaveProperty(id);
	}
	else return SendErrorMessage(playerid, "You aren't near a property.");
	return 1;
}

CMD:sellproperty(playerid, params[])
{
	new
		bool:nearProperty = false,
		id,
		pay,
		hstring[90]
	;

	for(new i = 1; i < MAX_PROPERTY; i++)
	{
		if(!PropertyInfo[i][ePropertyDBID])
			continue;

		if(IsPlayerInRangeOfPoint(playerid, 3.0, PropertyInfo[i][ePropertyEntrance][0], PropertyInfo[i][ePropertyEntrance][1], PropertyInfo[i][ePropertyEntrance][2]))
		{
			nearProperty = true;
			id = i;
			break;
		}
	}

	if(nearProperty)
	{
		if(PropertyInfo[id][ePropertyOwnerDBID] != PlayerInfo[playerid][pDBID])
			return SendErrorMessage(playerid, "This property isn't yours.");

		pay = PropertyInfo[id][ePropertyMarketPrice] / 2;

		GiveMoney(playerid, pay);
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

		SCMex(playerid, COLOR_YELLOW, "You've sold your property for $%i", pay);

		format(hstring, sizeof(hstring), "Adess: %s\nFor Sale!\n Price: $%i", PropertyInfo[id][ePropertyAdress],PropertyInfo[id][ePropertyMarketPrice]);
        Update3DTextLabelText(PropertyInfo[id][ePropertyTag], COLOR_GREEN, hstring);
        DestroyDynamicPickup(PropertyInfo[id][ePropertyPickup]);
        PropertyInfo[id][ePropertyPickup] = CreateDynamicPickup(1273, 1, PropertyInfo[id][ePropertyEntrance][0], PropertyInfo[id][ePropertyEntrance][1], PropertyInfo[id][ePropertyEntrance][2], 0);

		PropertyInfo[id][ePropertyOwnerDBID] = 0;
		SaveCharacter(playerid); SaveProperty(id);
	}
	else return SendErrorMessage(playerid, "You aren't near a property.");
	return 1;
}

CMD:lock(playerid, params[])
{
	new
		id,
		b_id
	;

	if((id = IsPlayerNearProperty(playerid)) != 0)
	{
		if(PlayerInfo[playerid][pDBID] != PropertyInfo[id][ePropertyOwnerDBID])
			return SendErrorMessage(playerid, "You don't have the keys to this property.");

		if(!PropertyInfo[id][ePropertyLocked])
		{
			GameTextForPlayer(playerid, "~w~DOOR ~r~LOCKED", 1000, 6);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

			PropertyInfo[id][ePropertyLocked] = true;
		}
		else
		{
			GameTextForPlayer(playerid, "~w~DOOR ~g~UNLOCKED", 1000, 6);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

			PropertyInfo[id][ePropertyLocked] = false;
		}
	}
	else if((id = IsPlayerInProperty(playerid)) != 0)
	{
		if(PlayerInfo[playerid][pDBID] != PropertyInfo[id][ePropertyOwnerDBID])
			return SendErrorMessage(playerid, "You don't have the keys to this property.");

		if(!IsPlayerInRangeOfPoint(playerid, 3.0, PropertyInfo[id][ePropertyInterior][0], PropertyInfo[id][ePropertyInterior][1], PropertyInfo[id][ePropertyInterior][2]))
			return SendErrorMessage(playerid, "You aren't near your properties door.");

		if(!PropertyInfo[id][ePropertyLocked])
		{
			GameTextForPlayer(playerid, "~w~DOOR ~r~LOCKED", 1000, 4);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

			PropertyInfo[id][ePropertyLocked] = true;
		}
		else
		{
			GameTextForPlayer(playerid, "~w~DOOR ~g~UNLOCKED", 1000, 4);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

			PropertyInfo[id][ePropertyLocked] = false;
		}
	}

	if((b_id = IsPlayerNearBusiness(playerid)) != 0)
	{
		if(BusinessInfo[b_id][eBusinessOwnerDBID] != PlayerInfo[playerid][pDBID])
			return SendErrorMessage(playerid, "You don't have the keys to this business.");

		if(!BusinessInfo[b_id][eBusinessLocked])
		{
			GameTextForPlayer(playerid, "~w~DOOR ~r~LOCKED", 1000, 4);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

			BusinessInfo[b_id][eBusinessLocked] = true;
		}
		else
		{
			GameTextForPlayer(playerid, "~w~DOOR ~g~UNLOCKED", 1000, 4);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

			BusinessInfo[b_id][eBusinessLocked] = false;
		}
	}
	else if((b_id = IsPlayerInBusiness(playerid)) != 0)
	{
		if(!IsPlayerInRangeOfPoint(playerid, 3.0, BusinessInfo[b_id][eBusinessInterior][0], BusinessInfo[b_id][eBusinessInterior][1], BusinessInfo[b_id][eBusinessInterior][2]))
			return SendErrorMessage(playerid, "You aren't near the door.");

		if(BusinessInfo[b_id][eBusinessOwnerDBID] != PlayerInfo[playerid][pDBID])
			return SendErrorMessage(playerid, "You don't have the keys to this business.");

		if(!BusinessInfo[b_id][eBusinessLocked])
		{
			GameTextForPlayer(playerid, "~w~DOOR ~r~LOCKED", 1000, 4);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

			BusinessInfo[b_id][eBusinessLocked] = true;
		}
		else
		{
			GameTextForPlayer(playerid, "~w~DOOR ~g~UNLOCKED", 1000, 4);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

			BusinessInfo[b_id][eBusinessLocked] = false;
		}
	}
	return 1;
}

CMD:placepos(playerid, params[])
{
	new
		id
	;

	if((id = IsPlayerInProperty(playerid)) != 0)
	{
		if(PlayerInfo[playerid][pDBID] != PropertyInfo[id][ePropertyOwnerDBID])
			return SendErrorMessage(playerid, "You don't own this house.");

		GetPlayerPos(playerid, PropertyInfo[id][ePropertyPlacePos][0], PropertyInfo[id][ePropertyPlacePos][1], PropertyInfo[id][ePropertyPlacePos][2]);
		SendServerMessage(playerid, "You changed your properties place position.");
	}
	else return SendErrorMessage(playerid, "You aren't in a property.");

	return 1;
}

CMD:property(playerid, params[])
{
	if(!CountPlayerProperties(playerid))
		return SendErrorMessage(playerid, "You don't own a property.");

	new id, str[90], bstr[90], cstr[60];

	if((id = IsPlayerInProperty(playerid)) == 0)
		return SendErrorMessage(playerid, "You aren't inside your property.");

	if(PropertyInfo[id][ePropertyOwnerDBID] != PlayerInfo[playerid][pDBID])
		return SendErrorMessage(playerid, "You don't own this property.");

	if(sscanf(params, "s[90]S()[90]S()[60]", str, bstr, cstr))
	{
		SendClientMessage(playerid, COLOR_RED, "____________________________________________________");
		SendUsageMessage(playerid, "/property [action]");
		SendClientMessage(playerid, COLOR_RED, "[Actions] info, cashbox, boombox");
		SendClientMessage(playerid, COLOR_RED, "____________________________________________________");
		return 1;
	}

	if(!strcmp(str, "info"))
	{
		new type[30];

		if(PropertyInfo[id][ePropertyType] == PROPERTY_TYPE_HOUSE)
			type = "House";

		else if(PropertyInfo[id][ePropertyType] == PROPERTY_TYPE_APTROOM)
			type = "Apartment Room";

		else if(PropertyInfo[id][ePropertyType] == PROPERTY_TYPE_APTCOMPLEX)
			type = "Apartment Complex";

		SendClientMessageEx(playerid, COLOR_WHITE, "House ID:[%i], Price:[$%s], Level:[%i], Type:[%s]", PropertyInfo[id][ePropertyDBID], MoneyFormat(PropertyInfo[id][ePropertyMarketPrice]), PropertyInfo[id][ePropertyLevel], type);
	}
	else if(!strcmp(str, "cashbox"))
	{
		new pick[30], amount;

		if(sscanf(bstr, "s[30]", pick))
			return SendUsageMessage(playerid, "/property cashbox [Info, Place, Take]");

		if(!strcmp(pick, "info"))
		{
			SendClientMessageEx(playerid, COLOR_ACTION, "You have $%s inside your houses' cashbox.", MoneyFormat(PropertyInfo[id][ePropertyCashbox]));
		}
		else if(!strcmp(pick, "place"))
		{
			if(sscanf(cstr, "i", amount))
				return SendUsageMessage(playerid, "/property cashbox place [amount]");

			if(amount > PlayerInfo[playerid][pMoney])
				return SendErrorMessage(playerid, "You don't have that amount on you.");

			GiveMoney(playerid, -amount);
			PropertyInfo[id][ePropertyCashbox]+= amount;

			SendServerMessage(playerid, "You added $%s to your cashbox.", amount);
			SaveProperty(id);
		}
		else if(!strcmp(pick, "take"))
		{
			if(sscanf(cstr, "i", amount))
				return SendUsageMessage(playerid, "/property cashbox take [amount]");

			if(amount > PropertyInfo[id][ePropertyCashbox])
				return SendErrorMessage(playerid, "Your cashbox doesn't have that much.");

			GiveMoney(playerid, amount);
			PropertyInfo[id][ePropertyCashbox]-= amount;

			SendServerMessage(playerid, "You took $%s from your cashbox.", amount);
			SaveProperty(id);
		}
		else return SendErrorMessage(playerid, "Invalid Paramater.");
	}
	else if(!strcmp(str, "boombox"))
	{
		new pick[30];

		if(sscanf(bstr, "s[30]", pick))
			return SendUsageMessage(playerid, "/property boombox [Add, Remove, Adjust]");

		if(!strcmp(pick, "add"))
		{
			if(PropertyInfo[id][ePropertyHasBoombox])
				return SendErrorMessage(playerid, "This property already has a boombox.");

			if(PlayerInfo[playerid][pEditingObject])
				return SendErrorMessage(playerid, "You're already adding or editing an object.");

			new
				Float:x,
				Float:y,
				Float:z
			;

			GetPlayerPos(playerid, x, y, z);

			PlayerInfo[playerid][pAddObject] = CreateDynamicObject(2103, x, y - 1, z, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			EditDynamicObject(playerid, PlayerInfo[playerid][pAddObject]);

			SendServerMessage(playerid, "Place your Boombox where you would like it. Once you're done, hit save. This costs $1,000.");
			PlayerInfo[playerid][pEditingObject] = 1;
		}
		else if(!strcmp(pick, "remove"))
		{
			if(!PropertyInfo[id][ePropertyHasBoombox])
				return SendErrorMessage(playerid, "This property doesn't have a boombox.");

			ConfirmDialog(playerid, "Confirmation", "Are you sure you want to remove your boombox?", "OnRemoveBoombox", id);
		}
		else if(!strcmp(pick, "adjust"))
		{
			if(!PropertyInfo[id][ePropertyHasBoombox])
				return SendErrorMessage(playerid, "This property doesn't have a boombox.");

			if(PlayerInfo[playerid][pEditingObject])
				return SendErrorMessage(playerid, "You're already editing an object.");

			PlayerInfo[playerid][pEditingObject] = 2;
			EditDynamicObject(playerid, PropertyInfo[id][ePropertyBoomboxObject]);

			SendServerMessage(playerid, "You're editing your properties boombox.");
		}
	}
	else return SendErrorMessage(playerid, "Invalid Paramater.");


	return 1;
}

//Emote commands:
CMD:me(playerid, params[])
{
	if (isnull(params))
		return SendUsageMessage(playerid, "/me [emote]");

	if(strlen(params) > 86)
	{
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s %.86s", ReturnName(playerid, 0), params);
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s ...%s", ReturnName(playerid, 0), params[86]);
	}
	else SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s %s", ReturnName(playerid, 0), params);

	return 1;
}

CMD:do(playerid, params[])
{
	if (isnull(params))
		return SendUsageMessage(playerid, "/do [emote]");

	if(strlen(params) > 86)
	{
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %.86s", params);
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s (( %s ))", params[86], ReturnName(playerid, 0));
	}
	else SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s (( %s ))", params, ReturnName(playerid, 0));

	return 1;
}

CMD:ame(playerid, params[])
{
	if (isnull(params))
		return SendUsageMessage(playerid, "/ame [emote]");

	new str[128];

	format (str, sizeof(str), "> %s %s", ReturnName(playerid, 0), params);
	SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4000);

	SendClientMessageEx(playerid, COLOR_EMOTE, "* %s %s", ReturnName(playerid, 0), params);
	return 1;
}

CMD:my(playerid, params[])
{
	if (isnull(params))
		return SendUsageMessage(playerid, "/my [emote]");

	new playerName[MAX_PLAYER_NAME], bool:hasEnding = false, idx;

	format(playerName, sizeof(playerName), "%s", ReturnName(playerid, 0));
	idx = strlen(playerName);

	if(playerName[idx-1] == 's' || playerName[idx-1] == 's')
	{
		hasEnding = true;
	}

	if(hasEnding == true)
	{
		if(strlen(params) > 86)
		{
			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s' %.86s", ReturnName(playerid, 0), params);
			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s' ...%s", ReturnName(playerid, 0), params[86]);
		}
		else SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s' %s", ReturnName(playerid, 0), params);
	}
	else
	{
		if(strlen(params) > 86)
		{
			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s's %.86s", ReturnName(playerid, 0), params);
			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s's ...%s", ReturnName(playerid, 0), params[86]);
		}
		else SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s's %s", ReturnName(playerid, 0), params);
	}

	return 1;
}

CMD:amy(playerid, params[])
{
	if (isnull(params))
		return SendUsageMessage(playerid, "/amy [emote]");

	new str[128], playerName[MAX_PLAYER_NAME], bool:hasEnding = false, idx;

	format(playerName, sizeof(playerName), "%s", ReturnName(playerid, 0));
	idx = strlen(playerName);

	if(playerName[idx-1] == 's' || playerName[idx-1] == 's')
	{
		hasEnding = true;
	}

	if(hasEnding == true)
	{
		format (str, sizeof(str), "> %s' %s", ReturnName(playerid, 0), params);
		SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4000);

		SendClientMessageEx(playerid, COLOR_EMOTE, "* %s' %s", ReturnName(playerid, 0), params);
	}
	else
	{
		format (str, sizeof(str), "> %s's %s", ReturnName(playerid, 0), params);
		SetPlayerChatBubble(playerid, str, COLOR_EMOTE, 20.0, 4000);

		SendClientMessageEx(playerid, COLOR_EMOTE, "* %s's %s", ReturnName(playerid, 0), params);
	}
	return 1;
}


CMD:s(playerid, params[]) return cmd_shout(playerid, params);
CMD:shout(playerid, params[])
{
	if (isnull(params))
		return SendUsageMessage(playerid, "/shout [text]");

	if(GetPlayerTeam(playerid) != PLAYER_STATE_ALIVE)
		return SendErrorMessage(playerid, "You can't shout right now.");

	new bool:isCaps = false;

	for( new i, j = strlen( params )-1; i < j; i ++ )
    {
        if( ( 'A' <= params[ i ] <= 'Z' ) && ( 'A' <= params[ i+1 ] <= 'Z' ) )
            isCaps = true;
    }

	if(isCaps == true)
	{
		if(strlen(params) > 84)
		{
			SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "%s screams: %.84s", ReturnName(playerid, 0), params);
			SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "%s screams: ...%s", params[84]);
		}
		else SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "%s screams: %s", ReturnName(playerid, 0), params);
	}
	else
	{
		if(strlen(params) > 84)
		{
			SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s shouts: %.84s", ReturnName(playerid, 0), params);
			SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s shouts: ...%s", params[84]);
		}
		else SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s shouts: %s", ReturnName(playerid, 0), params);
	}
	return 1;
}

CMD:low(playerid, params[])
{
	if(GetPlayerTeam(playerid) == PLAYER_STATE_DEAD)
		return SendErrorMessage(playerid, "You can't when you aren't alive.");

	if(isnull(params))
		return SendUsageMessage(playerid, "/low [text]");

	new
		str[128]
	;

	if(strlen(params) > 84)
	{
		format(str, sizeof(str), "%s says[low]: %.84s", ReturnName(playerid, 0), params);
		LocalChat(playerid, 6.0, str, COLOR_FADE5, COLOR_FADE4, COLOR_FADE3, COLOR_FADE3);

		format(str, sizeof(str), "%s says[low]: ... %s", ReturnName(playerid, 0), params[84]);
		LocalChat(playerid, 6.0, str, COLOR_FADE5, COLOR_FADE4, COLOR_FADE3, COLOR_FADE3);
	}
	else
	{
		format(str, sizeof(str), "%s says[low]: %s", ReturnName(playerid, 0), params);
		LocalChat(playerid, 6.0, str, COLOR_FADE5, COLOR_FADE4, COLOR_FADE3, COLOR_FADE3);
	}

	return 1;
}

CMD:b(playerid, params[])
{
	if (isnull(params))
		return SendUsageMessage(playerid, "/b [text]");

	if(PlayerInfo[playerid][pAdminDuty] == true)
	{
		if(strlen(params) > 84)
		{
			SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "{FFFFFF}(( {009900}%s{FFFFFF}: %.84s ))", ReturnName(playerid), params);
			SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "{FFFFFF}(( {009900}%s{FFFFFF}: ...%s ))", ReturnName(playerid), params[84]);
		}
		else SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "{FFFFFF}(( {009900}%s{FFFFFF}: %s ))", ReturnName(playerid), params);
	}
	else
	{
		if(strlen(params) > 84)
		{
			SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "(( %s: %.84s ))", ReturnName(playerid), params);
			SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "(( %s: ...%s ))", ReturnName(playerid), params[84]);
		}
		else SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "(( %s: %s ))", ReturnName(playerid), params);
	}
	return 1;
}

CMD:pm(playerid, params[])
{
	new
		playerb,
		text[144]
	;

	if(sscanf(params, "us[144]", playerb, text))
		return SendUsageMessage(playerid, "/pm [playerid OR name] [text]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(PlayerInfo[playerid][pAdminDuty])
	{
		SendClientMessageEx(playerb, COLOR_PMRECEIVED, "(( PM from {FF9900}%s{FFDC18} (ID: %d): %s ))", ReturnName(playerid), playerid, text);

		if(!PlayerInfo[playerb][pAdminDuty])
			SendClientMessageEx(playerid, COLOR_PMSENT, "(( PM sent to %s (ID: %d): %s ))", ReturnName(playerb), playerb, text);

		else SendClientMessageEx(playerid, COLOR_PMSENT, "(( PM sent to {FF9900}%s{EEE854} (ID: %d): %s ))", ReturnName(playerb), playerb, text);
	}
	else
	{
		if(PlayerInfo[playerb][pAdminDuty])
		{
			SendClientMessageEx(playerb, COLOR_PMRECEIVED, "(( PM from %s (ID: %d): %s ))", ReturnName(playerid), playerid, text);
			SendClientMessageEx(playerid, COLOR_PMSENT, "(( PM sent to {FF9900}%s{EEE854} (ID: %d): %s ))", ReturnName(playerb), playerb, text);
		}
		else
		{
			SendClientMessageEx(playerb, COLOR_PMRECEIVED, "(( PM from %s (ID: %d): %s ))", ReturnName(playerid), playerid, text);
			SendClientMessageEx(playerid, COLOR_PMSENT, "(( PM sent to %s (ID: %d): %s ))", ReturnName(playerb), playerb, text);
		}
	}
	PlayerPlaySound(playerb,1085,0.0,0.0,0.0);
	return 1;
}

//Business commands:
CMD:buybiz(playerid, params[])
{
	new
		id
	;

	if((id = IsPlayerNearBusiness(playerid)) != 0)
	{
		if(CountPlayerBusiness(playerid) == 1)
			return SendErrorMessage(playerid, "You can't own more than 1 business.");

		if(BusinessInfo[id][eBusinessOwnerDBID])
			return SendErrorMessage(playerid, "This business isn't for sale.");

		if(PlayerInfo[playerid][pLevel] < BusinessInfo[id][eBusinessLevel])
			return SendErrorMessage(playerid, "You need to be level %i to buy this.", BusinessInfo[id][eBusinessLevel]);

		if(PlayerInfo[playerid][pMoney] < BusinessInfo[id][eBusinessMarketPrice])
			return SendErrorMessage(playerid, "You can't afford this business.");

		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		GameTextForPlayer(playerid, "Congratulations!~n~You're now the owner of this business!", 4000, 5);

		SendClientMessageEx(playerid, COLOR_ACTION, "You purchased the %s for $%s!", BusinessInfo[id][eBusinessName], MoneyFormat(BusinessInfo[id][eBusinessMarketPrice]));

		BusinessInfo[id][eBusinessOwnerDBID] = PlayerInfo[playerid][pDBID];
		GiveMoney(playerid, -BusinessInfo[id][eBusinessMarketPrice]);

		if(BusinessInfo[id][eBusinessType] == BUSINESS_TYPE_RESTAURANT)
		{
			DestroyDynamicPickup(BusinessInfo[id][eBusinessPickup]);
			BusinessInfo[id][eBusinessPickup] = CreateDynamicPickup(1239, 1, BusinessInfo[id][eBusinessEntrance][0], BusinessInfo[id][eBusinessEntrance][1], BusinessInfo[id][eBusinessEntrance][2], 0);
		}

		SaveBusiness(id); SaveCharacter(playerid);
	}
	else return SendErrorMessage(playerid, "You aren't near a business.");

	return 1;
}

CMD:bizinfo(playerid, params[])
{
	if(!CountPlayerBusiness(playerid))
		return SendErrorMessage(playerid, "You don't own a business.");

	new
		id
	;

	if((id = IsPlayerInBusiness(playerid)) != 0)
	{
		if(BusinessInfo[id][eBusinessOwnerDBID] != PlayerInfo[playerid][pDBID])
			return SendErrorMessage(playerid, "You don't own this business.");

		SendClientMessage(playerid, COLOR_DARKGREEN, "____________________________________________");

		SendClientMessageEx(playerid, COLOR_DARKGREEN, "*** %s ***", BusinessInfo[id][eBusinessName]);

		SendClientMessageEx(playerid, COLOR_WHITE, "Owner:[%s] Level:[%d] Value:[$%s] Type:[%d] Locked:[%s] ID:[%d]", ReturnName(playerid), BusinessInfo[id][eBusinessLevel], MoneyFormat(BusinessInfo[id][eBusinessMarketPrice]),
			BusinessInfo[id][eBusinessType], (BusinessInfo[id][eBusinessLocked] != true) ? ("No") : ("Yes"), BusinessInfo[id][eBusinessDBID]);

		SendClientMessageEx(playerid, COLOR_WHITE, "Cashbox:[$%s] Entrance fee:[$%s] Products:[%d / %d]", MoneyFormat(BusinessInfo[id][eBusinessCashbox]), MoneyFormat(BusinessInfo[id][eBusinessEntranceFee]), BusinessInfo[id][eBusinessProducts], MAX_BUSINESS_PRODUCTS);

		SendClientMessage(playerid, COLOR_DARKGREEN, "____________________________________________");
	}
	else return SendErrorMessage(playerid, "You aren't in a business.");

	return 1;
}

CMD:bizfee(playerid, params[])
{
	if(!CountPlayerBusiness(playerid))
		return SendErrorMessage(playerid, "You don't own a business.");

	new
		id,
		amount
	;

	if((id = IsPlayerInBusiness(playerid)) != 0)
	{
		if(BusinessInfo[id][eBusinessOwnerDBID] != PlayerInfo[playerid][pDBID])
			return SendErrorMessage(playerid, "You don't own this business.");

		if(sscanf(params, "i", amount))
			return SendUsageMessage(playerid, "/bizfee [amount]");

		if(amount > 1500)
			return SendErrorMessage(playerid, "The amount can't be above $1,500.");

		SendServerMessage(playerid, "You set your businesses entrance fee to $%s.", MoneyFormat(amount));

		BusinessInfo[id][eBusinessEntranceFee] = amount;
		SaveBusiness(id);
	}
	else return SendErrorMessage(playerid, "You aren't in a business.");
	return 1;
}

CMD:bizcash(playerid, params[])
{
	if(!CountPlayerBusiness(playerid))
		return SendErrorMessage(playerid, "You don't own a business.");

	new
		id,
		amount,
		astr[30],
		bstr[30]
	;

	if((id = IsPlayerInBusiness(playerid)) != 0)
	{
		if(BusinessInfo[id][eBusinessOwnerDBID] != PlayerInfo[playerid][pDBID])
			return SendErrorMessage(playerid, "You don't own this business.");

		if(sscanf(params, "s[30]S()[30]", astr, bstr))
			return SendUsageMessage(playerid, "/bizcash [balance, deposit, withdraw]");

		if(!strcmp(astr, "balance"))
		{
			SendClientMessageEx(playerid, COLOR_ACTION, "You have $%s in your businesses cashbox.", MoneyFormat(BusinessInfo[id][eBusinessCashbox]));
		}
		else if(!strcmp(astr, "deposit"))
		{
			if(sscanf(bstr, "i", amount))
				return SendUsageMessage(playerid, "/bizcash deposit [amount]");

			if(amount > PlayerInfo[playerid][pMoney])
				return SendErrorMessage(playerid, "You don't have that much money.");

			BusinessInfo[id][eBusinessCashbox]+= amount;
			GiveMoney(playerid, -amount);

			SendClientMessageEx(playerid, COLOR_ACTION, "You deposited $%s into your business. (Total: $%s)", MoneyFormat(amount), MoneyFormat(BusinessInfo[id][eBusinessCashbox]));
			SaveBusiness(id); SaveCharacter(playerid);
		}
		else if(!strcmp(astr, "withdraw"))
		{
			if(sscanf(bstr, "i", amount))
				return SendUsageMessage(playerid, "/bizcash deposit [amount]");

			if(amount > BusinessInfo[id][eBusinessCashbox])
				return SendErrorMessage(playerid, "Your business doesn't have that much money.");

			BusinessInfo[id][eBusinessCashbox] -= amount;
			GiveMoney(playerid, amount);

			SendClientMessageEx(playerid, COLOR_ACTION, "You withdrew $%s from your business. (Total: $%s)", MoneyFormat(amount), MoneyFormat(BusinessInfo[id][eBusinessCashbox]));
			SaveBusiness(id); SaveCharacter(playerid);
		}
		else return SendErrorMessage(playerid, "Invalid Parameter.");
	}
	else return SendErrorMessage(playerid, "You aren't in a business.");
	return 1;
}

CMD:sellbiz(playerid, params[])
{
	new
		id,
		str[128]
	;

	if(!CountPlayerBusiness(playerid))
		return SendErrorMessage(playerid, "You don't own a business.");

	if((id = IsPlayerInBusiness(playerid)) != 0)
	{
		if(BusinessInfo[id][eBusinessOwnerDBID] != PlayerInfo[playerid][pDBID])
			return SendErrorMessage(playerid, "You don't own this business.");

		format(str, sizeof(str), "Are you sure you want to sell your business?\nYou'll earn $%s from selling and $%s from the cashbox.", MoneyFormat(BusinessInfo[id][eBusinessMarketPrice] / 2), MoneyFormat(BusinessInfo[id][eBusinessCashbox]));
		ConfirmDialog(playerid, "Confirmation", str, "OnSellBusiness", id);
	}
	else return SendErrorMessage(playerid, "You aren't in a business.");
	return 1;
}

//Faction commands:
CMD:factionhelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_RED, "[FACTION]:{FFFFFF} /factions, /f, /togfam, /nofam, /factionhelp");

	if(!PlayerInfo[playerid][pFaction])
		return 1;

	SendClientMessageEx(playerid, COLOR_RED, "%s Commands:", ReturnFactionName(playerid));

	if(ReturnFactionType(playerid) == FACTION_TYPE_POLICE)
	{
		SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} /fduty, /offduty, /cuff, /uncuff, /showbadge, /m(egaphone), /(r)adio,");
		SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} /(d)epartmrent, /carsign, /rcarsign, /taser, /take, /givelicense, /impound, /mdc, /wanted");
		SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} /arrest, /ticket, /taser, /checkrobbed, /takerobbed,/flash,/copann");

		if(PlayerInfo[playerid][pFactionRank] <= FactionInfo[PlayerInfo[playerid][pFaction]][eFactionTowRank])
			SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} /towcars");
	}

	if(ReturnFactionType(playerid) == FACTION_TYPE_MEDICAL)
	{
		SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} /fduty, /ofireduty, /healup, /deliver, /fbay, /locker, /m(egaphone), /(d)epartmrent, /(r)adio,");

		if(PlayerInfo[playerid][pFactionRank] <= FactionInfo[PlayerInfo[playerid][pFaction]][eFactionTowRank])
			SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} /towcars");
	}

	if(PlayerInfo[playerid][pFactionRank] <= FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank])
	{
		SendClientMessage(playerid, COLOR_RED, "Leadership:{FFFFFF} /invite, /uninvite, /ouninvite, /rank, /towcars, /factionconfig");
	}

	return 1;
}

CMD:factions(playerid, params[])
{
	new str[182], longstr[556];

	for (new i = 1; i < MAX_FACTIONS; i ++)
	{
		if(!FactionInfo[i][eFactionDBID])
			continue;

		format(str, sizeof(str), "{FFFFFF}%d {ADC3E7} %s {FFFFFF} [%d out of %d]   On Duty: %i\n", i, FactionInfo[i][eFactionName], ReturnOnlineMembers(i), ReturnTotalMembers(i),FactionOnDuty[i]);
		strcat(longstr, str);
	}

	ShowPlayerDialog(playerid, DIALOG_DEFAULT, DIALOG_STYLE_LIST, "Factions:", longstr, "Back", "");
	return 1;
}

CMD:r(playerid, params[])
{

	if(!PlayerInfo[playerid][pFaction])
	return SendErrorMessage(playerid, "You aren't in any faction.");

	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatRank])
	return SendErrorMessage(playerid, "Your rank doesn't have faction chat permissions.");

	if(PlayerInfo[playerid][pFactionChat] == true)
	return SendErrorMessage(playerid, "You are not on duty! Get on duty to use the department radio!");

	if(isnull(params)) return SendUsageMessage(playerid, "/r [text]");

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatStatus] == true)
	{
		if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank])
			return SendErrorMessage(playerid, "Your rank doesn't have permissions to avoid this.");

		if(strlen(params) > 79)
		{
			SendFactionMessage(playerid, "** %s %s: %.79s **", ReturnFactionRank(playerid), ReturnName(playerid), params);
			SendFactionMessage(playerid, "** %s %s: ...%s **", ReturnFactionRank(playerid), ReturnName(playerid), params[79]);
		}
		else SendFactionMessage(playerid, "** %s %s: %s **", ReturnFactionRank(playerid), ReturnName(playerid), params);
		return 1;
	}

	if(strlen(params) > 79)
	{
		SendFactionMessage(playerid, "** %s %s: %.79s **", ReturnFactionRank(playerid), ReturnName(playerid), params);
		SendFactionMessage(playerid, "** %s %s: ...%s **", ReturnFactionRank(playerid), ReturnName(playerid), params[79]);
	}
	else SendFactionMessage(playerid, "** %s %s: %s **", ReturnFactionRank(playerid), ReturnName(playerid), params);
	return 1;
}

CMD:d(playerid, params[])
{

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_MEDICAL && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_DOC)
	return SendErrorMessage(playerid, "You aren't in any faction.");

	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatRank])
	return SendErrorMessage(playerid, "Your rank doesn't have faction chat permissions.");

	if(PlayerInfo[playerid][pFactionChat] == true)
	return SendErrorMessage(playerid, "You are not on duty! Get on duty to use the inter-department radio!");

	if(isnull(params)) return SendUsageMessage(playerid, "/d [text]");

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatStatus] == true)
	{
		if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank])
			return SendErrorMessage(playerid, "Your rank doesn't have permissions to avoid this.");

		if(strlen(params) > 79)
		{
			SendFactionMessageAll(playerid, "** %s %s: %.79s **", ReturnFactionRank(playerid), ReturnName(playerid), params);
			SendFactionMessageAll(playerid, "** %s %s: ...%s **", ReturnFactionRank(playerid), ReturnName(playerid), params[79]);
		}
		else SendFactionMessageAll(playerid, "** %s %s: %s **", ReturnFactionRank(playerid), ReturnName(playerid), params);
		return 1;
	}

	if(strlen(params) > 79)
	{
		SendFactionMessageAll(playerid, "** %s %s: %.79s **", ReturnFactionRank(playerid), ReturnName(playerid), params);
		SendFactionMessageAll(playerid, "** %s %s: ...%s **", ReturnFactionRank(playerid), ReturnName(playerid), params[79]);
	}
	else SendFactionMessageAll(playerid, "** %s %s: %s **", ReturnFactionRank(playerid), ReturnName(playerid), params);
	return 1;
}

/*CMD:dept(playerid, params[])
{
		if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_MEDICAL && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_DOC)
	    return SendErrorMessage(playerid, "You're not in any faction.");

	if (isnull(params))
	    return SendUsageMessage(playerid, "/dept [department radio]");

	for (new i = 0; i != MAX_FACTIONS; i ++) 	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_MEDICAL && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_DOC)
	{
		SendFactionMessage(playerid, COLOR_YELLOW, "** %s %s: ...%s **", ReturnFactionRank(playerid), ReturnName(playerid), params);
	}
	//Log_Write("logs/faction_dept.txt", "[%s] [DEPARTMENTAL] [%s] [%s] %s %s: %s", ReturnDate(), Faction_GetName(playerid), Faction_GetDivision(playerid), Faction_GetRank(playerid), ReturnName(playerid, 0), params);
	return 1;
}*/

CMD:detain(playerid, params[])
{
	new
		criminal,
		vehicleid = GetNearestVehicle(playerid);

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_MEDICAL && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_DOC)
	return SendErrorMessage(playerid, "You aren't in any faction.");

	if (sscanf(params, "u", criminal))
	    return SendUsageMessage(playerid, "/detain [playerid/name]");

	if (criminal == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "That player is disconnected.");

    if (criminal == playerid)
	    return SendErrorMessage(playerid, "You cannot detained yourself.");

    if (!IsPlayerNearPlayer(playerid, criminal, 5.0))
	    return SendErrorMessage(playerid, "You must be near this player.");


	if (vehicleid == INVALID_VEHICLE_ID)
	    return SendErrorMessage(playerid, "You are not near any vehicle.");

	if (GetVehicleMaxSeats(vehicleid) < 2)
  	    return SendErrorMessage(playerid, "You can't detain that player in this vehicle.");

	if (IsPlayerInVehicle(criminal, vehicleid))
	{
		TogglePlayerControllable(criminal, 1);

		RemoveFromVehicle(criminal);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s opens the door and pulls %s out the vehicle.", ReturnName(playerid, 0), ReturnName(criminal, 0));
	}
	else
	{
		new seatid = GetAvailableSeat(vehicleid, 2);

		if (seatid == -1)
		    return SendErrorMessage(playerid, "There are no more seats remaining.");

		new
		    string[64];

		format(string, sizeof(string), "You've been ~r~detained~w~ by %s.", ReturnName(playerid, 0));
		TogglePlayerControllable(criminal, 0);

		PutPlayerInVehicle(criminal, vehicleid, seatid);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s opens the door and places %s into the vehicle.", ReturnName(playerid, 0), ReturnName(criminal, 0));
	}
	return 1;
}

/*CMD:f(playerid, params[])
{

	new factionid;

	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "You aren't in any faction.");

	if(isnull(params)) return SendUsageMessage(playerid, "/f [text]");

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatStatus] == true)
	{
		if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank])
			return SendErrorMessage(playerid, "Your factions chat is disabled. Your rank doesn't have permissions to avoid this.");

		if(strlen(params) > 79)
		{
			SendFactionMessage(playerid, "** [%s] %s %s: %.79s **", ReturnFactionRank(playerid), ReturnName(playerid), params);
			SendFactionMessage(playerid, "** [%s] %s %s: ...%s **", ReturnFactionRank(playerid), ReturnName(playerid), params[79]);
		}
		else SendFactionMessage(playerid, "**[%s] %s %s: %s **", ReturnFactionRank(playerid), ReturnName(playerid), params);
		return 1;
	}

	if(strlen(params) > 79)
	{
		SendFactionMessage(playerid, "** [%s] %s %s: %.79s **", ReturnFactionRank(playerid), ReturnName(playerid), params);
		SendFactionMessage(playerid, "** [%s] %s %s: ...%s **", ReturnFactionRank(playerid), ReturnName(playerid), params[79]);
	}
	else SendFactionMessage(playerid, "** [%s] %s %s: %s **", ReturnFactionRank(playerid), ReturnName(playerid), params);
	return 1;
}*/


CMD:ron(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "You aren't in any faction.");

	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank])
		return SendErrorMessage(playerid, "Your rank doesn't have permission to alter the faction chat.");

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatStatus] == true)
	{
		SendFactionMessageEx(playerid, COLOR_RED, "%s turned the /r chat on.", ReturnName(playerid));
		FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatStatus] = false;
	}
	else
	{
		SendFactionMessageEx(playerid, COLOR_RED, "%s turned the /r chat off.", ReturnName(playerid));
		FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatStatus] = true;
	}
	return 1;
}

CMD:togr(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "You aren't in any faction.");

	if(PlayerInfo[playerid][pFactionChat] == true)
	{
		SendServerMessage(playerid, "You enabled your radio chat.");
		PlayerInfo[playerid][pFactionChat] = false;
	}
	else
	{
		SendServerMessage(playerid, "You disabled your radio chat.");
		PlayerInfo[playerid][pFactionChat] = true;
	}
	return 1;
}

CMD:invite(playerid, params[])
{
	new playerb;

	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "You aren't in any faction.");

	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank])
		return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if(sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/invite [playerid OR name]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified hasn't logged in yet.");

	if(PlayerInfo[playerb][pFaction])
		return SendErrorMessage(playerid, "The player you specified IS already in a faction.");

	PlayerInfo[playerb][pFactionInvite] = PlayerInfo[playerid][pFaction];
	PlayerInfo[playerb][pFactionInvitedBy] = playerid;

	SendClientMessageEx(playerb, COLOR_YELLOW, "%s has invited you to join the %s, type /accept to join.", ReturnName(playerid), ReturnFactionName(playerid));
	SendClientMessageEx(playerid, COLOR_YELLOW, "You invited %s to join the %s.", ReturnName(playerb), ReturnFactionName(playerid));
	return 1;
}

CMD:accept(playerid, params[])
{
	if(PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "You're already in a faction.");

	if(!PlayerInfo[playerid][pFactionInvite])
		return SendErrorMessage(playerid, "You weren't invited to join any faction.");

	SendClientMessageEx(PlayerInfo[playerid][pFactionInvitedBy], COLOR_YELLOW, "%s accepted your faction invitation.", ReturnName(playerid));
	SendClientMessageEx(playerid, COLOR_YELLOW, "You joined the %s!", ReturnFactionNameEx(PlayerInfo[playerid][pFactionInvite]));

	PlayerInfo[playerid][pFaction] = PlayerInfo[playerid][pFactionInvite];
	PlayerInfo[playerid][pFactionRank] = FactionInfo[PlayerInfo[playerid][pFactionInvite]][eFactionJoinRank];

	PlayerInfo[playerid][pFactionInvite] = 0;
	PlayerInfo[playerid][pFactionInvitedBy] = INVALID_PLAYER_ID;

	SaveCharacter(playerid);
	return 1;
}

CMD:uninvite(playerid, params[])
{
	new playerb;

	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "You aren't in any faction.");

	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank])
		return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if(sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/uninvite [playerid OR name]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified hasn't logged in yet.");

	if(PlayerInfo[playerb][pFaction] != PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "The player you specified IS not in your faction.");

	SendClientMessageEx(playerb, COLOR_YELLOW, "You were uninvited from the %s by %s!", ReturnFactionNameEx(PlayerInfo[playerid][pFaction]), ReturnName(playerid));
	SendClientMessageEx(playerid, COLOR_YELLOW, "You uninvited %s!", ReturnName(playerb));

	PlayerInfo[playerb][pFaction] = 0;
	PlayerInfo[playerb][pFactionRank] = 0;

	SetPlayerSkin(playerb, 20003); PlayerInfo[playerb][pLastSkin] = 20003;
	PlayerInfo[playerb][pLastSkin] = 20003;
	SCM(playerb, COLOR_RED, "The skin that have been assigned to you is a noob skin. Please do not roleplay using this skin.");
	SaveCharacter(playerb);
	return 1;
}

CMD:ouninvite(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "You aren't in any faction.");

	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank])
		return SendErrorMessage(playerid, "You don't have permission to use this command.");

	new thread[128];

	if(isnull(params))
		return SendUsageMessage(playerid, "/ouninvite [Firstname_Lastname]");

	foreach(new i : Player)
	{
		if(!strcmp(ReturnName(i), params))
		{
			SendServerMessage(playerid, "%s is connected to the server. (ID: %i)", ReturnName(i), i);
			return 1;
		}
	}

	mysql_format(ourConnection, thread, sizeof(thread), "SELECT char_dbid, pFaction, pFactionRank FROM characters WHERE char_name = '%e'", params);
	new Cache:cache = mysql_query(ourConnection, thread);

	if(!cache_num_rows())
	{
		SendServerMessage(playerid, "%s does not exist in the database.", params);
		cache_delete(cache);
		return 1;
	}

	new playerDBID = cache_get_field_content_int(0, "char_dbid");
	new playerFaction = cache_get_field_content_int(0, "pFaction");
	new playerRank = cache_get_field_content_int(0, "pFactionRank");

	if(playerFaction != PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "%s is not in your faction.", params);

	if(playerRank > PlayerInfo[playerid][pFactionRank])
		return SendErrorMessage(playerid, "%s exceeds your faction rank.", params);


	mysql_format(ourConnection, thread, sizeof(thread), "UPDATE characters SET pFaction = 0, pFactionRank = 0, pLastSkin = 20003 WHERE char_dbid = %i", playerDBID);
	mysql_tquery(ourConnection, thread); cache_delete(cache);

	SendServerMessage(playerid, "%s was removed from the faction.", params);
	return 1;
}

CMD:giverank(playerid, params[])
{
	new playerb, rank;

	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "You aren't in any faction.");

	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank])
		return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if(sscanf(params, "ui", playerb, rank))
	{
		for(new i = 1; i < MAX_FACTION_RANKS; i++)
		{
			if(!strcmp(FactionRanks[PlayerInfo[playerid][pFaction]][i], "NotSet"))
				continue;

			SendClientMessageEx(playerid, COLOR_YELLOWEX, "-> Rank %i: %s", i, FactionRanks[PlayerInfo[playerid][pFaction]][i]);
		}

		SendUsageMessage(playerid, "/rank [playerid OR name] [rank id]");
		return 1;
	}

	if(rank < 1 || rank > 20)
		return SendErrorMessage(playerid, "You specified an invalid rank.");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified hasn't logged in yet.");

	if(PlayerInfo[playerb][pFaction] != PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "The player you specified IS not in your faction.");

	SendClientMessageEx(playerb, COLOR_LIGHTBLUE, "Your have been promoted to a %s by %s!", FactionRanks[PlayerInfo[playerb][pFaction]][rank], ReturnName(playerid, 0));
	SendClientMessageEx(playerid, COLOR_LIGHTBLUE, "You have promoted %s to a %s!", ReturnName(playerb, 0),  FactionRanks[PlayerInfo[playerb][pFaction]][rank]);

	PlayerInfo[playerb][pFactionRank] = rank;
	SaveCharacter(playerb);
	return 1;
}

CMD:factionconfig(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4)
		return SendErrorMessage(playerid, "You don't have the permission to use this command.");

	ShowFactionConfig(playerid);
	return 1;
}

CMD:factionon(playerid, params[])
{
	new factionid;

	if(sscanf(params, "I(-1)", factionid))
		return SendUsageMessage(playerid, "/factionon [factionid]");

	if(factionid == -1)
	{
		if(!PlayerInfo[playerid][pFaction])
			return SendErrorMessage(playerid, "You aren't in any faction.");

		SendClientMessageEx(playerid, COLOR_GREY, "Members of %s online:", ReturnFactionName(playerid));

		foreach(new i : Player)
		{
			if(PlayerInfo[i][pFaction] != PlayerInfo[playerid][pFaction])
				continue;

			if(PlayerInfo[i][pAdminDuty])
				SendClientMessageEx(playerid, COLOR_GREY, "(ID: %i) {FF9900}%s %s", i, ReturnFactionRank(i), ReturnName(i));

			else
				SendClientMessageEx(playerid, COLOR_GREY, "(ID: %i) %s %s", i, ReturnFactionRank(i), ReturnName(i));
		}

		return 1;
	}

	if(!FactionInfo[factionid][eFactionDBID])
		return SendErrorMessage(playerid, "The faction you specified doesn't exist.");

	SendClientMessageEx(playerid, COLOR_RED, "[ ! ]{FFFFFF} %s has %i out of %i members online.",  ReturnFactionNameEx(factionid), ReturnOnlineMembers(factionid), ReturnTotalMembers(factionid));
	return 1;
}
//Fire commands:
CMD:healup(playerid, params[])
{
    new victim,Float:health;
	new Float:x, Float:y, Float:z;
	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_MEDICAL)
	return SCM(playerid, COLOR_LIGHTRED, "You are not a firefighter.");
    if(sscanf(params, "u", victim)) return SendClientMessage(playerid, COLOR_GREY, "/healup (id)");
    if(victim == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_LIGHTRED, "That player is not connected.");
    if(PlayerInfo[victim][pIsAlive] == 1) return SCM(playerid, COLOR_LIGHTRED, "That player is not injured.");

	GetPlayerPos(victim, x, y, z);
	if(IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z))
	{
		GetPlayerHealth(victim, health);
		if (health < 40)
		{
 		SetPlayerHealth(victim, 60);
 		}
        else return SCM(playerid, COLOR_LIGHTRED, "This Player is not underneath 40 health yet.");
	}
	else return SCM(playerid, COLOR_LIGHTRED, "You're not close to that player.");
  	return 1;
}

CMD:deliver(playerid, params[])
{
    new victim;

 	if(sscanf(params, "u", victim))
	return SendUsageMessage(playerid, "/deliver [playerid]");

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_MEDICAL)
	return SCM(playerid, COLOR_LIGHTRED, "You are not an EMT or a Firefighter.");


    if(victim == INVALID_PLAYER_ID)
	return SendClientMessage(playerid, COLOR_LIGHTRED, "That player is not connected.");

    if(PlayerInfo[victim][pIsAlive] == 1)
    return SendErrorMessage(playerid, "This player is not injured.");

    if(!IsPlayerInRangeOfPoint(playerid, 10.0, -2504.4973,2367.6221,5.0401))
	return SCM(playerid, COLOR_LIGHTRED, "You're not at the patient delivery point.");

	SCM(victim, COLOR_LIGHTRED, "The medics have brought you in. You are now being treated by the doctors.");
  	SCM(victim, COLOR_LIGHTRED, "You have been treated and have been discharged. Your medical bill is $500.");
	GiveMoney(victim, -500);
	KillTimer(Deadtimer[victim]);
	isDead[victim] = false;
	SetPlayerHealth(victim, 50);
	ClearAnimations(victim);
	SetPlayerPos(victim, -2491.6150, 2362.9348, 10.3187);
 	SetPlayerInterior(victim, 0);
 	SetPlayerVirtualWorld(victim, 0);
 	SetCameraBehindPlayer(victim);
	ClearDamages(victim);

	return 1;
}

CMD:fduty(playerid, params[])
{
	new str[128];

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_MEDICAL)
	return SCM(playerid, COLOR_LIGHTRED, "You are not an EMT or a Firefighter.");

	if(!IsPlayerInRangeOfPoint(playerid, 10.0, -2594.9731,4014.6460,2004.7198))
		return SendErrorMessage(playerid, "You aren't near your lockers.");

    PlayerInfo[playerid][pMedicDuty] = true;

	if(PlayerInfo[playerid][pMedicDuty] == true)
	{
		format(str, sizeof(str), "** HQ: %s %s is now 10-8! **", ReturnFactionRank(playerid), ReturnName(playerid, 0));
		SendMedicalMessage(5, str);
		SendClientMessage(playerid, COLOR_WHITE, "You were given: Fire Extinguisher, Shovel, Chainsaw, Armour (100), Health(100)");
		cmd_me(playerid, "reaches into the lockers, and gears up.");
 	}
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 100);

	GivePlayerWeapon(playerid, 6, 10);
	GivePlayerWeapon(playerid, 9, 10);
	GivePlayerWeapon(playerid, 10, 10);
	GivePlayerWeapon(playerid, 9, 10);
	GivePlayerWeapon(playerid, 42, 500);
	SetPlayerColor(playerid, COLOR_RED);

	return 1;
}

CMD:ofireduty(playerid, params[])
{
	new str[128];

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_MEDICAL)
	return SCM(playerid, COLOR_LIGHTRED, "You are not an EMT or a Firefighter.");

	if(!IsPlayerInRangeOfPoint(playerid, 10.0, -2594.9731,4014.6460,2004.7198))
		return SendErrorMessage(playerid, "You aren't near your lockers.");

    PlayerInfo[playerid][pMedicDuty] = false;

	if(PlayerInfo[playerid][pMedicDuty] == false)
	{
		format(str, sizeof(str), "** HQ: %s %s is now 10-7! **", ReturnFactionRank(playerid), ReturnName(playerid, 0));
		SendMedicalMessage(5, str);
    	cmd_me(playerid, "reaches into the lockers, and places their equipment back into it.");
 	}

	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 100);
	SetPlayerColor(playerid, COLOR_WHITE);

	if(GetPlayerSkin(playerid) != PlayerInfo[playerid][pLastSkin])
		SetPlayerSkin(playerid, PlayerInfo[playerid][pLastSkin]);

	return 1;
}

/*CMD:load(playerid, params[])
{
	static
	    userid,
		seatid;

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_MEDICAL)
	return SCM(playerid, COLOR_LIGHTRED, "You are not an EMT or a Firefighter.");

	if (sscanf(params, "u", userid))
	    return SendUsageMessage(playerid, "/loadinjured [playerid/name]");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 10.0))
	    return SendErrorMessage(playerid, "That player is disconnected or not near you.");

	if (userid == playerid)
	    return SendErrorMessage(playerid, "You can't load yourself into an ambulance.");

	if (!PlayerData[userid][pInjured])
	    return SendErrorMessage(playerid, "That player is not injured.");

	for (new i = 0; i != MAX_VEHICLES; i ++) if (IsPlayerNearBoot(playerid, i) && GetVehicleModel(i) == 416)
	{
	    seatid = GetAvailableSeat(i, 2);

	    if (seatid == -1)
	        return SendErrorMessage(playerid, "There is no room for the patient.");

		ClearAnimations(userid);
		PlayerData[userid][pInjured] = 2;

		PutPlayerInVehicle(userid, i, seatid);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s opens up the ambulance and loads %s on the stretcher.", ReturnName(playerid, 0), ReturnName(userid, 0));

		TogglePlayerControllable(userid, 0);
		SetPlayerHealth(userid, 100.0);
		return 1;
	}
	SendErrorMessage(playerid, "You must be near an ambulance.");
	return 1;
}*/



// This needs testing
/*CMD:load(playerid, params[])
{
    new seat, string[128], playerb, giveplayerid, victim ;

 	if(sscanf(params, "u", victim))
	return SendUsageMessage(playerid, "/load [playerid] [seatid]");

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_MEDICAL)
	return SCM(playerid, COLOR_LIGHTRED, "You are not an EMT or a Firefighter.");


    if(victim == INVALID_PLAYER_ID)
	return SendClientMessage(playerid, COLOR_LIGHTRED, "That player is not connected.");

    if(PlayerInfo[victim][pIsAlive] == 1)
    return SendErrorMessage(playerid, "This player is not injured.");

    if(seat < 2 || seat > 3)
    SendClientMessageEx(playerid, COLOR_GRAD1, "The seat ID cannot be above 3 or below 2.");

	new carid;
	if(IsAmbulance(carid))

	new Float:pos[6];
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	GetPlayerPos(giveplayerid, pos[3], pos[4], pos[5]);
	GetVehiclePos( carid, pos[0], pos[1], pos[2]);
	if (floatcmp(floatabs(floatsub(pos[0], pos[3])), 10.0) != -1 &&
	floatcmp(floatabs(floatsub(pos[1], pos[4])), 10.0) != -1 &&
	floatcmp(floatabs(floatsub(pos[2], pos[5])), 10.0) != -1) return false;
	format(string, sizeof(string), "* You were loaded by paramedic %s.", ReturnName(playerid));
	SendClientMessage(giveplayerid, COLOR_RED, string);
	format(string, sizeof(string), "* You loaded patient %s.", ReturnName(playerid));
	SendClientMessage(playerid, COLOR_RED, string);
	format(string, sizeof(string), "* %s loads %s in the ambulance.", ReturnName(playerid), ReturnName(playerb));
	ClearAnimations(giveplayerid);
	PutPlayerInVehicle(giveplayerid,carid,seat);

	return 1;
}*/



//Police commands:

CMD:checkrobbed(playerid, params[])
{
	new criminal, str[128], str2[128];
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
    if(sscanf(params, "u", criminal)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /checkrobbed [ID].");

    if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You can't use this command.");

    if(!IsPlayerConnected(criminal))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

    format(str, sizeof(str), "Amount Robbed: $%i (%s)", PlayerInfo[criminal][pRobbedCash], ReturnName(criminal));
    format(str2, sizeof(str2), "Time Robbed: %s", PlayerInfo[criminal][pTimeRobbed]);

    GetPlayerPos(criminal, X, Y, Z);
	if(IsPlayerInRangeOfPoint(playerid, 7.0, X, Y, Z))
	{
	    SCM(playerid, COLOR_WHITE, str);
	    SCM(playerid, COLOR_WHITE, str2);
	}
	return 1;
}

CMD:takerobbed(playerid, params[])
{
    new Float:X, Float:Y, Float:Z, criminal;
    GetPlayerPos(playerid, X, Y, Z);
    GetPlayerPos(criminal, X, Y, Z);
    if(sscanf(params, "u", criminal)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /takerobbed [ID].");

    if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You can't use this command.");

  	new str[128];
	format(str, sizeof(str), "%s has just revoked $%i from %s which was robbed on %s.", ReturnName(playerid),PlayerInfo[criminal][pRobbedCash] ,ReturnName(criminal), PlayerInfo[criminal][pTimeRobbed]);
	SendAdminMessage(1, str);

    if(!IsPlayerConnected(criminal))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

    GiveMoney(criminal, -PlayerInfo[criminal][pRobbedCash]);
    PlayerInfo[criminal][pRobbedCash] = 0;
    PlayerInfo[criminal][pRobbedCash] = 0;
	return 1;
}

CMD:arrest(playerid, params[])
{
    new criminal, time, string[128];
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(criminal, X, Y, Z);

    if(sscanf(params, "ud", criminal, time)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /arrest [ID] [minutes].");
    if(criminal == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_LIGHTRED, "That player is not connected.");
    if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You can't use this command.");
    if(time > 120) return SCM(playerid, COLOR_LIGHTRED, "You can't give jail sentances that exceed two hours.");

 	GetPlayerPos(criminal, X, Y, Z);
	if(IsPlayerInRangeOfPoint(playerid, 5.0, X, Y, Z))
	{
		PlayerInfo[criminal][pJailTime] = time*60;
		format(string, sizeof(string), "[TR-SP:] %s has jailed %s for %d minutes.", ReturnName(playerid, 0), ReturnName(criminal, 0), time);
		SendClientMessageToAll(COLOR_BSSD, string);
		PlayerInfo[criminal][pInJail] = 1;
		PlayerInfo[criminal][pActiveListings] = 0;
		PlayerInfo[criminal][pJailTimes] += 1;
		SaveCharacter(criminal);
	} else return SCM(playerid, COLOR_LIGHTRED, "You're not close to that player.");
  	return 1;
}

CMD:ticket(playerid, params[])
{
	new criminal,
	amount,
	reason[64],
	Float:x,
	Float:y,
	Float:z,
	primary_str[500],
	sub_str[500]
	;
	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You can't use this command.");
	if(sscanf(params, "uis[64]", criminal, amount, reason)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /ticket [ID] [amount] [reason].");
	if(criminal == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_LIGHTRED, "That player is not connected.");
	if(amount < 1 || amount > 10000) return SendClientMessage(playerid, COLOR_LIGHTRED, "Tickets can only range between 1-10000 dollars.");
	SetPVarInt(criminal, "amount", amount);
	GivePlayerMoney(playerid,500);
	GetPlayerPos(criminal, x, y, z);
	SetPlayerWantedLevel(playerid,0);
	if(IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z))
	{
	format(sub_str, sizeof(sub_str), "Officer name: %s\nDate of violation: %s\nTime of violoation: %s\n\nOffender name: %s\nDate of Birth(DOB): %s\n\n", ReturnName(playerid), ReturnTicketDate(), ReturnTicketTime(), ReturnName(criminal), (PlayerInfo[criminal][pAge]));
	strcat(primary_str, sub_str);
	format(sub_str, sizeof(sub_str), "Violation: %s\nAmount: $%d\n", reason, amount);
	strcat(primary_str, sub_str);
	format(sub_str, sizeof(sub_str), "IMORTANT TO READ:\nYou have been given a ticket by the:\nMgMc Police Department Patrol.\nBy signing this ticket you Agree to the terms\nWithout admitting guilt, I  promise to comply\nwith the terms of this ticket and release.\n\nSignature: ________________________\n");
	strcat(primary_str, sub_str);
	ShowPlayerDialog(criminal, DIALOG_FINE, DIALOG_STYLE_MSGBOX, "MgMc Police Department", primary_str, "Sign", "Deny");
	}
	else return SCM(playerid, COLOR_LIGHTRED, "You're not close to that player.");
	return 1;
}

CMD:drag(playerid, params[])
{
	new criminal,
	Float:dX, Float:dY, Float:dZ;
	GetPlayerPos(criminal, dX, dY, dZ);
	if(sscanf(params, "u", criminal)) return SCM(playerid, COLOR_GREY, "USAGE: /drag [playerid]");
	
	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You can't use this command.");
	if(criminal == playerid)
		return SendErrorMessage(playerid, "You can't drag yourself.");
	if(criminal == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, COLOR_LIGHTRED, "That player is not connected.");
	if(IsPlayerInAnyVehicle(playerid))
		return SendErrorMessage(playerid, "You must be out of the vehicle to use this command.");
	if(GetPVarInt(criminal, "criminal") == 1)
		return SendErrorMessage(playerid, "That player is already being dragged.");
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, dX, dY, dZ))
		return SendErrorMessage(playerid, "That suspect is not near you.");

	SetPVarInt(criminal, "BeingDragged", 1);
	SetPVarInt(playerid, "DraggingPlayer", criminal);
	SetPVarInt(criminal, "DraggedByPlayer", playerid);
	dragtimer[playerid] = SetTimerEx("DragPlayer", 1000, 1, "ii", playerid, criminal);
	SCMex(playerid, COLOR_YELLOW, "You're now dragging: %s", ReturnName(criminal));
	SCMex(criminal, COLOR_YELLOW, "You're being dragged by: %s", ReturnName(playerid));
	return 1;
}

CMD:duty(playerid, params[])
{
	new factionid = PlayerInfo[playerid][pFaction];

	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "You aren't in any faction.");

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You can't use this command.");

	if(PlayerInfo[playerid][pPoliceDuty])
		return SendErrorMessage(playerid, "You're already on duty.");

	if(!IsPlayerInRangeOfPoint(playerid, 10.0,-2655.2791,2242.7988,1013.9836))
		return SendErrorMessage(playerid, "You aren't near your lockers.");

	PlayerInfo[playerid][pPoliceDuty] = true;
	FactionOnDuty[factionid] += 1;

	for(new i = 0; i < 12; i++)
	{
		playerWeaponsSave[playerid][i] = PlayerInfo[playerid][pWeapons][i];
		playerWeaponsAmmoSave[playerid][i] = PlayerInfo[playerid][pWeaponsAmmo][i];
	}

	SendPoliceMessage(COLOR_COP, "** HQ: %s %s is now 10-8! **", ReturnFactionRank(playerid), ReturnName(playerid, 0));
	SendClientMessage(playerid, COLOR_WHITE, "You were given: Spraycan, Nitestick, Desert Eagle (60), Health(100)");

	cmd_me(playerid, "reaches into the lockers, and gears up.");

	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 100);

	TakePlayerGuns(playerid);

	GivePlayerGun(playerid, 24, 100);
	GivePlayerGun(playerid, 3, 1);
	GivePlayerGun(playerid, 41, 350);

	if(!PlayerInfo[playerid][pAdminDuty])
		SetPlayerColor(playerid, COLOR_COP);

	return 1;
}

CMD:offduty(playerid, params[])
{
    new factionid = PlayerInfo[playerid][pFaction];

	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "You aren't in any faction.");

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You can't use this command.");

	if(!PlayerInfo[playerid][pPoliceDuty])
		return SendErrorMessage(playerid, "You aren't on duty.");

	if(!IsPlayerInRangeOfPoint(playerid, 10.0,-2655.2791,2242.7988,1013.9836))
		return SendErrorMessage(playerid, "You aren't near your faction spawn.");

	PlayerInfo[playerid][pPoliceDuty] = false;
	FactionOnDuty[factionid] -= 1;

	ResetPlayerWeapons(playerid);

	for(new i = 0; i < 12; i++)
	{
		PlayerInfo[playerid][pWeapons][i] = 0; PlayerInfo[playerid][pWeaponsAmmo][i] = 0;

		if(playerWeaponsSave[playerid][i])
			GivePlayerGun(playerid, playerWeaponsSave[playerid][i], playerWeaponsAmmoSave[playerid][i]);
	}

	SendPoliceMessage(COLOR_COP, "** HQ: %s %s is now 10-7! **", ReturnFactionRank(playerid), ReturnName(playerid, 0));
	cmd_me(playerid, "reaches into the lockers, putting their equipment away.");

	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 100);

	if(!PlayerInfo[playerid][pAdminDuty])
		SetPlayerColor(playerid, COLOR_WHITE);

	if(GetPlayerSkin(playerid) != PlayerInfo[playerid][pLastSkin])
		SetPlayerSkin(playerid, PlayerInfo[playerid][pLastSkin]);

	return 1;
}

CMD:cuff(playerid, params[])
{
    new Float:X, Float:Y, Float:Z;
    GetPlayerPos(playerid, X, Y, Z);
	new criminal;

    if(sscanf(params, "u", criminal)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /cuff [ID].");
   	if(!IsPlayerConnected(criminal))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");
    if(criminal == playerid) return SendClientMessage(playerid, COLOR_LIGHTRED, "You can't cuff yourself.");
    if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You can't use this command.");

	GetPlayerPos(criminal, X, Y, Z);
	if(IsPlayerInRangeOfPoint(playerid, 7.0, X, Y, Z))
	{
	    ClearAnimations(criminal);
	    SetPlayerSpecialAction(criminal, SPECIAL_ACTION_NONE);
		SetPlayerSpecialAction(criminal, SPECIAL_ACTION_CUFFED);
		SetPlayerAttachedObject(criminal, 9, 19418, 6, -0.011000, 0.028000, -0.022000, -15.600012, -33.699977, -81.700035, 0.891999, 1.000000, 1.168000);
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s handcuffs %s *", ReturnName(playerid), ReturnName(criminal));
		PlayerInfo[criminal][pHandcuffed] = true;
	} else return SCM(playerid, COLOR_LIGHTRED, "You're not close enough.");
	return 1;
}

CMD:uncuff(playerid, params[])
{
    new
	criminal, Float:X, Float:Y, Float:Z;

    if(sscanf(params, "u", criminal)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /uncuff [ID].");
    if(criminal == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_LIGHTRED, "That player is not connected.");
    if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You can't use this command.");

    GetPlayerPos(criminal, X, Y, Z);
    if(IsPlayerInRangeOfPoint(playerid, 7.0, X, Y, Z))
	{
	    ClearAnimations(criminal);
	    SetPlayerSpecialAction(criminal, SPECIAL_ACTION_NONE);
	    RemovePlayerAttachedObject(criminal, 9);
		PlayerInfo[criminal][pHandcuffed] = false;
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s uncuffs %s *", ReturnName(playerid), ReturnName(criminal));
	} else return SCM(playerid, COLOR_LIGHTRED, "You're not close enough.");
  	return 1;
}

CMD:showbadge(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "You aren't in any faction.");

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You can't use this command.");

	new playerb;

	if(sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/showbadge [playerid OR name]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(!PlayerInfo[playerb][pLoggedin])
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	if(!IsPlayerNearPlayer(playerid, playerb, 5.0))
		return SendErrorMessage(playerid, "You aren't near that player.");

	if(playerb == playerid)
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s looks at their badge.", ReturnName(playerid, 0));

	else SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s shows their badge to %s.", ReturnName(playerid, 0), ReturnName(playerb, 0));

	SendClientMessage(playerb, COLOR_COP, "____________DEPARTMENTAL ISSUED BADGE____________");

	SendClientMessageEx(playerb, COLOR_GRAD2, "  Name: %s", ReturnNameLetter(playerid));
	SendClientMessageEx(playerb, COLOR_GRAD2, "  Rank: %s", ReturnFactionRank(playerid));
	SendClientMessageEx(playerb, COLOR_GRAD2, "  Department: %s", ReturnFactionName(playerid));
	SendClientMessageEx(playerb, COLOR_GRAD2, "  Official has the authority to arrest and use Lethal or Non-Lethal force.");

	SendClientMessage(playerb, COLOR_COP, "____________STATE OF TIERRA ROBADA____________");
	return 1;
}

CMD:m(playerid, params[]) return cmd_megaphone(playerid, params);
CMD:megaphone(playerid, params[])
{
	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "You aren't in any faction.");

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_MEDICAL)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You can't use this command.");

	if(!IsPlayerInAnyVehicle(playerid))
		return SendErrorMessage(playerid, "You aren't in any vehicle.");

	if(isnull(params))
		return SendUsageMessage(playerid, "/megaphone [text]");

	SendNearbyMessage(playerid, 40.0, COLOR_YELLOWEX, "[ %s %s:o< %s ]", ReturnFactionRank(playerid), ReturnName(playerid, 0), params);
	return 1;
}

CMD:carsign(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
		return SendErrorMessage(playerid, "You aren't in any vehicle.");

	new
		vehicleid = GetPlayerVehicleID(playerid);

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_MEDICAL && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_DOC)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You can't use this command.");

	if(isnull(params))
		return SendUsageMessage(playerid, "/carsign [text]");

	if(strlen(params) < 2 || strlen(params) >= 50)
		return SendErrorMessage(playerid, "Your text has to be greater than 1 char and less than 50.");

	if(!VehicleInfo[vehicleid][eVehicleFaction])
		return SendErrorMessage(playerid, "You aren't in a faction vehicle.");

	if(VehicleInfo[vehicleid][eVehicleHasCarsign])
		Update3DTextLabelText(VehicleInfo[vehicleid][eVehicleCarsign], COLOR_WHITE, params);

	else
	{
		SendServerMessage(playerid, "Use \"/remove_carsign\" to destroy it next.");

		VehicleInfo[vehicleid][eVehicleCarsign] = Create3DTextLabel(params, COLOR_WHITE, 0.0, 0.0, 0.0, 25.0, GetPlayerVirtualWorld(playerid), 0);
		Attach3DTextLabelToVehicle(VehicleInfo[vehicleid][eVehicleCarsign], vehicleid, -0.7, -1.9, -0.3);

		VehicleInfo[vehicleid][eVehicleHasCarsign] = true;
	}

	return 1;
}

CMD:rcarsign(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
		return SendErrorMessage(playerid, "You aren't in any vehicle.");

	new
		vehicleid = GetPlayerVehicleID(playerid);

	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_MEDICAL && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_DOC)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You can't use this command.");

	if(!VehicleInfo[vehicleid][eVehicleFaction])
		return SendErrorMessage(playerid, "You aren't in a faction vehicle.");

	if(!VehicleInfo[vehicleid][eVehicleHasCarsign])
		return SendErrorMessage(playerid, "Your vehicle doesn't have a carsign.");

	Delete3DTextLabel(VehicleInfo[vehicleid][eVehicleCarsign]);
	VehicleInfo[vehicleid][eVehicleHasCarsign] = true;

	SendServerMessage(playerid, "You deleted your vehicles carsign.");
	return 1;
}

CMD:taser(playerid, params[])
{
	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You can't use this command.");

	if(!PlayerInfo[playerid][pPoliceDuty])
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You can't use this command.");

	if(!PlayerHasWeapon(playerid, 24) && !PlayerInfo[playerid][pTaser])
		return SendErrorMessage(playerid, "You don't have a taser on you.");

	if(!PlayerInfo[playerid][pTaser])
	{
		GetPlayerWeaponData(playerid, WeaponDataSlot(24), PlayerInfo[playerid][pWeapons][ReturnWeaponIDSlot(24)], playerTaserAmmo[playerid]);

		PlayerInfo[playerid][pTaser] = true;
		GivePlayerGun(playerid, 23, 5);

		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s takes out their taser.", ReturnName(playerid, 0));
	}
	else
	{
		GivePlayerGun(playerid, 24, playerTaserAmmo[playerid]);
		PlayerInfo[playerid][pTaser] = false;

		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s puts their taser away.", ReturnName(playerid, 0));
	}
	return 1;
}

CMD:towcars(playerid, params[])
{
	new
		bool:vehicle_found = false,
		factionid
	;

	if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionTowRank] && !PlayerInfo[playerid][pAdminDuty])
		return SendUnauthMessage(playerid);

	if(PlayerInfo[playerid][pAdminDuty])
	{
		if(sscanf(params, "i", factionid))
			return SendUsageMessage(playerid, "/towcars [faction ID]");

		if(!FactionInfo[factionid][eFactionDBID] || factionid > MAX_FACTIONS)
			return SendErrorMessage(playerid, "You specified an invalid faction ID.");

		for(new f = 1, j = GetVehiclePoolSize(); f <= j; f++)
		{
			if(VehicleInfo[f][eVehicleFaction] == factionid)
			{
				if(!IsVehicleOccupied(f))
				{
					vehicle_found = true;
					SetVehicleToRespawn(f);
				}
			}
		}

		if(vehicle_found)
		{
			foreach(new g : Player) if(PlayerInfo[g][pFaction] == factionid)
				SendFactionMessageEx(playerid, COLOR_RED, "Administrator %s returned all faction vehicles back to their parking places.", ReturnName(playerid));
		}
		else SendErrorMessage(playerid, "No vehicles were available for tow.");
		return 1;
	}

	for(new i = 1, j = GetVehiclePoolSize(); i <= j; i++)
	{
		if(VehicleInfo[i][eVehicleFaction] == PlayerInfo[playerid][pFaction])
		{
			if(!IsVehicleOccupied(i))
			{
				vehicle_found = true;
				SetVehicleToRespawn(i);
			}
		}
	}

	if(vehicle_found)
		SendFactionMessageEx(playerid, COLOR_RED, "%s returned all faction vehicles to back to their parking places.", ReturnName(playerid));

	else SendErrorMessage(playerid, "No vehicles were available for tow.");

	return 1;
}

CMD:take(playerid, params[])
{
	if(ReturnFactionType(playerid) != FACTION_TYPE_POLICE)
		return SendUnauthMessage(playerid);

	new
		playerb,
		a_str[60]
	;

	if(sscanf(params, "us[60]", playerb, a_str))
	{
		SendUsageMessage(playerid, "/take [playerid OR name] [item]");
		SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} Driverlicense, Weaponlicense, Weapons, Mask, Radio, Fishingrod, Gascan, Worms, Fish, Explosives");
		return 1;
	}

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "You specified an invalid player.");

	if(!PlayerInfo[playerb][pLoggedin])
		return SendErrorMessage(playerid, "You specified a player that isn't logged in.");

	if(!IsPlayerNearPlayer(playerid, playerb, 4.0))
		return SendErrorMessage(playerid, "You aren't near that player.");

	if(!strcmp(a_str, "driverlicense"))
	{
		if(!PlayerInfo[playerb][pDriversLicense])
			return SendErrorMessage(playerid, "%s doesn't have a driver's license.", ReturnName(playerb, 0));

		PlayerInfo[playerb][pDriversLicense] = 0;
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s %s took %s's driver's license.", ReturnFactionRank(playerid), ReturnName(playerid, 0), ReturnName(playerb, 0));
	}
	else if(!strcmp(a_str, "weaponlicense"))
	{
		if(!PlayerInfo[playerb][pWeaponsLicense])
			return SendErrorMessage(playerid, "%s doesn't have a weapons license.", ReturnName(playerb, 0));

		PlayerInfo[playerb][pWeaponsLicense] = 0;
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s %s took %s's weapons license.", ReturnFactionRank(playerid), ReturnName(playerid, 0), ReturnName(playerb, 0));
	}
	else if(!strcmp(a_str, "weapons"))
	{
	    for(new i = 0; i < 12; i ++)
		{
			if(PlayerInfo[playerb][pWeapons][i] != 0)
			{
				TakePlayerGuns(playerb);
				SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s %s took %s's weapons.", ReturnFactionRank(playerid), ReturnName(playerid, 0), ReturnName(playerb, 0));
				return 1;
			}
		}
		SendErrorMessage(playerid, "This player does not have any weapons");
		return 1;
	}
	else if(!strcmp(a_str, "mask"))
	{
	    if(PlayerInfo[playerb][pHasMask] == false)
	        return SendErrorMessage(playerid, "This player does not have any masks");
		PlayerInfo[playerb][pHasMask] = false;
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s %s took %s's mask.", ReturnFactionRank(playerid), ReturnName(playerid, 0), ReturnName(playerb, 0));
		return 1;
	}
	else if(!strcmp(a_str, "radio"))
	{
	    if(PlayerInfo[playerb][pHasRadio] == false)
	        return SendErrorMessage(playerid, "This player does not have any radio's");
		PlayerInfo[playerb][pHasRadio] = false;
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s %s took %s's radio.", ReturnFactionRank(playerid), ReturnName(playerid, 0), ReturnName(playerb, 0));
		return 1;
	}
	else if(!strcmp(a_str, "fishingrod"))
	{
	    if(PlayerInfo[playerb][pFishingRod] <= 0)
	        return SendErrorMessage(playerid, "This player does not have any fishingrods");
		PlayerInfo[playerb][pFishingRod] = 0;
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s %s took %s's fishing rod.", ReturnFactionRank(playerid), ReturnName(playerid, 0), ReturnName(playerb, 0));
		return 1;
	}
	else if(!strcmp(a_str, "gascan"))
	{
	    if(PlayerInfo[playerb][pGascan] <= 0)
	        return SendErrorMessage(playerid, "This player does not have any gascans");
		PlayerInfo[playerb][pGascan] = 0;
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s %s took %s's gas can.", ReturnFactionRank(playerid), ReturnName(playerid, 0), ReturnName(playerb, 0));
		return 1;
	}
	else if(!strcmp(a_str, "worms"))
	{
	    if(PlayerInfo[playerb][pWorms] <= 0)
	        return SendErrorMessage(playerid, "This player does not have any worms");
		PlayerInfo[playerb][pWorms] = 0;
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s %s took %s's worms.", ReturnFactionRank(playerid), ReturnName(playerid, 0), ReturnName(playerb, 0));
		return 1;
	}
	else if(!strcmp(a_str, "fish"))
	{
	    if(PlayerInfo[playerb][pFishes] <= 0)
	        return SendErrorMessage(playerid, "This player does not have any fish");
		PlayerInfo[playerb][pFishes] = 0;
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s %s took %s's fish.", ReturnFactionRank(playerid), ReturnName(playerid, 0), ReturnName(playerb, 0));
		return 1;
	}
	else if(!strcmp(a_str, "explosives"))
	{
	    if(PlayerInfo[playerb][pExplosives] <= 0)
	        return SendErrorMessage(playerid, "This player does not have any explosives");
		PlayerInfo[playerb][pExplosives] = 0;
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s %s took %s's explosives.", ReturnFactionRank(playerid), ReturnName(playerid, 0), ReturnName(playerb, 0));
		return 1;
	}
	else return SendServerMessage(playerid, "Invalid Parameter.");
	return 1;
}

CMD:givelicense(playerid, params[])
{
	if(ReturnFactionType(playerid) != FACTION_TYPE_POLICE)
		return SendUnauthMessage(playerid);

	if(PlayerInfo[playerid][pFactionRank] >= 2)
		return SendServerMessage(playerid, "Your rank doesn't have permission for this.");

	new
		playerb;

	if (sscanf(params, "u", playerb))
	{
		SendUsageMessage(playerid, "/givelicense [playerid OR name]");
		SendServerMessage(playerid, "This issues a weapon's license to players. ");
		return 1;
	}

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "You specified an invalid player.");

	if(!PlayerInfo[playerb][pLoggedin])
		return SendErrorMessage(playerid, "You specified a player that isn't logged in.");

	if(!PlayerInfo[playerid][pWeaponsLicense]) {
		PlayerInfo[playerid][pWeaponsLicense] = 1;

		SendPoliceMessage(COLOR_COP, "** HQ: %s %s issued %s a weapon's license! **", ReturnFactionRank(playerid), ReturnName(playerid, 0), ReturnName(playerb));
	}
	else {
		PlayerInfo[playerid][pWeaponsLicense] = 0;

		SendPoliceMessage(COLOR_COP, "** HQ: %s %s removed %s's weapon's license! **", ReturnFactionRank(playerid), ReturnName(playerid, 0), ReturnName(playerb));
	}

	return 1;
}

CMD:impound(playerid, params[])
{
	if(ReturnFactionType(playerid) != FACTION_TYPE_POLICE)
		return SendUnauthMessage(playerid);

	if(!PlayerInfo[playerid][pPoliceDuty])
		return SendUnauthMessage(playerid);

	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendErrorMessage(playerid, "You aren't driving a vehicle.");

	new
		vehicleid = GetPlayerVehicleID(playerid);

	if(!VehicleInfo[vehicleid][eVehicleDBID] && !VehicleInfo[vehicleid][eVehicleAdminSpawn])
		return SendServerMessage(playerid, "This command can only be used for private vehicles. You are in a public static vehicle.");

	if(VehicleInfo[vehicleid][eVehicleFaction])
		return SendErrorMessage(playerid, "You can't impound faction vehicles.");

	if(!IsPlayerInDynamicArea(playerid, ImpoundLotArea))
		return SendErrorMessage(playerid, "You aren't in the impound lot area.");

	GetPlayerPos(playerid, VehicleInfo[vehicleid][eVehicleImpoundPos][0], VehicleInfo[vehicleid][eVehicleImpoundPos][1], VehicleInfo[vehicleid][eVehicleImpoundPos][2]);
	VehicleInfo[vehicleid][eVehicleImpounded] = true;

	SendClientMessageEx(playerid, COLOR_DARKGREEN, "You impounded %s's %s", ReturnDBIDName(VehicleInfo[vehicleid][eVehicleOwnerDBID]), ReturnVehicleName(vehicleid));

	foreach(new i : Player) if(PlayerInfo[i][pDBID] == VehicleInfo[vehicleid][eVehicleOwnerDBID])
		SendClientMessageEx(i, COLOR_DARKGREEN, "Your %s was impounded by %s", ReturnVehicleName(vehicleid), ReturnName(playerid));

	return 1;
}

CMD:mdc(playerid, params[])
{
	if(ReturnFactionType(playerid) != FACTION_TYPE_POLICE)
		return SendUnauthMessage(playerid);

	if(!IsPlayerInAnyVehicle(playerid))
		return SendErrorMessage(playerid, "You aren't in a vehicle.");

	if(GetPlayerVehicleSeat(playerid) > 1)
		return SendErrorMessage(playerid, "You can't use the MDC from back there.");

	new
		vehicleid = GetPlayerVehicleID(playerid)
	;

	if(!VehicleInfo[vehicleid][eVehicleFaction] || VehicleInfo[vehicleid][eVehicleFaction] && FactionInfo[VehicleInfo[vehicleid][eVehicleFaction]][eFactionType] != FACTION_TYPE_POLICE)
		return SendErrorMessage(playerid, "This vehicle doesn't have an MDC.");

	ShowPlayerMDC(playerid);
	return 1;
}

CMD:wanted(playerid, params[])
{
	new
		add_query[256],
		charge[90],
		playerb
	;

	if(ReturnFactionType(playerid) != FACTION_TYPE_POLICE)
		return SendUnauthMessage(playerid);

	if(sscanf(params, "us[90]", playerb, charge))
		return SendUsageMessage(playerid, "/wanted [playerid OR name] [reason]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(PlayerInfo[playerb][pLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified hasn't logged in yet.");

	mysql_format(ourConnection, add_query, sizeof(add_query), "INSERT INTO criminal_record (player_name, charge_reason, add_date) VALUES('%e', '%e', '%e')", ReturnName(playerb), charge, ReturnDate());
	mysql_tquery(ourConnection, add_query, "OnPlayerAddCharge", "iis", playerid, playerb, charge);
	return 1;
}

//Admin commands:
CMD:cc(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] <= 3)
		return SendUnauthMessage(playerid);
    foreach (new i : Player)
		
    for(new q = 0; q < 50; q++)
	{
		SendClientMessage(i, COLOR_WHITE, "");
	}
	return 1;
}

CMD:asellproperty(playerid, params[])
{

    if(PlayerInfo[playerid][pAdmin] <= 3)
		return SendUnauthMessage(playerid);
		
	new
		bool:nearProperty = false,
		id,
		pay,
		hstring[90]
	;

	for(new i = 1; i < MAX_PROPERTY; i++)
	{
		if(!PropertyInfo[i][ePropertyDBID])
			continue;

		if(IsPlayerInRangeOfPoint(playerid, 3.0, PropertyInfo[i][ePropertyEntrance][0], PropertyInfo[i][ePropertyEntrance][1], PropertyInfo[i][ePropertyEntrance][2]))
		{
			nearProperty = true;
			id = i;
			break;
		}
	}

	if(nearProperty)
	{
		SCMex(playerid, COLOR_YELLOW, "You've sold this property", pay);

		format(hstring, sizeof(hstring), "Adess: %s\nFor Sale!\n Price: $%i", PropertyInfo[id][ePropertyAdress],PropertyInfo[id][ePropertyMarketPrice]);
        Update3DTextLabelText(PropertyInfo[id][ePropertyTag], COLOR_GREEN, hstring);
        DestroyDynamicPickup(PropertyInfo[id][ePropertyPickup]);
        PropertyInfo[id][ePropertyPickup] = CreateDynamicPickup(1273, 1, PropertyInfo[id][ePropertyEntrance][0], PropertyInfo[id][ePropertyEntrance][1], PropertyInfo[id][ePropertyEntrance][2], 0);

		PropertyInfo[id][ePropertyOwnerDBID] = 0;
		SaveCharacter(playerid); SaveProperty(id);
	}
	else return SendErrorMessage(playerid, "You aren't near a property.");
	return 1;
}

CMD:fundrag(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
		return SendUnauthMessage(playerid);

	new draggee, dragger;
 	if(sscanf(params, "u", draggee)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /fundrag [ID].");

 	dragger = GetPVarInt(draggee, "DraggedByPlayer");
 	SetPVarInt(draggee, "BeingDragged", 0);
 	DeletePVar(draggee, "BeingDragged");
 	SetPVarInt(dragger, "DraggingPlayer", INVALID_PLAYER_ID);
 	KillTimer(dragtimer[dragger]);
 	SCMex(draggee, COLOR_YELLOW, "You've been force undragged by admin: %s", ReturnName(playerid));
 	SCMex(dragger, COLOR_YELLOW, "%s has been force undragged by admin: %s", ReturnName(draggee), ReturnName(playerid));
 	SCMex(playerid, COLOR_YELLOW, "You have force-undragged: %s who was being dragged by: %s", ReturnName(draggee), ReturnName(dragger));
	return 1;
}

CMD:sorry(playerid, params[])
{
	new playerb;
	
 	if(PlayerInfo[playerid][pAdmin] < 3)
		return SendUnauthMessage(playerid);
		
    if(sscanf(params, "u", playerb)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /sorry [ID].");
		
    if(isDead[playerb] == false)
    	return SendErrorMessage(playerid, "This player is not in the hospital.");

    if(playerb == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_LIGHTRED, "That player is not connected.");
	SCM(playerb, COLOR_WHITE, "You have been treated at the hospital.");
	SCMex(playerid, COLOR_YELLOW, "You've forced: %s out of the hospital", ReturnName(playerb));
	SetPlayerHealth(playerb, 100.0);
	ClearAnimations(playerb);
	SetPlayerPos(playerb, -2491.6150, 2362.9348, 10.3187);
 	SetPlayerInterior(playerb, 0);
 	SetPlayerVirtualWorld(playerb, 0);
 	SetCameraBehindPlayer(playerb);
 	KillTimer(HospTimer[playerb]);
 	isDead[playerb] = false;
	return 1;
}

CMD:fixworld(playerid, params[])
{
    if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);
    new playerb, str[128], str2[128];
    if (sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/setworld [playerid OR name]");
    if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");
    if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

    SetPlayerVirtualWorld(playerb, 0);
    SetPlayerInterior(playerb, 0);

    format(str, sizeof(str), "%s fixed %s's their world.", ReturnName(playerid), ReturnName(playerb));
    SendAdminMessage(1, str);

    format(str2, sizeof(str2), "%s fixed your world.", ReturnName(playerid));
    SCM(playerb, COLOR_YELLOW, str2);
	return 1;
}

CMD:alock(playerid, params[])
{

	if(PlayerInfo[playerid][pAdmin] < 2)
		return SendUnauthMessage(playerid);

	new
		id,
		b_id
	;

	if((id = IsPlayerNearProperty(playerid)) != 0)
	{
		if(!PropertyInfo[id][ePropertyLocked])
		{
			GameTextForPlayer(playerid, "~w~DOOR ~r~LOCKED", 1000, 6);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

			PropertyInfo[id][ePropertyLocked] = true;
		}
		else
		{
			GameTextForPlayer(playerid, "~w~DOOR ~g~UNLOCKED", 1000, 6);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

			PropertyInfo[id][ePropertyLocked] = false;
		}
	}
	else if((id = IsPlayerInProperty(playerid)) != 0)
	{
		if(!IsPlayerInRangeOfPoint(playerid, 3.0, PropertyInfo[id][ePropertyInterior][0], PropertyInfo[id][ePropertyInterior][1], PropertyInfo[id][ePropertyInterior][2]))
			return SendErrorMessage(playerid, "You aren't near your properties door.");

		if(!PropertyInfo[id][ePropertyLocked])
		{
			GameTextForPlayer(playerid, "~w~DOOR ~r~LOCKED", 1000, 4);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

			PropertyInfo[id][ePropertyLocked] = true;
		}
		else
		{
			GameTextForPlayer(playerid, "~w~DOOR ~g~UNLOCKED", 1000, 4);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

			PropertyInfo[id][ePropertyLocked] = false;
		}
	}

	if((b_id = IsPlayerNearBusiness(playerid)) != 0)
	{
		if(!BusinessInfo[b_id][eBusinessLocked])
		{
			GameTextForPlayer(playerid, "~w~DOOR ~r~LOCKED", 1000, 4);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

			BusinessInfo[b_id][eBusinessLocked] = true;
		}
		else
		{
			GameTextForPlayer(playerid, "~w~DOOR ~g~UNLOCKED", 1000, 4);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

			BusinessInfo[b_id][eBusinessLocked] = false;
		}
	}
	else if((b_id = IsPlayerInBusiness(playerid)) != 0)
	{
		if(!IsPlayerInRangeOfPoint(playerid, 3.0, BusinessInfo[b_id][eBusinessInterior][0], BusinessInfo[b_id][eBusinessInterior][1], BusinessInfo[b_id][eBusinessInterior][2]))
			return SendErrorMessage(playerid, "You aren't near the door.");

		if(!BusinessInfo[b_id][eBusinessLocked])
		{
			GameTextForPlayer(playerid, "~w~DOOR ~r~LOCKED", 1000, 4);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

			BusinessInfo[b_id][eBusinessLocked] = true;
		}
		else
		{
			GameTextForPlayer(playerid, "~w~DOOR ~g~UNLOCKED", 1000, 4);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);

			BusinessInfo[b_id][eBusinessLocked] = false;
		}
	}
	return 1;
}

CMD:avlock(playerid, params[])
{
    	if(PlayerInfo[playerid][pAdmin] < 2)
			return SendUnauthMessage(playerid);

		new bool:foundCar = false, vehicleid, Float:fetchPos[3];

		for (new i = 0; i < MAX_VEHICLES; i++)
		{
			GetVehiclePos(i, fetchPos[0], fetchPos[1], fetchPos[2]);
			if(IsPlayerInRangeOfPoint(playerid, 4.0, fetchPos[0], fetchPos[1], fetchPos[2]))
			{
				foundCar = true;
				vehicleid = i;
				break;
			}
		}
		if(foundCar == true)
		{
			new statusString[90];
			new engine, lights, alarm, doors, bonnet, boot, objective;

			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

			if(VehicleInfo[vehicleid][eVehicleLocked])
			{
				format(statusString, sizeof(statusString), "~g~%s UNLOCKED", ReturnVehicleName(vehicleid));

				SetVehicleParamsEx(vehicleid, engine, lights, alarm, false, bonnet, boot, objective);
				VehicleInfo[vehicleid][eVehicleLocked] = false;
			}
			else
			{
				format(statusString, sizeof(statusString), "~r~%s LOCKED", ReturnVehicleName(vehicleid));

				SetVehicleParamsEx(vehicleid, engine, lights, alarm, true, bonnet, boot, objective);
				VehicleInfo[vehicleid][eVehicleLocked] = true;
			}
			GameTextForPlayer(playerid, statusString, 3000, 3);
		}
		else SendServerMessage(playerid, "You aren't near a vehicle OR the vehicle isn't synced.");
		return 1;
}


CMD:int(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2)
		return SendUnauthMessage(playerid);
    new tmp[256], string[256], playa;
	playa = strval(tmp);
    if(sscanf(params, "i", playa)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /int [Interior ID].");
	if(playa < 146 && playa >= 0)
	{
		format(string, sizeof(string), "Int %d: %s", playa, IntName[playa]);
   		SendClientMessage(playerid, 0xFFFFFFAA, string);
		SetPlayerInterior(playerid, IntArray2[playa][0]);
		SetPlayerPos(playerid, IntArray[playa][0], IntArray[playa][1], IntArray[playa][2]);
		SetPlayerFacingAngle(playerid, IntArray[playa][3]);
		return 1;
	}
	return 1;
}

CMD:adestroycar(playerid, params[])
{
		if(PlayerInfo[playerid][pAdmin] < 4)
			return SendUnauthMessage(playerid);
		if(!IsPlayerInAnyVehicle(playerid))
			return SendErrorMessage(playerid, "You aren't in any vehicle.");

		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)return SendErrorMessage(playerid, "You need to be driving your vehicle.");

		new
			str[160],
			vehicleid = GetPlayerVehicleID(playerid)
		;
		format(str, sizeof(str), "Are you sure you want to scrap this %s?\n{FF6347}This action is permanent and cannot be undone.", ReturnVehicleName(vehicleid));
		ConfirmDialog(playerid, "Confirmation", str, "OnVehicleaScrap", VehicleInfo[vehicleid][eVehicleDBID], vehicleid);
		return 1;
}

CMD:apark(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2)
		return SendUnauthMessage(playerid);
	if(!IsPlayerInAnyVehicle(playerid))
	return SendErrorMessage(playerid, "You aren't in any vehicle.");

	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)return SendErrorMessage(playerid, "You need to be driving your vehicle.");

	new
	vehicleid = GetPlayerVehicleID(playerid);

	GetVehiclePos(vehicleid, VehicleInfo[vehicleid][eVehicleParkPos][0], VehicleInfo[vehicleid][eVehicleParkPos][1], VehicleInfo[vehicleid][eVehicleParkPos][2]);
	GetVehicleZAngle(vehicleid, VehicleInfo[vehicleid][eVehicleParkPos][3]);

	VehicleInfo[vehicleid][eVehicleParkInterior] = GetPlayerInterior(playerid);
	VehicleInfo[vehicleid][eVehicleParkWorld] = GetPlayerVirtualWorld(playerid);

	SendClientMessageEx(playerid, COLOR_DARKGREEN, "You parked your %s.", ReturnVehicleName(vehicleid));
	SaveVehicle(vehicleid);
	return 1;
}

CMD:aengine(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 1)
		return SendUnauthMessage(playerid);
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendErrorMessage(playerid, "You aren't in the driver's seat of a vehicle.");

	new vehicleid = GetPlayerVehicleID(playerid);

	if(HasNoEngine(vehicleid))
		return SendErrorMessage(playerid, "This vehicle doesn't have a engine.");

	if(VehicleInfo[vehicleid][eVehicleFuel] < 1 && !VehicleInfo[vehicleid][eVehicleAdminSpawn])
		return SendClientMessage(playerid, COLOR_RED, "Vehicle is out of fuel!");

	if(!VehicleInfo[vehicleid][eVehicleEngineStatus])
	{
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s started the engine of the %s.", ReturnName(playerid, 0), ReturnVehicleName(vehicleid));
		ToggleVehicleEngine(vehicleid, true); VehicleInfo[vehicleid][eVehicleEngineStatus] = true;
	}
	else
	{
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s stopped the engine of the %s.", ReturnName(playerid, 0), ReturnVehicleName(vehicleid));
		ToggleVehicleEngine(vehicleid, false); VehicleInfo[vehicleid][eVehicleEngineStatus] = false;
	}
	return 1;
}

CMD:ruc(playerid,params[])
{
	new
	astring[124];

   	if(PlayerInfo[playerid][pAdmin] < 4)
		return SendUnauthMessage(playerid);
    {
		for(new i=0;i<MAX_VEHICLES;i++)
  		{
    		if(IsVehicleOccupied(i) == 0)
      		{
        		SetVehicleToRespawn(i);
        		ToggleVehicleEngine(i, false); VehicleInfo[i][eVehicleEngineStatus] = false;
          	}
        }
  		format(astring,sizeof(astring),"AmdCmd: Administrator %s has respawned all empty public vehicles.", ReturnName(playerid));
		SendClientMessageToAll(COLOR_LIGHTRED,astring);
    }
    return 1;
}

CMD:free(playerid, params[])
{
    new
	criminal, string[128];

	if(!PlayerInfo[playerid][pAdmin])
	return SendUnauthMessage(playerid);
    if(sscanf(params, "u", criminal)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /free [ID].");
    if(criminal == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_LIGHTRED, "That player is not connected.");

	PlayerInfo[criminal][pJailTime] = 0;
	PlayerInfo[criminal][pInJail] = 0;
	SetPlayerInterior(criminal, 0);
	SetPlayerVirtualWorld(criminal, 0);
	SetPlayerPos(criminal, -2614.5542, 2270.2622, 8.1);

	format(string, sizeof(string), "AdmCmd: %s has been released from the prison by administrator %s.", ReturnName(criminal, 0), ReturnName(playerid, 0));
 	SendClientMessageToAll(COLOR_LIGHTRED, string);
  	return 1;
}

CMD:restart(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] <= 4)
	    return SendUnauthMessage(playerid);
	    
 	SendClientMessageToAll(COLOR_LIGHTRED, "[SERVER:] The server will restart in 20 seconds.");
	SetTimer("ServerRestart", 20000, false);
    return 1;
}

CMD:setfuel(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3)
		return SendUnauthMessage(playerid);
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are not in a vehicle.");
    new vehicleid = GetPlayerVehicleID(playerid);
	new amount, msg[128];
	if(sscanf(params, "d", amount)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /setfuel [amount]");
	if(amount < 0 || amount > 100) return SendClientMessage(playerid, COLOR_LIGHTRED, "Invalid amount. (0-100)");
	VehicleInfo[vehicleid][eVehicleFuel] = amount;
	format(msg, sizeof(msg), "You have set your vehicle fuel to %d.", amount);
	SendClientMessage(playerid, COLOR_WHITE, msg);
	return 1;
}

CMD:rac(playerid,params[])
{
	new
	astring[124];

	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);
    {
		for(new i=0;i<MAX_VEHICLES;i++)
  		{
  			SetVehicleToRespawn(i);
  			ToggleVehicleEngine(i, false); VehicleInfo[i][eVehicleEngineStatus] = false;
        }
  		format(astring,sizeof(astring),"AmdCmd: Administrator %s has respawned all vehicles.", ReturnName(playerid));
		SendClientMessageToAll(COLOR_LIGHTRED,astring);
    }
    return 1;
}

CMD:acmds(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return 0;

	if(PlayerInfo[playerid][pAdmin] >= 1)
	{
		SendClientMessage(playerid, COLOR_DARKGREEN, "Trial Administrator:{FFFFFF} /aduty, /forumname, /goto, /gethere, /a (achat), /showmain, /kick, /(o)ban, /(o)ajail, /aengine,");
		SendClientMessage(playerid, COLOR_DARKGREEN, "Trial Administrator:{FFFFFF} /unjail, /setint, /setworld, /setskin, /health, /reports, /ar (accept), /dr (disregard),");
		SendClientMessage(playerid, COLOR_DARKGREEN, "Trial Administrator:{FFFFFF} /slap, /spec,/specoff, /stats (id), /gotols, /respawncar, /gotocar, /getcar, /towcars (aduty)");
		SendClientMessage(playerid, COLOR_DARKGREEN, "Trial Administrator:{FFFFFF} /gotosmuggle, /gotojob, /fixworld,/ann(announce)");
	}

	if(PlayerInfo[playerid][pAdmin] >= 2)
	{
		SendClientMessage(playerid, COLOR_DARKGREEN, "Junior Administrator:{FFFFFF} /armor, /clearreports, /p2p, /givegun, /clearpguns, /gotoproperty, /gotofaction, /gotopoint,");
		SendClientMessage(playerid, COLOR_DARKGREEN, "Junior Administrator:{FFFFFF} /gotobusiness, /noooc, /backup, /repair, /mute, /freeze, /unfreeze, /alock");
	}

	if(PlayerInfo[playerid][pAdmin] >= 3)
	{
		SendClientMessage(playerid, COLOR_DARKGREEN, "General Administrator:{FFFFFF} /spawncar, /despawncar, /pcar, /setstats, /givemoney, /setcar, /setcarparams, /rac, /sorry");
		SendClientMessage(playerid, COLOR_DARKGREEN, "General Administrator:{FFFFFF}  /listmasks, /dropinfo, /aooc, /revive, /arecord,  /listweapons, /apark, /avlock, /int, /fundrag, /cc");
	}

	if(PlayerInfo[playerid][pAdmin] >= 4)
	{
        SendClientMessage(playerid, COLOR_DARKGREEN, "Senior Administrator:{FFFFFF} /makefaction, /editfaction, /setpfaction, /makeproperty, /editproperty, /makexmrcat, /makexmrstation, /adestroycar.");
        SendClientMessage(playerid, COLOR_DARKGREEN, "Senior Administrator:{FFFFFF} /gotocar, /getcar, /listmasks, /dropinfo, /aooc, /revive, /arecord, /towcars (aduty), /listweapons");
	}

	if(PlayerInfo[playerid][pAdmin] >= 5)
	{

		SendClientMessage(playerid, COLOR_DARKGREEN, "Head Administrator:{FFFFFF} /makeadmin /makebusiness, /editbusiness, /callpaycheck,/startevent");
	}
	return 1;
}

CMD:vhelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_CUBER, "_________________Vehicle help_________________");
	SendClientMessage(playerid, COLOR_CUBEG, "[VEHICLES] /vget, /engine, /unscramble, /check, /place, /setstation, /refill");
	SendClientMessage(playerid, COLOR_CUBEG, "[VEHICLES] /park, /buyvehicle, /givecarkey, /destroycar, /vlock, /lights, /trunk");
	SendClientMessage(playerid, COLOR_CUBEG, "[VEHICLES] /trackcar, /carstats, /hood, /vlist, /droplicense, /hotwire, /detach");
	return 1;
}

CMD:jobhelp(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] == 0)
		return SendErrorMessage(playerid, "You dont have a job");

	if(PlayerInfo[playerid][pJob] == 1)
	{
		SendClientMessage(playerid, COLOR_CUBER, "_________________Your job: Pizzaman_________________");
		SendClientMessage(playerid, COLOR_CUBEG, "[HELP] Get on any Pizzabike at the backside of Bayside Stacks and type /pizzajob.");
		SendClientMessage(playerid, COLOR_CUBEG, "[COMMANDS] /pizzajob, /quitjob, /stoppizzajob");
	}

	if(PlayerInfo[playerid][pJob] == 2)
	{
		SendClientMessage(playerid, COLOR_CUBER, "_________________Your job: Mechanic_________________");
		SendClientMessage(playerid, COLOR_CUBEG, "[HELP] Go to the Tierra Robada Scrapyard to get a company vehicle.");
		SendClientMessage(playerid, COLOR_CUBEG, "[COMMANDS] /gate, /fix, /tow, /work, /stopwork");
	}
	if(PlayerInfo[playerid][pJob] == 3)
	{
		SendClientMessage(playerid, COLOR_CUBER, "_________________Your job: Taxi Driver_________________");
		SendClientMessage(playerid, COLOR_CUBEG, "[HELP] Drive around and find customers or wait for them to call.");
		SendClientMessage(playerid, COLOR_CUBEG, "[COMMANDS] /work, /stopwork");
	}
	if(PlayerInfo[playerid][pJob] == 4)
	{
		SendClientMessage(playerid, COLOR_CUBER, "_________________Your job: Truck Driver_________________");
		SendClientMessage(playerid, COLOR_CUBEG, "[HELP] Get a truck and trailer from the trucking depot and stat working.");
		SendClientMessage(playerid, COLOR_CUBEG, "[COMMANDS] /truckingjob, /stoptrucking");
	}
	return 1;
}


CMD:jetpack(playerid,params[])
{
if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);
SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
return 1;
}

CMD:updates(playerid, params[])
{
	new szPanel[655];
	strcat(szPanel,	"** All features are scripted in by the Development Team! **");
	strcat(szPanel, "\n- Robbery system added players can now use /rob to rob safes inside the shop.\n- Jail command for cops is fixed\n- Bayside police station is now shifted to ls\n- Players will get wanted stars after robbing safes and they will be marked in map.\n- Player receiving pm will get notified\n- Special Flashes for cop car added use /flash.\n- Trucking payment is now increased\n- Added announcement commands for admins.\n- Script has been linked to MySQL.\n- Several Optimizations.\n");
    strcat(szPanel, "\n");
    ShowPlayerDialog(playerid, 9998, DIALOG_STYLE_LIST, "MGMC:RP Development Panel - Version 1.2.1", szPanel, "Ok", "Cancel");
	return 1;
}

CMD:aduty(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return 0;

	new str[128];

	if(PlayerInfo[playerid][pAdminDuty])
	{
		PlayerInfo[playerid][pAdminDuty] = false;

		format(str, sizeof(str), "%s is now off administrative duty.", ReturnName(playerid));
		SendAdminMessage(1, str);

		if(!PlayerInfo[playerid][pPoliceDuty])
			SetPlayerColor(playerid, COLOR_WHITE);

		else
			SetPlayerColor(playerid, COLOR_COP);

		SetPlayerHealth(playerid, 100);
	}
	else
	{
		PlayerInfo[playerid][pAdminDuty] = true;

		format(str, sizeof(str), "%s is now on administrative duty.", ReturnName(playerid));
		SendAdminMessage(1, str);

		SetPlayerColor(playerid, 0x33AA33FF);
		SetPlayerHealth(playerid, 250);
	}

	return 1;
}

/*CMD:a(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return 0;

	if(isnull(params)) return SendUsageMessage(playerid, "/a (admin chat) [text]");

	if(strlen(params) > 89)
	{
		SendAdminMessageEx(COLOR_YELLOWEX, 1, "** %s (%s): %.89s", ReturnName(playerid), e_pAccountData[playerid][mForumName], params);
		SendAdminMessageEx(COLOR_YELLOWEX, 1, "** %s (%s): ... %s", ReturnName(playerid), e_pAccountData[playerid][mForumName], params[89]);
	}
	else SendAdminMessageEx(COLOR_YELLOWEX, 1, "** %s (%s): %s", ReturnName(playerid), e_pAccountData[playerid][mForumName], params);
	return 1;
}*/

CMD:a(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return 0;


	if(PlayerInfo[playerid][pAdmin] == 1)
	{
	SendAdminMessageEx(COLOR_YELLOWEX, 1,  "{009900}* Trial Administrator %s (%s):{FFFFFF} %s", ReturnName(playerid), e_pAccountData[playerid][mForumName], params);

	}

	if(PlayerInfo[playerid][pAdmin] == 2)
    {
		SendAdminMessageEx(COLOR_YELLOWEX, 1, "{009900}* Junior Administrator %s (%s):{FFFFFF} %s", ReturnName(playerid), e_pAccountData[playerid][mForumName], params);
	}

	if(PlayerInfo[playerid][pAdmin] == 3)
	{
		SendAdminMessageEx(COLOR_YELLOWEX, 1, "{009900}* General Administrator %s (%s):{FFFFFF} %s", ReturnName(playerid), e_pAccountData[playerid][mForumName], params);
	}

	if(PlayerInfo[playerid][pAdmin] == 4)
	{
		SendAdminMessageEx(COLOR_YELLOWEX, 1, "{009900}* Senior Administrator %s (%s):{FFFFFF} %s", ReturnName(playerid), e_pAccountData[playerid][mForumName], params);
	}

	if(PlayerInfo[playerid][pAdmin] == 5)
 	{
		SendAdminMessageEx(COLOR_YELLOWEX, 1, "{009900}* Head Administrator %s (%s):{FFFFFF} %s", ReturnName(playerid), e_pAccountData[playerid][mForumName], params);
	}
	return 1;
}


CMD:forumname(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	if(isnull(params))
		return SendUsageMessage(playerid, "/forumname [forum name]");

	if(strlen(params) > 60)
		return SendErrorMessage(playerid, "Your forum name needs to be shorter.");

	format(e_pAccountData[playerid][mForumName], 60, "%s", params);
	SendServerMessage(playerid, "Your forum name was changed to: %s.", params);

	SaveCharacter(playerid);
	return 1;
}

//Level 1 Admin commands:
CMD:goto(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new playerb;

	if (sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/goto [playerid OR name]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(PlayerInfo[playerb][pLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified hasn't logged in yet.");

	GetPlayerPos(playerb, PlayerInfo[playerb][pLastPos][0], PlayerInfo[playerb][pLastPos][1], PlayerInfo[playerb][pLastPos][2]);
	//Using the player variable to avoid making other variables;

	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		SetVehiclePos(GetPlayerVehicleID(playerid), PlayerInfo[playerb][pLastPos][0], PlayerInfo[playerb][pLastPos][1] - 1, PlayerInfo[playerb][pLastPos][2]);

	else
		SetPlayerPos(playerid, PlayerInfo[playerb][pLastPos][0], PlayerInfo[playerb][pLastPos][1] - 1, PlayerInfo[playerb][pLastPos][2]);

	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(playerb));

	if(GetPlayerInterior(playerb) != 0)
		SetPlayerInterior(playerid, GetPlayerInterior(playerb));

	SendTeleportMessage(playerid);

	if(PlayerInfo[playerid][pInsideProperty] || PlayerInfo[playerid][pInsideBusiness])
	{
		PlayerInfo[playerid][pInsideProperty] = 0; PlayerInfo[playerid][pInsideBusiness] = 0;
	}
	return 1;
}

CMD:gethere(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new playerb;

	if (sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/goto [playerid OR name]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(PlayerInfo[playerb][pLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified hasn't logged in yet.");

	GetPlayerPos(playerid, PlayerInfo[playerid][pLastPos][0], PlayerInfo[playerid][pLastPos][1], PlayerInfo[playerid][pLastPos][2]);
	//Using the player variable to avoid making other variables;

	if(GetPlayerState(playerb) == PLAYER_STATE_DRIVER)
		SetVehiclePos(GetPlayerVehicleID(playerb), PlayerInfo[playerid][pLastPos][0], PlayerInfo[playerid][pLastPos][1] - 1, PlayerInfo[playerid][pLastPos][2]);

	else
		SetPlayerPos(playerb, PlayerInfo[playerid][pLastPos][0], PlayerInfo[playerid][pLastPos][1] - 1, PlayerInfo[playerid][pLastPos][2]);

	SetPlayerVirtualWorld(playerb, GetPlayerVirtualWorld(playerid));

	if(GetPlayerInterior(playerid) != 0)
		SetPlayerInterior(playerb, GetPlayerInterior(playerid));

	SendTeleportMessage(playerb);
	SendServerMessage(playerid, "%s was teleported to you.", ReturnName(playerb));

	return 1;
}

CMD:showmain(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new playerb;

	if (sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/showmain [playerid OR name]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified hasn't logged in yet.");

	SendServerMessage(playerid, "%s's Master account is \"%s\" (DBID: %i).", ReturnName(playerid), e_pAccountData[playerid][mAccName], e_pAccountData[playerid][mDBID]);
	return 1;
}

CMD:kick(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new playerb, reason[120];

	if (sscanf(params, "us[120]", playerb, reason))
		return SendUsageMessage(playerid, "/kick [playerid OR name] [reason]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(strlen(reason) > 56)
	{
		SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s was kicked by %s, Reason: %.56s", ReturnName(playerb), ReturnName(playerid), reason);
		SendClientMessageToAllEx(COLOR_RED, "AdmCmd: ...%s", reason[56]);
	}
	else SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s was kicked by %s, Reason: %s", ReturnName(playerb), ReturnName(playerid), reason);

	new insertLog[256];

	if(e_pAccountData[playerb][mLoggedin] == false)
	{
		SendServerMessage(playerid, "The player (%s) you kicked was not logged in.", ReturnName(playerb));
	}

	mysql_format(ourConnection, insertLog, sizeof(insertLog), "INSERT INTO kick_logs (`KickedDBID`, `KickedName`, `Reason`, `KickedBy`, `Date`) VALUES(%i, '%e', '%e', '%e', '%e')",
		PlayerInfo[playerid][pDBID], ReturnName(playerb), reason, ReturnName(playerid), ReturnDate());

	mysql_tquery(ourConnection, insertLog);

	KickEx(playerb);
	return 1;
}

CMD:oban(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new
		insertQuery[256],
		infoQuery[128],
		playerb[32],
		reason[120],
		masterDBID
	;

	if(sscanf(params, "s[32]s[120]", playerb, reason))
		return SendUsageMessage(playerid, "/offlineban [players name] [reason]");

	foreach(new i : Player)
	{
		if(!strcmp(ReturnName(i), playerb))
		{
			SendServerMessage(playerid, "%s is connected to the server. (ID: %i)", playerb, i);
			return 1;
		}
	}

	if(!DoesPlayerExist(playerb))
		return SendErrorMessage(playerid, "%s doesn't exist in the database.", playerb);

	mysql_format(ourConnection, infoQuery, sizeof(infoQuery), "SELECT master_dbid FROM characters WHERE char_name = '%e'", playerb);
	new Cache:cache = mysql_query(ourConnection, infoQuery);

	masterDBID = cache_get_field_content_int(0, "master_dbid", ourConnection);
	cache_delete(cache);

	mysql_format(ourConnection, insertQuery, sizeof(insertQuery), "INSERT INTO bannedlist (CharacterDBID, MasterDBID, CharacterName, Reason, Date, BannedBy, IPAddress) VALUES(%i, %i, '%e', '%e', '%e', '%e', 'Offline')",
		ReturnDBIDFromName(playerb), masterDBID, playerb, reason, ReturnDate(), ReturnName(playerid));

	mysql_tquery(ourConnection, insertQuery, "OnOfflineBan", "isiiss", playerid, playerb, ReturnDBIDFromName(playerb), masterDBID, reason, ReturnDate());
	return 1;
}

CMD:ban(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new playerb, reason[120];

	if (sscanf(params, "us[120]", playerb, reason))
		return SendUsageMessage(playerid, "/ban [playerid OR name] [reason]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(PlayerInfo[playerb][pAdmin] > PlayerInfo[playerid][pAdmin])
		return SendErrorMessage(playerid, "You can't ban %s.", ReturnName(playerb));

	if(strlen(reason) > 56)
	{
		SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s was banned by %s, Reason: %.56s", ReturnName(playerb), ReturnName(playerid), reason);
		SendClientMessageToAllEx(COLOR_RED, "AdmCmd: ...%s", reason[56]);
	}
	else SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s was banned by %s, Reason: %s", ReturnName(playerb), ReturnName(playerid), reason);

	new insertLog[256];

	if(e_pAccountData[playerb][mLoggedin] == false)
	{
		SendServerMessage(playerid, "The player (%s) you selected isn't logged in.", ReturnName(playerb));
		SendServerMessage(playerid, "Kick them OR use adminsys for further details.");
		return 1;
	}

	mysql_format(ourConnection, insertLog, sizeof(insertLog), "INSERT INTO bannedlist (`CharacterDBID`, `MasterDBID`, `CharacterName`, `Reason`, `Date`, `BannedBy`, `IpAddress`) VALUES(%i, %i, '%e', '%e', '%e', '%e', '%e')",
		PlayerInfo[playerb][pDBID], e_pAccountData[playerid][mDBID], ReturnName(playerb), reason, ReturnDate(), ReturnName(playerid), ReturnIP(playerb));

	mysql_tquery(ourConnection, insertLog);

	mysql_format(ourConnection, insertLog, sizeof(insertLog), "INSERT INTO ban_logs (`CharacterDBID`, `MasterDBID`, `CharacterName`, `Reason`, `BannedBy`, `Date`) VALUES(%i, %i, '%e', '%e', '%e', '%e')",
		PlayerInfo[playerb][pDBID], e_pAccountData[playerid][mDBID], ReturnName(playerb), reason, ReturnName(playerid), ReturnDate());

	mysql_tquery(ourConnection, insertLog);

	KickEx(playerb);
	return 1;
}

CMD:oajail(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new insertQuery[256], playerb[32], length, reason[128];

	if(sscanf(params, "s[32]ds[128]", playerb, length, reason))
		return SendUsageMessage(playerid, "/offlineajail [player name] [time in minutes] [reason]");

	foreach(new i : Player)
	{
		if(!strcmp(ReturnName(i), playerb))
		{
			SendServerMessage(playerid, "%s is connected to the server. (ID: %i)", playerb, i);
			return 1;
		}
	}

	if(!DoesPlayerExist(playerb))
		return SendErrorMessage(playerid, "%s doesn't exist in the database.", playerb);

	mysql_format(ourConnection, insertQuery, sizeof(insertQuery), "UPDATE characters SET pOfflinejailed = 1, pOfflinejailedReason = '%e', pAdminjailTime = %i WHERE char_name = '%e'", reason, length * 60, playerb);
	mysql_tquery(ourConnection, insertQuery, "OnOfflineAjail", "issi", playerid, playerb, reason, length);

	return 1;
}

CMD:jailt(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new playerb, length, reason[120];

	if (sscanf(params, "uds[120]", playerb, length, reason))
		return SendUsageMessage(playerid, "/jail [playerid OR name] [time in minutes] [reason]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	if(length < 1)
		return SendErrorMessage(playerid, "You can't jail players for under a minute.");

	if(strlen(reason) > 45)
	{
		SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s was admin jailed by %s for %d mintues, Reason: %.56s", ReturnName(playerb), ReturnName(playerid), length, reason);
		SendClientMessageToAllEx(COLOR_RED, "AdmCmd: ...%s", reason[56]);
	}
	else SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s was admin jailed by %s for %d mintues, Reason: %s", ReturnName(playerb), ReturnName(playerid), length, reason);

	ClearAnimations(playerb);

	SetPlayerInterior(playerb, 6);
 	SetPlayerVirtualWorld(playerb, 10);
  	SetPlayerFacingAngle(playerb, 360.0);
   	SetPlayerPos(playerb, 264.5485,77.8464,1001.3657);
    SetPlayerHealth(playerb, 9999999999.0);
    ResetPlayerWeapons(playerb);
    SetPlayerWantedLevel(playerid,0);

	PlayerInfo[playerb][pAdminjailed] = true;
	PlayerInfo[playerb][pAdminjailTime] = length * 60;

	SaveCharacter(playerb);

	new insertLog[250];

	mysql_format(ourConnection, insertLog, sizeof(insertLog), "INSERT INTO ajail_logs (`JailedDBID`, `JailedName`, `Reason`, `Date`, `JailedBy`, `Time`) VALUES(%i, '%e', '%e', '%e', '%e', %i)",
		PlayerInfo[playerb][pDBID], ReturnName(playerb), reason, ReturnDate(), ReturnName(playerid), length);

	mysql_tquery(ourConnection, insertLog);
	return 1;
}

CMD:release(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new playerb, reason[120];

	if (sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/release [playerid OR name]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	if(PlayerInfo[playerb][pAdminjailed] == false)
		return SendErrorMessage(playerid, "The player you specified isn't admin jailed.");

	SetPlayerVirtualWorld(playerb, 0); SetPlayerInterior(playerb, 0);
	SetPlayerPos(playerb, 1553.0421, -1675.4706, 16.1953);

	PlayerInfo[playerb][pAdminjailed] = false;
	PlayerInfo[playerb][pAdminjailTime] = 0;

	SaveCharacter(playerb);
	SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s has been released from the admin jail by %s, Reason: %s", ReturnName(playerb), ReturnName(playerid), reason);
	return 1;
}

CMD:setint(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new playerb, int, str[128];

	if (sscanf(params, "ud", playerb, int))
		return SendUsageMessage(playerid, "/setint [playerid OR name] [interior]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	SetPlayerInterior(playerb, int);

	format(str, sizeof(str), "%s set %s's interior to %d.", ReturnName(playerid), ReturnName(playerb), int);
	SendAdminMessage(1, str);
	return 1;
}

CMD:setworld(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new playerb, world, str[128];

	if (sscanf(params, "ud", playerb, world))
		return SendUsageMessage(playerid, "/setworld [playerid OR name] [world]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	SetPlayerVirtualWorld(playerb, world);

	format(str, sizeof(str), "%s set %s's local world to %d.", ReturnName(playerid), ReturnName(playerb), world);
	SendAdminMessage(1, str);
	return 1;
}

CMD:setskin(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new playerb, skinid, str[128];

	if (sscanf(params, "ud", playerb, skinid))
		return SendUsageMessage(playerid, "/skin [playerid OR name] [skinid]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	PlayerInfo[playerb][pLastSkin] = skinid; SetPlayerSkin(playerb, skinid);

	format(str, sizeof(str), "%s set %s's skin to %d.", ReturnName(playerid), ReturnName(playerb), skinid);
	SendAdminMessage(1, str);
	return 1;
}

CMD:sethp(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new playerb, health, str[128];

	if (sscanf(params, "ud", playerb, health))
		return SendUsageMessage(playerid, "/sethhp [playerid OR name] [health]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	if(health > 150)
		return SendErrorMessage(playerid, "You can't set health over 150.");

	SetPlayerHealth(playerb, health);

	format(str, sizeof(str), "%s set %s's health to %d.", ReturnName(playerid), ReturnName(playerb), health);
	SendAdminMessage(1, str);
	return 1;
}

CMD:setarmour(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new playerb, armour, str[128];

	if (sscanf(params, "ud", playerb, armour))
		return SendUsageMessage(playerid, "/setarmour [playerid OR name] [armour]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	if(armour > 100)
		return SendErrorMessage(playerid, "You can't set health over 100.");

	SetPlayerArmour(playerb, armour);

	format(str, sizeof(str), "%s set %s's armour to %d.", ReturnName(playerid), ReturnName(playerb), armour);
	SendAdminMessage(1, str);
	return 1;
}

CMD:reports(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return 0;

	SendClientMessage(playerid, COLOR_DARKGREEN, "____________________REPORTS____________________");

	for (new i = 0; i < sizeof(ReportInfo); i ++)
	{
		if(ReportInfo[i][rReportExists] == true)
		{
			if(strlen(ReportInfo[i][rReportDetails]) > 65)
			{
				SendClientMessageEx(playerid, COLOR_REPORT, "%s (ID: %d) | RID: %d | Report: %.65s", ReturnName(ReportInfo[i][rReportBy]), ReportInfo[i][rReportBy], i, ReportInfo[i][rReportDetails]);
				SendClientMessageEx(playerid, COLOR_REPORT, "...%s | Pending: %d Sec ago", ReportInfo[i][rReportDetails][65], gettime() - ReportInfo[i][rReportTime]);
			}
			else SendClientMessageEx(playerid, COLOR_REPORT, "%s (ID: %d) | RID: %d | Report: %s | Pending: %d Sec ago", ReturnName(ReportInfo[i][rReportBy]), ReportInfo[i][rReportBy], i, ReportInfo[i][rReportDetails], gettime() - ReportInfo[i][rReportTime]);
		}
	}
	return 1;
}

CMD:ar(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return 0;

	new reportid;

	if (sscanf(params, "d", reportid))
		return SendUsageMessage(playerid, "/acceptreport [report id]");

	if(ReportInfo[reportid][rReportExists] == false)
		return SendErrorMessage(playerid, "The report ID you specified doesn't exist.");

	SendAdminMessageEx(COLOR_RED, 1, "[Report] Admin %s has accepted report %d", ReturnName(playerid), reportid);
	SendClientMessageEx(playerid, COLOR_YELLOW, "You accepted %s's report. [Report: %s]", ReturnName(ReportInfo[reportid][rReportBy]), ReportInfo[reportid][rReportDetails]);

	ReportInfo[reportid][rReportExists] = false;
	ReportInfo[reportid][rReportBy] = INVALID_PLAYER_ID;

	return 1;
}

CMD:dr(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return 0;

	new reportid;

	if (sscanf(params, "d", reportid))
		return SendUsageMessage(playerid, "/denyreport [report id]");

	if(ReportInfo[reportid][rReportExists] == false)
		return SendErrorMessage(playerid, "The report ID you specified doesn't exist.");

	SendAdminMessageEx(COLOR_RED, 1, "[Report] Admin %s has denied the report %d", ReturnName(playerid), reportid);

	ReportInfo[reportid][rReportExists] = false;
	ReportInfo[reportid][rReportBy] = INVALID_PLAYER_ID;

	return 1;
}

CMD:slap(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new playerb;

	if (sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/slap [playerid OR name]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	GetPlayerPos(playerb, PlayerInfo[playerb][pLastPos][0], PlayerInfo[playerb][pLastPos][1], PlayerInfo[playerb][pLastPos][2]);
	//Using the player variable to avoid making other variables;

	SetPlayerPos(playerb, PlayerInfo[playerb][pLastPos][0], PlayerInfo[playerb][pLastPos][1], PlayerInfo[playerb][pLastPos][2] + 5);
	PlayNearbySound(playerb, 1130); //Slap sound;

	SendServerMessage(playerid, "%s slapped %s", ReturnName(playerid), ReturnName(playerb));
	if(playerb != playerid) SendServerMessage(playerb, "%s slapped %s", ReturnName(playerid), ReturnName(playerb));
	return 1;
}

CMD:mute(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new playerb;

	if (sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/mute [playerid OR name]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	if(PlayerInfo[playerb][pMuted] == false)
	{
		PlayerInfo[playerb][pMuted] = true;
		SendClientMessageToAllEx(COLOR_RED, "%s muted %s.", ReturnName(playerid), ReturnName(playerb));
	}
	else
	{
		PlayerInfo[playerb][pMuted] = false;
		SendClientMessageToAllEx(COLOR_RED, "%s unmuted %s.", ReturnName(playerid), ReturnName(playerb));
	}
	return 1;
}

CMD:freeze(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new playerb, str[128];

	if (sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/freeze [playerid OR name]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	TogglePlayerControllable(playerb, 0);

	format(str, sizeof(str), "%s froze player %s.", ReturnName(playerid), ReturnName(playerb));
	SendAdminMessage(1, str);
	return 1;
}

CMD:unfreeze(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new playerb, str[128];

	if (sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/thaw [playerid OR name]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	TogglePlayerControllable(playerb, 1);

	format(str, sizeof(str), "%s unfroze player %s.", ReturnName(playerid), ReturnName(playerb));
	SendAdminMessage(1, str);
	return 1;
}

CMD:spec(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new playerb;

	if (sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/spec [playerid OR name]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	if(PlayerInfo[playerb][pSpectating] != INVALID_PLAYER_ID)
		return SendErrorMessage(playerid, "That player is spectating another player.");

	//if(playerb == playerid) return SendErrorMessage(playerid, "You can't spectate yourself.");

	if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
	{
		GetPlayerPos(playerid, PlayerInfo[playerid][pLastPos][0], PlayerInfo[playerid][pLastPos][1], PlayerInfo[playerid][pLastPos][2]);

		PlayerInfo[playerid][pLastInterior] = GetPlayerInterior(playerid);
		PlayerInfo[playerid][pLastWorld] = GetPlayerVirtualWorld(playerid);
	}

	SetPlayerInterior(playerid, GetPlayerInterior(playerb));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(playerb));

	TogglePlayerSpectating(playerid, true);
	PlayerSpectatePlayer(playerid, playerb);

	PlayerInfo[playerid][pSpectating] = playerb;
	SendServerMessage(playerid, "You're now spectating %s. To stop, use \"/specoff\".", ReturnName(playerb));
	return 1;
}

CMD:specoff(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
		return SendErrorMessage(playerid, "You aren't spectating anyone.");

	SendServerMessage(playerid, "You stopped spectating %s.", ReturnName(PlayerInfo[playerid][pSpectating]));

	TogglePlayerSpectating(playerid, false);
	ReturnPlayerGuns(playerid);
	return 1;
}

CMD:gotols(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	SetPlayerPos(playerid, 1514.1836, -1677.8027, 14.0469);
	SetPlayerInterior(playerid, 0); SetPlayerVirtualWorld(playerid, 0);

	if(PlayerInfo[playerid][pInsideProperty] || PlayerInfo[playerid][pInsideBusiness])
	{
		PlayerInfo[playerid][pInsideProperty] = 0; PlayerInfo[playerid][pInsideBusiness] = 0;
	}

	SendTeleportMessage(playerid);
	return 1;
}

CMD:respawncar(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new vehicleid, str[128];

	if(sscanf(params, "d", vehicleid))
		return SendUsageMessage(playerid, "/respawncar [vehicleid]");

	if(!IsValidVehicle(vehicleid))
		return SendErrorMessage(playerid, "You specified an invalid vehicle.");

	SetVehicleToRespawn(vehicleid);

	foreach(new i : Player)
	{
		if(GetPlayerVehicleID(i) == vehicleid)
		{
			SendServerMessage(i, "The vehicle you're in was respawned by %s.", ReturnName(playerid));
		}
	}

	format(str, sizeof(str), "%s respawned vehicle ID %d.", ReturnName(playerid), vehicleid);
	SendAdminMessage(1, str);
	return 1;
}

CMD:gotocar(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new vehicleid;

	if(sscanf(params, "d", vehicleid))
		return SendUsageMessage(playerid, "/gotocar [vehicleid]");

	if(!IsValidVehicle(vehicleid))
		return SendErrorMessage(playerid, "You specified an invalid vehicle.");

	new Float: fetchPos[3];
	GetVehiclePos(vehicleid, fetchPos[0], fetchPos[1], fetchPos[2]);

	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		SetVehiclePos(GetPlayerVehicleID(playerid), fetchPos[0], fetchPos[1], fetchPos[2]);

	else
		SetPlayerPos(playerid, fetchPos[0], fetchPos[1], fetchPos[2]);

	SendTeleportMessage(playerid);

	if(PlayerInfo[playerid][pInsideProperty] || PlayerInfo[playerid][pInsideBusiness])
	{
		PlayerInfo[playerid][pInsideProperty] = 0; PlayerInfo[playerid][pInsideBusiness] = 0;
	}
	return 1;
}

CMD:getcar(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	new
		vehicleid,
		Float:x,
		Float:y,
		Float:z,
		str[128]
	;

	if(sscanf(params, "d", vehicleid))
		return SendUsageMessage(playerid, "/gotocar [vehicleid]");

	if(!IsValidVehicle(vehicleid))
		return SendErrorMessage(playerid, "You specified an invalid vehicle.");

	GetPlayerPos(playerid, x, y, z);

	SetVehiclePos(vehicleid, x, y, z);
	LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));

	format(str, sizeof(str), "%s teleported vehicle ID %i", ReturnName(playerid), vehicleid);
	SendAdminMessage(1, str);

	foreach(new i : Player)
	{
		if(!IsPlayerInAnyVehicle(i))
			continue;

		if(GetPlayerVehicleID(i) == vehicleid)
		{
			SendServerMessage(i, "The vehicle you were in (%i) was teleported.", vehicleid);
		}
	}
	return 1;
}

CMD:listmasks(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	foreach(new i : Player)
	{
		if(!PlayerInfo[i][pMasked])
			continue;

		SendClientMessageEx(playerid, COLOR_RED, "%s ID: %i %s", ReturnName(i), i, ReturnName(i, 0));
		return 1;
	}

	SendServerMessage(playerid, "There aren't any Masked players.");
	return 1;
}

CMD:dropinfo(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	for(new i = 0; i < sizeof(WeaponDropInfo); i++)
	{
		if(!WeaponDropInfo[i][eWeaponDropped])
			continue;

		if(IsPlayerInRangeOfPoint(playerid, 5.0, WeaponDropInfo[i][eWeaponPos][0], WeaponDropInfo[i][eWeaponPos][1], WeaponDropInfo[i][eWeaponPos][2]))
		{
			if(GetPlayerVirtualWorld(playerid) == WeaponDropInfo[i][eWeaponWorld])
			{
				SendServerMessage(playerid, "This is a %s with %d ammo dropped by %s.", ReturnWeaponName(WeaponDropInfo[i][eWeaponWepID]), WeaponDropInfo[i][eWeaponWepAmmo], ReturnDBIDName(WeaponDropInfo[i][eWeaponDroppedBy]));
			}
		}
		return 1;
	}

	SendServerMessage(playerid, "You aren't near a dropped gun.");
	return 1;
}

CMD:aooc(playerid, params[])
{
	if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);

	if(isnull(params)) return SendUsageMessage(playerid, "/aooc [text]");

	if(strcmp(e_pAccountData[playerid][mForumName], "Null"))
		SendClientMessageToAllEx(COLOR_RED, "[AOOC] Admin %s (%s): %s", ReturnName(playerid), e_pAccountData[playerid][mForumName], params);

	else SendClientMessageToAllEx(COLOR_RED, "[AOOC] Admin %s: %s", ReturnName(playerid), params);
	return 1;
}

CMD:revive(playerid, params[])
{
    if(!PlayerInfo[playerid][pAdmin])
		return SendUnauthMessage(playerid);
	new
		playerb,
		str[128]
	;

	if(sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/revive [playerid OR name]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(!PlayerInfo[playerb][pLoggedin])
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

    if(PlayerInfo[playerb][pIsAlive] == 1)
        return SendErrorMessage(playerid, "This player is not injured.");

	format(str, sizeof(str), "%s revived player %s.", ReturnName(playerid), ReturnName(playerb));
	SendAdminMessage(1, str);

	KillTimer(Deadtimer[playerb]);
	isDead[playerid] = false;
	SetPlayerHealth(playerb, 100);

	TogglePlayerControllable(playerb, 1);
	SetPlayerWeather(playerb, globalWeather);
	PlayerInfo[playerb][pIsAlive] = 1;

	SetPlayerChatBubble(playerb, "(( Revived ))", COLOR_WHITE, 21.0, 3000);
	GameTextForPlayer(playerb, "~b~You were revived", 3000, 4);

	ClearDamages(playerb);
	ClearAnimations(playerb,0);
	return 1;
}

CMD:arecord(playerid, params[])
{
	new
		playerb[60],
		type[30],
		query[128]
	;

	if(sscanf(params, "s[60]s[30]", playerb, type))
		return SendUsageMessage(playerid, "/arecord [character name] [ajail, kicks, bans]");

	if(!ReturnDBIDFromName(playerb))
		return SendErrorMessage(playerid, "That character doesn't exist.");

	if(!strcmp(type, "ajail"))
	{
		mysql_format(ourConnection, query, sizeof(query), "SELECT * FROM ajail_logs WHERE JailedDBID = %i", ReturnDBIDFromName(playerb));
		mysql_tquery(ourConnection, query, "OnAjailRecord", "i", playerid);
	}
	else return SendServerMessage(playerid, "Invalid Parameter.");
	return 1;
}

CMD:listweapons(playerid, params[])
{
	new
		playerb,
		weapon_id[2][13]
	;

	if(sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/listweapons [playerid OR name]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");


	SendClientMessageEx(playerid, COLOR_RED, "________** %s's Weapons **________", ReturnName(playerb));

	for(new i = 0; i < 13; i++)
	{
		GetPlayerWeaponData(playerid, i, weapon_id[0][i], weapon_id[1][i]);

		if(!weapon_id[0][i])
			continue;

		SendClientMessageEx(playerid, COLOR_GRAD1, "%s [Ammo: %d]", ReturnWeaponName(weapon_id[0][i]), weapon_id[1][i]);
	}

	return 1;
}

//Level 2 Admin commands:
CMD:setarmor(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2)
		return SendUnauthMessage(playerid);

	new playerb, armor, str[128];

	if (sscanf(params, "ud", playerb, armor))
		return SendUsageMessage(playerid, "/armor [playerid OR name] [armor]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	if(armor > 200)
		return SendErrorMessage(playerid, "You can't set armor above 200.");

	SetPlayerArmour(playerid, armor);

	format(str, sizeof(str), "%s set %s's Armor to %d.", ReturnName(playerid), ReturnName(playerb), armor);
	SendAdminMessage(1, str);
	return 1;
}

CMD:clearreports(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2)
		return 0;

	new reportCount = 0;

	for (new i = 0; i < sizeof(ReportInfo); i ++)
	{
		if(ReportInfo[i][rReportExists] == true)
		{
			reportCount++;
		}
	}
	if(reportCount)
	{
		new string[128];

		format(string, sizeof(string), "{FFFFFF}Are you sure you want to clear ALL active reports?\n\nThere are {FF6347}%d{FFFFFF} report(s).", reportCount);
		ConfirmDialog(playerid, "Confirmation", string, "ClearReports", reportCount);
	}
	else return SendServerMessage(playerid, "There are no active reports to clear.");
	return 1;
}

CMD:p2p(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2)
		return SendUnauthMessage(playerid);

	new playerb, targetid, str[128];

	if(sscanf(params, "uu", playerb, targetid))
		return SendUsageMessage(playerid, "/p2p [playerid] [targetid]");

	if (!IsPlayerConnected(playerb) || !IsPlayerConnected(targetid))
		return SendErrorMessage(playerid, "A player you specified isn't connected to the server.");

	if (e_pAccountData[playerb][mLoggedin] == false || e_pAccountData[targetid][mLoggedin] == false)
		return SendErrorMessage(playerid, "A player you specified isn't logged in.");

	format(str, sizeof(str), "%s teleported player %s to %s.", ReturnName(playerid), ReturnName(playerb), ReturnName(targetid));
	SendAdminMessage(1, str);

	GetPlayerPos(targetid, PlayerInfo[targetid][pLastPos][0], PlayerInfo[targetid][pLastPos][1], PlayerInfo[targetid][pLastPos][2]);
	//Using the player variable to avoid making other variables;

	SetPlayerPos(playerb, PlayerInfo[targetid][pLastPos][0], PlayerInfo[targetid][pLastPos][1], PlayerInfo[targetid][pLastPos][2]);
	SetPlayerInterior(playerb, GetPlayerInterior(targetid)); SetPlayerVirtualWorld(playerb, GetPlayerVirtualWorld(targetid));

	SendTeleportMessage(playerb);
	return 1;
}

CMD:givegun(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2)
		return SendUnauthMessage(playerid);

	new playerb, weaponid, ammo, idx, str[128];

	if(sscanf(params, "uii", playerb, weaponid, ammo))
	{
		SendUsageMessage(playerid, "/givegun [playerid OR name] [weaponid] [ammo]");
		SendServerMessage(playerid, "These weapons save to the players account.");
		return 1;
	}

	if (!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "A player you specified isn't connected to the server.");

	if (e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "A player you specified isn't logged in.");

	if(weaponid < 1 || weaponid > 46 || weaponid == 35 || weaponid == 36 || weaponid == 37 || weaponid == 38 || weaponid == 39)
	    return SendErrorMessage(playerid, "You have specified an invalid weaponid.");

	if(ammo < 1)return SendErrorMessage(playerid, "You specified invalid ammo amount.");

	idx = ReturnWeaponIDSlot(weaponid);

	if(PlayerInfo[playerb][pWeapons][idx])
		SendServerMessage(playerid, "%s's %s and %d ammo was removed.", ReturnName(playerb), ReturnWeaponName(PlayerInfo[playerb][pWeapons][idx]), PlayerInfo[playerb][pWeaponsAmmo][idx]);

	GivePlayerWeapon(playerb, weaponid, ammo);

	PlayerInfo[playerb][pWeapons][idx] = weaponid;
	PlayerInfo[playerb][pWeaponsAmmo][idx] = ammo;

	format(str, sizeof(str), "%s gave %s a %s and %d ammo.", ReturnName(playerid), ReturnName(playerb), ReturnWeaponName(weaponid), ammo);
	SendAdminMessage(2, str);
	SaveCharacter(playerb);

	SendServerMessage(playerb, "You were given %s and %d ammo.", ReturnWeaponName(weaponid), ammo);
	return 1;
}

CMD:clearpguns(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2)
		return SendUnauthMessage(playerid);

	new playerb, displayString[128], str[128];

	if(sscanf(params, "u", playerb))
		return SendUsageMessage(playerid, "/clearpguns [playerid OR name]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");


	for(new i = 0; i < 12; i ++)
	{
		if(PlayerInfo[playerb][pWeaponsAmmo][i] > 0)
		{
			format(displayString, sizeof(displayString), "%s%s - %d Ammo\n", displayString, ReturnWeaponName(PlayerInfo[playerb][pWeapons][i]), PlayerInfo[playerb][pWeaponsAmmo][i]);

			PlayerInfo[playerb][pWeapons][i] = 0;
			PlayerInfo[playerb][pWeaponsAmmo][i] = 0;
		}
	}

	ShowPlayerDialog(playerid, DIALOG_DEFAULT, DIALOG_STYLE_LIST, "Weapons Cleared:", displayString, "Back", "");
	TakePlayerGuns(playerb);

	format(str, sizeof(str), "%s cleared %s's weapons.", ReturnName(playerid), ReturnName(playerb));
	SendAdminMessage(1, str);
	return 1;
}

CMD:gotoproperty(playerid, params[])
{
	new id;

	if(PlayerInfo[playerid][pAdmin] < 2)
		return SendUnauthMessage(playerid);

	if(sscanf(params, "i", id))
		return SendUsageMessage(playerid, "/gotoproperty [property ID]");

	if(!PropertyInfo[id][ePropertyDBID] || id > MAX_PROPERTY)
		return SendErrorMessage(playerid, "The property you specified doesn't exist.");

	SetPlayerPos(playerid, PropertyInfo[id][ePropertyEntrance][0], PropertyInfo[id][ePropertyEntrance][1], PropertyInfo[id][ePropertyEntrance][2]);

	SetPlayerVirtualWorld(playerid, PropertyInfo[id][ePropertyEntranceWorld]);
	SetPlayerInterior(playerid, PropertyInfo[id][ePropertyEntranceInterior]);

	SendServerMessage(playerid, "You teleported to Property %i.", id);

	if(PlayerInfo[playerid][pInsideProperty] || PlayerInfo[playerid][pInsideBusiness])
	{
		PlayerInfo[playerid][pInsideProperty] = 0; PlayerInfo[playerid][pInsideBusiness] = 0;
	}
	return 1;
}

CMD:gotobusiness(playerid, params[])
{
	new id;

	if(PlayerInfo[playerid][pAdmin] < 2)
		return SendUnauthMessage(playerid);

	if(sscanf(params, "i", id))
		return SendUsageMessage(playerid, "/gotobusiness [business ID]");

	if(!BusinessInfo[id][eBusinessDBID] || id > MAX_BUSINESS)
		return SendErrorMessage(playerid, "The business you specified doesn't exist.");

	SetPlayerPos(playerid, BusinessInfo[id][eBusinessEntrance][0], BusinessInfo[id][eBusinessEntrance][1], BusinessInfo[id][eBusinessEntrance][2]);
	SendServerMessage(playerid, "You teleported to business %i.", id);

	if(PlayerInfo[playerid][pInsideProperty] || PlayerInfo[playerid][pInsideBusiness])
	{
		PlayerInfo[playerid][pInsideProperty] = 0; PlayerInfo[playerid][pInsideBusiness] = 0;
	}
	return 1;
}

CMD:gotofaction(playerid, params[])
{
	new id;

	if(PlayerInfo[playerid][pAdmin] < 2)
		return SendUnauthMessage(playerid);

	if(sscanf(params, "i", id))
		return SendUsageMessage(playerid, "/gotofaction [faction ID]");

	if(!FactionInfo[id][eFactionDBID] || id > MAX_FACTIONS)
		return SendErrorMessage(playerid, "The faction you specified doesn't exist.");

	SetPlayerPos(playerid, FactionInfo[id][eFactionSpawn][0], FactionInfo[id][eFactionSpawn][1], FactionInfo[id][eFactionSpawn][2]);

	SetPlayerVirtualWorld(playerid, FactionInfo[id][eFactionSpawnWorld]);
	SetPlayerInterior(playerid, FactionInfo[id][eFactionSpawnInt]);

	SendServerMessage(playerid, "You teleported to %s's spawn point.", ReturnFactionNameEx(id));

	if(PlayerInfo[playerid][pInsideProperty] || PlayerInfo[playerid][pInsideBusiness])
	{
		PlayerInfo[playerid][pInsideProperty] = 0; PlayerInfo[playerid][pInsideBusiness] = 0;
	}
	return 1;
}

CMD:gotopoint(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2)
		return SendUnauthMessage(playerid);

	new
		Float:x,
		Float:y,
		Float:z,
		interior
	;

	if(sscanf(params, "fffi", x, y, z, interior))
		return SendUsageMessage(playerid, "/gotopoint [x] [y] [z] [interior id]");

	SetPlayerPos(playerid, x, y, z);
	SetPlayerInterior(playerid, interior);

	SendTeleportMessage(playerid);

	if(PlayerInfo[playerid][pInsideProperty] || PlayerInfo[playerid][pInsideBusiness])
	{
		PlayerInfo[playerid][pInsideProperty] = 0; PlayerInfo[playerid][pInsideBusiness] = 0;
	}
	return 1;
}

CMD:noooc(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2)
		return SendUnauthMessage(playerid);

	new
		str[128]
	;

	if(!oocEnabled)
	{
		format(str, sizeof(str), "%s enabled OOC chat.", ReturnName(playerid));
		SendAdminMessage(1, str);

		SendClientMessageToAll(COLOR_GREY, "OOC chat has been enabled by an admin.");
		oocEnabled = true;
	}
	else
	{
		format(str, sizeof(str), "%s disabled OOC chat.", ReturnName(playerid));
		SendAdminMessage(1, str);

		SendClientMessageToAll(COLOR_GREY, "OOC chat has been disabled by an admin.");
		oocEnabled = false;
	}
	return 1;
}

CMD:backup(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2)
		return SendUnauthMessage(playerid);

	if(isnull(params))
		return SendUsageMessage(playerid, "/backup [players, all]");

	new
		str[128];

	if(!strcmp(params, "players"))
	{
		foreach(new i : Player)
		{
			if(!PlayerInfo[playerid][pDBID])
				continue;

			SaveCharacter(i);
		}

		format(str, sizeof(str), "%s backed up player data. (%i)", ReturnName(playerid), GetPlayerPoolSize());
		SendAdminMessage(1, str);
	}
	else if(!strcmp(params, "all"))
	{
		SaveFactions();
		SaveProperties();
  		SaveBusinesses();

		SendClientMessageToAllEx(COLOR_RED, "Admin %s backed up server data.", ReturnName(playerid));
	}
	else return SendErrorMessage(playerid, "Invalid Paramater.");
	return 1;
}

CMD:repair(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2)
		return SendUnauthMessage(playerid);

	new
		str[128],
		vehicleid,
		Float:angle
	;

	if(sscanf(params, "i", vehicleid))
		return SendUsageMessage(playerid, "/repair [vehicle id]");

	if(!IsValidVehicle(vehicleid))
		return SendErrorMessage(playerid, "You specified an invalid vehicle.");

	format(str, sizeof(str), "%s repaired vehicle ID %i.", ReturnName(playerid), vehicleid);
	SendAdminMessage(1, str);

	RepairVehicle(vehicleid);
	SetVehicleHealth(vehicleid, 1000);

	GetVehicleZAngle(vehicleid, angle);
	SetVehicleZAngle(vehicleid, angle);
	return 1;
}

//Level 3 Admin commands:
CMD:spawncar(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3)
		return 0;

	new vehicleid = INVALID_VEHICLE_ID, modelid, color1, color2, siren, str[128];

	if(sscanf(params, "iiiI(0)", modelid, color1, color2, siren))
	{
		SendUsageMessage(playerid, "/spawncar [model id] [color1] [color2] [siren default 0]");
		SendServerMessage(playerid, "These vehicles are temporary. Siren allows you to turn sirens on using horn.");
		return 1;
	}

	if(gettime() - lastVehicleSpawn[playerid] < 5)
		return SendServerMessage(playerid, "You need to wait before spawning another vehicle.");

	if(modelid < 400 || modelid > 611)
		return SendErrorMessage(playerid, "You specified an invalid model.");

	if(color1 < 0 || color2 < 0 || color1 > 255 || color2 > 255)
		return SendErrorMessage(playerid, "A color you specified was invalid.");

	GetPlayerPos(playerid, PlayerInfo[playerid][pLastPos][0], PlayerInfo[playerid][pLastPos][1], PlayerInfo[playerid][pLastPos][2]);
	//Using the player variable to avoid making other variables;

	vehicleid = CreateVehicle(modelid, PlayerInfo[playerid][pLastPos][0], PlayerInfo[playerid][pLastPos][1], PlayerInfo[playerid][pLastPos][2], 0, color1, color2, -1, siren);

	if(vehicleid != INVALID_VEHICLE_ID)
	{
		VehicleInfo[vehicleid][eVehicleAdminSpawn] = true;
		VehicleInfo[vehicleid][eVehicleModel] = modelid;

		VehicleInfo[vehicleid][eVehicleColor1] = color1;
		VehicleInfo[vehicleid][eVehicleColor2] = color2;
	}

	lastVehicleSpawn[playerid] = gettime();
	PutPlayerInVehicle(playerid, vehicleid, 0);

	format(str, sizeof(str), "%s spawned a temporary %s.", ReturnName(playerid), ReturnVehicleName(vehicleid));
	SendAdminMessage(3, str);
	return 1;
}

CMD:despawncar(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3)
		return 0;

	new vehicleid, str[128];

	if(sscanf(params, "d", vehicleid))
		return SendUsageMessage(playerid, "/despawncar [vehicleid]");

	if(!IsValidVehicle(vehicleid))
		return SendErrorMessage(playerid, "You specified an invalid vehicle.");

	if(VehicleInfo[vehicleid][eVehicleAdminSpawn] == false)
		return SendErrorMessage(playerid, "You can't despawn a private / faction vehicle.");

	format(str, sizeof(str), "%s despawned %s (%d).", ReturnName(playerid), ReturnVehicleName(vehicleid), vehicleid);
	SendAdminMessage(3, str);

	ResetVehicleVars(vehicleid); DestroyVehicle(vehicleid);
	return 1;
}

CMD:pcar(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3)
		return SendUnauthMessage(playerid);

	new playerb, modelid, color1, color2;

	if(sscanf(params, "uiii", playerb, modelid, color1, color2))
	{
		SendUsageMessage(playerid, "/pcar [playerid OR name] [model id] [color1] [color2]");
		SendServerMessage(playerid, "This issues a permanent vehicle to a player.");
		return 1;
	}

	if (!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "A player you specified isn't connected to the server.");

	if (e_pAccountData[playerb][mLoggedin] == false)
		return SendErrorMessage(playerid, "A player you specified isn't logged in.");

	if(modelid < 400 || modelid > 611)
		return SendErrorMessage(playerid, "You specified an invalid model.");

	if(color1 < 0 || color2 < 0 || color1 > 255 || color2 > 255)
		return SendErrorMessage(playerid, "A color you specified was invalid.");

	for(new i = 1; i < MAX_PLAYER_VEHICLES; i++)
	{
		if(!PlayerInfo[playerb][pOwnedVehicles][i])
		{
			playerInsertID[playerb] = i;
			break;
		}
	}
	if(!playerInsertID[playerb])
	{
		SendErrorMessage(playerid, "%s doesn't have any free vehicle slots.", ReturnName(playerb));
	}
	else
	{
		new insertQuery[256];

		mysql_format(ourConnection, insertQuery, sizeof(insertQuery), "INSERT INTO vehicles (`VehicleOwnerDBID`, `VehicleModel`, `VehicleColor1`, `VehicleColor2`, `VehicleParkPosX`, `VehicleParkPosY`, `VehicleParkPosZ`, `VehicleParkPosA`) VALUES(%i, %i, %i, %i, -2272.2729, 2330.2148, 4.4583, 270.5714)",
			PlayerInfo[playerb][pDBID], modelid, color1, color2);
		mysql_tquery(ourConnection, insertQuery, "Query_AddPlayerVehicle", "ii", playerid, playerb);
	}

	return 1;
}

CMD:setstats(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3)
		return SendUnauthMessage(playerid);

	new
		playerb,
		statid,
		value,
		str[128]
	;

	if(sscanf(params, "uiI(-1)", playerb, statid, value))
	{
		SendUsageMessage(playerid, "/setstats [playerid OR name] [stat code] [value]");
		SendClientMessage(playerid, COLOR_WHITE, "1. Faction Rank, 2. Mask, 3. Radio, 4. Bank Money, 5. Level,");
		SendClientMessage(playerid, COLOR_WHITE, "6. EXP, 7. Paycheck");
		return 1;
	}

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(!PlayerInfo[playerid][pLoggedin])
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	switch(statid)
	{
		case 1:
		{
			if(value == -1)
				return SendUsageMessage(playerid, "/setstats [playerid OR name] 1 [value required]");

			if(value < 1 && value != -1 || value > 20)
				return SendErrorMessage(playerid, "You specified an invalid rank. (1-20)");

			PlayerInfo[playerb][pFactionRank] = value;
			SaveCharacter(playerb);

			format(str, sizeof(str), "%s set %s's faction rank to %i.", ReturnName(playerid), ReturnName(playerb), value);
			SendAdminMessage(3, str);
		}
		case 2:
		{
			if(!PlayerInfo[playerb][pHasMask])
				PlayerInfo[playerb][pHasMask] = true;

			else PlayerInfo[playerb][pHasMask] = false;

			format(str, sizeof(str), "%s %s %s's Mask.", ReturnName(playerid), (PlayerInfo[playerb][pHasMask] != true) ? ("took") : ("set"), ReturnName(playerb));
			SendAdminMessage(3, str);
		}
		case 3:
		{
			if(!PlayerInfo[playerb][pHasRadio])
				PlayerInfo[playerb][pHasRadio] = true;

			else PlayerInfo[playerb][pHasRadio] = false;

			format(str, sizeof(str), "%s %s %s's Radio.", ReturnName(playerid), (PlayerInfo[playerb][pHasRadio] != true) ? ("took") : ("set"), ReturnName(playerb));
			SendAdminMessage(3, str);
		}
		case 4:
		{
			if(value == -1)
				return SendUsageMessage(playerid, "/setstats [playerid OR name] 4 [value required]");

			format(str, sizeof(str), "%s set %s's bank money: $%s (Previously $%s)", ReturnName(playerid), ReturnName(playerb), MoneyFormat(value), MoneyFormat(PlayerInfo[playerb][pBank]));
			SendAdminMessage(3, str);

			PlayerInfo[playerb][pBank] = value;
			SaveCharacter(playerb);
		}
		case 5:
		{
			if(value == -1)
				return SendUsageMessage(playerid, "/setstats [playerid OR name] 5 [value required]");

			if(value < 1 && value != -1)
				return SendErrorMessage(playerid, "Player levels can't go below one.");

			format(str, sizeof(str), "%s set %s's level: %i (Previously %i)", ReturnName(playerid), ReturnName(playerb), value, PlayerInfo[playerb][pLevel]);
			SendAdminMessage(3, str);

			PlayerInfo[playerb][pLevel] = value; SetPlayerScore(playerb, value);
			SaveCharacter(playerb);
		}
		case 6:
		{
			if(value == -1)
				return SendUsageMessage(playerid, "/setstats [playerid OR name] 6 [value required]");

			format(str, sizeof(str), "%s set %s's EXP: %i (Previously %i)", ReturnName(playerid), ReturnName(playerb), value, PlayerInfo[playerb][pEXP]);
			SendAdminMessage(3, str);

			PlayerInfo[playerb][pEXP] = value;
			SaveCharacter(playerb);
		}
		case 7:
		{
			if(value == -1)
				return SendUsageMessage(playerid, "/setstats [playerid OR name] 7 [value required]");

			format(str, sizeof(str), "%s set %s's EXP: %i (Previously %i)", ReturnName(playerid), ReturnName(playerb), value, PlayerInfo[playerb][pPaycheck]);
			SendAdminMessage(3, str);

			PlayerInfo[playerb][pPaycheck] = value;
			SaveCharacter(playerb);
		}
	}
	return 1;
}

CMD:givemoney(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3)
		return SendUnauthMessage(playerid);

	new playerb, value, str[128];

	if(sscanf(params, "ui", playerb, value))
		return SendUsageMessage(playerid, "/givemoney [playerid OR name] [amount]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(!PlayerInfo[playerid][pLoggedin])
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	GiveMoney(playerb, value);
	SendServerMessage(playerb, "You received $%s from Admin %s.", MoneyFormat(value), ReturnName(playerid));

	format(str, sizeof(str), "%s gave $%s to %s", ReturnName(playerid), MoneyFormat(value), ReturnName(playerb));
	SendAdminMessage(3, str);
	return 1;
}

CMD:setcar(playerid, params[])
{
	new	vehicleid, a_str[60], b_str[60];
	new str[128], value, Float:life;

	if(PlayerInfo[playerid][pAdmin] < 3)
		return SendUnauthMessage(playerid);

	if(sscanf(params, "is[60]S()[60]", vehicleid, a_str, b_str))
	{
		SendUsageMessage(playerid, "/setcar [vehicleid] [params]");
		SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} locklvl, alarmlvl, immoblvl, timesdestroyed,");
		SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} enginelife, batterylife, color1, color2, paintjob, plates.");
		return 1;
	}

	if(!IsValidVehicle(vehicleid))
		return SendErrorMessage(playerid, "You specified an invalid vehicle ID.");

	if(VehicleInfo[vehicleid][eVehicleAdminSpawn])
		return SendErrorMessage(playerid, "The vehicle you specified is admin spawned.");

	if(!strcmp(a_str, "locklvl"))
	{
		if(sscanf(b_str, "i", value))
			return SendUsageMessage(playerid, "/setcar vehicleid locklvl [1-4]");

		if(value > 4 || value < 1)
			return SendErrorMessage(playerid, "Invalid Value.");

		format(str, sizeof(str), "%s set vehicle ID %i's lock level to %i.", ReturnName(playerid), vehicleid, value);
		SendAdminMessage(3, str);

		VehicleInfo[vehicleid][eVehicleLockLevel] = value;
		SaveVehicle(vehicleid);
	}
	else if(!strcmp(a_str, "alarmlvl"))
	{
		if(sscanf(b_str, "i", value))
			return SendUsageMessage(playerid, "/setcar vehicleid alarmlvl [1-4]");

		if(value > 4 || value < 1)
			return SendErrorMessage(playerid, "Invalid Value.");

		format(str, sizeof(str), "%s set vehicle ID %i's alarm level to %i.", ReturnName(playerid), vehicleid, value);
		SendAdminMessage(3, str);

		VehicleInfo[vehicleid][eVehicleAlarmLevel] = value;
		SaveVehicle(vehicleid);
	}
	else if(!strcmp(a_str, "immoblvl"))
	{
		if(sscanf(b_str, "i", value))
			return SendUsageMessage(playerid, "/setcar vehicleid immoblvl [1-5]");

		if(value > 5 || value < 1)
			return SendErrorMessage(playerid, "Invalid Value.");

		format(str, sizeof(str), "%s set vehicle ID %i's immobiliser level to %i.", ReturnName(playerid), vehicleid, value);
		SendAdminMessage(3, str);

		VehicleInfo[vehicleid][eVehicleImmobLevel] = value;
		SaveVehicle(vehicleid);
	}
	else if(!strcmp(a_str, "timesdestroyed"))
	{
		if(sscanf(b_str, "i", value))
			return SendUsageMessage(playerid, "/setcar vehicleid timesdestroyed [value]");

		format(str, sizeof(str), "%s set vehicle ID %i's time destroyed to %i. (Previously %i)", ReturnName(playerid), vehicleid, value, VehicleInfo[vehicleid][eVehicleTimesDestroyed]);
		SendAdminMessage(3, str);

		VehicleInfo[vehicleid][eVehicleTimesDestroyed] = value;
		SaveVehicle(vehicleid);
	}
	else if(!strcmp(a_str, "enginelife"))
	{
		if(sscanf(b_str, "f", life))
			return SendUsageMessage(playerid, "/setcar vehicleid enginelife [float]");

		if(life > 100.00 || life < 0.00)
			return SendErrorMessage(playerid, "You can't set that value. (0.00 - 100.00)");

		format(str, sizeof(str), "%s set vehicle ID %i's engine life to %.2f. (Previously %.2f)", ReturnName(playerid), vehicleid, life, VehicleInfo[vehicleid][eVehicleEngine]);
		SendAdminMessage(3, str);

		VehicleInfo[vehicleid][eVehicleEngine] = life;
		SaveVehicle(vehicleid);
	}
	else if(!strcmp(a_str, "batterylife"))
	{
		if(sscanf(b_str, "f", life))
			return SendUsageMessage(playerid, "/setcar vehicleid batterylife [float]");

		if(life > 100.00 || life < 0.00)
			return SendErrorMessage(playerid, "You can't set that value. (0.00 - 100.00)");

		format(str, sizeof(str), "%s set vehicle ID %i's battery life to %.2f. (Previously %.2f)", ReturnName(playerid), vehicleid, life, VehicleInfo[vehicleid][eVehicleBattery]);
		SendAdminMessage(3, str);

		VehicleInfo[vehicleid][eVehicleBattery] = life;
		SaveVehicle(vehicleid);
	}
	else if(!strcmp(a_str, "color1"))
	{
		if(sscanf(b_str, "i", value))
			return SendUsageMessage(playerid, "/setcar vehicleid color1 [value]");

		if(value > 255 || value < 0)
			return SendErrorMessage(playerid, "You specified an invalid color. (0-255)");

		format(str, sizeof(str), "%s set vehicle ID %i's color1 to %i. (Previously %i)", ReturnName(playerid), vehicleid, value, VehicleInfo[vehicleid][eVehicleColor1]);
		SendAdminMessage(3, str);

		SendClientMessage(playerid, COLOR_WHITE, "The vehicle needs to be respawned to take affect.");

		VehicleInfo[vehicleid][eVehicleColor1] = value;
		SaveVehicle(vehicleid);
	}
	else if(!strcmp(a_str, "color2"))
	{
		if(sscanf(b_str, "i", value))
			return SendUsageMessage(playerid, "/setcar vehicleid color2 [value]");

		if(value > 255 || value < 0)
			return SendErrorMessage(playerid, "You specified an invalid color. (0-255)");

		format(str, sizeof(str), "%s set vehicle ID %i's color2 to %i. (Previously %i)", ReturnName(playerid), vehicleid, value, VehicleInfo[vehicleid][eVehicleColor2]);
		SendAdminMessage(3, str);

		SendClientMessage(playerid, COLOR_WHITE, "The vehicle needs to be respawned to take affect.");

		VehicleInfo[vehicleid][eVehicleColor2] = value;
		SaveVehicle(vehicleid);
	}
	else if(!strcmp(a_str, "paintjob"))
	{
		if(sscanf(b_str, "i", value))
			return SendUsageMessage(playerid, "/setcar vehicleid paintjob [0-2, 3 to remove]");

		if(value > 255 || value < 0)
			return SendErrorMessage(playerid, "You specified an invalid color. (0-255)");

		format(str, sizeof(str), "%s set vehicle ID %i's paintjob to %i. (Previously %i)", ReturnName(playerid), vehicleid, value, VehicleInfo[vehicleid][eVehiclePaintjob]);
		SendAdminMessage(3, str);

		SendClientMessage(playerid, COLOR_WHITE, "The vehicle needs to be respawned to take affect.");

		VehicleInfo[vehicleid][eVehiclePaintjob] = value;
		SaveVehicle(vehicleid);
	}
	else if(!strcmp(a_str, "plates"))
	{
		new
			plates[32];

		if(sscanf(b_str, "s[32]", plates))
			return SendUsageMessage(playerid, "/setcar vehicleid plates [plates]");

		if(strlen(plates) > 6 || strlen(plates) < 6)
			return SendErrorMessage(playerid, "You need to provide a 6 digit plate. (California license plate: Q123Q1)");

		format(str, sizeof(str), "%s set vehicle ID %i's plates to \"%s\". (Previously %s)", ReturnName(playerid), vehicleid, plates, VehicleInfo[vehicleid][eVehiclePlates]);
		SendAdminMessage(3, str);

		format(VehicleInfo[vehicleid][eVehiclePlates], 32, "%s", plates);
		SaveVehicle(vehicleid);
	}
	return 1;
}

CMD:setcarparams(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 3)
		return SendUnauthMessage(playerid);

	new vehicleid, a_str[60], b_str[60];
	new str[128];

	if(sscanf(params, "is[60]S()[60]", vehicleid, a_str, b_str))
	{
		SendUsageMessage(playerid, "/setcarparams [vehicleid] [params]");
		SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} engine, lights, lock, health");
		return 1;
	}

	if(!IsValidVehicle(vehicleid))
		return SendErrorMessage(playerid, "You specified an invalid vehicleid.");

	if(!strcmp(a_str, "engine"))
	{
		if(!VehicleInfo[vehicleid][eVehicleEngineStatus])
		{
			ToggleVehicleEngine(vehicleid, true); VehicleInfo[vehicleid][eVehicleEngineStatus] = true;
			format(str, sizeof(str), "%s turned vehicle ID %i's engine on.", ReturnName(playerid), vehicleid);
		}
		else
		{
			ToggleVehicleEngine(vehicleid, false); VehicleInfo[vehicleid][eVehicleEngineStatus] = false;
			format(str, sizeof(str), "%s turned vehicle ID %i's engine off.", ReturnName(playerid), vehicleid);
		}

		SendAdminMessage(3, str);
	}
	else if(!strcmp(a_str, "lights"))
	{
		if(VehicleInfo[vehicleid][eVehicleLights] == false)
			ToggleVehicleLights(vehicleid, true);

		else ToggleVehicleLights(vehicleid, false);

		format(str, sizeof(str), "%s turned vehicle ID %i's lights %s.", ReturnName(playerid), vehicleid, (VehicleInfo[vehicleid][eVehicleLights] != true) ? ("off") : ("on"));
		SendAdminMessage(3, str);
	}
	else if(!strcmp(a_str, "lock"))
	{
		new engine, lights, alarm, doors, bonnet, boot, objective;

		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

		if(VehicleInfo[vehicleid][eVehicleLocked])
		{
			SetVehicleParamsEx(vehicleid, engine, lights, alarm, false, bonnet, boot, objective);
			VehicleInfo[vehicleid][eVehicleLocked] = false;
		}
		else
		{
			SetVehicleParamsEx(vehicleid, engine, lights, alarm, true, bonnet, boot, objective);
			VehicleInfo[vehicleid][eVehicleLocked] = true;
		}

		format(str, sizeof(str), "%s %s vehicle ID %i.", ReturnName(playerid), (VehicleInfo[vehicleid][eVehicleLocked] != false) ? ("locked") : ("unlocked"));
		SendAdminMessage(3, str);
	}
	else if(!strcmp(a_str, "health"))
	{
		new Float:health;

		if(sscanf(b_str, "f", health))
			return SendUsageMessage(playerid, "/setcar vehicleid health [value]");

		SetVehicleHealth(vehicleid, health);

		format(str, sizeof(str), "%s set vehicle ID %i's health to %.2f.", ReturnName(playerid), vehicleid, health);
		SendAdminMessage(3, str);
	}

	return 1;
}

//Level 4 Admin commands:
CMD:makefaction(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4)
		return 0;

	new varAbbrev[30], varName[90];

	if(sscanf(params, "s[30]s[90]", varAbbrev, varName))
	{
		SendUsageMessage(playerid, "/makefaction [faction abbreviation] [faction name]");
		SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} Do not use spaces for the abbreviation.");
		return 1;
	}

	if(strlen(varName) > 90)
		return SendErrorMessage(playerid, "Your factions name needs to be shorter.");

	new idx = 0;

	for (new i = 1; i < MAX_FACTIONS; i ++)
	{
		if(!FactionInfo[i][eFactionDBID])
		{
			idx = i;
			break;
		}
	}
	if(idx == 0)
	{
		return SendServerMessage(playerid, "The server has met the maximum amount of factions.");
	}

	SendServerMessage(playerid, "Creating the faction...");

	new thread[128];

	mysql_format(ourConnection, thread, sizeof(thread), "INSERT INTO factions (`FactionName`, `FactionAbbrev`) VALUES('%e', '%e')", varName, varAbbrev);
	mysql_tquery(ourConnection, thread, "Query_InsertFaction", "issi", playerid, varAbbrev, varName, idx);

	return 1;
}

CMD:editfaction(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4)
		return 0;

	//This is a lead admin version for faction configuration;
	new factionid, oneString[60], secString[90];

	if (sscanf(params, "ds[60]S()[90]", factionid, oneString, secString))
	{
		SendUsageMessage(playerid, "/editfaction [faction id] [configuration]");
		SendServerMessage(playerid, "type, alterrank, joinrank, chatrank, towrank, chatcolor, spawn");
		return 1;
	}

	if(!FactionInfo[factionid][eFactionDBID])
		return SendErrorMessage(playerid, "The faction you specified doesn't exist.");

	if(!strcmp(oneString, "type"))
	{
		new type;

		if(sscanf(secString, "d", type))
		{
			SendUsageMessage(playerid, "/editfaction factionid type [type id]");
			SendServerMessage(playerid, "1. Illegal, 2. Police, 3. Medical, 4. DOC");
			return 1;
		}

		if(type > 4 || type < 1)
			return SendErrorMessage(playerid, "You specified an invalid faction type.");

		FactionInfo[factionid][eFactionType] = type;

		new
			typeName[32];

		if(type == 1) typeName = "Illegal";
		if(type == 2) typeName = "Police";
		if(type == 3) typeName = "Medical";
		if(type == 4) typeName = "DOC";

		SendServerMessage(playerid, "You set faction %d's type to %s.", factionid, typeName);
		SaveFaction(factionid);
	}
	else if(!strcmp(oneString, "alterrank"))
	{
		new rankid;

		if(sscanf(secString, "d", rankid))
		{
			SendUsageMessage(playerid, "/editfaction factionid alterrank [rank]");
			SendServerMessage(playerid, "This is the rank that may edit the factions name and other permissions.");
			return 1;
		}

		if(rankid < 1 || rankid > 20)
			return SendErrorMessage(playerid, "Faction ranks are between 1-20.");

		FactionInfo[factionid][eFactionAlterRank] = rankid;
		SendServerMessage(playerid, "You set faction %d's alter rank to %d.", factionid, rankid);

		SaveFaction(factionid);
	}
	else if(!strcmp(oneString, "joinrank"))
	{
		new rankid;

		if(sscanf(secString, "d", rankid))
		{
			SendUsageMessage(playerid, "/editfaction factionid joinrank [rank]");
			SendServerMessage(playerid, "This is the rank a player receives when they join this faction.");
			return 1;
		}

		if(rankid < 1 || rankid > 20)
			return SendErrorMessage(playerid, "Faction ranks are between 1-20.");

		FactionInfo[factionid][eFactionJoinRank] = rankid;
		SendServerMessage(playerid, "You set faction %d's join rank to %d.", factionid, rankid);

		SaveFaction(factionid);
	}
	else if(!strcmp(oneString, "chatrank"))
	{
		new rankid;

		if(sscanf(secString, "d", rankid))
		{
			SendUsageMessage(playerid, "/editfaction factionid chatrank [rank]");
			SendServerMessage(playerid, "This is the rank a player needs to access faction chat.");
			return 1;
		}

		if(rankid < 1 || rankid > 20)
			return SendErrorMessage(playerid, "Faction ranks are between 1-20.");

		FactionInfo[factionid][eFactionChatRank] = rankid;
		SendServerMessage(playerid, "You set faction %d's chat rank to %d.", factionid, rankid);

		SaveFaction(factionid);
	}
	else if(!strcmp(oneString, "towrank"))
	{
		new rankid;

		if(sscanf(secString, "d", rankid))
		{
			SendUsageMessage(playerid, "/editfaction factionid towrank [rank]");
			SendServerMessage(playerid, "This is the rank a player needs to tow faction vehicles.");
			return 1;
		}

		if(rankid < 1 || rankid > 20)
			return SendErrorMessage(playerid, "Faction ranks are between 1-20.");

		FactionInfo[factionid][eFactionTowRank] = rankid;
		SendServerMessage(playerid, "You set faction %d's tow rank to %d.", factionid, rankid);

		SaveFaction(factionid);
	}
	else if(!strcmp(oneString, "chatcolor"))
	{
		new hexcolor;

		if(sscanf(secString, "x", hexcolor))
		{
			SendUsageMessage(playerid, "/editfaction factionid chatcolor [hexcode]");
			SendServerMessage(playerid, "This is the color faction chat is shown in. Example: 0x8D8DFFFF");
			return 1;
		}

		FactionInfo[factionid][eFactionChatColor] = hexcolor;
		SendServerMessage(playerid, "You set faction %d's chat color to \"%x\". ", factionid, hexcolor);

		SaveFaction(factionid);
	}
	else if(!strcmp(oneString, "spawn"))
	{
		GetPlayerPos(playerid, FactionInfo[factionid][eFactionSpawn][0], FactionInfo[factionid][eFactionSpawn][1], FactionInfo[factionid][eFactionSpawn][2]);

		FactionInfo[factionid][eFactionSpawnInt] = GetPlayerInterior(playerid);

		if(GetPlayerInterior(playerid) != 0)
			FactionInfo[factionid][eFactionSpawnWorld] = random(50000)+playerid+5;

		else FactionInfo[factionid][eFactionSpawnWorld] = GetPlayerVirtualWorld(playerid);

		SendServerMessage(playerid, "You changed faction %d's spawn point.");
	}
	else return SendErrorMessage(playerid, "Invalid Parameter.");
	return 1;
}

CMD:setpfaction(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4)
		return SendUnauthMessage(playerid);

	new playerb, factionid, str[128];

	if(sscanf(params, "ud", playerb, factionid))
		return SendUsageMessage(playerid, "/setpfaction [playerid OR name] [faction id]");

	if(!IsPlayerConnected(playerb))
		return SendErrorMessage(playerid, "The player you specified isn't connected.");

	if(e_pAccountData[playerid][mLoggedin] == false)
		return SendErrorMessage(playerid, "The player you specified isn't logged in.");

	if(!FactionInfo[factionid][eFactionDBID]) return SendErrorMessage(playerid, "The faction you specified doesn't exist.");

	if(PlayerInfo[playerb][pFaction] != 0)
	{
		new detailStr[128];

		format(detailStr, sizeof(detailStr), "{FFFFFF}%s is already in a faction. Would you like to continue?", ReturnName(playerb));
		ConfirmDialog(playerid, "Confirmation", detailStr, "OnSetFaction", playerb, factionid);
		return 1;
	}

	PlayerInfo[playerb][pFaction] = factionid;
	PlayerInfo[playerb][pFactionRank] = FactionInfo[factionid][eFactionJoinRank];

	SaveCharacter(playerb);

	format(str, sizeof(str), "%s set %s's faction to %d.", ReturnName(playerid), ReturnName(playerb), factionid);
	SendAdminMessage(4, str);

	SendServerMessage(playerb, "You were set to faction %d by Admin %s.", factionid, ReturnName(playerid));

	return 1;
}

CMD:makeproperty(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4)
		return 0;

	new
		vartype,
		query[128]
	;

	if(sscanf(params, "i", vartype))
	{
		SendUsageMessage(playerid, "/makeproperty [type]");
		SendClientMessage(playerid, COLOR_WHITE, "Types: 1. House, 2. Apartment Complex, 3. Apartment Room.");
		return 1;
	}

	if(vartype > 3 || vartype < 1)
		return SendErrorMessage(playerid, "You specified an invalid type.");

	mysql_format(ourConnection, query, sizeof(query), "INSERT INTO properties (`PropertyType`) VALUES(%i)", vartype);
	mysql_tquery(ourConnection, query, "OnPropertyCreate", "ii", playerid, vartype);
	return 1;
}

CMD:editproperty(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4)
		return 0;

	new id, indx[60], specifier[60];

	if(sscanf(params, "is[60]S()[60]", id, indx, specifier))
	{
		SendUsageMessage(playerid, "/editproperty [property id] [params]");
		SendClientMessage(playerid, COLOR_WHITE, "Params: 1. Entrance, 2. Interior, 3. Faction,");
		SendClientMessage(playerid, COLOR_WHITE, "Params: 4. Type, 5. MarketPrice, 6. Level, 7. Adress");
		return 1;
	}

	if(!PropertyInfo[id][ePropertyDBID] || id > MAX_PROPERTY)
		return SendErrorMessage(playerid, "That Property doesn't exist.");

	if(!strcmp(indx, "entrance"))
	{
		ConfirmDialog(playerid, "Confirmation", "Are you sure you want to set this properties entrance?", "OnEntranceChange", id);
	}
	else if(!strcmp(indx, "interior"))
	{
		ConfirmDialog(playerid, "Confirmation", "Are you sure you want to set this properties interior?", "OnInteriorChange", id);
	}
	else if(!strcmp(indx, "faction"))
	{
		new factionid;

		if(sscanf(specifier, "i", factionid))
			return SendUsageMessage(playerid, "/editproperty %i Faction [faction ID]", id);

		if(!FactionInfo[factionid][eFactionDBID] || factionid > MAX_FACTIONS)
			return SendErrorMessage(playerid, "You specifier an invalid faction ID.");

		PropertyInfo[id][ePropertyFaction] = factionid;
		SaveProperty(factionid);

		SendServerMessage(playerid, "You set Property %i's faction to %i.", id, factionid);
	}
	else if(!strcmp(indx, "type"))
	{
		new vartype, typeName[30];

		if(sscanf(specifier, "i", vartype))
		{
			SendUsageMessage(playerid, "/editproperty %i Type [type id]", id);
			SendClientMessage(playerid, COLOR_WHITE, "Types: 1. House, 2. Apartment Complex, 3. Apartment Room.");
			return 1;
		}

		if(vartype > 3 || vartype < 1)
			return SendErrorMessage(playerid, "You specified an invalid type.");

		if(vartype == PROPERTY_TYPE_HOUSE) typeName = "House";
		if(vartype == PROPERTY_TYPE_APTCOMPLEX) typeName = "Apartment Complex";
		if(vartype == PROPERTY_TYPE_APTROOM) typeName = "Apartment Room";

		PropertyInfo[id][ePropertyType] = vartype;
		SaveProperty(id);

		SendServerMessage(playerid, "You set Property %i's type to %s.", id, typeName);
	}
	else if(!strcmp(indx, "marketprice"))
	{
		new price, hstring[90];

		if(sscanf(specifier, "i", price))
			return SendUsageMessage(playerid, "/editproperty %i MarketPrice [price]", id);

		if(price < 1)
			return SendErrorMessage(playerid, "The price has to be greater than or equal to 1.");

        if(!PropertyInfo[id][ePropertyOwnerDBID])
		{
			format(hstring, sizeof(hstring), "Adress: %s\nFor Sale!\n Price: $%i", PropertyInfo[id][ePropertyAdress], price);
			Update3DTextLabelText(PropertyInfo[id][ePropertyTag], COLOR_GREEN, hstring);
		}
		else
		{
			format(hstring, sizeof(hstring), "Adress: %s", PropertyInfo[id][ePropertyAdress]);
			Update3DTextLabelText(PropertyInfo[id][ePropertyTag], COLOR_WHITE, hstring);
		}

		PropertyInfo[id][ePropertyMarketPrice] = price;
		SaveProperty(id);

		SendServerMessage(playerid, "You set Property %i's market price to %i.", id, price);
	}
	else if(!strcmp(indx, "level"))
	{
		new level;

		if(sscanf(specifier, "i", level))
			return SendUsageMessage(playerid, "/editproperty %i Level [level]", id);

		if(level < 1)
			return SendErrorMessage(playerid, "The level can't be less than 1.");

		PropertyInfo[id][ePropertyLevel] = level;
		SaveProperty(id);

		SendServerMessage(playerid, "You set Property %i's level to %i.", id, level);
	}
	else if(!strcmp(indx, "adress"))
	{
		new adress, hstring[100];

		if(sscanf(specifier, "s[100]", adress))
			return SendUsageMessage(playerid, "/editproperty %i Adress [Adress]", id);

        format(PropertyInfo[id][ePropertyAdress], 100, "%s", adress);
		if(!PropertyInfo[id][ePropertyOwnerDBID])
		{
			format(hstring, sizeof(hstring), "Adress: %s\nFor Sale!\n Price: $%i", adress, PropertyInfo[id][ePropertyMarketPrice]);
			Update3DTextLabelText(PropertyInfo[id][ePropertyTag], COLOR_GREEN, hstring);
		}
		else
		{
			format(hstring, sizeof(hstring), "Adress: %s", adress);
			Update3DTextLabelText(PropertyInfo[id][ePropertyTag], COLOR_WHITE, hstring);
		}
		SendServerMessage(playerid, "You set Property %i's adress to %s.", id, adress);
		SaveProperty(id);
	}
	else return SendServerMessage(playerid, "Invalid Paramater.");
	return 1;
}

CMD:makexmrcat(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4)
		return 0;

	if(isnull(params))
	{
		SendUsageMessage(playerid, "/makexmrcat [Category name] (e.g: Rap)");
		SendServerMessage(playerid, "These are the station categories listed in the station list.");
		return 1;
	}

	if(strlen(params) > 90 || strlen(params) < 3)
		return SendErrorMessage(playerid, "Your categories either too long or too short.");

	new
		idx,
		insertQuery[128]
	;

	for(new i = 1; i < MAX_XMR_CATEGORY; i++)
	{
		if(!XMRCategoryInfo[i][eXMRID])
		{
			idx = i;
			break;
		}
	}

	if(idx == 0)
		return SendErrorMessage(playerid, "The server has met its XMR category capacity.");

	mysql_format(ourConnection, insertQuery, sizeof(insertQuery), "INSERT INTO xmr_categories (XMRCategoryName) VALUES ('%e')", params);
	mysql_tquery(ourConnection, insertQuery, "OnXMRCategory", "iis", playerid, idx, params);

	return 1;
}

CMD:makexmrstation(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4)
		return 0;

	new
		category,
		staURL[128],
		staName[90],
		idx,
		insertQuery[256]
	;

	if(sscanf(params, "is[128]s[90]", category, staURL, staName))
	{
		SendUsageMessage(playerid, "/makexmrstation [Category] [Audio URL] [Station Name]");
		SendClientMessage(playerid, -1, "Example: /makexmrstation 1 http://powerhitz.com Powerhitz");
		return 1;
	}

	if(!XMRCategoryInfo[category][eXMRID] || category > MAX_XMR_CATEGORY)
		return SendErrorMessage(playerid, "The category you specified doesn't exist.");

	for(new i = 1; i < MAX_XMR_CATEGORY_STATIONS; i++)
	{
		if(!XMRStationInfo[i][eXMRStationID])
		{
			idx = i;
			break;
		}
	}

	if(idx == 0)
		return SendErrorMessage(playerid, "The server has met its XMR stations capacity.");

	mysql_format(ourConnection, insertQuery, sizeof(insertQuery), "INSERT INTO xmr_stations (XMRCategory, XMRStationName, XMRStationURL) VALUES(%i, '%e', '%e')", category, staName, staURL);
	mysql_tquery(ourConnection, insertQuery, "OnXMRStation", "iiiss", playerid, category, idx, staURL, staName);

	return 1;
}

CMD:makebusiness(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4)
		return 0;

	new
		type_id,
		idx,
		query[128]
	;

	if(sscanf(params, "i", type_id))
	{
		SendUsageMessage(playerid, "/makebusiness [business type]");
		SendClientMessage(playerid, COLOR_WHITE, "Types: 1. Restaurant, 2. Ammunation, 3. Club,");
		SendClientMessage(playerid, COLOR_WHITE, "Types: 4. Bank, 5. General, 6. Dealership, 7. DMV, 8. Illigal, 9. Door.");
		return 1;
	}

	if(type_id > 9 || type_id < 1)
		return SendErrorMessage(playerid, "You specified an invalid type.");

	for(new i = 1; i < MAX_BUSINESS; i++)
	{
		if(!BusinessInfo[i][eBusinessDBID])
		{
			idx = i;
			break;
		}
	}

	if(idx == 0)
		return SendErrorMessage(playerid, "You can't make anymore businesses.");

	mysql_format(ourConnection, query, sizeof(query), "INSERT INTO businesses (BusinessType) VALUES(%i)", type_id);
	mysql_tquery(ourConnection, query, "Query_InsertBusiness", "iii", playerid, idx, type_id);
	return 1;
}

CMD:editbusiness(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4)
		return 0;

	new
		id,
		astr[90],
		bstr[90]
	;

	if(sscanf(params, "is[90]S()[90]", id, astr, bstr))
	{
		SendUsageMessage(playerid, "/editbusiness [business ID] [configuration]");
		SendServerMessage(playerid, "interior, entrance, type, level,");
		SendServerMessage(playerid, "entrancefee, name, bankpickup, marketprice");
		return 1;
	}

	if(!BusinessInfo[id][eBusinessDBID] || id > MAX_BUSINESS)
		return SendErrorMessage(playerid, "You specified an invalid business ID.");

	if(!strcmp(astr, "interior"))
	{
		ConfirmDialog(playerid, "Confirmation", "Are you sure you want to change this businesses interior?", "OnBusinessInteriorChange", id);
	}
	else if(!strcmp(astr, "entrance"))
	{
		ConfirmDialog(playerid, "Confirmation", "Are you sure you want to change this businesses entrance?", "OnBusinessEntranceChange", id);
	}
	else if(!strcmp(astr, "type"))
	{
		new type;

		if(sscanf(bstr, "i", type))
		{
			SendUsageMessage(playerid, "/editbusiness %i type [type id]", id);
			SendClientMessage(playerid, COLOR_WHITE, "Types: 1. Restaurant, 2. Ammunation, 3. Club,");
			SendClientMessage(playerid, COLOR_WHITE, "Types: 4. Bank, 5. General, 6. Dealership, 7. DMV.");
			return 1;
		}

		if(type > 7 || type < 1)
			return SendErrorMessage(playerid, "You specified an invalid type.");

		if(type == BusinessInfo[id][eBusinessType])
			return SendErrorMessage(playerid, "You can't set the businesses type to what it already is.");

		DestroyDynamicPickup(BusinessInfo[id][eBusinessPickup]);

		if(type == BUSINESS_TYPE_RESTAURANT)
		{
			if(!BusinessInfo[id][eBusinessOwnerDBID])
				BusinessInfo[id][eBusinessPickup] = CreateDynamicPickup(1272, 1, BusinessInfo[id][eBusinessEntrance][0], BusinessInfo[id][eBusinessEntrance][1], BusinessInfo[id][eBusinessEntrance][2], 0);

			else BusinessInfo[id][eBusinessPickup] = CreateDynamicPickup(1239, 1, BusinessInfo[id][eBusinessEntrance][0], BusinessInfo[id][eBusinessEntrance][1], BusinessInfo[id][eBusinessEntrance][2], 0);
		}
		else BusinessInfo[id][eBusinessPickup] = CreateDynamicPickup(1239, 1, BusinessInfo[id][eBusinessEntrance][0], BusinessInfo[id][eBusinessEntrance][1], BusinessInfo[id][eBusinessEntrance][2], 0);

		if(BusinessInfo[id][eBusinessType] == BUSINESS_TYPE_BANK)
		{
			DestroyDynamicPickup(BusinessInfo[id][eBusinessBankPickup]);

			for(new i = 0; i < 3; i++) {
				BusinessInfo[id][eBusinessBankPickupLoc][i] = 0.0;
			}

			SendServerMessage(playerid, "This business is no longer a bank and the pickup was destroyed.");
		}

		SendServerMessage(playerid, "You changed business %i's type to %i.", id, type);
		SaveBusiness(id);
	}
	else if(!strcmp(astr, "level"))
	{
		new level;

		if(sscanf(bstr, "i", level))
			return SendUsageMessage(playerid, "/editbusiness %i level [level]", id);

		if(level < 1)
			return SendErrorMessage(playerid, "You can't make the level below 1.");

		BusinessInfo[id][eBusinessLevel] = level;

		SendServerMessage(playerid, "You set business %i's level to %i.", id, level);
		SaveBusiness(id);
	}
	else if(!strcmp(astr, "entrancefee"))
	{
		new fee;

		if(sscanf(bstr, "i", fee))
			return SendUsageMessage(playerid, "/editbusiness %i entrancefee [amount]", id);

		if(fee > 1500)
			return SendErrorMessage(playerid, "The entrance fee can't be above 1500.");

		BusinessInfo[id][eBusinessEntranceFee] = fee;

		SendServerMessage(playerid, "You set business %i's entrance fee to %i.", id, fee);
		SaveBusiness(id);
	}
	else if(!strcmp(astr, "name"))
	{
		new bizname[90];

		if(sscanf(bstr, "s[90]", bizname))
		{
			SendUsageMessage(playerid, "/editbusiness %i name [business name]", id);
			SendServerMessage(playerid, "You can use text colors (i.e ~r~Red ~b~Blue) in the name.");
			return 1;
		}

		if(strlen(bizname) > 90)
			return SendErrorMessage(playerid, "Stay below 90 characters.");

		SendServerMessage(playerid, "You set business %i's name from \"%s\" to \"%s\". ", id, BusinessInfo[id][eBusinessName], bizname);

		format(BusinessInfo[id][eBusinessName], 90, "%s", bizname);
		SaveBusiness(id);
	}
	else if(!strcmp(astr, "bankpickup"))
	{
		if(BusinessInfo[id][eBusinessType] != BUSINESS_TYPE_BANK)
			return SendErrorMessage(playerid, "This business isn't a bank.");

		ConfirmDialog(playerid, "Confirmation", "Are you sure you want to set / change this banks pickup?", "OnBusinessBankpickupChange", id);
	}
	else if(!strcmp(astr, "marketprice"))
	{
		new price;

		if(sscanf(bstr, "i", price))
			return SendUsageMessage(playerid, "/editbusiness %i marketprice [amount]", id);

		BusinessInfo[id][eBusinessMarketPrice] = price;

		SendServerMessage(playerid, "You set business %i's market price to $%s.", id, MoneyFormat(price));
		SaveBusiness(id);
	}
	else return SendErrorMessage(playerid, "Invalid Parameter.");
	return 1;
}

CMD:callpaycheck(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 4)
		return 0;

	ConfirmDialog(playerid, "Confirmation", "Are you sure you want to call a paycheck?\n\nThis action cannot be undone.", "OnCallPaycheck");
	return 1;
}

CMD:fbay(playerid,params[])
{
    if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "You aren't in any faction.");
	else if(IsPlayerInRangeOfPoint(playerid, 7.0,-2534.17944, 2347.45361, 5.94538)) // fdgate1
	{
	    if(fdgate1_status == 0) // gate is closed, so let's open it
	    {
	    	MoveDynamicObject(fdgate1,-2534.1794, 2348.4136, 7.8590,0.50,0.00000, 90.0000, 90.0000);
			fdgate1_status = 1; // we just opened the gate so let's update our variable
		}
		else // gate is not closed so it must be open, so let's close it
		{
			MoveDynamicObject(fdgate1,-2534.17944, 2347.45361, 5.94538,0.50,0.00000, 0.0000, 90.0000);
			fdgate1_status = 0; // we just closed the gate so let's update our variable
		}
	}
	else if(IsPlayerInRangeOfPoint(playerid, 7.0,-2526.27173, 2347.45361, 5.94540)) // fdgate2
	{
	    if(fdgate2_status == 0) // gate is closed, so let's open it
	    {
	    	MoveDynamicObject(fdgate2,-2526.2717, 2348.4136, 7.8590,0.50,0, 90, 90);
			fdgate2_status = 1; // we just opened the gate so let's update our variable
		}
		else // gate is not closed so it must be open, so let's close it
		{
			MoveDynamicObject(fdgate2,-2526.27173, 2347.45361, 5.94540,0.50,0, 0, 90);
			fdgate2_status = 0; // we just closed the gate so let's update our variable
		}
	}
	else if(IsPlayerInRangeOfPoint(playerid, 7.0,-2518.36084, 2347.45361, 5.94540)) // fdgate3
	{
	    if(fdgate3_status == 0) // gate is closed, so let's open it
	    {
	    	MoveDynamicObject(fdgate3,-2518.3608, 2348.4136, 7.8590,0.50,0, 90, 90);
			fdgate3_status = 1; // we just opened the gate so let's update our variable
		}
		else // gate is not closed so it must be open, so let's close it
		{
			MoveDynamicObject(fdgate3,-2518.36084, 2347.45361, 5.94540,0.50,0, 0, 90);
			fdgate3_status = 0; // we just closed the gate so let's update our variable
		}
	}
	else SCM(playerid, COLOR_LIGHTRED, "Invalid Choice - you aren't close to any bays");
	return 1;
}

CMD:locker(playerid, params[])
{
    if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "You aren't in any faction.");

    if(!(IsPlayerInRangeOfPoint(playerid, 6.0, 253.2740, 77.0761, 1003.6406)) && !(IsPlayerInRangeOfPoint(playerid, 6.0, -2595.1748, 4014.8813, 2005.2134)))
        return SCM(playerid, COLOR_LIGHTRED, "You're not by the lockers.");

    if((IsPlayerInRangeOfPoint(playerid, 6.0, 253.2740, 77.0761, 1003.6406)) && (FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] == FACTION_TYPE_POLICE))
    	ShowPlayerDialog(playerid, DIALOG_SDLOCKER, DIALOG_STYLE_LIST, "TR-SP locker", "Armour\nNightstick\nPepper-Spray\nDeagle\nShotgun\nMP5\nM4\nUniform", "Choose", "Cancel");
    else if((IsPlayerInRangeOfPoint(playerid, 6.0, 359.2829,206.8669,1008.3828)) && (FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] == FACTION_TYPE_MEDICAL))
		ShowPlayerDialog(playerid, DIALOG_FDLOCKER, DIALOG_STYLE_LIST, "MGFD locker", "Armour\nFirst Aid\nShovel\nChainsaw\nUniform", "Choose", "Cancel");
    return 1;
}

CMD:afbays(playerid,params[])
{
    if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "You aren't in any faction.");
	else if(IsPlayerInRangeOfPoint(playerid, 15.0, -2526.2966, 2349.8823, 5.0027)) // fdgate1
	{
	    if(fdgate1_status == 0) // gate is closed, so let's open it
	    {
	    	MoveObject(fdgate1,-2534.1794, 2348.4136, 7.8590,0.50,0.00000, 90.0000, 90.0000);
			fdgate1_status = 1; // we just opened the gate so let's update our variable
		}
		else // gate is not closed so it must be open, so let's close it
		{
			MoveObject(fdgate1,-2534.17944, 2347.45361, 5.94538,0.50,0.00000, 0.0000, 90.0000);
			fdgate1_status = 0; // we just closed the gate so let's update our variable
		}
	    if(fdgate2_status == 0) // gate is closed, so let's open it
	    {
	    	MoveObject(fdgate2,-2526.2717, 2348.4136, 7.8590,0.50,0, 90, 90);
			fdgate2_status = 1; // we just opened the gate so let's update our variable
		}
		else // gate is not closed so it must be open, so let's close it
		{
			MoveObject(fdgate2,-2526.27173, 2347.45361, 5.94540,0.50,0, 0, 90);
			fdgate2_status = 0; // we just closed the gate so let's update our variable
		}
	    if(fdgate3_status == 0) // gate is closed, so let's open it
	    {
	    	MoveObject(fdgate3,-2518.3608, 2348.4136, 7.8590,0.50,0, 90, 90);
			fdgate3_status = 1; // we just opened the gate so let's update our variable
		}
		else // gate is not closed so it must be open, so let's close it
		{
			MoveObject(fdgate3,-2518.36084, 2347.45361, 5.94540,0.50,0, 0, 90);
			fdgate3_status = 0; // we just closed the gate so let's update our variable
		}
	}
	else SCM(playerid, COLOR_LIGHTRED, "You're not near any bay.");
	return 1;
}

CMD:gate(playerid,params[])
{
	if(PlayerInfo[playerid][pJob] == 2 || PlayerInfo[playerid][pFaction] >= 1)
	{
 		if(IsPlayerInRangeOfPoint(playerid, 15.0,-2611.6956, 2276.0476, 7.9324) && PlayerInfo[playerid][pFaction] == 1)
		{
            if(sdgate1_status == 0) // gate is closed, so let's open it
            {
		    	MoveObject(gate0,-2611.6956, 2276.0476, 7.9324,0.50,0, 0, 0);
		    	sdgate1_status = 1;
		    }
		    else
		    {
		    	MoveObject(gate0, -2611.6956, 2276.0476, 7.9324,0.50,0, -90.0000, 0);
		    	sdgate1_status = 0;
		    }
		}
		else if(IsPlayerInRangeOfPoint(playerid, 15.0, -1485.9548, 1988.4215, 46.5477))
		{
			if(scrapgate_status == 0) // gate is closed, so let's open it
   			{
		   		MoveDynamicObject(scrapgate1,-1481, 1988.5431, 47.6099,0.50,0, 0, 0);
		   		MoveDynamicObject(scrapgate2,-1491, 1988.5597, 47.6099,0.50,0, 0, -180.0000);
		   		scrapgate_status = 1;
 			}
	 		else
 			{
		   		MoveDynamicObject(scrapgate1, -1485.9573, 1988.5431, 47.6099,0.50,0, 0, 0);
		   		MoveDynamicObject(scrapgate2, -1486.0131, 1988.5597, 47.6099,0.50,0, 0, -180.0000);
		   		scrapgate_status = 0;
  			}
		}
		else SCM(playerid, COLOR_LIGHTRED, "You're not near any gate that you can control.");
	}
	else SendErrorMessage(playerid, "You're not permitted to use this command.");
	return 1;
}

CMD:cell(playerid,params[])
{
		if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You can't use this command.");
 		if(IsPlayerInRangeOfPoint(playerid, 2.0,-2654.86865, 2241.96411, 1009.22820)) //Cell0
		{
		    if(cell0_status == 0) // gate is closed, so let's open it
		    {
		    	MoveObject(cell0,-2654.8687,2243.4441,1009.2282,0.50);
      			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "%s inserts the keys and opens the cell.", ReturnName(playerid, 0), params);
      			cell0_status = 1;
      		}
      		else
      		{
		    	MoveObject(cell0,-2654.86865, 2241.96411, 1009.22820,0.50);
		    	SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "%s inserts the keys and closes the cell.", ReturnName(playerid, 0), params);
		    	cell0_status = 0;
		    }
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.0,-2654.86865, 2246.01611, 1009.22820)) //Cell1
		{
		    if(cell1_status == 0)
		    {
		    	MoveObject(cell1,-2654.8687, 2247.5161, 1009.2282,0.50);
   			 	SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "%s inserts the keys and opens the cell.", ReturnName(playerid, 0), params);
		    	cell1_status = 1;
	 		}
	 		else
	 		{
 				MoveObject(cell1,-2654.86865, 2246.01611, 1009.22820,0.50);
		    	SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "%s inserts the keys and closes the cell.", ReturnName(playerid, 0), params);
		    	cell1_status = 0;
		    }
		} else return SCM(playerid, COLOR_LIGHTRED, "You're not by any cell.");
		return 1;
}

CMD:door(playerid,params[])
{
    	if(!PlayerInfo[playerid][pFaction])
		return SendErrorMessage(playerid, "You aren't in any faction.");
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 245.63580, 72.39397, 1002.53650)) //Door 0
		{
		    if(door0_status == 0)
		    {
		    	MoveObject(door0, 245.63580, 72.39400, 1002.53650,0.5, 0.00000, 0.00000, 91.00000);
		    	SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "%s unlocks and opens the door.", ReturnName(playerid, 0), params);
		    	door0_status = 1;
			}
			else
			{
   			MoveObject(door0,245.63580, 72.39397, 1002.53650, 0.5,-0.20600, 0.00000,0.00000);
		    SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "%s closed the door and locks it.", ReturnName(playerid, 0), params);
		    door0_status = 0;
			}
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0,  -2597.09375, 4003.74438, 2000.24695)) //Door 1
		{
		    if(door1_status == 0)
			{
		    	MoveObject(door1, -2597.09375, 4003.74438, 2000.24695, 0.5,  0.00000, 0.00000, 90.00000);
		    	SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "%s unlocks and opens the door.", ReturnName(playerid, 0), params);
		    	door1_status = 1;
			}
			else
			{
   				MoveObject(door1,-2597.09375, 4003.74438, 2000.24695, 0.5,  0.00000, 0.00000, 0.00000);
  				SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "%s closed the door and locks it.", ReturnName(playerid, 0), params);
  				door1_status = 0;
  			}
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, -2487.74023, 3477.03247, 2004.85376)) //Bank door 1
		{
		    if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank] && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE)
				return SendErrorMessage(playerid, "You don't have permission to open this door.");
		
		    if(bankdoor_status == 0)
		    {
		        MoveDynamicObject(bankdoor, -2489.2602, 3477.0325, 2004.8538, 0.5,  0.00000, 0.00000, 0.00000);
		        SendPoliceMessage(COLOR_COP, "** Bayside Bank: The Bayside bank's security door has been opened by %s **", ReturnName(playerid));
		        SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "%s unlocks and opens the door.", ReturnName(playerid));
		        bankdoor_status = 1;
			}
			else
			{
			    MoveDynamicObject(bankdoor, -2487.74023, 3477.03247, 2004.85376, 0.5,  0.00000, 0.00000, 0.00000);
			    SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "%s closed the door and locks it.", ReturnName(playerid));
			    bankdoor_status = 0;
			}
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, -2481.31641, 3473.12598, 2004.85376)) //bank vault door
		{
		    if(PlayerInfo[playerid][pFactionRank] > FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank] && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE)
				return SendErrorMessage(playerid, "You don't have permission to open this door.");
				
		    if(bankdoor2_status == 0)
		    {
		        MoveDynamicObject(bankdoor2, -2481.3164, 3471.6060, 2004.8538, 0.5,  0.00000, 0.00000, 90.00000);
		        SendPoliceMessage(COLOR_COP, "** Bayside Bank: The Bayside bank's vault door has been opened by %s **", ReturnName(playerid));
		        SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "%s unlocks and opens the door.", ReturnName(playerid));
		        bankdoor2_status = 1;
			}
			else
			{
                MoveDynamicObject(bankdoor2, -2481.31641, 3473.12598, 2004.85376, 0.5,  0.00000, 0.00000, 90.00000);
                SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "%s closed the door and locks it.", ReturnName(playerid));
                bankdoor2_status = 0;
			}
		}
		else return SCM(playerid, COLOR_LIGHTRED, "[Error:] You're not by any door.");
		return 1;
}

//=========================ANIMATIONS=========================
CMD:crack(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /crack [1-2]");
    if(!strcmp(params, "1", true))
    {
   		ApplyPlayerAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "2", true))
    {
   		ApplyPlayerAnimation(playerid, "CRACK", "crckidle1", 4.0, 1, 0, 0, 0, 0, 1);
    }
    return 1;
}

CMD:chat(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "MISC", "IDLE_CHAT_02", 2.0, 1, 0, 0, 0, 10000, 1);
	return 1;
}

CMD:hike(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"PED","idle_taxi", 3.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:caract(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"PED","TAP_HAND",4.0, 1, 0 , 0, 0, 0, 1);
	return 1;
}

CMD:give(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"KISSING","gift_give",3.0,0,0,0,0,0,1);
	return 1;
}

CMD:liftup(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "CARRY", "LIFTUP", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:putdown(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "CARRY", "PUTDWN", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:cry(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "GRAVEYARD", "MRNF_LOOP", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:mourn(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "GRAVEYARD", "MRNM_LOOP", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:endchat(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"PED","endchat_01",8.0,0,0,0,0,0,1);
	return 1;
}

CMD:show(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "ON_LOOKERS", "point_loop", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:shoutanim(playerid, params[])
{
    ApplyPlayerAnimation(playerid, "ON_LOOKERS", "shout_loop", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:look(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "ON_LOOKERS", "lkup_loop", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:drunk(playerid, params[])
{
	ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1,1,1,1,1,1);
	return 1;
}

CMD:play(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /play [1-3]");
    if(!strcmp(params, "1", true))
    {
        ApplyPlayerAnimation(playerid, "CRIB", "PED_CONSOLE_LOOP", 4.0, 1, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "2", true))
    {
        ApplyPlayerAnimation(playerid, "CRIB", "PED_CONSOLE_WIN", 4.0, 0, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "3", true))
    {
        ApplyPlayerAnimation(playerid, "CRIB", "PED_CONSOLE_LOOSE", 4.0, 0, 0, 0, 0, 0, 1);
    }
    return 1;
}

CMD:pee(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /pee [1-2]");
    if(!strcmp(params, "1", true))
    {
        ApplyPlayerAnimation(playerid, "PAULNMAC", "PISS_IN", 4.0, 0, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "2", true))
    {
        SetPlayerSpecialAction(playerid, 68);
    }
    return 1;
}

CMD:wank(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /wank [1-2]");
    if(!strcmp(params, "1", true))
    {
        ApplyPlayerAnimation(playerid, "PAULNMAC", "WANK_IN", 4.0, 0, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "2", true))
    {
        ApplyPlayerAnimation(playerid, "PAULNMAC", "WANK_LOOP", 4.0, 1, 0, 0, 0, 0, 1);
    }
    return 1;
}

CMD:sit(playerid, params[])
{

    if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /sit [1-3]");
    if(!strcmp(params, "1", true))
    {
		ApplyPlayerAnimation(playerid, "MISC", "SEAT_LR", 4.0, 1, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "2", true))
    {
		ApplyPlayerAnimation(playerid, "MISC", "SEAT_TALK_01", 4.0, 1, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "3", true))
    {
		ApplyPlayerAnimation(playerid, "BEACH", "PARKSIT_M_LOOP", 4.0, 1, 0, 0, 0, 0, 1);
    }
	return 1;
}

CMD:bball(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /bball [1-6]");
    if(!strcmp(params, "1", true))
    {
		ApplyPlayerAnimation(playerid, "BSKTBALL", "BBALL_JUMP_SHOT", 4.0, 0, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "2", true))
    {
		ApplyPlayerAnimation(playerid, "BSKTBALL", "BBALL_DEF_LOOP", 4.0, 1, 1, 0, 1, 0, 1);
    }
    else if(!strcmp(params, "3", true))
    {
		ApplyPlayerAnimation(playerid, "BSKTBALL", "BBALL_PICKUP", 4.0, 0, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "4", true))
    {
		ApplyPlayerAnimation(playerid, "BSKTBALL", "BBALL_DNK", 4.0, 0, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "5", true))
    {
		ApplyPlayerAnimation(playerid, "BSKTBALL", "BBALL_IDLE", 4.0, 1, 0, 0, 1, 0, 1);
    }
    else if(!strcmp(params, "6", true))
    {
		ApplyPlayerAnimation(playerid, "BSKTBALL", "BBALL_IDLE2", 4.0, 1, 0, 0, 1, 0, 1);
    }
	return 1;
}

CMD:scratch(playerid, params[])
{
    ApplyPlayerAnimation(playerid, "MISC", "Scratchballs_01", 4.0, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:reload(playerid, params[])
{
    ApplyPlayerAnimation(playerid, "COLT45", "COLT45_RELOAD", 4.0, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:injured(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:gsign(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /gsign [1-8]");
    if(!strcmp(params, "1", true))
    {
    	ApplyPlayerAnimation(playerid, "GHANDS", "GSIGN1", 4.0, 0, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "2", true))
    {
    	ApplyPlayerAnimation(playerid, "GHANDS", "GSIGN2", 4.0, 0, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "3", true))
    {
        ApplyPlayerAnimation(playerid, "GHANDS", "GSIGN3", 4.0, 0, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "4", true))
    {
        ApplyPlayerAnimation(playerid, "GHANDS", "GSIGN4", 4.0, 0, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "5", true))
    {
        ApplyPlayerAnimation(playerid, "GHANDS", "GSIGN5", 4.0, 0, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "6", true))
    {
        ApplyPlayerAnimation(playerid, "GHANDS", "GSIGN1LH", 4.0, 0, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "7", true))
    {
        ApplyPlayerAnimation(playerid, "GHANDS", "GSIGN2LH", 4.0, 0, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "8", true))
    {
        ApplyPlayerAnimation(playerid, "GHANDS", "GSIGN5LH", 4.0, 0, 0, 0, 0, 0, 1);
    }
    return 1;
}

CMD:chill(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /chill [1-2]");
    if(!strcmp(params, "1", true))
    {
    	ApplyPlayerAnimation(playerid, "RAPPING", "RAP_A_Loop", 4.1, 1, 1, 1, 1, 1, 1);
    }
    else if(!strcmp(params, "2", true))
    {
        ApplyPlayerAnimation(playerid, "RAPPING", "RAP_B_Loop", 4.1, 1, 1, 1, 1, 1, 1);
    }
    return 1;
}

CMD:tag(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /tag [1-3]");
    if(!strcmp(params, "1", true))
    {
        ApplyPlayerAnimation(playerid, "GRAFFITI", "GRAFFITI_CHKOUT", 4.0, 0, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "2", true))
    {
        ApplyPlayerAnimation(playerid, "GRAFFITI", "SPRAYCAN_FIRE", 4.0, 0, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(params, "3", true))
    {
        ApplyPlayerAnimation(playerid, "SPRAYCAN", "SPRAYCAN_FULL", 4.0, 0, 0, 0, 0, 0, 1);
    }
    return 1;
}

CMD:camera(playerid, params[])
{
    new
	give[5];

    if(sscanf(params, "s[5]", give)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /camera [1-3]");
    if(!strcmp(give, "1", true))
    {
        ApplyPlayerAnimation(playerid, "CAMERA", "camcrch_cmon", 4.1, 0, 1, 1, 1, 1, 1);
    }
    else if(!strcmp(give, "2", true))
    {
        ApplyPlayerAnimation(playerid, "CAMERA", "camstnd_to_camcrch", 4.1, 0, 1, 1, 1, 1, 1);
    }
    else if(!strcmp(give, "3", true))
    {
        ApplyPlayerAnimation(playerid, "CAMERA", "PICCRCH_TAKE", 4.0, 1, 0, 0, 0, 0);
    }
    return 1;
}

CMD:rap(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"RAPPING","RAP_A_Loop",4.0,1,0,0,0,0,1);
	return 1;
}

CMD:think(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "COP_AMBIENT", "Coplook_think", 4.1, 0, 1, 1, 1, 1, 1);
	return 1;
}

CMD:box(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"GYMNASIUM","GYMshadowbox",4.0,1,1,1,1,0,1);
	return 1;
}

CMD:tired(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"PED","IDLE_tired",3.0,1,0,0,0,0,1);
	return 1;
}

CMD:bar(playerid, params[])
{
    new
	give[3];

    if(sscanf(params, "s[3]", give)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /bar [1-2]");
    if(!strcmp(give, "1", true))
    {
		ApplyPlayerAnimation(playerid, "BAR", "Barserve_bottle", 2.0, 0, 0, 0, 0, 0,1);
    }
	else if(!strcmp(give, "2", true))
    {
		ApplyPlayerAnimation(playerid, "BAR", "Barserve_give", 2.0, 0, 0, 0, 0, 0,1);
    }
	return 1;
}

CMD:bat(playerid, params[])
{
    new
	give[4];

    if(sscanf(params, "s[4]", give)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /bat [1-3]");
    if(!strcmp(give, "1", true))
    {
		ApplyPlayerAnimation(playerid, "BASEBALL", "Bat_IDLE", 2.0, 0, 0, 0, 0, 0,1);
    }
    else if(!strcmp(give, "2", true))
    {
		ApplyPlayerAnimation(playerid, "CRACK", "Bbalbat_Idle_01", 2.0, 0, 0, 0, 0, 0,1);
    }
    else if(!strcmp(give, "3", true))
    {
		ApplyPlayerAnimation(playerid, "CRACK", "Bbalbat_Idle_02", 2.0, 0, 0, 0, 0, 0,1);
    }
	return 1;
}

CMD:lean(playerid, params[])
{
	new
	give[7];

    if(sscanf(params, "s[7]", give)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /lean [1-2]");
    if(!strcmp(give, "1", true))
    {
   		ApplyPlayerAnimation(playerid,"GANGS","leanIDLE",4.0,0,1,1,1,0,1);
    }
    if(!strcmp(give, "2", true))
    {
   		ApplyPlayerAnimation(playerid,"MISC","Plyrlean_loop",4.1,1,0,0,0,0);
    }
	return 1;
}

CMD:dance(playerid, params[])
{
    new
	give[7];

    if(sscanf(params, "s[7]", give)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /dance [1-5]");
    if(!strcmp(give, "1", true))
    {
   		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE1);
    }
    if(!strcmp(give, "2", true))
    {
   		ApplyPlayerAnimation(playerid, "DANCING", "DNCE_M_A", 4.0, 1, 0, 0, 0, 0, 1);
    }
    if(!strcmp(give, "3", true))
    {
   		ApplyPlayerAnimation(playerid, "DANCING", "DNCE_M_B", 4.0, 1, 0, 0, 0, 0, 1);
    }
    if(!strcmp(give, "4", true))
    {
   		ApplyPlayerAnimation(playerid, "DANCING", "DNCE_M_D", 4.0, 1, 0, 0, 0, 0, 1);
    }
    if(!strcmp(give, "5", true))
    {
   		ApplyPlayerAnimation(playerid, "DANCING", "DNCE_M_E", 4.0, 1, 0, 0, 0, 0, 1);
    }
    return 1;
}

CMD:searchfiles(playerid, params[])
{
    new
	give[7];

    if(sscanf(params, "s[7]", give)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /searchfiles [1-3]");
    if(!strcmp(give, "1", true))
    {
   		ApplyPlayerAnimation(playerid, "COP_AMBIENT", "COPBROWSE_IN", 4.0, 0, 1, 0, 1, 0, 1);
    }
    if(!strcmp(give, "2", true))
    {
   		ApplyPlayerAnimation(playerid, "COP_AMBIENT", "COPBROWSE_NOD", 4.0, 0, 1, 0, 1, 0, 1);
    }
    if(!strcmp(give, "3", true))
    {
   		ApplyPlayerAnimation(playerid, "COP_AMBIENT", "COPBROWSE_OUT", 4.0, 0, 1, 0, 0, 0, 1);
    }
    return 1;
}

CMD:kiss(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "BD_Fire", "grlfrd_kiss_03", 2.0, 0, 0, 0, 0, 0,1);
	return 1;
}

CMD:cpr(playerid, params[])
{
    ApplyPlayerAnimation(playerid, "MEDIC", "CPR", 4.0, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:handsup(playerid, params[])
{
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
	return 1;
}

CMD:bomb(playerid, params[])
{
	ClearAnimations(playerid);
	ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0,1); // Place Bomb
	return 1;
}

CMD:getarrested(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1,1); // Gun Arrest
	return 1;
}

CMD:laugh(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0,1); // Laugh
	return 1;
}

CMD:lookout(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0,1); // Rob Lookout
	return 1;
}

CMD:aim(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0,1); // Rob
	return 1;
}

CMD:crossarms(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 1, 0, 1, 1, -1,1); // Arms crossed
	return 1;
}

CMD:car(playerid, params[])
{
    new
	give[4];

    if(sscanf(params, "s[4]", give)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /car [1-3]");
    if(!strcmp(give, "1", true))
    {
   		ApplyPlayerAnimation(playerid,"CAR","Fixn_Car_Loop", 4.0, 1, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(give, "2", true))
    {
        ApplyPlayerAnimation(playerid, "CAR", "Fixn_Car_Out", 4.1, 1, 1, 1, 1, 1, 1);
    }
    else if(!strcmp(give, "3", true))
    {
        ApplyPlayerAnimation(playerid, "CAR", "flag_drop", 4.1, 1, 1, 1, 1, 1, 1);
    }
    return 1;
}

CMD:lay(playerid, params[])
{
    new
	give[4];

    if(sscanf(params, "s[4]", give)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /lay [1-4]");
    if(!strcmp(give, "1", true))
    {
   		ApplyPlayerAnimation(playerid,"BEACH","bather", 4.0, 1, 0, 0, 0, 0,1);
    }
    else if(!strcmp(give, "2", true))
    {
        ApplyPlayerAnimation(playerid,"BEACH","SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0,1);
    }
    else if(!strcmp(give, "3", true))
    {
        ApplyPlayerAnimation(playerid,"CRACK","crckidle4", 4.0, 1, 0, 0, 0, 0,1);
    }
    else if(!strcmp(give, "4", true))
    {
        ApplyPlayerAnimation(playerid,"BEACH","PARKSIT_W_LOOP", 4.0, 1, 0, 0, 0, 0,1);
    }
    return 1;
}

CMD:what(playerid, params[])
{
    new
	give[3];

    if(sscanf(params, "s[3]", give)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /what [1-2]");
    if(!strcmp(give, "1", true))
    {
        ApplyPlayerAnimation(playerid,"RIOT","RIOT_ANGRY", 4.0, 0, 0, 0, 0, 0, 0);
    }
    else if(!strcmp(give, "2", true))
    {
        ApplyPlayerAnimation(playerid,"benchpress","gym_bp_celebrate", 4.0, 0, 0, 0, 0, 0, 0);
    }
    return 1;
}

CMD:hide(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 0,1);
	return 1;
}

CMD:vomit(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0,1); // Vomit BAH!
	return 1;
}

CMD:eat(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "FOOD", "EAT_PIZZA", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:wave(playerid, params[])
{
    new
	give[3];

    if(sscanf(params, "s[3]", give)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /wave [1-3]");
    if(!strcmp(give, "1", true))
    {
   		ApplyPlayerAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0,1);
    }
    else if(!strcmp(give, "2", true))
    {
        ApplyPlayerAnimation(playerid, "KISSING", "GFWAVE2", 4.0, 0, 0, 0, 0, 0, 1);
    }
    else if(!strcmp(give, "3", true))
    {
        ApplyPlayerAnimation(playerid, "KISSING", "BD_GF_WAVE", 4.0, 0, 0, 0, 0, 0, 1);
    }
    return 1;
}

CMD:strip(playerid, params[])
{
    new
	give[3];

    if(sscanf(params, "s[4]", give)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /strip [1-4]");
    if(!strcmp(give, "1", true))
    {
   		ApplyPlayerAnimation(playerid, "STRIP", "STRIP_A", 4.0, 1, 0, 0, 0, 0);
    }
    else if(!strcmp(give, "2", true))
    {
        ApplyPlayerAnimation(playerid, "STRIP", "STR_LOOP_A", 4.0, 1, 0, 0, 0, 0);
    }
    else if(!strcmp(give, "3", true))
    {
        ApplyPlayerAnimation(playerid, "STRIP", "STR_LOOP_B", 4.0, 1, 0, 0, 0, 0);
    }
    else if(!strcmp(give, "4", true))
    {
        ApplyPlayerAnimation(playerid, "STRIP", "STR_LOOP_C", 4.0, 1, 0, 0, 0, 0);
    }
    return 1;
}

CMD:chant(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"RIOT","RIOT_CHANT",4.0,1,1,1,1,0,1);
	return 1;
}

CMD:slapass(playerid, params[])
{
    new
	give[3];

    if(sscanf(params, "s[3]", give)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /slap [1-2]");
    if(!strcmp(give, "1", true))
    {
   		ApplyPlayerAnimation(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0,1);
    }
    else if(!strcmp(give, "2", true))
    {
        ApplyPlayerAnimation(playerid, "FLOWERS", "FLOWER_ATTACK_M", 4.0, 0, 0, 0, 0, 0, 1);
    }
    return 1;
}

CMD:deal(playerid, params[])
{
	ApplyPlayerAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0,1); // Deal Drugs
 	return 1;
}

CMD:fucku(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"PED","fucku",4.0,0,0,0,0,0,1);
	return 1;
}

CMD:taichi(playerid, params[])
{
	ApplyPlayerAnimation(playerid,"PARK","Tai_Chi_Loop",4.0,0,0,0,0,0,1);
	return 1;
}

CMD:stopanim(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid))
    {
        ApplyPlayerAnimation(playerid, "CAR_CHAT", "CAR_Sc1_FR", 4.1, 0, 0, 0, 1, 1, 1);
	}
	else
	{
	    ClearAnimations(playerid);
	    if(PlayerInfo[playerid][pHandcuffed])
	    	return 1;
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
	}
	return 1;
}

CMD:buyclothes(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 50.0, 207.583,-110.885,1005.13))
    {
  		ShowModelSelectionMenu(playerid, skins, "Clothes");
	}
	else return SCM(playerid, COLOR_GREY, "You need to be in a clothes shop.");
  	return 1;
}

CMD:droplicense(playerid, params[])
{
	PlayerInfo[playerid][pDriversLicense] = 0;
	SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s Dropped their driverslicense.", ReturnName(playerid, 0));
	return 1;
}

CMD:refuel(playerid, params[])
{
    new info[128];
    new vehicleid = GetPlayerVehicleID(playerid);
	strcat(info, "Refuel Vehicle  ($" #FUEL_PRICE " per liter)", sizeof(info));
	if(VehicleInfo[vehicleid][eVehicleEngineStatus] == true)
	    return SCM(playerid, COLOR_LIGHTRED, "Turn your engine off.");
	if(IsPlayerInRangeOfPoint(playerid, 10.0, -2278.7888,2409.3823,4.9141) || IsPlayerInRangeOfPoint(playerid, 15.0, -1471.5280,1864.1913,32.0834) || IsPlayerInRangeOfPoint(playerid, 15.0, -1328.3480,2677.3635,49.5130)|| IsPlayerInRangeOfPoint(playerid, 15.0, 1939.9840,-1769.2646,13.3828))
	{
		ShowPlayerDialog(playerid, DIALOG_FUEL, DIALOG_STYLE_LIST, "Fuel Station", info, "OK", "Cancel");
		return 1;
	}
	else
	SendClientMessage(playerid, COLOR_LIGHTRED, "You are not at a fuel station.");
	return 1;
}

// Fishing //

CMD:fish(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 15.0, -2373.2520, 2211.9939, 4.3631))
	{
	        if(WormAttached[playerid] < 1) return SCM(playerid, COLOR_LIGHTRED, "You need to have a worm attached to the fishing rod to fish.");
	        if(Equipped[playerid] == 0) return SCM(playerid, COLOR_LIGHTRED, "You need to have your fishing rod equipped.");
	        if(Fishing[playerid] == true) return SCM(playerid, COLOR_LIGHTRED, "You are already fishing.");
	        SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "begins to fish with his fishing rod.");
  			fish[playerid] = 25; //change it with the timer time
    		TimerFish[playerid] = SetTimerEx("timerFish",500,1,"i",playerid);
		    TogglePlayerControllable(playerid,0);
		    WormAttached[playerid] = 0;
	    	ApplyAnimation(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1,1);
	    	Fishing[playerid] = true;
	    	wormattached2[playerid] = 0;
	}
	else return SCM(playerid, COLOR_LIGHTRED, "You can't fish here.");
  	return 1;
}

CMD:attachworm(playerid, params[])
{
	if(PlayerInfo[playerid][pFishingRod] < 1) return SCM(playerid, COLOR_LIGHTRED, "You need to have a fishing rod.");
	if(attachingw[playerid] == 1) return SCM(playerid, COLOR_LIGHTRED, "You're already attaching a worm to your hook.");
	if(PlayerInfo[playerid][pWorms] < 1) return SCM(playerid, COLOR_LIGHTRED, "You need to have a worm.");
	if(Equipped[playerid] == 0) return SCM(playerid, COLOR_LIGHTRED, "You need to have your fishing rod equipped.");
	if(wormattached2[playerid] == 1) return SCM(playerid, COLOR_LIGHTRED, "You have already attached a worm to your hook.");
	if(Fishing[playerid] == true) return SCM(playerid, COLOR_LIGHTRED, "You are already fishing. Attach a worm when you're done fishing.");
	SendNearbyMessage(playerid,20.0, COLOR_EMOTE, "begins to fiddle with the fishing hook.");
	AttachWorm[playerid] = 5; //change it with the timer time
	TimerAttachWorm[playerid] = SetTimerEx("timerAttachWorm",500,1,"i",playerid);
	TogglePlayerControllable(playerid,0);
	PlayerInfo[playerid][pWorms] -= 1;
	attachingw[playerid] = 1;
	wormattached2[playerid] = 1;
  	return 1;
}

CMD:sellfish(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 7.0, 388.1848,-2088.7964,7.8359) || IsPlayerInRangeOfPoint(playerid, 7.0, -2255.0498, 2556.8599, 2.9914))
	{
	    if(PlayerInfo[playerid][pFishes] < 1) return SCM(playerid, COLOR_LIGHTRED, "You do not have any fishes.");
	    new string[64];
		new sellfishamount = (PlayerInfo[playerid][pFishes])*(sellfish);
		GiveMoney(playerid, sellfishamount);
		format(string, sizeof(string), "You have sold all of your fishes for: $%d.", sellfishamount);
		SendClientMessage(playerid, COLOR_WHITE, string);
		PlayerInfo[playerid][pFishes] = 0;
	}
	else SendErrorMessage(playerid, "You are not at the fishingshop");
  	return 1;
}

CMD:fshop(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 2.0, -2255.0498, 2556.8599, 2.9914))
	{
	    ShowPlayerDialog(playerid, DIALOG_FISH_BUY, DIALOG_STYLE_LIST, "Fishing Shop", "Simple Fishing Rod ($15)\nWorms ($50)", "Purchase", "Cancel");
	}
	return 1;
}

CMD:fishingrod(playerid, params[])
{
	if(PlayerInfo[playerid][pFishingRod] < 1) return SCM(playerid, COLOR_LIGHTRED, "You do not have a fishing rod.");
	if(Equipped[playerid] == 0)
	{
 		RodObject = SetPlayerAttachedObject(playerid, 0,18632,6,0.079376,0.037070,0.007706,181.482910,0.000000,0.000000,1.000000,1.000000,1.000000);
 		Equipped[playerid] = 1;
	}
	else if(Equipped[playerid] == 1)
	{
		RemovePlayerAttachedObject(playerid,0);
		RemovePlayerAttachedObject(playerid,RodObject);
		Equipped[playerid] = 0;
	}
	return 1;
}

CMD:fishhelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_CUBER, "_________________Fish help_________________");
    SCM(playerid, COLOR_CUBEG, "[HELP:] Type /fishingrod to equip your fishing rod.");
    SCM(playerid, COLOR_CUBEG, "[HELP:] You can buy a fishing rod and worms at the fishing store. (/map)");
	SCM(playerid, COLOR_CUBEG, "[FISHING:] /attachworm /fish /fshop /fishingrod, /sellfish");
	return 1;
}

// Job Commands
CMD:getjob(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] > 0)
		return SCM(playerid, COLOR_RED, "You already have a job");

    if(IsPlayerInRangeOfPoint(playerid, 2.0, 365.0197,-5.3500,1001.8516))
    {
        SCM(playerid, COLOR_GRAD1, "You are a pizzaboy now");
    	SetPlayerSkin (playerid, 155);
    	PlayerInfo[playerid][pLastSkin] = 155;
    	PlayerInfo[playerid][pJob] = 1;
    	SaveCharacter(playerid);
    }
    else if(IsPlayerInRangeOfPoint(playerid, 2.0,2508.8284,-2119.4658,13.5469))
    {
        SCM(playerid, COLOR_GRAD1, "You are a mechanic now");
    	SetPlayerSkin (playerid, 50);
    	PlayerInfo[playerid][pLastSkin] = 50;
    	PlayerInfo[playerid][pJob] = 2;
    	SaveCharacter(playerid);
    }
    else if(IsPlayerInRangeOfPoint(playerid, 2.0, 2767.9299,-1611.6864,10.9219))
    {
        SCM(playerid, COLOR_GRAD1, "You are a taxi driver now");
    	PlayerInfo[playerid][pJob] = 3;
    	SaveCharacter(playerid);
    }
    else if(IsPlayerInRangeOfPoint(playerid, 2.0, 2099.6868,-2062.7520,13.5544))
    {
        SCM(playerid, COLOR_GRAD1, "You are a truck driver now");
    	PlayerInfo[playerid][pJob] = 4;
    	SaveCharacter(playerid);
    }
    else SCM(playerid, COLOR_RED, "You're not at a location where you can get a job");
    return 1;
}

CMD:quitjob(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] == 0)
		return SCM(playerid, COLOR_RED, "You don't have a job");

    PlayerInfo[playerid][pJob] = 0;
    PlayerInfo[playerid][pWorking] = 0;
    SetPlayerColor(playerid, COLOR_WHITE);
    SetPlayerSkin (playerid, 20003);
    PlayerInfo[playerid][pLastSkin] = 20003;
    SCM(playerid, COLOR_RED, "The skin that has been assigned to you is the noob skin. Please do not roleplay using this skin.");
    SaveCharacter(playerid);
    return 1;
}

CMD:stoppizzajob(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] == 0)
		return SCM(playerid, COLOR_RED, "You don't have a job");

	if(PlayerInfo[playerid][pWorking] == 0)
		return SendErrorMessage(playerid, "You're not working.");

	SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s their phone starts to ring.", ReturnName(playerid, 0));
	SCM(playerid, COLOR_WHITE, "Boss: You're just stopping like this? I'm taking this out of your paycheck.");
	GiveMoney(playerid, -100);
    DisablePlayerCheckpoint(playerid);
    pizzacp[playerid] = 0;
    PlayerInfo[playerid][pWorking] = 0;
	return 1;
}

// Pizza Commands

CMD:pizzajob(playerid, params[])
{
	if(PlayerInfo[playerid][pWorking] == 1)
		return SendErrorMessage(playerid, "You're already working.");

    if(PlayerInfo[playerid][pJob] != 1)
		return SendErrorMessage(playerid, "You're not a a pizzaboy.");

	new vehicleid = GetPlayerVehicleID(playerid);
	new rand = random(sizeof(pizza));
	if(!IsPlayerInPizzaVehicle(playerid))
		return SendErrorMessage(playerid, "You aren't on a pizza bike.");

	if(IsPlayerInRangeOfPoint(playerid, 5.0, -2527.7644,2288.0918,4.5828))
	{
	ToggleVehicleEngine(vehicleid, true); VehicleInfo[vehicleid][eVehicleEngineStatus] = true;
 	pizzacp[playerid] = 1;
  	SetPlayerCheckpoint(playerid,pizza[rand][0],pizza[rand][1],pizza[rand][2],1);
  	PlayerInfo[playerid][pWorking] = 1;
  	}
  	else return SendErrorMessage(playerid, "You're not at the Cluck'n Bell");
	return 1;
}

// q Commands

CMD:tow(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] != 2)
		return SendErrorMessage(playerid, "You aren't a mechanic.");
		
    if(PlayerInfo[playerid][pJob] == 2 && PlayerInfo[playerid][pWorking] == 0)
		return SendErrorMessage(playerid, "You're not working.");
		
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are not driving a vehicle!");
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(vehicleid) != 525)
 		return SendErrorMessage(playerid, "You aren't driving a towtruck.");
	if(IsTrailerAttachedToVehicle(vehicleid))
	{
		DetachTrailerFromVehicle(vehicleid);
		return 1;
	}
	new Float:x, Float:y, Float:z;
	new Float:dist, Float:closedist=8, closeveh;
	for(new i=1; i < MAX_VEHICLES; i++)
	{
		if(i != vehicleid && GetVehiclePos(i, x, y, z))
		{
			dist = GetPlayerDistanceFromPoint(playerid, x, y, z);
			if(dist < closedist)
			{
				closedist = dist;
				closeveh = i;
			}
		}
	}
	if(!closeveh) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are not close to a vehicle!");
	AttachTrailerToVehicle(closeveh, vehicleid);
	return 1;
}

CMD:fix(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] == 2 && PlayerInfo[playerid][pWorking] == 0)
		return SendErrorMessage(playerid, "You're not working.");
		
    if(PlayerInfo[playerid][pJob] == 2)
	{
    	new string[32 + MAX_PLAYER_NAME];
        if(IsPlayerInAnyVehicle(playerid))
		{
		    SendClientMessageEx(playerid, COLOR_GRAD1, "You can not repair while inside the vehicle.");
		    return 1;
		}
  		else
		{
			new closestcar = GetClosestCar(playerid);

  			if(IsPlayerInRangeOfVehicle(playerid, closestcar, 10.0))
  			{
				if(!IsABike(closestcar) && !IsAPlane(closestcar)) {
					new engine,lights,alarm,doors,bonnet,boot,objective;
					GetVehicleParamsEx(closestcar,engine,lights,alarm,doors,bonnet,boot,objective);
					if(bonnet == VEHICLE_PARAMS_OFF || bonnet == VEHICLE_PARAMS_UNSET)
					{
						SendClientMessageEx(playerid, COLOR_GRAD1, "The vehicle hood must be opened in order to repair it.");
						return 1;
					}
				}
   				SetVehicleHealth(closestcar, 1000.0);
    			format(string, sizeof(string), "* %s has repaired the vehicle.*", ReturnName(playerid));
    			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, string, ReturnName(playerid, 0));
			}
			else return SendClientMessageEx(playerid, COLOR_GRAD1, "You are not close enough to any vehicle.");
  		}
    }
    else return SendClientMessageEx(playerid, COLOR_WHITE, "You are not a Mechanic!" );
    return 1;
}

CMD:phonebook(playerid, params[])
{
	SendClientMessage(playerid, COLOR_CUBER, "_________________Usefull numbers:_________________");

	SendClientMessage(playerid, COLOR_CUBEG, "911 - Emergency Service number");
	SendClientMessage(playerid, COLOR_CUBEG2, "457 - Mechanical Service");
	SendClientMessage(playerid, COLOR_CUBEG, "686 - Taxi Service");
	return 1;
}

CMD:smuggle(playerid,params[])
{
    new vehicleid = GetPlayerVehicleID(playerid),
    rand = random(sizeof(smuggle))
	;
	if(PlayerInfo[playerid][pSmuggling] == 1)
		return SCM(playerid, COLOR_GREY,"You're already smuggling.");
	if(IsABoat(vehicleid))
	{
	    if(!IsSmuggleBoat(vehicleid))
			return SendErrorMessage(playerid, "This is not a smuggleboat");
			
		PlayerInfo[playerid][pSmuggling] = 1;
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s their phone would beep, displaying a message.", ReturnName(playerid, 0));
		SCM(playerid, COLOR_GRAD1,"Private Number: Go get my supplies then we'll talk.");
		SetPlayerCheckpoint(playerid,smuggle[rand][0],smuggle[rand][1],smuggle[rand][2],1);
		smugglecp[playerid] = 1;
	}
	else SCM(playerid, COLOR_GREY,"You're not on a boat.");
	return 1;
}

CMD:stopsmuggle(playerid,params[])
{
	if(PlayerInfo[playerid][pSmuggling] == 0)
		return SCM(playerid, COLOR_RED, "You're not smuggling.");

 	SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s their phone would beep, displaying a message.", ReturnName(playerid, 0));
	SCM(playerid, COLOR_GRAD1,"Private Number: You really went out of your way to fail on me like this? You're in Debt.");
	GiveMoney(playerid, -150);
    DisablePlayerCheckpoint(playerid);
    smugglecp[playerid] = 0;
    PlayerInfo[playerid][pSmuggling] = 0;
    RemovePlayerAttachedObject(playerid, 9);
	return 1;
}

CMD:climb(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid))
		return SendErrorMessage(playerid, "You're Inside of a vehicle.");

	if(IsPlayerInRangeOfPoint(playerid, 3.0,-2329.0156, 1528.7533, 0.7219))
	{
	    SetPlayerPos(playerid, -2327.4351, 1532.2285, 16.8729);
	}
	else SCM(playerid, COLOR_LIGHTRED, "There is nothing to climb here.");
	return 1;
}

CMD:scar(playerid,params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    VehicleInfo[vehicleid][eVehicleID] = vehicleid;
    SaveVehicle(vehicleid);
    SaveCharacter(playerid);
	return 1;
}

CMD:stash(playerid, params[])
{
    new
	closestcar = GetClosestCar(playerid),
	model = GetVehicleModel(closestcar);

	if(PlayerInfo[playerid][pSmuggling] == 0)
		return SCM(playerid, COLOR_RED, "You're not smuggling.");

    if(PlayerInfo[playerid][pCarry] == 0)
		return SCM(playerid, COLOR_RED, "You're not carrying any smuggle material.");

	if(IsPlayerInRangeOfVehicle(playerid, closestcar, 4.0))
	{
	    if(IsSmuggleBoat(closestcar))
	    {
	        ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0,1);
 	    	PlayerInfo[playerid][pCarry] = 0;
       		RemovePlayerAttachedObject(playerid, 9);
       		VehicleInfo[closestcar][eVehicleStash] = 1;
         	smugglebag[playerid] = CreateDynamicObject(11745, 0, 0, -1000, 0, 0, 0);
         	
         	if(model == 473){AttachDynamicObjectToVehicle(smugglebag[playerid], closestcar, -0.02430, 1.64271, 0.76649,   1.80000, -26.52000, 92.64003);}
         	if(model == 446){AttachDynamicObjectToVehicle(smugglebag[playerid], closestcar, 0.55939, -1.09281, 1.12228,   0.00000, 0.00000, 93.41998);}
         	if(model == 453){AttachDynamicObjectToVehicle(smugglebag[playerid], closestcar, -0.06243, 0.70013, 2.83463,   0.00000, 0.00000, 60.66002);}
         	if(model == 454){AttachDynamicObjectToVehicle(smugglebag[playerid], closestcar, -0.22078, -1.32557, 2.86666,   0.00000, 0.00000, 54.72002);}
		}
		else SendErrorMessage(playerid, "This is not a boat where you can stash your goods or it is already stashed");
	}
	else SendErrorMessage(playerid, "You're not near a stashboat");
	return 1;
}

CMD:unstash(playerid, params[])
{
    new closestcar = GetClosestCar(playerid);

    if(PlayerInfo[playerid][pSmuggling] == 0)
		return SCM(playerid, COLOR_RED, "You're not smuggling.");

    if(PlayerInfo[playerid][pCarry] == 1)
		return SCM(playerid, COLOR_RED, "You're already carrying smuggle material.");

 	if(IsPlayerInRangeOfVehicle(playerid, closestcar, 4.0))
	{
	    if(VehicleInfo[closestcar][eVehicleStash] == 1)
	    {
	        ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0,1);
	        PlayerInfo[playerid][pCarry] = 1;
	        VehicleInfo[closestcar][eVehicleStash] = 0;
	        DestroyDynamicObject(smugglebag[playerid]);
	        SetPlayerAttachedObject(playerid, 9, 11745, 6, 0.1619, -0.0190, 0.0000, 0.0000, -79.3999, 97.4999, 1.0000, 1.0000, 1.0000, 0, 0);
		}
		else SendErrorMessage(playerid, "There is nothing stashed in this vehicle");
	}
	else SendErrorMessage(playerid, "You're not near a stashboat");
	return 1;
}

CMD:gotosmuggle(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
			return SendUnauthMessage(playerid);
			
	if(isnull(params)) return SendClientMessage(playerid, COLOR_GREEN, "[Usage:] /gotosmuggle (ID)");
	{
	if(!strcmp(params, "1", true, 7))
	{
	SetPlayerPos(playerid, -2473.1389,1553.8724,33.2344);
	}
	if(!strcmp(params, "2", true, 7))
	{
	SetPlayerPos(playerid, -1394.6014,1480.8807,1.8672);
	}
	if(!strcmp(params, "3", true, 7))
	{
	SetPlayerPos(playerid, -1342.6853,491.2126,11.1953);
	}
	if(!strcmp(params, "4", true, 7))
	{
	SetPlayerPos(playerid, -1154.3422,-478.6216,1.9609);
	}
	if(!strcmp(params, "dam", true, 7))
	{
	SetPlayerPos(playerid, -830.9731,1985.0918,9.4007);
	}
	if(!strcmp(params, "shop", true, 7))
	{
	SetPlayerPos(playerid, -796.0307,2259.3723,59.4689);
	}
	}
	return 1;
}

CMD:jimshop(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 299.9676,308.2690,999.1484))
	{
	    if(BusinessInfo[8][eBusinessProducts] <= 0)
			return SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "Jim: Sorry partner I dont have anything in stock for ya.");

        ShowPlayerDialog(playerid, DIALOG_JIM, DIALOG_STYLE_TABLIST_HEADERS, "Jim's Mighty shop",
        "Weapon\tPrice\tAmmo\n\
		Desert Eagle\t$25.000\t50\n\
		Shotgun\t$25.000\t25\n\
		Rifle\t$17.500\t75\n\
		AK-47\t$60.000\t150\n\
		Knife\t$75\n\
		Basseball bat\t$100\n\
		Explosive\t$10.000\t1",
		"Buy", "Exit");
	}
	return 1;
}

CMD:channel(playerid, params[])
{
    if(isnull(params))
        return SendClientMessage(playerid, COLOR_GREEN, "[Usage:] /channel (Channel ID)");

    if(strcmp(params, "on", true) && !Voip[playerid])
        return SendClientMessage(playerid, -1, "You have not activated your Voip label. (Hint: /channel on)");

    if(!strcmp(params, "on", true))
    {
        if(!client_found)
			return SendErrorMessage(playerid, "We did not find you on our Teamspeak, please reconnect.");
    
        Attach3DTextLabelToPlayer(voiplabel[playerid], playerid, 0.0, 0.0, 0.275);
        SCM(playerid, 0xE91616FF, "You have turned on your VoiP marker, you CANNOT turn this off.");

        Voip[playerid] = true;
    }
    else if(!strcmp(params, "lobby", true))
    {
        Update3DTextLabelText(voiplabel[playerid], 0xE91616FF, "Channel: Lobby");
        SendNearbyMessage(playerid, 20.0, 0xE91616FF, "**%s Has switched to the channel Lobby.**", ReturnName(playerid, 0));
        TSC_MoveClient(TSClientID[playerid], 18);
    }
    else
    {
        if(!IsNumeric(params))
            return SendClientMessage(playerid, -1, "[Error]: Invalid paramater.");

        new channel_id, string[128];
        channel_id = strval(params);

        switch(channel_id)
        {
            case 1: TSC_MoveClient(TSClientID[playerid], 13);
            case 2: TSC_MoveClient(TSClientID[playerid], 12);
            case 3: TSC_MoveClient(TSClientID[playerid], 15);
            case 4: TSC_MoveClient(TSClientID[playerid], 16);
            case 5: TSC_MoveClient(TSClientID[playerid], 19);
            default: return SendClientMessage(playerid, -1, "[Error:] Invalid channel.");
        }

        format(string, sizeof string, "Channel: %i", channel_id);
        Update3DTextLabelText(voiplabel[playerid], 0xE91616FF, string);

        SendNearbyMessage(playerid, 20.0, 0xE91616FF, "**%s Has switched to the channel %i.**", ReturnName(playerid, 0), channel_id);
    }
    return 1;
}

CMD:tac(playerid, params[])
{
	if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You can't use this command.");

    if(isnull(params))
        return SendClientMessage(playerid, COLOR_GREEN, "[Usage:] /tac (Channel ID)");

    else if(!strcmp(params, "lobby", true))
    {
        Update3DTextLabelText(voiplabel[playerid], 0xE91616FF, "Channel: Lobby");
        SendNearbyMessage(playerid, 20.0, 0xE91616FF, "**%s Has switched to the channel Lobby.**", ReturnName(playerid, 0));
        TSC_MoveClient(TSClientID[playerid], 23);
    }
    else
    {
        if(!IsNumeric(params))
            return SendClientMessage(playerid, -1, "[Error]: Invalid paramater.");

        new channel_id;
        channel_id = strval(params);

        switch(channel_id)
        {
            case 1: TSC_MoveClient(TSClientID[playerid], 22);
            case 2: TSC_MoveClient(TSClientID[playerid], 24);
            case 3: TSC_MoveClient(TSClientID[playerid], 25);
            default: return SendClientMessage(playerid, -1, "[Error:] Invalid channel.");
        }
    }
    return 1;
}

CMD:gotojob(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
			return SendUnauthMessage(playerid);
			
	if(isnull(params)) return SendClientMessage(playerid, COLOR_GREEN, "[Usage:] /gotojob (ID)");
	{
		if(!strcmp(params, "tow", true, 7))
		{
			SetPlayerPos(playerid, -1485.9392, 1996.4408, 46.9271);
		}
		if(!strcmp(params, "taxi", true, 7))
		{
			SetPlayerPos(playerid, -1413.8309, 2639.5298, 55.0692);
		}
		if(!strcmp(params, "trucking", true, 7))
		{
			SetPlayerPos(playerid, -1295.1902, 2692.5564, 49.7559);
		}
		if(!strcmp(params, "pizza", true, 7))
		{
			SetPlayerPos(playerid, -2530.1958, 2281.0811, 4.8624);
		}
	}
	return 1;
}

CMD:buyfood(playerid, params[])
{
    new
	id = IsPlayerInBusiness(playerid),
	a_str[60], b_str[60],
    totalPrice, amount,
	str[128],
    Float:playerHealth
	;
	GetPlayerHealth(playerid, playerHealth);
    
    if(BusinessInfo[id][eBusinessType] != BUSINESS_TYPE_RESTAURANT)
		return SendErrorMessage(playerid, "You aren't in an restaurant.");
		
    if(sscanf(params, "s[60]S()[60]", a_str, b_str))
	{
		SendUsageMessage(playerid, "/buyfood [food] [amount]");
		SendClientMessage(playerid, COLOR_GRAD2, "Pizza:$25(Health +25), Steak:$75(Health +75), Hotdog:$10(Health +10), Candy:$5(Health +5)");
		return 1;
	}
	if(!strcmp(a_str, "pizza"))
	{
		if(sscanf(b_str, "i", amount))
			return SendUsageMessage(playerid, "/buyfood pizza [amount]");

		if(amount < 1 || amount > 10)
			return SendErrorMessage(playerid, "Invalid amount (Max 10).");

		totalPrice = amount * 25;
		if(totalPrice > PlayerInfo[playerid][pMoney]) return SendErrorMessage(playerid, "You don't have enough money to buy this");
		format(str, sizeof(str), "You've purchased %i pizza('s) for $%s", amount, MoneyFormat(totalPrice));
		SCM(playerid, COLOR_GRAD1, str);
		GiveMoney(playerid, -totalPrice);
		SetPlayerHealth(playerid, playerHealth +totalPrice);
		ApplyPlayerAnimation(playerid, "FOOD", "EAT_PIZZA", 4.0, 0, 0, 0, 0, 0, 1);
	}
	if(!strcmp(a_str, "steak"))
	{
		if(sscanf(b_str, "i", amount))
			return SendUsageMessage(playerid, "/buyfood steak [amount]");

		if(amount < 1 || amount > 5)
			return SendErrorMessage(playerid, "Invalid amount (Max 5).");

		totalPrice = amount * 75;
        if(totalPrice > PlayerInfo[playerid][pMoney]) return SendErrorMessage(playerid, "You don't have enough money to buy this");
		format(str, sizeof(str), "You've purchased %i steak('s) for $%s", amount, MoneyFormat(totalPrice));
		SCM(playerid, COLOR_GRAD1, str);
		GiveMoney(playerid, -totalPrice);
		SetPlayerHealth(playerid, playerHealth +totalPrice);
		ApplyPlayerAnimation(playerid, "FOOD", "EAT_PIZZA", 4.0, 0, 0, 0, 0, 0, 1);
	}
    if(!strcmp(a_str, "hotdog"))
	{
		if(sscanf(b_str, "i", amount))
			return SendUsageMessage(playerid, "/buyfood hotdog [amount]");

		if(amount < 1 || amount > 10)
			return SendErrorMessage(playerid, "Invalid amount (Max 10).");

		totalPrice = amount * 10;
        if(totalPrice > PlayerInfo[playerid][pMoney]) return SendErrorMessage(playerid, "You don't have enough money to buy this");
		format(str, sizeof(str), "You've purchased %i hotdog('s) for $%s", amount, MoneyFormat(totalPrice));
		SCM(playerid, COLOR_GRAD1, str);
		GiveMoney(playerid, -totalPrice);
		SetPlayerHealth(playerid, playerHealth +totalPrice);
		ApplyPlayerAnimation(playerid, "FOOD", "EAT_PIZZA", 4.0, 0, 0, 0, 0, 0, 1);
	}
    if(!strcmp(a_str, "candy"))
	{
		if(sscanf(b_str, "i", amount))
			return SendUsageMessage(playerid, "/buyfood candy [amount]");

		if(amount < 1 || amount > 10)
			return SendErrorMessage(playerid, "Invalid amount (Max 10).");

		totalPrice = amount * 5;
        if(totalPrice > PlayerInfo[playerid][pMoney]) return SendErrorMessage(playerid, "You don't have enough money to buy this");
		format(str, sizeof(str), "You've purchased %i candy('s) for $%s", amount, MoneyFormat(totalPrice));
		SCM(playerid, COLOR_GRAD1, str);
		GiveMoney(playerid, -totalPrice);
		SetPlayerHealth(playerid, playerHealth +totalPrice);
		ApplyPlayerAnimation(playerid, "FOOD", "EAT_PIZZA", 4.0, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

CMD:work(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] == 0)
		return SendErrorMessage(playerid, "You dont have a job");
		
    if(PlayerInfo[playerid][pWorking] == 1)
		return SendErrorMessage(playerid, "You're already working");
		
    if(PlayerInfo[playerid][pJob] == 2)
    {
        if(IsPlayerInRangeOfPoint(playerid, 20.0, 2508.8284,-2119.4658,13.5469))
        {
        	SCM(playerid, COLOR_CUBEG, "You're now working as a Mechanic");
			SetPlayerColor(playerid, COLOR_CUBEG);
    		PlayerInfo[playerid][pWorking] = 1;
		}
		else return SendErrorMessage(playerid, "You're not at the Mechanic site");
	}
	if(PlayerInfo[playerid][pJob] == 3)
    {
        if(IsPlayerInRangeOfPoint(playerid, 20.0, -1406.4631, 2643.7144, 54.6765))
        {
        	SCM(playerid, COLOR_YELLOW, "You're now working as a Taxi Driver");
			SetPlayerColor(playerid, COLOR_YELLOW);
    		PlayerInfo[playerid][pWorking] = 1;
		}
		else return SendErrorMessage(playerid, "You're not at the Taxi depot");
	}
	return 1;
}

CMD:stopwork(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] == 0)
		return SendErrorMessage(playerid, "You dont have a job");
		
    if(PlayerInfo[playerid][pWorking] == 0)
		return SendErrorMessage(playerid, "You're not working");

    SetPlayerColor(playerid, COLOR_WHITE);
    PlayerInfo[playerid][pWorking] = 0;
    SCM(playerid, COLOR_GRAD1, "You've stopped working and won't receive any calls anymore.");
	return 1;
}

CMD:truckingjob(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new trailerid = GetVehicleModel(GetVehicleTrailer(vehicleid));
	
    if(PlayerInfo[playerid][pJob] == 0)
		return SendErrorMessage(playerid, "You dont have a job");
		
    if(PlayerInfo[playerid][pWorking] == 1)
		return SendErrorMessage(playerid, "You're already working");
		
 	if(PlayerInfo[playerid][pJob] != 4)
		return SendErrorMessage(playerid, "You're not a trucker");

	if(!IsPlayerInTruckingVehicle(playerid))
		return SendErrorMessage(playerid, "You aren't in a trucking vehicle.");
		
    if(IsTrailerAttachedToVehicle(vehicleid))
    {
    	if(trailerid == 450) //Artic
    	{
    	    new job = randomEx(1,5);
    	    SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* The trucks PDA would show a location along with a new message *");
    		PlayerInfo[playerid][pWorking] = 1;
    		if(job == 1)
    	    {
    	    	SetPlayerCheckpoint(playerid, -2245.7339,2372.5742,4.5694, 5);
    	    	SendClientMessage(playerid, COLOR_TRUCK, "_________________Tierra Robada Trucking Co._________________");
				SendClientMessage(playerid, COLOR_WHITE, "Description: You're picking up Fish from the bayside docks.");
				SendClientMessage(playerid, COLOR_WHITE, "Goods: Fish");
				truckcp[playerid] = 1;
				PlayerInfo[playerid][pWorking] =1;
    	    }
    	    if(job == 2)
    	    {
    	    	SetPlayerCheckpoint(playerid, -790.0087,1436.9532,13.3598, 5);
    	    	SendClientMessage(playerid, COLOR_TRUCK, "_________________Tierra Robada Trucking Co._________________");
				SendClientMessage(playerid, COLOR_WHITE, "Description: You're picking up ditry clothes from the Las Barrancas Tents.");
				SendClientMessage(playerid, COLOR_WHITE, "Goods: Clothes");
				truckcp[playerid] = 2;
				PlayerInfo[playerid][pWorking] =1;
    	    }
    	    if(job == 3)
    	    {
    	    	SetPlayerCheckpoint(playerid, -1486.1328,1999.2722,46.9672, 5);
    	    	SendClientMessage(playerid, COLOR_TRUCK, "_________________Tierra Robada Trucking Co._________________");
				SendClientMessage(playerid, COLOR_WHITE, "Description: You're picking up vehicle parts from the Tierra Robada Mechanic site.");
				SendClientMessage(playerid, COLOR_WHITE, "Goods: vehicle parts");
				truckcp[playerid] = 3;
				PlayerInfo[playerid][pWorking] =1;
    	    }
    	    if(job == 4)
    	    {
    	    	SetPlayerCheckpoint(playerid, -1524.7013,2570.6042,55.4067, 5);
    	    	SendClientMessage(playerid, COLOR_TRUCK, "_________________Tierra Robada Trucking Co._________________");
				SendClientMessage(playerid, COLOR_WHITE, "Description: You're picking up leftover goods from El Quebrados shops.");
				SendClientMessage(playerid, COLOR_WHITE, "Goods: Shop Goods");
				truckcp[playerid] = 4;
				PlayerInfo[playerid][pWorking] =1;
    	    }
    	}
    	if(trailerid == 584) //Petrol
    	{
    			SetPlayerCheckpoint(playerid, 255.2025,1420.7549,11.1406, 5);
    	    	SendClientMessage(playerid, COLOR_TRUCK, "_________________Tierra Robada Trucking Co._________________");
				SendClientMessage(playerid, COLOR_WHITE, "Description: You're picking up fuel to provide Tierra Robade with fuel.");
				SendClientMessage(playerid, COLOR_WHITE, "Goods: Fuel");
				truckcp[playerid] = 5;
				PlayerInfo[playerid][pWorking] =1;
    	}
	}
	else return SendErrorMessage(playerid, "You dont have a trailer attached");
	return 1;
}

CMD:stoptrucking(playerid, params[])
{
	if(PlayerInfo[playerid][pJob] == 0)
		return SCM(playerid, COLOR_RED, "You don't have a job");

	if(PlayerInfo[playerid][pWorking] == 0)
		return SendErrorMessage(playerid, "You're not working.");

	SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s their phone starts to ring.", ReturnName(playerid, 0));
	SCM(playerid, COLOR_WHITE, "Boss: You're just stopping like this? I'm taking this out of your paycheck.");
	GiveMoney(playerid, -100);
    DisablePlayerCheckpoint(playerid);
    truckcp[playerid] = 0;
    PlayerInfo[playerid][pWorking] = 0;
	return 1;
}

CMD:detach(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    
    if(!IsPlayerInAnyVehicle(playerid))
		return SendErrorMessage(playerid, "You aren't in any vehicle.");
    
    if(!IsTrailerAttachedToVehicle(vehicleid))
        return SendErrorMessage(playerid, "You dont have a trailer attached");
    
    if(IsTrailerAttachedToVehicle(vehicleid))
    {
        DetachTrailerFromVehicle(vehicleid);
	}
	return 1;
}

// Robbing //
CMD:blowdoor(playerid, params[])
{
	new bid = PlayerInfo[playerid][pInsideBusiness];
	if(BusinessInfo[bid][eRobbed] == 1)
        return SendErrorMessage(playerid, "This location has been robbed not too long ago. Please wait");
        
    if(!IsAFireArm(playerid))
	{
	    if(GetPlayerWeapon(playerid) == 0)
			return SendErrorMessage(playerid, "You must be holding a weapon in order to rob a bank");
		SendErrorMessage(playerid, "The clerks wont be intimidated by you with this weapon.");
		return 1;
	}
	
	if(FactionOnDuty[1] < 2)
        return SendErrorMessage(playerid, "There are no enough police officers on Duty.");

	if(IsPlayerInRangeOfPoint(playerid, 1.0, -2487.6033,3477.4148,2004.6260))
	{
	    if(bankdoor_status == 1)
	        return SendErrorMessage(playerid, "There is no door here to blow up");
	        
	    if(PlayerInfo[playerid][pExplosives] <= 0)
	    	return SendErrorMessage(playerid, "You need explosives in order to do this");

        PlayerInfo[playerid][pExplosives] -= 1;
        doorbomb1 = CreateDynamicObject(363, -2486.84351, 3477.07324, 2004.93872,   0.00000, 0.00000, -176.04007);
        doorbombstats1 = 1;
        SetTimerEx("BombTimer", 15000, false, "ii", playerid, bid);
        ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0,1);

        ApplyActorAnimation(bankworker1,"ped","handsup",4.1,0,0,0,1,5000);
		ApplyActorAnimation(bankworker2,"ped","handsup",4.1,0,0,0,1,5000);
		ApplyActorAnimation(bankworker3,"ped","handsup",4.1,0,0,0,1,5000);
	}
	else if(IsPlayerInRangeOfPoint(playerid, 1.0, -2480.9412,3473.1184,2004.6260))
	{
	    if(bankdoor2_status == 1)
	        return SendErrorMessage(playerid, "There is no door here to blow up");

        if(PlayerInfo[playerid][pExplosives] <= 0)
	    	return SendErrorMessage(playerid, "You need explosives in order to do this");
	    	
        PlayerInfo[playerid][pExplosives] -= 1;
        doorbomb2 = CreateDynamicObject(363, -2481.24463, 3473.52148, 2004.93872,   0.00000, 0.00000, 90.00000);
        doorbombstats2 = 1;
        SetTimerEx("BombTimer", 15000, false, "ii", playerid, bid);
        ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0,1);
        
        ApplyActorAnimation(bankworker1,"ped","handsup",4.1,0,0,0,1,5000);
		ApplyActorAnimation(bankworker2,"ped","handsup",4.1,0,0,0,1,5000);
		ApplyActorAnimation(bankworker3,"ped","handsup",4.1,0,0,0,1,5000);
	}
	else SendErrorMessage(playerid, "You're not at a door you can blowup");
	return 1;
}

CMD:robbank(playerid, params[])
{
	new bid = PlayerInfo[playerid][pInsideBusiness];
	if(BusinessInfo[bid][eRobbed] == 1)
        return SendErrorMessage(playerid, "This location has been robbed not too long ago. Please wait");
        
	if(!IsAFireArm(playerid))
	{
	    if(GetPlayerWeapon(playerid) == 0)
			return SendErrorMessage(playerid, "You must be holding a weapon in order to rob a bank");
		SendErrorMessage(playerid, "The clerks wont be intimidated by you with this weapon.");
		return 1;
	}
        
    if(FactionOnDuty[1] < 2)
        return SendErrorMessage(playerid, "There are no enough police officers on Duty.");
        
	if(bid != 7)
		return SendErrorMessage(playerid, "You're not inside the Bayside bank");
        
    SendPoliceMessage(COLOR_COP, "** Bayside Bank: Bayside bank's silent alarm went off. All units respond! **");
    new rand = random(4);
    
    ChanceRobbedTimer[playerid] = SetTimerEx("chancerobbedtimer", 15000, false, "iii", playerid, rand, bid);
    PlayerInfo[playerid][pRobbing] = 1;
    PlayerInfo[playerid][pRobTime] = 15;
    BusinessInfo[bid][eRobbed] = 1;
    RobAgainTime[bid] = SetTimerEx("robagaintime", 3600000, false, "ii", playerid, bid);
    EmptyIntTimer[bid] = SetTimerEx("emptyinttimer", 1000, true, "ii", playerid, bid);
    RobCheatTimer[playerid] = SetTimerEx("BankCheatRobTimer", 1000, true, "ii", playerid, bid);
	SCM(playerid, COLOR_RED, "You're attempting to Rob the Bayside bank wait 15 seconds");
	ArmedRobbery[playerid] = 1;
	
	return 1;
}

CMD:loadcash(playerid, params[])
{
    new bid = PlayerInfo[playerid][pInsideBusiness];
    
    if(BusinessInfo[bid][eRobbed] == 1 && ArmedRobbery[playerid] != 1)
        return SendErrorMessage(playerid, "This location has been robbed not too long ago. Please wait");
        
    for(new i = 1; i < MAX_BUSINESS; i++)
	if(IsPlayerInRangeOfPoint(playerid, 1.0, BusinessInfo[i][eBusinessBankPickupLoc][0], BusinessInfo[i][eBusinessBankPickupLoc][1], BusinessInfo[i][eBusinessBankPickupLoc][2]))
	{
	    if(ArmedRobbery[playerid] == 0){EmptyIntTimer[bid] = SetTimerEx("emptyinttimer", 1000, true, "ii", playerid, bid); RobCheatTimer[playerid] = SetTimerEx("BankCheatRobTimer", 1000, true, "ii", playerid, bid);}
		ApplyPlayerAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0,1);
		RobTimer[playerid] = SetTimerEx("BankRobTimer", 30000, false, "i", playerid);
		BusinessInfo[i][eRobbed] = 1;
		ArmedRobbery[playerid] = 0;
		PlayerInfo[playerid][pRobbing] = 1;
		PlayerInfo[playerid][pRobTime] = 30;
		return 1;
	}
	SendServerMessage(playerid, "You aren't near a location where you can load cash.");
	return 1;
}

CMD:resetbiz(playerid, params[])
{
	new bid;
	
    if(PlayerInfo[playerid][pAdmin] < 3)
		return SendUnauthMessage(playerid);
		
    if(sscanf(params, "i", bid)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /resetbiz [ID].");
    IntCheck[bid] = 0;
    BusinessInfo[bid][eRobbed] = 0;
    KillTimer(EmptyBizTimer[bid]);
    KillTimer(EmptyIntTimer[bid]);
    KillTimer(BizOpenAgainTimer[bid]);
    BellTimerQuit[bid] = 30;
    BizOpenAgainTimer[bid] = SetTimerEx("bizopenagaintimer", 1, false, "ii", playerid, bid);
    
	if(bid == 7)
	return SCM(playerid, COLOR_YELLOW, "You've resetted the Bayside Bank");
	return 1;
}

CMD:inv(playerid, params[])
{
	new primary_str[1024],
	sub_str[1024],
	name[64],
	weaponname[100]
	;
	if(PlayerInfo[playerid][pMoney] > 0)
	{
	    format(sub_str, sizeof(sub_str), "{145F0B}Cash:{FFFFFF} $%i,-\n", PlayerInfo[playerid][pMoney]);
	    strcat(primary_str, sub_str);
	}
	if(PlayerInfo[playerid][pHasMask] == true)
	{
	    format(sub_str, sizeof(sub_str), "{FFFFFF}Mask,\n");
	    strcat(primary_str, sub_str);
	}
	if(PlayerInfo[playerid][pHasRadio] == true)
	{
	    format(sub_str, sizeof(sub_str), "{FFFFFF}Radio,\n");
	    strcat(primary_str, sub_str);
	}
	if(PlayerInfo[playerid][pFishingRod] > 0)
	{
	    format(sub_str, sizeof(sub_str), "{FFFFFF}Fishing Rod,\n");
	    strcat(primary_str, sub_str);
	}
	if(PlayerInfo[playerid][pGascan] > 0)
	{
	    format(sub_str, sizeof(sub_str), "{FFFFFF}Gas Can: %i,\n", PlayerInfo[playerid][pGascan]);
	    strcat(primary_str, sub_str);
	}
	if(PlayerInfo[playerid][pWorms] > 0)
	{
	    format(sub_str, sizeof(sub_str), "{FFFFFF}Worms: %i,\n", PlayerInfo[playerid][pWorms]);
	    strcat(primary_str, sub_str);
	}
	if(PlayerInfo[playerid][pFishes] > 0)
	{
	    format(sub_str, sizeof(sub_str), "{FFFFFF}Fish: %i (g),\n", PlayerInfo[playerid][pFishes]);
	    strcat(primary_str, sub_str);
	}
	if(PlayerInfo[playerid][pExplosives] > 0)
	{
	    format(sub_str, sizeof(sub_str), "{F81414}Explosives{FFFFFF}: %i,\n", PlayerInfo[playerid][pExplosives]);
	    strcat(primary_str, sub_str);
	}
 	format(sub_str, sizeof(sub_str), "{C3C3C3}\n________Weapons:________\n");
	strcat(primary_str, sub_str);
	for(new i = 0; i < 12; i++)
	{
		if(PlayerInfo[playerid][pWeapons][i] > 0)
		{
			GetWeaponName(PlayerInfo[playerid][pWeapons][i], weaponname, sizeof(weaponname));
			format(sub_str, sizeof(sub_str), "{FFFFFF}%s,\t[Ammo: %i]\n", weaponname, PlayerInfo[playerid][pWeaponsAmmo][i]);
			strcat(primary_str, sub_str);
		}
	}
	format(name, sizeof(name), "{FFFFFF}%s's Inventory:", ReturnName(playerid));
	ShowPlayerDialog(playerid, DIALOG_DEFAULT, DIALOG_STYLE_MSGBOX, name, primary_str, "Close", "");
	return 1;
}

CMD:frisk(playerid, params[])
{
    new playerb,
	Float:x,
	Float:y,
	Float:z,
	primary_str[1024],
	sub_str[1024],
	name[64],
	weaponname[100]
	;
    if(FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE)
		return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You can't use this command.");
		
    if(sscanf(params, "u", playerb)) return SendClientMessage(playerid, COLOR_GREY, "[Usage:] /frisk [ID].");
    
   	if(playerb == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_LIGHTRED, "That player is not connected.");
   	GetPlayerPos(playerb, x, y, z);
    if(IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z))
	{
    	if(PlayerInfo[playerb][pMoney] > 0)
		{
	    	format(sub_str, sizeof(sub_str), "{145F0B}Cash:{FFFFFF} $%i,-\n", PlayerInfo[playerb][pMoney]);
	    	strcat(primary_str, sub_str);
		}
		if(PlayerInfo[playerb][pHasMask] == true)
		{
	    	format(sub_str, sizeof(sub_str), "{FFFFFF}Mask,\n");
	    	strcat(primary_str, sub_str);
		}
		if(PlayerInfo[playerb][pHasRadio] == true)
		{
	    	format(sub_str, sizeof(sub_str), "{FFFFFF}Radio,\n");
	    	strcat(primary_str, sub_str);
		}
		if(PlayerInfo[playerb][pFishingRod] > 0)
		{
	    	format(sub_str, sizeof(sub_str), "{FFFFFF}Fishing Rod,\n");
	    	strcat(primary_str, sub_str);
		}
		if(PlayerInfo[playerb][pGascan] > 0)
		{
	    	format(sub_str, sizeof(sub_str), "{FFFFFF}Gas Can: %i,\n", PlayerInfo[playerb][pGascan]);
	    	strcat(primary_str, sub_str);
		}
		if(PlayerInfo[playerb][pWorms] > 0)
		{
	    	format(sub_str, sizeof(sub_str), "{FFFFFF}Worms: %i,\n", PlayerInfo[playerb][pWorms]);
	    	strcat(primary_str, sub_str);
		}
		if(PlayerInfo[playerb][pFishes] > 0)
		{
	    	format(sub_str, sizeof(sub_str), "{FFFFFF}Fish: %i (g),\n", PlayerInfo[playerb][pFishes]);
	    	strcat(primary_str, sub_str);
		}
		if(PlayerInfo[playerb][pExplosives] > 0)
		{
	    	format(sub_str, sizeof(sub_str), "{F81414}Explosives{FFFFFF}: %i,\n{A9C4E4}", PlayerInfo[playerb][pExplosives]);
	    	strcat(primary_str, sub_str);
		}
		format(sub_str, sizeof(sub_str), "{C3C3C3}\n________Weapons:________\n");
		strcat(primary_str, sub_str);
		for(new i = 0; i < 12; i++)
		{
			if(PlayerInfo[playerb][pWeapons][i] > 0)
			{
				GetWeaponName(PlayerInfo[playerb][pWeapons][i], weaponname, sizeof(weaponname));
				format(sub_str, sizeof(sub_str), "{FFFFFF}%s,\t[Ammo: %i]\n", weaponname, PlayerInfo[playerb][pWeaponsAmmo][i]);
				strcat(primary_str, sub_str);
			}
		}
		format(name, sizeof(name), "{FFFFFF}%s's Inventory:", ReturnName(playerb));
		ShowPlayerDialog(playerid, DIALOG_DEFAULT, DIALOG_STYLE_MSGBOX, name, primary_str, "Close", "");
		SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s frisks %s *",ReturnName(playerid), ReturnName(playerb));
		SCMex(playerb, COLOR_YELLOW, "You've been frisked by: %s", ReturnName(playerid));
	}
	return 1;
}

CMD:cpc(playerid, params[])
{
    for(new q = 0; q < 50; q++)
	{
		SendClientMessage(playerid, COLOR_WHITE, "");
	}
	return 1;
}

// END OF COMMANDS //

//Local functions:

function:LocalChat(playerid, Float:radi, string[], color1, color2, color3, color4)
{

    //if(PlayerInfo[playerid][pAdmin] < 2)
			//return SendUnauthMessage(playerid);
	if (e_pAccountData[playerid][mLoggedin] == false)
		return 0;

	new
		Float:currentPos[3],
		Float:oldPos[3],
		Float:checkPos[3]
	;

	GetPlayerPos(playerid, oldPos[0], oldPos[1], oldPos[2]);
	foreach (new i : Player)
	{
		if (PlayerInfo[playerid][pLoggedin] == false) continue;

		GetPlayerPos(i, currentPos[0], currentPos[1], currentPos[2]);
		for (new p = 0; p < 3; p++)
		{
			checkPos[p] = (oldPos[p] - currentPos[p]);
		}

		if (GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid))
			continue;

		if (((checkPos[0] < radi/16) && (checkPos[0] > -radi/16)) && ((checkPos[1] < radi/16) && (checkPos[1] > -radi/16)) && ((checkPos[2] < radi/16) && (checkPos[2] > -radi/16)))
		{
			SendClientMessage(i, color1, string);
		}
		else if (((checkPos[0] < radi/8) && (checkPos[0] > -radi/8)) && ((checkPos[1] < radi/8) && (checkPos[1] > -radi/8)) && ((checkPos[2] < radi/8) && (checkPos[2] > -radi/8)))
		{
			SendClientMessage(i, color2, string);
		}
		else if (((checkPos[0] < radi/4) && (checkPos[0] > -radi/4)) && ((checkPos[1] < radi/4) && (checkPos[1] > -radi/4)) && ((checkPos[2] < radi/4) && (checkPos[2] > -radi/4)))
		{
			SendClientMessage(i, color3, string);
		}
		else if (((checkPos[0] < radi/2) && (checkPos[0] > -radi/2)) && ((checkPos[1] < radi/2) && (checkPos[1] > -radi/2)) && ((checkPos[2] < radi/2) && (checkPos[2] > -radi/2)))
		{
			SendClientMessage(i, color4, string);
		}
	}
	return 1;
}

function:OnPlayerReport(playerid, reportid, const text[])
{
	if(ReportInfo[reportid][rReportExists] == true)
	{
		for (new i = 1; i < sizeof(ReportInfo); i ++)
		{
			if(ReportInfo[i][rReportExists] == false)
			{
				reportid = i;
				break;
			}
		}
	}

	ReportInfo[reportid][rReportExists] = true;
	ReportInfo[reportid][rReportTime] = gettime();

	format(ReportInfo[reportid][rReportDetails], 90, "%s", text);
	ReportInfo[reportid][rReportBy] = playerid;

	SendServerMessage(playerid, "Your report was sent to all online admins.");

	if(strlen(text) > 67)
	{
		SendAdminMessageEx(COLOR_REPORT, 1, "[Report: %d] %s (%d): %.75s", reportid, ReturnName(playerid), playerid, text);
		SendAdminMessageEx(COLOR_REPORT, 1, "[Report: %d] ...%s", reportid, text[75]);
	}
	else SendAdminMessageEx(COLOR_REPORT, 1, "[Report: %d] %s (%d): %s", reportid, ReturnName(playerid), playerid, text);

	if(strfind(text, "hack", true) != -1 || strfind(text, "cheat", true) != -1)
	{
		foreach(new i : Player)
		{
			if(PlayerInfo[i][pAdmin]) GameTextForPlayer(i, "~y~~h~Priority Report", 4000, 1);
		}
	}
	return 1;
}

function:ClearReports(playerid, response, reports)
{
	if(response)
	{
		for (new i = 0; i < sizeof(ReportInfo); i ++)
		{
			ReportInfo[i][rReportExists] = false;
			ReportInfo[i][rReportDetails] = ' ';
			ReportInfo[i][rReportBy] = INVALID_PLAYER_ID;
			ReportInfo[i][rReportTime] = 0;
		}

		new str[128];

		format(str, sizeof(str), "%s cleared %d active reports.", ReturnName(playerid), reports);
		SendAdminMessage(1, str);
	}
	else return SendServerMessage(playerid, "You cancelled the confirmation.");
	return 1;
}

function:OnSetFaction(playerid, response, playerb, factionid)
{
	if(response)
	{
		PlayerInfo[playerb][pFaction] = factionid;
		PlayerInfo[playerb][pFactionRank] = FactionInfo[factionid][eFactionJoinRank];

		new str[128];

		format(str, sizeof(str), "%s set %s's faction to %d.", ReturnName(playerid), ReturnName(playerb), factionid);
		SendAdminMessage(4, str);

		SendServerMessage(playerb, "You were set to faction %d by Admin %s.", factionid, ReturnName(playerid));

		SaveCharacter(playerb);
	}
	else return SendServerMessage(playerid, "You disregarded the faction set.");
	return 1;
}

function:OnVehicleScrap(playerid, response, dbid, cash_back, vehicleid)
{
	if(response)
	{
		if(!IsPlayerInAnyVehicle(playerid))
			return SendErrorMessage(playerid, "You're no longer in a vehicle. This was aborted.");

		new delQuery[128];

		mysql_format(ourConnection, delQuery, sizeof(delQuery), "DELETE FROM vehicles WHERE VehicleDBID = %i", dbid);
		mysql_tquery(ourConnection, delQuery);

		SendServerMessage(playerid, "Your %s has been permanently deleted.", ReturnVehicleName(GetPlayerVehicleID(playerid)));
		SendServerMessage(playerid, "You earned $%s from scrapping it.", MoneyFormat(cash_back));

		GiveMoney(playerid, cash_back);

		ResetVehicleVars(GetPlayerVehicleID(playerid));
		DestroyVehicle(GetPlayerVehicleID(playerid));

		for(new i = 1; i < MAX_PLAYER_VEHICLES; i++)
		{
			if(PlayerInfo[playerid][pOwnedVehicles][i] == dbid)
			{
				PlayerInfo[playerid][pOwnedVehicles][i] = 0;
			}
		}
	}
	else return SendServerMessage(playerid, "This action was aborted.");
	return 1;
}

function:OnVehicleaScrap(playerid, response, dbid, vehicleid)
{
	if(response)
	{
		if(!IsPlayerInAnyVehicle(playerid))
			return SendErrorMessage(playerid, "You're no longer in a vehicle. This was aborted.");

		new delQuery[128];

		mysql_format(ourConnection, delQuery, sizeof(delQuery), "DELETE FROM vehicles WHERE VehicleDBID = %i", dbid);
		mysql_tquery(ourConnection, delQuery);

		ResetVehicleVars(GetPlayerVehicleID(playerid));
		DestroyVehicle(GetPlayerVehicleID(playerid));

		for(new i = 1; i < MAX_PLAYER_VEHICLES; i++)
		{
			if(PlayerInfo[playerid][pOwnedVehicles][i] == dbid)
			{
				PlayerInfo[playerid][pOwnedVehicles][i] = 0;
			}
		}
	}
	else return SendServerMessage(playerid, "This action was aborted.");
	return 1;
}

function:OnVehicleTow(playerid)
{
	new vehicleid = PlayerInfo[playerid][pOwnedVehicles], newDisplay[128];

	if(IsVehicleOccupied(vehicleid))
	{
		KillTimer(playerTowTimer[playerid]);
		SendServerMessage(playerid, "Your vehicle tow was interrupted.");

		playerTowingVehicle[playerid] = false;
		Delete3DTextLabel(VehicleInfo[vehicleid][eVehicleTowDisplay]);

		VehicleInfo[vehicleid][eVehicleTowCount] = 0;
		return 1;
	}

	VehicleInfo[vehicleid][eVehicleTowCount]++;

	if(VehicleInfo[vehicleid][eVehicleTowCount] == 1) newDisplay = "(( || ))\nTOWING VEHICLE";
	if(VehicleInfo[vehicleid][eVehicleTowCount] == 2) newDisplay = "(( ||| ))\nTOWING VEHICLE";
	if(VehicleInfo[vehicleid][eVehicleTowCount] == 3) newDisplay = "(( |||| ))\nTOWING VEHICLE";
	if(VehicleInfo[vehicleid][eVehicleTowCount] == 4) newDisplay = "(( ||||| ))\nTOWING VEHICLE";
	if(VehicleInfo[vehicleid][eVehicleTowCount] == 5) newDisplay = "(( |||||| ))\nTOWING VEHICLE";
	if(VehicleInfo[vehicleid][eVehicleTowCount] == 6) newDisplay = "(( ||||||| ))\nTOWING VEHICLE";
	if(VehicleInfo[vehicleid][eVehicleTowCount] == 7) newDisplay = "(( |||||||| ))\nTOWING VEHICLE";
	if(VehicleInfo[vehicleid][eVehicleTowCount] == 8) newDisplay = "(( |||||||| ))\nTOWING VEHICLE";

	Update3DTextLabelText(VehicleInfo[vehicleid][eVehicleTowDisplay], COLOR_DARKGREEN, newDisplay);

	if(VehicleInfo[vehicleid][eVehicleTowCount] == 9)
	{
		SendServerMessage(playerid, "Your vehicle has been towed.");
		GiveMoney(playerid, -2000);

		playerTowingVehicle[playerid] = false;
		SetVehicleToRespawn(vehicleid);

		Delete3DTextLabel(VehicleInfo[vehicleid][eVehicleTowDisplay]);
		KillTimer(playerTowTimer[playerid]);

		VehicleInfo[vehicleid][eVehicleTowCount] = 0;
		return 1;
	}

	return 1;
}

function:OnGascanRefill(playerid, vehicleid, x, y, z)
{
	new
		text[128]
	;
	if(GetVehicleDistanceFromPoint(vehicleid, x, y, z) > 3)
	{
		SendClientMessage(playerid, COLOR_ACTION, "The vehicle you were refilling moved and canceled.");

		KillTimer(playerRefillTimer[playerid]);
		playerRefillingVehicle[playerid] = false;

		Delete3DTextLabel(VehicleInfo[vehicleid][eVehicleRefillDisplay]);
		VehicleInfo[vehicleid][eVehicleRefillCount] = 0;
		return 1;
	}

	if(!IsPlayerInRangeOfPoint(playerid, 1.0, PlayerInfo[playerid][pLastPos][0], PlayerInfo[playerid][pLastPos][1], PlayerInfo[playerid][pLastPos][2]))
	{
		SendClientMessage(playerid, COLOR_ACTION, "You moved and stopped refilling the vehicle.");

		KillTimer(playerRefillTimer[playerid]);
		playerRefillingVehicle[playerid] = false;

		Delete3DTextLabel(VehicleInfo[vehicleid][eVehicleRefillDisplay]);
		VehicleInfo[vehicleid][eVehicleRefillCount] = 0;
		return 1;
	}

	VehicleInfo[vehicleid][eVehicleRefillCount] ++;

	switch(VehicleInfo[vehicleid][eVehicleRefillCount])
	{
		case 2: text = "(( ||----- ))\nREFILLING VEHICLE";
		case 3: text = "(( |||---- ))\nREFILLING VEHICLE";
		case 4: text = "(( ||||--- ))\nREFILLING VEHICLE";
		case 5: text = "(( |||||-- ))\nREFILLING VEHICLE";
		case 6: text = "(( ||||||- ))\nREFILLING VEHICLE";
		case 7: text = "(( ||||||| ))\nREFILLING VEHICLE";
		case 8:
		{
			KillTimer(playerRefillTimer[playerid]);
			playerRefillingVehicle[playerid] = false;

			Delete3DTextLabel(VehicleInfo[vehicleid][eVehicleRefillDisplay]);
			VehicleInfo[vehicleid][eVehicleRefillCount] = 0;

			VehicleInfo[vehicleid][eVehicleFuel] = 50;

			SendClientMessageEx(playerid, COLOR_ACTION, "You refilled the %s to 50 percent fuel.", ReturnVehicleName(vehicleid));
			SendNearbyMessage(playerid, 20.0, COLOR_EMOTE, "* %s refilled the %s with their gas can.", ReturnName(playerid, 0), ReturnVehicleName(vehicleid));
			return 1;
		}
	}

	Update3DTextLabelText(VehicleInfo[vehicleid][eVehicleRefillDisplay], COLOR_DARKGREEN, text);
	return 1;
}

function:OnPlayerRelog(playerid)
{
	new
		updateLabel[90],
		relogCheck[60]
	;

	PlayerInfo[playerid][pRelogCount] ++;

	if(PlayerInfo[playerid][pRelogCount] == 2)
		updateLabel = "(( ||----- ))\nRELOGGING";

	if(PlayerInfo[playerid][pRelogCount] == 3)
		updateLabel = "(( |||---- ))\nRELOGGING";

	if(PlayerInfo[playerid][pRelogCount] == 4)
		updateLabel = "(( ||||--- ))\nRELOGGING";

	if(PlayerInfo[playerid][pRelogCount] == 5)
		updateLabel = "(( |||||-- ))\nRELOGGING";

	if(PlayerInfo[playerid][pRelogCount] == 6)
		updateLabel = "(( ||||||- ))\nRELOGGING";

	if(PlayerInfo[playerid][pRelogCount] == 7)
		updateLabel = "(( ||||||| ))\nRELOGGING";

	Update3DTextLabelText(PlayerInfo[playerid][pRelogTD], COLOR_DARKGREEN, updateLabel);

	if(PlayerInfo[playerid][pRelogCount] == 8)
	{
		Delete3DTextLabel(PlayerInfo[playerid][pRelogTD]);
		KillTimer(PlayerInfo[playerid][pRelogTimer]);

		PlayerInfo[playerid][pRelogging] = false;
		PlayerInfo[playerid][pRelogCount] = 0;

		SaveCharacter(playerid); SaveCharacterPos(playerid);

		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);

		PlayerInfo[playerid][pLoggedin] = false;
		e_pAccountData[playerid][mLoggedin] = false;

		SetPlayerName(playerid, e_pAccountData[playerid][mAccName]);
		TogglePlayerSpectating(playerid, true); SetPlayerCamera(playerid);

		mysql_format(ourConnection, relogCheck, sizeof(relogCheck), "SELECT acc_dbid FROM masters WHERE acc_name = '%e'", ReturnName(playerid));
		mysql_tquery(ourConnection, relogCheck, "LogPlayerIn", "i", playerid);

		return 1;
	}

	return 1;
}

function:OnVehicleTextdraw(playerid)
{
	if(IsValidDynamic3DTextLabel(playerVehicleTextdraw[playerid]))
		DestroyDynamic3DTextLabel(playerVehicleTextdraw[playerid]);

	playerTextdraw[playerid] = false;
	return 1;
}

function:OnPropertyBoombox(playerid, response, propertyid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(response)
	{
		GiveMoney(playerid, -1000);

		DestroyDynamicObject(PlayerInfo[playerid][pAddObject]);
		PlayerInfo[playerid][pEditingObject] = 0;

		PropertyInfo[propertyid][ePropertyBoomboxObject] = CreateDynamicObject(2103, x, y, z, rx, ry, rz, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
		PropertyInfo[propertyid][ePropertyHasBoombox] = true;

		PropertyInfo[propertyid][ePropertyBoomboxPos][0] = x;
		PropertyInfo[propertyid][ePropertyBoomboxPos][1] = y;
		PropertyInfo[propertyid][ePropertyBoomboxPos][2] = z;

		PropertyInfo[propertyid][ePropertyBoomboxRot][0] = rx;
		PropertyInfo[propertyid][ePropertyBoomboxRot][1] = ry;
		PropertyInfo[propertyid][ePropertyBoomboxRot][2] = rz;

		SendServerMessage(playerid, "You bought a boombox for your property.");
		SaveProperty(propertyid);
	}
	else
	{
		DestroyDynamicObject(PlayerInfo[playerid][pAddObject]);
		PlayerInfo[playerid][pEditingObject] = 0;

		SendServerMessage(playerid, "You cancelled.");
	}
	return 1;
}

function:OnRemoveBoombox(playerid, response, propertyid)
{
	if(response)
	{
		DestroyDynamicObject(PropertyInfo[propertyid][ePropertyBoomboxObject]);
		PropertyInfo[propertyid][ePropertyHasBoombox] = false;

		for(new i = 0; i < 3; i++)
		{
			PropertyInfo[propertyid][ePropertyBoomboxPos][i] = 0.0;
			PropertyInfo[propertyid][ePropertyBoomboxRot][i] = 0.0;
		}

		SendServerMessage(playerid, "You removed your properties boombox.");
		SaveProperty(propertyid);
	}
	else return SendServerMessage(playerid, "You cancelled.");
	return 1;
}

function:OnBusinessInteriorChange(playerid, response, businessid)
{
	if(response)
	{
		GetPlayerPos(playerid, BusinessInfo[businessid][eBusinessInterior][0], BusinessInfo[businessid][eBusinessInterior][1], BusinessInfo[businessid][eBusinessInterior][2]);

		new
			world = random(20000)+playerid+2;

		BusinessInfo[businessid][eBusinessInteriorIntID] = GetPlayerInterior(playerid);
		BusinessInfo[businessid][eBusinessInteriorWorld] = world;

		SendServerMessage(playerid, "You changed Business %i's interior ID.", businessid);

		foreach(new i : Player) if(IsPlayerInBusiness(i) == businessid)
		{
			SetPlayerPos(i, BusinessInfo[businessid][eBusinessInterior][0], BusinessInfo[businessid][eBusinessInterior][1], BusinessInfo[businessid][eBusinessInterior][2]);
			SetPlayerInterior(i, GetPlayerInterior(playerid)); SetPlayerVirtualWorld(playerid, world);

			SendServerMessage(i, "The business you were in was amended.");
		}

		if(BusinessInfo[businessid][eBusinessType] == BUSINESS_TYPE_BANK)
		{
			if(IsValidDynamicPickup(BusinessInfo[businessid][eBusinessBankPickup]))
			{
				DestroyDynamicObject(BusinessInfo[businessid][eBusinessBankPickup]);
				SendServerMessage(playerid, "This businesses' bank pickup was destroyed and needs to be remade.");
			}

			for(new i = 0; i < 3; i++)
			{
				BusinessInfo[businessid][eBusinessBankPickupLoc][i] = 0.0;
			}
		}

		SaveBusiness(businessid);
	}
	else return SendServerMessage(playerid, "You cancelled.");
	return 1;
}

function:OnBusinessEntranceChange(playerid, response, businessid)
{
	if(response)
	{
		GetPlayerPos(playerid, BusinessInfo[businessid][eBusinessEntrance][0], BusinessInfo[businessid][eBusinessEntrance][1], BusinessInfo[businessid][eBusinessEntrance][2]);

		if(IsValidDynamicObject(BusinessInfo[businessid][eBusinessPickup]))
			DestroyDynamicPickup(BusinessInfo[businessid][eBusinessPickup]);

        BusinessInfo[businessid][eBusinessInteriorExtIntID] = GetPlayerInterior(playerid);
		BusinessInfo[businessid][eBusinessInteriorExtWorld] = GetPlayerVirtualWorld(playerid);

		if(BusinessInfo[businessid][eBusinessType] == BUSINESS_TYPE_RESTAURANT)
		{
			if(!BusinessInfo[businessid][eBusinessOwnerDBID])
				BusinessInfo[businessid][eBusinessPickup] = CreateDynamicPickup(1272, 1, BusinessInfo[businessid][eBusinessEntrance][0], BusinessInfo[businessid][eBusinessEntrance][1], BusinessInfo[businessid][eBusinessEntrance][2], 0);

			else BusinessInfo[businessid][eBusinessPickup] = CreateDynamicPickup(1239, 1, BusinessInfo[businessid][eBusinessEntrance][0], BusinessInfo[businessid][eBusinessEntrance][1], BusinessInfo[businessid][eBusinessEntrance][2], 0);
		}
		else BusinessInfo[businessid][eBusinessPickup] = CreateDynamicPickup(1239, 1, BusinessInfo[businessid][eBusinessEntrance][0], BusinessInfo[businessid][eBusinessEntrance][1], BusinessInfo[businessid][eBusinessEntrance][2], 0);

		SendServerMessage(playerid, "You changed Business %i's entrance.", businessid);
		SaveBusiness(businessid);
	}
	else return SendServerMessage(playerid, "You cancelled.");
	return 1;
}

function:OnBusinessBankpickupChange(playerid, response, businessid)
{
	if(response)
	{
		GetPlayerPos(playerid, BusinessInfo[businessid][eBusinessBankPickupLoc][0], BusinessInfo[businessid][eBusinessBankPickupLoc][1], BusinessInfo[businessid][eBusinessBankPickupLoc][2]);
		BusinessInfo[businessid][eBusinessBankPickupWorld] = GetPlayerVirtualWorld(playerid);

		if(IsValidDynamicPickup(BusinessInfo[businessid][eBusinessBankPickup]))
			DestroyDynamicPickup(BusinessInfo[businessid][eBusinessBankPickup]);

		BusinessInfo[businessid][eBusinessBankPickup] = CreateDynamicPickup(1274, 1, BusinessInfo[businessid][eBusinessBankPickupLoc][0], BusinessInfo[businessid][eBusinessBankPickupLoc][1], BusinessInfo[businessid][eBusinessBankPickupLoc][2], BusinessInfo[businessid][eBusinessBankPickupWorld]);

		SendServerMessage(playerid, "You changed business %i's bank point.", businessid);
		SaveBusiness(businessid);
	}
	else return SendServerMessage(playerid, "You cancelled.");
	return 1;
}

function:OnSellBusiness(playerid, response, businessid)
{
	if(response)
	{
		new
			totalPay
		;

		totalPay = BusinessInfo[businessid][eBusinessMarketPrice] / 2 + BusinessInfo[businessid][eBusinessCashbox];
		GiveMoney(playerid, totalPay);

		BusinessInfo[businessid][eBusinessOwnerDBID] = 0;

		if(BusinessInfo[businessid][eBusinessType] == BUSINESS_TYPE_RESTAURANT)
		{
			DestroyDynamicPickup(BusinessInfo[businessid][eBusinessPickup]);
			BusinessInfo[businessid][eBusinessPickup] = CreateDynamicPickup(1272, 1, BusinessInfo[businessid][eBusinessEntrance][0], BusinessInfo[businessid][eBusinessEntrance][1], BusinessInfo[businessid][eBusinessEntrance][2], 0);
		}

		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		SendClientMessageEx(playerid, COLOR_ACTION, "You sold your business and earned $%s.", MoneyFormat(totalPay));

		SaveBusiness(businessid); SaveCharacter(playerid);
	}
	else return SendServerMessage(playerid, "You cancelled.");
	return 1;
}

function:OnPlateSet(playerid)
{
	for(new i = 0; i < 2; i++)
	{
		PlayerTextDrawHide(playerid, CarBought_PTD[playerid][i]);
	}
	return 1;
}
public OnPlayerExitVehicle(playerid, vehicleid)
{
    if(SweepingJob[playerid] == 1)
    {
        SendClientMessage(playerid, COLOR_RED, "* You have left your job, you won't be payed.");
        SweepingJob[playerid] = 0;
    }
    if(PetrolJob[playerid] == 1)
    {
        SendClientMessage(playerid, COLOR_RED, "* You have left your job, you won't be payed.");
        DisablePlayerCheckpoint(playerid);
        PetrolJob[playerid] = 0;
    }
    
}
function:OnPlayerExitDealership(playerid, response)
{
	if(response)
	{
		SendServerMessage(playerid, "You exited out the dealership.");

		ResetVehicleVars(DealershipPlayerCar[playerid]);
		DestroyVehicle(DealershipPlayerCar[playerid]);

		ResetDealershipVars(playerid);
		TogglePlayerControllable(playerid, 1);
	}
	else return ShowDealerAppend(playerid);
	return 1;
}

function:OnPlayerVehiclePurchase(playerid, id, plates[], Float:x, Float:y, Float:z, Float:a)
{
	new
		vehicleid = INVALID_VEHICLE_ID
	;

	DestroyVehicle(DealershipPlayerCar[playerid]);

	vehicleid =
		CreateVehicle(g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModelID], x, y, z, a, DealershipCarColors[playerid][0], DealershipCarColors[playerid][1], -1);
    VehicleInfo[vehicleid][eVehicleID] = vehicleid;

    if(IsABoat(vehicleid))
    {
		SetVehiclePos(vehicleid, -2202.5156,2421.8928,-0.5458);
		SetVehicleZAngle(vehicleid, 1.0053);
	}

	SetVehicleNumberPlate(vehicleid, plates);
	SetVehicleToRespawn(vehicleid);

	PutPlayerInVehicle(playerid, vehicleid, 0);
 	PlayerInfo[playerid][pOwnedVehicles][id] = cache_insert_id();

	if(vehicleid != INVALID_VEHICLE_ID)
	{
		VehicleInfo[vehicleid][eVehicleDBID] = cache_insert_id();
		VehicleInfo[vehicleid][eVehicleOwnerDBID] = PlayerInfo[playerid][pDBID];

		VehicleInfo[vehicleid][eVehicleModel] = g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModelID];

		VehicleInfo[vehicleid][eVehicleColor1] = DealershipCarColors[playerid][0];
		VehicleInfo[vehicleid][eVehicleColor2] = DealershipCarColors[playerid][1];

		VehicleInfo[vehicleid][eVehiclePaintjob] = -1;

		VehicleInfo[vehicleid][eVehicleParkPos][0] = x;
		VehicleInfo[vehicleid][eVehicleParkPos][1] = y;
		VehicleInfo[vehicleid][eVehicleParkPos][2] = z;
		VehicleInfo[vehicleid][eVehicleParkPos][3] = a;

		format(VehicleInfo[vehicleid][eVehiclePlates], 32, "%s", plates);

		VehicleInfo[vehicleid][eVehicleLocked] = false;
		VehicleInfo[vehicleid][eVehicleEngineStatus] = false;

		VehicleInfo[vehicleid][eVehicleFuel] = 100;

		VehicleInfo[vehicleid][eVehicleBattery] = 100.0;
		VehicleInfo[vehicleid][eVehicleEngine] = 100.0;

		VehicleInfo[vehicleid][eVehicleHasXMR] = bool:DealershipXMR[playerid];
		VehicleInfo[vehicleid][eVehicleTimesDestroyed] = 0;

		VehicleInfo[vehicleid][eVehicleAlarmLevel] = DealershipAlarmLevel[playerid];
		VehicleInfo[vehicleid][eVehicleLockLevel] = DealershipLockLevel[playerid];
		VehicleInfo[vehicleid][eVehicleImmobLevel] = DealershipImmobLevel[playerid];
		VehicleInfo[vehicleid][eVehicleID] = vehicleid;

		for(new i = 1; i< 6; i++)
		{
			VehicleInfo[vehicleid][eVehicleWeapons][i] = 0;
			VehicleInfo[vehicleid][eVehicleWeaponsAmmo][i] = 0;
		}
	}
	SendClientMessageEx(playerid, 0xB9E35EFF, "PROCESSED: You successfully bought a %s for $%s.", ReturnVehicleName(vehicleid), MoneyFormat(DealershipTotalCost[playerid]));
	SendClientMessageEx(playerid, COLOR_RED, "Please repark your new vehicle at another location. If not reparked it'll be destroyed.");

	PlayerPurchasingVehicle[playerid] = false;
	ResetDealershipVars(playerid);
	SaveVehicle(vehicleid);
	return 1;
}

function:OnCallPaycheck(playerid, response)
{
	new
		str[128]
	;

	if(response)
	{
		format(str, sizeof(str), "%s called a paycheck.", ReturnName(playerid));
		SendAdminMessage(3, str);

		CallPaycheck();
	}
	return 1;
}

function:OnPlayerPurchaseWeapon(playerid, response, weapon, ammo, price)
{
	if(response)
	{
		if(price > PlayerInfo[playerid][pMoney])
			return SendErrorMessage(playerid, "You can't afford this. (Cost: $%s, Total: $%s)", MoneyFormat(price), MoneyFormat(PlayerInfo[playerid][pMoney]));

		new
			str[128]
		;

		GiveMoney(playerid, -price);
		GivePlayerGun(playerid, weapon, ammo);

		format(str, sizeof(str), "%s bought %s and %d Ammo", ReturnName(playerid), ReturnWeaponName(weapon), ammo);
		SendAdminMessage(1, str);
	}
	return 1;
}

function:OnPlayerPurchaseArmor(playerid, response)
{
	if(response)
	{
		if(2000 > PlayerInfo[playerid][pMoney])
			return SendErrorMessage(playerid, "You can't afford this. (Cost: $2,000, Total: $%s)", MoneyFormat(PlayerInfo[playerid][pMoney]));

		new
			str[128]
		;

		SetPlayerArmour(playerid, 50);

		format(str, sizeof(str), "%s bought Armor.", ReturnName(playerid));
		SendAdminMessage(1, str);
	}
	return 1;
}

function:OnPlayerAddCharge(playerid, playerb, charge[])
{
	SendPoliceMessage(COLOR_COP, "[WANTED] Suspect: %s Charger: %s Reason: %s", ReturnName(playerb), ReturnName(playerid), charge);
	PlayerInfo[playerb][pActiveListings]++;

	new
		query[128];

	mysql_format(ourConnection, query, sizeof(query), "UPDATE characters SET pActiveListings = %i WHERE char_dbid = %i", PlayerInfo[playerb][pActiveListings], PlayerInfo[playerb][pDBID]);
	mysql_pquery(ourConnection, query);
	return 1;
}

function:OnPlayerPurchaseAmmo(playerid, response, weaponid, ammo, price)
{
	if(response)
	{
		new
			slot,
			currammo,
			str[128]
		;

		slot = ReturnWeaponIDSlot(weaponid);
		currammo = PlayerInfo[playerid][pWeaponsAmmo][slot];

		GiveMoney(playerid, -price);
		SetPlayerAmmo(playerid, weaponid, currammo + ammo);

		format(str, sizeof(str), "%s bought %d Ammo for %s", ReturnName(playerid), ammo, ReturnWeaponName(weaponid));
		SendAdminMessage(1, str);
	}
	return 1;
}

function:Query_InsertFaction(playerid, varName, varAbbrev, idx)
{
	new insertRanks[90], str[128];

	mysql_format(ourConnection, insertRanks, sizeof(insertRanks), "INSERT INTO faction_ranks (`factionid`) VALUES(%i)", cache_insert_id());
	mysql_tquery(ourConnection, insertRanks);

	FactionInfo[idx][eFactionDBID] = cache_insert_id();

	format(FactionInfo[idx][eFactionName], 90, "%s", varName);
	format(FactionInfo[idx][eFactionAbbrev], 30, "%s", varAbbrev);

	format(str, sizeof(str), "%s has created Faction ID %d.", ReturnName(playerid), cache_insert_id());
	SendAdminMessage(4, str);

	SendServerMessage(COLOR_RED, "To configure the faction, use \"/editfaction\". ");
	return 1;
}

function:Query_InsertBusiness(playerid, newid, type)
{
	BusinessInfo[newid][eBusinessDBID] = cache_insert_id();
	BusinessInfo[newid][eBusinessType] = type;

	SendServerMessage(playerid, "You created business ID %i. To configure, use \"/editbusiness\". ", newid);
	return 1;
}

function:Query_LoadFactions()
{
	if(!cache_num_rows())
		return printf("[SERVER]: No factions were loaded from \"%s\" database...", SQL_DATABASE);

	new newThread[128], rows, fields; cache_get_data(rows, fields, ourConnection);

	for (new i = 0; i < rows && i < MAX_FACTIONS; i ++)
	{
		FactionInfo[i+1][eFactionDBID] = cache_get_field_content_int(i, "DBID", ourConnection);

		cache_get_field_content(i, "FactionName", FactionInfo[i+1][eFactionName], ourConnection, 90);
		cache_get_field_content(i, "FactionAbbrev", FactionInfo[i+1][eFactionAbbrev], ourConnection, 30);

		FactionInfo[i+1][eFactionSpawn][0] = cache_get_field_content_float(i, "FactionSpawnX", ourConnection);
		FactionInfo[i+1][eFactionSpawn][1] = cache_get_field_content_float(i, "FactionSpawnY", ourConnection);
		FactionInfo[i+1][eFactionSpawn][2] = cache_get_field_content_float(i, "FactionSpawnZ", ourConnection);

		FactionInfo[i+1][eFactionSpawnInt] = cache_get_field_content_int(i, "FactionInterior", ourConnection);
		FactionInfo[i+1][eFactionSpawnWorld] = cache_get_field_content_int(i, "FactionWorld", ourConnection);

		FactionInfo[i+1][eFactionJoinRank] = cache_get_field_content_int(i, "FactionJoinRank", ourConnection);
		FactionInfo[i+1][eFactionAlterRank] = cache_get_field_content_int(i, "FactionAlterRank", ourConnection);
		FactionInfo[i+1][eFactionChatRank] = cache_get_field_content_int(i, "FactionChatRank", ourConnection);
		FactionInfo[i+1][eFactionTowRank] = cache_get_field_content_int(i, "FactionTowRank", ourConnection);

		FactionInfo[i+1][eFactionChatColor] = cache_get_field_content_int(i, "FactionChatColor", ourConnection);

		FactionInfo[i+1][eFactionType] = cache_get_field_content_int(i, "FactionType", ourConnection);

		mysql_format(ourConnection, newThread, sizeof(newThread), "SELECT * FROM faction_ranks WHERE factionid = %i", i+1);
		mysql_tquery(ourConnection, newThread, "Query_LoadFactionRanks", "i", i+1);
	}
	printf("[SERVER]: %i factions were loaded from \"%s\" database...", rows, SQL_DATABASE);
	return 1;
}

function:Query_LoadFactionRanks(factionid)
{
	new str[128];

	new rows, fields; cache_get_data(rows, fields, ourConnection);

	for (new i = 0; i < rows; i++)
	{
		for (new j = 1; j < MAX_FACTION_RANKS; j++)
		{
			format(str, sizeof(str), "FactionRank%i", j);
			cache_get_field_content(i, str, FactionRanks[factionid][j], ourConnection, 60);
		}
	}
	return 1;
}

function:Query_LoadPrivateVehicle(playerid, slotid)
{
	if(!cache_num_rows())
		return SendErrorMessage(playerid, "An error occurred while loading your vehicle.");

	new rows, fields; cache_get_data(rows, fields, ourConnection);
	new str[128], vehicleid = INVALID_VEHICLE_ID;

	for (new i = 0; i < rows && i < MAX_VEHICLES; i++)
	{
		vehicleid = CreateVehicle(cache_get_field_content_int(i, "VehicleModel", ourConnection),
			cache_get_field_content_float(i, "VehicleParkPosX", ourConnection),
			cache_get_field_content_float(i, "VehicleParkPosY", ourConnection),
			cache_get_field_content_float(i, "VehicleParkPosZ", ourConnection),
			cache_get_field_content_float(i, "VehicleParkPosA", ourConnection),
			cache_get_field_content_int(i, "VehicleColor1", ourConnection),
			cache_get_field_content_int(i, "VehicleColor2", ourConnection),
			-1,
			0);
        VehicleInfo[vehicleid][eVehicleID] = vehicleid;

		if(vehicleid != INVALID_VEHICLE_ID)
		{
			VehicleInfo[vehicleid][eVehicleExists] = true;
			VehicleInfo[vehicleid][eVehicleDBID] = cache_get_field_content_int(i, "VehicleDBID", ourConnection);

			VehicleInfo[vehicleid][eVehicleOwnerDBID] = cache_get_field_content_int(i, "VehicleOwnerDBID", ourConnection);
			VehicleInfo[vehicleid][eVehicleFaction] = cache_get_field_content_int(i, "VehicleFaction", ourConnection);

			VehicleInfo[vehicleid][eVehicleModel] = cache_get_field_content_int(i, "VehicleModel", ourConnection);

			VehicleInfo[vehicleid][eVehicleColor1] = cache_get_field_content_int(i, "VehicleColor1", ourConnection);
			VehicleInfo[vehicleid][eVehicleColor2] = cache_get_field_content_int(i, "VehicleColor2", ourConnection);

			VehicleInfo[vehicleid][eVehicleParkPos][0] = cache_get_field_content_float(i, "VehicleParkPosX", ourConnection);
			VehicleInfo[vehicleid][eVehicleParkPos][1] = cache_get_field_content_float(i, "VehicleParkPosY", ourConnection);
			VehicleInfo[vehicleid][eVehicleParkPos][2] = cache_get_field_content_float(i, "VehicleParkPosZ", ourConnection);
			VehicleInfo[vehicleid][eVehicleParkPos][3] = cache_get_field_content_float(i, "VehicleParkPosA", ourConnection);

			VehicleInfo[vehicleid][eVehicleParkInterior] = cache_get_field_content_int(i, "VehicleParkInterior", ourConnection);
			VehicleInfo[vehicleid][eVehicleParkWorld] = cache_get_field_content_int(i, "VehicleParkWorld", ourConnection);

			cache_get_field_content(i, "VehiclePlates", VehicleInfo[vehicleid][eVehiclePlates], ourConnection, 32);
			VehicleInfo[vehicleid][eVehicleLocked] = bool:cache_get_field_content_int(i, "VehicleLocked", ourConnection);

			VehicleInfo[vehicleid][eVehicleImpounded] = bool:cache_get_field_content_int(i, "VehicleImpounded", ourConnection);

			VehicleInfo[vehicleid][eVehicleImpoundPos][0] = cache_get_field_content_float(i, "VehicleImpoundPosX", ourConnection);
			VehicleInfo[vehicleid][eVehicleImpoundPos][1] = cache_get_field_content_float(i, "VehicleImpoundPosY", ourConnection);
			VehicleInfo[vehicleid][eVehicleImpoundPos][2] = cache_get_field_content_float(i, "VehicleImpoundPosZ", ourConnection);
			VehicleInfo[vehicleid][eVehicleImpoundPos][3] = cache_get_field_content_float(i, "VehicleImpoundPosA", ourConnection);

			VehicleInfo[vehicleid][eVehicleFuel] = cache_get_field_content_float(i, "VehicleFuel", ourConnection);

			VehicleInfo[vehicleid][eVehicleHasXMR] = bool:cache_get_field_content_int(i, "VehicleXMR", ourConnection);
			VehicleInfo[vehicleid][eVehicleTimesDestroyed] = cache_get_field_content_int(i, "VehicleTimesDestroyed", ourConnection);

			VehicleInfo[vehicleid][eVehicleEngine] = cache_get_field_content_float(i, "VehicleEngine", ourConnection);
			VehicleInfo[vehicleid][eVehicleBattery] = cache_get_field_content_float(i, "VehicleBattery", ourConnection);

			VehicleInfo[vehicleid][eVehicleAlarmLevel] = cache_get_field_content_int(i, "VehicleAlarmLevel", ourConnection);
			VehicleInfo[vehicleid][eVehicleLockLevel] = cache_get_field_content_int(i, "VehicleLockLevel", ourConnection);
			VehicleInfo[vehicleid][eVehicleImmobLevel] = cache_get_field_content_int(i, "VehicleImmobLevel", ourConnection);
			VehicleInfo[vehicleid][eVehicleID] = vehicleid;

			for(new j = 1; j < 6; j++)
			{
				format(str, sizeof(str), "VehicleWeapons%d", j);
				VehicleInfo[vehicleid][eVehicleWeapons][j] = cache_get_field_content_int(i, str, ourConnection);

				format(str, sizeof(str), "VehicleWeaponsAmmo%d", j);
				VehicleInfo[vehicleid][eVehicleWeaponsAmmo][j] = cache_get_field_content_int(i, str, ourConnection);
			}

			for(new d = 1; d < 5; d++)
			{
				format(str, sizeof(str), "VehicleLastDrivers%d", d);
				VehicleInfo[vehicleid][eVehicleLastDrivers][d] = cache_get_field_content_int(i, str, ourConnection);

				format(str, sizeof(str), "VehicleLastPassengers%d", d);
				VehicleInfo[vehicleid][eVehicleLastPassengers][d] = cache_get_field_content_int(i, str, ourConnection);
			}
			if(VehicleInfo[vehicleid][eVehicleParkInterior] != 0)
			{
				LinkVehicleToInterior(vehicleid, VehicleInfo[vehicleid][eVehicleParkInterior]);
				SetVehicleVirtualWorld(vehicleid, VehicleInfo[vehicleid][eVehicleParkWorld]);
			}

			if(!isnull(VehicleInfo[vehicleid][eVehiclePlates]))
			{
				SetVehicleNumberPlate(vehicleid, VehicleInfo[vehicleid][eVehiclePlates]);
				SetVehicleToRespawn(vehicleid);
			}

			if(VehicleInfo[vehicleid][eVehicleImpounded] == true)
			{
				SetVehiclePos(vehicleid, VehicleInfo[vehicleid][eVehicleImpoundPos][0], VehicleInfo[vehicleid][eVehicleImpoundPos][1], VehicleInfo[vehicleid][eVehicleImpoundPos][2]);
				SetVehicleZAngle(vehicleid, VehicleInfo[vehicleid][eVehicleImpoundPos][3]);
			}

			if(VehicleInfo[vehicleid][eVehicleLocked] == false)
				SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, 0);

			else SetVehicleParamsEx(vehicleid, 0, 0, 0, 1, 0, 0, 0);

			VehicleInfo[vehicleid][eVehicleAdminSpawn] = false;

			if(HasNoEngine(playerid))
				ToggleVehicleEngine(vehicleid, true);
		}
	}
	SendClientMessageEx(playerid, COLOR_DARKGREEN, "%s has been spawned at its parking place.", ReturnVehicleName(vehicleid));
	SendClientMessageEx(playerid, COLOR_WHITE, "Lifespan: Engine Life[%.2f], Battery Life[%.2f], Times Destroyed[%d]", VehicleInfo[vehicleid][eVehicleEngine], VehicleInfo[vehicleid][eVehicleBattery], VehicleInfo[vehicleid][eVehicleTimesDestroyed]);
	if(VehicleInfo[vehicleid][eVehicleImpounded]) SendClientMessage(playerid, COLOR_RED, "Your vehicle is impounded.");

	SendClientMessage(playerid, 0xFF00FFFF, "Hint: Follow the red marker to your parking place.");
	SetPlayerCheckpoint(playerid, VehicleInfo[vehicleid][eVehicleParkPos][0], VehicleInfo[vehicleid][eVehicleParkPos][1], VehicleInfo[vehicleid][eVehicleParkPos][2], 3.0);

    VehicleInfo[vehicleid][eVehicleID] = vehicleid;
	SaveVehicle(vehicleid);
	PlayerCheckpoint[playerid] = 1;
	SaveCharacter(playerid);
	return 1;
}

function:Query_LoadProperties()
{
	if(!cache_num_rows())
		return printf("[SERVER]: No properties were loaded from \"%s\" database...", SQL_DATABASE);

	new rows, fields; cache_get_data(rows, fields, ourConnection);
	new countProperties = 0, str[128];
	new hstring[128];

	for(new i = 0; i < rows && i < MAX_PROPERTY; i++)
	{
		PropertyInfo[i+1][ePropertyDBID] = cache_get_field_content_int(i, "PropertyDBID", ourConnection);
		PropertyInfo[i+1][ePropertyOwnerDBID] = cache_get_field_content_int(i, "PropertyOwnerDBID", ourConnection);

		PropertyInfo[i+1][ePropertyType] = cache_get_field_content_int(i, "PropertyType", ourConnection);
		PropertyInfo[i+1][ePropertyFaction] = cache_get_field_content_int(i, "PropertyFaction", ourConnection);

		PropertyInfo[i+1][ePropertyEntrance][0] = cache_get_field_content_float(i, "PropertyEntranceX", ourConnection);
		PropertyInfo[i+1][ePropertyEntrance][1] = cache_get_field_content_float(i, "PropertyEntranceY", ourConnection);
		PropertyInfo[i+1][ePropertyEntrance][2] = cache_get_field_content_float(i, "PropertyEntranceZ", ourConnection);

		PropertyInfo[i+1][ePropertyEntranceInterior] = cache_get_field_content_int(i, "PropertyEntranceInterior", ourConnection);
		PropertyInfo[i+1][ePropertyEntranceWorld] = cache_get_field_content_int(i, "PropertyEntranceWorld", ourConnection);

		PropertyInfo[i+1][ePropertyInterior][0] = cache_get_field_content_float(i, "PropertyInteriorX", ourConnection);
		PropertyInfo[i+1][ePropertyInterior][1] = cache_get_field_content_float(i, "PropertyInteriorY", ourConnection);
		PropertyInfo[i+1][ePropertyInterior][2] = cache_get_field_content_float(i, "PropertyInteriorZ", ourConnection);

		PropertyInfo[i+1][ePropertyInteriorIntID] = cache_get_field_content_int(i, "PropertyInteriorIntID", ourConnection);
		PropertyInfo[i+1][ePropertyInteriorWorld] = cache_get_field_content_int(i, "PropertyInteriorWorld", ourConnection);

		PropertyInfo[i+1][ePropertyMarketPrice] = cache_get_field_content_int(i, "PropertyMarketPrice", ourConnection);
		PropertyInfo[i+1][ePropertyLevel] = cache_get_field_content_int(i, "PropertyLocked", ourConnection);
		cache_get_field_content(i, "PropertyAdress", PropertyInfo[i+1][ePropertyAdress], ourConnection, 90);

		PropertyInfo[i+1][ePropertyLocked] = bool:cache_get_field_content_int(i, "PropertyLocked", ourConnection);

		PropertyInfo[i+1][ePropertyCashbox] = cache_get_field_content_int(i, "PropertyCashbox", ourConnection);

		PropertyInfo[i+1][ePropertyPlacePos][0] = cache_get_field_content_float(i, "PropertyPlacePosX", ourConnection);
		PropertyInfo[i+1][ePropertyPlacePos][1] = cache_get_field_content_float(i, "PropertyPlacePosY", ourConnection);
		PropertyInfo[i+1][ePropertyPlacePos][2] = cache_get_field_content_float(i, "PropertyPlacePosZ", ourConnection);

		for(new w = 1; w < 21; w++)
		{
			format(str, sizeof(str), "PropertyWeapon%i", w);
			PropertyInfo[i+1][ePropertyWeapons][w] = cache_get_field_content_int(i, str, ourConnection);

			format(str, sizeof(str), "PropertyWeaponAmmo%i", w);
			PropertyInfo[i+1][ePropertyWeaponsAmmo][w] = cache_get_field_content_int(i, str, ourConnection);
		}

		PropertyInfo[i+1][ePropertyHasBoombox] = bool:cache_get_field_content_int(i, "PropertyHasBoombox", ourConnection);

		PropertyInfo[i+1][ePropertyBoomboxPos][0] = cache_get_field_content_float(i, "PropertyBoomboxPosX", ourConnection);
		PropertyInfo[i+1][ePropertyBoomboxPos][1] = cache_get_field_content_float(i, "PropertyBoomboxPosY", ourConnection);
		PropertyInfo[i+1][ePropertyBoomboxPos][2] = cache_get_field_content_float(i, "PropertyBoomboxPosZ", ourConnection);

		PropertyInfo[i+1][ePropertyBoomboxRot][0] = cache_get_field_content_float(i, "PropertyBoomboxRotX", ourConnection);
		PropertyInfo[i+1][ePropertyBoomboxRot][1] = cache_get_field_content_float(i, "PropertyBoomboxRotY", ourConnection);
		PropertyInfo[i+1][ePropertyBoomboxRot][2] = cache_get_field_content_float(i, "PropertyBoomboxRotZ", ourConnection);
		if(!PropertyInfo[i+1][ePropertyOwnerDBID])
		{
		    format(hstring, sizeof(hstring), "Adess: %s\nFor Sale!\n Price: $%i", PropertyInfo[i+1][ePropertyAdress],PropertyInfo[i+1][ePropertyMarketPrice]);
			PropertyInfo[i+1][ePropertyTag] = Create3DTextLabel(hstring, COLOR_GREEN, PropertyInfo[i+1][ePropertyEntrance][0], PropertyInfo[i+1][ePropertyEntrance][1], PropertyInfo[i+1][ePropertyEntrance][2], 20, 0, 1);
			PropertyInfo[i+1][ePropertyPickup] = CreateDynamicPickup(1273, 1, PropertyInfo[i+1][ePropertyEntrance][0], PropertyInfo[i+1][ePropertyEntrance][1], PropertyInfo[i+1][ePropertyEntrance][2], 0);
		}
		else
		{
		    format(hstring, sizeof(hstring), "Adress: %s", PropertyInfo[i+1][ePropertyAdress]);
		    PropertyInfo[i+1][ePropertyTag] = Create3DTextLabel(hstring, COLOR_WHITE, PropertyInfo[i+1][ePropertyEntrance][0], PropertyInfo[i+1][ePropertyEntrance][1], PropertyInfo[i+1][ePropertyEntrance][2], 20, 0, 1);
  			PropertyInfo[i+1][ePropertyPickup] = CreateDynamicPickup(1272, 1, PropertyInfo[i+1][ePropertyEntrance][0], PropertyInfo[i+1][ePropertyEntrance][1], PropertyInfo[i+1][ePropertyEntrance][2], 0);
		}
		if(PropertyInfo[i+1][ePropertyHasBoombox])
		{
			PropertyInfo[i+1][ePropertyBoomboxObject] = CreateDynamicObject(2103, PropertyInfo[i+1][ePropertyBoomboxPos][0], PropertyInfo[i+1][ePropertyBoomboxPos][1], PropertyInfo[i+1][ePropertyBoomboxPos][2],
				PropertyInfo[i+1][ePropertyBoomboxRot][0], PropertyInfo[i+1][ePropertyBoomboxRot][1], PropertyInfo[i+1][ePropertyBoomboxRot][2], PropertyInfo[i+1][ePropertyInteriorWorld], PropertyInfo[i+1][ePropertyInteriorIntID]);
		}

		countProperties++;
	}

	printf("[SERVER]: %i properties were loaded from \"%s\" database...", countProperties, SQL_DATABASE);
	return 1;
}

function:Query_LoadVehicles()
{
	if(!cache_num_rows())
		return printf("[SERVER]: No vehicles were loaded from \"%s\" database...", SQL_DATABASE);

	new rows, fields; cache_get_data(rows, fields, ourConnection);
	new endCount = 0, str[128], vehicleid = INVALID_VEHICLE_ID;

	for (new i = 0; i < rows && i < MAX_VEHICLES; i ++)
	{
		vehicleid = CreateVehicle(cache_get_field_content_int(i, "VehicleModel", ourConnection),
			cache_get_field_content_float(i, "VehicleParkPosX", ourConnection),
			cache_get_field_content_float(i, "VehicleParkPosY", ourConnection),
			cache_get_field_content_float(i, "VehicleParkPosZ", ourConnection),
			cache_get_field_content_float(i, "VehicleParkPosA", ourConnection),
			cache_get_field_content_int(i, "VehicleColor1", ourConnection),
			cache_get_field_content_int(i, "VehicleColor2", ourConnection),
			-1,
			cache_get_field_content_int(i, "VehicleSirens", ourConnection));
		VehicleInfo[vehicleid][eVehicleID] = vehicleid;

		if(vehicleid != INVALID_VEHICLE_ID)
		{
			VehicleInfo[vehicleid][eVehicleExists] = true;
			VehicleInfo[vehicleid][eVehicleID] = vehicleid;
			VehicleInfo[vehicleid][eVehicleDBID] = cache_get_field_content_int(i, "VehicleDBID", ourConnection);

			VehicleInfo[vehicleid][eVehicleOwnerDBID] = cache_get_field_content_int(i, "VehicleOwnerDBID", ourConnection);
			VehicleInfo[vehicleid][eVehicleFaction] = cache_get_field_content_int(i, "VehicleFaction", ourConnection);

			VehicleInfo[vehicleid][eVehicleModel] = cache_get_field_content_int(i, "VehicleModel", ourConnection);

			VehicleInfo[vehicleid][eVehicleColor1] = cache_get_field_content_int(i, "VehicleColor1", ourConnection);
			VehicleInfo[vehicleid][eVehicleColor2] = cache_get_field_content_int(i, "VehicleColor2", ourConnection);

			VehicleInfo[vehicleid][eVehicleParkPos][0] = cache_get_field_content_float(i, "VehicleParkPosX", ourConnection);
			VehicleInfo[vehicleid][eVehicleParkPos][1] = cache_get_field_content_float(i, "VehicleParkPosY", ourConnection);
			VehicleInfo[vehicleid][eVehicleParkPos][2] = cache_get_field_content_float(i, "VehicleParkPosZ", ourConnection);
			VehicleInfo[vehicleid][eVehicleParkPos][3] = cache_get_field_content_float(i, "VehicleParkPosA", ourConnection);

			VehicleInfo[vehicleid][eVehicleParkInterior] = cache_get_field_content_int(i, "VehicleParkInterior", ourConnection);
			VehicleInfo[vehicleid][eVehicleParkWorld] = cache_get_field_content_int(i, "VehicleParkWorld", ourConnection);

			cache_get_field_content(i, "VehiclePlates", VehicleInfo[vehicleid][eVehiclePlates], ourConnection, 32);
			VehicleInfo[vehicleid][eVehicleLocked] = bool:cache_get_field_content_int(i, "VehicleLocked", ourConnection);

			VehicleInfo[vehicleid][eVehicleImpounded] = bool:cache_get_field_content_int(i, "VehicleImpounded", ourConnection);

			VehicleInfo[vehicleid][eVehicleImpoundPos][0] = cache_get_field_content_float(i, "VehicleImpoundPosX", ourConnection);
			VehicleInfo[vehicleid][eVehicleImpoundPos][1] = cache_get_field_content_float(i, "VehicleImpoundPosY", ourConnection);
			VehicleInfo[vehicleid][eVehicleImpoundPos][2] = cache_get_field_content_float(i, "VehicleImpoundPosZ", ourConnection);
			VehicleInfo[vehicleid][eVehicleImpoundPos][3] = cache_get_field_content_float(i, "VehicleImpoundPosA", ourConnection);

			VehicleInfo[vehicleid][eVehicleFuel] = cache_get_field_content_float(i, "VehicleFuel", ourConnection);
			VehicleInfo[vehicleid][eVehicleSirens] = cache_get_field_content_int(i, "VehicleSirens", ourConnection);

			VehicleInfo[vehicleid][eVehicleHasXMR] = bool:cache_get_field_content_int(i, "VehicleXMR", ourConnection);
			VehicleInfo[vehicleid][eVehicleTimesDestroyed] = cache_get_field_content_int(i, "VehicleTimesDestroyed", ourConnection);

			VehicleInfo[vehicleid][eVehicleEngine] = cache_get_field_content_float(i, "VehicleEngine", ourConnection);
			VehicleInfo[vehicleid][eVehicleBattery] = cache_get_field_content_float(i, "VehicleBattery", ourConnection);

			VehicleInfo[vehicleid][eVehicleAlarmLevel] = cache_get_field_content_int(i, "VehicleAlarmLevel", ourConnection);
			VehicleInfo[vehicleid][eVehicleLockLevel] = cache_get_field_content_int(i, "VehicleLockLevel", ourConnection);
			VehicleInfo[vehicleid][eVehicleImmobLevel] = cache_get_field_content_int(i, "VehicleImmobLevel", ourConnection);
			VehicleInfo[vehicleid][eVehicleID] = vehicleid;

			for(new j = 1; j < 6; j++)
			{
				format(str, sizeof(str), "VehicleWeapons%d", j);
				VehicleInfo[vehicleid][eVehicleWeapons][j] = cache_get_field_content_int(i, str, ourConnection);

				format(str, sizeof(str), "VehicleWeaponsAmmo%d", j);
				VehicleInfo[vehicleid][eVehicleWeaponsAmmo][j] = cache_get_field_content_int(i, str, ourConnection);
			}

			for(new d = 1; d < 5; d++)
			{
				format(str, sizeof(str), "VehicleLastDrivers%d", d);
				VehicleInfo[vehicleid][eVehicleLastDrivers][d] = cache_get_field_content_int(i, str, ourConnection);

				format(str, sizeof(str), "VehicleLastPassengers%d", d);
				VehicleInfo[vehicleid][eVehicleLastPassengers][d] = cache_get_field_content_int(i, str, ourConnection);
			}

			if(VehicleInfo[vehicleid][eVehicleParkInterior] != 0)
			{
				LinkVehicleToInterior(vehicleid, VehicleInfo[vehicleid][eVehicleParkInterior]);
				SetVehicleVirtualWorld(vehicleid, VehicleInfo[vehicleid][eVehicleParkWorld]);
			}

			if(!isnull(VehicleInfo[vehicleid][eVehiclePlates]))
			{
				SetVehicleNumberPlate(vehicleid, VehicleInfo[vehicleid][eVehiclePlates]);
				SetVehicleToRespawn(vehicleid);
			}

			if(VehicleInfo[vehicleid][eVehicleImpounded] == true)
			{
				SetVehiclePos(vehicleid, VehicleInfo[vehicleid][eVehicleImpoundPos][0], VehicleInfo[vehicleid][eVehicleImpoundPos][1], VehicleInfo[vehicleid][eVehicleImpoundPos][2]);
				SetVehicleZAngle(vehicleid, VehicleInfo[vehicleid][eVehicleImpoundPos][3]);
			}

			VehicleInfo[vehicleid][eVehicleAdminSpawn] = false;
			endCount++;
		}
	}
	VehicleInfo[vehicleid][eVehicleID] = vehicleid;
	printf("[SERVER]: %d vehicles were loaded from \"%s\" database...", endCount, SQL_DATABASE);
	SaveVehicle(vehicleid);
	return 1;
}
function:Query_LoadXMRCategories()
{
	if(!cache_num_rows())
		return  printf("[SERVER]: No XMR categories were loaded from \"%s\" database...", SQL_DATABASE);

	new rows, fields; cache_get_data(rows, fields, ourConnection);

	for(new i = 0; i < rows && i < MAX_XMR_CATEGORY; i++)
	{
		XMRCategoryInfo[i+1][eXMRID] = cache_get_field_content_int(i, "XMRDBID", ourConnection);
		cache_get_field_content(i, "XMRCategoryName", XMRCategoryInfo[i+1][eXMRCategoryName], ourConnection, 90);
	}

	printf("[SERVER]: %i XMR categories were loaded from \"%s\" database...", rows, SQL_DATABASE);
	return 1;
}

function:Query_LoadXMRStations()
{
	if(!cache_num_rows())
		return  printf("[SERVER]: No XMR stations were loaded from \"%s\" database...", SQL_DATABASE);

	new rows, fields; cache_get_data(rows, fields, ourConnection);

	for(new i = 0; i < rows && i < MAX_XMR_CATEGORY_STATIONS; i++)
	{
		XMRStationInfo[i+1][eXMRStationID] = cache_get_field_content_int(i, "XMRStationDBID", ourConnection);
		XMRStationInfo[i+1][eXMRCategory] = cache_get_field_content_int(i, "XMRCategory", ourConnection);

		cache_get_field_content(i, "XMRStationName", XMRStationInfo[i+1][eXMRStationName], ourConnection, 90);
		cache_get_field_content(i, "XMRStationURL", XMRStationInfo[i+1][eXMRStationURL], ourConnection, 128);
	}

	printf("[SERVER]: %i XMR stations were loaded from \"%s\" database...", rows, SQL_DATABASE);
	return 1;
}

function:Query_LoadBusinesses()
{
	if(!cache_num_rows())
		return printf("[SERVER]: No businesses were loaded from \"%s\" database...", SQL_DATABASE);

	new rows, fields; cache_get_data(rows, fields, ourConnection);

	for(new i = 0; i < rows && i < MAX_BUSINESS; i++)
	{
		BusinessInfo[i+1][eBusinessDBID] = cache_get_field_content_int(i, "BusinessDBID", ourConnection);
		BusinessInfo[i+1][eBusinessOwnerDBID] = cache_get_field_content_int(i, "BusinessOwnerDBID", ourConnection);

		BusinessInfo[i+1][eBusinessInterior][0] = cache_get_field_content_float(i, "BusinessInteriorX", ourConnection);
		BusinessInfo[i+1][eBusinessInterior][1] = cache_get_field_content_float(i, "BusinessInteriorY", ourConnection);
		BusinessInfo[i+1][eBusinessInterior][2] = cache_get_field_content_float(i, "BusinessInteriorZ", ourConnection);

		BusinessInfo[i+1][eBusinessInteriorWorld] = cache_get_field_content_int(i, "BusinessInteriorWorld", ourConnection);
		BusinessInfo[i+1][eBusinessInteriorIntID] = cache_get_field_content_int(i, "BusinessInteriorIntID", ourConnection);
		BusinessInfo[i+1][eBusinessInteriorExtWorld] = cache_get_field_content_int(i, "BusinessInteriorExtWorld", ourConnection);
		BusinessInfo[i+1][eBusinessInteriorExtIntID] = cache_get_field_content_int(i, "BusinessInteriorExtIntID", ourConnection);

		BusinessInfo[i+1][eBusinessEntrance][0] = cache_get_field_content_float(i, "BusinessEntranceX", ourConnection);
		BusinessInfo[i+1][eBusinessEntrance][1] = cache_get_field_content_float(i, "BusinessEntranceY", ourConnection);
		BusinessInfo[i+1][eBusinessEntrance][2] = cache_get_field_content_float(i, "BusinessEntranceZ", ourConnection);

		cache_get_field_content(i, "BusinessName", BusinessInfo[i+1][eBusinessName], ourConnection, 90);
		BusinessInfo[i+1][eBusinessType] = cache_get_field_content_int(i, "BusinessType", ourConnection);

		BusinessInfo[i+1][eBusinessLocked] = bool:cache_get_field_content_int(i, "BusinessLocked", ourConnection);
		BusinessInfo[i+1][eBusinessEntranceFee] = cache_get_field_content_int(i, "BusinessEntranceFee", ourConnection);

		BusinessInfo[i+1][eBusinessLevel] = cache_get_field_content_int(i, "BusinessLevel", ourConnection);
		BusinessInfo[i+1][eBusinessMarketPrice] = cache_get_field_content_int(i, "BusinessMarketPrice", ourConnection);

		BusinessInfo[i+1][eBusinessCashbox] = cache_get_field_content_int(i, "BusinessCashbox", ourConnection);
		BusinessInfo[i+1][eBusinessProducts] = cache_get_field_content_int(i, "BusinessProducts", ourConnection);

		BusinessInfo[i+1][eBusinessBankPickupLoc][0] = cache_get_field_content_float(i, "BusinessBankPickupLocX", ourConnection);
		BusinessInfo[i+1][eBusinessBankPickupLoc][1] = cache_get_field_content_float(i, "BusinessBankPickupLocY", ourConnection);
		BusinessInfo[i+1][eBusinessBankPickupLoc][2] = cache_get_field_content_float(i, "BusinessBankPickupLocZ", ourConnection);

		BusinessInfo[i+1][eBusinessBankPickupWorld] = cache_get_field_content_int(i, "BusinessBankPickupWorld", ourConnection);

		if(BusinessInfo[i+1][eBusinessType] == BUSINESS_TYPE_RESTAURANT)
		{
			if(!BusinessInfo[i+1][eBusinessOwnerDBID])
				BusinessInfo[i+1][eBusinessPickup] = CreateDynamicPickup(1272, 1, BusinessInfo[i+1][eBusinessEntrance][0], BusinessInfo[i+1][eBusinessEntrance][1], BusinessInfo[i+1][eBusinessEntrance][2], 0);

			else BusinessInfo[i+1][eBusinessPickup] = CreateDynamicPickup(1239, 1, BusinessInfo[i+1][eBusinessEntrance][0], BusinessInfo[i+1][eBusinessEntrance][1], BusinessInfo[i+1][eBusinessEntrance][2], 0);
		}
		else BusinessInfo[i+1][eBusinessPickup] = CreateDynamicPickup(1239, 1, BusinessInfo[i+1][eBusinessEntrance][0], BusinessInfo[i+1][eBusinessEntrance][1], BusinessInfo[i+1][eBusinessEntrance][2], 0);

		if(BusinessInfo[i+1][eBusinessType] == BUSINESS_TYPE_BANK)
		{
			BusinessInfo[i+1][eBusinessBankPickup] = CreateDynamicPickup(1274, 1, BusinessInfo[i+1][eBusinessBankPickupLoc][0], BusinessInfo[i+1][eBusinessBankPickupLoc][1], BusinessInfo[i+1][eBusinessBankPickupLoc][2], BusinessInfo[i+1][eBusinessBankPickupWorld]);
		}
	}

	printf("[SERVER]: %i businesses were loaded from \"%s\" database...", rows, SQL_DATABASE);
	return 1;
}

function:Query_AddPlayerVehicle(playerid, playerb, id, modelid, color1, color2)
{
	PlayerInfo[playerb][pOwnedVehicles][playerInsertID[playerb]] = cache_insert_id();

	SendServerMessage(playerb, "You received a vehicle from %s in slot %i.", ReturnName(playerid), playerInsertID[playerb]);

	SendServerMessage(playerid, "You issued %s a new vehicle.", ReturnName(playerb));

	playerInsertID[playerb] = 0;
	SaveCharacter(playerb);
	return 1;
}

function:GivePlayerGun(playerid, weaponid, ammo)
{
	new idx = ReturnWeaponIDSlot(weaponid);

	if(PlayerInfo[playerid][pWeapons][idx])
	{
		RemovePlayerWeapon(playerid, PlayerInfo[playerid][pWeapons][idx]);
		printf("A weapon was removed. Slot: %i, Weapon: %i", idx, PlayerInfo[playerid][pWeapons][idx]);
	}

	GivePlayerWeapon(playerid, weaponid, ammo);

	PlayerInfo[playerid][pWeapons][idx] = weaponid;
	PlayerInfo[playerid][pWeaponsAmmo][idx] = ammo;

	PlayerInfo[playerid][pWeaponsImmune] = gettime();

	printf("Weapon given: IDX: %i, Weapon ID: %i", idx, PlayerInfo[playerid][pWeapons][idx]);
	return 1;
}

function:ReturnPlayerGuns(playerid)
{
	for(new i = 0; i < 12; i++) if(PlayerInfo[playerid][pWeaponsAmmo][i])
		GivePlayerWeapon(playerid, PlayerInfo[playerid][pWeapons][i], PlayerInfo[playerid][pWeaponsAmmo][i]);

	return 1;
}

function:TakePlayerGuns(playerid)
{
	for(new i = 0; i < 12; i++) if(PlayerInfo[playerid][pWeaponsAmmo][i])
		PlayerInfo[playerid][pWeapons][i] = 0;

	ResetPlayerWeapons(playerid);
	return 1;
}

function:OnPlayerUnscramble(playerid)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	{
		PlayerInfo[playerid][pUnscrambling] = false;
		PlayerInfo[playerid][pUnscramblerTime] = 0;
		PlayerInfo[playerid][pUnscrambleID] = 0;

		PlayerInfo[playerid][pScrambleSuccess] = 0;
		PlayerInfo[playerid][pScrambleFailed] = 0;
		KillTimer(PlayerInfo[playerid][pUnscrambleTimer]);

		ShowUnscrambleTextdraw(playerid, false);
		return 1;
	}

	PlayerInfo[playerid][pUnscramblerTime]--;

	new timerString[20];

	format(timerString, 20, "%d", PlayerInfo[playerid][pUnscramblerTime]);
	PlayerTextDrawSetString(playerid, Unscrambler_PTD[playerid][5], timerString);

	if(PlayerInfo[playerid][pUnscramblerTime] < 1)
	{
		PlayerInfo[playerid][pUnscrambling] = false;
		PlayerInfo[playerid][pUnscramblerTime] = 0;
		PlayerInfo[playerid][pUnscrambleID] = 0;

		PlayerInfo[playerid][pScrambleSuccess] = 0;
		PlayerInfo[playerid][pScrambleFailed] = 0;
		KillTimer(PlayerInfo[playerid][pUnscrambleTimer]);

		ShowUnscrambleTextdraw(playerid, false);

		new
			vehicleid = GetPlayerVehicleID(playerid)
		;

		ToggleVehicleAlarms(vehicleid, true);
		NotifyVehicleOwner(vehicleid);

		ClearAnimations(playerid);
	}
	return 1;
}

function:OnVehicleAlarm(vehicleid)
{
	return ToggleVehicleAlarms(vehicleid, false);
}

function:OnPlayerLeaveWeapon(index)
{
	WeaponDropInfo[index][eWeaponDropped] = false;
	WeaponDropInfo[index][eWeaponDroppedBy] = 0;

	WeaponDropInfo[index][eWeaponWepAmmo] = 0;
	WeaponDropInfo[index][eWeaponWepID] = 0;

	for(new i = 0; i < 3; i++)
	{
		WeaponDropInfo[index][eWeaponPos][i] = 0.0;
	}

	if(IsValidDynamicObject(WeaponDropInfo[index][eWeaponObject]))
	{
		DestroyDynamicObject(WeaponDropInfo[index][eWeaponObject]);
	}

	return 1;
}

function:OnPropertyCreate(playerid, type)
{
	new
		idx,
		str[128]
	;

	for(new i = 1; i < MAX_PROPERTY; i++)
	{
		if(PropertyInfo[i][ePropertyDBID])
			continue;

		idx = i;
		break;
	}

	PropertyInfo[idx][ePropertyDBID] = cache_insert_id();
	PropertyInfo[idx][ePropertyType] = type;

	format(str, sizeof(str), "%s created Property ID %i.", ReturnName(playerid), cache_insert_id());
	SendAdminMessage(4, str);

	SendClientMessage(playerid, COLOR_RED, "[ ! ]{FFFFFF} Use \"/editproperty\" to continue the next part.");
	return 1;
}

function:OnEntranceChange(playerid, response, property)
{
	if(response)
	{
		GetPlayerPos(playerid, PropertyInfo[property][ePropertyEntrance][0], PropertyInfo[property][ePropertyEntrance][1], PropertyInfo[property][ePropertyEntrance][2]);

        DestroyDynamicPickup(PropertyInfo[property][ePropertyPickup]);
        Delete3DTextLabel(PropertyInfo[property][ePropertyTag]);
		new hstring[90];
        if(!PropertyInfo[property][ePropertyOwnerDBID])
		{
			format(hstring, sizeof(hstring), "Adress: %s\nFor Sale!\n Price: $%i", PropertyInfo[property][ePropertyAdress],PropertyInfo[property][ePropertyMarketPrice]);
			PropertyInfo[property][ePropertyTag] = Create3DTextLabel(hstring, COLOR_GREEN, PropertyInfo[property][ePropertyEntrance][0], PropertyInfo[property][ePropertyEntrance][1], PropertyInfo[property][ePropertyEntrance][2], 20, 0, 1);
			PropertyInfo[property][ePropertyPickup] = CreateDynamicPickup(1273, 1, PropertyInfo[property][ePropertyEntrance][0], PropertyInfo[property][ePropertyEntrance][1], PropertyInfo[property][ePropertyEntrance][2]);
		}
		else
		{
			format(hstring, sizeof(hstring), "Adress: %s", PropertyInfo[property][ePropertyAdress]);
			Create3DTextLabel(hstring, COLOR_WHITE, PropertyInfo[property][ePropertyEntrance][0], PropertyInfo[property][ePropertyEntrance][1], PropertyInfo[property][ePropertyEntrance][2], 20, 0, 1);
			PropertyInfo[property][ePropertyPickup] = CreateDynamicPickup(1272, 1, PropertyInfo[property][ePropertyEntrance][0], PropertyInfo[property][ePropertyEntrance][1], PropertyInfo[property][ePropertyEntrance][2]);
		}
        
		PropertyInfo[property][ePropertyEntranceInterior] = GetPlayerInterior(playerid);
		PropertyInfo[property][ePropertyEntranceWorld] = GetPlayerVirtualWorld(playerid);

		SaveProperty(property);
		SendServerMessage(playerid, "You set Property %i's entrance.", property);
	}
	return 1;
}

function:OnInteriorChange(playerid, response, property)
{
	if(response)
	{
		GetPlayerPos(playerid, PropertyInfo[property][ePropertyInterior][0], PropertyInfo[property][ePropertyInterior][1], PropertyInfo[property][ePropertyInterior][2]);

		new
			world = random(40000)+playerid+2;

		PropertyInfo[property][ePropertyInteriorIntID] = GetPlayerInterior(playerid);
		PropertyInfo[property][ePropertyInteriorWorld] = world;

		foreach(new i : Player) if(IsPlayerInProperty(i) == property)
		{
			SetPlayerPos(i, PropertyInfo[property][ePropertyInterior][0], PropertyInfo[property][ePropertyInterior][1], PropertyInfo[property][ePropertyInterior][2]);
			SetPlayerInterior(i, GetPlayerInterior(playerid)); SetPlayerVirtualWorld(i, world);

			SendServerMessage(i, "The property you were in was amended.");
		}

		SaveProperty(property);
		SendServerMessage(playerid, "You set Property %i's interior.", property);
	}
	return 1;
}

function:OnPlayerEnterProperty(playerid, id)
{
	SetPlayerPos(playerid, PropertyInfo[id][ePropertyInterior][0], PropertyInfo[id][ePropertyInterior][1], PropertyInfo[id][ePropertyInterior][2]);
	return TogglePlayerControllable(playerid, 1);
}

function:Query_ShowVehicleList(playerid, idx)
{
	new rows, fields; cache_get_data(rows, fields, ourConnection);

	new
		vehicleDBID,
		vehicleModel,
		vehicleLockLevel,
		vehicleAlarmLevel,
		vehicleImmobLevel,
		vehicleTimesDestroyed,
		vehicleID,
		vehiclePlates[32],
		bool:isSpawned = false,
		color
	;

	for(new i = 0; i < rows; i++)
	{
		vehicleDBID = cache_get_field_content_int(0, "VehicleDBID", ourConnection);
		vehicleModel = cache_get_field_content_int(0, "VehicleModel", ourConnection);

		vehicleLockLevel = cache_get_field_content_int(0, "VehicleLockLevel", ourConnection);
		vehicleAlarmLevel = cache_get_field_content_int(0, "VehicleAlarmLevel", ourConnection);
		vehicleImmobLevel = cache_get_field_content_int(0, "VehicleImmobLevel", ourConnection);
		vehicleID = cache_get_field_content_int(0, "VehicleID", ourConnection);

		vehicleTimesDestroyed = cache_get_field_content_int(0, "VehicleTimesDestroyed", ourConnection);

		cache_get_field_content(0, "VehiclePlates", vehiclePlates, ourConnection, 32);
	}

	for(new id = 0; id < MAX_VEHICLES; id++)
	{
		if(VehicleInfo[id][eVehicleDBID] == vehicleDBID)
		{
			isSpawned = true;
		}
	}

	if(isSpawned)
		color = COLOR_CUBEG;

	else color = COLOR_CUBEG;

	SendClientMessageEx(playerid, color, "Vehicle(%i) %i: %s, Lock[%i], Alarm[%i], Immobiliser[%i], Times destroyed[%i], Plates[%s]", idx, vehicleID, ReturnVehicleModelName(vehicleModel), vehicleLockLevel, vehicleAlarmLevel, vehicleImmobLevel, vehicleTimesDestroyed, vehiclePlates);
	return 1;
}

function:OnOfflineAjail(playerid, jailing[], reason[], length)
{
	SendServerMessage(playerid, "%s was successfully admin jailed.", jailing);

	new
		logQuery[256]
	;

	mysql_format(ourConnection, logQuery, sizeof(logQuery), "INSERT INTO ajail_logs (JailedDBID, JailedName, Reason, Date, JailedBy) VALUES(%i, '%e', '%e', '%e', '%e')", ReturnDBIDFromName(jailing), jailing, reason, ReturnDate(), ReturnName(playerid));
	mysql_tquery(ourConnection, logQuery);
	return 1;
}

function:OnOfflineBan(playerid, banning[], dbid, masterdbid, reason[], date[])
{
	SendServerMessage(playerid, "%s was successfully banned.", banning);

	new
		logQuery[256]
	;

	mysql_format(ourConnection, logQuery, sizeof(logQuery), "INSERT INTO ban_logs (CharacterDBID, MasterDBID, CharacterName, Reason, BannedBy, Date) VALUES(%i, %i, '%e', '%e', '%e', '%e')",
		dbid, masterdbid, banning, reason, date);

	mysql_tquery(ourConnection, logQuery);
	return 1;
}

function:OnXMRCategory(playerid, newid, cat[])
{
	XMRCategoryInfo[newid][eXMRID] = cache_insert_id();
	format(XMRCategoryInfo[newid][eXMRCategoryName], 90, "%s", cat);

	SendServerMessage(playerid, "You made a new XMR category. \"%s\" (ID: %i)", cat, newid);
	return 1;
}

function:OnXMRStation(playerid, category, newid, url[], name[])
{
	XMRStationInfo[newid][eXMRStationID] = cache_insert_id();

	format(XMRStationInfo[newid][eXMRStationName], 90, "%s", name);
	format(XMRStationInfo[newid][eXMRStationURL], 128, "%s", url);

	SendServerMessage(playerid, "You made a new XMR station. \"%s\" (ID: %i)", name, newid);
	SendClientMessageEx(playerid, COLOR_WHITE, "Category: %s (%i). URL: %s", XMRCategoryInfo[category][eXMRCategoryName], category, url);
	return 1;
}

function:Float:GetVehicleTopSpeed(vehicleid)
{
    new model = GetVehicleModel(vehicleid);

    if (model)
    {
        return float(s_TopSpeed[(model - 400)]);
    }
    return 0.0;
}

function:SetPlayersSpawn(playerid)
{
	switch(PlayerInfo[playerid][pSpawnPoint])
	{
		case SPAWN_POINT_AIRPORT:
		{
			SetPlayerPos(playerid, -2329.0491,2299.7261,3.5000);
			if(PlayerInfo[playerid][pLastSkin] == 20003)
	 				return SCM(playerid, COLOR_RED, "you're currently wearing the noob skin. This is not ment to be role-played with, please change it.");

			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
		}
		case SPAWN_POINT_PROPERTY:
		{
			new
				id;

			id = PlayerInfo[playerid][pSpawnPointHouse];

			if(!PropertyInfo[id][ePropertyDBID] || PropertyInfo[id][ePropertyOwnerDBID] != PlayerInfo[playerid][pDBID])
			{
				if(PlayerInfo[playerid][pLastSkin] == 20003)
	 				return SCM(playerid, COLOR_RED, "you're currently wearing the noob skin. This is not ment to be role-played with, please change it.");
				PlayerInfo[playerid][pSpawnPoint] = SPAWN_POINT_AIRPORT;
				PlayerInfo[playerid][pSpawnPointHouse] = 0;

				return SetPlayersSpawn(playerid);
			}

			SetPlayerPos(playerid, PropertyInfo[id][ePropertyInterior][0], PropertyInfo[id][ePropertyInterior][1], PropertyInfo[id][ePropertyInterior][2]);

			SetPlayerInterior(playerid, PropertyInfo[id][ePropertyInteriorIntID]);
			SetPlayerVirtualWorld(playerid, PropertyInfo[id][ePropertyInteriorWorld]);

			PlayerInfo[playerid][pInsideProperty] = id;
		}
		case SPAWN_POINT_FACTION:
		{
			if(!PlayerInfo[playerid][pFaction])
			{
				if(PlayerInfo[playerid][pLastSkin] == 20003)
	 				return SCM(playerid, COLOR_RED, "you're currently wearing the noob skin. This is not ment to be role-played with, please change it.");
				PlayerInfo[playerid][pSpawnPoint] = SPAWN_POINT_AIRPORT;
				return SetPlayersSpawn(playerid);
			}

			new
				idx
			;

			idx = PlayerInfo[playerid][pFaction];

			if(!FactionInfo[idx][eFactionDBID])
			{
				PlayerInfo[playerid][pSpawnPoint] = SPAWN_POINT_AIRPORT;
				return SetPlayersSpawn(playerid);
			}

			SetPlayerPos(playerid, FactionInfo[idx][eFactionSpawn][0], FactionInfo[idx][eFactionSpawn][1], FactionInfo[idx][eFactionSpawn][2]);

			SetPlayerInterior(playerid, FactionInfo[idx][eFactionSpawnInt]);
			SetPlayerVirtualWorld(playerid, FactionInfo[idx][eFactionSpawnWorld]);
		}
		case SPAWN_POINT_LASTPOS:
		{
		    if(PlayerInfo[playerid][pLastSkin] == 20003)
	 				return SCM(playerid, COLOR_RED, "you're currently wearing the noob skin. This is not ment to be role-played with, please change it.");
            SetPlayerPos(playerid, PlayerInfo[playerid][pLastPos][0], PlayerInfo[playerid][pLastPos][1], PlayerInfo[playerid][pLastPos][2]);
            SetPlayerInterior(playerid, PlayerInfo[playerid][pLastInterior]);
            SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pLastWorld]);
            if(PlayerInfo[playerid][pLastInterior] >= 1){TogglePlayerControllable(playerid, 0);SetTimerEx("Freeze", 5000, false, "i", playerid);}
		}
	}
	return 1;
}

function:OnTaserShoot(playerid)
{
	return SetPlayerArmedWeapon(playerid, WEAPON_SILENCED);
}

function:OnPlayerTasered(playerid)
{
	SetPlayerDrunkLevel(playerid, 1000);
	TogglePlayerControllable(playerid, 1);

	ApplyAnimation(playerid, "PED", "KO_skid_front", 4.1, 0, 1, 1, 1, 0);
	ApplyAnimation(playerid, "PED", "KO_skid_front", 4.1, 0, 1, 1, 1, 0);
	return 1;
}

function:OnPhoneCall(playerid, type)
{
	switch(type)
	{
		case 1:
		{
			SendClientMessage(playerid, COLOR_GREY, "[ ! ] The number you dialed is out of service.");
			playerPhone[playerid] = 0;

			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE){
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			}

			return 1;
		}
		case 2:
		{
			SendClientMessage(playerid, COLOR_GREY, "[ ! ] The number you dialed cannot be reached at this time.");
			playerPhone[playerid] = 0;

			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE){
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			}

			return 1;
		}
		case 3:
		{
			SendClientMessage(playerid, COLOR_GREY, "[ ! ] You received a busy tone.");
			playerPhone[playerid] = 0;

			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE){
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			}

			return 1;
		}
		case 4:
		{
			SendClientMessage(playerid, COLOR_GREY, "[ ! ] You received a busy tone.");
			playerPhone[playerid] = 0;

			if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE){
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
			}

			return 1;
		}
	}
	return 1;
}

function:On911Call(playerid)
{
	SendClientMessage(playerid, COLOR_GREY, "[ ! ] They picked up. You can talk now by using the chat box.");
	Player911Timer[1][playerid] = SetTimerEx("On911Pickup", 1500, false, "i", playerid);
	return 1;
}

function:OnTaxiCall(playerid)
{
	SendClientMessage(playerid, COLOR_GREY, "[ ! ] They picked up. You can talk now by using the chat box.");
	Player911Timer[1][playerid] = SetTimerEx("OnTaxiPickup", 500, false, "i", playerid);
	return 1;
}

function:OnTowCall(playerid)
{
	SendClientMessage(playerid, COLOR_GREY, "[ ! ] They picked up. You can talk now by using the chat box.");
	Player911Timer[1][playerid] = SetTimerEx("OnTowPickup", 500, false, "i", playerid);
	return 1;
}

function:OnTowPickup(playerid)
{
	SendClientMessage(playerid, COLOR_YELLOWEX, "Tierra Robada Tow 'n Co. where and what kind of assistance do you need?");

	PlayerInfo[playerid][pPhoneline] = 457;
	PlayerInfo[playerid][pCalling] = 0;
	return 1;
}

function:OnTaxiPickup(playerid)
{
	SendClientMessage(playerid, COLOR_YELLOWEX, "Tierra Robada Cab 'n Co. where do you need us?");

	PlayerInfo[playerid][pPhoneline] = 686;
	PlayerInfo[playerid][pCalling] = 0;
	return 1;
}

function:On911Pickup(playerid)
{
	SendClientMessage(playerid, COLOR_YELLOWEX, "911 Operator says: 911, what service do you require?");

	PlayerInfo[playerid][pPhoneline] = 911;
	PlayerInfo[playerid][pCalling] = 0;
	return 1;
}

function:OnSuccessCall(playerid)
{
	if(playerid != INVALID_PLAYER_ID){
		PlayNearbySound(playerid, 23000);
		return 1;
	}

	return 0;
}

function:OnPhoneSMS(playerid, type, playerb, text[])
{
	switch(type)
	{
		case 1:
		{
			SendClientMessage(playerid, COLOR_GREY, "[ ! ] Your text failed to deliver.");
			playerText[playerid] = 0;
			return 1;
		}
		case 2:
		{
			SendClientMessage(playerid, COLOR_GREY, "[ ! ] Your text failed to deliver.");
			playerText[playerid] = 0;
			return 1;
		}
		case 3:
		{
			if(!IsPlayerConnected(playerb)) //Possible they disconnect while timer plays;
			{
				SendClientMessage(playerid, COLOR_GREY, "[ ! ] Your text failed to deliver.");
				playerText[playerid] = 0;
				return 1;
			}

			SendClientMessage(playerid, COLOR_GREY, "[ ! ] Your text message delivered.");

			if(strlen(text) > 80)
			{
				SendClientMessageEx(playerb, COLOR_YELLOWEX, "SMS: %.80s ...", text, PlayerInfo[playerid][pPhone]);
				SendClientMessageEx(playerb, COLOR_YELLOWEX, "SMS: ...%s, Sender: %i", text[80], PlayerInfo[playerid][pPhone]);
				printf("Call ;");
			}
			else SendClientMessageEx(playerb, COLOR_YELLOWEX, "SMS: %s, Sender: %i", text, PlayerInfo[playerid][pPhone]);

			playerText[playerid] = 0;
			return 1;
		}
	}
	printf("[OnPhoneSMS] Call 4");
	return 1;
}

function:Float:GetDistanceBetweenPoints(Float:rx1,Float:ry1,Float:rz1,Float:rx2,Float:ry2,Float:rz2)
{
	return floatadd(floatadd(floatsqroot(floatpower(floatsub(rx1,rx2),2)),floatsqroot(floatpower(floatsub(ry1,ry2),2))),floatsqroot(floatpower(floatsub(rz1,rz2),2)));
}

function:OnAjailRecord(playerid)
{
	if(!cache_num_rows())
		return SendClientMessage(playerid, COLOR_RED, "[ ! ] {FFFFFF}This player hasn't been admin jailed.");

	new rows, fields;
	cache_get_data(rows, fields, ourConnection);

	new
		JailedName[32],
		Reason[128],
		Date[90],
		JailedBy[32],
		Time
	;

	for(new i = 0; i < rows; i++)
	{
		cache_get_field_content(i, "JailedName", JailedName, ourConnection, 32);
		cache_get_field_content(i, "Reason", Reason, ourConnection, 128);

		cache_get_field_content(i, "Date", Date, ourConnection, 90);
		cache_get_field_content(i, "JailedBy", JailedBy, ourConnection, 32);

		Time = cache_get_field_content_int(i, "Time", ourConnection);

		SendClientMessageEx(playerid, COLOR_ACTION, "[%s] %s was admin jailed by %s for %d minutes, Reason: %s", Date, JailedName, JailedBy, Time, Reason);
	}

	return 1;
}

//Stock functions:
stock randomEx(min, max)
{
    new randm = random(max-min)+min;
    return randm;
}

stock IsAFireArm(playerid) {
	switch(GetPlayerWeapon(playerid))
	{
		case 16 .. 18,22 .. 39: return 1;
	}
	return 0;
}

stock IsABoat(carid) {
	switch(GetVehicleModel(carid))
	{
		case 472,473,595,493,430,453,484,446,452,454: return 1;
	}
	return 0;
}

stock IsSmuggleBoat(carid) {
	switch(GetVehicleModel(carid))
	{
		case 446,453,454,473: return 1;
	}
	return 0;
}

stock IsPlayerInRangeOfVehicle(playerid, vehicleid, Float: radius) {

	new
		Float:Floats[3];

	GetVehiclePos(vehicleid, Floats[0], Floats[1], Floats[2]);
	return IsPlayerInRangeOfPoint(playerid, radius, Floats[0], Floats[1], Floats[2]);
}

stock IsAPlane(carid, type = 0)
{
	if(type == 0)
	{
		switch(GetVehicleModel(carid)) {
			case 592, 577, 511, 512, 593, 520, 553, 476, 519, 460, 513, 548, 425, 417, 487, 488, 497, 563, 447, 469: return 1;
		}
	}
	else
	{
		switch(carid) {
			case 592, 577, 511, 512, 593, 520, 553, 476, 519, 460, 513, 548, 425, 417, 487, 488, 497, 563, 447, 469: return 1;
		}
	}
	return 0;
}

stock IsABike(carid) {
	switch(GetVehicleModel(carid))
	{
		case 509, 481, 510, 462, 448, 581, 522, 461, 521, 523, 463, 586, 468, 471: return 1;
	}
	return 0;
}

stock IsAmbulance(vehicleid)
{
	switch(GetVehicleModel(vehicleid))
	{
		case 416, 407, 490: return 1;
	}
	return 0;
}

stock CheckDriver(vehicleid)
{
	for(new i = 0; i < MAX_PLAYERS; i++) //Loops through all players
	{
	    if(GetPlayerVehicleID(i) == vehicleid && GetPlayerState(i) == PLAYER_STATE_DRIVER) return i; //Returns playerid if the player is in the vehicleid provided AND is the driver
	}
	return 1;
}

stock Float:DistanceCameraTargetToLocation(Float:CamX, Float:CamY, Float:CamZ,  Float:ObjX, Float:ObjY, Float:ObjZ,  Float:FrX, Float:FrY, Float:FrZ)
{

    new Float:TGTDistance;

    // get distance from camera to target
    TGTDistance = floatsqroot((CamX - ObjX) * (CamX - ObjX) + (CamY - ObjY) * (CamY - ObjY) + (CamZ - ObjZ) * (CamZ - ObjZ));

    new Float:tmpX, Float:tmpY, Float:tmpZ;

    tmpX = FrX * TGTDistance + CamX;
    tmpY = FrY * TGTDistance + CamY;
    tmpZ = FrZ * TGTDistance + CamZ;

    return floatsqroot((tmpX - ObjX) * (tmpX - ObjX) + (tmpY - ObjY) * (tmpY - ObjY) + (tmpZ - ObjZ) * (tmpZ - ObjZ));
}

stock IsVehicleSeatUsed(vehicleid, seat)
{
	foreach (new i : Player) if (IsPlayerInVehicle(i, vehicleid) && GetPlayerVehicleSeat(i) == seat) {
	    return 1;
	}
	return 0;
}

stock GetDistanceToCar(playerid, veh, Float: posX = 0.0, Float: posY = 0.0, Float: posZ = 0.0) {

	new
	    Float: Floats[2][3];

	if(posX == 0.0 && posY == 0.0 && posZ == 0.0) {
		if(!IsPlayerInAnyVehicle(playerid)) GetPlayerPos(playerid, Floats[0][0], Floats[0][1], Floats[0][2]);
		else GetVehiclePos(GetPlayerVehicleID(playerid), Floats[0][0], Floats[0][1], Floats[0][2]);
	}
	else {
		Floats[0][0] = posX;
		Floats[0][1] = posY;
		Floats[0][2] = posZ;
	}
	GetVehiclePos(veh, Floats[1][0], Floats[1][1], Floats[1][2]);
	return floatround(floatsqroot((Floats[1][0] - Floats[0][0]) * (Floats[1][0] - Floats[0][0]) + (Floats[1][1] - Floats[0][1]) * (Floats[1][1] - Floats[0][1]) + (Floats[1][2] - Floats[0][2]) * (Floats[1][2] - Floats[0][2])));
}

stock GetClosestCar(iPlayer, iException = INVALID_VEHICLE_ID, Float: fRange = Float: 0x7F800000) {

	new
		iReturnID = INVALID_VEHICLE_ID,
		Float: fVehiclePos[4];

	for(new i = 1; i <= MAX_VEHICLES; ++i) if(GetVehicleModel(i) && i != iException) {
		GetVehiclePos(i, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2]);
		if((fVehiclePos[3] = GetPlayerDistanceFromPoint(iPlayer, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2])) < fRange) {
			fRange = fVehiclePos[3];
			iReturnID = i;
		}
	}
	return iReturnID;
}

stock GetPlayerSpeed(playerid, bool:kmh = true)
{
	new
		Float:xx,
		Float:yy,
		Float:zz,
		Float:pSpeed;

	if(IsPlayerInAnyVehicle(playerid))
	{
		GetVehicleVelocity(GetPlayerVehicleID(playerid),xx,yy,zz);
	}
	else
	{
		GetPlayerVelocity(playerid,xx,yy,zz);
	}

	pSpeed = floatsqroot((xx * xx) + (yy * yy) + (zz * zz));
	return kmh ? floatround((pSpeed * 165.12)) : floatround((pSpeed * 103.9));
}

stock ApplyPlayerAnimation(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
{
    ApplyAnimation(playerid, animlib, "null", fDelta, loop, lockx, locky, freeze, time, forcesync); // Pre-load animation library
    return ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
}
stock PreloadAnimations(playerid)
{
	for (new i = 0; i < sizeof(g_aPreloadLibs); i ++) {
	    ApplyAnimation(playerid, g_aPreloadLibs[i], "null", 4.0, 0, 0, 0, 0, 0, 1);
	}
	return 1;
} // Credits to Emmet, South Central Roleplay

stock SendClientMessageEx(playerid, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[156]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 156
		#emit PUSH.C string
		#emit PUSH.C args
		#emit SYSREQ.C format

		SendClientMessage(playerid, color, string);

		#emit LCTRL 5
		#emit SCTRL 4
		#emit RETN
	}
	return SendClientMessage(playerid, color, str);
} // Credits to Emmet, South Central Roleplay

stock SendClientMessageToAllEx(color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.pri args
		#emit ADD.C 4
		#emit PUSH.pri
		#emit SYSREQ.C format

        #emit LCTRL 5
		#emit SCTRL 4

		foreach (new i : Player) {
			SendClientMessage(i, color, string);
		}
		return 1;
	}
	return SendClientMessageToAll(color, str);
} // Credits to Emmet, South Central Roleplay

stock SendNearbyMessage(playerid, Float:radius, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 16)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 16); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit CONST.alt 4
		#emit SUB
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
			if (IsPlayerNearPlayer(i, playerid, radius)) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (IsPlayerNearPlayer(i, playerid, radius)) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
} // Credits to Emmet, South Central Roleplay

stock SendAdminMessage(level, const str[])
{
	new newString[128];

	format(newString, sizeof(newString), "AdmWarn: %s", str);

	foreach(new i : Player)
	{
		if(PlayerInfo[i][pAdmin] >= level)
		{
			SendClientMessage(i, COLOR_RED, newString);
		}
	}
	return 1;
}

stock SendAdminMessageEx(color, level, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
			if (PlayerInfo[i][pAdmin] >= level) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (PlayerInfo[i][pAdmin] >= level) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
} // Credits to Emmet, South Central Roleplay

stock SendFactionMessage(playerid, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
			if (PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction]) {
				if(PlayerInfo[i][pFactionChat] == false)
  				{
					SendClientMessage(i, FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatColor], string);
				}
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction]) {
			if(PlayerInfo[i][pFactionChat] == false)
  			{
				SendClientMessage(i, FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatColor], str);
			}
		}
	}
	return 1;
} // Credits to Emmet, South Central Roleplay


stock SendPoliceMessage(color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
			if (FactionInfo[PlayerInfo[i][pFaction]][eFactionType] == FACTION_TYPE_POLICE) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (FactionInfo[PlayerInfo[i][pFaction]][eFactionType] == FACTION_TYPE_POLICE) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}

stock GetAvailableSeat(vehicleid, start = 1)
{
	new seats = GetVehicleMaxSeats(vehicleid);

	for (new i = start; i < seats; i ++) if (!IsVehicleSeatUsed(vehicleid, i)) {
	    return i;
	}
	return -1;
}

stock RemoveFromVehicle(playerid)
{
	if (IsPlayerInAnyVehicle(playerid))
	{
		static
		    Float:fX,
	    	Float:fY,
	    	Float:fZ;

		GetPlayerPos(playerid, fX, fY, fZ);
		SetPlayerPos(playerid, fX, fY, fZ + 1.5);
	}
	return 1;
}

stock GetVehicleMaxSeats(vehicleid)
{
    static const g_arrMaxSeats[] = {
		4, 2, 2, 2, 4, 4, 1, 2, 2, 4, 2, 2, 2, 4, 2, 2, 4, 2, 4, 2, 4, 4, 2, 2, 2, 1, 4, 4, 4, 2,
		1, 7, 1, 2, 2, 0, 2, 7, 4, 2, 4, 1, 2, 2, 2, 4, 1, 2, 1, 0, 0, 2, 1, 1, 1, 2, 2, 2, 4, 4,
		2, 2, 2, 2, 1, 1, 4, 4, 2, 2, 4, 2, 1, 1, 2, 2, 1, 2, 2, 4, 2, 1, 4, 3, 1, 1, 1, 4, 2, 2,
		4, 2, 4, 1, 2, 2, 2, 4, 4, 2, 2, 1, 2, 2, 2, 2, 2, 4, 2, 1, 1, 2, 1, 1, 2, 2, 4, 2, 2, 1,
		1, 2, 2, 2, 2, 2, 2, 2, 2, 4, 1, 1, 1, 2, 2, 2, 2, 7, 7, 1, 4, 2, 2, 2, 2, 2, 4, 4, 2, 2,
		4, 4, 2, 1, 2, 2, 2, 2, 2, 2, 4, 4, 2, 2, 1, 2, 4, 4, 1, 0, 0, 1, 1, 2, 1, 2, 2, 1, 2, 4,
		4, 2, 4, 1, 0, 4, 2, 2, 2, 2, 0, 0, 7, 2, 2, 1, 4, 4, 4, 2, 2, 2, 2, 2, 4, 2, 0, 0, 0, 4,
		0, 0
	};
	new
	    model = GetVehicleModel(vehicleid);

	if (400 <= model <= 611)
	    return g_arrMaxSeats[model - 400];

	return 0;
}

stock SendFactionMessageEx(playerid, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
			if (PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction]) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction]) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
} // Credits to Emmet, South Central Roleplay

stock SendFactionMessageAll(color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    playerid,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
			if (FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_MEDICAL && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_DOC) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_POLICE && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_MEDICAL && FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_DOC) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
} // Credits to Emmet, South Central Roleplay

stock SendMedicalMessage(color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    playerid,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
			if (FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_MEDICAL) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType] != FACTION_TYPE_MEDICAL) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}

stock SendUnauthMessage(playerid)
{
	return SendClientMessage(playerid, COLOR_RED, "ACCESS DENIED:{FFFFFF} You aren't authorized to use this.");
}

stock SendTeleportMessage(playerid)
{
	return SendClientMessage(playerid, COLOR_GREY, "You were teleported.");
}

stock IsPlayerNearPlayer(playerid, targetid, Float:radius)
{
	static
		Float:fX,
		Float:fY,
		Float:fZ;

	GetPlayerPos(targetid, fX, fY, fZ);

	return (GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) && IsPlayerInRangeOfPoint(playerid, radius, fX, fY, fZ);
}

stock IsValidRoleplayName(const name[]) {
	if (!name[0] || strfind(name, "_") == -1)
	    return 0;

	else for (new i = 0, len = strlen(name); i != len; i ++) {
	    if ((i == 0) && (name[i] < 'A' || name[i] > 'Z'))
	        return 0;

		else if ((i != 0 && i < len  && name[i] == '_') && (name[i + 1] < 'A' || name[i + 1] > 'Z'))
		    return 0;

		else if ((name[i] < 'A' || name[i] > 'Z') && (name[i] < 'a' || name[i] > 'z') && name[i] != '_' && name[i] != '.')
		    return 0;
	}
	return 1;
}

stock ReturnName(playerid, underScore = 1)
{
	new playersName[MAX_PLAYER_NAME + 2];
	GetPlayerName(playerid, playersName, sizeof(playersName));

	if(!underScore)
	{
		if(PlayerInfo[playerid][pMasked])
			format(playersName, sizeof(playersName), "[Mask %i_%i]", PlayerInfo[playerid][pMaskID][0], PlayerInfo[playerid][pMaskID][1]);

		else
		{
			for(new i = 0, j = strlen(playersName); i < j; i ++)
			{
				if(playersName[i] == '_')
				{
					playersName[i] = ' ';
				}
			}
		}
	}

	return playersName;
}

stock KickEx(playerid)
{
	return SetTimerEx("KickTimer", 100, false, "i", playerid);
}

stock ClearLines(playerid, lines)
{
	if (lines > 20 || lines < 1)
		return 0;

	for (new i = 0; i < lines; i++)
	{
		SendClientMessage(playerid, -1, " ");
	}
	return 1;
}

stock strreplace(string[], find, replace)
{
    for(new i=0; string[i]; i++)
	{
        if(string[i] == find)
		{
            string[i] = replace;
        }
    }
}

stock ReturnDate()
{
	new sendString[90], MonthStr[40], month, day, year;
	new hour, minute, second;

	gettime(hour, minute, second);
	getdate(year, month, day);
	switch(month)
	{
	    case 1:  MonthStr = "January";
	    case 2:  MonthStr = "February";
	    case 3:  MonthStr = "March";
	    case 4:  MonthStr = "April";
	    case 5:  MonthStr = "May";
	    case 6:  MonthStr = "June";
	    case 7:  MonthStr = "July";
	    case 8:  MonthStr = "August";
	    case 9:  MonthStr = "September";
	    case 10: MonthStr = "October";
	    case 11: MonthStr = "November";
	    case 12: MonthStr = "December";
	}

	format(sendString, 90, "%s %d, %d %02d:%02d:%02d", MonthStr, day, year, hour, minute, second);
	return sendString;
}

stock ReturnTicketTime()
{
	new sendString[90],hour, minute;

	gettime(hour, minute);

	format(sendString, 90, "%02d:%02d", hour, minute);
	return sendString;
}

stock ReturnTicketDate()
{
	new sendString[90], MonthStr[40], month, day, year;

	getdate(year, month, day);
	switch(month)
	{
	    case 1:  MonthStr = "January";
	    case 2:  MonthStr = "February";
	    case 3:  MonthStr = "March";
	    case 4:  MonthStr = "April";
	    case 5:  MonthStr = "May";
	    case 6:  MonthStr = "June";
	    case 7:  MonthStr = "July";
	    case 8:  MonthStr = "August";
	    case 9:  MonthStr = "September";
	    case 10: MonthStr = "October";
	    case 11: MonthStr = "November";
	    case 12: MonthStr = "December";
	}

	format(sendString, 90, "%s %d, %d", MonthStr, day, year);
	return sendString;
}

stock ShowCharacterStats(playerid, playerb)
{
	// playerid = player's statistics;
	// playerb = player receiving stats;

	new
		vehicle_key[20],
		duplicate_key[20],
		business_key[20] = "None"
	;

	if(PlayerInfo[playerid][pDuplicateKey] == INVALID_VEHICLE_ID)
		duplicate_key = "None";
	else format(duplicate_key, 32, "%d", PlayerInfo[playerid][pDuplicateKey]);

	for(new i = 1; i < MAX_BUSINESS; i++)
	{
		if(!BusinessInfo[i][eBusinessDBID])
			continue;

		if(BusinessInfo[i][eBusinessOwnerDBID] == PlayerInfo[playerid][pDBID])
			format(business_key, 20, "%d", BusinessInfo[i][eBusinessDBID]);
	}

	SendClientMessageEx(playerb, COLOR_DARKGREEN, "|__________________%s [%s]__________________|", ReturnName(playerid), ReturnDate());

	SendClientMessageEx(playerb, COLOR_GRAD2, "CHARACTER: Faction:[%s] Rank:[%s]", ReturnFactionName(playerid), ReturnFactionRank(playerid));
	SendClientMessageEx(playerb, COLOR_GRAD1, "EXPERIENCE: Level:[%d] Experience:[%d/%d] Time played:[%d hours]", PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pEXP], ((PlayerInfo[playerid][pLevel]) * 4 + 2), PlayerInfo[playerid][pTimeplayed]);
	SendClientMessageEx(playerb, COLOR_GRAD2, "WEAPONS: Primary weapon:[%s] Ammo:[%d] Secondary weapon:[%s] Ammo:[%d]", ShowPlayerWeapons(playerid, 4), PlayerInfo[playerid][pWeaponsAmmo][3], ShowPlayerWeapons(playerid, 3), PlayerInfo[playerid][pWeaponsAmmo][2]);
	SendClientMessageEx(playerb, COLOR_GRAD1, "INVENTORY: Phone:[%d] Radio:[%s] Channel:[%d] Mask:[%s] Melee:[%s]", PlayerInfo[playerid][pPhone], (PlayerInfo[playerid][pHasRadio] != true) ? ("No") : ("Yes"), PlayerInfo[playerid][pRadio][PlayerInfo[playerid][pMainSlot]], (PlayerInfo[playerid][pHasMask] != true) ? ("No") : ("Yes"), ShowPlayerWeapons(playerid, 1));
	SendClientMessageEx(playerb, COLOR_GRAD2, "MONEY: Cash:[$%s] Bank:[$%s] Paycheck:[$%s]", MoneyFormat(PlayerInfo[playerid][pMoney]), MoneyFormat(PlayerInfo[playerid][pBank]), MoneyFormat(PlayerInfo[playerid][pPaycheck]));
	SendClientMessageEx(playerb, COLOR_GRAD1, "OTHER: VehicleKey:[%s] DuplicateKey:[%s] BusinessKey:[%s]", vehicle_key, duplicate_key, business_key);

	if(PlayerInfo[playerb][pAdmin])
	{
		SendClientMessageEx(playerb, COLOR_GRAD1, "FOR ADMIN: DBID:[%d] Master:[%s (%d)] Interior:[%d] Local:[%d]", PlayerInfo[playerid][pDBID], e_pAccountData[playerid][mAccName], e_pAccountData[playerid][mDBID], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));

		SendClientMessageEx(playerb, COLOR_GRAD2, "CONNECTION: IP:[%s] Last Online:[%s] Duration:[%d Minutes]", ReturnIP(playerid), ReturnLastOnline(playerid), PlayerInfo[playerid][pLastOnlineTime]);

		SendClientMessageEx(playerb, COLOR_GRAD1, "MISC: InsideProperty:[%i] InsideBusiness:[%i]", IsPlayerInProperty(playerid), IsPlayerInBusiness(playerid));
	}

	SendClientMessageEx(playerb, COLOR_DARKGREEN, "|__________________%s [%s]__________________|", ReturnName(playerid), ReturnDate());

	return 1;
}

stock ReturnIP(playerid)
{
	new
		ipAddress[20];

	GetPlayerIp(playerid, ipAddress, sizeof(ipAddress));
	return ipAddress;
}

stock ReturnGPCI(playerid)
{
	new szSerial[41]; // 40 + \0

	gpci(playerid, szSerial, sizeof(szSerial));
	return szSerial;
}

stock ReturnLastOnline(playerid)
{
	new returnString[90];

	if(isnull(PlayerInfo[playerid][pLastOnline]))
		returnString = "Never";

	else
		format(returnString, 90, "%s", PlayerInfo[playerid][pLastOnline]);

	return returnString;
}

stock ConfirmDialog(playerid, caption[], info[], callback[], {Float,_}:...)
{
	new n = numargs(), 		// number of arguments, static + optional
		szParamHash[256];	// variable where the passed arguments will be stored
	for(new arg = 4; arg < n; arg++){	// loop all additional arguments
		format(szParamHash, sizeof(szParamHash), "%s%d|", szParamHash, getarg(arg)); // store them in szParamHash
	}
	SetPVarInt(playerid, "confDialogArgs", n -4);			// store the amount of additional arguments
	SetPVarString(playerid, "confDialCallback", callback);	// store the callback that needs to be called after response
	SetPVarString(playerid, "confDialog_arg", szParamHash);	// store the additional arguments

	ShowPlayerDialog(playerid, DIALOG_CONFIRM_SYS, DIALOG_STYLE_MSGBOX, caption, info, "Yes", "No"); // display the dialog message itself

	return;
} // Credits to Mmartin (SA-MP forums)

stock ConfirmDialog_Response(playerid, response)
{
	new szCallback[33],		// variable to fetch our callback to
		szParamHash[64], 	// variable to check raw compressed argument string
		n,					// variable to fetch the amount of additional arguments
		szForm[12];			// variable to generate the CallLocalFunction() "format" argument

	n = GetPVarInt(playerid, "confDialogArgs");	// Fetch the amount of additional arguments
	GetPVarString(playerid, "confDialCallback", szCallback, sizeof(szCallback));	// fetch the callback
	GetPVarString(playerid, "confDialog_arg", szParamHash, sizeof(szParamHash));	// fetch the raw compressed additional arguments

	new hashDecoded[12];	// variable to store extracted additional arguments from the ConfirmDialog() generated string

	sscanf(szParamHash, "p<|>A<d>(0)[12]", hashDecoded);	// extraction of the additional arguments

	new args, 	// amount of cells passed to CallLocalFunction
		addr, 	// pointer address variable for later use
		i;		// i

	format(szForm, sizeof(szForm), "dd");	// static parameters for the callback, "playerid" and "response"

	#emit ADDR.pri hashDecoded	// get pointer address of the extracted additional arguments
	#emit STOR.S.pri addr		// store the pointer address in variable 'addr'
	if(n){	// if there's any additional arguments
		for(i = addr + ((n-1) * 4); i >= addr; i-=4){ // loops all additional arguments by their addresses
			format(szForm, sizeof(szForm), "%sd", szForm); // adds an aditional specifier to the "format" parameter of CallLocalFunction
			#emit load.s.pri i	// load the argument at the current address
			#emit push.pri		// push it to the CallLocalFunction argument list
			args+=4;			// increase used cell number by 4
		}
	}


	args+=16;	// preserve 4 more arguments for CallLocalFunction (16 cause 4 args by 4 cells (4*4))

	#emit ADDR.pri response				// fetch "response" pointer address to the primary buffer
	#emit push.pri						// push it to the argument list

	#emit ADDR.pri playerid				// fetch "playerid" pointer address to the primary buffer
	#emit push.pri						// push it to the argument list

	#emit push.adr szForm				// push the szForm ("format") to the argument list by its referenced address
	#emit push.adr szCallback			// push the szCallback (custom callback) to the argument list by its referenced address
	#emit push.s args					// push the amount of arguments
	#emit sysreq.c CallLocalFunction	// call the function

	// Clear used data
	#emit LCTRL 4
	#emit LOAD.S.ALT args
	#emit ADD.C 4
	#emit ADD
	#emit SCTRL 4

	// Clear used PVars
	DeletePVar(playerid, "confDialCallback");
	DeletePVar(playerid, "confDialog_arg");
	DeletePVar(playerid, "confDialogArgs");

	return;
} // Credits to Mmartin (SA-MP forums)

stock PlayNearbySound(playerid, sound)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(playerid, x, y, z);

	foreach (new i : Player) if (IsPlayerInRangeOfPoint(i, 15.0, x, y, z)) {
	    PlayerPlaySound(i, sound, x, y, z);
	}
	return 1;
}

stock SaveFactions()
{
	for (new i = 1; i < MAX_FACTIONS; i ++)
	{
		if(FactionInfo[i][eFactionDBID])
		{
			SaveFaction(i);
		}
	}
	return 1;
}

stock SaveProperties()
{
	for(new i = 1; i < MAX_PROPERTY; i++)
	{
		if(!PropertyInfo[i][ePropertyDBID])
			continue;

		SaveProperty(i);
	}
	return 1;
}

stock SaveBusinesses()
{
	for(new i = 1; i < MAX_BUSINESS; i++)
	{
		if(!BusinessInfo[i][eBusinessDBID])
			continue;

		SaveBusiness(i);
	}
	return 1;
}

stock SaveFaction(id)
{
	if(!FactionInfo[id][eFactionDBID])
		return 0;

	new threadSave[256];

	mysql_format(ourConnection, threadSave, sizeof(threadSave), "UPDATE factions SET FactionName = '%e', FactionAbbrev = '%e', FactionJoinRank = %i, FactionAlterRank = %i, FactionChatRank = %i, FactionTowRank = %i, FactionType = %i, FactionChatColor = %i WHERE DBID = %i",
		FactionInfo[id][eFactionName],
		FactionInfo[id][eFactionAbbrev],
		FactionInfo[id][eFactionJoinRank],
		FactionInfo[id][eFactionAlterRank],
		FactionInfo[id][eFactionChatRank],
		FactionInfo[id][eFactionTowRank],
		FactionInfo[id][eFactionType],
		FactionInfo[id][eFactionChatColor],
		FactionInfo[id][eFactionDBID]);
	mysql_tquery(ourConnection, threadSave);

	mysql_format(ourConnection, threadSave, sizeof(threadSave), "UPDATE factions SET FactionSpawnX = %f, FactionSpawnY = %f, FactionSpawnZ = %f, FactionInterior = %i, FactionWorld = %i WHERE DBID = %i",
		FactionInfo[id][eFactionSpawn][0],
		FactionInfo[id][eFactionSpawn][1],
		FactionInfo[id][eFactionSpawn][2],
		FactionInfo[id][eFactionSpawnInt],
		FactionInfo[id][eFactionSpawnWorld],
		FactionInfo[id][eFactionDBID]);
	mysql_tquery(ourConnection, threadSave);
	return 1;
}

stock SaveFactionRanks(id)
{
	if(!FactionInfo[id][eFactionDBID])
		return 0;

	new threadSave[256];

	for(new i = 1; i < MAX_FACTION_RANKS; i++)
	{
		mysql_format(ourConnection, threadSave, sizeof(threadSave), "UPDATE faction_ranks SET FactionRank%i = %i WHERE factionid = %i", i, FactionRanks[id][i], FactionInfo[id][eFactionDBID]);
		mysql_tquery(ourConnection, threadSave);
	}

	return 1;
}

stock SaveVehicle(vehicleid)
{
	new query[1550];

	mysql_format(ourConnection, query, sizeof(query), "UPDATE vehicles SET VehicleOwnerDBID = %i, VehicleFaction = %i, VehicleColor1 = %i, VehicleColor2 = %i, VehiclePaintjob = %i, VehiclePlates = '%e', VehicleLocked = %i, VehicleSirens = %i, VehicleFuel = %f WHERE VehicleDBID = %i",
		VehicleInfo[vehicleid][eVehicleOwnerDBID],
		VehicleInfo[vehicleid][eVehicleFaction],
		VehicleInfo[vehicleid][eVehicleColor1],
		VehicleInfo[vehicleid][eVehicleColor2],
		VehicleInfo[vehicleid][eVehiclePaintjob],
		VehicleInfo[vehicleid][eVehiclePlates],
		VehicleInfo[vehicleid][eVehicleLocked],
		VehicleInfo[vehicleid][eVehicleSirens],
		VehicleInfo[vehicleid][eVehicleFuel],
		VehicleInfo[vehicleid][eVehicleDBID]);
	mysql_tquery(ourConnection, query);

	mysql_format(ourConnection, query, sizeof(query), "UPDATE vehicles SET VehicleID = %i, VehicleXMR = %i, VehicleBattery = %f, VehicleEngine = %f, VehicleTimesDestroyed = %i WHERE VehicleDBID = %i",
		VehicleInfo[vehicleid][eVehicleID],
		VehicleInfo[vehicleid][eVehicleHasXMR],
		VehicleInfo[vehicleid][eVehicleBattery],
		VehicleInfo[vehicleid][eVehicleEngine],
		VehicleInfo[vehicleid][eVehicleTimesDestroyed],
		VehicleInfo[vehicleid][eVehicleDBID]);
	mysql_tquery(ourConnection, query);

	mysql_format(ourConnection, query, sizeof(query), "UPDATE vehicles SET VehicleParkPosX = %f, VehicleParkPosY = %f, VehicleParkPosZ = %f, VehicleParkPosA = %f, VehicleParkInterior = %i, VehicleParkWorld = %i WHERE VehicleDBID = %i",
		VehicleInfo[vehicleid][eVehicleParkPos][0],
		VehicleInfo[vehicleid][eVehicleParkPos][1],
		VehicleInfo[vehicleid][eVehicleParkPos][2],
		VehicleInfo[vehicleid][eVehicleParkPos][3],
		VehicleInfo[vehicleid][eVehicleParkInterior],
		VehicleInfo[vehicleid][eVehicleParkWorld],
		VehicleInfo[vehicleid][eVehicleDBID]);
	mysql_tquery(ourConnection, query);

	mysql_format(ourConnection, query, sizeof(query), "UPDATE vehicles SET VehicleImpounded = %i, VehicleImpoundPosX = %f, VehicleImpoundPosY = %f, VehicleImpoundPosZ = %f, VehicleImpoundPosA = %f WHERE VehicleDBID = %i",
		VehicleInfo[vehicleid][eVehicleImpounded],
		VehicleInfo[vehicleid][eVehicleImpoundPos][0],
		VehicleInfo[vehicleid][eVehicleImpoundPos][1],
		VehicleInfo[vehicleid][eVehicleImpoundPos][2],
		VehicleInfo[vehicleid][eVehicleImpoundPos][3],
		VehicleInfo[vehicleid][eVehicleDBID]);
	mysql_tquery(ourConnection, query);

	for(new i = 1; i < 6; i++)
	{
		mysql_format(ourConnection, query, sizeof(query), "UPDATE vehicles SET VehicleWeapons%d = %i, VehicleWeaponsAmmo%d = %i WHERE VehicleDBID = %i",
			i,
			VehicleInfo[vehicleid][eVehicleWeapons][i],
			i,
			VehicleInfo[vehicleid][eVehicleWeaponsAmmo][i],
			VehicleInfo[vehicleid][eVehicleDBID]);
		mysql_tquery(ourConnection, query);
	}

	for(new j = 1; j < 5; j++)
	{
		mysql_format(ourConnection, query, sizeof(query), "UPDATE vehicles SET VehicleLastDrivers%d = %i, VehicleLastPassengers%d = %i WHERE VehicleDBID = %i",
			j,
			VehicleInfo[vehicleid][eVehicleLastDrivers][j],
			j,
			VehicleInfo[vehicleid][eVehicleLastPassengers][j],
			VehicleInfo[vehicleid][eVehicleDBID]);
		mysql_tquery(ourConnection, query);

	}
	return 1;
}

stock SaveProperty(id)
{
	new query[312];

	mysql_format(ourConnection, query, sizeof(query), "UPDATE properties SET PropertyAdress = '%e', PropertyOwnerDBID = %i, PropertyType = %i, PropertyFaction = %i, PropertyLocked = %i, PropertyCashbox = %i, PropertyLevel = %i, PropertyMarketPrice = %i, PropertyHasBoombox = %i WHERE PropertyDBID = %i",
        PropertyInfo[id][ePropertyAdress],
		PropertyInfo[id][ePropertyOwnerDBID],
		PropertyInfo[id][ePropertyType],
		PropertyInfo[id][ePropertyFaction],
		PropertyInfo[id][ePropertyLocked],
		PropertyInfo[id][ePropertyCashbox],
		PropertyInfo[id][ePropertyLevel],
		PropertyInfo[id][ePropertyMarketPrice],
		PropertyInfo[id][ePropertyHasBoombox],
		PropertyInfo[id][ePropertyDBID]);
	mysql_tquery(ourConnection, query);

	mysql_format(ourConnection, query, sizeof(query), "UPDATE properties SET PropertyEntranceX = %f, PropertyEntranceY = %f, PropertyEntranceZ = %f, PropertyEntranceInterior = %i, PropertyEntranceWorld = %i WHERE PropertyDBID = %i",
		PropertyInfo[id][ePropertyEntrance][0],
		PropertyInfo[id][ePropertyEntrance][1],
		PropertyInfo[id][ePropertyEntrance][2],
		PropertyInfo[id][ePropertyEntranceInterior],
		PropertyInfo[id][ePropertyEntranceWorld],
		PropertyInfo[id][ePropertyDBID]);
	mysql_tquery(ourConnection, query);

	mysql_format(ourConnection, query, sizeof(query), "UPDATE properties SET PropertyInteriorX = %f, PropertyInteriorY = %f, PropertyInteriorZ = %f, PropertyInteriorIntID = %i, PropertyInteriorWorld = %i WHERE PropertyDBID = %i",
		PropertyInfo[id][ePropertyInterior][0],
		PropertyInfo[id][ePropertyInterior][1],
		PropertyInfo[id][ePropertyInterior][2],
		PropertyInfo[id][ePropertyInteriorIntID],
		PropertyInfo[id][ePropertyInteriorWorld],
		PropertyInfo[id][ePropertyDBID]);
	mysql_tquery(ourConnection, query);

	mysql_format(ourConnection, query, sizeof(query), "UPDATE properties SET PropertyPlacePosX = %f, PropertyPlacePosY = %f, PropertyPlacePosZ = %f WHERE PropertyDBID = %i",
		PropertyInfo[id][ePropertyPlacePos][0],
		PropertyInfo[id][ePropertyPlacePos][1],
		PropertyInfo[id][ePropertyPlacePos][2],
		PropertyInfo[id][ePropertyDBID]);
	mysql_tquery(ourConnection, query);

	mysql_format(ourConnection, query, sizeof(query), "UPDATE properties SET PropertyBoomboxPosX = %f, PropertyBoomboxPosY = %f, PropertyBoomboxPosZ = %f, PropertyBoomboxRotX = %f, PropertyBoomboxRotY = %f, PropertyBoomboxRotZ = %f WHERE PropertyDBID = %i",
		PropertyInfo[id][ePropertyBoomboxPos][0],
		PropertyInfo[id][ePropertyBoomboxPos][1],
		PropertyInfo[id][ePropertyBoomboxPos][2],
		PropertyInfo[id][ePropertyBoomboxRot][0],
		PropertyInfo[id][ePropertyBoomboxRot][1],
		PropertyInfo[id][ePropertyBoomboxRot][2],
		PropertyInfo[id][ePropertyDBID]);
	mysql_tquery(ourConnection, query);

	return 1;
}

stock SaveBusiness(id)
{
	new query[400];

	mysql_format(ourConnection, query, sizeof(query), "UPDATE businesses SET BusinessOwnerDBID = %i, BusinessName = '%e', BusinessType = %i, BusinessLocked = %i, BusinessEntranceFee = %i, BusinessLevel = %i, BusinessCashbox = %i, BusinessProducts = %i, BusinessMarketPrice = %i WHERE BusinessDBID = %i",
		BusinessInfo[id][eBusinessOwnerDBID],
		BusinessInfo[id][eBusinessName],
		BusinessInfo[id][eBusinessType],
		BusinessInfo[id][eBusinessLocked],
		BusinessInfo[id][eBusinessEntranceFee],
		BusinessInfo[id][eBusinessLevel],
		BusinessInfo[id][eBusinessCashbox],
		BusinessInfo[id][eBusinessProducts],
		BusinessInfo[id][eBusinessMarketPrice],
		BusinessInfo[id][eBusinessDBID]);
	mysql_tquery(ourConnection, query);

	mysql_format(ourConnection, query, sizeof(query), "UPDATE businesses SET BusinessInteriorX = %f, BusinessInteriorY = %f, BusinessInteriorZ = %f, BusinessInteriorWorld = %i, BusinessInteriorIntID = %i WHERE BusinessDBID = %i",
		BusinessInfo[id][eBusinessInterior][0],
		BusinessInfo[id][eBusinessInterior][1],
		BusinessInfo[id][eBusinessInterior][2],
		BusinessInfo[id][eBusinessInteriorWorld],
		BusinessInfo[id][eBusinessInteriorIntID],
		BusinessInfo[id][eBusinessDBID]);
	mysql_tquery(ourConnection, query);

	mysql_format(ourConnection, query, sizeof(query), "UPDATE businesses SET BusinessEntranceX = %f, BusinessEntranceY = %f, BusinessEntranceZ = %f WHERE BusinessDBID = %i",
		BusinessInfo[id][eBusinessEntrance][0],
		BusinessInfo[id][eBusinessEntrance][1],
		BusinessInfo[id][eBusinessEntrance][2],
		BusinessInfo[id][eBusinessDBID]);
	mysql_tquery(ourConnection, query);

	mysql_format(ourConnection, query, sizeof(query), "UPDATE businesses SET BusinessBankPickupLocX = %f, BusinessBankPickupLocY = %f, BusinessBankPickupLocZ = %f, BusinessBankPickupWorld = %i WHERE BusinessDBID = %i",
		BusinessInfo[id][eBusinessBankPickupLoc][0],
		BusinessInfo[id][eBusinessBankPickupLoc][1],
		BusinessInfo[id][eBusinessBankPickupLoc][2],
		BusinessInfo[id][eBusinessBankPickupWorld],
		BusinessInfo[id][eBusinessDBID]);
	mysql_tquery(ourConnection, query);

	return 1;
}

stock ReturnTotalMembers(factionid)
{
	if(factionid == 0 || !FactionInfo[factionid][eFactionDBID])
		return 0;

	new threadCheck[128], counter;

	mysql_format(ourConnection, threadCheck, sizeof(threadCheck), "SELECT COUNT(*) FROM characters WHERE pFaction = %i", factionid);
	mysql_query(ourConnection, threadCheck);

	counter = cache_get_row_int(0, 0);
	return counter;
}

stock ReturnOnlineMembers(factionid)
{
	new counter;

	foreach(new i : Player)
	{
		if(e_pAccountData[i][mLoggedin] == false)
			continue;

		if(PlayerInfo[i][pFaction] == factionid)
		{
			counter++;
		}
	}
	return counter;
}

stock ReturnFactionName(playerid)
{
	new factionName[90];

	if(!PlayerInfo[playerid][pFaction])
		factionName = "Civilian";

	else
		format(factionName, sizeof(factionName), "%s", FactionInfo[PlayerInfo[playerid][pFaction]][eFactionName]);

	return factionName;
}

stock ReturnFactionNameEx(factionid)
{
	new factionName[90];

	format(factionName, sizeof(factionName), "%s", FactionInfo[factionid][eFactionName]);
	return factionName;
}

stock ReturnFactionAbbrev(factionid)
{
	 new facAbbrev[90];

	 format(facAbbrev, sizeof(facAbbrev), "%s", FactionInfo[factionid][eFactionAbbrev]);
	 return facAbbrev;
}

stock ReturnFactionRank(playerid)
{
	new rankStr[90];

	if(!PlayerInfo[playerid][pFaction])
	{
		rankStr = "No Rank";
	}
	else
	{
		new
			factionid = PlayerInfo[playerid][pFaction],
			rank = PlayerInfo[playerid][pFactionRank];

		format(rankStr, sizeof(rankStr), "%s", FactionRanks[factionid][rank]);
	}
	return rankStr;
}

stock ReturnFactionType(playerid)
{
	if(!PlayerInfo[playerid][pFaction])
		return 0;

	return FactionInfo[PlayerInfo[playerid][pFaction]][eFactionType];
}

static stock g_arrVehicleNames[][] = {
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
    "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach",
    "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow",
    "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
    "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
    "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
    "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
    "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick",
    "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
    "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain",
    "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
    "Fortune", "Cadrona", "SWAT Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
    "Blade", "Streak", "Freight", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
    "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster",
    "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30",
    "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
    "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "LSPD Cruiser", "SFPD Cruiser", "LVPD Cruiser",
    "Police Rancher", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs",
    "Boxville", "Tiller", "Utility Trailer"
};

stock ReturnVehicleName(vehicleid)
{
	new
		model = GetVehicleModel(vehicleid),
		name[32] = "None";

    if (model < 400 || model > 611)
	    return name;

	format(name, sizeof(name), g_arrVehicleNames[model - 400]);
	return name;
}

stock ReturnVehicleModelName(model)
{
	new
	    name[32] = "None";

    if (model < 400 || model > 611)
	    return name;

	format(name, sizeof(name), g_arrVehicleNames[model - 400]);
	return name;
}

stock ResetVehicleVars(vehicleid)
{
	if(vehicleid == INVALID_VEHICLE_ID)
		return 0;

	VehicleInfo[vehicleid][eVehicleDBID] = 0;
	VehicleInfo[vehicleid][eVehicleExists] = false;

	VehicleInfo[vehicleid][eVehicleOwnerDBID] = 0;
	VehicleInfo[vehicleid][eVehicleFaction] = 0;

	VehicleInfo[vehicleid][eVehicleImpounded] = false;
	VehicleInfo[vehicleid][eVehiclePaintjob] = -1;

	VehicleInfo[vehicleid][eVehicleFuel] = 100;

	for(new i = 1; i < 6; i++)
	{
		VehicleInfo[vehicleid][eVehicleWeapons][i] = 0;
		VehicleInfo[vehicleid][eVehicleWeaponsAmmo][i] = 0;
	}

	for(new i = 1; i < 5; i++)
	{
		VehicleInfo[vehicleid][eVehicleLastDrivers][i] = 0;
		VehicleInfo[vehicleid][eVehicleLastPassengers][i] = 0;
	}

	VehicleInfo[vehicleid][eVehicleTowCount] = 0;

	VehicleInfo[vehicleid][eVehicleHasXMR] = false;
	VehicleInfo[vehicleid][eVehicleBattery] = 100.0;
	VehicleInfo[vehicleid][eVehicleEngine] = 100.0;
	VehicleInfo[vehicleid][eVehicleTimesDestroyed] = 0;

	VehicleInfo[vehicleid][eVehicleEngineStatus] = false;
	VehicleInfo[vehicleid][eVehicleLights] = false;
	return 1;
}

stock ToggleVehicleAlarms(vehicleid, bool:alarmstate, time = 5000)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, engine, lights, alarmstate, doors, bonnet, boot, alarmstate);

	if(alarmstate) SetTimerEx("OnVehicleAlarm", time, false, "i", vehicleid);
	return 1;
}

stock ToggleVehicleEngine(vehicleid, bool:enginestate)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, enginestate, lights, alarm, doors, bonnet, boot, objective);
	return 1;
}

stock ToggleVehicleLights(vehicleid, bool:lightstate)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, engine, lightstate, alarm, doors, bonnet, boot, objective);

	VehicleInfo[vehicleid][eVehicleLights] = lightstate;
	return 1;
}

stock GiveMoney(playerid, amount)
{
	PlayerInfo[playerid][pMoney] += amount;
	GivePlayerMoney(playerid, amount);

	new string[128];

	if(amount < 0) {
		format(string, sizeof(string), "~r~$%d", amount);
		GameTextForPlayer(playerid, string, 2000, 1);
	}
	else{
		format(string, sizeof(string), "~g~$%d", amount);
		GameTextForPlayer(playerid, string, 2000, 1);
	}
	return 1;
}

stock IsVehicleOccupied(vehicleid)
{
	foreach(new i : Player){
		if(IsPlayerInVehicle(i, vehicleid))return true;
	}
	return false;
}

stock PlayerHasWeapons(playerid)
{
	new countWeapons = 0;

	for(new i = 0; i < 12; i ++)
	{
		if(PlayerInfo[playerid][pWeapons][i] != 0)
			countWeapons++;
	}
	if(countWeapons == 0)
		return 0;

	if(countWeapons > 0)
		return 1;

	return 1;
}

stock PlayerHasWeapon(playerid, weaponid)
{
	if(PlayerInfo[playerid][pWeapons][ReturnWeaponIDSlot(weaponid)] != weaponid)
		return 0;

	return 1;
}

stock ReturnWeaponIDSlot(weaponid)
{
	new returnID;

	switch(weaponid)
	{
		case 1: returnID = 0;
		case 2 .. 9: returnID = 1;
		case 22 .. 24: returnID = 2;
		case 25, 27: returnID = 3;
		case 28, 29, 32: returnID = 4;
		case 30, 31: returnID = 5;
		case 33, 34: returnID = 6;
		case 35 .. 38: returnID = 7;
		case 39: returnID = 8;
		case 41 .. 43: returnID = 9;
		case 10 .. 15: returnID = 10;
		case 44 .. 46: returnID = 11;
	}
	return returnID;
}

stock WeaponDataSlot(weaponid)
{
	new slot;

	switch (weaponid)
	{
		case 1: slot = 0;
		case 2 .. 9: slot = 1;
		case 10 .. 15: slot = 10;
		case 16 .. 18: slot = 8;
		case 41, 43: slot = 9;
		case 24: slot = 2;
		case 25: slot = 3;
		case 28, 29, 32: slot = 4;
		case 30, 31: slot = 5;
		case 33, 34: slot = 6;
	}
	return slot;
}

stock RemovePlayerWeapon(playerid, weaponid)
{
	if(!IsPlayerConnected(playerid) || weaponid < 0 || weaponid > 50)
	    return;
	new saveweapon[13], saveammo[13];
	for(new slot = 0; slot < 13; slot++)
	    GetPlayerWeaponData(playerid, slot, saveweapon[slot], saveammo[slot]);
	ResetPlayerWeapons(playerid);
	for(new slot; slot < 13; slot++)
	{
		if(saveweapon[slot] == weaponid || saveammo[slot] == 0)
			continue;
		GivePlayerWeapon(playerid, saveweapon[slot], saveammo[slot]);
	}

	GivePlayerWeapon(playerid, 0, 1);
}

stock ReturnWeaponName(weaponid)
{
	new weapon[22];
    switch(weaponid)
    {
        case 0: weapon = "Fists";
        case 18: weapon = "Molotov Cocktail";
        case 44: weapon = "Night Vision Goggles";
        case 45: weapon = "Thermal Goggles";
		case 54: weapon = "Fall";
        default: GetWeaponName(weaponid, weapon, sizeof(weapon));
    }
    return weapon;
}

stock ShowFactionConfig(playerid)
{
	new rankCount, infoString[128], showString[256];

	format(infoString, sizeof(infoString), "Name: %s\n", ReturnFactionName(playerid));
	strcat(showString, infoString);

	format(infoString, sizeof(infoString), "Abbreviation: %s\n", ReturnFactionAbbrev(PlayerInfo[playerid][pFaction]));
	strcat(showString, infoString);

	format(infoString, sizeof(infoString), "Alter Rank: %d\n", FactionInfo[PlayerInfo[playerid][pFaction]][eFactionAlterRank]);
	strcat(showString, infoString);

	format(infoString, sizeof(infoString), "Join Rank: %d\n", FactionInfo[PlayerInfo[playerid][pFaction]][eFactionJoinRank]);
	strcat(showString, infoString);

	format(infoString, sizeof(infoString), "Chat Rank: %d\n", FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatRank]);
	strcat(showString, infoString);

	format(infoString, sizeof(infoString), "Chat Color\n", FactionInfo[PlayerInfo[playerid][pFaction]][eFactionChatColor]);
	strcat(showString, infoString);

	for(new i = 1; i < MAX_FACTION_RANKS; i++)
	{
		if(!strcmp(FactionRanks[PlayerInfo[playerid][pFaction]][i], "NotSet"))
			continue;

		rankCount++;
	}

	format(infoString, sizeof(infoString), "Faction Ranks (%i)\n", rankCount);
	strcat(showString, infoString);

	strcat(showString, "Faction Spawn\n");

	format(infoString, sizeof(infoString), "Tow Rank: %d\n", FactionInfo[PlayerInfo[playerid][pFaction]][eFactionTowRank]);
	strcat(showString, infoString);

	ShowPlayerDialog(playerid, DIALOG_FACTION_CONFIG, DIALOG_STYLE_LIST, "{ADC3E7}Faction Configuration", showString, "Select", "Back");
	return 1;
}

stock HexToInt(string[])
{
    if(!string[0]) return 0;
    new cur = 1, res = 0;
    for(new i = strlen(string); i > 0; i--)
    {
        res += cur * (string[i - 1] - ((string[i - 1] < 58) ? (48) : (55)));
        cur = cur * 16;
    }
    return res;
}

stock ShowUnscrambleTextdraw(playerid, bool:showTextdraw = true)
{
	if(showTextdraw)
	{
		for(new i = 0; i < 7; i++)
		{
			PlayerTextDrawShow(playerid, Unscrambler_PTD[playerid][i]);
		}
	}
	else
	{
		for(new i = 0; i < 7; i++)
		{
			PlayerTextDrawHide(playerid, Unscrambler_PTD[playerid][i]);
		}
	}
	return 1;
}

stock ShowPlayerWeapons(playerid, slotid)
{
	new returnStr[60];

	switch(slotid)
	{
		case 1:
		{
			new str_1slot[60];

			if(!PlayerInfo[playerid][pWeapons][0])
				str_1slot = "None";

			else
				format(str_1slot, 60, "%s", ReturnWeaponName(PlayerInfo[playerid][pWeapons][0]));

			returnStr = str_1slot;
		}
		case 2:
		{
			new str_2slot[60];

			if(!PlayerInfo[playerid][pWeapons][1])
				str_2slot = "None";

			else
				format(str_2slot, 60, "%s", ReturnWeaponName(PlayerInfo[playerid][pWeapons][1]));

			returnStr = str_2slot;
		}
		case 3:
		{
			new str_3slot[60];

			if(!PlayerInfo[playerid][pWeapons][2])
				str_3slot = "None";

			else
				format(str_3slot, 60, "%s", ReturnWeaponName(PlayerInfo[playerid][pWeapons][2]));

			returnStr = str_3slot;
		}
		case 4:
		{
			new str_4slot[60];

			if(!PlayerInfo[playerid][pWeapons][3])
				str_4slot = "None";

			else
				format(str_4slot, 60, "%s", ReturnWeaponName(PlayerInfo[playerid][pWeapons][3]));

			returnStr = str_4slot;
		}
	}
	return returnStr;
}

stock ReturnDBIDName(dbid)
{
	new query[120], returnString[60];

	mysql_format(ourConnection, query, sizeof(query), "SELECT char_name FROM characters WHERE char_dbid = %i", dbid);
	new Cache:cache = mysql_query(ourConnection, query);

	if(!cache_num_rows())
		returnString = "None";

	else
		cache_get_field_content(0, "char_name", returnString);

	cache_delete(cache);
	return returnString;
}

stock NotifyVehicleOwner(vehicleid)
{
	new playerid = INVALID_PLAYER_ID;

	foreach(new i : Player)
	{
		if(!strcmp(ReturnName(i), ReturnDBIDName(VehicleInfo[vehicleid][eVehicleOwnerDBID])))
		{
			playerid = i;
		}
	}
	if(playerid != INVALID_PLAYER_ID)
	{
		SendClientMessage(playerid, COLOR_YELLOWEX, "SMS: Your vehicle alarm has been set off, Sender: Vehicle Alarm (Unknown)");
	}
	else return 1;
	return 1;
}

stock GetNearestVehicle(playerid)
{
 	new
	 	Float:fX,
	 	Float:fY,
	 	Float:fZ,
	 	Float:fSX,
	    Float:fSY,
		Float:fSZ,
		Float:fRadius;

	for (new i = 1, j = GetVehiclePoolSize(); i <= j; i ++)
	{
	    if (!IsVehicleStreamedIn(i, playerid))
		{
			continue;
	    }
	    else
	    {
			GetVehiclePos(i, fX, fY, fZ);

			GetVehicleModelInfo(GetVehicleModel(i), VEHICLE_MODEL_INFO_SIZE, fSX, fSY, fSZ);

			fRadius = floatsqroot((fSX + fSX) + (fSY + fSY));

			if (IsPlayerInRangeOfPoint(playerid, fRadius, fX, fY, fZ) && GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(i))
			{
				return i;
			}
		}
	}
	return INVALID_VEHICLE_ID;
}

stock GetVehicleBoot(vehicleid, &Float:x, &Float:y, &Float:z)
{
    if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
        return (x = 0.0, y = 0.0, z = 0.0), 0;

    static
        Float:pos[7]
    ;
    GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
    GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
    GetVehicleZAngle(vehicleid, pos[6]);

    x = pos[3] - (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
    y = pos[4] - (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
    z = pos[5];

    return 1;
}

stock GetVehicleHood(vehicleid, &Float:x, &Float:y, &Float:z)
{
    if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
        return (x = 0.0, y = 0.0, z = 0.0), 0;

    static
        Float:pos[7]
    ;
    GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
    GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
    GetVehicleZAngle(vehicleid, pos[6]);

    x = pos[3] + (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
    y = pos[4] + (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
    z = pos[5];

    return 1;
}

stock ReturnWeaponsModel(weaponid)
{
    new WeaponModels[] =
    {
        0, 331, 333, 334, 335, 336, 337, 338, 339, 341, 321, 322, 323, 324,
        325, 326, 342, 343, 344, 0, 0, 0, 346, 347, 348, 349, 350, 351, 352,
        353, 355, 356, 372, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366,
        367, 368, 368, 371
    };
    return WeaponModels[weaponid];
}

stock IsPlayerInProperty(playerid)
{
	if(PlayerInfo[playerid][pInsideProperty])
	{
		for(new i = 1; i < MAX_PROPERTY; i++)
		{
			if(i == PlayerInfo[playerid][pInsideProperty] && GetPlayerVirtualWorld(playerid) == PropertyInfo[i][ePropertyInteriorWorld])
				return i;
		}
	}
	return 0;
}

stock IsPlayerNearProperty(playerid)
{
	for(new i = 1; i < MAX_PROPERTY; i++)
	{
		if(!PropertyInfo[i][ePropertyDBID])
			continue;

		if(IsPlayerInRangeOfPoint(playerid, 3.0, PropertyInfo[i][ePropertyEntrance][0], PropertyInfo[i][ePropertyEntrance][1], PropertyInfo[i][ePropertyEntrance][2]) && GetPlayerVirtualWorld(playerid) == PropertyInfo[i][ePropertyEntranceWorld])
			return i;
	}
	return 0;
}

stock IsPlayerNearBusiness(playerid)
{
	for(new i = 1; i < MAX_BUSINESS; i++)
	{
		if(!BusinessInfo[i][eBusinessDBID])
			continue;

		if(IsPlayerInRangeOfPoint(playerid, 3.0, BusinessInfo[i][eBusinessEntrance][0], BusinessInfo[i][eBusinessEntrance][1], BusinessInfo[i][eBusinessEntrance][2]))
			return i;
	}
	return 0;
}

stock IsPlayerInBusiness(playerid)
{
	if(PlayerInfo[playerid][pInsideBusiness])
	{
		for(new i = 1; i < MAX_BUSINESS; i++)
		{
			if(!BusinessInfo[i][eBusinessDBID])
				continue;

			if(i == PlayerInfo[playerid][pInsideBusiness] && GetPlayerVirtualWorld(playerid) == BusinessInfo[i][eBusinessInteriorWorld])
				return i;
		}
	}
	return 0;
}

stock CountPlayerProperties(playerid)
{
	new
		count = 0
	;

	for(new i = 1; i < MAX_PROPERTY; i++)
	{
		if(!PropertyInfo[i][ePropertyDBID])
			continue;

		if(PropertyInfo[i][ePropertyOwnerDBID] == PlayerInfo[playerid][pDBID])
			count++;
	}
	return count;
}

stock CountPlayerBusiness(playerid)
{
	new
		count = 0
	;

	for(new i = 1; i < MAX_BUSINESS; i++)
	{
		if(!BusinessInfo[i][eBusinessDBID])
			continue;

		if(BusinessInfo[i][eBusinessOwnerDBID] == PlayerInfo[playerid][pDBID])
			count++;
	}
	return count;
}

stock CountPlayerVehicles(playerid)
{
	new
		count = 0
	;

	for(new i = 1; i < 6; i++)
	{
		if(PlayerInfo[playerid][pOwnedVehicles][i])
		{
			count++;
		}
	}
	return count;
}

stock ShowVehicleList(playerid)
{
	new thread[128];

	SendClientMessageEx(playerid, COLOR_CUBER, "_________________Your vehicles(%i)_________________", CountPlayerVehicles(playerid));

	for(new i = 1; i < 6; i++)
	{
		if(PlayerInfo[playerid][pOwnedVehicles][i])
		{
			mysql_format(ourConnection, thread, sizeof(thread), "SELECT * FROM vehicles WHERE VehicleDBID = %i", PlayerInfo[playerid][pOwnedVehicles][i]);
			mysql_tquery(ourConnection, thread, "Query_ShowVehicleList", "ii", playerid, i);
		}
	}

	return 1;
}

stock DoesPlayerExist(name[])
{
	new checkQuery[128];

	mysql_format(ourConnection, checkQuery, sizeof(checkQuery), "SELECT char_name FROM characters WHERE char_name = '%e'", name);
	new Cache:cache = mysql_query(ourConnection, checkQuery);

	if(cache_num_rows())
	{
		cache_delete(cache);
		return 1;
	}

	cache_delete(cache);
	return 0;
}

stock ReturnDBIDFromName(name[])
{
	new checkQuery[128], dbid;

	mysql_format(ourConnection, checkQuery, sizeof(checkQuery), "SELECT char_dbid FROM characters WHERE char_name = '%e'", name);
	new Cache:cache = mysql_query(ourConnection, checkQuery);


	if(!cache_num_rows())
	{
		cache_delete(cache);
		return 0;
	}

	dbid = cache_get_field_content_int(0, "char_dbid", ourConnection);
	cache_delete(cache);
	return dbid;
}

stock MoneyFormat(integer)
{
	new value[20], string[20];

	valstr(value, integer);

	new charcount;

	for(new i = strlen(value); i >= 0; i --)
	{
		format(string, sizeof(string), "%c%s", value[i], string);
		if(charcount == 3)
		{
			if(i != 0)
				format(string, sizeof(string), ",%s", string);
			charcount = 0;
		}
		charcount ++;
	}

	return string;
}

stock ReturnXMRCategories(playerid)
{
	new
		liststr[500];

	for (new i = 1; i < MAX_XMR_CATEGORY; i++)
	{
		if(XMRCategoryInfo[i][eXMRID])
		{
			format (liststr, sizeof(liststr), "%s%s\n", liststr, XMRCategoryInfo[i][eXMRCategoryName]);
			ShowPlayerDialog(playerid, DIALOG_XMR_CATEGORIES, DIALOG_STYLE_LIST, "Genres:", liststr, "Select", "Cancel");
		}
	}

	return 1;
}

stock PlayXMRStation(playerid, vehicleid = INVALID_VEHICLE_ID, propertyid = 0, bool:disableXMR = false)
{
	new
		string[128];

	if(disableXMR == true)
	{
		if(vehicleid != INVALID_VEHICLE_ID)
		{
			foreach(new i : Player)
			{
				if(IsPlayerInVehicle(i, vehicleid))
				{
					StopAudioStreamForPlayer(i);
					SendClientMessage(i, COLOR_RED, "Radio has been stopped.");
				}
			}

			VehicleInfo[vehicleid][eVehicleXMROn] = false;
			format(VehicleInfo[vehicleid][eVehicleXMRURL], 128, " ");

			return 1;
		}

		if(propertyid != 0)
		{
			foreach(new i : Player)
			{
				if(IsPlayerInProperty(playerid) == propertyid)
				{
					StopAudioStreamForPlayer(i);
					SendClientMessage(i, COLOR_RED, "Radio has been stopped.");
				}
			}

			PropertyInfo[propertyid][ePropertyBoomboxOn] = false;
			format(PropertyInfo[propertyid][ePropertyBoomboxURL], 128, " ");

			return 1;
		}

		return 1;
	}

	if(vehicleid != INVALID_VEHICLE_ID)
	{
		format(string, sizeof(string), "> %s has turned the radio to %s.", ReturnName(playerid, 0), XMRStationInfo[SubXMRHolder[playerid]][eXMRStationName]);
		SetPlayerChatBubble(playerid, string, COLOR_ACTION, 20.0, 3000);
		SendClientMessage(playerid, 0x88AA62FF, string);

		foreach(new i : Player)
		{
			if(IsPlayerInVehicle(i, vehicleid))
			{
				PlayAudioStreamForPlayer(i, XMRStationInfo[SubXMRHolder[playerid]][eXMRStationURL]);
				SendClientMessageEx(i, COLOR_RED, "Radio changed to station %s.", XMRStationInfo[SubXMRHolder[playerid]][eXMRStationName]);
			}
		}

		if(!VehicleInfo[vehicleid][eVehicleXMROn])
			VehicleInfo[vehicleid][eVehicleXMROn] = true;

		format(VehicleInfo[vehicleid][eVehicleXMRURL], 128, "%s", XMRStationInfo[SubXMRHolder[playerid]][eXMRStationURL]);
		SubXMRHolder[playerid] = 0;

		return 1;
	}

	if(propertyid != 0)
	{
		format(string, sizeof(string), "> %s has turned the radio to %s.", ReturnName(playerid, 0), XMRStationInfo[SubXMRHolder[playerid]][eXMRStationName]);
		SetPlayerChatBubble(playerid, string, COLOR_ACTION, 20.0, 3000);
		SendClientMessage(playerid, 0x88AA62FF, string);

		foreach(new i : Player)
		{
			if(IsPlayerInProperty(i) == propertyid)
			{
				PlayAudioStreamForPlayer(i, XMRStationInfo[SubXMRHolder[playerid]][eXMRStationURL]);
				SendClientMessageEx(i, COLOR_RED, "Radio changed to station %s.", XMRStationInfo[SubXMRHolder[playerid]][eXMRStationName]);
			}
		}

		if(!PropertyInfo[propertyid][ePropertyBoomboxOn])
			PropertyInfo[propertyid][ePropertyBoomboxOn] = true;

		format(PropertyInfo[propertyid][ePropertyBoomboxURL], 128, "%s", XMRStationInfo[SubXMRHolder[playerid]][eXMRStationURL]);
		SubXMRHolder[playerid] = 0;

		return 1;
	}

	return 1;
}

stock ReturnNameLetter(playerid)
{
	new
		playersName[MAX_PLAYER_NAME]
	;

	GetPlayerName(playerid, playersName, sizeof(playersName));

	format(playersName, sizeof(playersName), "%c. %s", playersName[0], playersName[strfind(playersName, "_") + 1]);
	return playersName;
}

stock SendBusinessType(playerid, id)
{
	switch(BusinessInfo[id][eBusinessType])
	{
		case BUSINESS_TYPE_AMMUNATION:
		{
			SendClientMessageEx(playerid, COLOR_DARKGREEN, "Welcome to %s.", BusinessInfo[id][eBusinessName]);
			SendClientMessage(playerid, COLOR_WHITE, "Available commands: /buygun, /buyammo.");
		}
		case BUSINESS_TYPE_BANK:
		{
			SendClientMessage(playerid, COLOR_DARKGREEN, "Bank: /bank, /withdraw, /balance.");
		}
		case BUSINESS_TYPE_GENERAL:
		{
			SendClientMessageEx(playerid, COLOR_DARKGREEN, "Welcome to %s.", BusinessInfo[id][eBusinessName]);
			SendClientMessage(playerid, COLOR_WHITE, "Available commands: /buy, /withdraw, /balance.");
		}
		case BUSINESS_TYPE_CLUB:
		{
			SendClientMessageEx(playerid, COLOR_DARKGREEN, "Welcome to %s.", BusinessInfo[id][eBusinessName]);
			SendClientMessage(playerid, COLOR_WHITE, "Available commands: /buydrink.");
		}
		case BUSINESS_TYPE_RESTAURANT:
		{
			SendClientMessageEx(playerid, COLOR_DARKGREEN, "Welcome to %s. This is a fast food restaurant.", BusinessInfo[id][eBusinessName]);
			SendClientMessage(playerid, COLOR_WHITE, "Available commands: /buyfood.");
		}
	}
	return 1;
}

stock GetChannelSlot(playerid, chan)
{
	for(new i = 1; i < 3; i++)
	{
		if(PlayerInfo[playerid][pRadio][i] == chan)
			return i;
	}
	return 0;
}

stock ResetDealershipVars(playerid)
{
	DealershipPlayerCar[playerid] = INVALID_VEHICLE_ID;
	DealershipTotalCost[playerid] = 0;

	DealershipAlarmLevel[playerid] = 0;
	DealershipImmobLevel[playerid] = 1;

	DealershipLockLevel[playerid] = 0;
	DealershipXMR[playerid] = 0;

	for(new i = 0; i <2 ;i++) { DealershipCarColors[playerid][i] = 0; }
	return 1;
}

stock ShowDealerAppend(playerid)
{
	new
		caption[60],
		str[255]
	;

	format(caption, 60, "%s - {33AA33}%s", g_aDealershipData[SubDealershipHolder[playerid]][eDealershipModel], MoneyFormat(DealershipTotalCost[playerid]));

	strcat(str, "Alarm\n");
	strcat(str, "Lock\n");
	strcat(str, "Immobiliser\n");
	strcat(str, "Colors\n");

	if(DealershipXMR[playerid])
		strcat(str, "{FFFF00}XM-Radio Installed\n");

	else strcat(str, "No XM Installed\n");

	strcat(str, "{FFFF00}Purchase Vehicle\n");

	ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_APPEND, DIALOG_STYLE_LIST, caption, str, "Append", "Back");
	return 1;
}

stock IsNumeric(const str[])
{
	for (new i = 0, l = strlen(str); i != l; i ++)
	{
	    if (i == 0 && str[0] == '-')
			continue;

	    else if (str[i] < '0' || str[i] > '9')
			return 0;
	}
	return 1;
}

stock ShowPlayerPlates(playerid, str[])
{
	for(new i = 0; i < 2; i++)
	{
		PlayerTextDrawShow(playerid, CarBought_PTD[playerid][i]);
	}

	PlayerTextDrawSetString(playerid, CarBought_PTD[playerid][1], str);
	SetTimerEx("OnPlateSet", 4000, false, "i", playerid);
	return 1;
}

stock ReturnBodypartName(bodypart)
{
	new bodyname[20];

	switch(bodypart)
	{
		case BODY_PART_CHEST:bodyname = "CHEST";
		case BODY_PART_GROIN:bodyname = "GROIN";
		case BODY_PART_LEFT_ARM:bodyname = "LEFT ARM";
		case BODY_PART_RIGHT_ARM:bodyname = "RIGHT ARM";
		case BODY_PART_LEFT_LEG:bodyname = "LEFT LEG";
		case BODY_PART_RIGHT_LEG:bodyname = "RIGHT LEG";
		case BODY_PART_HEAD:bodyname = "HEAD";
	}

	return bodyname;
}

stock CallbackDamages(playerid, issuerid, bodypart, weaponid, Float:amount)
{
	new
		id,
		Float:armor
	;

	TotalPlayerDamages[playerid] ++;

	for(new i = 0; i < 100; i++)
	{
		if(!DamageInfo[playerid][i][eDamageTaken])
		{
			id = i;
			break;
		}
	}

	GetPlayerArmour(playerid, armor);

	if(armor > 1 && bodypart == BODY_PART_CHEST)
		DamageInfo[playerid][id][eDamageArmor] = 1;

	else DamageInfo[playerid][id][eDamageArmor] = 0;

	DamageInfo[playerid][id][eDamageTaken] = floatround(amount, floatround_round);
	DamageInfo[playerid][id][eDamageWeapon] = weaponid;

	DamageInfo[playerid][id][eDamageBodypart] = bodypart;
	DamageInfo[playerid][id][eDamageTime] = gettime();

	DamageInfo[playerid][id][eDamageBy] = PlayerInfo[issuerid][pDBID];
	return 1;
}

stock ShowPlayerDamages(damageid, playerid, adminView)
{
	new
		caption[33],
		str[355],
		longstr[1200]
	;

	format(caption, sizeof(caption), "%s", ReturnName(damageid));

	if (TotalPlayerDamages[damageid] < 1)
		return ShowPlayerDialog(playerid, DIALOG_DEFAULT, DIALOG_STYLE_LIST, caption, "There aren't any damages to show.", "Back", "");

	switch(adminView)
	{
		case 0:
		{
			for(new i = 0; i < 100; i ++)
			{
				if(!DamageInfo[damageid][i][eDamageTaken])
					continue;

				format(str, sizeof(str), "%d dmg from %s to %s (Kevlarhit: %d) %d s ago\n", DamageInfo[damageid][i][eDamageTaken], ReturnWeaponName(DamageInfo[damageid][i][eDamageWeapon]), ReturnBodypartName(DamageInfo[damageid][i][eDamageBodypart]), DamageInfo[damageid][i][eDamageArmor], gettime() - DamageInfo[damageid][i][eDamageTime]);
				strcat(longstr, str);
			}

			ShowPlayerDialog(playerid, DIALOG_DEFAULT, DIALOG_STYLE_LIST, caption, longstr, "Back", "");
		}
		case 1:
		{
			for(new i = 0; i < 100; i ++)
			{
				if(!DamageInfo[damageid][i][eDamageTaken])
					continue;

				format(str, sizeof(str), "{FF6346}(%s){FFFFFF} %d dmg from %s to %s (Kevlarhit: %d) %d s ago\n", ReturnDBIDName(DamageInfo[damageid][i][eDamageBy]), DamageInfo[damageid][i][eDamageTaken], ReturnWeaponName(DamageInfo[damageid][i][eDamageWeapon]), ReturnBodypartName(DamageInfo[damageid][i][eDamageBodypart]), DamageInfo[damageid][i][eDamageArmor], gettime() - DamageInfo[damageid][i][eDamageTime]);
				strcat(longstr, str);
			}

			ShowPlayerDialog(playerid, DIALOG_DEFAULT, DIALOG_STYLE_LIST, caption, longstr, "Back", "");
		}
	}
	return 1;
}

stock ClearDamages(playerid)
{
	for(new i = 0; i < 100; i++)
	{
		DamageInfo[playerid][i][eDamageTaken] = 0;
		DamageInfo[playerid][i][eDamageBy] = 0;

		DamageInfo[playerid][i][eDamageArmor] = 0;
		DamageInfo[playerid][i][eDamageBodypart] = 0;

		DamageInfo[playerid][i][eDamageTime] = 0;
		DamageInfo[playerid][i][eDamageWeapon] = 0;
	}

	return 1;
}

stock ShowBuylist(playerid)
{
	new
		id = IsPlayerInBusiness(playerid),
		str[90]
	;

	format(str, sizeof(str), "%s", BusinessInfo[id][eBusinessName]);

	ShowPlayerDialog(playerid, DIALOG_BUY_LIST, DIALOG_STYLE_TABLIST_HEADERS, str,
	"Product\tPrice\n\
		2 Slot Radio\t$1,000\n\
		Gas Can\t$500\n\
		Mask\t$2000\n\
		",
			"Select", "Cancel");

	return 1;
}

stock ReturnHour()
{
	new time[36];

	gettime(time[0], time[1], time[2]);

	format(time, sizeof(time), "%02d:%02d", time[0], time[1]);
	return time;
}

stock ReturnLicenses(playerid, playerb)
{
	new
		driver_str[60],
		wep_str[60]
	;

	if(!PlayerInfo[playerid][pDriversLicense])
		driver_str = "{FF6346}Driving License : No";

	else driver_str = "{E2FFFF}Driving License : Yes";

	if(!PlayerInfo[playerid][pWeaponsLicense])
		wep_str = "{FF6346}Weapons License : No";

	else wep_str = "{E2FFFF}Weapons License : Yes";

	SendClientMessage(playerb, COLOR_DARKGREEN, "______Identification_______");
	SendClientMessageEx(playerb, COLOR_GRAD2, "Name : %s", ReturnName(playerid));
	SendClientMessageEx(playerb, COLOR_GRAD2, "%s", driver_str);
	SendClientMessageEx(playerb, COLOR_GRAD2, "%s", wep_str);
	SendClientMessage(playerb, COLOR_DARKGREEN, "___________________________");
	return 1;
}

stock IsPlayerInTruckingVehicle(playerid)
{
	new
		vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid)
		return 0;

	for(new i = 0; i < sizeof trucking_vehicles; i++)
	{
		if(vehicleid == trucking_vehicles[i])
			return 1;
	}

	return 0;
}

stock IsPlayerInPizzaVehicle(playerid)
{
	new
		vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid)
		return 0;

	for(new i = 0; i < sizeof pizza_vehicles; i++)
	{
		if(vehicleid == pizza_vehicles[i])
			return 1;
	}

	return 0;
}

stock IsPlayerInDMVVehicle(playerid)
{
	new
		vehicleid = GetPlayerVehicleID(playerid);

	if(!vehicleid)
		return 0;

	for(new i = 0; i < sizeof dmv_vehicles; i++)
	{
		if(vehicleid == dmv_vehicles[i])
			return 1;
	}

	return 0;
}

stock StopDriverstest(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
	SetVehicleToRespawn(vehicleid);
	ToggleVehicleEngine(vehicleid, false);
	VehicleInfo[vehicleid][eVehicleEngineStatus] = false;

	PlayersLicenseVehicle[playerid] = INVALID_VEHICLE_ID;
	VehicleInfo[vehicleid][eVehicleFuel] = 100;

	PlayerLicensePoint[playerid] = 0;
	PlayerTakingLicense[playerid] = false;

	DisablePlayerCheckpoint(playerid);
	return 1;
}

stock GetPlayer2DZone(playerid, zone[], len) //Credits to Cueball, Betamaster, Mabako, and Simon (for finetuning).
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
	for(new i = 0; i != sizeof(gSAZones); i++ )
	{
        if(x >= gSAZones[i][SAZONE_AREA][0] && x <= gSAZones[i][SAZONE_AREA][3] && y >= gSAZones[i][SAZONE_AREA][1] && y <= gSAZones[i][SAZONE_AREA][4])
        {
            return format(zone, len, gSAZones[i][SAZONE_NAME], 0);
        }
	}
	return 0;
}

stock ReturnLocation(playerid)
{
	new
		playerLocation[MAX_ZONE_NAME]
	;

	GetPlayer2DZone(playerid, playerLocation, MAX_ZONE_NAME);
	return playerLocation;
}

stock Send911Message(playerid, type)
{
	switch(type)
	{
		case 911:
		{
			foreach(new i : Player) if(PlayerInfo[i][pPoliceDuty])
			{
				SendClientMessage(i, COLOR_CYAN, "|____________Emergency Call____________|");
				SendClientMessageEx(i, COLOR_CYAN, "Caller: %s, Phone: %d, Trace: %s", ReturnName(playerid, 0), PlayerInfo[playerid][pPhone], ReturnLocation(playerid));
				SendClientMessageEx(i, COLOR_CYAN, "Service required: %s", Player911Text[playerid][0]);
				SendClientMessageEx(i, COLOR_CYAN, "Situation: %s", Player911Text[playerid][1]);
				SendClientMessageEx(i, COLOR_CYAN, "Location: %s", Player911Text[playerid][2]);
			}
		}
		case 800:
		{
			foreach(new i : Player) if(PlayerInfo[i][pMedicDuty])
			{
				SendClientMessage(i, COLOR_PINK, "|____________Emergency Call____________|");
				SendClientMessageEx(i, COLOR_PINK, "Caller: %s, Phone: %d, Trace: %s", ReturnName(playerid, 0), PlayerInfo[playerid][pPhone], ReturnLocation(playerid));
				SendClientMessageEx(i, COLOR_PINK, "Service required: %s", Player911Text[playerid][0]);
				SendClientMessageEx(i, COLOR_PINK, "Situation: %s", Player911Text[playerid][1]);
				SendClientMessageEx(i, COLOR_PINK, "Location: %s", Player911Text[playerid][2]);
			}
		}
	}


	Player911Type[playerid] = 0;
	cmd_hangup(playerid, "");
	return 1;
}


stock SendTowMessage(playerid)
{
	foreach(new i : Player) if(PlayerInfo[i][pJob] == 2 && PlayerInfo[i][pWorking] == 1)
	{
		SendClientMessage(i, COLOR_CUBEG, "|____________Service Call____________|");
		SendClientMessageEx(i, COLOR_CUBEG, "Caller: %s, Phone: %d, Trace: %s", ReturnName(playerid, 0), PlayerInfo[playerid][pPhone], ReturnLocation(playerid));
		SendClientMessageEx(i, COLOR_CUBEG, "Information: %s", Player911Text[playerid][2]);
	}
	
	Player911Type[playerid] = 0;
	cmd_hangup(playerid, "");
	return 1;
}

stock SendTaxiMessage(playerid)
{
	foreach(new i : Player) if(PlayerInfo[i][pJob] == 3 && PlayerInfo[i][pWorking] == 1)
	{
		SendClientMessage(i, COLOR_YELLOWEX, "|____________Taxi Call____________|");
		SendClientMessageEx(i, COLOR_YELLOWEX, "Caller: %s, Phone: %d, Trace: %s", ReturnName(playerid, 0), PlayerInfo[playerid][pPhone], ReturnLocation(playerid));
		SendClientMessageEx(i, COLOR_YELLOWEX, "Location: %s", Player911Text[playerid][2]);
	}
	
	Player911Type[playerid] = 0;
	cmd_hangup(playerid, "");
	return 1;
}

stock ShowPlayerMDC(playerid)
{
	new
		szPanel[128]
	;
	strcat(szPanel, "Name Search\n");
	strcat(szPanel, "Plate Search\n");
	strcat(szPanel, "Property Search\n");
	strcat(szPanel, "Issue Ticket\n");
	strcat(szPanel, "Departmental Interpol Ops [Interpol Comms Status]\n");
	strcat(szPanel, "Network Intermission [No outreach detected]\n");
	ShowPlayerDialog(playerid, DIALOG_MDC, DIALOG_STYLE_LIST, "Mobile Database Computer", szPanel, "Select", "Exit");
	return 1;
}

stock HasNoEngine(vehicleid)
{
	switch(GetVehicleModel(vehicleid))
	{
		case 481, 509, 510: return 1;
	}
	return 0;
}
GetName(playerid)
{
  new name[MAX_PLAYER_NAME];
  GetPlayerName(playerid, name, MAX_PLAYER_NAME);
  return name;
}
CMD:botsay( playerid, params[ ] )
{
	new string[250];
    if ( sscanf( params, "s[128]", params ) ) return SendClientMessage( playerid, -1 , "{FF0000}USAGE: {FFFFFF}/botsay [Text]" );
 	if(IsPlayerConnected(playerid))
    {
    format(string, sizeof(string), ""BOTCOLOR""BOTNAME": %s ",params);
    SendClientMessageToAll(-1 , string);
    }
    return 1;
}
forward rMSG();
public rMSG()
{
	new string[150];
	format(string, sizeof(string), ""BOTCOLOR""BOTNAME": %s", RandomMessages[random(sizeof(RandomMessages))]);
	SendClientMessageToAll(-1 , string);
	return 1;
}
forward PingChecker();
public PingChecker()
{

    for(new i = 0; i < MAX_PLAYERS;i++)
    {
        if(IsPlayerConnected(i))
        {
            new lping = GetPlayerPing(i);
            if(lping > pinglimit)
            {
                new usern[MAX_PLAYER_NAME];
                GetPlayerName(i,usern,sizeof(usern));
                new str[128];
                format(str,sizeof(str),"[Info]: %s Has Been Kicked For High Pings.",usern);
                SendClientMessageToAll(0xFFFFFFFF,str);
                SendClientMessage(i,COLOR_RED,"You have been kicked from the server for High Pings.");
                Kick(i);
            }
        }
    }
    return 1;
}
stock Float:PointAngle(playerid, Float:xa, Float:ya, Float:xb, Float:yb) // Don't know the owner.
{
	new Float:carangle;
	new Float:xc, Float:yc;
	new Float:angle;
	xc = floatabs(floatsub(xa,xb));
	yc = floatabs(floatsub(ya,yb));
	if (yc == 0.0 || xc == 0.0)
	{
		if(yc == 0 && xc > 0) angle = 0.0;
		else if(yc == 0 && xc < 0) angle = 180.0;
		else if(yc > 0 && xc == 0) angle = 90.0;
		else if(yc < 0 && xc == 0) angle = 270.0;
		else if(yc == 0 && xc == 0) angle = 0.0;
	}
	else
	{
		angle = atan(xc/yc);
		if(xb > xa && yb <= ya) angle += 90.0;
		else if(xb <= xa && yb < ya) angle = floatsub(90.0, angle);
		else if(xb < xa && yb >= ya) angle -= 90.0;
		else if(xb >= xa && yb > ya) angle = floatsub(270.0, angle);
	}
	GetVehicleZAngle(GetPlayerVehicleID(playerid), carangle);
	return floatadd(angle, -carangle);
}

forward Refresh(playerid);
public Refresh(playerid)
{
	new Float:pos[3], Float:pPos[3];
	pPos[0] = NavData[pNavID[playerid]][NAV_X];
	pPos[1] = NavData[pNavID[playerid]][NAV_Y];
	pPos[2] = NavData[pNavID[playerid]][NAV_Z];
	GetVehiclePos(GetPlayerVehicleID(playerid), pos[0], pos[1], pos[2]);
	new Float:rot = PointAngle(playerid, pos[0], pos[1], pPos[0], pPos[1]);
	AttachObjectToVehicle(ok[playerid], GetPlayerVehicleID(playerid), 0.000000, 0.000000, 1.399998, 0.000000, 90.0, rot + 180);
	new Float:mesafe, str[32];
	mesafe = GetPlayerDistanceFromPoint(playerid, pPos[0], pPos[1], pPos[2]);
	format(str, sizeof(str), "Distance Left: ~y~%0.2fm", mesafe);
	PlayerTextDrawSetString(playerid, NAVpTD[playerid], str);
	if(IsPlayerInRangeOfPoint(playerid, 10.0, pPos[0], pPos[1], pPos[2]))
	{
		KillTimer(pNavTimer[playerid]);
		DestroyObject(ok[playerid]);
		for(new i; i<sizeof(NAVTD); i++) TextDrawHideForPlayer(playerid, NAVTD[i]);
		PlayerTextDrawHide(playerid, NAVpTD[playerid]);
		DisablePlayerCheckpoint(playerid);
		PlayerPlaySound(playerid,1137,0.0,0.0,0.0);
		pNavState[playerid] = 0;
		SendClientMessage(playerid, -1, "{00FF00}<!> You have reached your destination!");
	}
	return 1;
}
CMD:leavejob(playerid,params[])
{
		if(SweepingJob[playerid] == 0)return SCM(playerid,COLOR_RED,"You don't have any job");
		{
	        SweepingJob[playerid] = 0;
	        SCM(playerid,COLOR_GREEN,"You left your job succesfully");
		}
        return 1;
}
CMD:sweeper(playerid,params[])
{

			if(SweepingJob[playerid] == 1)return SCM(playerid,COLOR_RED,"You already strated the job");
			{
			            if(IsPlayerInRangeOfPoint(playerid,7.0,1782.7313,-1696.2794,13.4750))return SendClientMessage(playerid,COLOR_RED,"You are not near the job hq use /gps to locate nearest one");
   						else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 574)
						{
							{
					            SweepingJob[playerid] = 1;
					            new name[MAX_PLAYER_NAME], string[48];
					            GetPlayerName(playerid, name, sizeof(name));
					            format(string, sizeof(string), "* %s is now a StreetSweeper.", name );
					            SendClientMessageToAll(COLOR_YELLOW, string);
					            SendClientMessage(playerid,COLOR_YELLOW,"* Clean the street for 1 minute and recieve $200");
					            SetTimerEx("SweeperJobFinish", 60000, false, "i", playerid);
					            return 1;
							}
				        }
			}
	    	SendClientMessage(playerid, COLOR_RED,"You have to be in a streetsweeper to start the job");
 	 		return 1;
}
forward ShowCredits(playerid);
public ShowCredits(playerid)
{
    new BigString20[2000];
    strcat(BigString20, "Gamemode Main scripter   : MrCubie\n\n");
    strcat(BigString20, "Script Revised by : Bo$$(Bo$$#5950)\n\n");
    strcat(BigString20, "Special thanks to : Ultra-h.com\n\n");
    strcat(BigString20, "\n\n");
    strcat(BigString20, "Beta Testers :\n\n");
    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{00FF00}MGMC {33CCFF}Credits", BigString20, "Watched","Close");
    return 1;
}

CMD:credits(playerid,params[]) {
    #pragma unused params
    ShowCredits(playerid);
    return 1;
}
forward ShowEhelp(playerid);
public ShowEhelp(playerid)
{
    new BigString20[2000];
    strcat(BigString20, "1.Fallout(Use /joinfallout to join the event)\n\n");
    strcat(BigString20, "Fallout is an event where you spawn on a giant platform,\n\n");
    strcat(BigString20, "the platform will be destroyed one by one, meanwhile you have to try to not fall.\n\n");
    strcat(BigString20, "If you're the Last man standing on the platform you will win the minigame.\n\n");
    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{00FF00}MGMC {33CCFF}Events", BigString20, "Watched","Close");
    return 1;
}

CMD:ehelp(playerid,params[]) {
    #pragma unused params
    ShowEhelp(playerid);
    return 1;
}
CMD:startlotto(playerid,params[])
{
new startername[MAX_PLAYER_NAME],stri[200];
if(PlayerInfo[playerid][pAdmin] >= 5)return SendClientMessage(playerid, -1, "{ff0000}You are not authorized to use this command");
if(IsLottoStarted==true)return SendClientMessage(playerid, 0xFF4500AA, "Lottery has already been started");
IsLottoStarted=true;
GetPlayerName(playerid,startername,sizeof(startername));
format(stri,sizeof(stri),"%s has started Lottery",startername);
SendClientMessageToAll(0xCCFF00,stri);
format(stri,sizeof(stri),"It will be drawed after %i minutes.",lottogap);
SendClientMessageToAll(0xCCFF00,stri);
format(stri,sizeof(stri),"Current lottery is of %i $",lottoadd);
SendClientMessageToAll(0xCCFF00,stri);
format(stri,sizeof(stri),"Do /buyticket [your number] to take a ticket | The number should be in range of 0-%i",numrange);
SendClientMessageToAll(0xCCFF00,stri);
lotto_timer=SetTimer("draw",1000*60*lottogap,true);
return 1;
}


CMD:buyticket(playerid,params[])
{
new ru[200],ti;
if(IsLottoStarted==false)return SendClientMessage(playerid, 0xFF4500AA, "Lottery has not been started yet.");
if(sscanf(params,"i",ti))return SendClientMessage(playerid,-1,"{ff0000}Wrong Usage of command | Correct Usage : /ticket [your number]");
format(ru,sizeof(ru),"The nuber should be in range of 0-%i",numrange);
if(ti > numrange || ti < 0)return SendClientMessage(playerid,0xFF4500AA,ru);
format(ru,sizeof(ru),"You need to have %i $ to buy ticket.",ticketprice);
if(GetPlayerMoney(playerid)<ticketprice)return SendClientMessage(playerid,0xFF4500AA,ru);
if(takenticket[playerid]==1)return SendClientMessage(playerid,0xFF4500AA,"You have already taken a lottrey ticket.");
if(IsNumTaken(ti))return SendClientMessage(playerid,0xFF4500AA,"The number has already been chosen by other user. | Please chose other number");
takenticket[playerid]=1;
GivePlayerMoney(playerid,-ticketprice);
ticketnum[playerid]=ti;
format(ru,sizeof(ru),"You have chosen %i as your lucky number!!",ti);
SendClientMessage(playerid,0xCCFF00,ru);
return 1;
}


CMD:stoplotto(playerid,params[])
{
if(!IsPlayerAdmin(playerid))return SendClientMessage(playerid, -1, "{ff0000}You are not authorized to use this command.");
if(IsLottoStarted!=true)return SendClientMessage(playerid,0xFF4500AA,"No lottery is currently going on.");
new m;
IsLottoStarted=false;
KillTimer(lotto_timer);
SendClientMessageToAll(0xFF4500AA,"The lottery has been stopped by an admin");
foreach(m:Player)
{
takenticket[m]=0;
ticketnum[m]=20000;//resets the no. if ticket to value that cannot be taken in /ticket
}

return 1;
}

CMD:lotto(playerid,params[])
{
if(IsLottoStarted!=true)return SendClientMessage(playerid,0xFF4500AA,"No lottery is currently going on");
new rm[200];
format(rm,200,"Current lottery prize is %i $",totallotto);
SendClientMessage(playerid,0xCCFF00,rm);
if(takenticket[playerid]==1)format(rm,200,"Your Current number is %i",ticketnum[playerid]);
else format(rm,200,"Do /ticket [your number] to take a lottery ticket",ticketnum[playerid]);
SendClientMessage(playerid,0xCCFF00,rm);
return 1;
}

CMD:addlotto(playerid,params[])
{
new adm,oo[120],playername[MAX_PLAYER_NAME];
if(IsLottoStarted!=true)return SendClientMessage(playerid,0xFF4500AA,"No lottery is currently going on");
if(sscanf(params,"i",adm))return SendClientMessage(playerid,-1,"{ff0000}Wrong Usage | Correct Usage : /addlotto [amount of money to add]");
if(GetPlayerMoney(playerid)<adm)return SendClientMessage(playerid,0xFF4500AA,"Not enough money to donate.");
format(oo,sizeof(oo),"You cannot doante less than %i $.",minlottoadd);
if(adm<minlottoadd)return SendClientMessage(playerid,0xFF4500AA,oo);
GivePlayerMoney(playerid,-adm);
GetPlayerName(playerid,playername,sizeof(playername));
format(oo,sizeof(oo),"%s(%i) has doanted %i $ to lottery.",playername,playerid,adm);
SendClientMessageToAll(0xCCFF00,oo);
totallotto+=adm;
format(oo,sizeof(oo),"Now the total lotto prize has become %i $",totallotto);
SendClientMessageToAll(0xCCFF00,oo);
return 1;
}

CMD:lottohelp(playerid,params[])
{
new show[300];
if(IsPlayerAdmin(playerid))format(show,sizeof(show),"{9ACD32}/startlotto\t\tStarts a lottery\n/stoplotto\t\tStops a lottery\n/lticket [your number]\tSelect your lucky number for lottery\n/lotto\t\t\tShows the current lotto prize and your lucky number if selected\n/addlotto [amount]\tUse to Doante to lottery");
else format(show,sizeof(show),"{9ACD32}/ticket [your number]\tSelect your lucky number for lottery\n/lotto\t\t\tShows the current lotto prize and your lucky number if selected\n/addlotto [amount]\tUse to Doante to lottery");
ShowPlayerDialog(playerid, 110, DIALOG_STYLE_MSGBOX, "{00BFFF}Available Lottery commands",show, "Cool", "");
return 1;
}
COMMAND:startevent(playerid,params[])
{
	//Warnings
	if(FalloutWaiting == 1) return SendClientMessage(playerid,COLOR_RED,"You can't start another Fallout Event!"); //If the player tries to start again the event while FalloutWaiting is 1 so that means that the event is currently waiting for players
	if(FalloutStarted == 1) return SendClientMessage(playerid,COLOR_RED,"The Fallout Event has already started!"); //If the players tries to start the event while the event is active
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,COLOR_RED,"You need to be Admin to use that command!"); //If the player that tries to do that command is not admin we send him a warning

	//If the requirements are met then let's do this:

	new string[100];
	format(string,sizeof(string),"The Fallout event is about to start in %d minute(s), join it by typing '/joinfallout'",EVENT_START); //let's send everyone a string with the time until start and the join command
	SendClientMessageToAll(COLOR_GREEN,string); //If the event has triggered and it's about to be started (60 secs)
	SetTimer("FalloutStarting",60000*EVENT_START,0); //Timer till the event starts
	FalloutWaiting = 1; //Variable for the waiting time meanwhile searching for players
	FalloutPlayer[playerid] = 1; //The player is now a Fallout Partecipant
	FalloutPlayers++; //Increase the Fallout Players number by 1
	return 1;
}

COMMAND:joinfallout(playerid,params[])
{
	if(FalloutWaiting == 0) return SendClientMessage(playerid,COLOR_RED,"There's no active Fallout Event!"); //If the player tries to join it while there's no active event
	if(FalloutStarted == 1) return SendClientMessage(playerid,COLOR_RED,"The Fallout event has already started, you can't join it now!"); //If the players tries to join it while the Event has already started
	if(FalloutPlayer[playerid] == 1) return SendClientMessage(playerid,COLOR_RED,"You can't join this, you're already in the event!"); //If the player tries to join the event but he's already inside it.

	//Join the event
	FalloutPlayers++; //Increase the players in the event
	FalloutPlayer[playerid] = 1; //The player is now a Fallout Partecipant
	SendClientMessage(playerid,COLOR_GREEN,"You joined the Fallout Event! Just wait until the event starts!");

	return 1;
}


//=============================== FALLOUT CORE FUNCTIONS =======================

public FalloutStarting(playerid) //The function from the timer: We do start the event or delete it if there are not enough players
{
	if(FalloutPlayers < 2) //If the players that joined the event are less than 2 then it triggers this
	{
	    SendClientMessageToAll(COLOR_RED,"Sadly there were not enough players to start the Fallout Event :("); //Send the player a message to let him know that the event isn't started cause of missing players
	    FalloutPlayers = 0; //Reset the fallout players to 0
	    FalloutWaiting = 0; //Reset the fallout Waiting to 0
	    FalloutPlayer[playerid] = 0; //Let's reset the player variable

	} else { //Otherwise the event begins

	    FalloutWaiting = 0; //Let's avoid more players to join the event by putting this to 0
	    FalloutStarted = 1; //Put this to 1 to start the event
	    Platforms(); //Let's create the platforms

	    SetTimer("FallingPlat",1000,1);
	    SetTimer("CheckPlayer",1000,1);

	//We're now cycling into all players to see if they are Players of the Fallout Event and teleport them if they are so.
	    for(new i; i < MAX_PLAYERS; i++)
	    {
		    if(FalloutPlayer[i] == 1)
		    {
			    SetPlayerPos(i,-1737.18042, 845.63318, 435.79611);
			    SetPlayerVirtualWorld(i,5000); //Set all the players in the Virtual World 5000
		    }
	    }

	} //Close
}


/* Here we do check the player and see if he's still in the platform or he has fallen
   this gets checked every 1 second.
*/

public CheckPlayer()
{
    //If there is only 1 player remaining he's the winner
    if(FalloutPlayers == 1) //Checking if there's 1 player remaining
    {
        for ( new z; z < MAX_PLAYERS; z++)
        {
            if(FalloutPlayer[z] == 1) //Checking if he's a fallout player
            {
               SendClientMessage(z,COLOR_GREEN,"Congratz, you're the last man standing on the platform, you won! And you got some extra money for it!"); //Let's send him a message
               GivePlayerMoney(z,MONEY); //Give him the money for the victory you can change it from the top of the Filterscript
               SpawnPlayer(z); //Spawn him
               SetPlayerVirtualWorld(z,0); //Reset his virtual world

               //Reset everything for a new run
               FalloutPlayer[z] = 0;
               FalloutStarted = 0;
               FalloutPlayers = 0;

	           SetTimer("RegenPlatforms",5000,0); //Let's recreate all the platforms in 20 seconds meanwhile they get destroyed and recreated

               //Now let's destroy all objects and reset them
               for(new o=0;o<sizeof(PlatformObject);o++) //Cycle to get all the objects
               {
                    if(IsValidObject(PlatformObject[o])) //Then destroy it
                    {
                        DestroyObject(PlatformObject[o]);
                    }
               }

        }
    }

    } else { //Otherwise do the following

	for(new i; i < MAX_PLAYERS; i++) //Cycle it to get all players id
	{
        new Float: px, Float: py, Float: pz; //Let's define px, py, pz
        GetPlayerPos(i,px,py,pz); //Get everyone position

        if(IsPlayerConnected(i))
        {
		    if(FalloutPlayer[i] == 1)
		    {
	            if(pz < 400) //Let's check who has fallen from the platform
	            {

	            new name[25];
	            new string[100];

	            GetPlayerName(i,name,25);
                format(string,sizeof(string),"%s has been eliminated from the Fallout Event, Players Remaining: %d",name, FalloutPlayers);
	            SendClientMessageToAll(COLOR_RED,string);

	            FalloutPlayers--; //Decrease by 1 the Fallout Players count
	            FalloutPlayer[i] = 0; //Reset his variables
	            SpawnPlayer(i); //Spawn him
	            SetPlayerVirtualWorld(i,0); //Reset his virtual world

		        }
            }
	    }
	}
    }
}

public FallingPlat() //Destroyer of the platforms :^) It destroys a random object from the platform
{
    if(IsValidObject(PlatformObject[random(PLATFORMS)]))
    {
        DestroyObject(PlatformObject[random(PLATFORMS)]);
    }
}


public RegenPlatforms() //Regenerate all the platform for a second run
{
	 Platforms();
}

//================================= PLATFORMS ==================================

stock Platforms()
{
     //Platform objects
     PlatformObject[0] = CreateObject(1649, -1740.44092, 845.66888, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[1] = CreateObject(1649, -1737.18042, 845.63318, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[2] = CreateObject(1649, -1740.48816, 841.32959, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[3] = CreateObject(1649, -1737.22803, 841.29327, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[4] = CreateObject(1649, -1743.76868, 841.38629, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[5] = CreateObject(1649, -1743.70081, 845.68628, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[6] = CreateObject(1649, -1743.67358, 850.00671, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[7] = CreateObject(1649, -1740.37341, 849.96948, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[8] = CreateObject(1649, -1737.11243, 849.93317, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[9] = CreateObject(1649, -1733.85181, 849.89679, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[10] = CreateObject(1649, -1733.93787, 845.51715, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[11] = CreateObject(1649, -1733.96399, 841.24866, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[12] = CreateObject(1649, -1730.74585, 841.14685, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[13] = CreateObject(1649, -1730.63953, 845.54553, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[14] = CreateObject(1649, -1730.59717, 849.84680, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[15] = CreateObject(1649, -1743.81250, 837.06433, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[16] = CreateObject(1649, -1740.53174, 837.00037, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[17] = CreateObject(1649, -1737.23096, 836.97479, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[18] = CreateObject(1649, -1734.09045, 836.91614, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[19] = CreateObject(1649, -1730.79199, 836.81165, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[20] = CreateObject(1649, -1747.12341, 837.09131, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[21] = CreateObject(1649, -1747.06689, 841.43445, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[22] = CreateObject(1649, -1747.01526, 845.75745, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[23] = CreateObject(1649, -1746.95740, 849.99884, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[24] = CreateObject(1649, -1730.82996, 832.48993, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[25] = CreateObject(1649, -1734.09753, 832.52924, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[26] = CreateObject(1649, -1737.34229, 832.58447, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[27] = CreateObject(1649, -1740.63342, 832.60742, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[28] = CreateObject(1649, -1743.83813, 832.65540, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[29] = CreateObject(1649, -1747.13342, 832.65881, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[30] = CreateObject(1649, -1750.43262, 832.73029, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[31] = CreateObject(1649, -1750.41174, 837.09027, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[32] = CreateObject(1649, -1750.32996, 841.42944, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[33] = CreateObject(1649, -1750.28845, 845.78906, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[34] = CreateObject(1649, -1750.24622, 850.10901, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[35] = CreateObject(1649, -1730.54651, 854.22644, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[36] = CreateObject(1649, -1733.78687, 854.29486, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[37] = CreateObject(1649, -1737.08728, 854.30304, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[38] = CreateObject(1649, -1740.26367, 854.29370, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[39] = CreateObject(1649, -1743.52954, 854.32788, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[40] = CreateObject(1649, -1746.84167, 854.36127, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[41] = CreateObject(1649, -1750.14624, 854.45685, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[42] = CreateObject(1649, -1753.71252, 832.77502, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[43] = CreateObject(1649, -1753.56506, 837.16809, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[44] = CreateObject(1649, -1753.59863, 841.46564, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[45] = CreateObject(1649, -1753.53516, 845.80377, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[46] = CreateObject(1649, -1753.46643, 850.09772, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[47] = CreateObject(1649, -1753.44092, 854.44940, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[48] = CreateObject(1649, -1730.49390, 858.64581, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[49] = CreateObject(1649, -1733.77344, 858.66431, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[50] = CreateObject(1649, -1737.05298, 858.68329, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[51] = CreateObject(1649, -1740.31287, 858.70197, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[52] = CreateObject(1649, -1743.45178, 858.75903, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[53] = CreateObject(1649, -1746.75024, 858.76831, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[54] = CreateObject(1649, -1750.05212, 858.79803, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[55] = CreateObject(1649, -1753.37537, 858.88470, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[56] = CreateObject(1649, -1756.61438, 858.90198, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[57] = CreateObject(1649, -1756.71008, 854.54590, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[58] = CreateObject(1649, -1756.71973, 850.21057, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[59] = CreateObject(1649, -1756.76819, 845.92291, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[60] = CreateObject(1649, -1756.84387, 841.63708, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[61] = CreateObject(1649, -1756.79749, 837.29614, 428.79611, -90.00000, 0.00000, -90.60000);
     PlatformObject[62] = CreateObject(1649, -1756.81995, 832.97583, 428.79611, -90.00000, 0.00000, -90.60000);
}
/*
Kiler:

xSafe[sid][safe_BosObj][0] = CreateObject(19618, xSafe[sid][safe_Pos][0], xSafe[sid][safe_Pos][1], xSafe[sid][safe_Pos][2], 0.0, 0.0, xSafe[sid][safe_Pos][3]);
xSafe[sid][safe_BosObj][1] = CreateObject(19619, xSafe[sid][safe_Pos][0]-0.35, xSafe[sid][safe_Pos][1]+0.35, xSafe[sid][safe_Pos][2], 0.0, 0.0, xSafe[sid][safe_Pos][3]);
xSafe[sid][safe_ParaObj] = CreateObject(2005, xSafe[sid][safe_Pos][0], xSafe[sid][safe_Pos][1], xSafe[sid][safe_Pos][2], 0.0, 0.0, xSafe[sid][safe_Pos][3]);
MoveObject(xSafe[sid][safe_BosObj][1], xSafe[sid][safe_Pos][0]-0.2, xSafe[sid][safe_Pos][1]+0.45, xSafe[sid][safe_Pos][2], 1.0, 0.0, 0.0, xSafe[sid][safe_Pos][3]+250);
*/
CMD:flash(playerid,params[])
{
        new vehicleid,panels,doors,lights,tires;
        vehicleid = GetPlayerVehicleID(playerid);
        if(!Flasher[vehicleid]) {
                if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
                {
                        return SendClientMessage(playerid, -1, "* You are not the driver!");
                }
                if (!GetVehicleModel(vehicleid)) return SendClientMessage(playerid, -1, "* You are not in a vehicle!");
                if (IsValidObject(obj[vehicleid]) || IsValidObject(obj2[vehicleid]))
                {
                        SendClientMessage(playerid, -1, "You switched off the lights."), DestroyObject(obj[vehicleid]), DestroyObject(obj2[vehicleid]);
                        GetVehicleDamageStatus(vehicleid,panels,doors,lights,tires);
                        if(LightPwr[vehicleid] == 1)
                        UpdateVehicleDamageStatus(vehicleid, panels, doors, 0, tires);
                        else
                        UpdateVehicleDamageStatus(vehicleid, panels, doors, 5, tires);
                        Flasher[vehicleid] = 0;
                }
                switch (GetVehicleModel(vehicleid))
                {
                        case 596:
                        {
                                obj[vehicleid] = CreateObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                                obj2[vehicleid] = CreateObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                                AttachObjectToVehicle(obj[vehicleid], vehicleid, 0.599999,-0.375000,0.899999,0.000000,0.000000,0.000000);
                                AttachObjectToVehicle(obj2[vehicleid], vehicleid, -0.599999,-0.375000,0.899999,0.000000,0.000000,0.000000);
                                GetVehicleDamageStatus(vehicleid,panels,doors,lights,tires);
                                Flasher[vehicleid] = 1;
                        }
                        case 597:
                        {
                                obj[vehicleid] = CreateObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                                obj2[vehicleid] = CreateObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                                AttachObjectToVehicle(obj[vehicleid], vehicleid, 0.599999,-0.375000,0.899999,0.000000,0.000000,0.000000);
                                AttachObjectToVehicle(obj2[vehicleid], vehicleid, -0.599999,-0.375000,0.899999,0.000000,0.000000,0.000000);

                                GetVehicleDamageStatus(vehicleid,panels,doors,lights,tires);
                                Flasher[vehicleid] = 1;
                        }
                        case 598:
                        {
                                obj[vehicleid] = CreateObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                                obj2[vehicleid] = CreateObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                                AttachObjectToVehicle(obj[vehicleid], vehicleid, 0.524999, -0.300000, 0.899999, 0.000000, 0.000000, 0.000000);
                                AttachObjectToVehicle(obj2[vehicleid], vehicleid, -0.524999, -0.300000, 0.899999, 0.000000, 0.000000, 0.000000);
                                GetVehicleDamageStatus(vehicleid,panels,doors,lights,tires);
                                Flasher[vehicleid] = 1;
                        }
                        case 599:
                        {
                                obj[vehicleid] = CreateObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                                obj2[vehicleid] = CreateObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                                AttachObjectToVehicle(obj[vehicleid], vehicleid, 0.524999,0.000000,1.125000,0.000000,0.000000,0.000000);
                                AttachObjectToVehicle(obj2[vehicleid], vehicleid, -0.524999,0.000000,1.125000,0.000000,0.000000,0.000000);
                                GetVehicleDamageStatus(vehicleid,panels,doors,lights,tires);
                                Flasher[vehicleid] = 1;
                        }
                        case 541://bullet
                        {
                                obj[vehicleid] = CreateObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                                AttachObjectToVehicle(obj[vehicleid], vehicleid, 0.375000,0.524999,0.375000,0.000000,0.000000,0.000000);

                                GetVehicleDamageStatus(vehicleid,panels,doors,lights,tires);
                                Flasher[vehicleid] = 1;
                        }
                        case 426://premier
                        {
                                obj[vehicleid] = CreateObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                                AttachObjectToVehicle(obj[vehicleid], vehicleid, 0.524999,0.749999,0.375000,0.000000,0.000000,0.000000);

                                GetVehicleDamageStatus(vehicleid,panels,doors,lights,tires);
                                Flasher[vehicleid] = 1;
                        }
                        case 427://enforcer
                        {
                                GetVehicleDamageStatus(vehicleid,panels,doors,lights,tires);
                                Flasher[vehicleid] = 1;
                        }
                        case 416://Ambulance
                        {
                                GetVehicleDamageStatus(vehicleid,panels,doors,lights,tires);
                                Flasher[vehicleid] = 1;
                        }
                        case 407://FireTruck
                        {
                                GetVehicleDamageStatus(vehicleid,panels,doors,lights,tires);
                                Flasher[vehicleid] = 1;
                        }
                        case 560://sultan
                        {
                                obj[vehicleid] = CreateObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                                AttachObjectToVehicle(obj[vehicleid], vehicleid, 0.225000,0.750000,0.449999,0.000000,0.000000,0.000000);
                                GetVehicleDamageStatus(vehicleid,panels,doors,lights,tires);
                                Flasher[vehicleid] = 1;
                        }
                        case 490://FBI
                        {
                                obj[vehicleid] = CreateObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                                AttachObjectToVehicle(obj[vehicleid], vehicleid, 0.000000,1.125000,0.599999,0.000000,0.000000,0.000000);
                                GetVehicleDamageStatus(vehicleid,panels,doors,lights,tires);
                                Flasher[vehicleid] = 1;
                        }
                        default:
                        {
                                return SendClientMessage(playerid, -1, "You are not in a CODE 2 compatible police vehicle!");
                        }
                }
                return SendClientMessage(playerid, -1, "Lights on, you are now in a CODE 2 run!");
        } else {
                if (IsValidObject(obj[vehicleid]) || IsValidObject(obj2[vehicleid])) {
                        SendClientMessage(playerid, -1, "You switched off the lights."), DestroyObject(obj[vehicleid]), DestroyObject(obj2[vehicleid]);
                }
                GetVehicleDamageStatus(vehicleid,panels,doors,lights,tires);
                if(LightPwr[vehicleid] == 1)
                        UpdateVehicleDamageStatus(vehicleid, panels, doors, 0, tires);
                else
                        UpdateVehicleDamageStatus(vehicleid, panels, doors, 5, tires);
                Flasher[vehicleid] = 0;
        }
        return 1;
}

public FlasherFunc() {
        new panelsx,doorsx,lightsx,tiresx;
        for (new p=0; p<MAX_VEHICLES; p++)
        {
                if (Flasher[p] == 1)
                {
                        if (FlasherState[p] == 1)
                        {
                                GetVehicleDamageStatus(p,panelsx,doorsx,lightsx,tiresx);
                                UpdateVehicleDamageStatus(p, panelsx, doorsx, 4, tiresx);
                                FlasherState[p] = 0;
                        }
                        else
                        {
                                GetVehicleDamageStatus(p,panelsx,doorsx,lightsx,tiresx);
                                UpdateVehicleDamageStatus(p, panelsx, doorsx, 1, tiresx);
                                FlasherState[p] = 1;
                        }
                }
        }
        return 1;
}
CMD:ann( playerid, params[ ] ) return cmd_announce( playerid, params );
CMD:announce(playerid,params[])
{
    if(!IsPlayerAdmin(playerid))return SendClientMessage(playerid, -1, "{ff0000}You are not authorized to use this command");
    new text[60]; //Making new text.
    if(sscanf(params,"s[60]",text))
    return SendClientMessage(playerid, COLOR_RED, "USAGE: /announce [text]"); //If you only type /announce this will happen.
    GameTextForAll(text,3000,3); //This will show Game Text to all Players.
    return 1;
}
CMD:startcourier(playerid,params[])
{
        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 609)
        {
            if(PetrolJob[playerid] != 1 && PetrolJob[playerid] != 2 && PetrolJob[playerid] != 3){ PetrolJob[playerid] = 1; }

            new name[MAX_PLAYER_NAME], string[48];
            GetPlayerName(playerid, name, sizeof(name));
            format(string, sizeof(string), "* %s is now a Courier man.", name );
            SendClientMessageToAll(COLOR_YELLOW, string);

            if(PetrolJob[playerid] == 1){
                PetrolJob[playerid] = 2;
                SetPlayerCheckpoint(playerid,1944.7424,-1771.1267,13.1157,10);
                return 1;
            }
            if(PetrolJob[playerid] == 2){
                PetrolJob[playerid] = 3;
                SetPlayerCheckpoint(playerid,1003.4263,-941.8485,41.8079,10);
                return 1;
            }
            if(PetrolJob[playerid] == 3){
                PetrolJob[playerid] = 1;
                SetPlayerCheckpoint(playerid,-97.8173,-1166.7585,2.2650,10);
                return 1;
            }
            return 1;
        }
        SendClientMessage(playerid, COLOR_RED,"You have to be in a courier truck to start the job");
        return 1;
}
