#!/usr/bin/perl
#Author: Sajeed Mohammad Shahriat and Naseef Mansoor
#Affiliation: Rochester Institute of Technology (RIT)
#All rights reserved-2017 The materials are open source and can be re-used and modified, given that the copyright headers in this file is NOT removed

use strict;
use warnings;

############################INPUTS#################################
my $num_col = 3;
my $num_row = 3;
my $inject_buffer = 528;
my $bw = 16;
my $packet = 16;
my $net_name = "testtorus";
my $node_type = "EndNode";
my $router_type = "Switch";
my $link_type = "Bidirectional";
###################################################################
my $filename = 'torus.ini';
open (my $fh, '>', $filename) or die "could not open file '$filename' $!";

my $nodes = $num_col * $num_row;
my $num_of_n =  $nodes - 1;

print $fh ";-------------- Torus Network--------------\n";
print $fh "[Network.$net_name]\n";
print $fh "DefaultInputBufferSize = $inject_buffer\n";
print $fh "DefaultOutputBufferSize = $inject_buffer\n";
print $fh "DefaultBandwidth = $bw\n";
print $fh "DefaultPacketSize = $packet\n";

#######define all the nodes#######################################
print $fh "\n;define all the nodes\n";
for (my $i = 0; $i<=$num_of_n; $i=$i+1){
	print $fh "[Network.$net_name.Node.N$i]\n";
	print $fh "Type = $node_type\n"; 
}

#######define all the switches####################################
print $fh "\n;define all the switches\n";
for (my $i = 0; $i<=$num_of_n; $i=$i+1){
	print $fh "[Network.$net_name.Node.S$i]\n";
	print $fh "Type = $router_type\n"; 
}

#######define all the links between nodes and switches############
print $fh "\n;define all the links between nodes and switches\n";
for (my $i = 0; $i<=$num_of_n; $i=$i+1){
	print $fh "[Network.$net_name.Link.N$i-S$i]\n";
	print $fh "Type = $link_type\n";
	print $fh "Source = N$i\nDest = S$i\n";
}

#######define all the links between switches######################
print $fh "\n;define all the links between switches\n";
my $current_switch = 0;
for (my $i = 0; $i<=$num_of_n; $i=$i+1){
	if(($current_switch + 1) % $num_col != 0 || $current_switch == 0){		
		my $switch_x = $current_switch + 1;
		print $fh "[Network.$net_name.Link.S$current_switch-S$switch_x]\n";
		print $fh "Type = $link_type\n";
		print $fh "Source = S$current_switch\nDest = S$switch_x\n";
	}
	else{
		my $switch_h = $current_switch - $num_col + 1 ;
		print $fh "[Network.$net_name.Link.S$current_switch-S$switch_h]\n";
		print $fh "Type = $link_type\n";
		print $fh "Source = S$current_switch\nDest = S$switch_h\n";	
	}

	my $switch_y = $current_switch + $num_col;
	if($switch_y <= $num_of_n || $current_switch == 0 ){		
		print $fh "[Network.$net_name.Link.S$current_switch-S$switch_y]\n";
		print $fh "Type = $link_type\n";
		print $fh "Source = S$current_switch\nDest = S$switch_y\n";
	}
	else{
		my $switch_v = $current_switch - ($num_col * ($num_row - 1)) ;
		print $fh "[Network.$net_name.Link.S$current_switch-S$switch_v]\n";
		print $fh "Type = $link_type\n";
		print $fh "Source = S$current_switch\nDest = S$switch_v\n";		
	}
	$current_switch = $current_switch + 1;
}


###################################################################
close $fh;
print "a torus network file was successfully created\n";

#endcode
