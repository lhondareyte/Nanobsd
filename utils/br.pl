#!/usr/bin/perl
#
use strict;

my $val;
my $c=8;

printf "static const uint8_t breath[TABLE_SIZE] = \n{\n\t";
sub funcCirc
{
	my $a = shift;
	my $r;
	$r = 16129 - (( $a - 127) * ( $a -127));
	return (sqrt($r));
}

sub funcSeg
{
	my $v = shift;
	if ( $v <= 70 ) 
	{
		return ($v * 3/7);
	}
	elsif ( $v <= 90 )
	{
		return ($v - 40);
	}
	else
	{
		return ((($v * 77) - 5080 ) / 37);
	}
}

for ($val = 0; $val <=127 ; $val++)
{
	if ( $c != 0) {
		$c--;
	}
	else {
		$c=7;
		printf "\n\t";
	}
	printf "%d, ",funcSeg($val);
	
}
printf"\n};";
