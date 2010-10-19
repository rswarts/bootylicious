package Bootylicious::Comment;

use strict;
use warnings;

use base 'Bootylicious::Document';

use Bootylicious::Article;
use Bootylicious::Timestamp;
use File::stat;

sub new {
    my $self   = shift->SUPER::new;
    my %params = @_;

    foreach my $method (qw/author email url content/) {
        $self->$method($params{$method}) if defined $params{$method};
    }

    return $self;
}

sub created {
    Bootylicious::Timestamp->new(epoch => stat(shift->path)->mtime);
}
sub email { shift->metadata(email => @_) }
sub url   { shift->metadata(url   =>) }

sub create {
    my $self = shift;
    my $path = shift;

    open my $file, '>:encoding(UTF-8)', $path or return;

    $self->path($path);

    print $file 'Author: ', $self->author || '', "\n";
    print $file 'Email: ',  $self->email  || '', "\n";
    print $file 'Url: ',    $self->url    || '', "\n";
    print $file "\n";
    print $file $self->content || '';
}

sub number {
    my $self = shift;

    my $path = $self->path;

    my ($number) = ($path =~ m/-(\d+)$/);

    return $number;
}

sub article {
    my $self = shift;

    my $path = $self->path;
    $path =~ s/\.comment-(\d+)$//;

    return Bootylicious::Article->new(path => $path);
}

1;
