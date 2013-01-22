use 5.010; # re::regexp_pattern
use strict;
use warnings;

package IO::All::Rule;
# ABSTRACT: File finder based on Path::Iterator::Rule, but using IO::All
# VERSION

use parent 'Path::Iterator::Rule';

use IO::All;
use IO::Dir;
use namespace::clean;

sub _objectify {
    my ( $self, $path ) = @_;
    return io($path);
}

sub _children {
    my $self = shift;
    my $path = shift;
    if ( $path->is_link ) {
        # IO::All can't seem to give symlink-path relative children, so
        # we construct the list by hand
        my $dir = IO::Dir->new("$path");
        return map { io("$path/$_") } grep { $_ ne "." && $_ ne ".." } $dir->read;
    }
    else {
        return $path->all;
    }
}

1;

=head1 SYNOPSIS

  use IO::All::Rule;

  my $rule = IO::All::Rule->new; # match anything
  $rule->file->size(">10k");     # add/chain rules

  # iterator interface
  my $next = $rule->iter( @dirs );
  while ( my $file = $next->() ) {
    ...
  }

  # list interface
  for my $file ( $rule->all( @dirs ) ) {
    ...
  }

=head1 DESCRIPTION

This module iterates over files and directories to identify ones matching a
user-defined set of rules.

This is a thin subclass of L<Path::Iterator::Rule> that operates on and returns
L<IO::All> objects instead of bare file paths.

See that module for details on features and usage.

=head1 EXTENDING

This module may be extended in the same way as C<Path::Iterator::Rule>, but
test subroutines receive C<IO::All> objects instead of strings.

Consider whether you should extend C<Path::Iterator::Rule> or C<IO::All::Rule>.
Extending this module specifically is recommended if your tests rely on having
a C<IO::All> object.

=head1 LEXICAL WARNINGS

If you run with lexical warnings enabled, C<Path::Iterator::Rule> will issue
warnings in certain circumstances (such as a read-only directory that must be
skipped).  To disable these categories, put the following statement at the
correct scope:

  no warnings 'Path::Iterator::Rule';

=cut

# vim: ts=4 sts=4 sw=4 et: