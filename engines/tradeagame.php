<?php
/**
 * trade-a-game.de purchase parser
 *
 * @package Engines
 * @author  Andreas Götz    <cpuidle@gmx.de>
 *
 * @link    http://www.trade-a-game.de/suchen?q=scrubs
 *
 * @version $Id: tradeagame.php,v 1.3 2010/02/18 15:17:25 andig2 Exp $
 */

$GLOBALS['tradeagameServer']    = 'http://www.trade-a-game.de';

define('AFFILINET', 'http://partners.webmasterplan.com/click.asp?ref=447048&site=5261&type=b351&bnb=351&diurl=');

/**
 * Get meta information about the engine
 *
 * @todo    Include image search capabilities etc in meta information
 */
function tradeagameMeta()
{
    return array('name' => 'Trade-a-Game', 'stable' => 1, 'capabilities' => array('purchase'));
}

/**
 * Get Url to search tradeagame for an item
 *
 * @param   string    The search string
 * @return  string    The search URL (GET)
 */
function tradeagameSearchUrl($title)
{
    global $tradeagameServer;
    return $tradeagameServer."/suchen?q=".urlencode($title);
}

/**
 * Search an image on tradeagame
 *
 * Searches for a given title on the tradeagame and returns the found links in
 * an array
 *
 * @param   string    The search string
 * @return  array     Associative array with id and title
 */
function tradeagameSearch($title)
{
    global $CLIENTERROR;
    global $tradeagameServer;

    $page   = 1;
    $data   = array();
    $data['encoding'] = 'utf-8';
#    $data['bestprice']= 1e6;

    $url    = tradeagameSearchUrl($title);
    
    do
    {
        $resp = httpClient($url, 1);
        if (!$resp['success']) $CLIENTERROR .= $resp['error']."\n";
#       dump($resp);

        if (!preg_match('#<table id="article_overview">(.+?)</table>#is', $resp['data'], $t)) return null;

        if (!preg_match_all('#<td class="image">.*?href="(.+?)".*?src="(.+?)".+?<h4>(.+?)</h4>.*?<div class="used_new_cont">(.+?)<p class="annotation">#is', $t[1], $m, PREG_SET_ORDER)) return null;

        foreach ($m as $row) 
        {
            $res    = array();
            $title  = trim(preg_replace('#[ \t\r\n]+#', ' ', strip_tags($row[3])));
            $url    = $tradeagameServer.$row[1];
            $img    = $row[2];
            
            $price  = preg_replace('#<form .+?/form>#is', '', $row[4]);
            $price  = trim(preg_replace('#[ \t\r\n]+#', ' ', strip_tags($price)));
            $price  = preg_replace('/....Info/', '', $price);

            $bestprice = 0;
            // find best price
            if (preg_match_all('#(\d+[\.,]\d\d)#', $price, $m)) {
                foreach ($m as $row) {
                    $bestprice  = doubleval(preg_replace('/,/', '.', $row[0]));
                    if ($bestprice < $data['bestprice']) $data['bestprice'] = $bestprice;
                }
            }    

            // add available items only    
            if ($bestprice > 0)
            {
                $res['title']    = $title;
                $res['subtitle'] = $price;
                $res['imgsmall'] = $img;
                $res['coverurl'] = $img;
                $res['url']      = AFFILINET.$url;
#               dump($res);
                $data[]          = $res;
            }    
        }
        
        $url = (preg_match('#<a href="(.+?)">..vor</a>#i', $resp['data'], $m) && $m[1] != '#') ? $tradeagameServer.$m[1] : '';
#       dump($url);
    }
    while ($url);
    
#   dump($data);
    
    return $data;
}

?>