{*
  Template for the video detailview
  $Id: show.tpl,v 1.16 2008/01/08 08:56:15 andig2 Exp $
*}

<table width="100%" class="tablelist" cellspacing="0" cellpadding="0">
<tr><td>
{if $video.editable || $video.copyable}
<table width="100%" class="tablefilter" cellspacing="5">
  <tr>
    <td width="100%">&nbsp;</td>
    {if $video.editable}
    <td>
        <form action="edit.php" name="copyform" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_copyform}', 'styleClass', 'niceTitle');">
            <input type="hidden" name="copyid" value="{$video.id}"/>
            <input type="hidden" name="copy" id="copy" value="1" />
            <input type="hidden" name="save" id="save" value="1" />
            <input type="submit" value="{$lang.copy}" class="button"/>
        </form>
    </td>
    {/if}
    {if $video.editable}
    <td>
        <form action="edit.php" name="editform" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_editform}', 'styleClass', 'niceTitle');">
            <input type="hidden" name="id" value="{$video.id}"/>
            <input type="submit" value="{$lang.edit}" class="button"/>
        </form>
    </td><td>
        <form action="borrow.php" name="borrowform" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_borrowform}', 'styleClass', 'niceTitle');">
            <input type="hidden" name="diskid" id="diskid" value="{$video.diskid}"/>
            <input type="submit" value="{$lang.borrow}" class="button"/>
        </form>
    </td><td>
        <form action="delete.php" name="deleteform" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_deleteform}', 'styleClass', 'niceTitle');">
            <input type="hidden" name="id" id="id" value="{$video.id}"/>
            <input type="submit" value="{$lang.del}" onclick="return(confirm('{$lang.really_del|escape:javascript|escape}?'))" class="button"/>
        </form>
    </td>
    {/if}
  </tr>
</table>
{else}
    <div id="topspacer"></div>
{/if}

