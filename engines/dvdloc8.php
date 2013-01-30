<?php
/**
 * dvdloc8 Parser
 *
 * Parses data from the dvdloc8
 *
 * @todo    Pre-experimental state, need somebody to implement it
 *
 * @package Engines
 * @author  Andreas Goetz (cpuidle@gmx.de)
 * @link    http://www.dvdloc8.com
 * @version $Id: dvdloc8.php,v 1.3 2010/02/18 15:17:25 andig2 Exp $
 */

$GLOBALS['dvdloc8Server']	= 'http://www.dvdloc8.de';

/**
 * Get meta information about the engine
 *
 * @todo    Include image search capabilities etc in meta information
 */
function dvdloc8Meta()
{
    return array('name' => 'DVD Loc8e (de)');
}

/**
 * Get search Url for a TV Tome movie
 *
 * @author  Andreas Goetz <cpuidle@gmx.de>
 * @param   string    The search string
 * @return  string    The search URL (GET)
 */
function dvdloc8SearchUrl($title)
{
	global $dvdloc8Server;
	return $dvdloc8Server.'/view.php?page=suchergebnis&Kat=OTitel&SText='.urlencode($title);	// DTitel is alternative
}

/**
 * Get search Url to visit external site
 *
 * @author  Andreas Goetz <cpuidle@gmx.de>
 * @param   string	$id	The movie's external id
 * @return  string		The visit URL
 */
function dvdloc8ContentUrl($id)
{
	global $dvdloc8Server;
	
	// split into show and episode
	list($showid, $episodeid) = explode('-', $id);
	return $dvdloc8Server.'/dvdloc8/servlet/GuidePageServlet/showid-'.$showid.'/epid-'.$episodeid.'/';
}

/**
 * Search a Movie
 *
 * Searches for a given title on the IMDB and returns the found links in
 * an array
 *
 * @author  Andreas Goetz (cpuidle@gmx.de)
 * @param   string    The search string
 * @return  array     Associative array with id and title
 */
function dvdloc8Search($title)
{
	global $dvdloc8Server;
	global $CLIENTERROR;
	global $cache;

	// search for series
	$resp = httpClient(dvdloc8SearchUrl($title), $cache);
	if (!$resp['success']) $CLIENTERROR .= $resp['error']."\n";

	// direct match?
	if ($resp['redirect']) {
		$url = $resp['redirect'];
	} else {
		// take the first match
		if (preg_match('/Show search for:.*?<a href="(.*?)">/s', $resp['data'], $series)) {
			$url = $dvdloc8Server.$series[1];
#			echo "URL: ".$url;
			$resp = httpClient($dvdloc8Server.$series[1], $cache);
			if (!$resp['success']) $CLIENTERROR .= $resp['error']."\n";
		}
	}
	
	// look for episode guide
	if (preg_match('/<a href="(.*?)" class="sidenav">.*?Episode List/', $resp['data'], $series)) {
		$resp = httpClient($url.$series[1], $cache);
		if (!$resp['success']) $CLIENTERROR .= $resp['error']."\n";
	}
/*
	// get title
	if (preg_match('/<h1>(.+?) - <\/h1>/', $resp['data'], $m)) {
		$title = $m[1];
	}
*/
	if (preg_match_all('/<td nowrap valign=top class="small">\s*(.*?)<\/td>.*?<a href=".*?showid-(\d+)\/epid-(\d+).*?">(.*?)<\/a>/i', $resp['data'], $data, PREG_SET_ORDER)) {
		foreach ($data as $row) {
			$info['id']			= $row[2].'-'.$row[3];	//$row[1];
			$info['showid']		= $row[2];
			$info['episodeid']	= $row[3];
			$info['title']		= $row[4];	// dup
			$info['subtitle']	= $row[4];	// dup
			$ary[]				= $info;
		}
	}

	return $ary;
}

/**
 * Fetches the data for a given TV Tome id
 *
 * @author  Andreas Goetz (cpuidle@gmx.de)
 * @param   int   TV Tome id (show-episode)
 * @return  array Result data
 */
function dvdloc8Data($id)
{
	global $CLIENTERROR;
	global $cache;

	$data= array(); //result
	$ary = array(); //temp

	// fetch mainpage
    $resp = httpClient(dvdloc8ContentUrl($id), $cache);
	if (!$resp['success']) $CLIENTERROR .= $resp['error']."\n";

	// Titles
	preg_match('/<h1>(.*?)<\/h1>/i', $resp['data'], $ary);
    list($t,$s)         = explode(" - ",trim($ary[1]),2);
	$data['title']		= trim($t);
	$data['subtitle']	= trim($s);

	// Year
	preg_match('/<td class="row1">First Aired<\/td><td class="row1">.*?(\d{4})<\/td>/i', $resp['data'], $ary);
	$data['year']		= trim($ary[1]);

	// Director
	preg_match('/<td class="row2">Director<\/td><td class="row2"><a href=".+?">(.+?)<\/a>/i', $resp['data'], $ary);
	$data['director']	= trim($ary[1]);

	// Plot
	preg_match('/Synopsis<\/strong>.*?<tr><td>\s+(.+?)\s+<\/td><\/tr>/is', $resp['data'], $ary);
	$plot = preg_replace('/\s{2,}/s', ' ', $ary[1]);
	$plot = preg_replace('#<(br|p)\s*/?>#i', "\n", $plot);
	$data['plot'] = trim($plot);

/*
	// expose this to append the notes to the plot
	if (preg_match('/Notes<\/strong>.*?<tr><td>\s+(.+?)\s+<\/td><\/tr>/is', $resp['data'], $ary))
	{
		$data['plot'] .= "\n<b>Note:</b>\n".'<ul>'.trim(preg_replace('/\s{2,}/s', ' ', $ary[1])).'</ul>';
	}
*/

	// Cast
	if (preg_match('/<b>Guest Stars:<\/b>(.+?)<\/td>/is', $resp['data'], $m))
	{
		preg_match_all('/<a href="\/dvdloc8\/servlet\/PersonDetail\/personid-\d+">(.+?)<\/a>\s+\((.+?)\)/si', $m[1], $ary, PREG_PATTERN_ORDER);
		$count = 0;
		while (isset($ary[1][$count]))
		{
			$actor = trim(strip_tags($ary[1][$count]));
			$role  = trim(strip_tags($ary[2][$count]));
			$role  = preg_replace('/as\s+/', '', $role);	// avoid leading as...
			if (ereg('\(uncredited$', $role)) $role .= ')';	// fix trailing )
			$cast .= "$actor::$role\n";	# ::$actorid
			$count++;
		}
		$data['cast'] = trim($cast);	
	}
	
	// Rating
	preg_match('/Avg. Rating:<\/td><td>(\d\.\d)\d*<\/td>/i', $resp['data'], $ary);
	$data['rating']   = trim($ary[1]);

	return $data;
}

/**
 * Parses Actor-Details
 *
 * Find image and detail URL for actor, not sure if this can be made
 * a one-step process?
 *
 * @author Andreas Goetz (cpuidle@gmx.de)
 * @param  string  $name  Name of the Actor
 * @return array          array with Actor-URL and Thumbnail
 */
function dvdloc8Actor($name, $actorid)
{
	global $dvdloc8Server;	
	return array();
}

?>
