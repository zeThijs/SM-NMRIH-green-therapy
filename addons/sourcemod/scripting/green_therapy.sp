/*
 * Simply replaces the gene therapy with green therapy...
 * ( *∀*)y─┛
 */


#include <sourcemod>
#include <sdktools>
#include <weaponmodels>

#define PLUGIN_VERSION "1.0"
#define PLUGIN_NAME "Green Therapy"

//original soundnames
#define geneinject      "genetherapy_inject_01.wav"
#define genecapremove   "genetherapy_cap_remove_01.wav"
#define genetune        "melodyofdarkness.mp3"

//overwrites
char inject[128] = "toke/genetherapy_cap_remove_01.wav";
char capremove[128] = "toke/genetherapy_inject_01.wav";
char tune[128] = "toke/melodyofdarkness.ogg";

ConVar g_vaccine_partial_blind_chance;

public Plugin:myinfo = 
{
	name = PLUGIN_NAME,
	author = "Thijs|RogueGarlicBread, Torquemada71",
	description = "The best kind of therapy. Original gamefiles by Torquemada71. Plugin by Thijs.",
	version = PLUGIN_VERSION,
	url = "https://steamcommunity.com/sharedfiles/filedetails/?id=2744416557"
}

public void OnPluginStart()
{
    g_vaccine_partial_blind_chance = FindConVar("sv_vaccine_partial_blind_chance");
}

public void OnMapStart()
{

    PrecacheAndDownloads()

    int result = WeaponModels_AddWeaponByClassName("item_gene_therapy", "models/items/genetherapy/v_weedtherapy.mdl", "models/items/genetherapy/weedtherapy.mdl", WeaponModels_OnWeapon);
    if (result == -1){
        LogError("---%s--- error setting weaponmodels override", PLUGIN_NAME);
    }
    
    g_vaccine_partial_blind_chance.FloatValue = 1.0;
    HookEvent("vaccine_taken", CB_VaccineTaken);
    HookEvent("vaccine_taken", CB_VaccineEnd);
}



public bool WeaponModels_OnWeapon(int weaponIndex, int client, int weapon, const char[] className, int itemDefIndex)
{
    return true;
}



public Action CB_VaccineTaken(Event event, const char[] eventName, bool dontBrodcast)
{
    int client = GetClientOfUserId(GetEventInt(event, "userid"));
    if (! IsClientInGame(client)) return;
    EmitSoundToClient(client, "toke/genetherapy_cap_remove_01.wav");

    DataPack data = new DataPack();
    data.WriteCell(client);
    CreateTimer(2.5, CB_Cough, data); //TODO convert client entID to something more safe like maybe authid
}

public Action CB_Cough(Handle timer, DataPack data)
{
    data.Reset();
    int client = data.ReadCell();
    EmitSoundToAll("toke/genetherapy_inject_01.wav", client);
    CreateTimer(1.0, CB_Tune, data);
}
public Action CB_Tune(Handle timer, DataPack data)
{
    data.Reset();
    int client = data.ReadCell();
    EmitSoundToClient(client, "toke/melodyofdarkness.mp3");
    timer = INVALID_HANDLE;
    delete data;
}


public Action CB_VaccineEnd(Event event, const char[] eventName, bool dontBrodcast)
{
    int client = GetEventInt(event, "userid");
}

public void PrecacheAndDownloads()
{
    PrintToServer("%s Precaching and adding to downloadtable.", PLUGIN_NAME);
    AddFileToDownloadsTable("materials/models/rex_reefer/cb_weed_survival_kit.vmt");
    AddFileToDownloadsTable("materials/models/rex_reefer/cb_weed_survival_kit.vtf");
    AddFileToDownloadsTable("models/items/genetherapy/weedtherapy.dx80.vtx");
    AddFileToDownloadsTable("models/items/genetherapy/weedtherapy.dx90.vtx");
    AddFileToDownloadsTable("models/items/genetherapy/weedtherapy.mdl");
    AddFileToDownloadsTable("models/items/genetherapy/weedtherapy.sw.vtx");
    AddFileToDownloadsTable("models/items/genetherapy/weedtherapy.vvd");
    AddFileToDownloadsTable("models/items/genetherapy/v_weedtherapy.dx80.vtx");
    AddFileToDownloadsTable("models/items/genetherapy/v_weedtherapy.dx90.vtx");
    AddFileToDownloadsTable("models/items/genetherapy/v_weedtherapy.mdl");
    AddFileToDownloadsTable("models/items/genetherapy/v_weedtherapy.sw.vtx");
    AddFileToDownloadsTable("models/items/genetherapy/v_weedtherapy.vvd");
    AddFileToDownloadsTable("sound/toke/genetherapy_cap_remove_01.wav");
    AddFileToDownloadsTable("sound/toke/genetherapy_inject_01.wav");
    AddFileToDownloadsTable("sound/toke/melodyofdarkness.mp3");
    PrecacheSound("toke/genetherapy_cap_remove_01.wav", true);
    PrecacheSound("toke/genetherapy_inject_01.wav", true);
    PrecacheSound("toke/melodyofdarkness.mp3", true);
}   
void PrecacheWeaponInfo_PrecahceModel(const char[] model){
	if (PrecacheModel(model, true) == 0)
        PrintToServer("%s Error precaching %s", PLUGIN_NAME, model);
}

