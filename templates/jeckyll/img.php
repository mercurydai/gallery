<?
    $max = 100;

    $img = str_replace("%", "%25", $img);

    $im = imagecreatefromjpeg($img);

    if (!$im)
    {
	header("Content-type: image/gif");
        $im = imagecreatefromgif("../../images/nocover.gif");
        imagegif($im);
        imagedestroy($im);
        exit;
    }

    $origX = ImageSX($im);
    $origY = ImageSY($im);
    if (($origX > $max) || ($origY > $max))
    {
	if ($origX > $origY)
	{
	    $percent = $origX / $max;
	} else
	{
	    $percent = $origY / $max;
	}
	$myX = $origX / $percent;
	$myY = $origY / $percent;

	$im2 = imagecreatetruecolor($myX, $myY);
	imagecopyresized($im2, $im, 0, 0, 0, 0, $myX, $myY, $origX, $origY);
    } else
    {
	$im2 = $im;
    }

    header("Content-type: image/jpeg");
    imagejpeg($im2);

    imagedestroy($im);
    imagedestroy($im2);
																			    
?>