<!-- content begin -->
<table width="100%" class="show_info" cellspacing="5">
  <tr>
    <td align="center" valign="top" rowspan="2" width="200" style="text-align:center">
    {if $link}
    {if $config.imdbBrowser}{assign var="link" value=$link|escape:url}{assign var="link" value="trace.php?videodburl=$link"}{/if}
    {/if}

    <span class="show_img" onmouseover="domTT_activate(this, event, 'content', document.getElementById('{$video.imgurl|regex_replace:"/[\/+?&=]/":"-"}'), 'styleClass', 'niceTitle', 'type', 'velcro');">
        {html_image file=$video.imgurl link=$link max_width="144" max_height="144"}
    </span>

    </td>
    <td valign="top" colspan="2">
      <span class="show_title">{$video.title|escape:"html"}</span>&nbsp;
        <a href="http://images.google.com/images?q=%22{$video.title|escape:"url"}%22&amp;hl=en&amp;lr=&amp;ie=UTF-8&amp;safe=off&amp;output=search" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_google_imgsearch} {$video.title|escape:html}', 'styleClass', 'niceTitle');">
          <img src="templates/advanced/images/google.png" width="16" height="16" border="0" />
        </a>
       {if $video.subtitle}
       <br/>
       <span class="show_subtitle">{$video.subtitle|escape:"html"}</span>
       {/if}
    </td>

    <td align="center" style="text-align:center">
      {if $video.diskid}
          <span class="show_id" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_searchfor}<b> {$video.diskid}', 'styleClass', 'niceTitle');"><a href="search.php?q={$video.diskid}&amp;fields=diskid&amp;nowild=1">{$video.diskid}</a></span>
          {if $video.who}
            <br/>
            {$lang.notavail} {$video.who}
          {/if}
      {/if}
    </td>
  </tr>

  <tr valign="top">
    <td>
      <table>
        {if $video.year}
            <tr><td><b>{$lang.year}:</b></td><td><a href="search.php?q={$video.year}&amp;fields=year&amp;nowild=1" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_searchfor}<b> {$video.year}', 'styleClass', 'niceTitle');">{$video.year}</a></td></tr>
        {/if}

        {if $video.director}
            <tr><td><b>{$lang.director}:</b>
             </td>
             <td>
             <a href="search.php?q=%22{$video.director|escape:url}%22&amp;isname=Y" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_searchfor}<b> {$video.director|escape:html}', 'styleClass', 'niceTitle');">{$video.director}</a>
             </td></tr>
        {/if}

        {if $video.country}
            <tr><td><b>{$lang.country}:</b></td>
            <td>
{*
            <td><a href="search.php?q=%22{$video.country|escape:url}%22&amp;fields=country&amp;nowild=1">{$video.country}</a>
*}
            {foreach item=country from=$video.country}
                <a href="search.php?q=%22{$country|escape:url}%22&amp;fields=country" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_searchfor}<b> {$country}', 'styleClass', 'niceTitle');">{$country}</a>
            {/foreach}
            </td></tr>
        {/if}

          <tr>
            <td valign="top"><b>{$lang.seen}:</b></td>
            <td>
              <form action="show.php" name="show" id="show">
                <input type="hidden" name="id" id="id" value="{$video.id}" />
                <input type="hidden" name="save" id="save" value="1" />
                {if $video.seen}
                    {if $video.editable || $loggedin}
                        <input type="checkbox" name="seen" id="seen" value="1" checked="checked" onclick="submit()" />
                    {/if}
                    <label for="seen">{$lang.yes}</label>
                {else}
                    {if $video.editable || $loggedin}
                        <input type="checkbox" name="seen" value="1" onclick="submit()" />
                    {/if}
                {/if}
              </form>
            </td>
          </tr>

          <tr>
            <td><b>{$lang.rating}:</b></td>
            <td>{html_rating value=$video.rating}</td>
          </tr>

      </table>
    </td>

    <td>
      <table>
        {if $video.runtime > 0}
            <tr><td><b>{$lang.length}:</b></td><td><b>{math equation="floor(x/60)" x=$video.runtime}</b> hr(s) <b>{math equation="x - floor(x/60) * 60" x=$video.runtime}</b> min ({$video.runtime} min)</td></tr>
        {/if}

        {if $video.language}
            <tr>
                <td>
                    <b>{$lang.language}:</b>
                </td>
                <td>
{*
                    <a href="search.php?q=%22{$video.language|escape:url}%22&amp;fields=language&amp;nowild=1">{$video.language}</a>
*}
                    {foreach item=language from=$video.language}
                        <a href="search.php?q=%22{$language|escape:url}%22&fields=language">{$language}</a>
                    {/foreach}
                </td>
            </tr>
        {/if}

        {if $video.mediatype}
            <tr><td><b>{$lang.mediatype}:</b></td><td><a href="search.php?q=%22{$video.mediatype|escape:url}%22&amp;fields=mediatype&amp;nowild=1">{$video.mediatype}</a></td></tr>
        {/if}

        {if $video.owner}
            <tr>
                <td><b>{$lang.owner}:</b></td>
                <td><a href="search.php?q={$video.owner|escape:url}&amp;fields=owner&amp;nowild=1" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_searchfor}<b> {$video.owner|escape:html}', 'styleClass', 'niceTitle');">{$video.owner}</a>
                      {if $loggedin and $video.email and $video.owner != $loggedin and $video.who == '' and $video.diskid}
                      [ <a href="javascript:void(open('borrowask.php?id={$video.id|escape:url}&diskid={$video.diskid|escape:url}','borrowask','width=210,height=210,menubar=no,resizable=yes,scrollbars=yes,status=yes,toolbar=no'))">{$lang.borrowask}</a> ]
                      {/if}
                </td>
            </tr>
        {/if}
        {if $video.custom1name && $video.custom1out}
            <tr>
                <td valign="top"><b>{$video.custom1name}:</b></td>
                <td>{$video.custom1out}</td>
            </tr>
        {/if}
        {if $video.custom2name && $video.custom2out}
            <tr>
                <td valign="top"><b>{$video.custom2name}:</b></td>
                <td>{$video.custom2out}</td>
            </tr>
        {/if}
        {if $video.custom3name && $video.custom3out}
            <tr>
                <td valign="top"><b>{$video.custom3name}:</b></td>
                <td>{$video.custom3out}</td>
            </tr>
        {/if}
        {if $video.custom4name && $video.custom4out}
            <tr>
                <td valign="top"><b>{$video.custom4name}:</b></td>
                <td>{$video.custom4out}</td>
            </tr>
        {/if}
      </table>
    </td>

    <td>
      {if $genres}
          <b>{$lang.genres}:</b><br/>
            {foreach item=genre from=$genres}
                  <a href="search.php?q=&amp;genres%5b%5d={$genre.id}" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_searchfor}<b> {$genre.name}', 'styleClass', 'niceTitle');">{$genre.name}</a><br/>
            {/foreach}
      {/if}
    </td>

  </tr>
</table>


{if $video.plot}
<table width="100%" class="show_plot">
  <tr>
    <td colspan="2" valign="top" style="text-align:justify">
      <b>{$lang.plot}:</b><br/>{$video.plot}<br/>
    </td>
  </tr>
</table>
{/if}

{if $video.comment != ''}
<table width="100%" class="show_plot">
  <tr>
     <td colspan="2" valign="top" style="text-align:justify">
              <b>{$lang.comment}:</b><br/>{$video.comment}<br/>
    </td>
  </tr>
</table>
{/if}

