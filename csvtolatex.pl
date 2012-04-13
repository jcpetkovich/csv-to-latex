#!/usr/bin/perl -w
# csvtolatex.pl --- Convert csv to simple latex table.
# Author: Jean-Christophe Petkovich <me@jcpetkovich.com>
# Created: 13 Apr 2012
# Version: 0.01

use warnings;
use strict;
use autodie;
use Carp;
use Getopt::Long qw( :config auto_help );

my $sep  = ' & ';
my $line = '\hline';

my ( $ordering, @ordering );
GetOptions( 'order=s' => \$ordering );
@ordering = split /,/, $ordering;

# Parse header and decide ordering
my @header = split /,/, <>;
my %header;
if (@header) {
    chomp($_) for @header;

    # Use header as ordering if one wasen't requested
    @ordering = @header unless @ordering;

    # Make reverse lookup of header
    @header{ values @header } = keys @header;

    my @new_header;
    while (my ($index, $row_name) = each @ordering) {
        $new_header[$index] = $header[ $header{$row_name} ];
    }

    @new_header = map { '\textbf{' . $_ . '}' } @new_header;

    print "$line", join( $sep, @new_header ), "\\\\", " $line", " \n";
}
else {
    croak "You should have a header!";
}


while (<>) {
    my @row = split /,/;
    chomp($_) for @row;
    carp "missing a value!" if @row < @header;

    my @ordered_row;
    while ( my ( $index, $row_name ) = each @ordering ) {
        $ordered_row[$index] = $row[ $header{$row_name} ];
    }
    @row = @ordered_row;
    print join( $sep, @row ), "\\\\", " \n";
}

__END__

=head1 NAME

csvtolatex.pl - Turns a well behaving csv into a latex table.

=head1 SYNOPSIS

B<csvtolatex.pl> [options] file...

      -h --help                  Print this help documentation.
      --order [name[,name...]]   Change the order or omit elements.

=head1 DESCRIPTION

B<csvtolatex.pl> converts csv data into latex tables. If an ordering is
specified (with the names of the columns) then that ordering is used
for the final latex table. If columns are excluded from the ordering,
then they are omitted.

B<WARNING> the csv should have a well formed header (also comma seperated).

=head1 AUTHOR

Jean-Christophe Petkovich, E<lt>me@jcpetkovich.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Jean-Christophe Petkovich

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.2 or,
at your option, any later version of Perl 5 you may have available.

=head1 BUGS

None reported... yet.

=cut
