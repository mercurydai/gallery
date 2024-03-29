<?php
/**
 * IMDB Parser
 *
 * Parses data from the Internet Movie Database
 *
 * @package Engines
 * @author  Andreas Gohr    <a.gohr@web.de>
 * @link    http://www.imdb.com  Internet Movie Database
 * @version $Id: imdb.php,v 1.67 2011/02/11 07:35:23 andig2 Exp $
 */

$GLOBALS['imdbServer']   = 'http://www.imdb.com';
$GLOBALS['imdbIdPrefix'] = 'imdb:';

/**
 * Get meta information about the engine
 *
 * @todo    Include image search capabilities etc in meta information
 */
function imdbMeta()
{
    return array('name' => 'IMDB', 'stable' => 1);
}


/**
 * Get Url to search IMDB for a movie
 *
 * @author  Andreas Goetz <cpuidle@gmx.de>
 * @param   string    The search string
 * @return  string    The search URL (GET)
 */
function imdbSearchUrl($title)
{
    global $imdbServer;
    return $imdbServer.'/find?s=all&amp;q='.urlencode($title);
}

/**
 * Get Url to visit IMDB for a specific movie
 *
 * @author  Andreas Goetz <cpuidle@gmx.de>
 * @param   string  $id The movie's external id
 * @return  string      The visit URL
 */
function imdbContentUrl($id)
{
    global $imdbServer;
    global $imdbIdPrefix;
    $id = preg_replace('/^'.$imdbIdPrefix.'/', '', $id);
    return $imdbServer.'/title/tt'.$id.'/';
}

/**
 * Search a Movie
 *
 * Searches for a given title on the IMDB and returns the found links in
 * an array
 *
 * @author  Tiago Fonseca <t_r_fonseca@yahoo.co.uk>
 * @author  Charles Morgan <cmorgan34@yahoo.com>
 * @param   string  title   The search string
 * @param   boolean aka     Use AKA search for foreign language titles
 * @return  array           Associative array with id and title
 */
function imdbSearch($title, $aka=null)
{
    global $imdbServer;
    global $imdbIdPrefix;
    global $CLIENTERROR;
    global $cache;

    $url    = $imdbServer.'/find?q='.urlencode($title);
    if ($aka) $url .= ';s=tt;site=aka';

    $resp = httpClient($url, $cache);
    if (!$resp['success']) $CLIENTERROR .= $resp['error']."\n";

    $data = array();

    // add encoding
    $data['encoding'] = get_response_encoding($resp);

    // direct match (redirecting to individual title)?
    if (preg_match('/^'.preg_quote($imdbServer,'/').'\/[Tt]itle(\?|\/tt)([0-9?]+)\/?/', $resp['url'], $single))
    {
        $info       = array();
        $info['id'] = $imdbIdPrefix.$single[2];

        // Title
        preg_match('/<title>(.*?) \([1-2][0-9][0-9][0-9].*?\)<\/title>/i', $resp['data'], $m);
        list($t, $s)        = explode(' - ', trim($m[1]), 2);
        $info['title']      = trim($t);
        $info['subtitle']   = trim($s);

        $data[]     = $info;
    }

    // multiple matches
    else if (preg_match_all('#<a href="/title/tt(\d+)/?".*?>(.+?)</a>\s*\(([0-9?]+)\)?#i', $resp['data'], $multi, PREG_SET_ORDER))
    {
        foreach ($multi as $row)
        {
            // fix for images in search results (re-apply search to title)
            if (preg_match('#<a href="/title/tt(\d+)/?".*?>(.+?)$#i', $row[2], $row2)) $row[2] = $row2[2];

            $info           = array();
            $info['id']     = $imdbIdPrefix.$row[1];
            $info['title']  = $row[2];
            $info['year']   = $row[3];
#           dump($info);
            $data[]         = $info;
        }
    }

    return $data;
}

/**
 * Fetches the data for a given IMDB-ID
 *
 * @author  Tiago Fonseca <t_r_fonseca@yahoo.co.uk>
 * @author  Victor La <cyridian@users.sourceforge.net>
 * @author  Roland Obermayer <robelix@gmail.com>
 * @param   int   IMDB-ID
 * @return  array Result data
 */
