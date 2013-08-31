{

    package Gideon::Exception;
    use Moose;
    with 'Throwable';
    __PACKAGE__->meta->make_immutable;
}

{

    package Gideon::Exception::ObjectNotInStore;
    use Moose;
    with 'Throwable';
    __PACKAGE__->meta->make_immutable;
}

{

    package Gideon::Exception::NotFound;
    use Moose;
    with 'Throwable';
    __PACKAGE__->meta->make_immutable;
}

{

    package Gideon::Exception::SaveFailure;
    use Moose;
    with 'Throwable';
    __PACKAGE__->meta->make_immutable;
}

{

    package Gideon::Exception::UpdateFailure;
    use Moose;
    with 'Throwable';
    __PACKAGE__->meta->make_immutable;
}

{

    package Gideon::Exception::RemoveFailure;
    use Moose;
    with 'Throwable';
    __PACKAGE__->meta->make_immutable;
}

{

    package Gideon::Exception::InvalidOperation;
    use Moose;
    with 'Throwable';
    __PACKAGE__->meta->make_immutable;
}


1;
