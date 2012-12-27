#! /usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Boggle;
use feature qw(say);

# visual representation of indices on Boggle grid
#  0  1  2  3
#  4  5  6  7
#  8  9 10 11
# 12 13 14 15

my %contiguous = (
     0 => [qw/1 4 5/],
     1 => [qw/0 2 4 5 6/],
     2 => [qw/1 3 5 6 7/],
     3 => [qw/2 6 7/],
     4 => [qw/0 1 5 8 9/],
     5 => [qw/0 1 2 4 6 8 9 10/],
     6 => [qw/1 2 3 5 7 9 10 11/],
     7 => [qw/2 3 6 10 11/],
     8 => [qw/4 5 9 12 13/],
     9 => [qw/4 5 6 8 10 12 13 14/],
    10 => [qw/5 6 7 9 11 13 14 15/],
    11 => [qw/6 7 10 14 15/],
    12 => [qw/8 9 13/],
    13 => [qw/8 9 10 12 14/],
    14 => [qw/9 10 11 13 15/],
    15 => [qw/10 11 14/],
);


#my $game = Boggle->new();
#my @sides = $game->roll();
my @sides = (qw(G B O I E B H R E P E E E H L K));


my %pos; my $i = 0;
for my $char ( @sides ) {
    push @{$pos{ $char }}, $i;
    ++$i;
}

my $word = shift || 'bee';
$word = uc($word);

my @possible;
my @temp;

#print Dumper \%contiguous;
my @valid = valid( $word );
#print Dumper \@valid;

say Dumper @possible;

my $counter = 0;
my $level   = 0;


# Does the word exist on the current boggle board, and what are the indexes of
# each char on the board? (Should return an arrayref, b/c some words will exist
# multiple times on the board).
sub valid {
    my $word  = shift;
    my $char  = substr($word,0,1);

    my $used  = shift || {};
    my $conti = shift || [ 0 .. $#sides ];
    my %conti = map { $_ => 1 } @$conti;

    my @valid = grep { !$used->{$_} && $conti{$_} } @{$pos{$char}};
    say "valid indices: " . join(', ', @valid);

    my @stuff;
    for my $index ( @valid ) {
        say "index: $index";
        push @temp, $index;
        $used->{$index}++;
        if ( length($word) == 1 ) {
            say "found a match! stop recursion!";
            push @possible, [ @temp ];
        #    pop  @temp;
        #    next;
        }
        @stuff = valid(substr($word,1), $used, $contiguous{ $index });
        pop  @temp;
        delete($used->{$index});
    }

    return @stuff;
}

# [ 1 4 8 ]
# [ 5 4 8 ]
# [ 5 8 4 ]
# [ 5 8 12 ]
# [ 5 10 11 ]

# $VAR1 = [ 1, 4, 8 ];
# $VAR2 = [ 5, 4, 8 ];
# $VAR3 = [ 5, 8, 4 ];
# $VAR4 = [ 5, 8, 12 ];
# $VAR5 = [ 5, 10, 11 ];

#   G   B   O   I
#   0   1   2   3
#
#   E   B   H   R
#   4   5   6   7
#
#   E   P   E   E
#   8   9   10   11
#
#   E   H   L   K
#   12   13   14   15

# print the standard Boggle grid
print '-'x25,"\n";
my $count = 0;
for my $char ( @sides ) {
    $count++;
    print '   ' . $char;
    if ( $count % 4 == 0 ) {
        #print "\n\n";
        print "\n";
        printf("   %d", ($count - $_)) for (qw(4 3 2 1));
        print "\n";
        print "\n";
    }
}
print '-'x25,"\n";
