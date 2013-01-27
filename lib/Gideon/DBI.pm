package Gideon::DBI;

use Moose;
use Gideon::Meta::Attribute::DBI::Column;
use SQL::Abstract::Limit;

with 'Gideon::Driver';

sub _find {
    my ( $class, $target, $query, $order_by, $limit ) = @_;

    my ( $dbh, $table ) = $class->_get_dbh_and_table($target);

    my $mapping = $class->_get_column_mapping($target);
    $query = $class->_translate_query( $query, $mapping );
    $order_by = $class->_translate_order_by( $order_by, $mapping );

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

sub _update {
    my ( $class, $target, $orig_changes, $orig_where ) = @_;

    my ( $dbh, $table ) = $class->_get_dbh_and_table($target);

    my $mapping = $class->_get_column_mapping($target);
    my $where   = $class->_translate_query( $orig_where, $mapping );
    my $changes = $class->_translate_query( $orig_changes, $mapping );

    my ( $stmt, @bind ) =
      SQL::Abstract::Limit->new( limit_dialect => $dbh )
      ->update( $table, $changes, $where );

    my $sth = $dbh->prepare($stmt);
    my $rv  = $sth->execute(@bind);

    return 1 if $rv > 0;
}

sub _update_object {
    my ( $class, $target, $changes ) = @_;

    my $where = $class->_compute_primary_key($target);
    $class->_update( $target, $changes, $where );
}

sub _compute_primary_key {
    my ( $class, $target ) = @_;

    my @columns = $class->_get_columns( ref $target );
    my @primary_key = grep { $_->primary_key } @columns;

    unless ( scalar @primary_key ) {
        @primary_key = @columns;
    }

    my $where = {};
    $where->{$_} = $target->$_() for map { $_->name } @primary_key;
    return $where;
}

sub _get_dbh_and_table {
    my ( $class, $target ) = @_;

    my ( $store, $table ) = split ':', $target->meta->store;
    my $dbh = Gideon::StoreRegistry->store($store);

    return ( $dbh, $table );
}

sub _get_columns {
    my ( $class, $target ) = @_;

    return
      grep { $_->does('Gideon::Meta::Attribute::DBI::Column') }
      $target->meta->get_all_attributes;
}

sub _get_column_mapping {
    my ( $class, $target ) = @_;

    my @columns         = $class->_get_columns($target);
    my @column_names    = map { $_->column || $_->name } @columns;
    my @attribute_names = map { $_->name } @columns;

    my %mapping;
    @mapping{@attribute_names} = @column_names;

    return \%mapping;
}

sub _translate_query {
    my ( $class, $orig_query, $mapping ) = @_;

    my $query = \%$orig_query;
    $query->{ $mapping->{$_} } = delete $query->{$_} for keys %$query;
    return $query;
}

sub _translate_order_by {
    my ( $class, $order_by, $mapping ) = @_;

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

sub _remove        { ... }
sub _remove_object { ... }

1;
