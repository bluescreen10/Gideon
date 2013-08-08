package Gideon::Driver::DBI;
use Moose;
use Gideon::Meta::Attribute::Trait::DBI::Column;
use SQL::Abstract::Limit;

with 'Gideon::Driver';

sub _find {
    my ( $self, $target, $query, $order_by, $limit ) = @_;

    my ( $dbh, $table ) = $self->_get_dbh_and_table($target);

    my $mapping = $self->_get_column_mapping($target);
    $query = $self->_translate_query( $query, $mapping );
    $order_by = $self->_translate_order_by( $order_by, $mapping );

    my @columns_names = values %$mapping;

    my ( $stmt, @bind ) =
      SQL::Abstract::Limit->new( limit_dialect => $dbh )
      ->select( $table, \@columns_names, $query, $order_by, $limit );

    my $sth = $dbh->prepare($stmt);
    $sth->execute(@bind);

    my @instances;

    while ( my $data = $sth->fetchrow_hashref ) {
        @$data{ keys %$mapping } = delete @$data{ values %$mapping };
        push @instances, $target->new(%$data);
    }

    return @instances;
}

sub _insert_object {
    my ( $self, $target ) = @_;

    my ( $dbh, $table ) = $self->_get_dbh_and_table($target);

    my @columns = $self->_get_columns($target);
    my ($serial) = map { $_->name } grep { $_->serial } @columns;
    my $mapping = $self->_get_column_mapping($target);

    my $values = {};
    $values->{ $mapping->{$_} } = $target->$_() for keys %$mapping;
    delete $values->{$serial} if $serial;

    my ( $stmt, @bind ) =
      SQL::Abstract::Limit->new( limit_dialect => $dbh )
      ->insert( $table, $values );

    my $sth = $dbh->prepare($stmt);
    my $rv  = $sth->execute(@bind);

    if ( $rv > 0 ) {
        my @columns = $self->_get_columns($target);

        if ( $serial and not defined $values->{$serial} ) {
            $target->$serial(
                $dbh->last_insert_id( undef, undef, $table, $serial ) );
        }
    }

    return 1 if $rv > 0;
}

sub _remove {
    my ( $self, $target, $orig_where, $limit ) = @_;

    my ( $dbh, $table ) = $self->_get_dbh_and_table($target);

    my $mapping = $self->_get_column_mapping($target);
    my $where = $self->_translate_query( $orig_where, $mapping );

    my ( $stmt, @bind ) =
      SQL::Abstract::Limit->new( limit_dialect => $dbh )
      ->delete( $table, $where, $limit );

    my $sth = $dbh->prepare($stmt);
    my $rv  = $sth->execute(@bind);

    return 1 if $rv > 0;
}

sub _remove_object {
    my ( $self, $target ) = @_;

    my $where = $self->_compute_primary_key($target);
    $self->_remove( $target, $where, 1 );
}

sub _update {
    my ( $self, $target, $orig_changes, $orig_where, $limit ) = @_;

    my ( $dbh, $table ) = $self->_get_dbh_and_table($target);

    my $mapping = $self->_get_column_mapping($target);
    my $where   = $self->_translate_query( $orig_where, $mapping );
    my $changes = $self->_translate_query( $orig_changes, $mapping );

    my ( $stmt, @bind ) =
      SQL::Abstract::Limit->new( limit_dialect => $dbh )
      ->update( $table, $changes, $where, $limit );

    my $sth = $dbh->prepare($stmt);
    my $rv  = $sth->execute(@bind);

    return 1 if $rv > 0;
}

sub _update_object {
    my ( $self, $target, $changes ) = @_;

    $changes ||= $self->_compute_changes($target);
    return 1 unless %$changes;

    my $where = $self->_compute_primary_key($target);
    my $rv = $self->_update( $target, $changes, $where, 1 );

    if ($rv) {
        my @columns = $self->_get_columns($target);
    }

    return $rv;
}

sub _compute_changes {
    my ( $self, $target ) = @_;

    my @columns = $self->_get_columns( ref $target );
    my $changes = {};

    $changes->{$_} = $target->$_() for map { $_->name } @columns;

    return $changes;
}

sub _compute_primary_key {
    my ( $self, $target ) = @_;

    my @columns = $self->_get_columns( ref $target );
    my @primary_key = grep { $_->primary_key } @columns;

    unless ( scalar @primary_key ) {
        @primary_key = @columns;
    }

    my $where = {};
    $where->{$_} = $target->$_() for map { $_->name } @primary_key;

    return $where;
}

sub _get_dbh_and_table {
    my ( $self, $target ) = @_;

    my ( $store, $table ) = split ':', $target->meta->store;
    my $dbh = Gideon::Registry->get_store($store);

    return ( $dbh, $table );
}

sub _get_columns {
    my ( $self, $target ) = @_;

    return
      grep { $_->does('Gideon::Meta::Attribute::Trait::DBI::Column') }
      $target->meta->get_all_attributes;
}

sub _get_column_mapping {
    my ( $self, $target ) = @_;

    my @columns         = $self->_get_columns($target);
    my @column_names    = map { $_->column || $_->name } @columns;
    my @attribute_names = map { $_->name } @columns;

    my %mapping;
    @mapping{@attribute_names} = @column_names;

    return \%mapping;
}

sub _translate_query {
    my ( $self, $orig_query, $mapping ) = @_;

    my $query = \%$orig_query;
    $query->{ $mapping->{$_} } = delete $query->{$_} for keys %$query;
    return $query;
}

sub _translate_order_by {
    my ( $self, $order_by, $mapping ) = @_;

    return unless $order_by;

    if ( ref $order_by eq 'HASH' ) {
        $order_by->{$_} = $mapping->{ $order_by->{$_} } for keys %$order_by;
    }

    elsif ( ref $order_by eq 'ARRAY' ) {
        my @new_order_by = map { $mapping->{$_} } @$order_by;
        $order_by = \@new_order_by;
    }

    else {
        my ( $column, $order ) = split( ' ', $order_by );
        $order_by = $mapping->{$column} . ( $order ? " $order" : '' );
    }

    return $order_by;
}

1;
