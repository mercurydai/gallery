<?php
/**
 * DVDB.de Parser
 *
 * Parse data from a german DVD Database
 *
 * @author  Chinamann <chinamann@users.sourceforge.net>
 * @package Engines
 * @link    http://www.dvdb.de
 */

$GLOBALS['dvdbServer']   = 'http://www.dvdb.de/dvdb';
$GLOBALS['dvdbIdPrefix'] = 'dvdb:';

/**
 * Get meta information about the engine
 * 
 * @author  Chinamann <chinamann@users.sourceforge.net>
 * @return  array     Associative array with metadata
 */
function dvdbMeta()
{
    return array(
    	'name' => 'DVDB (de)'
    	, 'stable' => 1
    	, 'supportsEANSearch' => 1
    );
}

/**
 * Try to Login to DVDB to get FSK18 access
 * 
 * @author  Chinamann <chinamann@users.sourceforge.net>
 */
function dvdbLogin()
{
    global $dvdbServer;
    global $config;

    // start session
    session_start();
	
    if ($_SESSION['vdb']['dvdb_loggedin'] != true && !empty($config['dvdb_user']) && !empty($config['dvdb_password']))
    {
        // save session cookies
        $resp = httpClient($dvdbServer."/index.seam?k1=", false);
        $_SESSION['vdb']['dvdb_cookies'] = get_cookies_from_response($resp);
        
        $resp = httpClient($dvdbServer."/login.seam", false, array('cookies' => $_SESSION['vdb']['dvdb_cookies']));
        //$_SESSION['vdb']['dvdb_cookies'] = array_merge($_SESSION['vdb']['dvdb_cookies'], get_cookies_from_response($resp));
        $_SESSION['vdb']['dvdb_cookies'] = myArrayJoin($_SESSION['vdb']['dvdb_cookies'],$cookies);
        
        if (!$resp['success']) $CLIENTERROR .= $resp['error']."\n";
	    $resp['data'] = preg_replace('/[\r\n\t]/',' ', $resp['data']);
	    
        // collect post data
        $postData = '';
	    
        // find username & passwd strings
        if (preg_match('#<form .*?action="([^"]*)".*?>(.*?:username".*?)</form>#i', $resp['data'], $formData)) {
        	$post = array();
        	$post['conversationPropagation'] = "none";
        	if (preg_match_all('#<input type="hidden".*?name="([^"]+)".*?value="([^"]+)"#i', $formData[2], $hiddenTags, PREG_SET_ORDER))
		    {
		        foreach ($hiddenTags as $tag)
		        {
		        	$post[$tag[1]] = $tag[2];
		        }
		    }
		    
	        if (preg_match('#<input id="[^"]*".*? name="([^"]*:username)"#i', $formData[2], $ary)) {
	        	$post[$ary[1]] = $config['dvdb_user'];
	        }
	        if (preg_match('#<input id="[^"]*".*? name="([^"]*:password)"#i', $formData[2], $ary)) {
	        	$post[$ary[1]] = $config['dvdb_password'];
	        }
	   		if (preg_match('#<input id="[^"]*".*? name="([^"]*:rememberme)".*? checked="([^"]*)"#i', $formData[2], $ary)) {
	        	$post[$ary[1]] = $ary[2];
	        }

	        foreach ($post as $key => $val)
	        {
	        	$postData .= '&'.$key.'='.urlencode($val);
	        }
	        $postData = substr($postData,1);
        }

        // fill request params
		$para=array();
		$para['cookies'] = $_SESSION['vdb']['dvdb_cookies'];
		$para['post']    = $postData;

        // Login
        $resp = httpClient($dvdbServer."/login.seam", false, $para);
        $_SESSION['vdb']['dvdb_cookies'] = myArrayJoin($_SESSION['vdb']['dvdb_cookies'],$cookies);

        // remeber that we are already logged in
        $_SESSION['vdb']['dvdb_loggedin'] = true;
    }
}                                                                                                             

