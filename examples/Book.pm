package Book;
use Gideon driver => 'DBI';
use DateTime;
use DateTime::Format::MySQL;

has id => (
    is          => 'rw',
    isa         => 'Int',
    serial      => 1,
    primary_key => 1,
    traits      => ['Gideon::DBI::Column'],
);

has name => (
    is     => 'rw',
    isa    => 'Str',
    column => 'name',
    traits => ['Gideon::DBI::Column']
);

has created_at => (
    is       => 'rw',
    isa      => 'DateTime',
    default  => sub { DateTime->now },
    traits   => [ 'Gideon::DBI::Column', 'Gideon::DBI::Inflate::DateTime' ],
);

# has authors => (
#     isa     => 'ArrayRef[Author]',
#     through => 'BookAuthor',
#     traits  => ['Gideon::RelationShip']
# );

__PACKAGE__->meta->store("test:book");
__PACKAGE__->meta->make_immutable;
1;
