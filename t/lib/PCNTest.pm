use strict;
use warnings;
package PCNTest;
use Path::Class;
use File::Temp;

use Exporter;
our @ISA = qw/Exporter/;
our @EXPORT = qw/make_tree unixify/;

sub make_tree {
  my $td = File::Temp->newdir;
  for ( @_ ) {
    my $item = /\/$/ ? dir($td, $_) : file($td, $_);
    if ( $item->is_dir ) {
      $item->mkpath;
    }
    else {
      $item->parent->mkpath;
      $item->touch;
    }
  }
  return $td;
}

sub unixify {
    my ($arg, $td) = @_;
    $arg = "$arg";
    my $pc = -d $arg ? dir($arg) : file($arg);
    return $pc->relative($td)->as_foreign("Unix")->stringify;
}

1;

