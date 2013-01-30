{*
  Template for the edit interface
  $Id: edit.tpl,v 1.21 2007/12/29 10:23:18 andig2 Exp $
*}

<script language="JavaScript" type="text/javascript" src="javascript/edit.js"></script>

<table width="100%" cellspacing="0" cellpadding="0">
<tr valign="top">
<td>


<div align="center">

{if $http_error}<h1>{$http_error}</h1><br/>{/if}

<form action="edit.php" id="edi" name="edi" method="post" enctype="multipart/form-data">
  <input type="hidden" name="id" id="id" value="{$video.id}" />
  <input type="hidden" name="engine" id="engine" value="{$engine}" />
  <input type="hidden" name="save" id="save" value="1" />

  <table class="tableedit">
  <tr valign="top">
      <td>

      <table>
        <tr valign="top">
          <td><span class="editcaption">{$lang.title}:</span></td>
          <td>
            <input type="text" name="title" id="title" value="{$video.q_title}" size="50" maxlength="255" />
            <a href="javascript:void(lookupData(document.edi.title.value))"><img src="images/search.gif" alt="" border="0" align="middle" /></a>
          </td>
        </tr>

        <tr valign="top">
          <td><span class="editcaption">{$lang.subtitle}:</span></td>
          <td>
            <input type="text" name="subtitle" id="subtitle" value="{$video.q_subtitle}" size="50" maxlength="255" />
            <a href="javascript:void(lookupData(document.edi.subtitle.value))"><img src="images/search.gif" alt="" border="0" align="middle" /></a>
          </td>
        </tr>

        <tr valign="top">
          <td><span class="editcaption">{$lang.language}:</span></td>
          <td>{$video.f_language}</td>
        </tr>

        <tr valign="top">
          <td><span class="editcaption">{$lang.diskid}:</span></td>
          <td>
            <input type="text" name="diskid" id="diskid" value="{$video.q_diskid}" size="15" maxlength="255" />
            <input type="hidden" name="autoid" id="autoid" value="{$autoid}" />
            <input type="hidden" name="oldmediatype" id="oldmediatype" value="{$video.mediatype}" />
            {$lang.mediatype} {html_options name="mediatype" options=$mediatypes selected=$video.mediatype}</td>
        </tr>

        <tr valign="top">
          <td><span class="editcaption"><label for="istv">{$lang.tvepisode}</label>:</span></td>
          <td>
            {if $video.istv}
                <input type="checkbox" name="istv" id="istv" value="1" checked="checked" />
            {else}
                <input type="checkbox" name="istv" id="istv" value="1" />
            {/if}</td>
        </tr>

        <tr valign="top">
          <td><span class="editcaption"><label for="seen">{$lang.seen}</label>:</span></td>
          <td>
            {if $video.seen}
                <input type="checkbox" name="seen" id="seen" value="1" checked="checked" />
            {else}
                <input type="checkbox" name="seen" id="seen" value="1" />
            {/if}</td>
        </tr>

        <tr valign="top">
          <td><span class="editcaption">{$lang.filename}:</span></td>
          <td><input type="text" name="filename" id="filename" value="{$video.q_filename}" size="50" maxlength="255" /></td>
        </tr>

        <tr valign="top">
          <td><span class="editcaption">{$lang.filesize}:</span></td>
          <td><input type="text" name="filesize" id="filesize" value="{$video.q_filesize}" size="10" maxlength="15" /> bytes</td>
        </tr>

        <tr valign="top">
          <td><span class="editcaption">{$lang.filedate}:</span></td>
          <td><input type="text" name="filedate" id="filedate" value="{$video.q_filedate}" size="18" maxlength="20" /></td>
        </tr>

        <tr valign="top">
          <td><span class="editcaption">{$lang.audiocodec}:</span></td>
          <td><input type="text" name="audio_codec" id="audio_codec" value="{$video.q_audio_codec}" /></td>
        </tr>

        <tr valign="top">
          <td><span class="editcaption">{$lang.videocodec}:</span></td>
          <td><input type="text" name="video_codec" id="video_codec" value="{$video.q_video_codec}" /></td>
        </tr>

        <tr valign="top">
          <td><span class="editcaption">{$lang.dimension}:</span></td>
          <td>
            <input type="text" name="video_width" id="video_width" value="{$video.q_video_width}" size="5" maxlength="4" /> x
            <input type="text" name="video_height" id="video_height" value="{$video.q_video_height}" size="5" maxlength="4" />
          </td>
        </tr>

          <tr>
            <td><span class="editcaption">{$lang.rating}:</span></td>
            <td>{rating_input value=$video.rating}</td>
          </tr>

        <tr valign="top">
          <td valign="top" colspan="2"><span class="editcaption">{$lang.genre}:</span>
            <br/>
            {$genreselect}
          </td>
        </tr>

        {if $video.custom1name}
        <tr valign="top">
            <td><span class="editcaption">{$video.custom1name}:</span></td>
            <td>{$video.custom1in}</td>
        </tr>
        {/if}

        {if $video.custom3name}
        <tr valign="top">
            <td><span class="editcaption">{$video.custom3name}:</span></td>
            <td>{$video.custom3in}</td>
        </tr>
        {/if}

      </table>
      </td>

      <td width="10">&nbsp;</td>

      <td>
      <table>

        <tr valign="top">
            <td><span class="editcaption">IMDb-ID:</span></td>
            <td>
                <input type="text" name="imdbID" id="imdbID" value="{$video.q_imdbID}" size="15" maxlength="30" onchange="changedId()" />
                {if $link}<span class="filterlink"><a href="{$link}" target="_blank">{$lang.visit}</a></span>{/if}
            </td>
        </tr>

        <tr valign="top">
            <td><span class="editcaption">{$lang.coverurl}:</span></td>
            <td>
                <input type="text" name="imgurl" id="imgurl" value="{$video.q_imgurl}" size="50" maxlength="255" />
                <a href="javascript:void(lookupImage(document.edi.title.value))"><img src="images/search.gif" alt="" border="0" align="middle" /></a>
            </td>
        </tr>

        <tr valign="top">
          <td><span class="editcaption">{$lang.coverupload}:</span></td>
          <td><input type="file" name="coverupload" id="coverupload" size="35" /></td>
        </tr>

        <tr valign="top">
          <td><span class="editcaption">{$lang.country}:</span></td>
          <td><input type="text" name="country" id="country" value="{$video.q_country}" size="50" maxlength="255" /></td>
        </tr>

        <tr valign="top">
          <td><span class="editcaption">{$lang.director}:</span></td>
          <td><input type="text" name="director" id="director" value="{$video.q_director}" size="50" maxlength="255" /></td>
        </tr>

        <tr valign="top">
          <td><span class="editcaption">{$lang.runtime}:</span></td>
          <td>
            <input type="text" name="runtime" id="runtime" value="{$video.q_runtime}" size="5" maxlength="5" />min
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$lang.year}
            <input type="text" name="year" id="year" value="{$video.q_year}" size="5" maxlength="4" />
          </td>
        </tr>

        <tr valign="top">
          <td><span class="editcaption">{$lang.plot}:</span></td>
          <td><textarea cols="40" rows="8" name="plot" id="plot" wrap="virtual">{$video.q_plot}</textarea></td>
        </tr>

        <tr valign="top">
          <td><span class="editcaption">{$lang.cast}:</span></td>
          <td><textarea cols="40" rows="8" name="actors" id="actors" wrap="off">{$video.q_actors}</textarea></td>
        </tr>

        <tr valign="top">
          <td><span class="editcaption">{$lang.comment}:</span></td>
          <td><textarea cols="40" rows="3" name="comment" id="comment" wrap="virtual">{$video.q_comment}</textarea></td>
        </tr>

        {if $video.custom2name}
        <tr valign="top">
            <td><span class="editcaption">{$video.custom2name}:</span></td>
            <td>{$video.custom2in}</td>
        </tr>
        {/if}

        {if $video.custom4name}
        <tr valign="top">
            <td><span class="editcaption">{$video.custom4name}:</span></td>
            <td>{$video.custom4in}</td>
        </tr>
        {/if}

        {if $owners}
        <tr valign="top">
            <td>{$lang.owner}</td>
            <td>
                {html_options name=owner_id options=$owners selected=$video.owner_id}
            </td>
        </tr>
        {/if}

      </table>
      </td>
    </tr>
  </table>

  {$lang.radio_look_caption}: {html_radios name=lookup options=$lookup checked="$lookup_id"}
</form>
</div>

<script language="JavaScript" type="text/javascript">
    document.edi.title.focus();
</script>


</td>
<td>


    <table cellspacing="1" cellpadding="0" border="0" class="content-tabelle">
    <tr class="reihe0">
        <td>
            <div id="links">
        {if $video.id}
            <form action="show.php" name="show">
                <input type="hidden" name="id" id="id" value="{$video.id}" />
                <div class="channelnavi">
                    <a href="javascript:document.show.submit()">{$lang.view}</a>
                </div>
            </form>
        {/if}

            <div id="links">
                <div class="channelnavi">
                    <a href="javascript:document.edi.submit()" accesskey="s">{$lang.save}</a>
                    <br/>
                </div>
            </div>

            </div>
        </td>
    </tr>
    </table>


</td>
</tr>
</table>
