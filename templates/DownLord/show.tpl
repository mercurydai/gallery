{*
  Template for the video detailview
  $Id: show.tpl,v 1.22 2008/01/08 08:56:15 andig2 Exp $
*}

<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
  <td width="800" valign="top" class="content">
    <div class="content-box">
      <h1>{$video.title}</h1><br/>
      {if $video.subtitle}
        <h2>{$video.subtitle}</h2><br/>
      {/if}
      <table cellspacing="0" cellpadding="0" border="0" width="100%">
        <tr>
          <td>
                {if $video.plot}
                    <b>{$lang.plot}:</b><br/>{$video.plot}<br/>
                {/if}

                {if $video.filename}
                <table width="100%" class="show_info">
                <tr>
                    <td valign="top">
                        <table>
                        {if $video.filename}
                            <tr><td><b>{$lang.filename}:</b></td><td>{$video.filename}</td></tr>
                        {/if}
                        {if $video.filesize > 0}
                            <tr><td><b>{$lang.filesize}:</b></td><td>{$video.filesize} mb</td></tr>
                        {/if}
                        {if $video.filedate != "0000-00-00 00:00:00"}
                            <tr><td><b>{$lang.filedate}:</b></td><td>{$video.filedate}</td></tr>
                        {/if}
                        {if $video.audio_codec}
                            <tr><td><b>{$lang.audiocodec}:</b></td><td>{$video.audio_codec}</td></tr>
                        {/if}
                        {if $video.video_codec}
                            <tr><td><b>{$lang.videocodec}:</b></td><td>{$video.video_codec}</td></tr>
                        {/if}
                        {if $video.video_height > 0 || $video.video_width > 0}
                            <tr><td><b>{$lang.dimension}:</b></td><td>{$video.video_width}x{$video.video_height}<br /><br /></td></tr>
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
                <table width="100%">
                <tr  class="actors">
                    <td>
                        <h2>{$lang.cast}:</h2>
                    </td>
                </tr>
                <tr>
                    <td></td>
                </tr>

                <tr valign="top">
                <td>
                    <table width="100%">
                    {counter start=0 print=false name=castcount}
                    {foreach item=actor from=$video.cast}

                    {if $count == 0}
                    <tr valign="top">
                    {/if}

                    <td valign="top" width="{math equation="floor(100/x)" x=$config.castcolumns}%">
                    <dl>
                        {if $actor.imgurl}
                    {assign var="link" value=$actor.imdburl}
                    <a href="{if $config.imdbBrowser}{assign var="link" value=$link|escape:url}trace.php?videodburl={/if}{$link}">{html_image file=$actor.imgurl max_width=45 max_height=60 align=left}{*<img src="{$actor.imgurl}" width="38" height="52" border="0" align="left">*}</a>
                        {/if}

                        <dt><a href="search.php?q=%22{$actor.name|escape:url}%22&isname=Y">{$actor.name}</a></dt>
                        <dd>
                        {foreach item=role from=$actor.roles}
                            {$role}<br/>
                        {/foreach}
                        </dd>
                    </dl>
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

            </td>
    </tr>
  </table>
</div>
</td>
<td width="200" valign="top" class="content">
<div class="content">



<table cellspacing="1" cellpadding="0" border="0" width="100%" class="content-tabelle">
<tr class="reihe0">
    <td>
        {if $video.editable || $video.copyable}
            <div id="links">
            {if $video.copyable}
            <form action="edit.php" id="copyform" name="copyform">
                <input type="hidden" name="copyid" value="{$video.id}"/>
                <input type="hidden" name="copy" value="1" />
                <input type="hidden" name="save" value="1" />
                <div class="channelnavi">
                    <a href="javascript:document.copyform.submit()">{$lang.copy}</a>
                </div>
            </form>
            {/if}
            {if $video.editable}
            <form action="edit.php" id="editform" name="editform">
                <input type="hidden" name="id" value="{$video.id}"/>
                <div class="channelnavi">
                    <a href="javascript:document.editform.submit()">{$lang.edit}</a>
                </div>
            </form>
            <form action="borrow.php" id="borrowform" name="borrowform">
                <input type="hidden" name="diskid" value="{$video.diskid}"/>
                <div class="channelnavi">
                    <a href="javascript:document.borrowform.submit()">{$lang.borrow}</a>
                </div>
            </form>
            <form action="delete.php" id="deleteform" name="deleteform">
                <input type="hidden" name="id" value="{$video.id}"/>
                <div class="channelnavi">
                    <a href="javascript:if (confirm('{$lang.really_del|escape:javascript|escape}?')) document.deleteform.submit()">{$lang.del}</a>
                    <br/>
                </div>
            </form>
            {/if}
            </div>
        {else}
            <div id="topspacer"></div>
        {/if}
    </td>
</tr>
<tr class="reihe1">
    <td>
        {if $link}
            {if $config.imdbBrowser}{assign var="link" value=$link|escape:url}{assign var="link" value="trace.php?videodburl=$link"}{/if}
        {/if}
        {html_image file=$video.imgurl link=$link max_width="97" max_height="144"}
    </td>
</tr>
<tr class="reihe1">
    <td>
    <div id="videodata">
        <table>
        {if $video.year}
            <tr><td><b>{$lang.year}:</b></td><td><a href="search.php?q={$video.year}&fields=year&nowild=1">{$video.year}</a></td></tr>
        {/if}

        {if $video.director}
            <tr><td><b>{$lang.director}:</b></td><td><a href="search.php?q=%22{$video.director|escape:url}%22&isname=Y">{$video.director}</a></td></tr>
        {/if}

        {if count($video.country)}
            <tr><td><b>{$lang.country}:</b></td>
                <td>
                    {foreach item=country from=$video.country}
                        <a href="search.php?q=%22{$country|escape:url}%22&fields=country">{$country}</a>
                    {/foreach}
                </td>
            </tr>
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

        <table>
            {if $video.runtime > 0}
                <tr><td><b>{$lang.length}:</b></td><td><b>{math equation="floor(x/60)" x=$video.runtime}</b> hr(s) <b>{math equation="x - floor(x/60) * 60" x=$video.runtime}</b> min ({$video.runtime} min)</td></tr>
            {/if}

            {if $video.language}
                <tr>
                    <td><b>{$lang.language}:</b></td>
                    <td>
{*
                        <a href="search.php?q=%22{$video.language|escape:url}%22&fields=language&nowild=1">{$video.language}</a>
*}
                        {foreach item=language from=$video.language}
                            <a href="search.php?q=%22{$language|escape:url}%22&fields=language">{$language}</a>
                        {/foreach}
                    </td>
                </tr>
            {/if}

            {if $video.mediatype}
                <tr><td><b>{$lang.mediatype}:</b></td><td><a href="search.php?q=%22{$video.mediatype|escape:url}%22&fields=mediatype&nowild=1">{$video.mediatype}</a></td></tr>
            {/if}

            {if $video.owner}
                <tr>
                    <td><b>{$lang.owner}:</b></td>
                    <td><a href="search.php?q={$video.owner|escape:url}&fields=owner&nowild=1">{$video.owner}</a>
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
    </div>
    </td>
</tr>
</table>

    </div>
  </td>
</tr>
</table>

