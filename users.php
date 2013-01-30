<?php
/**
 * User Management
 *
 * User administration functions
 *
 * @package Multiuser
 * @author  Andreas Gohr <a.gohr@web.de>
 * @version $Id: users.php,v 1.21 2009/04/04 16:25:58 andig2 Exp $
 */

require_once './core/functions.php';

localnet_or_die();
permission_or_die(PERM_ADMIN);


/**
 * Create user
 *
 * @param string $user Username
 * @param string $pass Password
 * @param string $perm permission as integer
 * @return boolean     true on success
 */
function create_user($user, $pass, $perm, $email)
{
	global $config;

    // acquire next free "real" user-id
    $SQL = "SELECT (MAX(id)+1) AS id FROM ".TBL_USERS." WHERE id != ".$config['guestid'].";";
    $res = runSQL($SQL);
    $nextid = $res[0]['id'];
    
    $SQL = "INSERT INTO ".TBL_USERS."
               SET id = ".$nextid.",
               	   name = '".addslashes($user)."',
                   passwd = '".md5($pass)."',
                   permissions = $perm,
                   email = '".addslashes($email)."'";
    runSQL($SQL);
    
    // set default read/write permissions for own data
    $SQL = 'REPLACE INTO '.TBL_PERMISSIONS." 
                SET from_uid=".$nextid.", to_uid=".$nextid.", permissions=".PERM_READ."|".PERM_WRITE;
    runSQL($SQL);

    return true;
}

// calculate permissions
$perm = 0;

if ($adminflag) $perm |= PERM_ADMIN + PERM_ADULT;
elseif ($adultflag) $perm |= PERM_ADULT;

if ($writeflag) $perm |= PERM_READ + PERM_WRITE;
elseif ($readflag) $perm |= PERM_READ;

// new user?
if (!(empty($newuser) || empty($password)))
{
	create_user($newuser, $password, $perm, $email);
	$message = $lang['msg_usercreated'];
}

// update user?
elseif ($id && $name)
{
    runSQL("UPDATE ".TBL_USERS."
               SET name = '".addslashes($name)."', permissions = $perm, email = '".addslashes($email)."'
			 WHERE id = $id");
	// new password?
	if (!empty($password))
	{
		$pw = md5($password);
        runSQL("UPDATE ".TBL_USERS." SET passwd = '$pw' WHERE id = '$id'");
		$message = $lang['msg_permpassupd'];
	} else {
		$message = $lang['msg_permupd'];
	}
}

// delete user?
elseif ($del)
{
    validate_input($del);
    
    // clear user and config
    runSQL('DELETE FROM '.TBL_USERS.' WHERE id = '.$del);
    runSQL('DELETE FROM '.TBL_USERCONFIG.' WHERE user_id = '.$del);

    // clear permissions
    runSQL('DELETE FROM '.TBL_PERMISSIONS." WHERE from_uid=".$del);
    
	$message = $lang['msg_userdel'];
}

// current user permissions
$result = runSQL('SELECT id, name, permissions, email
                    FROM '.TBL_USERS.'
                ORDER BY name');
foreach ($result as $user)
{
	// is guest ?
    $user['guest'] = ($user['id'] == $config['guestid']) ? 1 : 0;
	
	// don't show guest user if guest is disabled
	if ($config['denyguest'] && $user['guest']) 
    {
        continue;
    }
	 
	// collect and separate permission information
    $user['read']  = ($user['permissions'] & PERM_READ);
    $user['write'] = ($user['permissions'] & PERM_WRITE);
    $user['admin'] = ($user['permissions'] & PERM_ADMIN);
    $user['adult'] = ($user['permissions'] & PERM_ADULT);
    $userlist[]    = $user;
}

// make sure caches are clean
clear_permission_cache();

// prepare templates
tpl_page('usermanager');

$smarty->assign('userlist', $userlist);
$smarty->assign('message', $message);

// display templates
tpl_display('users.tpl');

?>
