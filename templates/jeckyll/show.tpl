{*
  Template for the video detailview
  $Id: show.tpl,v 1.17 2008/01/08 08:56:17 andig2 Exp $
*}

<table width="95%" cellspacing="0" cellpadding="0">
<tr><td>
{if $video.editable || $video.copyable}
<table width="100%" cellspacing="2">
  <tr>
    <td class="forumheader3" align="right">
    <table cellpadding="0" cellspacing="2">
    <tr>
        <td>
        {if $video.copyable}
        <form action="edit.php" name="copyform">
            <input type="hidden" name="copyid" id="id" value="{$video.id}"/>
            <input type="hidden" name="copy" id="copy" value="1" />
            <input type="hidden" name="save" id="save" value="1" />
            <input type="submit" value="{$lang.copy}" class="button"/>
        </form>
        </td>
        {/if}
        {if $video.editable}
        <td>
        <form action="edit.php" name="editform">
            <input type="hidden" name="id" id="id" value="{$video.id}"/>
            <input type="submit" value="{$lang.edit}" class="button"/>
        </form>
        </td><td>
        <form action="borrow.php" name="borrowform">
            <input type="hidden" name="diskid" id="diskid" value="{$video.diskid}"/>
            <input type="submit" value="{$lang.borrow}" class="button"/>
        </form>
        </td><td>
        <form action="delete.php" name="deleteform">
            <input type="hidden" name="id" value="{$video.id}"/>
            <input type="submit" value="{$lang.del}" onclick="return(confirm('{$lang.really_del|escape:javascript|escape}?'))" class="button"/>
        </form>
        </td>
        {/if}
    </tr>
    </table>
    </td>
  </tr>
</table>
{/if}

<!-- content begin -->
<table width="100%" cellspacing="2">
  <tr>
    <td align="center" valign="top" rowspan="2" width="200" style="text-align:center" class="forumheader3">
    {if $link}
    {if $config.imdbBrowser}{assign var="link" value=$link|escape:"url"}{assign var="link" value="trace.php?videodburl=$link"}{/if}
    {/if}
{*  <a href="{$link}" title="{$lang.visit}">
    <img src="{$video.imgurl}" width="97" height="144" border="0" alt="" />{if $video.imdbID}</a>{/if} *}
    <span class="show_img" onmouseover="return makeTrue(domTT_activate(this, event, 'statusText', 'Nice cover', 'content', '<img src={$video.imgurl} border=0>'));">{html_image file=$video.imgurl link=$link max_width="97" max_height="144"} </span>
    {*html_image file=$video.imgurl link=$link max_width="97" max_height="144"*}
    </td>

    <td valign="top" colspan="2" class="forumheader3" align="left">
      <span class="show_title">{$video.title}</span>
      <a href="http://images.google.com/images?q=%22{$video.title|escape:url}%22&amp;hl=en&amp;lr=&amp;ie=UTF-8&amp;safe=off&amp;output=search" onmouseover="return makeTrue(domTT_activate(this, event, 'content', '{$lang.tooltip_google_imgsearch} {$video.title|escape:"javascript"}'));"><img src="templates/jeckyll/images/google.png" width="16" height="16" border="0" /></a>
       {if $video.subtitle}
       <br/>
       <span class="show_subtitle">{$video.subtitle}</span>
       {/if}
    </td>

    <td align="center" style="text-align:center" class="forumheader3">
      {if $video.diskid}
          <span class="show_id"><a href="search.php?q={$video.diskid}&fields=diskid&nowild=1">{$video.diskid}</a></span>
          {if $video.who}
            <br/>
            {$lang.notavail} {$video.who}
          {/if}
      {/if}
    </td>
  </tr>

  <tr valign="top">
    <td  class="forumheader3">
      <table>
        {if $video.year}
            <tr><td align="left"><b>{$lang.year}:</b></td><td align="left"><a href="search.php?q={$video.year}&fields=year&nowild=1">{$video.year}</a></td></tr>
        {/if}

        {if $video.director}
            <tr><td align="left"><b>{$lang.director}:</b></td><td align="left"><a href="search.php?q=%22{$video.director|escape:"url"}%22&isname=Y">{$video.director}</a></td></tr>
        {/if}

        {if count($video.country)}
            <tr><td align="left"><b>{$lang.country}:</b></td>
            <td align="left">
{*
            <a href="search.php?q=%22{$video.country|escape:url}%22&fields=country&nowild=1">{$video.country}</a>
*}
            {foreach item=country from=$video.country}
                <a href="search.php?q=%22{$country|escape:url}%22&fields=country">{$country}</a>
            {/foreach}
            </td></tr>
        {/if}

          <tr>
            <td valign="top"  align="left"><b>{$lang.seen}:</b></td>
            <td align="left">
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

    <td class="forumheader3">
      <table>
        {if $video.runtime > 0}
            <tr><td><b>{$lang.length}:</b></td><td><b>{math equation="floor(x/60)" x=$video.runtime}</b> hr(s) <b>{math equation="x - floor(x/60) * 60" x=$video.runtime}</b> min ({$video.runtime} min)</td></tr>
        {/if}

        {if $video.language}
{*
            <tr><td><b>{$lang.language}:</b></td><td><a href="search.php?q=%22{$video.language|escape:"url"}%22&fields=language&nowild=1">{$video.language}</a></td></tr>
*}
            <tr>
                <td><b>{$lang.language}:</b></td>
                <td>
                    {foreach item=language from=$video.language}
                        <a href="search.php?q=%22{$language|escape:url}%22&fields=language">{$language}</a>
                    {/foreach}
                </td>
            </tr>
        {/if}

        {if $video.mediatype}
            <tr><td><b>{$lang.mediatype}:</b></td><td><a href="search.php?q=%22{$video.mediatype|escape:"url"}%22&fields=mediatype&nowild=1">{$video.mediatype}</a></td></tr>
        {/if}

        {if $video.owner}
            <tr>
                <td><b>{$lang.owner}:</b></td>
                <td><a href="search.php?q={$video.owner|escape:"url"}&fields=owner&nowild=1">{$video.owner}</a>
                      {if $loggedin and $video.email and $video.owner != $loggedin and $video.who == '' and $video.diskid}
                      [ <a href="javascript:void(open('borrowask.php?id={$video.id|escape:"url"}&diskid={$video.diskid|escape:"url"}','borrowask','width=210,height=210,menubar=no,resizable=yes,scrollbars=yes,status=yes,toolbar=no'))">{$lang.borrowask}</a> ]
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

    <td class="forumheader3">
      {if $genres}
          <b>{$lang.genres}:</b><br/>
            {foreach item=genre from=$genres}
                  <a href="search.php?q=&genres[]={$genre.id}">{$genre.name}</a><br/>
            {/foreach}
      {/if}
    </td>
  </tr>
