{*
  Output of search results/browselist
  $Id: list.tpl,v 1.14 2008/01/29 10:59:52 veal Exp $
*}

{if $listcolumns == 1}
    {assign var=IMGWIDTH value="35"}
    {assign var=IMGHEIGHT value="48"}
    {assign var=ROWSPAN value="2"}
{else}
    {assign var=IMGWIDTH value="97"}
    {assign var=IMGHEIGHT value="144"}
    {assign var=ROWSPAN value="3"}
{/if}

<table width="100%" class="tablelist" cellspacing="0" cellpadding="0">
{counter start=0 print=false name=videocount}
{foreach item=video from=$list}

{if $count == 0}
    {cycle values="even,odd" assign=CLASS print=false}
    <tr class="{$CLASS}" valign="top">
{/if}

    <td {if $video.who}class="lent"{elseif $video.mediatype==$smarty.const.MEDIA_WISHLIST}class="wanted"{/if} width="{math equation="floor(100/x)" x=$listcolumns}%" align="left">
{*  uncomment this if you want the 'Browse' tab to remember last visited movie
    <a name="{$video.id}" />
*}
        <table>
        <tr>
            {if $video.imgurl}
            <td valign="top">
                <a class="list_title" href="show.php?id={$video.id}" onmouseover="domTT_activate(this, event, 'content', document.getElementById('{$video.id}'), 'styleClass', 'niceTitle');">
                {html_image file=$video.imgurl link=$link max_width=$IMGWIDTH max_height=$IMGHEIGHT align="left"}
                </a>
            <div id="tooltipPool" style="display: none">
                <div id="{$video.id}">
                    {html_image file=$video.imgurl max_width="400" max_height="400"}<br/>{$lang.tooltip_view}
                </div>
            </div>

            {if $listcolumns < 4}</td>{/if}
            {/if}

            {if $listcolumns < 4}<td valign="top" width="100%">{/if}
                <a class="list_title" href="show.php?id={$video.id}" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_view}', 'styleClass', 'niceTitle');">{$video.title}{if $video.subtitle}- {$video.subtitle}{/if}</a>

                            {if $listcolumns != 1}<br/>{/if}

                {if $video.year || $video.director}
                <span class="list_info">[
                    {if $video.year}
                        <a href="search.php?q={$video.year|escape:"url"}&amp;fields=year&amp;nowild=1" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_videodb_search} {$video.year}', 'styleClass', 'niceTitle');">{$video.year}</a>
                    {/if}
                    {if $video.director};
                        <a href="search.php?q={$video.director|escape:"url"}&amp;isname=Y" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_videodb_search} {$video.director}', 'styleClass', 'niceTitle');">{$video.director}</a>
                    {/if}]
                    </span>

                <br/>
                {/if}

                <span class="list_plot">
                {$video.plot}
                <b><a class="list_plot" href="show.php?id={$video.id}" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_view}', 'styleClass', 'niceTitle');">{$lang.more}</a></b>
                </span>
            </td>

            {if $listcolumns < 3}<td valign="top" align="diskid" nowrap="nowrap" style="text-align:right">
                <span class="list_diskid"><a href="search.php?q={$video.diskid}&fields=diskid&nowild=1">{$video.diskid}</a></span>
                <br/>
                {foreach item=itemlang from=$video.language}
                    {if $itemlang}<a href="search.php?q={$itemlang|escape:url}&fields=language">
                        {if $video.flagfile[$itemlang]}
                            <img src="{$video.flagfile[$itemlang]}" border="0" alt="{$itemlang}"/>
                        {else}
                            {$itemlang}
                        {/if}</a>
                    {/if}
                {/foreach}
                <br/>
                {if $video.seen}<span class="list_seen">{$lang.seen}</span><br/>{/if}

            {if $listcolumns == 1}</td>

            <td valign="top" align="center" nowrap="nowrap" style="text-align:center">{/if}
            {if $video.editable}
                <form action="edit.php" method="get">
                    <input type="hidden" name="id" value="{$video.id}"/>
                    <input type="submit" value="{$lang.edit}" class="button"/>
                </form>
                <form action="delete.php" method="get">
                    <input type="hidden" name="id" value="{$video.id}"/>
                    <input type="submit" value="{$lang.del}" onclick="return(confirm('{$video.title|escape:javascript|escape}: {$lang.really_del|escape:javascript|escape}?'))" class="button"/>
                </form>
            {/if}
            </td>{/if}
        </tr>
        </table>
    </td>

{counter assign=count name=videocount}
{if $count == $listcolumns}
    {counter start=0 print=false name=videocount}
    </tr>
{/if}

{/foreach}

{if $count != 0}
    {section name="columnLoop" start=$count loop=$listcolumns}
        <td class="{$CLASS}">&nbsp;</td>
    {/section}
    </tr>
{/if}

</table>
