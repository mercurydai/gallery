<?php
/**
 * youtube.com trailer search
 *
 * Search trailers on youtube.com
 *
 * @package Engines
 * @author  Andreas Goetz   <cpuidle@gmx.de>
 * @author  Adam Benson	    <precarious_panther@bigpond.com>
 * @link    http://www.youtube.com  YouTube
 * @version $Id: youtube.php,v 1.8 2009/04/04 16:17:22 andig2 Exp $
 */

require_once './core/functions.php';
require_once './core/httpclient.php';

define('YOUTUBE_CLIENT_ID', 'ytapi-AndreasGoetz-videodb-g7dk2dh6-0');
define('YOUTUBE_DEVELOPER_KEY', 'AI39si7znfvxGu-6OfT-PIPHxUJbAy429l63_jnWSThlJ7Hitv_gmCpJ9cE_HCnH7PDvSLgthw4wEZ5wSrw139DPLbbmLb50GQ');

/**
 * Get meta information about the engine
 */
function youtubeMeta()
{
    return array('name' => 'YouTube', 'stable' => 1, 'php' => '5.0', 'capabilities' => array('trailer'));
}

function youtubeHasTrailer($title)
{
	return count(youtubeSearch($title)) > 0;
}

function normalize($str)
{
	return preg_replace('/[^a-zäöüA-ZÄÖÜ0-9\s]/', '', $str);
}

function youtubeSearch($title)
{
	$trailers       = array();
    $title	        = normalize($title);
    $trailerquery	= $title." trailer";

    $youtubeurl     = "http://gdata.youtube.com/feeds/api/videos?client=".YOUTUBE_CLIENT_ID."&key=".YOUTUBE_DEVELOPER_KEY."&v=2&".
                      "q=".urlencode($trailerquery)."&start-index=1&max-results=10";

    $resp = httpClient($youtubeurl, true);    
    if (!$resp['success']) return $trailers;

    $xml 	= simplexml_load_string($resp['data']);
    $tags	= explode(' ', $trailerquery);
#		dump($tags);

    foreach ($xml->entry as $trailer)
    {
/* 
        // Now, as the YouTube API doesn't allow us to search by title, do some extra filtering on the results...
        $tagsMatch  = true;

        // not sure this produces good results- disable filtering for now
        foreach($tags as $tag)
        {
            // make sure to normalize result title, too
            $ttitle	= normalize($trailer->title);

            if (stripos($ttitle, $tag) === false)
            {
#					dump($title, $tag);
                $tagsMatch	= false;
                break;
            }
        }			
        if ($tagsMatch) $trailers[] = $trailer->id;
*/
        $trailers[] = (string) $trailer->content['src'];

        if (count($trailers) >= 10) break;
    }

	return $trailers;
}

?>