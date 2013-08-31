package Author;
use Gideon driver => 'DBI';
use DateTime;

has id => (
    is          => 'rw',
    isa         => 'Int',
    serial      => 1,
    primary_key => 1,
    traits      => ['Gideon::DBI::Column']
);

has name => (
    is     => 'rw',
    isa    => 'Str',
    traits => ['Gideon::DBI::Column']
);

has created_at => (
    is      => 'rw',
    isa     => 'DateTime',
    default => sub { DateTime->now },
    traits => [ 'Gideon::DBI::Column', 'Gideon::DBI::Inflate::DateTime' ],
);

# has books => (
#     is      => 'rw',
#     isa     => 'ArrayRef[Book]',
#     through => 'BookAuthor',
#     traits  => ['Gideon::Relationship']
# );

__PACKAGE__->meta->store("test:author");
__PACKAGE__->meta->make_immutable;
1;
