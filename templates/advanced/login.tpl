{*
  Output of login page
*}

<div id="topspacer"></div>

<table class="tableborder" style="background-color:#eeeeee;">
<tr><td align="center" style="text-align:center">
	<br/>
	<p>{$lang.enterusername}</p>

	<form action="login.php" method="post">
	<input type="hidden" value="{$refer}" name="refer"/>
	<table class="tableedit" align="center">
	<tr valign="top">
		<td>{$lang.username}:</td>
		<td><input type="textbox" name="username"/></td>
    </tr>
	<tr valign="top">
		<td>{$lang.password}:</td>
		<td><input type="password" name="password"/></td>
    </tr>
    <tr>
      <td colspan="2"><input type="checkbox" name="permanent" id="permanent" value="1" /><label for="permanent">{$lang.stayloggedin}</label></td>
    </tr>

	<tr valign="top">
		<td colspan="2" class="centered">
		    <input type="submit" value="{$lang.login}" class="button"/>
		</td>
    </tr>
	</table>
	</form>

	<p>{$error}</p>
</td></tr>
</table>
