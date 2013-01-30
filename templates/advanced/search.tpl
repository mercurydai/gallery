{*
  Template for the search interface
  $Id: search.tpl,v 1.9 2005/06/04 16:21:08 andig2 Exp $
*}

<script language="JavaScript" type="text/javascript" src="javascript/search.js"></script>

<table width="100%" cellspacing="0" cellpadding="0">
<tr><td>
    {include file="searchengines.tpl"}

    <form action="search.php" id="search" name="search" method="get">
    <table width="100%" class="tablefilter" cellspacing="5">
    <tr>
        <td valign="top" width="40%">
            <table width="100%" border="0" cellpadding="5" cellspacing="0">
                <tr>
                    <td width="20%">
                        <span class="filterlink">{$lang.keywords}:</span>
                        <br/>
                        <input type="text" name="q" id="q" value='{$q_q}' size="45" maxlength="300"/>
                        <br/>
                        {include file="searchradios.tpl"}
                        <input type="button" value="{$lang.l_search}" onClick="submitSearch()" class="button" />
                    </td>
                </tr>
                <tr>
                    <td><span class="filterlink">{$lang.keywords_desc}</span></td>
                </tr>
            </table>
        </td>
        <td valign="top" nowrap="nowrap" align="center" style="text-align:center">
            <span class="filterlink">{$lang.fieldselect}:</span><br />
            <select name="fields[]" size="8" multiple="multiple">
            {html_options options=$search_fields selected=$selected_fields}
            </select><br />
                                        <a href="#" onclick="for(var i = 0;i < document.search['fields[]'].length;i++) document.search['fields[]'].options[i].selected = true;"><span class="filterlink">{$lang.selectall}</span></a>
        </td>
        <td valign="top" width="60%" rowspan="2">
            {if $owners}
            <span class="filterlink">{$lang.owner}:</span>
            {html_options name=owner options=$owners selected=$video.owner_id}<br/>
            {/if}
            <span class="filterlink">{$lang.genre_desc}:</span>
            {$genreselect}
        </td>
        {if $imgurl}
        <td>
{*
            <a href='http://uk.imdb.com/Name?{$q_q|replace:"&quot;|\"":""|escape:url}'>{html_image file=$imgurl}</a>
*}
            <a href='http://uk.imdb.com/Name?{$q|replace:"&quot;|\"":""|escape:url}'>{html_image file=$imgurl}</a>
            <!--<img align=left src="{$imgurl}" border="0" width="97" height="144"/>-->
        </td>
        {/if}
    </tr>
    </table>
    </form>
</td></tr>
</table>

<script language="JavaScript" type="text/javascript">
    selectField(document.search.q);
</script>