{if $video.filename}
<table width="100%" class="show_info">
  <tr>
    <td valign="top">
      <table>
        {if $video.filename}
            <tr><td valign="top"><b>{$lang.filename}:</b></td><td valign="top">{$video.filename}</td></tr>
        {/if}
        {if $video.filesize > 0}
            <tr><td valign="top"><b>{$lang.filesize}:</b></td><td valign="top">{$video.filesize} mb</td></tr>
        {/if}
        {if $video.filedate != "0000-00-00 00:00:00"}
            <tr><td valign="top"><b>{$lang.filedate}:</b></td><td valign="top">{$video.filedate}</td></tr>
        {/if}
        {if $video.audio_codec}
            <tr><td valign="top"><b>{$lang.audiocodec}:</b></td><td valign="top">{$video.audio_codec}</td></tr>
        {/if}
        {if $video.video_codec}
            <tr><td valign="top"><b>{$lang.videocodec}:</b></td><td valign="top">{$video.video_codec}</td></tr>
        {/if}
        {if $video.video_height > 0 || $video.video_width > 0}
            <tr><td valign="top"><b>{$lang.dimension}:</b></td><td valign="top">{$video.video_width}x{$video.video_height}<br /><br /></td></tr>
        {/if}
      </table>
    </td>

    <td valign="top">
      <table>
        {if $video.comment}
            <tr>
              <td valign="top"><b>{$lang.comment}:</b></td>
              <td valign="top">{$video.comment}</td>
            </tr>
        {/if}

        {if $video.custom1name && $video.custom1out}
            <tr>
              <td valign="top"><b>{$video.custom1name}:</b></td>
              <td valign="top">{$video.custom1out}</td>
            </tr>
        {/if}

        {if $video.custom2name && $video.custom2out}
            <tr>
              <td valign="top"><b>{$video.custom2name}:</b></td>
              <td valign="top">{$video.custom2out}</td>
            </tr>
        {/if}

        {if $video.custom3name && $video.custom3out}
            <tr>
              <td valign="top"><b>{$video.custom3name}:</b></td>
              <td valign="top">{$video.custom3out}</td>
            </tr>
        {/if}

        {if $video.custom4name && $video.custom4out}
            <tr>
              <td valign="top"><b>{$video.custom4name}:</b></td>
              <td valign="top">{$video.custom4out}</td>
            </tr>
        {/if}

      </table>
    </td>
  </tr>
</table>
{/if}

{if $video.actors}
<table width="100%" class="show_info">
  <tr valign="top">
    <td>
        <b>{$lang.cast}:</b>
        <table width="100%">
        {counter start=0 print=false name=castcount}
        {foreach item=actor from=$video.cast}

        {if $count == 0}
        <tr valign="top">
        {/if}

    <td valign="top" width="{math equation="floor(100/x)" x=$config.castcolumns}%">
        <table width="100%"  class="show_plot">
            <tbody>
                <tr>
                    <td align="center" rowSpan="2" colspan="1" width="32" valign="top">{assign var="link" value=$actor.imdburl}
                        <a href="{if $config.imdbBrowser}{assign var="link" value=$link|escape:url}trace.php?videodburl={/if}{$link}"  onmouseover="domTT_activate(this, event, 'content', document.getElementById('{$actor.imgurl|regex_replace:"/[\/+?&=]/":"-"}'), 'styleClass', 'niceTitle');">{html_image file=$actor.imgurl max_width="30" max_height="43"}</a></td>
                    <td width="18" align="center" valign="top" rowSpan="2" colspan="1">
                        <a href="http://images.google.com/images?q=%22{$actor.name|escape:"url"}%22&amp;hl=en&amp;lr=&amp;ie=UTF-8&amp;safe=off&amp;output=search" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_google_imgsearch}<b> {$actor.name|escape:html}', 'styleClass', 'niceTitle');">{html_image file="templates/advanced/images/google.png" width="16" height="16"}</a></td>
                    <td>
                        <a href="search.php?q=%22{$actor.name|escape:"url"}%22&amp;isname=Y" onmouseover="domTT_activate(this, event, 'content', '{$lang.tooltip_videodb_search}<b> {$actor.name|escape:html}', 'styleClass', 'niceTitle');">{$actor.name}</a>{if $actor.roles >= 1} {$lang.asactor}: {/if}</td>
                </tr>
                <tr>

                    <td>
                        {if $actor.roles >= 1}
                            {foreach item=role from=$actor.roles}
                                {$role}<r/>
                            {/foreach}
                        {/if}
                    </td>
                </tr>
            </tbody>
        </table>
    </td>

          {counter assign=count name=castcount}
          {if $count == $config.castcolumns}
            {counter start=0 print=false name=castcount}
          </tr>
          {/if}
        {/foreach}
        {if $count != 0}
            {section name="columnLoop" start=$count loop=$config.castcolumns}
                <td>&nbsp;</td>
            {/section}
            </tr>
        {/if}
        </table>
    </td>
    </tr>
</table>
{/if}

<!-- content end -->
</td></tr></table>

<div id="tooltipPool" style="display: none">
        <div id="{$video.imgurl|regex_replace:"/[\/+?&=]/":"-"}">
            <a href="{$video.imgurl}">{html_image file=$video.imgurl max_width="400" max_height="400"}<br/> {$lang.tooltip_coverlink}</a>
        </div>
    {foreach item=actor from=$video.cast}
        <div id="{$actor.imgurl|regex_replace:"/[\/+?&=]/":"-"}">
            {if $actor.imgurl!="images/nocover.gif"}{html_image file=$actor.imgurl}{/if}<br/> {$lang.tooltip_imdb_search|escape:html} {$actor.name|escape:html}
        </div>
    {/foreach}
</div>
