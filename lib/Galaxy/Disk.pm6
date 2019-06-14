use DB::SQLite;
unit class Galaxy::Disk;

has $!disk;

submethod BUILD ( IO :$disk ) {

  $!disk  = DB::SQLite.new: filename => $disk.Str;

  self!init-disk;

}

method !select-star ( $name, $age?, $core?, $form?, $tag? ) {

  my %star;

  %star.push: ( name => $name );
  %star.push: ( age  => $age )      if $age;
  %star.push: ( core => $core )     if $core;
  %star.push: ( form => $form.Int ) if $form;
  %star.push: ( tag  => $tag )      if $tag;


  my @star = $!disk.query( 'select * from star where name = $name', :$name).hashes
    .grep( * ≅ %star )
    .map({ .push: ( planet  => self!select-planet:  .<star> ) })
    .map({ .push: ( cluster => self!select-cluster: .<star> ) })
    .map({ .push: ( law     => self!select-law:     .<star> ) })
    .map({ .push: ( env     => self!select-env:     .<star> ) });

  @star;
}


method all-stars ( ) {

  my @star = $!disk.query( 'select * from star' ).hashes
    .map({ .push: ( planet  => self!select-planet: .<star> ) })
    .map({ .push: ( cluster => self!select-cluster: .<star> ) })
    .map({ .push: ( law     => self!select-law:     .<star> ) })
    .map({ .push: ( env     => self!select-env:     .<star> ) }) ;

  @star;
}


method !select-planet ( Str:D $star ) {

  $!disk.query( 'select path, type, size, perm, mode from planet where star = $star', $star).hashes;

}

method !select-cluster ( Str:D $star ) {

  $!disk.query( 'select name, age, core, form, tag from cluster where star = $star', $star).hashes;

}

method !select-law ( Str:D $star ) {

  $!disk.query( 'select law from law where star = $star', $star).arrays.flat;

}

method !select-env ( Str:D $star ) {

  $!disk.query( 'select env from env where star = $star', $star).arrays.flat;

}

method add-star (

  Str:D :$star!,
  Str:D :$name!,
  Str:D :$age!,
  Str:D :$core!,
  Int:D :$form!,
  Str:D :$tag!,
  Str:D :$origin!,
  Str:D :$source!,
  Str   :$desc,
  Str   :$location,
        :@planet,
        :@cluster,
        :@law,
        :@env,

) {

  $!disk.query(
    'insert into star ( star, name, age, core, form, tag, origin, source, desc, location )
      values ( $star, $name, $age, $core, $form, $tag, $origin, $source, $desc, $location )',
      :$star, :$name, :$age, :$core, :$form, :$tag, :$origin, :$source, :$desc, :$location
  );

    $!disk.query(
      'insert into planet ( path, type, size, perm, mode, star )
        values ( $path, $type, $size, $perm, $mode, $star )',
        |$_, :$star
    ) for @planet;


    $!disk.query(
      'insert into cluster ( star, name, age, core, form, tag )
        values ( $star, $name, $age, $core, $form, $tag )',
        |$_, :$star
    ) for @cluster;


  $!disk.query( 'insert into law ( star, law ) values ( $star, $law )', law => $_, :$star) for @law;

  $!disk.query( 'insert into env ( star, env ) values ( $star, $env )', env => $_, :$star) for @env;

}

method remove-star ( Str:D :$star! ) {

  $!disk.query( 'delete from star    where star = $star', $star);
  $!disk.query( 'delete from planet  where star = $star', $star);
  $!disk.query( 'delete from cluster where star = $star', $star);
  $!disk.query( 'delete from env     where star = $star', $star);
  $!disk.query( 'delete from law     where star = $star', $star);

}

method clean (  ) {

  $!disk.query( 'delete from star'    );
  $!disk.query( 'delete from planet'  );
  $!disk.query( 'delete from cluster' );
  $!disk.query( 'delete from env'     );
  $!disk.query( 'delete from law'     );

}

method !init-disk ( ) {
  $!disk.execute: q:to /SQL/;
    PRAGMA foreign_keys = ON
    SQL

  $!disk.execute: q:to /SQL/;
    create table if not exists star (
      star     text primary key not null,
      name     text,
      age      text,
      core     text,
      form     int,
      tag      text,
      origin   text,
      source   text,
      desc     text,
      location text,
      chksum   text
    )
    SQL

  $!disk.execute: q:to /SQL/;
    create table if not exists planet (
      path  text,
      type  int,
      size  int,
      perm  int,
      mode  int,
      star  text references star(star) ON DELETE CASCADE
    )
    SQL

  $!disk.execute: q:to /SQL/;
    create table if not exists cluster (
      name text,
      age  text,
      core text,
      form int,
      tag  text,
      star text references star(star) ON DELETE CASCADE
    )
    SQL

  $!disk.execute: q:to /SQL/;
    create table if not exists law (
      law  text,
      star text references star(star) ON DELETE CASCADE
    )
    SQL

  $!disk.execute: q:to /SQL/;
    create table if not exists env (
      env  text,
      star text references star(star) ON DELETE CASCADE

    )
    SQL

}

