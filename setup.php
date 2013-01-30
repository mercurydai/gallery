<?php
/**
 * Setup page
 *
 * Handles saving of the various config options.
 *
 * @package Setup
 * @author  Andreas Gohr <a.gohr@web.de>
 * @author  Andreas G�tz    <cpuidle@gmx.de>
 * @version $Id: setup.php,v 2.49 2010/11/15 09:29:45 andig2 Exp $
 */
 
require_once './core/session.php';
require_once './core/functions.php';
require_once './core/setup.core.php';

localnet_or_die();
permission_or_die(PERM_ADMIN);

/*
 * Note:
 * 
 * for administrators, the profile settings will override generic setup
 */
if ($quicksave)
{
    // insert data
    foreach ($SETUP_QUICK as $opt)
    {
        $SQL = 'REPLACE INTO '.TBL_CONFIG." (opt,value) VALUES ('$opt','".addslashes($$opt)."')";
        runSQL($SQL);
    }

    // make sure no artifacts
    $smarty->clearCache('list.tpl');

    // reload config
    load_config(true);
}
// save data
elseif ($save)
{
    // add dynamic config options for saving
    setup_additionalSettings();

    $languageflags  = @join('::', $languages);
	$adultgenres    = @join('::', $adultgenres);

	// insert data
	foreach ($SETUP_GLOBAL as $opt)
	{
		$SQL = 'REPLACE INTO '.TBL_CONFIG." (opt,value) VALUES ('$opt','".addslashes($$opt)."')";
        runSQL($SQL);
    }
    
	// make sure default engine ist active
	if (!empty($enginedefault)) 
	{
		$opt	= 'engine'.$enginedefault;
		$$opt 	= 1;
	}

    $config['engine'] = array();
    foreach ($config['engines'] as $engine => $meta)
    {
        $opt    = 'engine'.$engine;
        $SQL    = 'REPLACE INTO '.TBL_CONFIG." (opt,value) VALUES ('$opt','".addslashes($$opt)."')";
        runSQL($SQL);

        // mark engine as available
        $config['engine'][$engine] = $$opt;
        
        // add meta-engine if enabled
        if ($$opt) engine_setup_meta($engine, $meta);
    }

    // update session variables
    update_session();
    
    // remove user-specific config options
    $user_id = get_current_user_id();
	if (!empty($user_id))
	{  
        $SQL = "DELETE FROM ".TBL_USERCONFIG." WHERE user_id = '".addslashes($user_id)."'";
        runSQL($SQL);
	}

    // make sure no artifacts
    $smarty->clearCache('list.tpl');

	// reload config
	load_config(true);
} 

// set default engine to imdb if not set
if (empty($config['enginedefault'])) 
{
    $config['enginedefault'] = 'imdb';
}

// check permissions again - they may have changed
if (!check_permission(PERM_ADMIN))
{
    redirect('login.php');
}

// destroy cookies if required
if ($_COOKIE['VDBusername'] && !$config['multiuser'])
{
    setcookie('VDBpassword', '', time()-7200);
    setcookie('VDBusername', '', time()-7200);
    setcookie('VDBuserid',   '', time()-7200);
}

// cache maintenance
if ($cacheempty)
{
    // clear thumbnail cache
    runSQL('DELETE FROM '.TBL_CACHE);

    // clean HTTP cache
    cache_prune_folders(CACHE.'/'.CACHE_HTML.'/', 0, true,  false, '*', (int) $config['hierarchical']);
    
    // clean Smarty as well
    $smarty->clearAllCache();
}

// prepare options
$setup = setup_mkOptions(false);

// prepare templates
tpl_page('configview');

$smarty->assign('setup', $setup);

// display templates
tpl_display('setup.tpl');

?>
