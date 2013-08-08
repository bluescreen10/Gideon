use strict;
use warnings;

use Author;
use Book;

#TODO Register Gideon;

my $author1 = Author->new( name => 'Jack Vance')->save;
my $author2 = Author->new( name => 'Isaac Asimov')->save;

my $book1 = Book->new( name => 'Cugel the clever')->save;
my $book2 = Book->new( name => 'The Dying Earth')->save;

my $book3 = Book->new( name => 'The Naked Sun')->save;
my $book4 = Book->new( name => 'The Caves of Steel')->save;

my $book5 = Book->new( name => 'It\'d be awesome')->save;

BookAuthor->new( author_id => $author1->id, book_id => $book1->id );
BookAuthor->new( author_id => $author1->id, book_id => $book2->id );

BookAuthor->new( author_id => $author2->id, book_id => $book3->id );
BookAuthor->new( author_id => $author2->id, book_id => $book4->id );

BookAuthor->new( author_id => $author1->id, book_id => $book5->id );
BookAuthor->new( author_id => $author2->id, book_id => $book5->id );

my $jack_vance_books = Author->find_one( name => 'Jack Vance' )->books;
my $awesome_book_authors = Book->find_one( name => 'Awesome' )->authors;


