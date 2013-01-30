<?php
/**
 * Template functions
 *
 * These functions prepare the data for assignment to the template engine
 *
 * @todo    comment callback functions
 *
 * @author  Andreas Goetz <cpuidle@gmx.de>
 * @package videoDB
 * @version $Id: trace.php,v 2.62 2010/04/04 10:32:55 andig2 Exp $
 */

require_once './core/functions.php';
require_once './core/httpclient.php';

// identifier for URL parameter
$urlid      = 'videodburl';
$striptags  = array('iframe','object','embed','ads','html','head','body','!DOCTYPE');

/**
 * Figures out which part of a given URI is server and path
 * Result in global $base_server and $base_path variables
 *
 * @param  string  $url      URI
 */
function get_base($url)
{
	global $uri;

	$uri = parse_url($url);
	if (!$uri['scheme']) $uri['scheme'] = 'http';
	if (!$uri['host']) $uri['host'] = 'localhost';
	if (!$uri['path']) $uri['path'] = '/';
	$uri['server'] = $uri['scheme'].'://'.$uri['host'];

	// remove filename from path if recognized file type
	$uri['path'] = preg_replace("/^(.*\/)(.*)$/i", '\\1', $uri['path']);
    
	// append trailing / if missing
	if (!preg_match("/\/$/", $uri['path'])) $uri['path'] .= '/';
}

/**
 * Figures out fully qualified, absolute URI for given (relative) URI,  
 * using global $base_server and $base_path variables
 *
 * @param  string  $url (relative) URI
 * @return string       fully qualified, absolute URI
 */
function get_full_url($url)
{
    global $uri, $config;

    // fully qualified?
    if (preg_match("/^http:\/\//", $url)) return $url;

    // local absolute path?
    if (preg_match("/^\//", $url)) {
        $url = $uri['server'].$url;
    } else {
        $url = preg_replace("/^\.\//", '', $url);
        $url = $uri['server'].$uri['path'].$url;
    }
	return $url;
}

/**
 * Helper function to enable http(s) redirects
 *
 * @return string       protocol scheme (http or https)
 */
function getScheme()
{
    #  || strtolower(substr($_SERVER["SERVER_PROTOCOL"],0,5)) != 'https'
    return (!isset($_SERVER['HTTPS']) || strtolower($_SERVER['HTTPS']) != 'on') ? 'http' : 'https';
}

/**
 * array_delete removes elements from array
 *
 * @param  array   $a       input array
 * @param  string  $i       index to delete from
 * @param  string  $count   number of items to delete
 * @return array            resulting array
 */
function array_delete($a, $i, $count = 1)
{
	$result = array_slice($a, 0, $i);

	foreach (array_slice($a, $i+$count) as $val)
	{
		array_push($result, $val);
	}

	return $result;
}

function tvcomId($url)
{
	global $uri;

	$id = false;
	if (preg_match('|/episode/(\d+)/summary\.html|', $url, $m))
	{
		if (preg_match('|/show/(\d+)/|', $uri[path], $n))
		{
			$id = $n[1].'-'.$m[1];
		}
	}
	
	return $id;
}

/**
 * Check if this item is already in the database
 */
function is_known_item($id, &$sp_id, &$sp_diskid)
{
    $SQL = "SELECT imdbID, id, diskid
              FROM ".TBL_DATA."
             WHERE imdbID = '".addslashes($id)."'
             ORDER BY diskid DESC";
    $result = runSQL($SQL);

    // do we know this movie?
    if (count($result) && isset($result[0]['imdbID']) && adultcheck($result[0]['id']) && check_videopermission(PERM_READ, $result[0]['id']))
    {
        $sp_id      = $result[0]['id'];
        $sp_diskid  = $result[0]['diskid'];
        if (!$sp_diskid) $sp_diskid = 'no_diskid';
        
        return true;
    }
    
    return false;
}

