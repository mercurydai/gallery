{*
  Template for the search interface
  $Id: search.tpl,v 1.10 2005/06/04 16:21:09 andig2 Exp $
*}

<script language="JavaScript" type="text/javascript" src="javascript/search.js"></script>

<table width="95%" cellspacing="2" cellpadding="0">
<tr><td class="forumheader3">
    {include file="searchengines.tpl"}

    <form action="search.php" id="search" name="search" method="get">
    <table cellspacing="2">
    <tr>
        <td valign="top">
            <table width="100%" border="0" cellpadding="5" cellspacing="0">
                <tr>
                    <td>
                        <span>{$lang.keywords}:</span>
                        <br/>
                        <input type="text" name="q" id="q" value='{$q_q}' size="40" maxlength="300"/>
                        <br/>
                        {include file="searchradios.tpl"}
                        <input type="button" value="{$lang.l_search}" onClick="submitSearch()" class="button" />
                    </td>
                </tr>
                <tr>
                    <td>{$lang.keywords_desc}</td>
                </tr>
            </table>
        </td>
        <td valign="top" nowrap="nowrap">
            <span>{$lang.fieldselect}:</span><br />
            <select name="fields[]" size="8" multiple="multiple">
            {html_options options=$search_fields selected=$selected_fields}
            </select><br />
            <span style="font-size:10px; font-weight: bold;"><a href="javascript:selectAllFields()">{$lang.selectall}</a></span>
        </td>
        <td valign="top" width="60%" rowspan="2">
            {if $owners}
            <span>{$lang.owner}:</span>
            {html_options name=owner options=$owners selected=$owner}<br/><br/>
            {/if}
            <span>{$lang.genre_desc}:</span>
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