/**
 * Get Url to search DVDB for a movie
 *
 * @author  Chinamann <chinamann@users.sourceforge.net>
 * @param   string    The search string
 * @return  string    The search URL (GET)
 */
function dvdbSearchUrl($title, $searchType = 'title')
{
    global $dvdbServer;
    $sID = $_SESSION['vdb']['dvdb_cookies']['JSESSIONID'];
    if ($sID!='') $sID = ';jsessionid='.$sID;
    $url = $dvdbServer.'/discover/dvd/results.seam'.$sID.'?sp=true&hd=true&dvd=true&upc=false&os=false&o=releaseDateAsc&k1='.urlencode($title);
    
    if (preg_match('#^\s*[0-9]{13}\s*$#',$title)) $searchType = 'ean'; 
    
	switch($searchType)
	{
		default    :
		case 'text': {
			$url = $url.'&d1=DOMAIN_TITLE'; break;
		}
		case 'ean' : {
			$url = $url.'&d1=DOMAIN_EAN'; break;
		}
	}
    
    return $url;
}

/**
 * Get Url to visit DVDB for a specific movie
 *
 * @author  Chinamann <chinamann@users.sourceforge.net>
 * @param   string  $id The movie's external id
 * @return  string      The visit URL
 */
function dvdbContentUrl($id)
{
    global $dvdbServer;
    global $dvdbIdPrefix;
    
    // check if login to dvdb is possible -> needed for FSK18 access via trace.php
    dvdbLogin();
    
    $sID = $_SESSION['vdb']['dvdb_cookies']['JSESSIONID'];
    if ($sID!='') $sID = ';jsessionid='.$sID;
    
    $id = preg_replace('/^'.$dvdbIdPrefix.'/', '', $id);
    return $dvdbServer.'/discover/dvd/details'.$sID.'?item='.$id;
}

/**
 * Search a Movie
 *
 * Searches for a given title on the DVDB and returns the found links in
 * an array
 *
 * @author  Chinamann <chinamann@users.sourceforge.net>
 * @param   string    The search string
 * @return  array     Associative array with id and title
 */
