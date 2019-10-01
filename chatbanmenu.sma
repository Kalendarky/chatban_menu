// License: https://github.com/Kalendarky/Licenses/blob/master/v1/README.md
#include <amxmodx>
#include <amxmisc>
#include <engine>
#include <fakemeta>
#include <hamsandwich>
#include <fun>
#include <cstrike>

#define PLUGIN "ChatbanMenu"
#define VERSION "1.0"
#define AUTHOR "Kalendarky"

new temphrac[32];
new tempdovod[255];
new temptime[127];

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_clcmd("napis_cas","Napis_Cas");
	register_clcmd("napis_dovod","Napis_Dovod");
	
	register_clcmd("amx_chatbanmenu", "open_menu", ADMIN_BAN);
	
	AddMenuItem("Chatban Menu", "amx_chatbanmenu",ADMIN_BAN,"ChatbanMenu");
}
public open_menu(id,level,cid)
{
	if(!(get_user_flags(id) & ADMIN_BAN))
		return PLUGIN_HANDLED;
	
	chatbanmenu(id);
	
	return PLUGIN_CONTINUE;
}
public Napis_Cas(id) 
{
    if(!(get_user_flags(id) & ADMIN_BAN))
        return;
		
	new cas[255];
	read_argv(1, cas, 255);
	temptime[id] = str_to_num(cas);
	client_cmd(id,"messagemode napis_dovod");
}
public Napis_Dovod(id)
{
    if(!(get_user_flags(id) & ADMIN_BAN))
        return;

    new dovodis[255];
    read_argv(1, dovodis, 255);
    copy(tempdovod[id],255,dovodis);
    client_cmd(id,"amx_chatban ^"%s^" %d ^"%s^"", temphrac[id],temptime[id],tempdovod[id])
}
public chatbanmenu(id)
{
	new menus = menu_create("Chatban Vyber hraca:","Chatban_Vyber")

	new players[32], pnum, tempid
	new szName[32], szUserId[32]
	
	get_players( players, pnum )
	
	for ( new i; i<pnum; i++ )
	{
		tempid = players[i]
		get_user_name(tempid, szName, charsmax(szName))
		formatex(szUserId, charsmax(szUserId), "%d", get_user_userid(tempid))
		menu_additem(menus, szName, szUserId, 0)
	}
	menu_setprop(menus, MPROP_EXITNAME, "Zavriet")
	menu_display(id, menus, 0)
	
	return PLUGIN_CONTINUE;
}
public Chatban_Vyber(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	
	new szData[6], szName[64]
	new item_access, item_callback
	menu_item_getinfo(menu, item, item_access, szData,charsmax(szData), szName,charsmax(szName), item_callback)
	
	new userid = str_to_num(szData)
	new player = find_player("k", userid)
	static p_name[ 32 ]
	get_user_name( player, p_name, 31 )
	
	if(player)
	{
		copy(temphrac[id],32,p_name);
		client_cmd(id,"messagemode napis_cas");
	}
	menu_destroy(menu)

	return PLUGIN_HANDLED
}
