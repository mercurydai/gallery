{*
  Template for the search interface
  $Id: search.tpl,v 1.13 2005/09/23 10:50:38 chinamann Exp $
*}

<script language="JavaScript" type="text/javascript" src="javascript/search.js"></script>

<div class="content-box">

<table width="100%" class="tablelist" cellspacing="0" cellpadding="0">
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
                    <td>{$lang.keywords_desc}</td>
                </tr>
            </table>
        </td>
        <td valign="top" nowrap="nowrap">
            <span class="filterlink">{$lang.fieldselect}:</span><br />
            <select name="fields[]" size="8" multiple="multiple">
            {html_options options=$search_fields selected=$selected_fields}
            </select><br />
            <span class="filterlink" style="font-size:10px; font-weight: bold;"><a href="javascript:selectAllFields()">{$lang.selectall}</a></span>
        </td>
        <td valign="top" width="60%" rowspan="2">
            {if $owners}
            <span class="filterlink">{$lang.owner}:</span>
            {html_options name=owner options=$owners selected=$owner}<br/>
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

</div>

<script language="JavaScript" type="text/javascript">
    selectField(document.search.q);
</script>
