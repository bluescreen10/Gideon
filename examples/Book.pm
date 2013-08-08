package Book;
use Gideon driver => 'DBI';

has id => (
    is     => 'rw',
    isa    => 'Int',
    traits => ['Gideon::DBI::Column']
);

has name => (
    is     => 'rw',
    isa    => 'Str',
    column => 'name',
    traits => ['Gideon::DBI::Column']
);

has author_id => (
    is     => 'rw',
    isa    => 'Int',
    traits => ['Gideon::DBI::Column']
);

has authors => (
    isa     => 'ArrayRef[Author]',
    through => 'BookAuthor',
    traits  => ['Gideon::RelationShip']
);

__PACKAGE__->meta->store("test:book");
__PACKAGE__->meta->make_immutable;
1;
