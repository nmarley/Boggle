package Boggle;
{ $Boggle::VERSION = '0.01'; }

use Moose;
use Modern::Perl;
use Data::Dumper;
use Carp;
  
has 'dice' => (
    is => 'ro',
    isa => 'ArrayRef[Boggle::Die]',
    writer => 'set_dice',
);

has 'faces' => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    writer => 'set_faces',
);

sub BUILD {
    my $self = shift;

    my @sides= ( [ qw/N I G E V T/ ],
                 [ qw/W R L G I U/ ],
                 [ qw/D U N O T K/ ],
                 [ qw/C I T A O A/ ],
                 [ qw/A Z E V D N/ ],
                 [ qw/B A J O M Qu/ ],
                 [ qw/N E P I S H/ ],
                 [ qw/R O F I B X / ],
                 [ qw/R E L A S C/ ],
                 [ qw/M A D E C P/ ],
                 [ qw/H I F E E Y/ ],
                 [ qw/S O W E D N/ ],
                 [ qw/P U L E S T/ ],
                 [ qw/R A M O S H/ ],
                 [ qw/T I Y A L B/ ],
                 [ qw/G U Y E K L/ ] );

    my @dice = map { Boggle::Die->new(sides => $_) } @sides;
    $self->set_dice( \@dice );

    # initial roll. We won't make the user call roll() after instantiation
    $self->roll();
}

sub roll {
    my $self = shift;
    my @faces =  map { $_->roll } @{$self->dice};
    $self->set_faces( \@faces );
}

1;

package Boggle::Die;
{ $Boggle::Die::VERSION = '0.01'; }

use Moose;
use Modern::Perl;
use Data::Dumper;
use Carp;

has 'sides' => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
);

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    if ( @_ == 1 && !ref $_[0]) {
        return $class->$orig(sides => @_);
    }
    else {
        return $class->$orig(@_);
    }

};


sub BUILD {
    my $self = shift;

    if (@{$self->sides} != 6) {
        croak "Error: Die must have 6 sides.";
    }
}

sub roll {
    my $self = shift;
    my @sides = @{$self->sides};
    return $sides[ int(rand(@sides)) ];
}

1;


# These side values come directly from actual Boggle pieces
# 1.  N I G E V T
# 2.  W R L G I U 
# 3.  D U N O T K
# 4.  C I T A O A
# 5.  A Z E V D N
# 6.  B A J O M Qu
# 7.  N E P I S H
# 8.  R O F I B X 
# 9.  R E L A S C
# 10. M A D E C P
# 11. H I F E E Y
# 12. S O W E D N
# 13. P U L E S T
# 14. R A M O S H
# 15. T I Y A L B
# 16. G U Y E K L


