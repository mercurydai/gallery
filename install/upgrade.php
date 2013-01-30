<?php
/**
 * Database encoding conversion for unicode
 *
 * @package Setup
 * @author  Andreas Goetz <cpuidle@gmx.net>
 * @version $Id: upgrade.php,v 1.8 2009/02/09 17:56:17 andig2 Exp $
 */

// clear cache table
$res    = runSQL("SELECT value FROM config WHERE opt='dbversion'", $dbh, true);
if (count($res) && ($res[0]['value'] >= 30))
{
    runSQL("DELETE FROM cache", $dbh, true);
}

$sql    = '';

// check db  encoding
$res    = runSQL("SHOW VARIABLES LIKE 'character_set_database'", $dbh, true);
$enc    = strtoupper($res[0]['Value']);

if ($enc !== 'UTF8')
{
    $sql    = "ALTER DATABASE CHARACTER SET UTF8;";
}

$tables = array('actors', 'cache', 'config', 'genres', 'lent', 'mediatypes', 'permissions', 
                'userconfig', 'users', 'userseen', 'videodata', 'videogenre');

foreach ($tables as $table)
{
    #!! note:   new code- checking table encoding on table level, too
    #           this is for the case that the DB ist alreaady utf8 but the tables are not
    #
    #           alternative approach:
    #           SELECT TABLE_COLLATION FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'videodb'
    $res    = runSQL("SHOW TABLE STATUS WHERE name = '".$table."'", $dbh, true);
    $enc    = $res[0]['Collation'];

    if (!eregi('UTF8', $enc)) $sql .= "\nALTER TABLE ".$table." CONVERT TO CHARACTER SET UTF8;";
}

if ($sql)
{
    // add DB prefix
    $sql = prefix_query($sql);

    warn('<b>Note:</b><br/>
    Install detected that your database encoding is not UTF8 (current encoding: '.$enc.'). Please make sure to convert your database encoding to UTF8 before you continue using videoDB. If you do not upgrade your database encoding, you may experience problems using videoDB such as SQL error messages or when exporting data. To perform the conversion please execute the following SQL statements against your database:
    <p><pre>'.$sql.'</pre></p>');
}

// signal success
return true;

?>
