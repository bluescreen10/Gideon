use strict;
use warnings;
use Author;
use Book;
use BookAuthor;
use DBI;
use CHI;
use Gideon::Registry;
use Getopt::Long;
use Time::HiRes qw(time);

use constant DSN      => 'DBI:mysql:database=gideon;host=127.0.0.1;port=3306';
use constant USERNAME => 'devel';
use constant PASSWORD => '123456';

my $create = 0;

GetOptions( "create" => \$create )
  or die "Invalid Argumetns\n";

my $cache = CHI->new( driver => 'Memory', global => 1 );
Gideon::Registry->register_cache($cache);

my $dbh = DBI->connect( DSN, USERNAME, PASSWORD, { RaiseError => 1 } );
Gideon::Registry->register_store( test => $dbh );

if ($create) {
    my $author1 = Author->new( name => 'Jack Vance' )->save;
    my $author2 = Author->new( name => 'Isaac Asimov' )->save;

    my $book1 = Book->new( name => 'Cugel the clever' )->save;
    my $book2 = Book->new( name => 'The Dying Earth' )->save;

    my $book3 = Book->new( name => 'The Naked Sun' )->save;
    my $book4 = Book->new( name => 'The Caves of Steel' )->save;

    my $book5 = Book->new( name => 'It\'d be awesome' )->save;

    BookAuthor->new( author_id => $author1->id, book_id => $book1->id )->save;
    BookAuthor->new( author_id => $author1->id, book_id => $book2->id )->save;

    BookAuthor->new( author_id => $author2->id, book_id => $book3->id )->save;
    BookAuthor->new( author_id => $author2->id, book_id => $book4->id )->save;

    BookAuthor->new( author_id => $author1->id, book_id => $book5->id )->save;
    BookAuthor->new( author_id => $author2->id, book_id => $book5->id )->save;
}

my $jack_vance = Author->find_one( name => 'Jack Vance' );
my $awesome_book = Book->find_one( name => { like => '%Awesome%' } );

print "Vance’s id:" . $jack_vance->id . "\n";
print "Awesome Book’s id:" . $awesome_book->id . "\n";

my $start = time();
my @jacks = Author->find( name => { like => 'Jack%' } );
print "ellapsed:" . ( time() - $start ) . "\n";

$start = time();
@jacks = Author->find( name => { like => 'Jack%' }, -cache_for => '20m' );
print "ellapsed:" . ( time() - $start ) . "\n";


$start = time();
@jacks = Author->find( name => { like => 'Jack%' }, -cache_for => '20m' );
print "ellapsed:" . ( time() - $start ) . "\n";

$start = time();
@jacks = Author->find( name => { like => 'Jack%' }, -cache_for => '20m' );
print "ellapsed:" . ( time() - $start ) . "\n";

print $_->name . "\n" for @jacks;

