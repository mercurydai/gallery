<?php
/**
 * dvdinside Parser
 *
 * Parse data from Dvdinside
 *
 * @package Engines
 * @author  Axel Bodemer
 * @link    http://www.dvdinside.de
 * @version $Id: dvdinside.php,v 1.5 2008/06/29 11:13:03 andig2 Exp $
 */

$GLOBALS['dvdinsideServer']	= 'http://www.dvdinside.de';

/**
 * Get meta information about the engine
 *
 * @todo    Include image search capabilities etc in meta information
 */
function dvdinsideMeta()
{
    return array('name' => 'DVD Inside');
}

/**
 * Get search Url for an Dvdinside product
 *
 * @author  Axel Bodemer
 * @param   string    The search string
 * @return  string    The search URL (GET)
 */
function dvdinsideSearchUrl($title)
{
    global $dvdinsideServer;
    return $dvdinsideServer;
}

/**
 * Get Url to visit size for a specific movie
 *
 * @author  Andreas Goetz <cpuidle@gmx.de>
 * @param   string  $id The movie's external id
 * @return  string      The visit URL
 */
function dvdinsideContentUrl($id)
{
    global $dvdinsideServer;
    
    $id = preg_replace('/^DI/', '', $id);
    return $dvdinsideServer.'/db/details.php?id='.$id;
}

/**
 * Search a Movie/DVD/Book etc
 *
 * Searches for a given title on Dvdinside and returns the found links in
 * an array
 *
 * @author Axel Bodemer
 * @param   string    The search string
 * @return  array     Associative array with id and title
 */
function dvdinsideSearch($title)
{
    global $dvdinsideServer, $cache;
    global $CLIENTERROR;

    $post = 'action=new&suchen=Suchen&title='.urlencode($title);

    $resp = httpClient($dvdinsideServer.'/db/search.php', $cache, array('post' => $post));

    if (!$resp['success']) $CLIENTERROR .= $resp['error']."\n";

    if (preg_match_all('/<a href=\"details.php\?id\=(.+?)\">(.+?)<\/a>.+?<a href=\"studio_list.php.+?\">(.+?)<\/a>.+?<td align=\"center\">(.+?)<\/td>/is', $resp['data'], $data, PREG_SET_ORDER)) 
    {
        foreach ($data as $row) 
        {
            if (ereg('<img', $row[2])) continue;
            $info['id']     = "DI".trim($row[1]);
            $info['title']  = trim($row[2]);
            $info['studio'] = trim($row[3]);
            $info['datum']  = trim($row[4]);
            $ary[]          = $info;
        }
    }

    return $ary;	
}

/**
 * Fetches the data for a given Dvdinside ID (equals ISBN)
 *
 * @author  Axel Bodemer
 * @param   int   DVD-ID
 * @return  array Result data
 */
function dvdinsideData($dvd_id)
{
    global $dvdinsideServer, $cache;
    global $CLIENTERROR;

    $data = array();
    $dvd_id = substr($dvd_id, 2);

    // Get  mainpage
    $resp = httpClient($dvdinsideServer.'/db/details.php?id='.$dvd_id, 1);
    if (!$resp[success])
    {
        $CLIENTERROR .= $resp[error]."\n";
        return $data;
    }


    // Cover URL
    if (preg_match("/<img src=\"(bild.php\?id=$dvd_id.+?)\"/",$resp[data],$ary)) 
    {
        $data[coverurl] = $dvdinsideServer."/db/".$ary[1];
        //http://www.dvdinside.de/db/bild.php?id=4167&type=ds&studio=20thCenturyFox
    }

    //Director
    preg_match("/Regie:.+?<a.*?>(.*?)<\/a>/is",$resp[data],$ary);
    $data[director] = trim($ary[1]);

    //Year
    preg_match("/ffentlichung.+?blue\">(.+?)<\/b>/is",$resp[data],$ary);
    $year    = trim($ary[1]);
    if(!empty($year))
    {
        $data[year] = substr($year,6);
    }

    //Plot
    preg_match("/>Inhalt.+?gross2\">(.+?)<\/td>/is",$resp[data],$ary);
    $data[plot] = trim($ary[1]);


    //Runtime
    preg_match("/nge:.+?blue\">(.+?)<\/b>/is",$resp[data],$ary);
    $runtime= trim($ary[1]);
    if(!empty($runtime))$data[runtime]  = $runtime;

    // Genere
    preg_match("/Genre:.+?<a.*?>(.*?)<\/a>/is",$resp[data],$ary);
    $data[genres] = trim($ary[1]);

	// NOT YET:    Language
    // NO EXIST:    Rating

/*  Laeuft. Aber die Schauspielerdaten sind von  IMDB  besser!

    // Actors
    preg_match("/>Schauspieler:<.+?<td class=\"gross2\">(.*?)<\/td>/is",$resp[data],$ary);
    //print "<pre>";print_r($ary);
    preg_match_all("/personen.php.+?>(.+?)<\/a>/is",$ary[1], $array_match);

	foreach($array_match[1] as $actor) {
		$actor = trim(strip_tags($actor));
		if (!$actor) continue;
	
		$data[cast][] = $actor;
	}
*/

	return $data;
}

?>