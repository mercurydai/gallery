<?php
/**
 * freedb Parser
 *
 * Parses data from the freedb CD Database
 *
 * @package Engines
 * @author  Andreas Goetz <cpuidle@gmx.de>
 * @link    http://www.freedb.com  TV Tome
 * @version $Id: freedb.php,v 1.7 2010/02/18 15:17:25 andig2 Exp $
 */

$GLOBALS['freedbServer']	= 'http://www.freedb.org';

/**
 * Get meta information about the engine
 *
 * @todo    Include image search capabilities etc in meta information
 */
function freedbMeta()
{
    return array('name' => 'FreeDB');
}

/*
<form action="http://www.freedb.org/freedb_search.php" method=get>
<input type=text name=words width=30 size=30 length=30>
<input type=hidden name=allfields value="NO">
<input type=hidden name=fields value="artist">
<input type=hidden name=fields value="title">
<input type=hidden name=allcats value="YES">
<input type=hidden name=grouping value="none">
</form>
*/

/**
 * Get search Url for a TV Tome movie
 *
 * @author  Andreas Goetz <cpuidle@gmx.de>
 * @param   string    The search string
 * @return  string    The search URL (GET)
 */
function freedbSearchUrl($title)
{
	global $freedbServer;
	return $freedbServer.'/freedb/servlet/Search?searchType=all&searchString='.urlencode($title);
}

/**
 * Get search Url to visit external site
 *
 * @author  Andreas Goetz <cpuidle@gmx.de>
 * @param   string	$id	The movie's external id
 * @return  string		The visit URL
 */
function freedbContentUrl($id)
{
	global $freedbServer;
	
	// split into show and episode
	list($showid, $episodeid) = explode('-', $id);
	return $freedbServer.'/freedb/servlet/GuidePageServlet/showid-'.$showid.'/epid-'.$episodeid.'/';
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
function freedbSearch($title)
{
	global $freedbServer;
	global $CLIENTERROR;
	global $cache;

	// search for series
	$resp = httpClient(freedbSearchUrl($title), $cache);
	if (!$resp['success']) $CLIENTERROR .= $resp['error']."\n";

	// direct match?
	if ($resp['redirect']) {
		$url = $resp['redirect'];
	} else {
		// take the first match
		if (preg_match('/Show search for:.*?<a href="(.*?)">/s', $resp['data'], $series)) {
			$url = $freedbServer.$series[1];
#			echo "URL: ".$url;
			$resp = httpClient($freedbServer.$series[1], $cache);
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
function freedbData($id)
{
	global $CLIENTERROR;
	global $cache;

	$data= array(); //result
	$ary = array(); //temp

	// fetch mainpage
    $resp = httpClient(freedbContentUrl($id), $cache);
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
	$data['plot'] = trim(preg_replace('/\s{2,}/s', ' ', $ary[1]));

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
		preg_match_all('/<a href="\/freedb\/servlet\/PersonDetail\/personid-\d+">(.+?)<\/a>\s+\((.+?)\)/si', $m[1], $ary, PREG_PATTERN_ORDER);
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

#echo nl2br(print_r($data,1));
/*
	//Cover URL
	preg_match('/<IMG.*?alt="cover".*?(http:\/\/.+?\.(jpe?g|gif))/i',$resp['data'],$ary);
	$data['coverurl'] = trim($ary[1]);

	//MPAA Rating
	preg_match('/<A HREF="\/mpaa">MPAA<\/A>: ?<\/B>(.+?)<br>/i',$resp['data'],$ary);
	$data['mpaa']     = trim($ary[1]);

	//Runtime
	preg_match('/Runtime:?<\/B>:?.*?([0-9,]+).*?<\/TD>/si',$resp['data'],$ary);
	$data['runtime']  = preg_replace('/,/', '', trim($ary[1]));

	//Countries
	preg_match_all('/<A HREF="\/Sections\/Countries\/.+?\/">(.+?)<\/A>/i',$resp['data'],$ary,PREG_PATTERN_ORDER);
	$data['country']  = trim(join(' ',$ary[1]));

	//Genres (as Array)
	preg_match_all('/<A HREF="\/Sections\/Genres\/.+?\/">(.+?)<\/A>/i',$resp['data'],$ary,PREG_PATTERN_ORDER);
	foreach($ary[1] as $genre) {
		$data['genres'][] = trim($genre);
	}

	//fetch credits
	$resp = httpClient($freedbServer.'/title/tt'.$id.'/fullcredits', true);
	if(!$resp['success']) $CLIENTERROR .= $resp['error']."\n";
	$resp['data'] = preg_replace('/.*?Cast<\/B><\/A>(.*?)<\/TABLE>/is', '$1', $resp['data']);
*/

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
function freedbActor($name, $actorid)
{
	global $freedbServer;	
	return array();
}

?>