function dvdbSearch($title, $searchType = 'title')
{
    global $dvdbServer;
    global $dvdbIdPrefix;
    global $config;
    global $CLIENTERROR;

    $title = utf8_smart_decode($title);
    
    // check if login to dvdb is possible -> needed for FSK18 access
    dvdbLogin();
    
    // force EAN/Barcode search type when $title is a 13 digit number 
    if (preg_match('#^\s*[0-9]{13}\s*$#',$title)) $searchType = 'ean';

    $ret            = array();
	$maxPage        = -1;
	$currentPage    = 1;
	
	// looping is needed for multipage results
    while (true) {
	    // get the search result
	    $resp = httpClient(dvdbSearchUrl($title, $searchType).'&pn='.$currentPage, false, array('cookies' => $_SESSION['vdb']['dvdb_cookies']));
#       dump($resp);

	    // Session allive?
	    if (!empty($config['dvdb_user']) && !empty($config['dvdb_password']) && preg_match('#Dieser Titel ist ausgeblendet#i', $resp['data'])) {
	    	$_SESSION['vdb']['dvdb_loggedin'] = false;
	    	return dvdbSearch($title, $searchType);
	    }
	    
	    if (!$resp['success']) $CLIENTERROR .= $resp['error']."\n";
	    $resp['data'] = preg_replace('/[\r\n\t]/',' ', $resp['data']);
	
	    // add encoding
        $ret['encoding'] = get_response_encoding($resp);

	    // find page count
	    if ($maxPage == -1) {
	    	if (preg_match('#<div class="pageBrowser">.*?<div id="paging">.*?class="pageNumber">([0-9]+)</a></div></div>#i', $resp['data'], $ary)) {
	    		$maxPage = $ary[1];	
	    	} else {
	    		$maxPage = 1;
	    	}
	    }
	    
		if (preg_match('#<table .*?class="dataset full".*?>.*?<tbody>(.*?)</table>#i', $resp['data'], $tableData)) {
			preg_match_all('/<tr.*?>[^<]*(<td[^>]*><a href="\/dvdb\/discover\/dvd\/details\?item.*?)<\/tr>/si', $tableData[1], $data, PREG_SET_ORDER);
	        foreach ($data as $row) {
	        	$id   = '';
	        	$text = '';
	        	$info = array();

	        	// ID & Title
	        	if (preg_match('#<a href="/dvdb/discover/dvd/details\?item=([0-9]+).*?".*?>.*?<strong>(.*?)</strong>#i', $row[1], $ary)) {
	        		$id    = $ary[1];
	        		$text .= trim($ary[2]) . ' ';
	        	}
	        	
	        	// Media type
	        	if (preg_match('#<img src="/dvdb/../assets/main/art/mediatype/([0-9]+).gif"#', $row[1], $ary)) {
	        		switch($ary[1])
					{
						case '1': $text .= '- DVD '; break;
						case '2': $text .= '- UMD '; break;
						case '3': $text .= '- HD DVD '; break;
						case '4': $text .= '- BLU-RAY '; break;
					}
	        	}
	        	
	        	// Country & release year
	        	if (preg_match('#</strong></a>.*?<br />(.*?)([ \-/0-9]*),#', $row[1], $ary)) {
	        		if (trim($ary[1]) != '') $text .= '- '.trim($ary[1]).' '; 
	        		if (trim($ary[2]) != '') $text .= '('.trim($ary[2]).') ';
	        		$info['year'] = trim($ary[2]);
	        	}
	        	
	        	// Release date
	        	if (preg_match('#<br />.*?  am  ([0-9][0-9].[0-9][0-9].[0-9][0-9][0-9][0-9])#', $row[1], $ary)) {
	        		$text .= trim($ary[1]) . ' ';
	        	}
	        	
	        	// FSK
	        	if (preg_match('#<div class="fsk (.*?)"#', $row[1], $ary)) {
	        		$text .= trim($ary[1]) . ' ';
	        	}
	        	
	        	// Runtime
	        	if (preg_match('#<br /> ([0-9]+) Min.</td>#', $row[1], $ary)) {
	        		$text .= trim($ary[1]) . 'min ';
	        	}
	        	
	        	// Image
	        	if (preg_match('#<img\s+src="([^"]*/dvdpix/[^"]*)"#', $row[1], $ary)) {
	        		$img = trim($ary[1]);
	        	}
	        	
	        	// add to result array
	        	if ($id != '') {
					$info['id']     = $dvdbIdPrefix.$id;
					$info['title']  = trim($text);
					$info['title']  = preg_replace('/  +/', ' ', $info['title']);
					if (!empty($img)) $info['img']  = $img;
					$ret[]          = $info;
	        	}
	        }
		    		
		}
		
		if ($currentPage < $maxPage) {
			$currentPage++;
		} else {
			break;
		}

    }
    
    // do not return an array which contains only an encoding attribute
	if (count($ret) < 2) return array();
    
    return $ret;
}

/**
 * Fetches data for a given DVDB-ID
 *
 * @author  Chinamann <chinamann@users.sourceforge.net>
 * @param   int   DVDB-ID
 * @return  array Result data
 */
