{*
  Trailer popup
  $Id: trailer.tpl,v 1.4 2011/02/11 07:42:10 andig2 Exp $
*}
{include file="xml.tpl"}

<body>

<script language="JavaScript" type="text/javascript" src="javascript/lookup.js"></script>

<div class="tablemenu">
	<div style="height:7px; font-size:1px;"></div>
    <span class="tabActive"><a href="#">YouTube Trailers</a></span>
</div>

<div id="topspacer"></div>

{if $trailer}
<table width="100%" cellspacing="0" cellpadding="0">

{foreach item=match from=$trailer}
	<tr>
		<td>

		<object width="425" height="350">
			<param name="movie" value="{$match}"></param>
			<param name="wmode" value="transparent"></param>
			<embed src="{$trailerid}" type="application/x-shockwave-flash" wmode="transparent" width="425" height="350"></embed>
		</object>

		</td>
	</tr>
{/foreach}

</table>
{/if}

</body>
</html>
