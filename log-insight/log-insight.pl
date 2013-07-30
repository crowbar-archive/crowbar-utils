#!/usr/bin/env perl
#

use strict;
use warnings;
use IO::Dir;
use Time::Piece;
use Data::Dumper;

my $log_dir = '/opt/dell/crowbar_framework/log/';

if ( defined $ARGV[0] and -d $ARGV[0] ) {
  $log_dir = $ARGV[0];
} 

my @global_run_lists;

tie my %dir, 'IO::Dir', $log_dir;
foreach (keys %dir) {
  next unless /.log$/;
  next if /^dtest/;
  if (/chef_client.log$/) { &chef($_); next; } ;
  if (/production.log$/) { &prod($_); next; } ;
  # print $_, " ", $dir{$_}->size,"\n";
}

#print Dumper @run_lists;

print "\n\n";

#print @run_lists , "\n\n";
my @ordered = sort { $a->[0] <=> $b->[0] } @global_run_lists;

my $lame_html;
my @colors = ( 
     "#b58900;",
     "#cb4b16;",
     "#dc322f;",
     "#d33682;",
     "#6c71c4;",
     "#268bd2;",
     "#2aa198;",
     "#859900;"
   );
my @aliases = (
    "one",
    "two",
    "three",
    "four",
    "five",
    "seven",
    "eight",
    "nine",
    "ten"
  );

my %node_colors;
my %node_aliases;

$lame_html = '<table border=1><th>Date/Time</th><th>Node</th><th>Alias</th><th>#</th><th>Added</th><th>Removed</th></tr>' . "\n";

for ( @ordered ) {
  my $node_name = $_->[1];
  # colorize
  $node_colors{$node_name} = shift @colors unless $node_colors{$node_name}; 
  $node_aliases{$node_name} = shift @aliases unless $node_aliases{$node_name}; 

  my $t = Time::Piece->new($_->[0]);
  my $added = join("<br>", @{$_->[3]});
  my $removed = join("<br>", @{$_->[4]});

  $lame_html .= "<tr valign=top bgcolor=\'" . $node_colors{$node_name} ."\'>";
  $lame_html .= "<td>" . $t->ymd . " " . $t->hms . '</td>';
  $lame_html .= "<td>" . $node_name . '</td>';
  $lame_html .= "<td>" . $node_aliases{$node_name} . '</td>';
  $lame_html .= "<td>" . scalar @{$_->[2]} . '</td>';
  $lame_html .= "<td>" . $added . '</td>';
  $lame_html .= "<td>" . $removed . '</td>';
  $lame_html .= '</tr>'. "\n";

}
$lame_html .= '</table>' . "\n";
open my $fh1, ">", '/opt/dell/crowbar_framework/public/log-insight.html' or die $!;
print $fh1 $lame_html;



#print map {  print join ", ", @{$_}; print "\n\n"; } @ordered;

sub compare_run_lists {
  my $prev_rl = shift;
  my $curr_rl = shift;

  #print ref $prev_rl, ref $curr_rl;
  if ( @$prev_rl ~~ @$curr_rl ) {
    #print "same";
  }

  # stolen from PerlFAQ4
  my (@union, @not_in_prev, @not_in_curr);
  my %count = ();
  foreach my $element (@$prev_rl, @$curr_rl) { $count{$element}++ }
  foreach my $element (keys %count) {
    push @union, $element;
    $element ~~ @$prev_rl ? undef : push @not_in_prev, $element;
    $element ~~ @$curr_rl ? undef : push @not_in_curr, $element;
  }
  
  #print "removed:" . join(" ", @not_in_curr) . " " if @not_in_curr ;
  #print "added: " . join(" ", @not_in_prev) . " " if @not_in_prev ;
 
  return @not_in_curr, @not_in_prev;
}


sub chef() {
  my $filename = shift;
  my @run_lists;
  #print "reading " , $filename, "\n";
  open my $fh, "<", "${log_dir}/${filename}" or die $!;
  while (<$fh>) {
    if ( /\[(.*?)\].*?Run List expands to \[(.*)\]/ ){

      # Mon, 29 Jul 2013 21:29:32 +0000
      my $t = Time::Piece->strptime($1, "%a, %d %b %Y %T %z");

      my $rl = $2;
      $rl =~ s/,//g;
      my @run_list = split(/ /, $rl);
      my (@add, @remove);

      if ( scalar @run_lists eq 0 ) {
        @add = @run_list;
        #print "run_list 1: " , join " ", @run_list;
        #print "\n";
      }
      else {
        #print "run_list " . scalar @run_lists + 1 . ": ";
        (@add, @remove) = &compare_run_lists( $run_lists[-1], \@run_list );
        #print "run list: ", $run_lists[-1][2];
        #print "\n";
      }

      push @run_lists, [ @run_list ];
        #print $t->strftime("%a, %d %b %Y");
      push @global_run_lists, [ $t->epoch, $filename =~ /^(.*?)\./, [ @run_list ], [ @add ], [ @remove] ];
      next;
    }
  }
}

sub prod {
  return 0;
}

