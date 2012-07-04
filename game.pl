#! /usr/bin/perl

use Modern::Perl;
use Data::Dumper;
use Boggle;

my $game = Boggle->new();

# print the standard Boggle grid
my $count = 0;
for my $char ( @{$game->faces} ) {
    $count++;
    print '   ' . $char;
    if ( $count % 4 == 0 ) {
        print "\n\n";
    }
}