function _replace_enclosed_tag_traced($matches)
{
	global $urlid, $config, $uri, $page;

	// quotes
	$matches = array_delete($matches, 2);

	// get fully qualified url
	$url = get_full_url($matches[2]);
	$url = preg_replace("/&".session_name()."=[\d|\w]+$/", '', $url);

	// show anchor translation if debugging
	$note = ($config['debug']) ? "($matches[2] -> $url)" : '';

	$options = '';
	$title = strip_tags($matches[4]);
	
    // what's our host?
    $engine = (preg_match('/(imdb|amazon|tv|filmweb)/i', $uri['host'], $m)) ? $m[1] : '';
    
    if ($engine == 'imdb')
	{
		// imdb
		// fix for IMDB speciality: 2nd href inside first one
		if (preg_match("/http.*?http/i", $url)) 
		{
			return implode('', array_slice($matches,1));
		}

		// title link?
		// either /Title?0328828	(old-style or tiger-redirect)
		// or /title/tt0306734/	(new-style)
        if (preg_match("#/[Tt]itle(\?|/tt)(\d+)/?$#", $url, $m) && $title)
        {
            // don't link images to avoid matching the imdb page flicker
            if (!preg_match("/<img\s+/i", $matches[4]))
            {
                $append = ' <a href="edit.php?save=1&amp;lookup=2&amp;imdbID='.
                          urlencode("imdb:".$m[2]).'"><img src="'.img('add.gif').
                          '" valign="absmiddle" border="0" alt="Add Movie"/></a>';

                if (is_known_item('imdb:'.$m[2], $sp_id, $sp_diskid))
                {
                    $append.= ' <a href="show.php?id='.$sp_id.'"><img src="'.img('existing.gif').
                              '" title='.$sp_diskid.' valign="absmiddle" border="0" alt="Show Movie"/></a>';
                }
            }
        }
	}
    elseif ($engine == 'amazon')
	{
		// amazon
		if (preg_match("#exec/obidos/tg/detail/-/([0-9A-Z]{10,})/#", $url, $m)) 
		{
			$id = $m[1];
			$append .= ' <a href="edit.php?save=1&amp;lookup=2&amp;imdbID='.urlencode('amazon:'.$id).
				       '"><img src="'.img('add.gif').'" valign="absmiddle" border="0" alt="Add Movie"/></a>';
		}
	}
    elseif ($engine == 'tv')
	{
		// tvcom
        if (strstr($url, 'title') && false !== ($id = tvcomId($url)))
		{
			$subtitle = $title;
			$title = '';
			if (preg_match('|<h1>([^<]+)</h1>|si', $page, $m))
				$title = strip_tags($m[1]);
			$append .= ' <a href="edit.php?save=1&amp;lookup=2&amp;istv=1&amp;imdbID='.
					   urlencode('tvcom:'.$id).'"><img src="'.img('add.gif').
					   '" valign="absmiddle" border="0" alt="Add Movie"/></a>';
		}
	}
    elseif ($engine == 'filmweb')
	{
		// filmweb.pl
		if (preg_match("/[Ff]ilm[\?\.]id=(\d+)/i", $url, $m) && $title) 
		{
			$append = " <a href=\"edit.php?save=1&amp;engine=filmweb&amp;lookup=1&amp;imdbID=".
			          urlencode('filmweb:'.$m[1])."&amp;title="."\">".
			          '<img src="'.img('add.gif').'" valign="absmiddle" border="0" alt="Add Movie"/></a>';
		}
	}

	$url = getScheme().'://'.$_SERVER['HTTP_HOST'].$_SERVER['PHP_SELF']."?$urlid=".urlencode($url);

	return $matches[1].$url.$matches[3].$matches[4].$note.$matches[5].$append;
}

function _replace_tag($matches)
{
	global $urlid, $striptags;
	
	$url = get_full_url($matches[4]);
	if (in_array('ads', $striptags) && (strtolower($matches[2]) == 'img') && preg_match("/\/ads?\//i", $url)) return '';

	// switch on tag
	switch (strtolower($matches[2])) {
		case 'form' :	$append = "<input type='hidden' name='$urlid' value='$url'/>";
                        $url = getScheme().'://'.$_SERVER['HTTP_HOST'].$_SERVER['PHP_SELF'];
						break;
		case 'area' :	$parameters = "?$urlid=".urlencode($url);
                        $url = getScheme().'://'.$_SERVER['HTTP_HOST'].$_SERVER['PHP_SELF'];
						break;
	}

	return $matches[1].$url.$parameters.$matches[5].$append;
}

function _remove_tag($matches)
{
	return '';
}

