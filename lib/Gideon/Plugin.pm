package Gideon::Plugin;
use Moose;

has next => ( is => 'rw', required => 1 );

sub find_one {
    my $self = shift;
    $self->next->find_one(@_);
}

sub find {
    my $self = shift;
    $self->next->find(@_);
}

sub update {
    my $self = shift;
    $self->next->update(@_);
}

sub save {
    my $self = shift;
    $self->next->save(@_);
}

sub remove {
    my $self = shift;
    $self->next->save(@_);
}

__PACKAGE__->meta->make_immutable;
1;
