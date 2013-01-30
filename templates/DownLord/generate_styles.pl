#!/usr/bin/perl

$my_base     = $ARGV[ 0 ];
$my_contrast = $ARGV[ 1 ];
$DEBUG       = $ARGV[ 2 ];

$steps = 10;
$down  = 0;

($r, $g, $b) = ($1, $2, $3) if ($my_base =~ /(..)(..)(..)/);

$down = 1 if (hex $r > 0xff / 2 || hex $g > 0xff / 2 || hex $b > 0xff / 2);
$DEBUG && $down && print "rendering colors downwards because the given value is too bright\n";

$DEBUG && print "using $my_base ($r,$g,$b)\n";

$/ = undef;
open(FH, "prototype.css.proto");
$output = <FH>;
close(FH);

#print $my_base. "\n";

for ($i = 2 ; $i <= $steps ; $i++)
{
   if ($down)
   {
      $nr = hex $r - (((hex $r) / $steps) * $i);
      $ng = hex $g - (((hex $g) / $steps) * $i);
      $nb = hex $b - (((hex $b) / $steps) * $i);
   }
   else
   {
      $nr = (((0xff - hex $r) / $steps) * $i) + hex $r;
      $ng = (((0xff - hex $g) / $steps) * $i) + hex $g;
      $nb = (((0xff - hex $b) / $steps) * $i) + hex $b;
   }

   $search = "XX_COLOR".$i."_XX";
   $nowcolor = sprintf("%2x%2x%2x", $nr, $ng, $nb);
   $output =~ s/$search/$nowcolor/gi;
   $DEBUG && print "$search = $nr $ng $nb = " . $nowcolor . "\n";
}

$output =~ s/XX_COLOR1_XX/$my_base/gi;
$output =~ s/XX_COLOR_CONTRAST_XX/$my_contrast/gi;

$DEBUG || print $output;