function imdbData($imdbID)
{
    global $imdbServer;
    global $imdbIdPrefix;
    global $CLIENTERROR;
    global $cache;

    $imdbID = preg_replace('/^'.$imdbIdPrefix.'/', '', $imdbID);
    $data= array(); // result
    $ary = array(); // temp

    // fetch mainpage
    $resp = httpClient($imdbServer.'/title/tt'.$imdbID.'/', $cache);     // added trailing / to avoid redirect
    if (!$resp['success']) $CLIENTERROR .= $resp['error']."\n";

    // add encoding
    $data['encoding'] = get_response_encoding($resp);

    // Check if it is a TV series episode
    if (preg_match('/<a class="tn15(prev|next)" href="\/title\/tt.+\/" title="(previous|next) episode">/i', $resp['data']) or
        preg_match('/<div class="article episode-nav" >.*?<a href="\/title\/tt\d+">(Previous|Next) Episode<\/a>/is', $resp['data'])
     ) {
        $data['istv'] = 1;

        # find id of Series
        preg_match('/<a href="\/title\/tt(\d+)\/episodes" title="Full Episode List.*">/i', $resp['data'], $ary);
        $data['tvseries_id'] = trim($ary[1]);
    }

   // Titles and Year
    preg_match('/<meta name="title" content="(.*?) \(.*?(\d\d\d\d)\) - IMDb" \/>/si', $resp['data'], $ary);
    $data['year'] = trim($ary[2]);
    if ($data['istv']) {
        # split title for tv-episodes
        preg_match('/&quot;(.*)&quot; (.*)/si', trim($ary[1]), $ary2);
        $data['title'] = trim($ary2[1]);
        $data['subtitle'] = trim($ary2[2]);
    } else {
        # split title - subtitle
        list($t, $s)	= explode(' - ', trim($ary[1]), 2);
        $data['title'] = trim($t);
        $data['subtitle'] = trim($s);
    }
    # orig. title
    preg_match('/<span class="title-extra">\s*(.*?)\s*<i>\(original title\)<\/i>\s*<\/span>/si', $resp['data'], $ary);
    $data['origtitle'] = trim($ary[1]);

    // Cover URL
    $data['coverurl'] = imdbGetCoverURL($resp['data']);

    // MPAA Rating
    preg_match('/<A HREF="\/mpaa">MPAA<\/A>\s*\)\s*<\/h4>\s*(.+?)\s*<span/is', $resp['data'], $ary);
    $data['mpaa']     = trim($ary[1]);

    // UK BBFC Rating
    # no longer appears on main page
    #preg_match('/>\s*UK:(.*?)<\/a>\s+/s', $resp['data'], $ary);
    #$data['bbfc'] = trim($ary[1]);

    // Runtime
    preg_match('/Runtime:?<\/h4>\D*?(\d+)\s+min/si', $resp['data'], $ary);
    $data['runtime']  = preg_replace('/,/', '', trim($ary[1]));

    // Director
    preg_match('/<h4 class="inline">\s*Directors?:\s*<\/h4>(.*?)<\/div>/si', $resp['data'], $ary);
    preg_match_all('/<A +HREF="\/Name[?\/].+?">(.+?)<\/A>/si', $ary[1], $ary, PREG_PATTERN_ORDER);
    // TODO: Update templates to use multiple directors
    $data['director']  = trim(join(', ', $ary[1]));

    // Rating
    preg_match('/<span class="rating-rating">([\d\.]+)<span>\/10<\/span><\/span>/si', $resp['data'], $ary);
    $data['rating'] = trim($ary[1]);

    // Countries
    preg_match('/Country:\s*<\/h4>(.+?)<\/div>/si', $resp['data'], $ary);
    preg_match_all('/<A HREF="\/Country\/.+?">(.+?)<\/A>/si', $ary[1], $ary, PREG_PATTERN_ORDER);;
    $data['country'] = trim(join(', ', $ary[1]));

    // Languages
    preg_match_all('/<A HREF="\/Language\/.+?">(.+?)<\/A>/si', $resp['data'], $ary, PREG_PATTERN_ORDER);
    $data['language'] = trim(strtolower(join(', ', $ary[1])));

    // Genres (as Array)
    preg_match('/<h4 class="inline">Genres?:<\/h4>\s+(.*?)\s+<\/div>/', $resp['data'], $ary);
    preg_match_all('/<A +HREF="\S*\/Genres?\/.+?\/?">(.+?)<\/A>/si', $ary[1], $ary, PREG_PATTERN_ORDER);
    foreach($ary[1] as $genre)
    {
        $data['genres'][] = trim($genre);
    }

    // for Episodes - try to get some missing stuff from the main series page
    if ( $data['istv'] and (!$data['runtime'] or !$data['country'] or !$data['language'] or !$data['coverurl'])) {
        $sresp = httpClient($imdbServer.'/title/tt'.$data['tvseries_id'].'/', $cache);
        if (!$sresp['success']) $CLIENTERROR .= $resp['error']."\n";

        # runtime
        if (!$data['runtime']) {
            preg_match('/Runtime:?<\/h4>\D*?(\d+)\s+min/si', $sresp['data'], $ary);
            $data['runtime']  = preg_replace('/,/', '', trim($ary[1]));
        }

        # language
        if (!$data['country']) {
            preg_match('/Country:\s*<\/h4>(.+?)<\/div>/si', $sresp['data'], $ary);
            preg_match_all('/<A HREF="\/Country\/.+?">(.+?)<\/A>/si', $ary[1], $ary, PREG_PATTERN_ORDER);;
            $data['country'] = trim(join(', ', $ary[1]));
        }

        # country
        if (!$data['language']) {
            preg_match_all('/<A HREF="\/Language\/.+?">(.+?)<\/A>/si', $sresp['data'], $ary, PREG_PATTERN_ORDER);
            $data['language'] = trim(strtolower(join(', ', $ary[1])));
        }

        # cover
        if (!$data['coverurl']) {
            $data['coverurl'] = imdbGetCoverURL($sresp['data']);
        }
    }

    // Plot
    preg_match('/<h2>Storyline<\/h2>\s+<p>(.*?)</si', $resp['data'], $ary);
    $data['plot'] = $ary[1];

    // Fetch credits
    $resp = imdbFixEncoding($data, httpClient($imdbServer.'/title/tt'.$imdbID.'/fullcredits', $cache));
    if (!$resp['success']) $CLIENTERROR .= $resp['error']."\n";

    // Cast
    if (preg_match('#<table class="cast">(.*)#si', $resp['data'], $match))
    {
        if (preg_match_all('#<td class="nm"><a href="/name/(.*?)/?".*?>(.*?)</a>.*?<td class="char">(.*?)</td>#si', $match[1], $ary, PREG_PATTERN_ORDER))
        {
            for ($i=0; $i < sizeof($ary[0]); $i++)
            {
                $actorid    = trim(strip_tags($ary[1][$i]));
                $actor      = trim(strip_tags($ary[2][$i]));
                $character  = trim(strip_tags($ary[3][$i]));
                $cast  .= "$actor::$character::$imdbIdPrefix$actorid\n";
            }
        }

        // remove html entities and replace &nbsp; with simple space
        $data['cast'] = html_clean_utf8($cast);

        // sometimes appearing in series (e.g. Scrubs)
        $data['cast'] = preg_replace('#/ ... #', '', $data['cast']);
    }

    // Fetch plot
    $resp = $resp = imdbFixEncoding($data, httpClient($imdbServer.'/title/tt'.$imdbID.'/plotsummary', $cache));
    if (!$resp['success']) $CLIENTERROR .= $resp['error']."\n";

    // Plot pages may come in diffrent charset
    $plotEncoding = get_response_encoding($resp);
    if ($plotEncoding != $data['encoding']) {
        $resp['data'] = html_entity_decode($resp['data'], ENT_COMPAT, $plotEncoding);
        $resp['data'] = iconv($plotEncoding, $data['encoding'], $resp['data']);
    }

    // Plot
    preg_match('/<P CLASS="plotpar">(.+?)<\/P>/is', $resp['data'], $ary);
    if ($ary[1])
    {
        $data['plot'] = trim($ary[1]);
        $data['plot'] = preg_replace('/&#34;/', '"', $data['plot']);     //Replace HTML " with "
        //Begin removal of 'Written by' section
        $data['plot'] = preg_replace('/<a href="\/SearchPlotWriters.*?<\/a>/', '', $data['plot']);
        $data['plot'] = preg_replace('/Written by/', '', $data['plot']);
        $data['plot'] = preg_replace('/<i>\s+<\/i>/', ' ', $data['plot']);
        //End of removal of 'Written by' section
        $data['plot'] = preg_replace('/\s+/s', ' ', $data['plot']);
    }
    $data['plot'] = html_clean($data['plot']);
    #dump($data['plot']);

    return $data;
}