function imdb_replace_title_callback($matches)
{
	global $uri;

	$result = $matches[1].$matches[2];

	if (preg_match("#/title/tt(.+)/#", $uri['path'], $m)) 
	{
        $result .= ' <a href="edit.php?save=1&amp;lookup=2&amp;imdbID='.
                    urlencode("imdb:".$m[1]).'"><img src="'.img('add.gif').
                    '" valign="absmiddle" border="0" alt="Add Movie"/></a>';

        if (is_known_item('imdb:'.$m[1], $sp_id, $sp_diskid))
        {
            $result .= ' <a href="show.php?id='.$sp_id.'"><img src="'.img('existing.gif').
                         '" title='.$sp_diskid.' valign="absmiddle" border="0" alt="Add Movie"/></a>';
        }
	}

	$result .= $matches[3];

	return $result;
}

function tvcom_replace_title_callback($matches)
{
	global $page, $uri;

	$result		= $matches[1].$matches[2];
	$subtitle	= html_entity_decode(strip_tags($matches[2]));		# fix names like &#34;ER&#34;
	$title		= '';
	if (preg_match('|<h1>([^<]+)</h1>|si', $page, $m))
		$title = html_entity_decode(strip_tags($m[1]));

	// Get id, can't use tvcomId()
	$id = false;
	if (preg_match('|/episode/(\d+)/|', $uri['path'], $m))
	{
		if (preg_match('|/show/(\d+)/summary\.html|', $page, $n))
		{
			$id = $n[1].'-'.$m[1];
		}
	}

	if (false !== $id) {
		$result .= ' <a href="edit.php?save=1&amp;lookup=2&amp;istv=1&amp;imdbID='.urlencode("tvcom:".$id).
				'"><img src="'.img('add.gif').'" valign="absmiddle" border="0" alt="Add Movie"/></a>';
	}
	$result .= '</h1>';

	return $result;
}


/**
 * HTML Code Conversion
 *
 * Converts HTML elements to allow proxying through trace.php
 * e.g. all href's are converted to trace.php?url=href links
 *
 * When a link of the IMDB movie title format is discovered, 
 * the "Add Disc" icon is appended, linking to edit.php with the correct disk id
 *
 * Note: this function is far from complete, more help is desired
 *
 * @param   string  $html   input HTML code including relative links etc.
 * @return  string          output HTML code with absolute proxied links, forms image maps etc.
 */
