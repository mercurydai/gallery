{*
  Output of search results/browselist
  $Id: list.tpl,v 1.15 2008/01/29 10:59:52 veal Exp $
*}

{if $listcolumns == 1}
    {assign var=imgWIDTH value="35"}
    {assign var=imgHEIGHT value="48"}
    {assign var=ROWSPAN value="2"}
{else}
    {assign var=imgWIDTH value="97"}
    {assign var=imgHEIGHT value="144"}
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
        <table>
        <tr>
            {if $video.imgurl}<td valign="top">
{*
                <a class="list_title" href="show.php?id={$video.id}">
                <img src="{$video.imgurl}" border="0" width="{$imgWIDTH}" height="{$imgHEIGHT}" align="left" />
                </a>
*}
                {html_image file=$video.imgurl link="show.php?id="|cat:$video.id align=left max_width=$imgWIDTH max_height=$imgHEIGHT}
            {if $listcolumns < 4}</td>{/if}
            {/if}

            {if $listcolumns < 4}<td valign="top" width="100%">{/if}
                <a class="list_title" href="show.php?id={$video.id}">{$video.title}{if $video.subtitle}- {$video.subtitle}{/if}</a>
                {if $listcolumns != 1}<br/>{/if}

                <span class="list_info">[{if $video.year}<a href="search.php?q={$video.year}&fields=year&nowild=1">{$video.year}</a>{if $video.director}; {/if}{/if}{if $video.director}<a href="search.php?q=%22{$video.director}%22&isname=Y">{$video.director}</a>{/if}]</span>
                <br/>

                <span class="list_plot">
                {$video.plot|truncate:250}
                <b><a class="list_plot" href="show.php?id={$video.id}">{$lang.more}</a></b>
                </span>
            </td>

            {if $listcolumns < 3}<td valign="top" align="right" nowrap="nowrap" style="text-align:right">
                <span class="list_diskid"><a href="search.php?q={$video.diskid}&fields=diskid&nowild=1">{$video.diskid}</a></span>
                <br/>
{*  changed to support mutiple languages
                {if $video.language}<a href="search.php?q={$video.language|escape:url}&fields=language&nowild=1">
                {if $video.flagfile}<img src="{$video.flagfile}" border="0" alt="{$video.language}" />{else}{$video.language}{/if}</a>{/if}
*}
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
{*
                <a href="edit.php?id={$video.id}">{$lang.edit}</a><br/>
                <a href="delete.php?id={$video.id}" onclick="return(confirm('{$video.title|escape:javascript|escape}: {$lang.really_del|escape:javascript|escape}?'))">{$lang.del}</a>
*}
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
