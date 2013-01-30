<?php
/**
 * Image loader
 *
 * Loads an image from the net and creates a chachefile for it.
 *
 * @package videoDB
 * @author  Andreas Gohr    <a.gohr@web.de>
 * @version $Id: img.php,v 2.28 2010/04/04 10:36:38 andig2 Exp $ 
 */

require_once './core/functions.php';
require_once './core/httpclient.php';

/* 
 * Note:
 *
 * We don't clear overage thumbnails. Instead, 
 * the table entries will be replaced when an image is finally available
 */

// since we don't need session functionality, use this as workaround 
// for php bug #22526 session_start/popen hang 
session_write_close();

/**
 * amazon workaround for 1 pixel transparent images
 */
function checkAmazonSmallImage($url, $ext, $file)
{
	if (preg_match('/^(.+)L(Z{7,}.+)$/', $url, $m)) 
    {
		list($width, $height, $type, $attr) = getimagesize($file);
		if ($width <= 1) 
        {
			$smallurl = $m[1].'M'.$m[2];
            if (cache_file_exists($smallurl, $cache_file, CACHE_IMG, $ext) || 
                download($smallurl, $cache_file))
            {
                copy($cache_file, $file);
			}
		}
	}
}

// Get imgurl for the actor
if ($name) 
{
    require_once './engines/engines.php';

    // name given
	$name   = html_entity_decode($name);
	$result = engineActor($name, $actorid, engineGetActorEngine($actorid));

	if (!empty($result)) {
		$url = $result[0][1];
	}
	if (preg_match('/nohs(-[f|m])?.gif$/', $url)) 
    {
        // imdb no-image picture
		$url = '';
	} 

    // write actor last checked record
    // NOTE: this is only called if the template preparation has determined the actor record needs checking
    {
        // write only if HTTP lookup physically successful
        $SQL = 'REPLACE '.TBL_ACTORS." (name, imgurl, actorid, checked)
                 VALUES ('".addslashes($name)."', '".addslashes($url)."', '".addslashes($actorid)."', NOW())";
        runSQL($SQL);
    }
}

// Get cached image for the given url
if (preg_match('/\.(jpe?g|gif|png)$/i', $url, $matches))
{
    // calculate cache filename if we're not looking into the cache again- otherwise this is done by cache_file_exists
    // $file is further needed for downloading the file
    // This is only effective if function is enabled in getThumbnail function
    # if ($cache_ignore) $file = cache_get_filename($url, CACHE_IMG, $matches[1]));
    
	// does the cache file exist?
    if (cache_file_exists($url, $file, CACHE_IMG, $matches[1]))
    {  
		// amazon workaround for 1 pixel transparent images
		checkAmazonSmallImage($url, $matches[1], $file);
	} 
    // try to download
    elseif (!download($url, $file)) 
    {
		// cache creation failed
        $file = img('nocover.gif');
	}
} 
else 
{
	// no url given -> nopic
    $file = img('nocover.gif');
}

// fix url for redirect
$file = preg_replace('/img\.php$/', $file, $_SERVER['PHP_SELF']);

header('Location: '.$file);

?>