function dvdbData($dvdbID)
{
    global $dvdbServer;
    global $dvdbIdPrefix;
    global $config;
    global $CLIENTERROR;
    
    $loopLimit = 3; // Maximum retries if http access fails.
    
    $dvdbID = preg_replace('/^'.$dvdbIdPrefix.'/', '', $dvdbID);

    // check if login to dvdb is possible -> needed for FSK18 access
    dvdbLogin();

    $data= array(); // result
    $ary = array(); // temp

    // retry until result is OK or loopLimit reached
    for($loop=0;$loop<$loopLimit;$loop++) 
    {
    	// fetch mainpage
        $resp = httpClient(dvdbContentUrl($dvdbID), false, array('cookies' => $_SESSION['vdb']['dvdb_cookies']));

        if (!$resp['success']) $CLIENTERROR .= $resp['error']."\n";
        else 
    	{
            if (preg_match('#<h1>.*?</h1>#i', $resp['data'], $ary)) {
            	break;
            } else {
            	$_SESSION['vdb']['dvdb_loggedin'] = false;
            	dvdbLogin();
            }
            if ($loop >= $loopLimit) return $data;
    	} 
    }
    $resp['data'] = preg_replace('/[\r\n\t]/',' ', $resp['data']);

    // add encoding
    $data['encoding'] = get_response_encoding($resp);

    // add engine ID -> important for non edit.php refetch
    $data['imdbID'] = $dvdbIdPrefix.$dvdbID;
    
    // Titles
    if (preg_match('#<h1>(.*?)</h1>#i', $resp['data'], $ary))
    {
        list($t, $s)      = explode(" - ",trim($ary[1]),2);
        $data['title']    = trim($t);
        $data['subtitle'] = trim($s);
    }

    // Country and Year
    if (preg_match('/<td.*?>Land und Jahr<\/td>.*?<td.*?>(.*?)<\/td>/i', $resp['data'], $ary))
    {
        $contries = array();
        foreach (preg_split('/[\/,:]/',$ary[1]) as $country)
        {
            $country = preg_replace('/[0-9]*/','',$country);
            $countries[] = trim($country);
        }
        $data['country']  = trim(join(', ', array_unique($countries)));
        preg_match('/([0-9]{4})/',$ary[1],$ary); // take first year occurrence
        $data['year']     = $ary[1];
    }
    
    // Original Title
    if (preg_match('/<td.*?>Originaltitel<\/td>.*?<td.*?>(.*?)<\/td>/i', $resp['data'], $ary))
    {
        $data['orgtitle'] .= trim($ary[1]);
    }

    // Cover URL
    if (preg_match('/<img.+?src="([^"]*?\/dvdpix\/big\/.*?\.jpg)"/i', $resp['data'], $ary))
    {
        $data['coverurl'] =  trim($ary[1]);
    }

    // Runtime
    if (preg_match('#<td.*?>Spielzeit</td>.*?<td.*?>(.*?)</td>#i', $resp['data'], $ary)) {
        if (preg_match('#([0-9]+)#',$ary[1],$ary)) {
            $data['runtime']  = trim($ary[1]);
        }
    }

    // Director
    if (preg_match('/<td.*?>Regie<\/td>.*?<td.*?>(.*?)<\/td>/i', $resp['data'], $ary) && 
        preg_match('/<a.*?>(.*?)<\/a>/si', $ary[1], $ary))
    {
        array_shift($ary);
        $data['director'] = trim(join(', ', $ary));
        if ($data['director'] == 'keine Angabe') $data['director'] ='';
    }

    // Rating
    if (preg_match('#<p>DVDB-Bewertung des Films:<br[^>]*>.*?<br[^>]*>Bewertung +([0-9\.,]+) +von#i', $resp['data'], $ary)) 
    {
        $data['rating'] = preg_replace('/,/','.', $ary[1]);;
    } 

    // Languages
    // Languages (as Array)
    $laguages = array(
        'arabisch' => 'arabic',
        'bulgarisch' => 'bulgarian',
        'chinesisch' => 'chinese',
        'tschechisch' => 'czech',
        'dänisch' => 'danish',
        'holändisch' => 'dutch',
        'englisch' => 'english',
        'französisch' => 'french',
        'deutsch' => 'german',
        'griechisch' => 'greek',
        'ungarisch' => 'hungarian',
        'isländisch' => 'icelandic',
        'indisch' => 'indian',
        'israelisch' => 'israeli',
        'italienisch' => 'italian',
        'japanisch' => 'japanese',
        'koreanisch' => 'korean',
        'norwegisch' => 'norwegian',
        'polnisch' => 'polish',
        'portugisisch' => 'portuguese',
        'rumänisch' => 'romanian',
        'russisch' => 'russian',
        'serbisch' => 'serbian',
        'spanisch' => 'spanish',
        'schwedisch' => 'swedish',
        'thailändisch' => 'thai',
        'türkisch' => 'turkish',
        'vietnamesisch' => 'vietnamese',
        'kantonesisch' => 'cantonese',
        'katalanisch' => 'catalan',
        'zypriotisch' => 'cypriot',
        'zyprisch' => 'cypriot',
        'esperanto' => 'esperanto',
        'gälisch' => 'gaelic',
        'hebräisch' => 'hebrew',
        'hindi' => 'hindi',
        'jüdisch' => 'jewish',
        'lateinisch' => 'latin',
        'mandarin' => 'mandarin',
        'serbokroatisch' => 'serbo-croatian',
        'somalisch' => 'somali'
    );
    $lang_list = array();
    if (preg_match('/<td.*?>Ton<\/td>.*?<td.*?>(.*?)<\/td>/i', $resp['data'], $ary) &&
        preg_match_all('/(\w+):/si', $ary[1], $langs, PREG_PATTERN_ORDER))
    {
        foreach($langs[1] as $language) {
            $language = trim(strtolower($language));
            $language = html_entity_decode(strip_tags($language));
            $language = preg_replace('/\s+$/','',$language);
            if (!$language) continue;
            if (isset($laguages[$language])) $language = $laguages[$language];
            else continue;
            if (!$language) continue;
            $lang_list[] = $language;
        }
        $data['language'] = trim(join(', ', array_unique($lang_list)));
    }

    // Plot
    if(
        preg_match('#<h3>Plot</h3>.*?<p>(.*?)</p>#i', $resp['data'], $ary)
    )
    {
        $ary[1] = preg_replace('/<br.*?>/',"\n",$ary[1]);
        $ary[1] = preg_replace('/\s*?$/','',html_entity_decode(strip_tags($ary[1])));
        $data['plot'] = trim($ary[1]);
    }


    // FSK
    if(preg_match('#<td.*>[ \s]*Freigabe</td>.*?<td.*?>.*?<div.*?>(.*?)</div></td>#', $resp['data'], $ary))
    {
    	$data['fsk'] = $ary[1];
    }
    
    // Genres
    $genres = array(
        'Reise' => '',
        'Ratgeber' => '',
        'Revuefilm' => '',
        'Serie' => '',
        'Special' => '',
        'Sport' => 'Sport',
        'TV-Movie' => '',
        'Unterhaltung' => '',
        'Biographie' => 'Biography',
        'Thriller' => 'Thriller',
        'Kriminalfilm' => 'Crime',
        'Science Fiction' => 'Sci-Fi',
        'Kinderfilm' => 'Family',
        'Familie' => 'Family',
        'Dokumentation' => 'Documentary',
        'Action' => 'Action',
        'Actionkomödie' => 'Comedy',
        'Drama' => 'Drama',
        'Abenteuer' => 'Adventure',
        'Historienfilm' => 'History',
        'Monumentalfilm' => '',
        'Komödie' => 'Comedy',
        'Romanze' => 'Romance',
        'Horror' => 'Horror',
        'Splatter' => 'Horror',
        'Western' => 'Western',
        'Erotik' => 'Adult',
        'Klassiker' => '',
        'Eastern' => '',
        'Musikfilm' => 'Musical',
        'Trickfilm' => 'Animation',
        'Anime' => 'Animation',
        'Animation' => 'Animation',
        'Fantasy' => 'Fantasy',
        'Filmoperette' => 'Musical',
        'Horrorkomödie' => 'Comedy',
        'Kriegsfilm' => 'War',
        'Musikdokumentation' => 'Music',
        'Mystery' => 'Mystery',
        'Roadmovie' => 'Thriller',
        'Satire' => 'Comedy',
        'Westernkomödie' => 'Western',
        'Musik' => 'Music',
        'Musik (Oper' => 'Music',
        'Musik (Pop' => 'Music',
        'Musik (Rock' => 'Music',
        'Zeichentrick' => 'Animation'
    );
    if (preg_match('#<td.*>Genre</td>.*?<ul>(.*?)</ul></td>#', $resp['data'], $ary)) {
    	if (preg_match_all('#<li><a.*?>(.*?)</a></li>#s', $ary[1], $gens, PREG_PATTERN_ORDER)) {
    		//
    	    foreach($gens[1] as $genre) {
		        $genre = trim(html_entity_decode($genre));
		        $genre = strip_tags($genre);
		        if (!$genre) continue;
		        if (isset($genres[$genre])) $data[genres][] = $genres[$genre];
		    }
		    
    	}
    }

    // Cast
    preg_match('/<td.*?>Schauspieler<\/td>.*?<td.*?>(.*?)<\/td>/i', $resp['data'], $ary);
    preg_match_all('/<a.*?>(.*?)<\/a>/si', $ary[1], $actors, PREG_PATTERN_ORDER);
    $actors = $actors[1];
    $casts = "";
    $role = "";
    $actorid = "";
    foreach($actors as $actor) {
        $actor = trim(strip_tags($actor));
        $actor = preg_replace('/\s+$/','',$actor);
        if (preg_match('/:$/',$actor)) continue;
        $casts .= trim($actor)."\n";
        $actorid = "";
    }
    $data['cast'] = trim($casts);
    if (preg_match('#^\s*\++\s*#',$data['cast'])) $data['cast'] ='';
    
    // EAN-Code
    if (preg_match('#<td.*?>EAN</td>.*?<td.*?>([0-9]+)</td>#i', $resp['data'], $ary))
    {
        $data['barcode'] = $ary[1];
    }

    // Video Aspect Ratio
    if (preg_match('/<td.*?>Bild<\/td>.*?<td.*?>(.*?)<\/td>/i', $resp['data'], $ary) && preg_match('#:#',$ary[1]))
    {
        $ary[1] = preg_replace('/\s*?$/','',html_entity_decode(strip_tags($ary[1])));
        $ary[1] = preg_replace('/<br>/',', ',$ary[1]);
        $ary[1] = preg_replace('/\s\s+/',' ',$ary[1]);
        // only trust data if ':' is present
        if (preg_match('/:/',$ary[1])) $data['comment'] .= "Bildformate: ".trim($ary[1])."\n";
    }
    
    // Audio Type
    if (preg_match('/<td.*?>Ton<\/td>.*?<td.*?>(.*?)<\/td>/i', $resp['data'], $ary) && preg_match('#:#',$ary[1]))
    {
        $ary[1] = preg_replace('/\s*$/','',html_entity_decode($ary[1]));
        $ary[1] = preg_replace('/\s\s+/',' ',$ary[1]);
        $ary = preg_split('/<br>/',$ary[1]);
        if (count($ary)>0) $data['comment'] .= "Tonformate:";
        foreach($ary as $audiodesc) 
        {
            if (trim($audiodesc)!='') $data['comment'] .= ' '.trim($audiodesc)."\n";
        }
    }
  
    return $data;
}

/**
 * Get an array of all previous prefixes for the ImdbId
 * 
 * @author  Chinamann <chinamann@users.sourceforge.net>
 * @return  array     Associative array with ImdbId prefixes
 */
function dvdbImdbIdPrefixes() 
{
	global $dvdbIdPrefix;
    return array($dvdbIdPrefix);
}

function dvdbDbg($text,$append = true) 
{
	file_append('debug.txt', $text, $append);
}

function myArrayJoin($ary1,$ary2) {
	foreach ($ary2 as $key => $val) {
		$ary1[$key] = $val;
	}
	return $ary1;
}


?>
