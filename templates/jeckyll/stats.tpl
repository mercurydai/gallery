{*
  Template for the statistics page
  $Id: stats.tpl,v 1.8 2008/11/13 17:56:05 andig2 Exp $
*}
<table width="95%" border="0">
  <tr valign="top">
    <td align="center" class="forumheader3">
      <table>
		{if $owners}
        <tr valign="top">
          <td><span class="caption">{$lang.owner}:</span></td>
          <td><form action="stats.php">{html_options name=owner options=$owners selected=$owner onchange="submit()"}</form></td>
        </tr>
		{/if}
        <tr valign="top">
          <td><span class="caption">{$lang.totalfiles}:</span></td>
          <td>{$stats.count_all}</td>
        </tr>
        <tr valign="top">
          <td><span class="caption">{$lang.tv_episodes}:</span></td>
          <td>{$stats.count_tv}</td>
        </tr>
        <tr valign="top">
          <td><span class="caption">{$lang.numberdisks}:</span></td>
          <td>{$stats.count_disk}</td>
        </tr>
        <tr valign="top">
          <td><span class="caption">{$lang.videobygen}:</span><br/>{$lang.multiple}</td>
          <td>
          	<table cellspacing="0">
            {foreach item=row from=$stats.count_genre}
              <tr><td><a href="search.php?q=&genres[]={$row.id}">{$row.name}</a>:</td><td>{$row.count}</td></tr>
            {/foreach}
          	</table>
          </td>
        </tr>
        <tr valign="top">
          <td><span class="caption">{$lang.year}:</span></td>
          <td>
            <table cellpadding="2">
              <tr valign="top">
                <td valign="bottom" align="left" style="text-align:left"><small>{$stats.first_year|spacify:"<br/>"}</small></td>
                <td  colspan="2" valign="bottom" align="left" class="odd">
                {foreach key=year item=count from=$stats.count_year}<a href="search.php?q={$year}&fields=year&nowild=1"><img src="images/bar.gif" width="5" height="{$count}" title="{$year}: {$count}" border="0"></a>{/foreach}
                </td>
                <td valign="bottom" align="right" style="text-align:right"><small>{$stats.last_year|spacify:"<br/>"}</small></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
    <td align="center" class="forumheader3">
      <table>
        <tr valign="top">
          <td><span class="caption">{$lang.averagefilesize}:</span></td>
          <td>{$stats.avg_size} mb</td>
        </tr>
        <tr valign="top">
          <td><span class="caption">{$lang.totalsize}:</span></td>
          <td>{$stats.sum_size} gb</td>
        </tr>
        <tr valign="top">
          <td><span class="caption">{$lang.averageruntime}:</span></td>
          <td>{$stats.avg_time} min</td>
        </tr>
        <tr valign="top">
          <td><span class="caption">{$lang.totalruntime}:</span></td>
          <td>{$stats.sum_time} h</td>
        </tr>
        <tr valign="top">
          <td><span class="caption">{$lang.totalseen}:</span></td>
          <td>{$stats.seen_time} h</td>
        </tr>
        <tr valign="top">
          <td><span class="caption">{$lang.languages}:</span><br/></td>
          <td>
          	<table cellspacing="0">
            {foreach item=row from=$stats.count_lang}
              {if $row.language}<tr><td><a href="search.php?q={$row.language|escape:url}&fields=language">{$row.language}</a>:</td><td>{$row.count}</td></tr>{/if}
            {/foreach}
          	</table>
          </td>
        </tr>
        <tr valign="top">
          <td><span class="caption">{$lang.videobymedia}:</span></td>
          <td>
          	<table cellspacing="0">
            {foreach item=row from=$stats.count_media}
              <tr><td><a href="search.php?q={$row.name|escape:url}&fields=mediatype&nowild=1">{$row.name}</a>:</td><td>{$row.count}</td></tr>
            {/foreach}
          	</table>
          </td>
        </tr>
        <tr valign="top">
          <td><span class="caption">{$lang.videobyvcodec}:</span><br/></td>
          <td>
          	<table cellspacing="0">
            {foreach item=row from=$stats.count_vcodec}
              {if $row.video_codec}<tr><td><a href="search.php?q={$row.video_codec|escape:url}&fields=video_codec&nowild=1">{$row.video_codec}</a>:</td><td>{$row.count}</td></tr>{/if}
            {/foreach}
          	</table>
          </td>
        </tr>
        <tr valign="top">
          <td><span class="caption">{$lang.videobavcodec}:</span><br/></td>
          <td>
          	<table cellspacing="0">
            {foreach item=row from=$stats.count_acodec}
              {if $row.audio_codec}<tr><td><a href="search.php?q={$row.audio_codec|escape:url}&fields=audio_codec&nowild=1">{$row.audio_codec}</a>:</td><td>{$row.count}</td></tr>{/if}
            {/foreach}
          	</table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