</table>


{if $video.plot}
<table width="100%">
  <tr>
    <td colspan="2" valign="top" style="text-align:justify" class="forumheader3">
      <b>{$lang.plot}:</b><br/>{$video.plot}<br/>
    </td>
  </tr>
</table>
{/if}

{if $video.filename}
<table width="100%" class="show_info">
  <tr>
    <td valign="top" class="forumheader3">
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

    <td valign="top" class="forumheader3">
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
<table width="100%">
  <tr valign="top">
    <td class="forumheader3">
        <b>{$lang.cast}:</b>
        <table width="100%">
        {counter start=0 print=false name=castcount}
        {foreach item=actor from=$video.cast}

        {if $count == 0}
        <tr valign="top">
        {/if}

            <td valign="top" width="{math equation="floor(100/x)" x=$config.castcolumns}%" class="forumheader3">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
        <td valign="top" align="left">
            {if $actor.imgurl}
                {assign var="link" value=$actor.imdburl}
            <!--a href="{if $config.imdbBrowser}{assign var="link" value=$link|escape:"url"}trace.php?videodburl={/if}{$link}">{html_image file=$actor.imgurl max_width=45 max_height=60 align=left}{*<img src="{$actor.imgurl}" width="38" height="52" border="0" align="left">*}</a-->
              {/if}
          <a href="search.php?q=%22{$actor.name|escape:"url"}%22&isname=Y">{$actor.name}</a>
          <br/>
          {foreach item=role from=$actor.roles}
                  {$role}<br/>
                {/foreach}
         </td>
         <td valign="top" width="25" style="text-align: right;">
        <a href="http://images.google.com/images?q=%22{$actor.name|escape:"url"}%22&amp;hl=en&amp;lr=&amp;ie=UTF-8&amp;safe=off&amp;output=search" onmouseover="return makeTrue(domTT_activate(this, event, 'content', '{$lang.tooltip_google_imgsearch} {$actor.name|escape:"javascript"}'));"><img src="templates/jeckyll/images/google.png" width="16" height="16" border="0"/></a>
        <br/>
        {assign var="link" value=$actor.imdburl}
        <a href="{if $config.imdbBrowser}{assign var="link" value=$link|escape:"url"}trace.php?videodburl={/if}{$link}"  onmouseover="return makeTrue(domTT_activate(this, event, 'statusText', '{$lang.searchimdb} {$actor.name|escape:"url"}', 'content', '{if $actor.imgurl}<img src={$actor.imgurl} border=0 /><br/>{/if}{$lang.searchimdb}<br/>{$actor.name|escape:"javascript"}'));"><img src="templates/jeckyll/images/person.gif" width="19" height="18" border="0" /></a>
        </td>
        </tr>
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
