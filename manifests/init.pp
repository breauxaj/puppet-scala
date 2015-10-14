class scala (
  $version = '2.11.7',
  $source = 'http://downloads.typesafe.com/scala'
){
  exec { 'get-scala':
    path    => '/bin:/usr/bin',
    command => "wget ${source}/${version}/scala-${version}.tgz",
    cwd     => '/tmp',
    creates => "/tmp/scala-${version}.tgz",
    timeout => 10000,
    onlyif  => "test ! -d /usr/local/scala-${version}",
  }

  exec { 'untar-scala':
    path    => '/bin:/usr/bin',
    command => "tar -zxf /tmp/scala-${version}.tgz",
    cwd     => '/usr/local',
    creates => "/usr/local/scala-${version}",
    timeout => 10000,
    require => Exec['get-scala'],
  }

  file { "/usr/local/scala-${version}":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    recurse => true,
    require => Exec['untar-scala'],
  }

  file { '/usr/local/scala':
    ensure  => 'link',
    owner   => 'root',
    group   => 'root',
    target  => "/usr/local/scala-${version}",
    require => Exec['untar-scala'],
  }

  file { '/etc/profile.d/scala.sh':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/scala/profile.txt',
  }

}
