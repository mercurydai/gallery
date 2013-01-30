{*
  This is the footer which is displayed on bottom of every page
  $Id: footer.tpl,v 1.8 2008/10/19 10:45:28 andig2 Exp $
*}

{$DEBUG}

<table width="95%" border="0">
<tr valign="top">
	<td class="forumheader3"><a href="#top"><img src="images/top.gif" border="0" alt=""/></a></td>
	{if $loggedin}
	    <td style="text-align:left" nowrap="nowrap" class="forumheader3"><span>{$lang.loggedinas} {$loggedin}</span></td>
	{/if}

	{if $pageno && $maxpageno}
	    <td style="text-align:center" nowrap="nowrap" class="forumheader3">
		{if $pageno != 1}<a href="?pageno={$pageno-1}">[<<]</a>{/if}
		{$lang.page} {$pageno} {$lang.of} {$maxpageno}
		{if $pageno != $maxpageno}<a href="?pageno={$pageno+1}">[>>]</a>{/if}
	    </td>
	{/if}
	<td style="text-align:center" nowrap="nowrap" class="forumheader3">
	<span id="count">{$totalresults}</span> {$lang.records}.
	</td>

	{if $pdf}
	<td align="right" style="text-align:right" nowrap="nowrap" class="forumheader3" width="80">
	    <a href="{$pdf}export=pdf&ext=.pdf" target="_blank"><img src="images/pdfexport.png" border="0" style="float:right"/></a>
	</td>
	{/if}
	{if $xls}
	<td align="right" style="text-align:right" nowrap="nowrap" class="forumheader3" width="80">
	    <a href="{$xls}export=xls&ext=.xls" target="_blank"><img src="images/xlsexport.png" border="0" style="float:right"/></a>
	</td>
	{/if}
	{if $xml}
	<td align="right" style="text-align:right" nowrap="nowrap" class="forumheader3" width="80">
	    <a href="{$xml}export=xml" target="_blank"><img src="images/xmlexport.png" border="0" style="float:right"/></a>
	</td>
	{/if}
	{if $rss}
	<td align="right" style="text-align:right" nowrap="nowrap" class="forumheader3" width="80">
	    <a href="{$rss}export=rss" target="_blank"><img src="images/rssexport.png" border="0" style="float:right"/></a>
	</td>
	{/if}
	<td align="right" style="text-align:right" nowrap="nowrap" class="forumheader3" width="80">
	    <a href="http://www.videodb.net" class="splitbrain">v.{$version|strip}</a>
	</td>
</tr>
</table>

</body>
</html>