function fixup_HTML($html)
{
	global $striptags, $config, $uri;

	// base
	if (preg_match("/<base\s+href=(\"|')(.*?)\\1/i", $html, $matches)) get_base($matches[2]);

	// replace unwanted tags
	$html = preg_replace_callback("/(<\/?(".join("|",$striptags).")(\s+.*?)?>)/is", '_remove_tag', $html);

	// link, map/area
	$html = preg_replace_callback("/(<(link|area|base)\s+[^>]*?href\s*=\s*(\"|'))([^>]*?)(\\3.*?>)/is", '_replace_tag', $html);
	$html = preg_replace_callback("/(<(link|area|base)\s+[^>]*?href\s*=\s*([^\"']))([\d\w\.\/\+\%-:=&_]+?)(\s*[^>]*?>)/is", '_replace_tag', $html);
	// image, frame, script
	$html = preg_replace_callback("/(<(ima?ge?|frame|iframe|script)\s+[^>]*?src\s*=\s*(\"|'))([^>]*?)(\\3.*?>)/is", '_replace_tag', $html);
	$html = preg_replace_callback("/(<(ima?ge?|frame|iframe|script)\s+[^>]*?src\s*=\s*([^\"']))([\d\w\.\/\+\%-:=&_]+?)(\s*[^>]*?>)/is", '_replace_tag', $html);
	// form  
	$html = preg_replace_callback("/(<(form)\s+[^>]*?action\s*=\s*(\"|'))([^>]*?)(\\3[^>]*?>)/is", '_replace_tag', $html);
	$html = preg_replace_callback("/(<(form)\s+[^>]*?action\s*=\s*([^\"']))([\d\w\.\/\+\%-:=&_]+?)(\s*[^>]*?>)/is", '_replace_tag', $html);

	// href
	$html = preg_replace_callback("/(<a\s+[^>]*?href\s*=\s*(\"|'))([^>]*?)(\\2[^>]*?>)(.*?)(<\/a\s*>)/is", '_replace_enclosed_tag_traced', $html);
	$html = preg_replace_callback("/(<a\s+[^>]*?href\s*=\s*())([\d\w\.\/\+\%-:=&_]+)(\s*[^>]*?>)(.*?)(<\/a\s*>)/is", '_replace_enclosed_tag_traced', $html);

	// title
    if (stristr($uri['host'], 'imdb'))
    {
		$html = preg_replace_callback("/(<h1>)(.*?)(<span>)/si", 'imdb_replace_title_callback', $html);

        // imdb form does not accept utf8
        $html = preg_replace("/(form\s+.*?)(>)/i", '\\1 accept-charset="ISO-8859-1" \\2', $html );
	} 
    elseif (stristr($uri['host'], 'tv'))
    {
		$html = preg_replace_callback('|(<td[^>]+class="pr-10 pl-10">\s*<h1>)(.+?)(</h1>)|si', 'tvcom_replace_title_callback', $html);
	}
/*
	// strip flash
	$html = preg_replace('/if \(MM_FlashCanPlay\) \{.+?\{.+?\}/is', '', $html);
	// strip ads
	$html = preg_replace('/<script.*?pagead.*?<\/script>/i', '', $html);
	$html = preg_replace('/<!-- FLASH AD BEGINS .*? FLASH AD ENDS -->/is', '', $html);
	$html = preg_replace('/<!-- AD BOX begins .*? AD BOX ends -->/is', '', $html);
	$html = preg_replace('#<CENTER><script src="http://\w+.amazon.com.*?</CENTER>#mis', '', $html);
	$html = preg_replace('#<!-- ---- IMDB.*?Advertising.com---------- -->#mis', '', $html);
	// tvcom
	$html = preg_replace('/<!-- BEGIN RICH-MEDIA BURST! CODE .*? END BURST CODE -->/is', '', $html);
	$html = preg_replace('/<!-- FASTCLICK.COM .*?!-- FASTCLICK.COM .*? -->/is', '', $html);
*/
	return $html;
}

function request()
{
	global $urlid, $url;
	
	// get or post?
	$pass = ($_POST) ? $_POST : $_GET;

	// don't use $_REQUEST or cookies will screw up the query	
	foreach ($pass as $key => $value) 
    {
		switch ($key) 
        {
			case $urlid:
				$url = html_entity_decode(urldecode($value));
				break;				
			case session_name():
			case 'videodbreload':
				break;				
			default:
				if ($request) $request .= "&";
				$request .= "$key=$value";
		}
	}

	// going directly to trace.php without options?
	if (!$url) $url = 'http://www.imdb.com';

	// remove session identifier before request is sent or caching will not work
	$url = preg_replace("/&".SID."$/", "", $url);
	// workaround for fishy IMDB URLs
	$url = preg_replace("/\&amp;/", "&", $url);

	// append request parameters
	if ($_POST) {
		$post = $request;
	} elseif ($request) {
		$url .= "?".$request;
	}

    // encode possible spaces, use %20 instead of +
	$url = preg_replace('/ /','%20', $url);

    $response = httpClient($url, $_GET['videodbreload'] != 'Y', array('post' => $post));

	// url after redirect
	get_base($response['url']);

	if ($response['success'] != true)
    {
		$page = 'Error: '.$response['error'];
		if ($response['header']) $page .= '<br/>Header:<br/>'.nl2br($response['header']);
	}
    else
    {
		if (!$cache) putHTTPcache($url.$post, $response);
		$page = $response['data'];
	}
	return $page;
}

// make sure this is a local access
if (preg_match('/^https?:\/\/'.$_SERVER['SERVER_NAME'].'/i', $_SERVER['HTTP_REFERER']))
{
    // fetch URL
    $fetchtime = time();
    $page = request();
    $fetchtime = time() - $fetchtime;

    // convert HTML for output
    $page = fixup_HTML($page);

    // prepare templates
    tpl_page('imdbbrowser');

    $smarty->assign('url', $url);
    $smarty->assign('page', $page);
    $smarty->assign('fetchtime', $fetchtime);

    // display templates
    tpl_display('trace.tpl');
}
else
{
    errorpage('Access denied', 'Access to trace.php is allowed for local scripts only. Please make sure to send a referer to allow verification!');
}

?>
