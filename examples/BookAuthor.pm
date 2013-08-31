package BookAuthor;
use Gideon driver => 'DBI';

has id => (
    is     => 'rw',
    isa    => 'Int',
    traits => ['Gideon::DBI::Column']
);

has author_id => (
    is     => 'rw',
    isa    => 'Int',
    traits => ['Gideon::DBI::Column']
);

has book_id => (
    is     => 'rw',
    isa    => 'Int',
    traits => ['Gideon::DBI::Column']
);

has created_at => (
    is      => 'rw',
    isa     => 'DateTime',
    default => sub { DateTime->now },
    traits  => ['Gideon::DBI::Column'],
);

__PACKAGE__->meta->store("test:book_author");
__PACKAGE__->meta->make_immutable;
1;
