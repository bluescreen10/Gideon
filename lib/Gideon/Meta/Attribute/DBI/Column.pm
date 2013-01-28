package Gideon::Meta::Attribute::DBI::Column;
use Moose::Role;

Moose::Util::meta_attribute_alias('Gideon::DBI::Column');

has column      => ( is => 'ro', isa => 'Str' );
has primary_key => ( is => 'ro', isa => 'Bool' );
has serial      => ( is => 'ro', isa => 'Bool' );
has _is_dirty   => ( is => 'rw', isa => 'Bool', default => undef );
has _original_value => ( is => 'rw' );

after install_accessors => sub {
    my ( $self, $inline ) = @_;

    my $class = $self->associated_class;
    my $name  = $self->name;

    $class->add_before_method_modifier(
        $self->accessor => sub {
            return unless $_[1];
            return if $self->_is_dirty;

            $self->_original_value( $_[0]->$name() );
            $self->_is_dirty(1);
        }
    );
};

1;
