{*
  Output of login page
*}

<div id="topspacer"></div>

<div align="center">

<table>
<tr>
	<td align="center">

	<div id="communitybox">
		<br/>
		<p style="text-transform: uppercase;"><strong>{$lang.enterusername}</strong></p>

		<form action="login.php" id="login" name="login" method="post">
			<input type="hidden" value="{$refer}" name="refer"/>

			<table align="center">
			<tr valign="top">
				<td>{$lang.username}:</td>
				<td><input type="textbox" id="username" name="username"/></td>
			</tr>
			<tr valign="top">
				<td>{$lang.password}:</td>
				<td><input type="password" name="password"/></td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="checkbox" name="permanent" id="permanent" value="1" />
					<label for="permanent">{$lang.stayloggedin}</label>
				</td>
			</tr>

			<tr valign="top">
				<td colspan="2" style="text-align: center">
					<input type="submit" value="{$lang.login}" class="button"/>
				</td>
			</tr>
			</table>
		</form>

		<p>{$error}</p>
	</div>

	</td>
</tr>
</table>

</div>

<script language="JavaScript" type="text/javascript">
	document.forms['login'].username.focus();
</script>