/**
 * At the moment - oct 2010 - most imdb-pages were changed to utf8, 
 * but e.g. fullcredits are still iso-8859-1
 * so data is recoded here
 */
function imdbFixEncoding($data, $resp)
{
    $result = $resp;
    $pageEncoding = get_response_encoding($resp);
    
    if ($pageEncoding != $data['encoding'])
    {
        $result['data'] = iconv($pageEncoding, $data['encoding'], html_entity_decode_all($resp['data']));
    }
    
    return $result;
}

/**
 * Get Url of Cover Image
 *
 * @author  Roland Obermayer <robelix@gmail.com>
 * @param   string  $data	IMDB Page data
 * @return  string		Cover Image URL
 */
function imdbGetCoverURL($data) {

    global $imdbServer;
    global $CLIENTERROR;
    global $cache;

    # link to big-image-page?
    if ( preg_match('/<td rowspan="2" id="img_primary">.*?<a\s+.*?href="(\/media\/rm\d+\/tt\d+)".*?<\/td>/si', $data, $ary) ) {

        // Fetch the image page
        $resp = httpClient($imdbServer.$ary[1], $cache);
        if (!$resp['success']) $CLIENTERROR .= $resp['error']."\n";

        preg_match('/<img id="primary-img".*?src="(http:\/\/\S*?)"/i', $resp['data'], $ary);
        return trim($ary[1]);
    } else {
        # no image
        return '';
    }
}


/**
 * Get Url to visit IMDB for a specific actor
 *
 * @author  Michael Kollmann <acidity@online.de>
 * @param   string  $name   The actor's name
 * @param   string  $id The actor's external id
 * @return  string      The visit URL
 */
function imdbActorUrl($name, $id)
{
    global $imdbServer;
    global $imdbIdPrefix;

    $path = ($id) ? 'name/'.urlencode($id).'/' : 'Name?'.urlencode(html_entity_decode_all($name));

    return $imdbServer.'/'.$path;
}

/**
 * Parses Actor-Details
 *
 * Find image and detail URL for actor, not sure if this can be made
 * a one-step process?
 *
 * @author                Andreas Goetz <cpuidle@gmx.de>
 * @param  string  $name  Name of the Actor
 * @return array          array with Actor-URL and Thumbnail
 */
function imdbActor($name, $actorid)
{
    global $imdbServer;
    global $cache;

    // search directly by id or via name?
    $resp   = httpClient(imdbActorUrl($name, $actorid), $cache);

    $ary    = array();

    // if not direct match load best match
    if (preg_match('#<b>Popular Names</b>.+?<a\s+href="(.*?)">#i', $resp['data'], $m) ||
        preg_match('#<b>Names \(Exact Matches\)</b>.+?<a\s+href="(.*?)">#i', $resp['data'], $m) ||
        preg_match('#<b>Names \(Approx Matches\)</b>.+?<a\s+href="(.*?)">#i', $resp['data'], $m))
    {
        if (!preg_match('/http/i', $m[1])) $m[1] = $imdbServer.$m[1];
        $resp = httpClient($m[1], true);
    }

    // now we should have loaded the best match

    // only search in img_primary <td> - or we get far to many useless images
    preg_match('/<td\s+id="img_primary".*?>(.*?)<\/td>/si',$resp['data'], $match);

    if (preg_match('/.*?<a.*?href="(.+?)"\s*?>\s*<img\s+.*?src="(.*?)"/si', $match[1], $m))
    {
        $ary[0][0] = $m[1];
        $ary[0][1] = $m[2];
    }

    return $ary;
}

?>
